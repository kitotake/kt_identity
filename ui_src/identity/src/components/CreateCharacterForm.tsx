import React, { useState } from 'react';
import type { CreateCharacterData } from '../types/nui';
import { useIdentity } from '@contexts/IdentityContext';

interface CreateCharacterFormProps {
  onSubmit: (data: CreateCharacterData) => void;
  onCancel: () => void;
}

export const CreateCharacterForm: React.FC<CreateCharacterFormProps> = ({
  onSubmit,
  onCancel,
}) => {
  const { availableNationalities } = useIdentity();
  
  const [formData, setFormData] = useState<CreateCharacterData>({
    firstname: '',
    lastname: '',
    dateofbirth: '',
    gender: 'male',
    height: 175,
    nationality: availableNationalities[0] || 'Française',
    addictions: {
      cigarette: 0,
      alcohol: 0,
      drugs: 0,
    },
  });

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!formData.firstname.trim() || !formData.lastname.trim()) {
      alert('⚠️ Veuillez remplir tous les champs obligatoires');
      return;
    }

    if (!formData.dateofbirth) {
      alert('⚠️ Veuillez sélectionner une date de naissance');
      return;
    }

    onSubmit(formData);
  };

  const maxDate = new Date();
  maxDate.setFullYear(maxDate.getFullYear() - 18);

  const getAddictionLevel = (value: number): string => {
    if (value === 0) return 'Aucune';
    if (value <= 25) return 'Faible';
    if (value <= 50) return 'Modérée';
    if (value <= 75) return 'Élevée';
    return 'Très élevée';
  };

  const getAddictionColor = (value: number): string => {
    if (value === 0) return '#10b981';
    if (value <= 25) return '#3b82f6';
    if (value <= 50) return '#f59e0b';
    if (value <= 75) return '#f97316';
    return '#ef4444';
  };

  return (
    <form onSubmit={handleSubmit} className="create-form">
      {/* Informations de base */}
      <div className="create-form__section">
        <h3 className="create-form__section-title">👤 Informations personnelles</h3>
        
        <div className="create-form__row">
          <div className="create-form__group">
            <label className="create-form__label" htmlFor="firstname">
              Prénom *
            </label>
            <input
              id="firstname"
              type="text"
              value={formData.firstname}
              onChange={(e) => setFormData({ ...formData, firstname: e.target.value })}
              className="create-form__input"
              placeholder="Ex: John"
              required
              minLength={2}
              maxLength={50}
            />
          </div>

          <div className="create-form__group">
            <label className="create-form__label" htmlFor="lastname">
              Nom *
            </label>
            <input
              id="lastname"
              type="text"
              value={formData.lastname}
              onChange={(e) => setFormData({ ...formData, lastname: e.target.value })}
              className="create-form__input"
              placeholder="Ex: Doe"
              required
              minLength={2}
              maxLength={50}
            />
          </div>
        </div>

        <div className="create-form__row">
          <div className="create-form__group">
            <label className="create-form__label" htmlFor="dateofbirth">
              Date de naissance *
            </label>
            <input
              id="dateofbirth"
              type="date"
              value={formData.dateofbirth}
              onChange={(e) => setFormData({ ...formData, dateofbirth: e.target.value })}
              className="create-form__input"
              max={maxDate.toISOString().split('T')[0]}
              required
            />
          </div>

          <div className="create-form__group">
            <label className="create-form__label" htmlFor="gender">
              Sexe *
            </label>
            <select
              id="gender"
              value={formData.gender}
              onChange={(e) => setFormData({ ...formData, gender: e.target.value as 'male' | 'female' })}
              className="create-form__select"
            >
              <option value="male">👨 Homme</option>
              <option value="female">👩 Femme</option>
            </select>
          </div>
        </div>

        <div className="create-form__row">
          <div className="create-form__group">
            <label className="create-form__label" htmlFor="nationality">
              Nationalité *
            </label>
            <select
              id="nationality"
              value={formData.nationality}
              onChange={(e) => setFormData({ ...formData, nationality: e.target.value })}
              className="create-form__select"
            >
              {availableNationalities.map((nat) => (
                <option key={nat} value={nat}>
                  🌍 {nat}
                </option>
              ))}
            </select>
          </div>

          <div className="create-form__group">
            <label className="create-form__label" htmlFor="height">
              Taille: <strong>{formData.height} cm</strong>
            </label>
            <input
              id="height"
              type="range"
              min="150"
              max="190"
              step="1"
              value={formData.height}
              onChange={(e) => setFormData({ ...formData, height: parseInt(e.target.value) })}
              className="create-form__range"
            />
            <div className="create-form__range-labels">
              <span>150 cm</span>
              <span>{formData.height} cm</span>
              <span>190 cm</span>
            </div>
          </div>
        </div>
      </div>

      {/* Dépendances */}
      <div className="create-form__section">
        <h3 className="create-form__section-title">🚬 Dépendances</h3>
        <p className="create-form__section-description">
          Définissez le niveau de dépendance de votre personnage (optionnel)
        </p>

        {/* Cigarette */}
        <div className="create-form__group">
          <label className="create-form__label">
            🚬 Cigarette: 
            <strong style={{ color: getAddictionColor(formData.addictions.cigarette) }}>
              {' '}{getAddictionLevel(formData.addictions.cigarette)} ({formData.addictions.cigarette}%)
            </strong>
          </label>
          <input
            type="range"
            min="0"
            max="100"
            step="5"
            value={formData.addictions.cigarette}
            onChange={(e) => setFormData({
              ...formData,
              addictions: { ...formData.addictions, cigarette: parseInt(e.target.value) }
            })}
            className="create-form__range"
          />
          <div className="create-form__range-labels">
            <span>Aucune</span>
            <span>Modérée</span>
            <span>Élevée</span>
          </div>
        </div>

        {/* Alcool */}
        <div className="create-form__group">
          <label className="create-form__label">
            🍺 Alcool: 
            <strong style={{ color: getAddictionColor(formData.addictions.alcohol) }}>
              {' '}{getAddictionLevel(formData.addictions.alcohol)} ({formData.addictions.alcohol}%)
            </strong>
          </label>
          <input
            type="range"
            min="0"
            max="100"
            step="5"
            value={formData.addictions.alcohol}
            onChange={(e) => setFormData({
              ...formData,
              addictions: { ...formData.addictions, alcohol: parseInt(e.target.value) }
            })}
            className="create-form__range"
          />
          <div className="create-form__range-labels">
            <span>Aucune</span>
            <span>Modérée</span>
            <span>Élevée</span>
          </div>
        </div>

        {/* Drogue */}
        <div className="create-form__group">
          <label className="create-form__label">
            💊 Drogue: 
            <strong style={{ color: getAddictionColor(formData.addictions.drugs) }}>
              {' '}{getAddictionLevel(formData.addictions.drugs)} ({formData.addictions.drugs}%)
            </strong>
          </label>
          <input
            type="range"
            min="0"
            max="100"
            step="5"
            value={formData.addictions.drugs}
            onChange={(e) => setFormData({
              ...formData,
              addictions: { ...formData.addictions, drugs: parseInt(e.target.value) }
            })}
            className="create-form__range"
          />
          <div className="create-form__range-labels">
            <span>Aucune</span>
            <span>Modérée</span>
            <span>Élevée</span>
          </div>
        </div>
      </div>

      {/* Actions */}
      <div className="create-form__actions">
        <button
          type="submit"
          className="create-form__button create-form__button--submit"
        >
          ✓ Créer le personnage
        </button>
        <button
          type="button"
          onClick={onCancel}
          className="create-form__button create-form__button--cancel"
        >
          ✕ Annuler
        </button>
      </div>
    </form>
  );
};