Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D895E3C1D61;
	Fri, 31 Jul 2026 08:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785486477; cv=none; b=cZO/+VikS6a7xumXxGgLY4vKgV/6yxtMNCIWpubluGV4B8xxC7yepKQtZsJAXS7FtlsviEqKeTn12JzdAUdHmtA1hYOVOTvNAIva5jT/LjtZfTAVYSChBtqEVconkO7FRUxZTomc9w6tRkP8zExgQBlMdvNIPAeTRVSXuDNe62g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785486477; c=relaxed/simple;
	bh=fe69X1I1Ec/+m6GQJUbe7ZMN9cnynljnmJzZwt1dUGY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q5dif9kFVosNaoNANrO2nPRWsE0uscHnx0Lg2tGQLZl0+rPFhUPofopoLnkiCQpKQLskNE64NvvIZkEWzp9vo68pTt9cM9+pSoJdb4CLUF2QxORqSMUdiHR4oJNq8EFqSeqlZ+WpXHfkwoor5xT5Taoc7AEJxG4Q2Zp9mUFaJIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KKTcuKiV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KKTcuKiV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AADB81F000E9;
	Fri, 31 Jul 2026 08:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785486475;
	bh=0FPsjGKiFGNpGHFVhapPvv4d0Php5/nsvTb7QDGoN5E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KKTcuKiVTYXYHZoic8lCmhkMod1LCT5ZZe3mmcFzCotvIANhyi1ax/vqL86dMJAEG
	 V5v632DxnnclqGfgOyZoN6HGozVwEzIQa122RR64uC80DN7oibAp+qbt1Qgqf3hMAT
	 0CdwFvUbzOuQPSiKXEZjs+WNsumICSubckjO1/9uamestgwda08We9vkKChJWfAtiP
	 CypAHYo6y45HvU/NRCJeVUzcg8DnxeC1fFHT1S2ZH+0kamt81gsVjss6POyci/LpmU
	 baNYWuo7G0jkiF+rzMx0mzWfGVMEOAgR7HsKsMOSYcrzUm2vIUkVOmf3mNn03CD2R+
	 Y4Tgdyu2P8ZMw==
Date: Fri, 31 Jul 2026 10:27:51 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Cc: Chunfeng Yun <chunfeng.yun@mediatek.com>, 
	Vinod Koul <vkoul@kernel.org>, Neil Armstrong <neil.armstrong@linaro.org>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Peter Wang <peter.wang@mediatek.com>, 
	Chaotian Jing <chaotian.jing@mediatek.com>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>, 
	Stanley Jhu <chu.stanley@gmail.com>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Philipp Zabel <p.zabel@pengutronix.de>, 
	Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>, kernel@collabora.com, 
	linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, 
	linux-phy@lists.infradead.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-scsi@vger.kernel.org, Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Subject: Re: [PATCH v10 03/26] dt-bindings: ufs: mediatek,ufs: Add mt8196
 variant
Message-ID: <20260731-fanatic-zealous-inchworm-ddfe0b@quoll>
References: <20260730-mt8196-ufs-v10-0-bc5ecef202dc@collabora.com>
 <20260730-mt8196-ufs-v10-3-bc5ecef202dc@collabora.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260730-mt8196-ufs-v10-3-bc5ecef202dc@collabora.com>

On Thu, Jul 30, 2026 at 11:48:59AM +0200, Louis-Alexis Eyraud wrote:
>  
>  examples:
>    - |
> @@ -177,3 +192,33 @@ examples:
>  
>          mediatek,ufs-disable-mcq;
>      };
> +  - |
> +    #include <dt-bindings/reset/mediatek,mt8196-resets.h>
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +
> +    ufshci@16810000 {

You already added second example. That's enough.

Sashiko reports are valid.

Best regards,
Krzysztof

