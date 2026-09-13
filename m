Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079DA399CEC;
	Sun, 13 Sep 2026 08:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789288824; cv=none; b=sROROWKbNrLhMcj1ORYOI/y0rbODCt32ggwmORerxcm/T0R2Ja9eUOKImt9ErmNzthLUOQOgl2VRZ3AqFyvIn5PGiJkiRcFR0Yb88rqDoSfUXX6NYg+P3VztKSR+v7+hU14cI5l2rgRTMCWmGsqu+kpJPxbvyvVTaXLuTBkLi6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789288824; c=relaxed/simple;
	bh=e2izvdQYBcDU/bfcrFEtSPC2JV5jOD6pcX91UdJ2UfA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DQQH8MglDoQncB9j9NlCana/AFr5AQX/VGjIyAzRJ9K2c2Be0Hb/wjqOWb9I2ytGWMdC4qGGu6aKI20QBtx8W9SRHYVLK9tnvV7Jg3XznoXcei8tr5Jww/Gy+GTUVqaeBZ6aK7xvYAR9AP3SQjzChtvzPB70OEYl1iVeZKWXBOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ecUN0sy8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ecUN0sy8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A722E1F00893;
	Sun, 13 Sep 2026 08:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789288822;
	bh=YureLu9/Z0Qra70ojA6pgOcX9RNvKMeCOl40rCqL2rg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ecUN0sy8WfMWhFw8mqBYkeWmchKSfwJOoH4iGZs8BzRDuL+7sIJjp1bdyiYnAn0Zo
	 nj1/Gp9Jk0GN6nQ52f9lZy/yCOnUkCeZyvgx16+C4ENTsbOE4sf+tz74bIC0v8pvWm
	 5bBp9s+/2tyrSsALZqNdT5xDgHfDf+7mAysO8Xqxw1LwCrPFA3HkdggyyElVEI+QYt
	 CIlGFpd3F7rbkFXiqG4OEEulRghPL7UCeOJniYQTfWjnL7adbJkCWxrLvMTTF7BFgN
	 T0P/2/ZIhgEScuft4j4keu/Y198Uy5fV5erSi0rtPYSpnEBNzcMdTPMqzXPEQpZ9Xs
	 Z3NKtq6SFjVgA==
Date: Sun, 13 Sep 2026 10:40:18 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Kartik Rajput <kkartik@nvidia.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Thierry Reding <thierry.reding@kernel.org>, 
	Jonathan Hunter <jonathanh@nvidia.com>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, 
	Thierry Reding <treding@nvidia.com>, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] dt-bindings: ufs: Add nvidia,tegra264-ufs
Message-ID: <20260913-vivid-accurate-bee-4ccc5a@quoll>
References: <20260909-tegra264-ufs-v1-0-e4a9831702a0@nvidia.com>
 <20260909-tegra264-ufs-v1-1-e4a9831702a0@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260909-tegra264-ufs-v1-1-e4a9831702a0@nvidia.com>

On Wed, Sep 09, 2026 at 04:11:19PM +0530, Kartik Rajput wrote:
> +  clocks:
> +    items:
> +      - description: UFS host controller functional clock
> +      - description: UFS host controller divider clock
> +      - description: UFS reference clock (PLLREFUFS output)
> +      - description: UFS device-side reference clock
> +      - description: M-PHY reference clock (UPHY0 PLL4 digital output)
> +
> +  clock-names:
> +    items:
> +      - const: ufs

core? Names equal to block name are not really useful

> +      - const: div
> +      - const: ref
> +      - const: ref-dev
> +      - const: phy

Shouldn't the phy take its reference clock?

> +
> +  resets:
> +    items:
> +      - description: UFS host controller reset
> +      - description: UFS host controller AXI-master reset
> +      - description: UFS host controller low-power sequencer reset
> +
> +  reset-names:
> +    items:
> +      - const: ufs
> +      - const: axi
> +      - const: lp
> +
> +  phys:
> +    items:
> +      - description: M-PHY lane 0 transmit
> +      - description: M-PHY lane 0 receive
> +      - description: M-PHY lane 1 transmit
> +      - description: M-PHY lane 1 receive
> +
> +  phy-names:
> +    items:
> +      - const: mphy-l0-tx
> +      - const: mphy-l0-rx
> +      - const: mphy-l1-tx
> +      - const: mphy-l1-rx
> +
> +  iommus:
> +    maxItems: 1
> +
> +  dma-coherent: true
> +
> +required:
> +  - compatible
> +  - reg
> +  - reg-names
> +  - clocks
> +  - clock-names
> +  - resets
> +  - reset-names
> +  - phys
> +  - phy-names
> +  - iommus
> +  - dma-coherent
> +
> +allOf:
> +  - $ref: ufs-common.yaml
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/clock/nvidia,tegra264.h>
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +    #include <dt-bindings/phy/nvidia,tegra264-mphy.h>

You need to decouple dependencies. Otherwise how is this supposed to be
checked with tools? If applied, you just broke maintainer's tree.


> +    #include <dt-bindings/reset/nvidia,tegra264.h>

Best regards,
Krzysztof

