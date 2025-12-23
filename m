Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38CF734D397;
	Tue, 23 Dec 2025 17:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766511586; cv=none; b=Ce/Rg+C/DA4Z5DQsRs5HkcQCDPdkwvWWHU1K93rwGxPTM4jjHhWc2SLSU0JBDwLXsTPCK7kHjbjXxTOwWAdnYSmQAsnQ29N1bdvd590h7p6EaO/xx9HKBWaQNGUk2jCm1bieDnCfnF4tFdj5Zm63zZWoa1tJOpQeck6H6mbLKXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766511586; c=relaxed/simple;
	bh=WPIIbHhicQ4q0GfMB7fVvQcBaHETS4fW+aGWxz9VUuY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=utK+Q9OgK8Y8VozMkMwMboROibs1Gr154imYqrzZdqM5pljp2wPSfHWfvAd3glshWvTmzrKuqrht9pj5aUlO8bDy+ow9l5gl5OOI8iV4gIQ/JsrDDsmrq+SuDRNlZKZlUMih3M2MktqBorLfdc80qFzJ1k9kKJLAvhzpmkMPOMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZLoULeoD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZLoULeoD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D560C113D0;
	Tue, 23 Dec 2025 17:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766511586;
	bh=WPIIbHhicQ4q0GfMB7fVvQcBaHETS4fW+aGWxz9VUuY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZLoULeoDl0jWzW9UgdeJyBBc0qLT/4rRqsjFYSqDo+AfDoSREU+PQxuqcS3VE2wxN
	 3A/pKf51i56JXCA9jt36TqfXQqcHVVpFIPZMx+Y9zPrTWxocb87FrU6/33m36VJ//7
	 hm3x3qM7wZx5dn9KMaUArGIRyB6rMiJa9BoadNwjS8Yr+6POlFYsayswKvc/ZvymbR
	 fbG73cVWu10I5zX+57VHql0rOSp9eFnxUzFWDCZxrkoCi3EQT6raPj5g1oKropzaOR
	 yaXin8Lh4SqAMEV7TH/urOnyUer9RK12dO36BvdeC/7/PllKuVdwtH+l6VGnBYzwb3
	 yoVcTBfUbFAeg==
Date: Tue, 23 Dec 2025 23:09:42 +0530
From: Vinod Koul <vkoul@kernel.org>
To: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chunfeng Yun <chunfeng.yun@mediatek.com>,
	Kishon Vijay Abraham I <kishon@kernel.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Chaotian Jing <Chaotian.Jing@mediatek.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
	kernel@collabora.com, linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, linux-phy@lists.infradead.org
Subject: Re: [PATCH v4 03/25] dt-bindings: ufs: mediatek,ufs: Add mt8196
 variant
Message-ID: <aUrT3pd_rCp_7CQI@vaman>
References: <20251218-mt8196-ufs-v4-0-ddec7a369dd2@collabora.com>
 <20251218-mt8196-ufs-v4-3-ddec7a369dd2@collabora.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251218-mt8196-ufs-v4-3-ddec7a369dd2@collabora.com>

On 18-12-25, 13:54, Nicolas Frattaroli wrote:
> The MediaTek MT8196 SoC's UFS controller uses three additional clocks
> compared to the MT8195, and a different set of supplies. It is therefore
> not compatible with the MT8195.
> 
> While it does have a AVDD09_UFS_1 pin in addition to the AVDD09_UFS pin,
> it appears that these two pins are commoned together, as the board
> schematic I have access to uses the same supply for both, and the
> downstream driver does not distinguish between the two supplies either.
> 
> Add a compatible for it, and modify the binding correspondingly.

Acked-by: Vinod Koul <vkoul@kernel.org>


-- 
~Vinod
