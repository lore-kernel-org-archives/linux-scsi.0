Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74904519AF;
	Thu, 15 Oct 2026 08:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792053210; cv=none; b=pL+j5uR3dY5JKfuq4NlrwNBRzBUOQrFTL6YNplu5a2M3ebdfJPRVTIWwxcXq0CLsbDM/XZDn3eLf7cYIoVzBFIz7/qHmWY4Kq325QUBEtj4LNqbqx/JZ9RTB0mUpjjibNV+z8M6KwiTWTZudfaEuySIjiao8+nX3QlVSNE1HPSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792053210; c=relaxed/simple;
	bh=j3srAWB0smoB0L9RdE+akBLmgDLIIcacMid+eoTKQ7w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LkpNiyffB2ccmKcwiNp0bSXIXkb593bCfd0UhJScTXgYXIHhmcKGVw6vuNe7kv0SpQuzzSv9XCUfgj+hNSV21TCeEYOc4DHAM3e7pi9wcahaTlrBnqDFuwW+IpBNqbn7hkGIdvT428FI6tOy8z4P39su7XfGT32uiWsgmQa7oWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JwtEX01X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JwtEX01X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1ADB1F000C4;
	Thu, 15 Oct 2026 08:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792053209;
	bh=3JJOFG+/Lcmrcjwm8gj4vFxpyUJmGEw18JAOdt4/SQI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JwtEX01Xl9e48pSRCYcm2j/QK8dOUtKk9gIbbrt0e+cI0HtWc5woePTnUwlnIFD+r
	 LCuP6mS0PzIqCUBYR/j3bI9eNvilXQxXsB+2j+XhvlVyoCFp73VIf/FqhA81fNIWOp
	 kfktbtd9JOrv5UKPQf8+ze7jKl0dE4h52zbvOmvWGaPMfIOXqQk5sAuD7+2lbZro0j
	 r+Y6V0lVwsSpiGBjMb+qHhy6A6lOlzPhvfFP+O/hkYk15csYbbi51FfT6zyBtp/tMC
	 a0TLdQHy1XJO7x/QBudtznXPhgxW+6htLFUJxQtL9gyJLeOpUGZ0Iczd5wGVKcElLF
	 LKYyUeJ1v6cVQ==
Date: Thu, 15 Oct 2026 10:33:25 +0200
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
Message-ID: <20261015-whimsical-amorphous-squid-6166c5@quoll>
References: <20261013103003.373156-1-larisa.grigore@oss.nxp.com>
 <20261013103003.373156-8-larisa.grigore@oss.nxp.com>
 <20261014-valiant-goose-of-revolution-efec17@quoll>
 <fa3a025b-0d82-42df-a4cc-e144d6a97b20@oss.nxp.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fa3a025b-0d82-42df-a4cc-e144d6a97b20@oss.nxp.com>

On Wed, Oct 14, 2026 at 04:58:30PM +0300, Larisa Ileana Grigore wrote:
> On 10/14/2026 2:10 PM, Krzysztof Kozlowski wrote:
> > On Tue, Oct 13, 2026 at 12:29:58PM +0200, Larisa Grigore wrote:
> > > +  clocks:
> > > +    maxItems: 1
> > > +
> > > +  clock-names:
> > > +    items:
> > > +      - const: core
> > 
> > I don't get why you added the clock-names.
> > 
> Hello Krzysztof,
> 
> The properties, `clock-names` and `operating-points-v2`, are needed to let
> the generic UFS platform code discover and manage the controller clock.
> 
> `ufshcd_parse_operating_points()` uses `clock-names` to create the

You have only one clock, so my point is that UFS code is just poor, but
if that's the reason to mention its name, then just say that in commit
msg... or probably the ufs-common should be fixed.

Best regards,
Krzysztof

