#! /usr/bin/bash

# Building AI Agents with ADK:The Foundation
# https://codelabs.developers.google.com/devsite/codelabs/build-agents-with-adk-foundation#0

# Building AI Agents with ADK: Empowering with Tools
# https://codelabs.developers.google.com/devsite/codelabs/build-agents-with-adk-empowering-with-tools#0

# gcloud auth application-default login

gcloud config set project mcp-server

gcloud services enable aiplatform.googleapis.com

uv venv --python 3.12
source .venv/Scripts/activate
uv pip install google-adk

adk create personal_assistant

gemini-2.5-flash
Vertex AI (option 2)
mcp-server
us-central1

adk run personal_assistant
hello. What can you do for me?

adk web

uv pip install langchain-community wikipedia

adk web
Tell me about the history of Kyoto

# gcloud services disable aiplatform.googleapis.com

export PROJECT_ID=$(gcloud config get-value project)
echo "$PROJECT_ID"

# export PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')
# echo "$PROJECT_NUMBER"

export SA_NAME=ai-agents-adk
export SERVICE_ACCOUNT="${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"
gcloud iam service-accounts create ${SA_NAME} \
    --display-name="Service Account for ai-agents-adk"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT" \
  --role="roles/run.invoker"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT" \
  --role="roles/aiplatform.user"

adk deploy cloud_run \
  --project=$PROJECT_ID \
  --region=us-central1 \
  --service_name=ai-agents-adk \
  --with_ui \
  personal_assistant \
  -- \
  --labels=dev-tutorial=codelab-adk \
  --service-account=$SERVICE_ACCOUNT


export APP_URL="https://ai-agents-adk-281483222353.us-central1.run.app"

# export TOKEN=$(gcloud auth print-identity-token)
# curl -X GET -H "Authorization: Bearer $TOKEN" $APP_URL/list-apps

curl -X GET $APP_URL/list-apps

curl -X POST \
    $APP_URL/apps/personal_assistant/users/user_123/sessions/session_abc \
    -H "Content-Type: application/json" \
    -d '{"preferred_language": "English", "visit_count": 5}'

curl -X POST \
    $APP_URL/run_sse \
    -H "Content-Type: application/json" \
    -d '{
    "app_name": "personal_assistant",
    "user_id": "user_123",
    "session_id": "session_abc",
    "new_message": {
        "role": "user",
        "parts": [{
        "text": "What is the capital of Canada?"
        }]
    },
    "streaming": true
    }'
