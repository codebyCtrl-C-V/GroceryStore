import { createAxios } from "./axios";

const axiosInstance = createAxios();

export const getCart = async () => {
  const response = await axiosInstance.get("cart");
  return response.data;
};

export const addToCart = async (productId: number | string, quantity: number) => {
  const response = await axiosInstance.post("cart/add", { productId, quantity });
  return response.data;
};

export const updateCartItem = async (id: number | string, quantity: number) => {
  const response = await axiosInstance.post(`cart/update/${id}`, { id, quantity });
  return response.data;
};

export const deleteCartItem = async (id: number | string) => {
  const response = await axiosInstance.post(`cart/delete/${id}`);
  return response.data;
};
