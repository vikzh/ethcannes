/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./app/**/*.{js,ts,jsx,tsx}", "./components/**/*.{js,ts,jsx,tsx}", "./utils/**/*.{js,ts,jsx,tsx}"],
  // DaisyUI plugin removed; will be loaded via CSS @plugin directive.
  theme: {
    extend: {
      colors: {
        'soda-blue': {
          50: '#f0f4ff',
          100: '#e6edfe',
          200: '#d1ddfe',
          300: '#aec2fc',
          400: '#839bf9',
          500: '#5b74f4',
          600: '#4554ea',
          700: '#3742d7',
          800: '#2e37ad',
          900: '#032E7B',
          950: '#011a4a',
        }
      },
      boxShadow: {
        center: "0 0 12px -2px rgb(0 0 0 / 0.05)",
      },
      animation: {
        "pulse-fast": "pulse 1s cubic-bezier(0.4, 0, 0.6, 1) infinite",
      },
    },
  },
};
