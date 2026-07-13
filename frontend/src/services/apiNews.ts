import { createAxios } from "./axios";

const axiosInstance = createAxios();

export const getAllNews = async (page = 1) => {
  const response = await axiosInstance.get(`news?page=${page}`);
  return response.data;
};

export const getNewsDetail = async (slug: string) => {
  const response = await axiosInstance.get(`news/${slug}`);
  return response.data;
};
