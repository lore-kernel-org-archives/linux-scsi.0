Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793969426;
	b=TZakNZpUge3JXkAuS8OLlDR4Di5m6/IzNj5NdtsBK6duSKtiyuLPMVaGg+ahIRHXIhzH
	 xaL7Flj0GHKwJckdheIIxR8rKCV4IFpq09PUvFPSK08h/Fw2AUTniMvkGMHb/gllDEPg/
	 biYEG/+r9nR8zryAEtZ7Wer6gP/MrwAFw3gCDpDTkgvs3fKtlTjJF/i6s+cl7ZtuHMz42
	 Kh274m9DyXWQJA/DeAdWMcr2Otmw+2PxM5nFYLbnOKCpuLdWoKIeQd2pDmfYYqk+SD4Hd
	 uXm4ZeLb0Vti9UE87/FpVJ2ojphWboaijVkQ9h/qCBsiSSmC/jasWPFETDBZ6+Lk1fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793969426;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=u7TzN7UjxwjzBe9DUJ1+ST6+Za71fgRUknBs8rBYbuI=;
	b=wFNPNbgY6eck6IlOtMCzLtaCm6KW8PGhG3GKfhE5uGSuFExQynf+6ZJEB/q9h7nx/XKm
	 hFp7ARXbLSTfespi+jV+GyeEpMAm6Xz7UZiR2QqfbuXC4keGGi0Xt8/qGq0XUlrDc+A0X
	 EQUXcF5jq7nPYz5Xz5YxG1W3xFgTC4CtfmNNNmybDZdV1AsUwXhSFvRD2Zf/+srqcVOFK
	 3HUmdCIMq7SaSyZ38aHRY8eC1H1WN5BJ3/VrdWTFFxb+paQjVk+n/iY+OgPIA70CYNq7V
	 iKp28FHkJ/AR+X0F1EEOUoY1A7KYKVwR9EkwAMRxHIpSgJtCFoHC38jJOq2PIC/eSbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UUU+zab7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D57606A329;
	Fri,  6 Nov 2026 12:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UUU+zab7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FE721F0089F;
	Fri,  6 Nov 2026 12:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793969426;
	bh=u7TzN7UjxwjzBe9DUJ1+ST6+Za71fgRUknBs8rBYbuI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UUU+zab7ko1b/IuvOLLJMhGYnAobEwxjsYAPCJBRYo8BWBJVVDKSMQaYBpMfYYZ8Z
	 ngUcCddpyyFNYBBjMUB3/5kOdmjEaloZ16DcS9Lqt4CoSAWrjpW5O+G9vE13u2bTw3
	 s4/xSmYst1uhMTz9XLYAzLGgV7P3KXZkgXdJDawigpbgUCjjAAdoUanvrYVQcVDQ/V
	 dN7RPerNuKOLwr9MaMqMX2jykXgsQd0BZ/LKE4M+2uvJgUnANc3ElVQZzUHr9vRgZu
	 IvQKPCr671kPsG9JpAQTBcwEaRZnN9WO/4oh/ZKaycyTLrRw9rDR3TaCuAAfsQaNwE
	 dnHkin62gu60Q==
Date: Fri, 6 Nov 2026 13:50:22 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Andrew Gigena <mail@andrewgigena.dev>
Cc: Abel Vesa <abelvesa@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Manivannan Sadhasivam <mani@kernel.org>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
	Bean Huo <beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>, 
	Bjorn Andersson <andersson@kernel.org>, Andy Gross <agross@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 1/2] dt-bindings: crypto: ice: Document sm8150 inline
 crypto engine
Message-ID: <20261106-offbeat-hawk-of-purring-50a8aa@quoll>
References: <20261104-sm8150-ice-rfc-v2-0-d697bbce0278@andrewgigena.dev>
 <20261104-sm8150-ice-rfc-v2-1-d697bbce0278@andrewgigena.dev>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261104-sm8150-ice-rfc-v2-1-d697bbce0278@andrewgigena.dev>

On Wed, Nov 04, 2026 at 06:38:12PM +0000, Andrew Gigena wrote:
> Document the compatible used for the inline crypto engine found on
> SM8150.
> 
> SM8150 UFS uses a standalone ICE node referenced via qcom,ice, so move
> qcom,sm8150-ufshc from the legacy embedded-ICE UFS binding to the
> standalone-ICE UFS binding. Update the legacy binding example to use
> qcom,sdm845-ufshc, which still uses the embedded ICE representation.
> 

This part should be a separate commit.

> Signed-off-by: Andrew Gigena <mail@andrewgigena.dev>
> ---
>  .../devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml |  1 +
>  Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml  |  2 ++
>  Documentation/devicetree/bindings/ufs/qcom,ufs.yaml           | 11 ++++-------
>  3 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> index 23bf98c2b9fa..0d73e4581e6e 100644
> --- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> +++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> @@ -24,6 +24,7 @@ properties:
>            - qcom,sc7180-inline-crypto-engine
>            - qcom,sc7280-inline-crypto-engine
>            - qcom,shikra-inline-crypto-engine
> +          - qcom,sm8150-inline-crypto-engine
>            - qcom,sm8450-inline-crypto-engine
>            - qcom,sm8550-inline-crypto-engine
>            - qcom,sm8650-inline-crypto-engine
> diff --git a/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml b/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
> index 3c407426d697..572eec814a60 100644
> --- a/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
> +++ b/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
> @@ -23,6 +23,7 @@ select:
>            - qcom,sc7280-ufshc
>            - qcom,sc8180x-ufshc
>            - qcom,sc8280xp-ufshc
> +          - qcom,sm8150-ufshc
>            - qcom,sm8250-ufshc
>            - qcom,sm8350-ufshc
>            - qcom,sm8450-ufshc
> @@ -48,6 +49,7 @@ properties:
>                - qcom,sc7280-ufshc
>                - qcom,sc8180x-ufshc
>                - qcom,sc8280xp-ufshc

And what about eight clock? All existing DTS will report warning? I
don't quite get the need of this move.

Best regards,
Krzysztof


