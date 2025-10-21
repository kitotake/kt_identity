import React, { createContext, useContext, useState, useCallback } from 'react';
import type { Character, OpenMenuData } from '../types/nui';
import { useNUIEvent } from '../hooks/useNUIEvent';

interface IdentityContextType {
  isVisible: boolean;
  characters: Character[];
  maxCharacters: number;
  availableNationalities: string[];
  selectedCharacter: Character | null;
  canCreateMore: boolean;
  setSelectedCharacter: (character: Character | null) => void;
  closeMenu: () => void;
}

const IdentityContext = createContext<IdentityContextType | undefined>(undefined);

export const IdentityProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [isVisible, setIsVisible] = useState(false);
  const [characters, setCharacters] = useState<Character[]>([]);
  const [maxCharacters, setMaxCharacters] = useState(5);
  const [availableNationalities, setAvailableNationalities] = useState<string[]>([]);
  const [canCreateMore, setCanCreateMore] = useState(true);
  const [selectedCharacter, setSelectedCharacter] = useState<Character | null>(null);

  useNUIEvent<OpenMenuData>('openMenu', useCallback((data) => {
    setCharacters(data.characters);
    setMaxCharacters(data.maxCharacters);
    setCanCreateMore(data.canCreateMore !== undefined ? data.canCreateMore : true);
    setAvailableNationalities(data.availableNationalities || [
      'Française',
      'Américaine',
      'Britannique',
      'Allemande',
      'Italienne',
      'Espagnole',
      'Portugaise',
      'Belge',
      'Suisse',
      'Canadienne',
      'Australienne',
      'Japonaise',
      'Chinoise',
      'Russe',
      'Brésilienne',
      'Mexicaine',
      'Argentine',
      'Marocaine',
      'Algérienne',
      'Tunisienne'
    ]);
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
        availableNationalities,
        selectedCharacter,
        canCreateMore,
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