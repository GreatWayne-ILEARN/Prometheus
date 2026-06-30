import React, { createContext, useContext, useEffect, useState } from "react";
import { useGetMe, setAuthTokenGetter, getGetMeQueryKey } from "@workspace/api-client-react";
import type { UserProfile } from "@workspace/api-client-react";

const TOKEN_KEY = "adspot_token";

export type AppRole = "reviewer" | "brand" | "admin" | "super_admin";

interface AuthContextType {
  user: UserProfile | null;
  isLoading: boolean;
  login: (token: string) => void;
  logout: () => void;
  hasRole: (...roles: AppRole[]) => boolean;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

setAuthTokenGetter(() => localStorage.getItem(TOKEN_KEY));

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [token, setTokenState] = useState<string | null>(() => localStorage.getItem(TOKEN_KEY));

  const { data: user, isLoading: isUserLoading, error } = useGetMe({
    query: {
      enabled: !!token,
      retry: false,
      queryKey: getGetMeQueryKey(),
    },
  });

  const hasRole = (...roles: AppRole[]) => {
    if (!user) return false;
    return roles.includes(user.role as AppRole);
  };

  const login = (newToken: string) => {
    localStorage.setItem(TOKEN_KEY, newToken);
    setTokenState(newToken);
  };

  const logout = () => {
    localStorage.removeItem(TOKEN_KEY);
    setTokenState(null);
    window.location.href = "/";
  };

  useEffect(() => {
    if (error) {
      logout();
    }
  }, [error]);

  return (
    <AuthContext.Provider
      value={{
        user: user ?? null,
        isLoading: !!token && isUserLoading,
        login,
        logout,
        hasRole,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error("useAuth must be used within an AuthProvider");
  }
  return context;
}
