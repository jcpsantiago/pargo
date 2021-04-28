#' Get features for training
#'
#' @param con A feature connection as created by `connect_store()`.
#' @param date_from The startndate of the time window for training as a string.
#' @param date_to The end date of the time window for training as a string.
#' @param features A character vector of full feature names.
#' @param trigger_name A string with the name of the trigger, as defined in the feature's definition yaml.
#'
#' @return A data-frame.
#' @export
#'
#' @examples
#' \dontrun{
#' training_data <- get_features(
#'   con = pargo_con,
#'   date_from = "2020-01-01",
#'   date_to = "2021-01-01",
#'   features = c("avg_order_amount_per_debtor_uuid", "n_complete_orders_per_email"),
#'   trigger_name = "order_uuid" # as defined in the feature's yaml definition
#' )
#' }
get_features <- function(con, date_from, date_to, features, trigger_name) {

  if (!all(features %in% con$available_features)) {
    stop("Not all features are available in the feature store!")
  }

  feature_data <- glue::glue_sql(
    "SELECT
      trigger_key,
      trigger_created_at,
    	feature_fullname,
    	feature_value
    FROM
    	STORE.FEATURE_HISTORY
    WHERE
    	feature_fullname IN {features}
    	AND trigger_name = {trigger_name}
    	AND trigger_created_at BETWEEN {date_from} AND {date_to}
    ",
    .con = con$dbcon
  ) %>%
    janitor::clean_names(.)

  feature_data %>%
    janitor::clean_names(.) %>%
    tidyr::pivot_wider(
      id_cols = "trigger_key",
      names_from = "feature_name",
      values_from = "feature_value"
    ) %>%
    poorman::rename_with(
      function(x) trigger_name,
      trigger_key
    )
}
