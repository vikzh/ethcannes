"use client";
import React from "react";

const Loading: React.FC = () => (
  <div className="flex flex-col items-center justify-start py-8 px-6">
    <div className="w-full max-w-6xl">
      <h1 className="text-3xl font-bold text-soda-blue-900 mb-6">My Portfolio</h1>
      <div className="bg-white rounded-3xl shadow-lg p-6">
        <div className="text-center py-8">
          <div className="animate-spin rounded-full h-16 w-16 border-b-2 border-soda-blue-900 mx-auto mb-4"></div>
          <h3 className="text-lg font-medium text-gray-900 mb-2">Loading tokens...</h3>
          <p className="text-gray-500 max-w-md mx-auto">Please wait while we fetch your token data</p>
        </div>
      </div>
    </div>
  </div>
);

export default Loading; 