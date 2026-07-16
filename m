Received: from hall.aurel32.net (hall.aurel32.net [195.154.119.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816FE2F84F;
	Thu, 16 Jul 2026 21:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.154.119.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784237208; cv=none; b=ZqBq/Tp8ShSxprlNaf6CZ+Qu4PyQXzuglXbDah+/BG8n0n4gUglGcgqSh+z9ngdcoT8d3zsIPrAAUlbvgHs0Dsygmq1za5ikCwz0GO25qG4CvfOClCHLNFRSz8U7SPnE3HWu0rdNoSotasAOoVrFCnrybJmhmReJBYXiTuRTJ7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784237208; c=relaxed/simple;
	bh=eBD3xC2w2r6IMFzyfSKGhQgxI2gP5si1zBfAThzzpfg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e2rBdNxqjV5ih0U6McWcOL8pNvl78jIwYSOO45CPKAUP9I2w6rrRiSaMUDAzOvqg032QJzBl1i53wkkSxM4vhMjHqDuEjkUdBuKpQPQeVSmgQE7zsH9tFLoe+QtXBLdaqsQetX4pte+/XzEDCeEM3lhA0bVBsXAPg1iudJtdEEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=aurel32.net; spf=pass smtp.mailfrom=aurel32.net; dkim=pass (2048-bit key) header.d=aurel32.net header.i=@aurel32.net header.b=cETsKBSL; arc=none smtp.client-ip=195.154.119.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=aurel32.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aurel32.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aurel32.net header.i=@aurel32.net header.b="cETsKBSL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=aurel32.net
	; s=202004.hall; h=In-Reply-To:Content-Type:MIME-Version:References:
	Message-ID:Subject:Cc:To:From:Date:Content-Transfer-Encoding:From:Reply-To:
	Subject:Content-ID:Content-Description:X-Debbugs-Cc;
	bh=IHHFZjWtMO0vAPMAs5btZr8tg9GjbzOdB+otmk/vwXE=; b=cETsKBSL6nUmD7VJt4o3Zp8jqG
	xs+K/FktxVlsQBPuvrY7A80KwrljJJGEaVST+WolVNYk4CV2Z3WD5ILuBqJf153xu8Sw5QNUmXQ6Q
	vH3e+2fT6JHUv+4sO/9THyFf/YeXQrUXtTYpS5LpRo/zi1clDvsvT0ZJoRimxIlmxs1bV0BHiPRER
	fLMVf4ERAWxNBQQdwaCFIuK11Bbj3gtvM5YdzbIu8uVHAY8D+7Z35G5rZMSiW09dfLpIs9yWidYxt
	2lQ5GTjs7VN3hXokGWUKW5RemGv9yCM2Y79TxMHELEIKWYV9664IknlrorIilev8q/hzwGfBNqemy
	+erHCU1g==;
Received: from authenticated user
	by hall.aurel32.net with esmtpsa  (TLS1.3)  tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <aurelien@aurel32.net>)
	id 1wkTbL-00000003GBa-2jK7;
	Thu, 16 Jul 2026 23:26:39 +0200
Date: Thu, 16 Jul 2026 23:26:38 +0200
From: Aurelien Jarno <aurelien@aurel32.net>
To: Yixun Lan <dlan@kernel.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
	linux-riscv@lists.infradead.org, spacemit@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] riscv: dts: spacemit: k3: Add UFS support
Message-ID: <allMjjHX9JhMm1M4@aurel32.net>
Mail-Followup-To: Yixun Lan <dlan@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
	linux-riscv@lists.infradead.org, spacemit@lists.linux.dev,
	linux-kernel@vger.kernel.org
References: <20260702-08-k3-ufs-support-v1-0-1a64a3ab128f@kernel.org>
 <20260702-08-k3-ufs-support-v1-3-1a64a3ab128f@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702-08-k3-ufs-support-v1-3-1a64a3ab128f@kernel.org>
User-Agent: Mutt/2.2.13 (2024-03-09)

On 2026-07-02 02:31, Yixun Lan wrote:
> Add UFS Host Controller support for SpacemiT K3 SoC, and enable
> it both on both Pico-ITX and CoM260-IFX boards.
> 
> Signed-off-by: Yixun Lan <dlan@kernel.org>
> ---
>  arch/riscv/boot/dts/spacemit/k3-com260-ifx.dts |  4 ++++
>  arch/riscv/boot/dts/spacemit/k3-pico-itx.dts   |  4 ++++
>  arch/riscv/boot/dts/spacemit/k3.dtsi           | 13 +++++++++++++
>  3 files changed, 21 insertions(+)
> 
> diff --git a/arch/riscv/boot/dts/spacemit/k3-com260-ifx.dts b/arch/riscv/boot/dts/spacemit/k3-com260-ifx.dts
> index 238bb03d0e9e..b37e1c7b03e3 100644
> --- a/arch/riscv/boot/dts/spacemit/k3-com260-ifx.dts
> +++ b/arch/riscv/boot/dts/spacemit/k3-com260-ifx.dts
> @@ -19,3 +19,7 @@ chosen {
>  		stdout-path = "serial0:115200n8";
>  	};
>  };
> +
> +&ufshc {
> +	status = "okay";
> +};
> diff --git a/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts b/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts
> index b89c1521e664..f1560a5a9031 100644
> --- a/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts
> +++ b/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts
> @@ -221,3 +221,7 @@ hub@1 {
>  &usb2_phy {
>  	status = "okay";
>  };
> +
> +&ufshc {
> +	status = "okay";
> +};

I guess you want to keep the nodes sorted and put it before usb2_host. Anyway:

Tested-by: Aurelien Jarno <aurelien@aurel32.net>

-- 
Aurelien Jarno                          GPG: 4096R/1DDD8C9B
aurelien@aurel32.net                     http://aurel32.net
