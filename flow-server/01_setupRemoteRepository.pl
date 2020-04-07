use strict;
use ElectricCommander;
use XML::XPath;
use Net::Domain qw(hostfqdn);
use Sys::Hostname;

# Turn off output buffering

$| = 1;

# The following variables will be substituted with the appropriate values by
# the installer.

$::gPlatform                        = 'Linux-x86';
$::gAgentPort                       = '7800';
$::gRepositoryPort                  = '8200';

sub invokeCommander($$;$) {
    my ($functionName, $functionArgsRef, $suppressError) = @_;
    print("Invoking function $functionName.\n");
    my @functionArgs = @{$functionArgsRef};
    my $xpath = $::gCommander->$functionName(@functionArgs);
    my $errMsg = $::gCommander->getError();
    if (defined($errMsg) && $errMsg =~ m{ExpiredSession|NoCredentials}) {
        $xpath = $::gCommander->$functionName(@functionArgs);
        $errMsg = $::gCommander->getError();
    }
    if (defined($errMsg) && $errMsg ne "") {
        if (defined($suppressError) && $suppressError ne "" && index($errMsg, $suppressError) >= 0) {
            return (1, $errMsg);
        } else {
            print($errMsg);
            exit 1;
        }
    } elsif ($functionName !~ m/(putFile|getFile)/) {
        $xpath = $xpath->findnodes('/responses/response')->get_node(0);
        return (0, $xpath);
    }
}

$::gCommander = new ElectricCommander;
$::gCommander->abortOnError(0);

my $error;
my $xpath;

# set plugins directory suitable for deployment in containers
invokeCommander("setProperty", ["/server/settings/pluginsDirectory", {value => "/opt/cbflow/plugins"}]);

my $repoHost = "flow-repository";

($error, $xpath) = invokeCommander("getRepository", ["default"], "NoSuchRepository");
if ($error) {
    my %args = (
        "description"    => "Default repository created during installation.",
        "url"            => "https://$repoHost:$::gRepositoryPort"
    );
    invokeCommander("createRepository", ["default", \%args]);
}

my $boundAgentHost = "flow-bound-agent";
my %boundAgentArgs = (
    "description"     => "Local resource created during installation.",
    "hostName"        => $boundAgentHost,
    "port"            => $::gAgentPort
);

($error, $xpath) = invokeCommander("getResource", ["local"], "NoSuchResource");
if ($error) {
    invokeCommander("createResource", ["local", \%boundAgentArgs]);
}else{
    invokeCommander("modifyResource", ["local", \%boundAgentArgs]);
}

($error, $xpath) = invokeCommander("getResource", ["default"], "NoSuchResource");
if ($error) {
    # If there's an agent installed and no pre-existing resource named
    # "default", create a resource pool named "default" and place the
    # local agent inside.
    ($error, $xpath) = invokeCommander("getResourcePool", ["default"], "NoSuchResourcePool");
    if ($error) {
        my %args = (
            "description"    => "Default resource pool containing local agent created during installation.",
            "resourceName"   => "local"
        );
        ($error, $xpath) = invokeCommander("createResourcePool", ["default", \%args]);
    }
}