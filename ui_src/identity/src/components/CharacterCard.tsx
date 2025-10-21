import React from 'react';
import { Character } from '../types/nui';

interface CharacterCardProps {
  character: Character;
  isSelected: boolean;
  onSelect: () => void;
  onDelete: () => void;
}

export const CharacterCard: React.FC<CharacterCardProps> = ({
  character,
  isSelected,
  onSelect,
  onDelete,
}) => {
  const age = calculateAge(character.dateofbirth);

  return (
    <div
      className={`character-card ${isSelected ? 'character-card--selected' : ''}`}
      onClick={onSelect}
    >
      <div className="character-card__content">
        <div className="character-card__info">
          <h3 className="character-card__name">
            {character.firstname} {character.lastname}
          </h3>
          <div className="character-card__details">
            <p>👤 Âge: {age} ans</p>
            <p>⚧️ Sexe: {character.gender === 'male' ? 'Homme' : 'Femme'}</p>
            <p>📏 Taille: {character.height} cm</p>
          </div>
        </div>
        
        <button
          onClick={(e) => {
            e.stopPropagation();
            onDelete();
          }}
          className="character-card__delete"
          title="Supprimer"
          aria-label="Supprimer le personnage"
        >
          <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>
      </div>
    </div>
  );
};

function calculateAge(dateofbirth: string): number {
  const birth = new Date(dateofbirth);
  const today = new Date();
  let age = today.getFullYear() - birth.getFullYear();
  const monthDiff = today.getMonth() - birth.getMonth();
  
  if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birth.getDate())) {
    age--;
  }
  
  return age;
}