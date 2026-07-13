import { useEffect, useState } from 'react';
import AppRouter from './routers/AppRouter';
import { useNavigate } from 'react-router-dom';
import useAuth from './hooks/useAuth';
import { refreshToken } from './services/apiUser';

function App() {
  const { fetchUserInfor } = useAuth();
  const navigate = useNavigate();
  const [ready, setReady] = useState(false);

  useEffect(() => {
    const initAuth = async () => {
      const access_token = localStorage.getItem('access_token');
      const refresh_token = localStorage.getItem('refresh_token');

      if (!access_token || !refresh_token) {
        setReady(true);
        return;
      }

      try {
        const res = await refreshToken();
        if (res && res.status === "success" && res.data?.accessToken) {
          localStorage.setItem('access_token', res.data.accessToken);
        }

        await fetchUserInfor();
        setReady(true);
      } catch (err) {
        console.error(err);
        localStorage.removeItem('access_token');
        localStorage.removeItem('refresh_token');
        navigate('/login');
      }
    };

    initAuth();

    // const intervalId = setInterval(refreshToken, 300000); // 5 phút
    // return () => {
    //   clearInterval(intervalId);
    // };
  }, []);

  return ready ? <AppRouter /> : null;
}

export default App;
