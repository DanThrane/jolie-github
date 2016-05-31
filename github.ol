include "exec.iol"
include "json_utils.iol"
include "string_utils.iol"

include "advanced_http.iol"
include "github.iol"

execution { concurrent }

inputPort GitHub {
    Interfaces: GitHubIface
    Location: "local"
}

main
{
    [listRepositories(request)(response) {
        execute@AdvancedHttp({
            .url = "https://api.github.com/users/" + request.username + 
                "/repos",
            .method = "GET",
            .headers[0].field = "User-Agent", 
            .headers[0].value = "JPM"
        })(httpResponse);
        getJsonValue@JsonUtils(httpResponse.body)(response)
    }]

    [getRepository(request)(response) {
        execute@AdvancedHttp({
            .url = "https://api.github.com/repos/" + request.owner + "/" + 
                request.repository,
            .method = "GET",
            .headers[0].field = "User-Agent",
            .headers[0].value = "JPM"
        })(httpResponse);

        if (httpResponse.code == 200) {
            getJsonValue@JsonUtils(httpResponse.body)(response)
        }
    }]

    [authenticate(request)(response) {
        with (authRequest) {
            .url = "https://api.github.com/user";
            .method = "GET";
            .headers[0].field = "User-Agent";
            .headers[0].value = "JPM";
            .auth << request
        };

        execute@AdvancedHttp(authRequest)(authResponse);
        response = authResponse.code == 200
    }]

    [forkRepository(request)(response) {
        with (httpRequest) {
            .url = "https://api.github.com/repos/" + request.owner + "/" +
                request.repository + "/forks";
            .method = "POST";
            .auth << request.auth
        };
        execute@AdvancedHttp(httpRequest)(httpResponse);
        getJsonValue@JsonUtils(httpResponse.body)(response)
    }]

    [createPullRequest(request)(response) {
        with (prRequest) {
            .title = request.title;
            .head = request.username + ":" + request.branch;
            .base = request.base;
            .body = request.body
        };

        getJsonString@JsonUtils(prRequest)(body);

        with (httpRequest) {
            .url = "https://api.github.com/repos/" + request.owner + "/" + 
                request.repository + "/pulls";
            .method = "POST";
            .auth << request.auth;
            .headers[0].field = "Content-Type";
            .headers[0].value = "application/json";
            .requestBody = body
        };
        valueToPrettyString@StringUtils(httpRequest)(prettyReq);
        execute@AdvancedHttp(httpRequest)(httpResponse);
        getJsonValue@JsonUtils(httpResponse.body)(response)
    }]
}
