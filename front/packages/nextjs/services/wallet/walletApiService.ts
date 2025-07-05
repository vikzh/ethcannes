/**
 * Service class for wallet-related API operations
 */
export class WalletApiService {
  /**
   * Decrypt balance via proxy API
   */
  static async decryptBalance(
    handle: string,
    chainId: number,
    userSignature: string
  ): Promise<string> {
    const requestData = {
      handle,
      chain_id: chainId,
      user_signature: userSignature,
    };

    const response = await fetch(`/api/encrypt-to-user`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(requestData),
    });

    if (!response.ok) {
      const errorText = await response.text();
      
      // Check for specific "unknown handle" error from MPC service
      if (errorText.includes("unknown handle") || errorText.includes("grpc_message:\"unknown handle\"")) {
        throw new Error("UNKNOWN_HANDLE: This balance handle is not recognized by the MPC service. You may need to perform a private token operation first (like shielding tokens) to initialize your private balance.");
      }
      
      throw new Error(`HTTP ${response.status}: ${errorText}`);
    }

    const data = (await response.json()) as { output: string };
    return data.output;
  }

  /**
   * Onboard user via API
   */
  static async onboardUser(
    rsaPublicKey: string,
    userSignature: string
  ): Promise<{ rsa_ciphertexts: string; message: string }> {
    const requestData = {
      rsa_public_key: rsaPublicKey,
      user_signature: userSignature,
    };

    const response = await fetch(`/api/onboard`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(requestData),
    });

    if (!response.ok) {
      const errorText = await response.text();
      throw new Error(`Onboarding failed: ${errorText}`);
    }

    const result = await response.json() as { rsa_ciphertexts: string; message: string };
    return result;
  }
} 