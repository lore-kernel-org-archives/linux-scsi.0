Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461043EB0FE;
	Mon,  6 Jul 2026 06:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783320235; cv=none; b=B/dEM0yXoYAtMFkA3+iSCWukwaQru26Bo3bdWXL5g8956QRUauBJEnA2ZWuk/tR5STH+92Pm+gUtyK8hjaglGMdnjpD7AxqhF18hF+cigGVJsGJuKblAQTkuMf9KSMYACEjuf8B/ZkK/BkF1ytWO4mK8fcQ1jmLdJsNWMEZOTiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783320235; c=relaxed/simple;
	bh=+M1cAc0OUzlIoNcUnqrbzKbXqjVKjITMqA9/Swf4wSg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kzz94i0sNua6tB096H/8wc1Eet7h9T/yR9HOOiuUuzYE6o2Z1dzhekRLDEWdNvTz8MBhqggiZDdxbm1JoRYAoIx+W68TDYoO1ifEOXIUtgwMRu8Bl5TCHtSJQveOQWo9ApLcw7gEzp3oALajXzOb/UDm8vRhe4y+vbbzUMsTEF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FridrF+2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FridrF+2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D601F00A3D;
	Mon,  6 Jul 2026 06:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783320229;
	bh=TumID3UOwbKJByG8LTYX/LOPxNfTfe26ymFWKPV79a0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FridrF+2y1DJUyj5T8Posaa1JEK8RacQbjRY4e9lh2GoBuJMH4wcXADxHwbSslNCe
	 5J6oaSMFkF5bRDn7dgNO8rWnth5l+KNLUO8LO0tI7eUQ8M8UonhUKp+zl13iNCyKG+
	 ig4z+WJ0D+8sM74K+YRWahcdIqcosv70+k6c4NJyb+z8nGrjaksfSYC5rBii8LvBmd
	 tGrhlAii0sgaXQO76r3VtbUwFOzR/ChxzqzrCC6OTbpGJbd47uC3zJAAdduA9QT/J3
	 A6dsYz8qyuZEMmPlXb+5q0KEOh1w6hyF+CPx/tfJPDsrjNxIKP6Nl39PCNJ6AaSDMy
	 BZBGomyAkSTBw==
Date: Mon, 6 Jul 2026 08:43:44 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
Cc: krzk+dt@kernel.org, robh@kernel.org, andersson@kernel.org, 
	mani@kernel.org, alim.akhtar@samsung.com, bvanassche@acm.org, avri.altman@wdc.com, 
	conor+dt@kernel.org, linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH V1] scsi: ufs: dt-bindings: Document the Maili UFS
 Controller
Message-ID: <20260706-curious-festive-ringtail-dd8fe4@quoll>
References: <20260630220536.3803984-1-nitin.rawat@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260630220536.3803984-1-nitin.rawat@oss.qualcomm.com>

On Wed, Jul 01, 2026 at 03:35:36AM +0530, Nitin Rawat wrote:
> Document the UFS Controller on Maili SoC.
> 
> Signed-off-by: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
> ---
>  Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml | 2 ++
>  1 file changed, 2 insertions(+)
> 

Why is MMIO address space size flexible here?

A few previous Maili bindings had the same problem - your Claude vibe
coding just looks at one piece and you do not review but trust that LLM.

So again the same comments as other Maili bindings.

Best regards,
Krzysztof

