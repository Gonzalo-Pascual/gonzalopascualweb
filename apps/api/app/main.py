from fastapi import FastAPI, status

from .models import ContactRequest, ContactResponse

app = FastAPI(title="API de gonzalopascual.es", version="0.1.0")


@app.get("/healthz")
def healthz():
    return {"status": "ok"}


@app.post(
    "/api/contact",
    response_model=ContactResponse,
    status_code=status.HTTP_201_CREATED,
)
def create_contact(payload: ContactRequest):
    return ContactResponse(status="received")
