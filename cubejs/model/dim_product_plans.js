cube("DimProductPlans", {
  sql: `SELECT * FROM public.dim_product_plans`,
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
    plan_id: {
      sql: "plan_id",
      type: "number",
      primaryKey: true,
    },

    pricing_tier: {
      sql: "pricing_tier",
      type: "string",
    },

    features_included: {
      sql: "features_included",
      type: "string",
    },

    plan_name: {
      sql: "plan_name",
      type: "string",
    },

    billing_frequency: {
      sql: "billing_frequency",
      type: "string",
    },
  },

  preAggregations: {
    // Define pre-aggregations if needed
  },
});
