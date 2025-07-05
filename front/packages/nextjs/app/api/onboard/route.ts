import { NextRequest } from "next/server";

const MPC_PROXY_URL = process.env.NEXT_PUBLIC_SODLABS_PROXY_URL || "https://proxy.bubble.sodalabs.net";

export async function POST(req: NextRequest) {
  try {
    const body = await req.json();

    const proxyResponse = await fetch(`${MPC_PROXY_URL}/onboard`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(body),
    });

    const text = await proxyResponse.text();
    return new Response(text, {
      status: proxyResponse.status,
      headers: { "Content-Type": proxyResponse.headers.get("content-type") || "application/json" },
    });
  } catch (error: any) {
    console.error("/api/onboard proxy error", error);
    return new Response(`Proxy error: ${error?.message || "unknown"}`, { status: 500 });
  }
} 