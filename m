Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE2F3F44C1;
	Fri, 28 Aug 2026 10:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787912891; cv=none; b=MOkOGcrYkIKZ0jdQTvHPsmBWorLs7keJ3MusgdpRx20ssYaMaoy83hetl5dy3Md8kcFC8VR8ofSxB/FC/XMML39aJB0qLypXoEznu9KtUdfcfM3RKRQnbAHp6y+244zJxSYsEOvl5vE5iSvyVyhR5uvv29zy18RD+uetqU6c6ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787912891; c=relaxed/simple;
	bh=aoKZWDUHo+Fcao1jZ8fwlVQ+ANgNQirHdxSNu9tQk14=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nkEfQQdt0QwcWsM5TcK0mf3IcozZZDbpb9k7xaMXjiYZ85Vmq5t6vDSV8oXP+zSsnrU0sPrnWw7rUob+7oXkcipYqQr/IsNfJV4QtcxaW2AaGZCY2UAEFQn9Nzt+N0qlZ7rMeFbmn9CwSZkxSDwWCu58OlZ+vIAHCm7rIZOtavk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HIjWXox8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HIjWXox8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 052001F000E9;
	Fri, 28 Aug 2026 10:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787912889;
	bh=O19Kqaz7Dc0R78cpyBBCb7hRpvdqq1kuEoC+NWYg7mY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HIjWXox84GVYA5/r5qnIDGTHPXsVfcElHLj7e6zkZzow0JfkOrlXCrbBE9kcfljnT
	 rO62Mb40W98e75UU5oJhfnTA8MOIfKbeshdvlhuz2m1iMDND8DDfxUs/xTD/oFC8hn
	 MQMcrg70klncgs4VW1DD5B9ztlK7OyaOretgMGZIfgpidmjJKzk03fyFmyuDU1eKCO
	 ds7RXxsyPjg7MmMsTlx4rAU3KlKszflh2YE30YS7idK8ObpOk0U3OpgvZXIhOBmwDk
	 kpGhW+kZLDc00wdSdW2Rs4kJGE5/E2N+ZTn8P2A2lZODO5KmikRbWceHDwvgCBIWlt
	 ib4IxtNfdRJtw==
Date: Fri, 28 Aug 2026 12:28:06 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Larisa Grigore <larisa.grigore@oss.nxp.com>
Cc: NXP S32 Linux Team <s32@nxp.com>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@sandisk.com>, 
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, Frank Li <Frank.Li@nxp.com>, 
	Sascha Hauer <s.hauer@pengutronix.de>, Pengutronix Kernel Team <kernel@pengutronix.de>, 
	Fabio Estevam <festevam@gmail.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, 
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>, Ajay Neeli <ajay.neeli@amd.com>, 
	Manivannan Sadhasivam <mani@kernel.org>, Pedro Sousa <pedrom.sousa@synopsys.com>, clizzi@redhat.com, 
	aruizrui@redhat.com, eballetb@redhat.com, echanude@redhat.com, 
	linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	imx@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 06/10] dt-bindings: ufs: Add compatibles for S32N79 Host
 Controller platform driver
Message-ID: <20260828-dark-foamy-guillemot-0b60be@quoll>
References: <20260826134048.854748-1-larisa.grigore@oss.nxp.com>
 <20260826134048.854748-7-larisa.grigore@oss.nxp.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260826134048.854748-7-larisa.grigore@oss.nxp.com>

On Wed, Aug 26, 2026 at 03:40:44PM +0200, Larisa Grigore wrote:
> +  clocks:
> +    maxItems: 1
> +    description: UFS core clock
> +
> +  clock-names:
> +    items:
> +      - const: core_clk

_clk is redundant, just "core". Or skip names, not really useful in this
case.

> +
> +  nxp,mphy-boot-mode:
> +    description: |
> +      MPHY initialization mode. Defines how the MPHY firmware should be
> +      initialized and executed during UFS controller startup.
> +      If this property is not specified, MPHY initialization will be skipped.

Isn't this implied by the compatible?

> +    $ref: /schemas/types.yaml#/definitions/string
> +    enum:
> +      - rom
> +
> +required:
> +  - compatible
> +  - reg
> +
> +allOf:
> +  - $ref: ufs-common.yaml
> +  - if:
> +      required:
> +        - nxp,mphy-boot-mode
> +    then:
> +      properties:
> +        reg:
> +          minItems: 2
> +        reg-names:
> +          minItems: 2
> +      required:
> +        - reg-names
> +        - clocks
> +        - clock-names
> +    else:
> +      properties:
> +        reg:
> +          maxItems: 1
> +        reg-names:
> +          maxItems: 1

I don't get why for the SAME device diffeernt initialization means
device has different address space or clocks. It's the same device, same
wiring, same hardware setup.

Best regards,
Krzysztof

