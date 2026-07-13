import { createAxios } from "./axios";

const axiosInstance = createAxios();

export const getAllCategories = async () => {
  const response = await axiosInstance.get("category");
  return response.data;
};

export const getCategoryProducts = async (slug: string, sort = "default", page = 1) => {
  const response = await axiosInstance.get(`category/${slug}?sort=${sort}&page=${page}`);
  return response.data;
};

export const getSaleVegetablesFruits = async (page = 1) => {
  const response = await axiosInstance.get(`category/sale/vegetables-fruits?page=${page}`);
  return response.data;
};

export const getSaleProcessed = async (page = 1) => {
  const response = await axiosInstance.get(`category/sale/proceed?page=${page}`);
  return response.data;
};

export const searchProducts = async (q: string, sort = "default", page = 1) => {
  const response = await axiosInstance.get(`product/search?q=${q}&sort=${sort}&page=${page}`);
  return response.data;
};
