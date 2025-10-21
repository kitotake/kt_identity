import React from 'react';
import type { Character } from '../types/nui';
import { CharacterCard } from './CharacterCard';

interface CharacterListProps {
  characters: Character[];
  selectedCharacter: Character | null;
  onSelectCharacter: (character: Character) => void;
  onDeleteCharacter: (character: Character) => void;
}

export const CharacterList: React.FC<CharacterListProps> = ({
  characters,
  selectedCharacter,
  onSelectCharacter,
  onDeleteCharacter,
}) => {
  if (characters.length === 0) {
    return (
      <div className="character-list--empty">
        <p className="character-list--empty__title">Aucun personnage trouvé</p>
        <p className="character-list--empty__subtitle">
          Créez votre premier personnage pour commencer votre aventure
        </p>
      </div>
    );
  }

  return (
    <div className="character-list">
      {characters.map((character) => (
        <CharacterCard
          key={character.id}
          character={character}
          isSelected={selectedCharacter?.id === character.id}
          onSelect={() => onSelectCharacter(character)}
          onDelete={() => onDeleteCharacter(character)}
        />
      ))}
    </div>
  );
};
