import React, { createContext, useContext, useState, useCallback } from 'react';
import type { Character, OpenMenuData } from '../types/nui';
import { useNUIEvent } from '../hooks/useNUIEvent';
import { mockOpenMenuData } from '../utils/mockData';

interface IdentityContextType {
  isVisible: boolean;
  characters: Character[];
  maxCharacters: number;
  selectedCharacter: Character | null;
  setSelectedCharacter: (character: Character | null) => void;
  closeMenu: () => void;
}

const IdentityContext = createContext<IdentityContextType | undefined>(undefined);

export const IdentityProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [isVisible, setIsVisible] = useState(import.meta.env.DEV);
  const [characters, setCharacters] = useState<Character[]>(
    import.meta.env.DEV ? mockOpenMenuData.characters : []
  );
  const [maxCharacters, setMaxCharacters] = useState(
    import.meta.env.DEV ? mockOpenMenuData.maxCharacters : 5
  );
  const [selectedCharacter, setSelectedCharacter] = useState<Character | null>(null);

  useNUIEvent<OpenMenuData>('openMenu', useCallback((data) => {
    setCharacters(data.characters);
    setMaxCharacters(data.maxCharacters);
    setIsVisible(true);
    setSelectedCharacter(null);
  }, []));

  useNUIEvent('closeMenu', useCallback(() => {
    setIsVisible(false);
    setSelectedCharacter(null);
  }, []));

  const closeMenu = useCallback(() => {
    setIsVisible(false);
    setSelectedCharacter(null);
  }, []);

  return (
    <IdentityContext.Provider
      value={{
        isVisible,
        characters,
        maxCharacters,
        selectedCharacter,
        setSelectedCharacter,
        closeMenu,
      }}
    >
      {children}
    </IdentityContext.Provider>
  );
};

export const useIdentity = () => {
  const context = useContext(IdentityContext);
  if (!context) {
    throw new Error('useIdentity must be used within IdentityProvider');
  }
  return context;
};