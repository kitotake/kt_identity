
import React, { useState, useEffect } from 'react';
import { IdentityProvider, useIdentity } from '@contexts/IdentityContext';
import { CharacterList } from './components/CharacterList';
import { CreateCharacterForm } from '@components/CreateCharacterForm';
import { useNUI } from '@hooks/useNUI';
import type { CreateCharacterData } from './types/nui';

const IdentityMenu: React.FC = () => {
  const { 
    isVisible, 
    characters, 
    maxCharacters, 
    selectedCharacter, 
    setSelectedCharacter, 
    closeMenu 
  } = useIdentity();
  
  const { post } = useNUI();
  const [showCreateForm, setShowCreateForm] = useState(false);

  useEffect(() => {
    const handleEscape = (e: KeyboardEvent) => {
      if (e.key === 'Escape' && isVisible) {
        if (showCreateForm) {
          setShowCreateForm(false);
        } else {
          handleCloseMenu();
        }
      }
    };

    window.addEventListener('keydown', handleEscape);
    return () => window.removeEventListener('keydown', handleEscape);
  }, [isVisible, showCreateForm]);

  if (!isVisible) return null;

  const handleSelectCharacter = async () => {
    if (!selectedCharacter) return;
    
    await post('selectCharacter', { characterId: selectedCharacter.id });
    closeMenu();
  };

  const handleDeleteCharacter = async (character: typeof selectedCharacter) => {
    if (!character) return;
    
    const confirmed = window.confirm(
      `⚠️ Êtes-vous sûr de vouloir supprimer ${character.firstname} ${character.lastname} ?\n\nCette action est irréversible.`
    );
    
    if (confirmed) {
      await post('deleteCharacter', { characterId: character.id });
      
      if (selectedCharacter?.id === character.id) {
        setSelectedCharacter(null);
      }
    }
  };

  const handleCreateCharacter = async (data: CreateCharacterData) => {
    await post('createCharacter', data);
    setShowCreateForm(false);
  };

  const handleCloseMenu = async () => {
    await post('closeMenu');
    closeMenu();
  };

  const canCreateMore = characters.length < maxCharacters;

  return (
    <div className="identity-menu">
      <div className="identity-menu__container">
        {/* Header */}
        <div className="identity-menu__header">
          <div className="identity-menu__header-top">
            <h1 className="identity-menu__title">
              🎭 Gestion des Personnages
            </h1>
            <button
              onClick={handleCloseMenu}
              className="identity-menu__close"
              aria-label="Fermer le menu"
            >
              <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>
          <p className="identity-menu__subtitle">
            📊 {characters.length} / {maxCharacters} personnages créés
          </p>
        </div>

        {/* Content */}
        <div className="identity-menu__content">
          {showCreateForm ? (
            <div>
              <h2 className="identity-menu__form-title">
                ➕ Nouveau Personnage
              </h2>
              <CreateCharacterForm
                onSubmit={handleCreateCharacter}
                onCancel={() => setShowCreateForm(false)}
              />
            </div>
          ) : (
            <CharacterList
              characters={characters}
              selectedCharacter={selectedCharacter}
              onSelectCharacter={setSelectedCharacter}
              onDeleteCharacter={handleDeleteCharacter}
            />
          )}
        </div>

        {/* Footer */}
        {!showCreateForm && (
          <div className="identity-menu__footer">
            <button
              onClick={() => setShowCreateForm(true)}
              disabled={!canCreateMore}
              className="identity-menu__button identity-menu__button--create"
              title={canCreateMore ? 'Créer un nouveau personnage' : 'Limite de personnages atteinte'}
            >
              ➕ Créer un personnage
            </button>
            <button
              onClick={handleSelectCharacter}
              disabled={!selectedCharacter}
              className="identity-menu__button identity-menu__button--play"
              title={selectedCharacter ? 'Jouer avec ce personnage' : 'Sélectionnez un personnage'}
            >
              🎮 Jouer avec ce personnage
            </button>
          </div>
        )}
      </div>
    </div>
  );
};

function App() {
  return (
    <IdentityProvider>
      <IdentityMenu />
    </IdentityProvider>
  );
}

export default App;
