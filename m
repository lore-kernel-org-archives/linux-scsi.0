Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794565174;
	b=GoQepiphYKu+4Zcl6kV29jzpf9yS+lJfXbLnSPCxopYKJmyJ6ogr/GG8nlRR/+6I4r5H
	 e7Hr2nk9JWrzgieCUhiS70OMZQHDtRY8Gt60rCDSPmJBTJdMFN4eyqowFbZIBaJdG9jYR
	 H9ybM3gyzqB/raRmaEE90HwDEy3gbcgFzt5W70hF6Wi61WqJpyVTHl+xvlz/e31esoHUG
	 SZ4mXb2qDsTV4Pg2mZ1cj3TaDste3rzWgGEeuRB1u493T3jVvJtjximajrwTyJjOjK6+u
	 e4nAZ9PWwdSij+poqR850jFL8WEJ8aQFotJtVXCdFwGQ4ZSVQ2oVFaMH3Mcfm7ldc3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794565174;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=gyAS678xyehwrSeqsPQSw9GBxZSkkiYhUUKHcjA2qv8=;
	b=fL3StTS2VtjCRo97ke3Np8kwshVUMCHwev2rhcQg/hOESu4dB1AXst9USVFsc4ats2mC
	 U5axGN/S+bevxVSq3RAbm0fIzZT7uahh0e7A0pW9aFFa5HBuy7Js5LyreEB9E/iaKZPFB
	 4TO9k68cSYf1iIdf0uUITNXVHJZ5D7nrHTMQamYjWKA2+icPx521iRHwcXGaGihZz/MQa
	 81Y0Um3B8UgKjCQ1x/A7WTLjSsOeSFfy/ou5/53j2+I1bh1oU/XuwLovogyn8Pv2mLY0M
	 +7UuOQZJx9HyYsMiUfEFn3r2XONbP/u/CT7eJ4vQDhyGlqEw7NEggAW5AcE8IBa8T1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K7sXUvxS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75406606A321;
	Fri, 13 Nov 2026 10:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K7sXUvxS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E05871F000C4;
	Fri, 13 Nov 2026 10:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794565174;
	bh=gyAS678xyehwrSeqsPQSw9GBxZSkkiYhUUKHcjA2qv8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=K7sXUvxSeB2tYcx6aB8Y0Y+c2bYY9eXO3YUiOeAL+ePkDCJNuN4GNuygwCv6k0YvR
	 SnH61/R2Pf3VijDTpLZ8D+gLRuNVXQ2d7XNq0TtYRtxrWdwwZ0r1h+vA+Tjq4lsMeO
	 whgfswO/RjhT1FZItgMwEQy/Cm1wS1wTTWXqKXSkDwZgN46q73t2uUYLNgclxvfg1M
	 IdceQi1bag68sn5ZdtghDVenDTCYYHVHBSXfVyYUDJOBp9Wd1DX7yO80Bd/5wH0QNz
	 5+8pMruEIzDYDcobDS8812sBEievteaeZzJ01K+l9uDKAsM0MxLaCn9/3RdjF2JIUy
	 DonlvfjBaYA/A==
Date: Fri, 13 Nov 2026 11:19:30 +0100
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
	Sibi Sankar <sibi.sankar@oss.qualcomm.com>, linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mfd@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	iommu@lists.linux.dev, linux-usb@vger.kernel.org, linux-phy@lists.infradead.org, 
	linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH 04/17] dt-bindings: power: qcom,rpmpd: document the
 Halliday RPMh Power Domains
Message-ID: <20261113-remarkable-inescapable-llama-cbec8d@quoll>
References: <20261109-halliday-dts-v1-0-289114ab8197@gmail.com>
 <20261109-halliday-dts-v1-4-289114ab8197@gmail.com>
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
In-Reply-To: <20261109-halliday-dts-v1-4-289114ab8197@gmail.com>

On Mon, Nov 09, 2026 at 12:33:16AM +0000, Stanislav Aleksandrov wrote:
> Document the RPMh Power Domains on the Qualcomm Halliday SoC
> (SXR2250P). Its command DB has the same power domains as SM8450
> (CX, EBI, GFX, LCX, LMX, MMCX, MSS, MX and MXC), so use
> qcom,sm8450-rpmhpd as the fallback compatible.
> 
> Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
> ---
>  Documentation/devicetree/bindings/power/qcom,rpmpd.yaml | 4 ++++
>  1 file changed, 4 insertions(+)

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

