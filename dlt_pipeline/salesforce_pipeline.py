"""dlt ingestion pipeline: Salesforce -> DuckDB bronze. (Fixture for the dlt e2e.)"""
import dlt
from dlt.sources.helpers import requests

@dlt.source
def salesforce(api_token=dlt.secrets.value):
    @dlt.resource(write_disposition="merge", primary_key="id")
    def opportunity():
        # Auth header built from the configured token; a rotated/expired token
        # surfaces as HTTP 401 at extract time (see the incident).
        headers = {"Authorization": f"Bearer {api_token}"}
        resp = requests.get("https://example.my.salesforce.com/services/data/v59.0/query",
                            headers=headers, params={"q": "SELECT Id, Amount, StageName FROM Opportunity"})
        resp.raise_for_status()
        yield resp.json()["records"]
    return opportunity

if __name__ == "__main__":
    pipe = dlt.pipeline(pipeline_name="salesforce", destination="duckdb", dataset_name="src_salesforce")
    pipe.run(salesforce())
