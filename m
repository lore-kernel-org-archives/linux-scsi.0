Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795435732;
	b=W8XN9hotP7SJ6yaCGP220RZkeB2F8Jhnp3yDtkWwVzzzVm5NpZ9EauXRH37mfp8LuqVq
	 0/XkP87BmlB342PDjunds1cZzWWWq1QWI1PBH6XGSv/0TgBWuYZ256LABYdkerul4YrrM
	 A4LZQde1LOc8iwBWx+2qINtl8mPoLdzJrs31zneszSOmzDUSXJocPmdkpv6Df8TOxELtC
	 K7vO8CHcoRFQLANRJKgIKXHfgGI3dcswCVvOOSy/hqUt+dK7U/Hx5sjrZ3/KrLYH7Rr6V
	 szwDpEfUlUT8yQ+VOC7vAypTwYH0ZJnOlLBgIXsiSlf9j77Hx1B2507SQR28eE+DenQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795435732;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=/SiwyGPERRZ+wI7IGJpaGAyT67P6/mQY+ZPMOD9UOv8=;
	b=XJqnMc6bPthawnKZTSWC/Dam9i0p/WOK3Jh6pRUxXrgXSqPlHwAV1etYh71pqGnYsfo1
	 73c1l0G08yR4hMtx4TeuaaJjdvdt+WFOKBB+ymwRdhxx2W01Huv5hlpCtqrGFLkHyy42f
	 owm5nnLC1fEFoWkeHO+8ErbDy57h64asvBd5oXu+r8tGxmVQw9+an1bomD3dTDj7+AhfU
	 /qdEDkiEguxW7WA2/YxDWB3BWns4K5sLTzlVWrTQZhs48iSGoCH3WzkiRT88aFIkbkct+
	 8kN9DxN4g9ek3dfDxHZNowwOf5xplBrh4r7FwbmNGFOxYPx+TDYGp+mdpgo+tMpRdtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YCnUYlR0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F82606A32C;
	Mon, 23 Nov 2026 12:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YCnUYlR0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB6C1F000EF;
	Mon, 23 Nov 2026 12:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795435731;
	bh=/SiwyGPERRZ+wI7IGJpaGAyT67P6/mQY+ZPMOD9UOv8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YCnUYlR06NIXDwlkMqxoqluJqGGwvJWyF5BytmNeQvqkCwBMflpmZawVrGD6583TA
	 VvkJWpwZg9AJOQs0jZYfRYZnDOwXQi/mfjpx51kYz2RQn851jLG5fx0YOIs7qI5utw
	 lskmBmAGTmAfWa6HUCXFltCKYqf05BLYLOOhSRQ8wuhUYANAgcQ8z1Me0hltHfLwBU
	 c+i1tHdzrUEzUMMP8dgqDx1CCLVlEVq804U3n+BpezSTjSnkwXm7V23EgmC/FvWRl0
	 zStihzQ1ZcJOOWAo9kE1yvVsIPUL8FHvo667wgP9uTBpNUaLq1tT+zGcOrdQgBivz6
	 npkH1DPGOGGiw==
Date: Mon, 23 Nov 2026 13:08:48 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Cc: Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, Abel Vesa <abelvesa@kernel.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Robert Marko <robimarko@gmail.com>, Guru Das Srinagesh <linux@gurudas.dev>, 
	Thomas Gleixner <tglx@kernel.org>, Radu Rendec <radu@rendec.net>, Lee Jones <lee@kernel.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	"Joerg Roedel (AMD)" <joro@8bytes.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Wesley Cheng <wesley.cheng@oss.qualcomm.com>, Vinod Koul <vkoul@kernel.org>, 
	Neil Armstrong <neil.armstrong@linaro.org>, Manivannan Sadhasivam <mani@kernel.org>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
	Bean Huo <beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>, 
	Amit Kucheria <amitk@kernel.org>, Thara Gopinath <thara.gopinath@gmail.com>, 
	Daniel Lezcano <daniel.lezcano@kernel.org>, Zhang Rui <rui.zhang@intel.com>, 
	Lukasz Luba <lukasz.luba@arm.com>, Georgi Djakov <djakov@kernel.org>, 
	Sibi Sankar <sibi.sankar@oss.qualcomm.com>, Ulf Hansson <ulfh@kernel.org>, linux-arm-msm@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, mfd@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev, linux-usb@vger.kernel.org, 
	linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-pm@vger.kernel.org
Subject: Re: [PATCH v2 09/16] dt-bindings: crypto: qcom,inline-crypto-engine:
 Add Halliday
Message-ID: <20261123-cherubic-sparkling-mussel-e94df1@quoll>
References: <20261116-halliday-dts-v2-0-2c92438c6c46@gmail.com>
 <20261116-halliday-dts-v2-9-2c92438c6c46@gmail.com>
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
In-Reply-To: <20261116-halliday-dts-v2-9-2c92438c6c46@gmail.com>

On Mon, Nov 16, 2026 at 09:26:25PM +0000, Stanislav Aleksandrov wrote:
> Document the Inline Crypto Engine on the Qualcomm Halliday SoC.
> 
> Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
> ---
>  Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 1 +
>  1 file changed, 1 insertion(+)

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

