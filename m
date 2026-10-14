Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C1C4F798D;
	Wed, 14 Oct 2026 11:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791976255; cv=none; b=Q1rBQAhrdkGOEkDqTeI90yDgyE3a9fmN5Eev9O7K42tOUyoACMdTHdNeH7jlCvtsOIqE3O3Im1o0yR9nLHGk1cgVUYjdlccrD/0QBSqPBqSurWQ2pFM2PtDbedHbohaHlshqt0hVcgvKOu/Cub02sfnVg/EBPht+ch7QiufLdqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791976255; c=relaxed/simple;
	bh=dEHPKb1DKoNwCQMbfM4JudnCdMqGpWORd6mwaTX1o8I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OxXEoJjidzUpsMCrXM72xcyVQZ9M+vj+Ch5+BZSVXkfQZ9JNbk0XenWMWiXoDT2wJbLnEAw8AEyA2tZ6HhK0Shf46LvFnBli5b3snqEh7v7U7JTcar/xng/ogWWlvE0paILxIh8DXoqMh/OsuVuZAWC2no/S8OJhjCn8rOL9UZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CWx4n9R4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CWx4n9R4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F4171F000FF;
	Wed, 14 Oct 2026 11:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791976251;
	bh=y96IkeDxhN2mv/HtCGTf5fVU+AZ1Foo8ubrdmppnui8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CWx4n9R46TUqwkh7PD3NrIpvAN6CeIsqtkLYPEI3nayTP82qiokRVEOSoTXi7JDun
	 0T0Y0ZEdhNY2vwCweSoDYhfikgZsICh522SJERQY0izF6rslpI26wHSvQIRECpsgPw
	 3T8DjC2hYwURj40OV3fgiSvD+O4LbCMP2loE5Hb3qn0Q/X6ZDvxT8K8G6R8xy9n45W
	 XkCJlBrfGwp7E33utB0UnoF0NNz+aoNjOUT0mKmuIfJbZJpYRgX53yGP0t/xm9KADF
	 r5HiAjK5/IcJVwY9jbWjDDP9ib7KsTnjIst2A5lQBCczmVDW6JacaVfo5Wh07knVNM
	 ToBz+IPNA4kow==
Date: Wed, 14 Oct 2026 13:10:48 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Larisa Grigore <larisa.grigore@oss.nxp.com>
Cc: NXP S32 Linux Team <s32@nxp.com>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@sandisk.com>, 
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, Frank Li <Frank.Li@nxp.com>, 
	Sascha Hauer <s.hauer@pengutronix.de>, Pengutronix Kernel Team <kernel@pengutronix.de>, 
	Fabio Estevam <festevam@gmail.com>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>, 
	Ajay Neeli <ajay.neeli@amd.com>, Manivannan Sadhasivam <mani@kernel.org>, 
	Pedro Sousa <pedrom.sousa@synopsys.com>, Hannes Reinicke <hare@suse.de>, 
	Joao Pinto <Joao.Pinto@synopsys.com>, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, imx@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-arm-msm@vger.kernel.org, clizzi@redhat.com, aruizrui@redhat.com, eballetb@redhat.com, 
	echanude@redhat.com
Subject: Re: [PATCH v8 07/12] dt-bindings: ufs: Add NXP S32N79 UFS host
 controller
Message-ID: <20261014-valiant-goose-of-revolution-efec17@quoll>
References: <20261013103003.373156-1-larisa.grigore@oss.nxp.com>
 <20261013103003.373156-8-larisa.grigore@oss.nxp.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261013103003.373156-8-larisa.grigore@oss.nxp.com>

On Tue, Oct 13, 2026 at 12:29:58PM +0200, Larisa Grigore wrote:
> +  clocks:
> +    maxItems: 1
> +
> +  clock-names:
> +    items:
> +      - const: core

I don't get why you added the clock-names.

> +
> +required:
> +  - compatible
> +  - reg
> +  - reg-names
> +  - clocks
> +  - clock-names
> +  - operating-points-v2

Your opp-table is empty, so requiring such property looks like wrongly
written driver.

> +
> +allOf:
> +  - $ref: ufs-common.yaml
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    ufshc@4ac80000 {
> +        compatible = "nxp,s32n79-ufshc";
> +        reg = <0x4ac80000 0x1000>, <0x4ac40000 0x1000>;
> +        reg-names = "ufshc", "scm";
> +        interrupt-parent = <&irqsteer_coss>;
> +        interrupts = <211>;
> +        clocks = <&clks 0x92>;
> +        clock-names = "core";
> +        operating-points-v2 = <&ufs_opp_table>;
> +
> +        ufs_opp_table: opp-table {
> +            compatible = "operating-points-v2";
> +
> +            opp-0 {
> +                opp-hz = /bits/ 64 <0>;

Best regards,
Krzysztof

