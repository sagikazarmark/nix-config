{ pkgs, ... }:

{
  users.users.mark = {
    hashedPassword = "81fbf929a6196fae3564d34457b0f2f74345786f9fc3a762039f57e8d47f5f8a612e61a96f33ee165414de36e7ab0d2615667a7636ae5d598b5afb25ce87c0b4";
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "docker"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDVVvekpHx2crhmavA9GJDyWToQXMGt8Rb71M0TQTH7zu5I6tXJHXwWNUQ7O2ESrx92lopu9wSWWWHctYunTTOEPNQVAS4tc7zH30lwBF9sSNWoRTK46NoP1bS1LSy9b5lT2pfKUf6e6aTWowzvtHdViH25LgKPIkP0lL0zQdNjh2a+6/MwBUHnOJ7UJ+uNOgrKWMIN3VgKkzj1SQPluPjWo/xRVcWWktZd6E9iDPWbrOOx4YO/y2jqSzGetF+OR553Bkkq+bxvmGxPLnmVEqLZgYA4+z7gjceaz89Wdd6pDUaAg/2/XJSc//T3NHrmRV3W36r4SBjCKO0E0mIy8YCX76VFjgSjiIMAhUn2h0waMSYUYikhAxbStks5YeSg4uJwYdOd1PiBJml8TAiWIkiK1+I1D8OpSWjt6vzjJ+vtgGIasT69acRwLYwgsV4H/uJAZertomTSiU6XwBQ8aPFpeqFFEBNV3JEXbSnw7K1htGV0yt3clf5I3xbN2/AsmjLpbJ4avtA/SwSGcPaf1nU53rQsyj7/N0nXN1d7fStoMT2x0PFLj0w6yVMZHc5+LlEIUXg5HdSpzUv07pPRhlmqfKrEtqX+IwtA2eTZEZc84fhMnw18t53jY9sxRaIj74h39bXJlbJvK19rc2aTMqI8/pZqGMNZPVfIMS28XttbLQ=="
    ];
  };
}
