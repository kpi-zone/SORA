cube("DimTime", {
  sql: `SELECT * FROM public.dim_time`,
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
    date_key: {
      sql: "date_key",
      type: "time",
    },
  },

  preAggregations: {
    // Define pre-aggregations if needed
  },
});
