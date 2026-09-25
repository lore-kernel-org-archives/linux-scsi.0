Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0354233943;
	Fri, 25 Sep 2026 16:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790354599; cv=none; b=iW20VfJ6++dYf9idpVu3qEo/AmoT++I99jTaiQikN3GdJE2SH0thUbWGikUVICRPijFtzOY+VH05IgCKI8KGq54VVfFmxeDivoLnfcQBexETWKHWHmdHZxTNE4jDNE+2ub2pG+Qq5Mv8YMepfClOEsbqtsR3Llh06scv0wQlIpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790354599; c=relaxed/simple;
	bh=C0VoGDzcMAmv6Or+++plvdMsJr8cWNXzmxPzoPDA5cs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GDoNYNY1eyf0wHYni4Is5AO2fgU8E9huLHviAgxjvap1LdTOYcHphW1Gm+xoJA9rBma2zr/FEaDTAHvIbyXBiKKeHphPq5ZsenUAGtc3ZEmHbrt0kOLqldhihmJAghpZkdp771tb2YyVcJKgopqSg8hJhkmPXoZYKXOOfDV+3Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZC9r9L3i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZC9r9L3i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8697B1F00893;
	Fri, 25 Sep 2026 16:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790354593;
	bh=C0VoGDzcMAmv6Or+++plvdMsJr8cWNXzmxPzoPDA5cs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZC9r9L3ipKqdS4ni6DqvA4ARifkGSw3WL51f2A9NTR8yWW3oXp7kmpJ+2TUce3Uj7
	 7xo4sU9RrDyA5uUkuJi3bTrxMUrh0ygYjCX8UVIUwC6TOj1uk2fLT5Vtf8BrJtiI6I
	 HnZQZk0dN8jJJMZRQtPMc4aXQyd6h+j2jDZiJMQH4aqmdpayDnYfWHczqPw9RpyYr3
	 3KVRGwckY9cwViH9/0ZAJgJbvQdSuYLjWxuf6aR1CUelxCzwzd3Wurkpefw0jHxECU
	 sHT4X60LzL+/eDFST9Nxpe4mtszcg4jPEBcSLrjp55c7JeGsfBld+PNflsCTVCJSeD
	 57aXjMA9rW1mA==
Date: Fri, 25 Sep 2026 17:43:05 +0100
From: Conor Dooley <conor@kernel.org>
To: Larisa Grigore <larisa.grigore@oss.nxp.com>
Cc: NXP S32 Linux Team <s32@nxp.com>, Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, Frank Li <Frank.Li@nxp.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Ajay Neeli <ajay.neeli@amd.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Pedro Sousa <pedrom.sousa@synopsys.com>,
	Joao Pinto <Joao.Pinto@synopsys.com>,
	Hannes Reinicke <hare@suse.de>, linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	imx@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-arm-msm@vger.kernel.org, clizzi@redhat.com,
	aruizrui@redhat.com, eballetb@redhat.com, echanude@redhat.com
Subject: Re: [PATCH v6 07/12] dt-bindings: ufs: Add NXP S32N79 UFS host
 controller
Message-ID: <20260925-afoot-tinsel-096f8efd16d3@spud>
References: <20260925143534.3298540-1-larisa.grigore@oss.nxp.com>
 <20260925143534.3298540-8-larisa.grigore@oss.nxp.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Dh1WmLbrcdsVY8Bn"
Content-Disposition: inline
In-Reply-To: <20260925143534.3298540-8-larisa.grigore@oss.nxp.com>

--Dh1WmLbrcdsVY8Bn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Acked-by: Conor Dooley <conor.dooley@microchip.com>
pw-bot: not-applicable

--Dh1WmLbrcdsVY8Bn
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCarakmQAKCRB4tDGHoIJi
0rwoAP0dM83jHfdNPJ071+EP930GYRzZ/9MxGHj9aiDL/l2yaAEA72eN8EreupVH
+nObbELyyrwyJ6xSnymW3QYolOyVhAk=
=8Spa
-----END PGP SIGNATURE-----

--Dh1WmLbrcdsVY8Bn--
