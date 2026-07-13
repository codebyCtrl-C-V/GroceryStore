import { createAxios } from "./axios";

const axiosInstance = createAxios();

export const getCheckout = async () => {
  const response = await axiosInstance.get("checkout");
  return response.data;
};

export const submitOrder = async (data: { name: string; phone: string; address: string; paymentMethod: string }) => {
  const response = await axiosInstance.post("checkout/submit", data);
  return response.data;
};

export const getOrders = async () => {
  const response = await axiosInstance.get("orders");
  return response.data;
};

export const cancelOrder = async (id: number | string) => {
  const response = await axiosInstance.post(`orders/${id}/cancel`);
  return response.data;
};

export const createPaymentUrl = async (amount: number, orderInfo: string, name: string, phone: string, address: string) => {
  const response = await axiosInstance.post("payment/create_payment_url", {
    amount,
    orderInfo,
    customerName: name,
    customerPhone: phone,
    customerAddress: address
  });
  return response.data;
};

export const handleVnpayReturn = async (queryParams: string) => {
  const response = await axiosInstance.get(`payment/vnpay_return${queryParams}`);
  return response.data;
};
