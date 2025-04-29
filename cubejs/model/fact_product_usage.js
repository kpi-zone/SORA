cube("FactSalesDeals", {
  sql: `SELECT * FROM public.fact_sales_deals`,
  dataSource: "default",

  joins: {
    DimSalesRep: {
      sql: `${CUBE}.sales_rep_id = ${DimSalesRep}.sales_rep_id`,
      relationship: "many_to_one",
    },
    DimAccounts: {
      sql: `${CUBE}.account_id = ${DimAccounts}.account_id`,
      relationship: "many_to_one",
    },
  },

  measures: {
    count: {
      type: "count",
    },
  },

  dimensions: {
    deal_id: {
      sql: "deal_id",
      type: "number",
      primaryKey: true,
    },

    deal_stage: {
      sql: "deal_stage",
      type: "string",
    },

    deal_value: {
      sql: "deal_value",
      type: "string", // Consider changing to `type: 'number'` if deal_value is numeric
    },

    created_date: {
      sql: "created_date",
      type: "time",
    },

    close_date: {
      sql: "close_date",
      type: "time",
    },
  },

  preAggregations: {
    // Define pre-aggregations if needed
  },
});
