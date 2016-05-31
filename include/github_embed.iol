include "github.iol"

outputPort GitHub {
    Interfaces: GitHubIface
}

embedded {
    Jolie:
        "github.ol" in GitHub
}
