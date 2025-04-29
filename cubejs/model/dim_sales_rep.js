cube("DimSalesRep", {
  sql: `SELECT * FROM public.dim_sales_rep`,
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
    sales_rep_id: {
      sql: "sales_rep_id",
      type: "number",
      primaryKey: true,
    },

    role: {
      sql: "role",
      type: "string",
    },

    territory: {
      sql: "territory",
      type: "string",
    },

    sales_rep_name: {
      sql: "sales_rep_name",
      type: "string",
    },
  },

  preAggregations: {
    // Define pre-aggregations if needed
  },
});
