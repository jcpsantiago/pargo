
# pargo 🐟🧪

<!-- badges: start -->
<!-- badges: end -->

The goal of pargo is to fetch features from a feature store.

## Example

``` r
library(pargo)

# connects to offline store, caches available features
pargo_con <- connect_store(
  user = Sys.getenv("FEATURE_STORE_USER"),
  pwd = Sys.getenv("FEATURE_STORE_PASSWORD"),
  host = Sys.getenv("FEATURE_STORE_HOST")
)

# collects features into a single data-frame
training_data <- get_features(
  con = pargo_con,
  date_from = "2020-01-01",
  date_to = "2021-01-01",
  features = c("avg_order_amount_per_debtor_uuid", "n_complete_orders_per_email"),
  trigger_name = "order_uuid" # as defined in the feature's yaml definition
)
```

