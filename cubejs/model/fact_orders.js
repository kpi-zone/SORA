cube("FactOrders", {
  sql: `SELECT * FROM public.fact_orders`,
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
    DimProductPlans: {
      sql: `${CUBE}.plan_id = ${DimProductPlans}.plan_id`,
      relationship: "many_to_one",
    },
  },

  measures: {
    count: {
      type: "count",
    },

    totalOrderAmount: {
      sql: "order_amount",
      type: "sum",
      format: "currency",
    },

    totalDiscountAmount: {
      sql: "discounts",
      type: "sum",
      format: "currency",
    },

    totalNetOrderAmount: {
      sql: `${CUBE}.order_amount - ${CUBE}.discounts`,
      type: "sum",
      format: "currency",
    },

    ...(() => {
      const statuses = ["Active", "Pending", "Inactive"];
      const measures = {};

      statuses.forEach((status) => {
        const key = status.toLowerCase();

        // 1. Total Order Amount
        measures[`totalOrderAmount_${key}`] = {
          sql: () => `order_amount`,
          type: "sum",
          format: "currency",
          filters: [
            {
              sql: (CUBE) =>
                `${CUBE}.renewal_status = '${status.replace(/'/g, "''")}'`,
            },
          ],
        };

        // 2. Orders Count
        measures[`orders_count_${key}`] = {
          sql: () => `order_id`,
          type: "count",
          filters: [
            {
              sql: (CUBE) =>
                `${CUBE}.renewal_status = '${status.replace(/'/g, "''")}'`,
            },
          ],
        };

        // 3. Orders Percentage
        measures[`orders_percentage_${key}`] = {
          sql: () => `100.0 * ${`orders_count_${key}`} / ${CUBE}.count`,
          type: "number",
          format: "percent",
        };
      });

      return measures;
    })(),
  },

  dimensions: {
    order_id: {
      sql: "order_id",
      type: "number",
      primaryKey: true,
    },

    net_order_amount: {
      sql: `${CUBE}.order_amount - ${CUBE}.discounts`,
      type: "number",
      format: "currency",
    },

    discounts: {
      sql: "discounts",
      type: "number",
      format: "currency",
    },

    order_amount: {
      sql: "order_amount",
      type: "number",
      format: "currency",
    },

    renewal_status: {
      sql: "renewal_status",
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

    order_date: {
      sql: "order_date",
      type: "time",
    },
  },

  preAggregations: {
    // Define pre-aggregations if needed
  },
});
