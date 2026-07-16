import { createAxios, uploadAxios } from "./axios";

// Standard JSON request axios instance
const getAxiosInstance = () => createAxios();

// Multipart/form-data request axios instance
const getUploadInstance = () => uploadAxios();

// Dashboard
export const getDashboard = async () => {
  const response = await getAxiosInstance().get("admin/dashboard");
  return response.data;
};

// Users management
export const getUsers = async (page = 1) => {
  const response = await getAxiosInstance().get(`admin/user?page=${page}`);
  return response.data;
};

export const searchUsers = async (q: string, page = 1) => {
  const response = await getAxiosInstance().get(`admin/user/search?q=${q}&page=${page}`);
  return response.data;
};

export const createUser = async (data: any) => {
  const response = await getAxiosInstance().post("admin/user", data);
  return response.data;
};

export const updateUser = async (data: any) => {
  const response = await getAxiosInstance().post("admin/user/update", data);
  return response.data;
};

export const deleteUser = async (id: number) => {
  const response = await getAxiosInstance().post("admin/user/delete", { id });
  return response.data;
};

// Products management
export const getProducts = async (page = 1) => {
  const response = await getAxiosInstance().get(`admin/product?page=${page}`);
  return response.data;
};

export const searchProducts = async (q: string, page = 1) => {
  const response = await getAxiosInstance().get(`admin/product/search?q=${q}&page=${page}`);
  return response.data;
};

export const createProduct = async (formData: FormData) => {
  const response = await getUploadInstance().post("admin/product", formData);
  return response.data;
};

export const updateProduct = async (formData: FormData) => {
  const response = await getUploadInstance().post("admin/product/update", formData);
  return response.data;
};

export const deleteProduct = async (id: number) => {
  const response = await getAxiosInstance().post("admin/product/delete", { id });
  return response.data;
};

// Orders management
export const getOrders = async (page = 1, status = "all") => {
  const response = await getAxiosInstance().get(`admin/orders?page=${page}&status=${status}`);
  return response.data;
};

export const getOrderDetail = async (id: number | string) => {
  const response = await getAxiosInstance().get(`admin/orders/detail/${id}`);
  return response.data;
};

export const updateOrderStatus = async (id: number | string, status: string) => {
  const response = await getAxiosInstance().post(`admin/orders/${id}/status`, { status });
  return response.data;
};

export const searchOrders = async (q: string) => {
  const response = await getAxiosInstance().get(`admin/orders/search?q=${q}`);
  return response.data;
};

export const getOrderStatistics = async () => {
  const response = await getAxiosInstance().get("admin/orders/statistics");
  return response.data;
};

// Payments management
export const getPayments = async (page = 1, status = "all") => {
  const response = await getAxiosInstance().get(`admin/payment?page=${page}&status=${status}`);
  return response.data;
};

export const updatePaymentStatus = async (id: number | string, status: string) => {
  const response = await getAxiosInstance().post(`admin/payment/${id}/status`, { status });
  return response.data;
};

export const searchPayment = async (q: string) => {
  const response = await getAxiosInstance().get(`admin/payment/search?q=${q}`);
  return response.data;
};

// Categories management
export const getCategories = async () => {
  const response = await getAxiosInstance().get("admin/categories");
  return response.data;
};

export const createCategory = async (name: string) => {
  const response = await getAxiosInstance().post("admin/categories", { name });
  return response.data;
};

export const updateCategory = async (id: number, name: string, slug: string) => {
  const response = await getAxiosInstance().post("admin/categories/update", { id, name, slug });
  return response.data;
};

export const deleteCategory = async (id: number) => {
  const response = await getAxiosInstance().post("admin/categories/delete", { id });
  return response.data;
};

// News management
export const getNews = async (page = 1) => {
  const response = await getAxiosInstance().get(`admin/news?page=${page}`);
  return response.data;
};

export const searchNews = async (q: string, page = 1) => {
  const response = await getAxiosInstance().get(`admin/news/search?q=${q}&page=${page}`);
  return response.data;
};

export const createNews = async (formData: FormData) => {
  const response = await getUploadInstance().post("admin/news", formData);
  return response.data;
};

export const updateNews = async (formData: FormData) => {
  const response = await getUploadInstance().post("admin/news/update", formData);
  return response.data;
};

export const deleteNews = async (id: number) => {
  const response = await getAxiosInstance().post("admin/news/delete", { id });
  return response.data;
};
