Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA71448822C;
	Thu, 15 Oct 2026 08:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792053890; cv=none; b=DB2U4jZOE6qHU63YkkHahZcszg65efaIMbuWcSdGSVIKAYbhyAjWYCoZ/mWZeSd6+q6pZcEQjWVU4u9BIqWngrBCC62UgAaHGlMu4jJmcoiKtcvi51Hy8LRjcvawuY1KjLBXB/GJ35YLfHO/Ok+bsWEJOX3iKabRFiPzf+yqYp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792053890; c=relaxed/simple;
	bh=cXZUFEFqZQRxuLGQs55LcLm/iOg9oZmy60i9XARmd+o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YCaI+cJ4zXCWvsLDInO+2Pe3Bk8yFZNvn9CJkGCspE2TpsuV+RJ9KX3G91o/3FGCXBIQrmdvfXOOafH5QgKpeP1TCl6FPNL35to79VmuaNrEBuvLZxyoxSsCpal6Xi7lJ7I+5WT+50FTR1ZF5/lioBVDFHHVkxJp8ai+Cg7rjkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L1zup2Fo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L1zup2Fo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4511F000C4;
	Thu, 15 Oct 2026 08:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792053889;
	bh=/+V20DFV5KmqtYyBbhJb85wqCLfg9fnPxzdn/tr5kCo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=L1zup2Foa+qnpqKJYziH6JSt6Q62mAZjn888akXceMvIy/nfa462P73dCgV427kbR
	 LV2LPCKJ7XoAN2aMJEJqFGoB/tmcZTDUZ/E/l2eilNIuLLNAZl3qr/oLLKod8hlR3g
	 26IcCFcdJKZz+gSb3h7QF2voeuzPIVAvAj5utOClBDZsL7Q5UJLI895/cYJVG5JUPH
	 Xa8bJiX7YGban2PEgkYIEEpcK0CuYFym8d00IOPvupYy4yAgLc03/9qabKVH10D3f0
	 Gw2RQA4egcJeUe8ww1/hZJqvKCgiaOyxzngCvTdLxinA5Q/GfB0XpRqyoK9cnTuAt+
	 Ixi8ld+Hs3TcQ==
Date: Thu, 15 Oct 2026 10:44:45 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Larisa Ileana Grigore <larisa.grigore@oss.nxp.com>
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
Message-ID: <20261015-observant-nickel-monkey-2a38b7@quoll>
References: <20261013103003.373156-1-larisa.grigore@oss.nxp.com>
 <20261013103003.373156-8-larisa.grigore@oss.nxp.com>
 <20261014-valiant-goose-of-revolution-efec17@quoll>
 <fa3a025b-0d82-42df-a4cc-e144d6a97b20@oss.nxp.com>
 <20261015-whimsical-amorphous-squid-6166c5@quoll>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261015-whimsical-amorphous-squid-6166c5@quoll>

On Thu, Oct 15, 2026 at 10:33:25AM +0200, Krzysztof Kozlowski wrote:
> On Wed, Oct 14, 2026 at 04:58:30PM +0300, Larisa Ileana Grigore wrote:
> > On 10/14/2026 2:10 PM, Krzysztof Kozlowski wrote:
> > > On Tue, Oct 13, 2026 at 12:29:58PM +0200, Larisa Grigore wrote:
> > > > +  clocks:
> > > > +    maxItems: 1
> > > > +
> > > > +  clock-names:
> > > > +    items:
> > > > +      - const: core
> > > 
> > > I don't get why you added the clock-names.
> > > 
> > Hello Krzysztof,
> > 
> > The properties, `clock-names` and `operating-points-v2`, are needed to let
> > the generic UFS platform code discover and manage the controller clock.
> > 
> > `ufshcd_parse_operating_points()` uses `clock-names` to create the
> 
> You have only one clock, so my point is that UFS code is just poor, but
> if that's the reason to mention its name, then just say that in commit
> msg... or probably the ufs-common should be fixed.

I see now that ufs-common already requires clock-names and it's needed
for PM opp, which cannot operate on indices, so it's fine.

Best regards,
Krzysztof

