cube("FactMarketingInteractions", {
  sql: `SELECT * FROM public.fact_marketing_interactions`,
  dataSource: "default",

  joins: {
    DimMarketingCampaign: {
      sql: `${CUBE}.campaign_id = ${DimMarketingCampaign}.campaign_id`,
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
    campaign_id: {
      sql: "campaign_id",
      type: "number",
      primaryKey: true,
    },

    engagement_score: {
      sql: "engagement_score",
      type: "string",
    },

    interaction_type: {
      sql: "interaction_type",
      type: "string",
    },

    interaction_date: {
      sql: "interaction_date",
      type: "time",
    },
  },

  preAggregations: {
    // Define pre-aggregations if needed
  },
});
