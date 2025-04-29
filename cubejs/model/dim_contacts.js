cube("DimContacts", {
  sql: `SELECT * FROM public.dim_contacts`,
  dataSource: "default",

  joins: {
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
    account_id: {
      sql: "account_id",
      type: "number",
      primaryKey: true,
    },

    first_name: {
      sql: "first_name",
      type: "string",
    },

    last_name: {
      sql: "last_name",
      type: "string",
    },

    full_name: {
      sql: `CONCAT(${CUBE}.first_name, ' ', ${CUBE}.last_name)`,
      type: "string",
    },

    email: {
      sql: "email",
      type: "string",
    },

    job_title: {
      sql: "job_title",
      type: "string",
    },

    contact_type: {
      sql: "contact_type",
      type: "string",
    },
  },

  preAggregations: {
    // Define pre-aggregations if needed
  },
});
