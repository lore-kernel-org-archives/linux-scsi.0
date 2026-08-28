Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C802D12EC;
	Fri, 28 Aug 2026 10:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787912954; cv=none; b=R/Tjej3eA3RuN1z/OUKgipULf89HLvpku7IxNbmlVskkrUd5uUN8XFp8o10GKm2vr9PaUqeHXutKo3qN3xKcW2t/Pzyi6rHMmXIaLF8m6mCi6rkmceeUK+9wRl9R553CDZ/oX6JbRDybpCrtMWLLaKVg/AyWpeCo3OaGA8qQUnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787912954; c=relaxed/simple;
	bh=BZ4e3BAM8WtvBRbCVZsWH8ycqPYsmV8yz4lnKdxgUT8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XHnX3w/C0eL+zlO3oA2S2DqaEoGHriOBfRB4ClCsXegla3yENquetV5FggJcPq/qr78tmwBEpQ2Pcdz0zdfu5faLdTz78uQaVqGnHhYf5O5MRMbzhcEui2C7FLWZo+E618f+koBWGfVpb+Up3Kn6vhoveFIBuLruhtxx4pztH4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DhGlpDid; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DhGlpDid"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5AB1F000E9;
	Fri, 28 Aug 2026 10:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787912953;
	bh=BZ4e3BAM8WtvBRbCVZsWH8ycqPYsmV8yz4lnKdxgUT8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DhGlpDidQLzWh8TNGr/UXa4orJ8My0d4LT2wsGgdpjOnnhzGZ/n5uIT/iCbu5EmDF
	 lJqqcNSK2zLvmd5Qkv8daRHRFsfZuIeVwYl3FT/M7xYJLdXhrLhhfZko3PztO9FogQ
	 YAvJ+NZILIhxQsjRfP9tuXpisbYiM2utYild6mb3FmAjtWg2hhEORnKJEmP/OLulqP
	 p2mtYzdgj2tInTJFQal/shyGFUJAETX+NCXLA2Pr4yrhwEVrMRUu5oHZDzBChm6+g8
	 sLbQHo0DOF6ZKrGyiHq6vOrbsu7ToQf37oxh2kwzuTTNhpQonOEyIcbGYZl2s1T55C
	 dhTw94bYmiNkw==
Date: Fri, 28 Aug 2026 12:29:10 +0200
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
Message-ID: <20260828-pretty-impetuous-dove-cfcd0e@quoll>
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
> Document the device tree binding for the NXP S32N79 DWC-based UFS host
> controller which is compliant with JESD-223D "Universal Flash Storage Host
> Controller Interface" v3.0.

Subject - Describe hardware, not platform drivers.

Best regards,
Krzysztof

