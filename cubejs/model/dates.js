// =====================
// cube: Dates
// =====================
cube(`Dates`, {
  sql: `SELECT * FROM dim_date`,
  public: false,
  measures: {
    count: {
      type: `count`,
    },
  },

  dimensions: {
    date: {
      sql: `date`,
      type: `time`,
      primaryKey: true,
    },
    year: {
      sql: `year`,
      type: `number`,
    },
    quarter: {
      sql: `quarter`,
      type: `string`,
    },
    yearmonth: {
      sql: `yearmonth`,
      type: `string`,
    },
    month: {
      sql: `month`,
      type: `string`,
    },
    dayofweek: {
      sql: `dayofweek`,
      type: `string`,
    },
    workingday: {
      sql: `workingday`,
      type: `boolean`,
    },
  },
});
