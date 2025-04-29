cube("DimMarketingCampaign", {
  sql: `SELECT * FROM public.dim_marketing_campaign`,
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
    campaign_id: {
      sql: "campaign_id",
      type: "number",
      primaryKey: true,
    },

    campaign_name: {
      sql: "campaign_name",
      type: "string",
    },

    budget: {
      sql: "budget",
      type: "string",
    },

    target_audience: {
      sql: "target_audience",
      type: "string",
    },

    channel: {
      sql: "channel",
      type: "string",
    },

    end_date: {
      sql: "end_date",
      type: "time",
    },

    start_date: {
      sql: "start_date",
      type: "time",
    },
  },

  preAggregations: {
    // Define pre-aggregations if needed
  },
});
