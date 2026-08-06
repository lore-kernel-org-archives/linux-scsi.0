Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631F5381EBA;
	Thu,  6 Aug 2026 07:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786002422; cv=none; b=Z1AtbaQVrACqZpXJ4V85mLAz7BIfNhtSGhy7P0mZueYatkW64oQ2GyDVke0C/59djcUsr55h6kwn67lMbXAip3TI6Q08XHoQFBXYeFMlPfMT1LBmfww9rXmYGVzAyyv9FhbU34DAHjBSnILEKtnfAFHgy0j/uWC/XozvR+88YHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786002422; c=relaxed/simple;
	bh=cVGrJHx5eNSMSKJ7gNU/Mw4tbIn/AOj/u8CdR6+Q+7A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WFkhvluHX3r54A9+zTO7haIKhuhZub1sYtOI3rk37uboXy4PIRem5WaYRmEeo+6AsiT5JcoYY804Wr4Ne8SvIJEgNVLgx5yJUS8kAnj5pGYY+5T10R/cX0qfquVWrAxOIsbeXZXUSeyBrx/yUVexQ2dHXiNT4Ykb/SxyChVVZeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G9k7hpxs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G9k7hpxs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6EF61F000E9;
	Thu,  6 Aug 2026 07:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786002421;
	bh=wMtX1g4kQRvpe1oyjMd1Y98xwvIKo8+2Xvfan9kHoZw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=G9k7hpxsq8xdO4+APUQWizUbYHmbvUum1id7Upke5bpFAZdY7TJ29WvAlemc2yWs6
	 kiu6B4db3jetW628b90l0cwlX3dyAPIUkYcDCcDFEFVA7Ws0oPN1SN9XO/7gSPAWxp
	 BQhjmWjWkvwWS+6JPfCT0prmpcT4tcNtY42m0sGP6VxkE7vIkdGrU5mO1bT2NOGjes
	 a/HFUlN4mQKPIoJWY8DT258ZFy2EgcicmK2dbsjvJYSnfOUJGay2tR017BQlVfPElT
	 4g9L3nRApPNnZ8RxEIzBVr8ALqE2DoL9tqsAz2oD/Lt90AsJnh5kU2QH94nE3qVBq6
	 4vJZUKcB6G69Q==
Date: Thu, 6 Aug 2026 07:46:57 +0000
From: Yixun Lan <dlan@kernel.org>
To: Krzysztof Kozlowski <krzk@kernel.org>
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
	Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Jennifer Berringer <jberring@redhat.com>,
	linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
	linux-riscv@lists.infradead.org, spacemit@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] scsi: ufs: spacemit: dt-bindings: Add UFS
 controller for K3 SoC
Message-ID: <20260806074657-GKA229492@kernel.org>
References: <20260806-08-k3-ufs-support-v3-0-037fb322acdb@kernel.org>
 <20260806-08-k3-ufs-support-v3-1-037fb322acdb@kernel.org>
 <20260806-prudent-vole-from-valhalla-3eae39@quoll>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260806-prudent-vole-from-valhalla-3eae39@quoll>


On 09:05 Thu 06 Aug     , Krzysztof Kozlowski wrote:
> On Thu, Aug 06, 2026 at 02:56:18AM +0000, Yixun Lan wrote:
> > Document the compatible for UFS (Universal Flash Storage) Host Controller
> > which found in SpacemiT K3 SoC chip. Its features are listed below:
> > 
> > - Compliant with MIPI UniPro v1.61 specification.
> > - Compliant with M-PHY v3.0 specification.
> > - Compliant with UFS HCI v2.1 specification.
> > - Supports up to 2 Tx and 2 Rx lanes, up to HS-GEAR3 5.8 Gbps per lane.
> > - Supports standard low-power hibernate to reduce power consumption.
> > 
> > Signed-off-by: Yixun Lan <dlan@kernel.org>
> > ---
> 
> You keep having the same failure for every version, no? Never responded to it...
> 
sorry, I should respond in previous series

for the Unexpected 'CLK_APMU_UFS_REFCLK' error, it depend on UFS clock patch[1],
also I've sent a PR to clock maintainer for inclusion to v7.3 [2], It should be
solved after v7.3-rc1 if all things goes well

Link: https://lore.kernel.org/all/20260630-06-clk-ufs-support-v1-2-cf7521d1d0fe@kernel.org/ [1] 
Link: https://lore.kernel.org/all/20260802014217-KYC2734409@kernel.org [2]
-- 
Yixun Lan (dlan)
