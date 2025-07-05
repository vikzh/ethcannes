"use client";

import React from "react";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { ChartBarIcon, ClockIcon, PlusIcon } from "@heroicons/react/24/outline";
import { ChartBarIcon as ChartBarIconSolid, ClockIcon as ClockIconSolid, PlusIcon as PlusIconSolid } from "@heroicons/react/24/solid";

type SidebarItem = {
  label: string;
  href: string;
  icon: React.ReactNode;
  activeIcon: React.ReactNode;
};

const sidebarItems: SidebarItem[] = [
  {
    label: "Portfolio",
    href: "/",
    icon: <ChartBarIcon className="h-6 w-6" />,
    activeIcon: <ChartBarIconSolid className="h-6 w-6" />,
  },
  {
    label: "History",
    href: "/history",
    icon: <ClockIcon className="h-6 w-6" />,
    activeIcon: <ClockIconSolid className="h-6 w-6" />,
  },
];

export const Sidebar = () => {
  const pathname = usePathname();

  return (
    <div className="w-64 bg-gray-50 min-h-screen flex flex-col border-r border-gray-200">
      {/* Logo Section */}
      <div className="p-6 border-b border-gray-200">
        <Link href="/" className="flex items-center gap-2">
          <div className="flex flex-col">
            <span className="font-bold leading-tight text-gray-900">Mosaic</span>
          </div>
        </Link>
      </div>

      {/* Navigation Items */}
      <nav className="flex-1 p-4">
        <ul className="space-y-2">
          {sidebarItems.map(({ label, href, icon, activeIcon }) => {
            const isActive = pathname === href;
            return (
              <li key={href}>
                <Link
                  href={href}
                  className={`flex items-center gap-3 px-4 py-3 rounded-xl transition-colors ${
                    isActive
                      ? "bg-soda-blue-100 text-soda-blue-900"
                      : "text-gray-600 hover:bg-gray-100 hover:text-gray-900"
                  }`}
                >
                  {isActive ? activeIcon : icon}
                  <span className="font-medium">{label}</span>
                </Link>
              </li>
            );
          })}
        </ul>
      </nav>
    </div>
  );
};
