import { NextRequest, NextResponse } from "next/server";
import { PROXY_SERVICE_URL } from "~~/config/contracts";

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();

    const response = await fetch(`${PROXY_SERVICE_URL}/encrypt-to-user`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(body),
    });

    if (!response.ok) {
      const errorText = await response.text();
      return NextResponse.json({ error: `Encrypt to user failed: ${errorText}` }, { status: response.status });
    }

    const data = await response.json();
    return NextResponse.json(data);
  } catch (error) {
    console.error("Encrypt-to-user proxy error:", error);
    return NextResponse.json({ error: "Internal server error" }, { status: 500 });
  }
}
