import type { Metadata } from 'next';
import './globals.css';

export const metadata: Metadata = { title: 'NPSD Teacher Portal', description: 'Noble Public School Dadu teacher portal' };

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return <html lang="en"><body>{children}</body></html>;
}
