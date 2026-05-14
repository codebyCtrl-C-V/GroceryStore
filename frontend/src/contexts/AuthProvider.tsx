import { useState, type ReactNode, createContext } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { toast } from 'react-toastify';
// import { getProfile } from '../services/apiUser';

interface AuthContextType {
  userInfor: any | undefined;
  fetchUserInfor: () => Promise<void>;
  login: (token: string, refresh_token: string, isToHome?: boolean) => Promise<void>;
  logout: () => Promise<void>;
}

const AuthContext = createContext<AuthContextType>({
  userInfor: undefined,
  fetchUserInfor: async () => {},
  login: async () => {},
  logout: async () => {}
});

interface AuthProviderProps {
  children: ReactNode;
}

export const AuthProvider = ({ children }: AuthProviderProps) => {
  const navigate = useNavigate();
  const location = useLocation();

  const [userInfor, setUserInfor] = useState<any>();

  const fetchUserInfor = async () => {
    try {
    //   const res = await getProfile();
    //   setUserInfor(res.profile);
    } catch (error) {
      console.error(error);
    }
  };

  const login = async (token: string, refresh_token: string, isToHome?: boolean) => {
    try {
      localStorage.setItem('refresh_token', refresh_token);
      localStorage.setItem('access_token', token);
      await fetchUserInfor();
      
      if (location.state?.from) {
        navigate(location.state.from);
      } else if (isToHome) {
        navigate('/');
      } else {
        navigate(-1);
      }
    } catch (error) {
      console.log(error);
      localStorage.removeItem('access_token');
      localStorage.removeItem('refresh_token');
      toast.error('Unexpected error occurred! Please try again.');
    }
  };

  const logout = async () => {
    localStorage.removeItem('access_token');
    localStorage.removeItem('refresh_token');
    setUserInfor(undefined);
    navigate('/signin');
  };

  return <AuthContext.Provider value={{ login, logout, userInfor, fetchUserInfor }}>{children}</AuthContext.Provider>;
};

export type { AuthContextType };
export default AuthContext;
