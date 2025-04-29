cube("DimAccounts", {
  sql: `SELECT * FROM public.dim_accounts`,
  dataSource: "default",

  joins: {
    // No joins defined
  },

  measures: {
    count: {
      type: "count",
    },
  },

  dimensions: {
    account_id: {
      sql: "account_id",
      type: "number",
      primaryKey: true,
    },

    account_name: {
      sql: "account_name",
      type: "string",
    },

    industry: {
      sql: "industry",
      type: "string",
    },

    company_size: {
      sql: "company_size",
      type: "string",
    },

    geography: {
      sql: "geography",
      type: "string",
    },

    customer_segment: {
      sql: "customer_segment",
      type: "string",
    },
  },

  preAggregations: {
    // Define pre-aggregations if needed
  },
});
