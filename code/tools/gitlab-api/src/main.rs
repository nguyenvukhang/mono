use reqwest::header::{self, HeaderMap, HeaderValue};
use reqwest::{Client, ClientBuilder};
use serde_json::{Value, json};

/// The personal access token from GitLab.
const PAT: &str = "glpat-***";

macro_rules! gitlab {
    ($($e:expr),* $(,)?) => {
        concat!("https://gitlab.com/api/v4", $($e)*)
    };
}

#[allow(unused)]
async fn get_all_projects(c: &Client) -> Vec<Value> {
    let api = gitlab!("/projects?owned=true&per_page=50");
    let url = |v| format!("{api}&page={v}");
    // Send off the first pageless request.
    let response = c.get(url(1)).send().await.unwrap();
    let Some(total_pages) = response.headers().get("x-total-pages") else {
        return response.json().await.unwrap();
    };
    let total_pages: usize = total_pages.to_str().unwrap().parse().unwrap();
    let mut projects: Vec<Value> = response.json().await.unwrap();

    for page in 2..=total_pages {
        let response = c.get(url(page)).send().await.unwrap();
        let buf: Vec<Value> = response.json().await.unwrap();
        projects.extend(buf);
    }
    projects
}

fn repository_template() -> Value {
    json!({
        "service_desk_enabled": false,
        "auto_devops_enabled": false,
        "emails_enabled": false,
        "group_runners_enabled": false,
        "lfs_enabled": false,
        "merge_pipelines_enabled": false,
        "public_jobs": false,
        "request_access_enabled": false,
        "warn_about_potentially_unwanted_characters": false,

        "package_registry_access_level": "disabled",
        "wiki_access_level": "disabled",
        "analytics_access_level": "disabled",
        "builds_access_level": "disabled",
        "container_registry_access_level": "disabled",
        "environments_access_level": "disabled",
        "feature_flags_access_level": "disabled",
        "forking_access_level": "disabled",
        "infrastructure_access_level": "disabled",
        "model_experiments_access_level": "disabled",
        "model_registry_access_level": "disabled",
        "monitor_access_level": "disabled",
        "pages_access_level": "disabled",
        "requirements_access_level": "disabled",
        "security_and_compliance_access_level": "disabled",
        "snippets_access_level": "disabled",
    })
}

async fn use_template(c: &Client, repo_id: &str) {
    let url = gitlab!("/projects");
    let url = format!("{url}/{repo_id}");

    let response = c.put(url).json(&repository_template()).send().await.unwrap();
    let _ = response.text().await.unwrap();
}

#[tokio::main]
async fn main() {
    let mut headers = HeaderMap::new();
    let mut token = HeaderValue::from_static(PAT);
    token.set_sensitive(true);
    headers.insert("PRIVATE-TOKEN", token);
    headers.insert(header::CONTENT_TYPE, HeaderValue::from_static("application/json"));
    let client = ClientBuilder::new().default_headers(headers).build().unwrap();

    use_template(&client, "78196162").await;

    // for project in get_all_projects(&client).await {
    //     let project_id = project["id"].as_u64().unwrap();
    //     println!("{project_id}");
    //     let project_id = format!("{project_id}");
    //     use_template(&client, &project_id).await;
    // }
}
