// =====================
// cube: Customers
// =====================
cube(`Customers`, {
  sql: `SELECT * FROM customer`,
  public: false,

  measures: {
    count: {
      type: `count`,
      drillMembers: [
        surname,
        gender,
        country,
        city,
        state,
        company,
        age,
        occupation,
        continent,
      ],
    },
    avgCustomerAge: {
      sql: `age`,
      type: `avg`,
    },
  },

  dimensions: {
    customerkey: {
      sql: `customerkey`,
      type: `number`,
      primaryKey: true,
    },
    surname: {
      sql: `surname`,
      type: `string`,
    },
    gender: {
      sql: `gender`,
      type: `string`,
    },
    continent: {
      sql: `continent`,
      type: `string`,
    },
    country: {
      sql: `country`,
      type: `string`,
    },
    city: {
      sql: `city`,
      type: `string`,
    },
    state: {
      sql: `state`,
      type: `string`,
    },
    company: {
      sql: `company`,
      type: `string`,
    },
    vehicle: {
      sql: `vehicle`,
      type: `string`,
    },
    age: {
      sql: `age`,
      type: `number`,
    },
    birthday: {
      sql: `birthday`,
      type: `time`,
    },
    occupation: {
      sql: `occupation`,
      type: `string`,
    },
    latitude: {
      sql: `latitude`,
      type: `number`,
    },
    longitude: {
      sql: `longitude`,
      type: `number`,
    },
  },
});
