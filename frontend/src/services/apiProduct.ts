import { createAxios, uploadAxios } from "./axios";

const axiosInstance = createAxios();

export const getProductForHome = async () => {
  try {
    const response = await axiosInstance.get(`product/for_home`);
    return response?.data;
  } catch (error) {
    console.log(error);
    throw error;
  }
};

export const getProductNew = async () => {
  try {
    const response = await axiosInstance.get(`product/new`);
    return response?.data;
  } catch (error) {
    console.log(error);
    throw error;
  }
};

export const getProductBySlug = async (slug: string) => {
  try {
    const response = await axiosInstance.get(`product/${slug}`);
    return response?.data;
  } catch (error) {
    console.log(error);
    throw error;
  }
};

export const uploadAvatar = async (file: File) => {
  try {
    const formData = new FormData();
    formData.append("avatar", file);
    const axiosInstance = uploadAxios();
    const response = await axiosInstance.post(`user/upload_avatar`, formData);
    return response.data;
  } catch (error) {
    console.error("Error uploading file:", error);
    throw error;
  }
};
