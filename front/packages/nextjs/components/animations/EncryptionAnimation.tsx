import React, { useEffect, useState } from 'react';
import styles from './EncryptionAnimation.module.css';

const HASH_CHARS = '0123456789abcdef';
const HASH_LENGTH = 64;
const ANIMATION_SPEED = 100; // ms

const generateRandomHash = () => {
  return '0x' + Array(HASH_LENGTH).fill(0).map(
    () => HASH_CHARS[Math.floor(Math.random() * HASH_CHARS.length)]
  ).join('');
};

const EncryptionAnimation: React.FC<{ isActive: boolean }> = ({ isActive }) => {
  const [hash, setHash] = useState('0x' + '0'.repeat(HASH_LENGTH));
  
  useEffect(() => {
    if (!isActive) return;
    
    const interval = setInterval(() => {
      setHash(generateRandomHash());
    }, ANIMATION_SPEED);
    
    return () => clearInterval(interval);
  }, [isActive]);
  
  if (!isActive) return null;
  
  return (
    <div className={styles.hashContainer}>
      <span className={styles.hashText}>{hash}</span>
      <span className={styles.cursor}>_</span>
    </div>
  );
};

export default EncryptionAnimation;
