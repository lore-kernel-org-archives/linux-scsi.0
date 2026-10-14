Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD563559D6;
	Wed, 14 Oct 2026 11:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791976084; cv=none; b=EsbiCnAsMyxGWHvMh3ONrt2IV+moGVtM+ILpQ76AzcMGEdh/5IoAE+PEd5Jv8FZ3BDtYozl/GWpnRuHVZ7PqANWzv4+r9WAdzFHiX2TE8z+RXAAZtwe4mWgIagmPoeawqf73K56Ei8zt0oL18lErjlNc8Q0HXh2H6K9lHvHbPOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791976084; c=relaxed/simple;
	bh=hgOXJRU3orsh1NBI3pvqUZkT3IhMcVU+D3dD+oX8nOM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BbFttoxnJ5+vkCfrBVE35FzaKS1iod41oafLK3MMpDHQUMvi2OUfGLdFF5k6R8HZaEWTIYoqHPem42yA52WTBiN1qMHTTLQIO8nhZSxO0uWVVBvFDs0FK676t9ZfCkLmF4Kb5WPQfTc+2t0UZ3hEU0+1P/GkT526x88ma1s0JEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ng3ouawJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ng3ouawJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F2901F000FF;
	Wed, 14 Oct 2026 11:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791976083;
	bh=i7Vm/ipdb4RFbngEiBrM2Kbqpue79Aa2GGMxvAz8GqY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ng3ouawJCasVk7LgevL638CVuYV2h9W2toQaDaf4h0VXW3vBcDbYVYF/0Zmh1con/
	 fkvVhefWbxAgmOaQDW+O+QkHdnJvQXGWBzvAk5v/pnTeFGLEvxrh3TQ6HRPszhhKFw
	 4TAJqaZuDOzqrB2owHGd8Rh0Wqu739LBOtnqHnCf5j8WiOh1r+ebHXkzCtg3LloYw1
	 lNlmWI/A/MOAPAd5XkPGIBl8d9T94XiGOLW6Ki4ATbV/AGcjkFWyubUI4zDO6lS+dr
	 8wxTu3i7bNm50rBFUxOpMENsL4pdj+XkbQ8IkcgXf4QlNvG3d58/Mn9tQyDUbuq0WI
	 gL+4QTDtwj3cw==
Date: Wed, 14 Oct 2026 13:07:59 +0200
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
Subject: Re: [PATCH v8 10/12] arm64: dts: freescale: s32n79: Add UFS host
 controller
Message-ID: <20261014-wonderful-elusive-hornet-c32e5a@quoll>
References: <20261013103003.373156-1-larisa.grigore@oss.nxp.com>
 <20261013103003.373156-11-larisa.grigore@oss.nxp.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261013103003.373156-11-larisa.grigore@oss.nxp.com>

On Tue, Oct 13, 2026 at 12:30:01PM +0200, Larisa Grigore wrote:
> Add the S32N79 UFS host controller node to the SoC dtsi.
> The controller remains disabled by default and is enabled by board dts
> files as needed.
> 
> Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
> ---
>  arch/arm64/boot/dts/freescale/s32n79.dtsi | 24 +++++++++++++++++++++++

DTS shouldn't be in the UFS patchset as they tend to grab everything.
Please split.

Best regards,
Krzysztof

