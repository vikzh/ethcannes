import React, { useEffect, useState, useCallback } from 'react';
import styles from './MosaicShieldAnimation.module.css';

interface MosaicShieldAnimationProps {
  isActive: boolean;
  data?: string; // Transaction hash or signature
  duration?: number;
  className?: string;
}

const CHARACTERS = '0123456789ABCDEF';
const MASK_CHAR = '•';
const ANIMATION_SPEED = 50; // ms per frame

const generateRandomChar = () => {
  return CHARACTERS[Math.floor(Math.random() * CHARACTERS.length)];
};

const MosaicShieldAnimation: React.FC<MosaicShieldAnimationProps> = ({
  isActive,
  data = '0x0000000000000000000000000000000000000000',
  duration = 2000,
  className = ''
}) => {
  // Split data into chunks for animation
  const chunks = React.useMemo(() => {
    const chunkSize = 4;
    const result = [];
    for (let i = 0; i < data.length; i += chunkSize) {
      result.push(data.slice(i, i + chunkSize));
    }
    return result;
  }, [data]);
  
  const rows = chunks.length || 1;
  const columns = chunks[0]?.length || 16;
  const [frame, setFrame] = useState<string[][]>([]);
  const [phase, setPhase] = useState<'typing' | 'hiding'>('typing');
  const [typingProgress, setTypingProgress] = useState(0);

  const generateFrame = useCallback((progress: number) => {
    const newFrame = [];
    const totalCells = rows * columns;
    const maskedCells = Math.floor(progress * totalCells);
    
    for (let i = 0; i < rows; i++) {
      const row = [];
      const chunk = chunks[i] || '';
      
      for (let j = 0; j < columns; j++) {
        const index = i * columns + j;
        const char = chunk[j] || ' ';
        const isMasked = index < maskedCells;
        
        if (isMasked) {
          // Show the actual character with some randomness
          const shouldShow = Math.random() > 0.3;
          row.push(shouldShow ? char : MASK_CHAR);
        } else {
          // Show random hex character or space
          row.push(Math.random() > 0.7 ? generateRandomChar() : ' ');
        }
      }
      newFrame.push(row);
    }
    return newFrame;
  }, [chunks, rows, columns]);

  useEffect(() => {
    if (!isActive || !data) {
      setTypingProgress(0);
      setPhase('typing');
      return;
    }

    let animationFrameId: number;
    let lastUpdate = Date.now();
    
    const animate = () => {
      const now = Date.now();
      const delta = now - lastUpdate;
      lastUpdate = now;
      
      if (phase === 'typing') {
        setTypingProgress(prev => {
          const newProgress = prev + (delta / (duration * 0.5));
          if (newProgress >= 1) {
            setPhase('hiding');
            return 1;
          }
          return newProgress;
        });
      } else {
        setTypingProgress(prev => {
          const newProgress = prev - (delta / (duration * 0.5));
          if (newProgress <= 0) {
            setPhase('typing');
            return 0;
          }
          return newProgress;
        });
      }
      
      setFrame(generateFrame(typingProgress));
      animationFrameId = requestAnimationFrame(animate);
    };
    
    animationFrameId = requestAnimationFrame(animate);
    
    return () => {
      cancelAnimationFrame(animationFrameId);
    };
  }, [isActive, duration, generateFrame]);

  if (!isActive) return null;

  return (
    <div className={`${styles.asciiContainer} ${className}`}>
      <div className={styles.asciiArt}>
        {frame.map((row, rowIndex) => (
          <div key={rowIndex} className={styles.asciiRow}>
            {row.map((char, colIndex) => (
              <span 
                key={`${rowIndex}-${colIndex}`}
                className={`${styles.asciiChar} ${char === MASK_CHAR ? styles.masked : ''}`}
                style={{
                  '--row': rowIndex,
                  '--col': colIndex,
                  '--delay': `${(rowIndex * 0.05) + (colIndex * 0.02)}s`
                } as React.CSSProperties}
              >
                {char}
              </span>
            ))}
          </div>
        ))}
      </div>
    </div>
  );
};

export default MosaicShieldAnimation;
