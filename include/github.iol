type GitHubRepository: undefined

type GitHubRepositoryList:void {
  ._[0,*]: GitHubRepository
}

type GitHubAuth: void {
  .username: string
  .password: string
}

type ForkRequest: void {
    .auth: GitHubAuth
    .owner: string
    .repository: string
}

type RepositoryRequest: void {
  .owner: string
  .repository: string
}

type PRRequest: void {
  .title: string
  .username: string
  .branch: string
  .base: string
  .body: string
  .owner: string
  .repository: string
  .auth: GitHubAuth
}

interface GitHubIface {
  RequestResponse:
    listRepositories(undefined)(GitHubRepositoryList),
    getRepository(RepositoryRequest)(GitHubRepository),
    authenticate(GitHubAuth)(bool),
    forkRepository(ForkRequest)(undefined),
    createPullRequest(PRRequest)(undefined)
}

