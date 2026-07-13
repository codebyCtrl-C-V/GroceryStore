import { createAxios } from "./axios";

const axiosInstance = createAxios();

export const loginUser = async (data: any) => {
  const response = await axiosInstance.post("login", data);
  return response.data;
};

export const registerUser = async (data: any) => {
  const response = await axiosInstance.post("register", data);
  return response.data;
};

export const logoutUser = async (refreshToken?: string) => {
  const response = await axiosInstance.post("logout", { refreshToken });
  return response.data;
};

export const getProfile = async () => {
  const response = await axiosInstance.get("profile");
  return response.data;
};

export const updateProfile = async (data: { name: string; phone?: string; address?: string }) => {
  const response = await axiosInstance.post("profile/update", data);
  return response.data;
};

export const changePassword = async (data: any) => {
  const response = await axiosInstance.post("profile/change-password", data);
  return response.data;
};

export const refreshToken = async () => {
  const rt = localStorage.getItem('refresh_token');
  if (!rt) return null;
  const response = await axiosInstance.post("login/refresh-token", { refreshToken: rt });
  return response.data;
};
