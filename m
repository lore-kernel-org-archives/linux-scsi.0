Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2CA434A3D0;
	Tue, 23 Dec 2025 17:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766511552; cv=none; b=quT7ucJBoxwFlz1HPQinMfZHKUJd/xR39s4jOtcdSsM8XmLHTq5SGAL3ibqYuK+5kRRQ//nt0oqoVCHRK8M5yIbrSALxnxhhdLp7RjxWOBN60WU0tt8RKzmvTDkK5/1dB/bjwfRo872nmj7BzgJXswtzR1K4NGCeCqM+11RDk7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766511552; c=relaxed/simple;
	bh=4l8j43J/v5I79EoFnJnHTBkeHnsgVhfsiIRiJM6PJE8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I6sgBOt8wJOeRdov4G3TvCyMigFkrXjdtJ2xG/1NzssgdKdJLAqffd5eIXM9J3ItHFOOqI7X+xyPhOX1GeI8poCa4LIH2npr5Ex7PPjYR2QLZDQwGKor9n9++wgR1utQ/AC9UbEabyL12ny/tsuvJCCj+TVUirQNpFoYE8D0z1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jgTj6pjM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jgTj6pjM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83902C113D0;
	Tue, 23 Dec 2025 17:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766511552;
	bh=4l8j43J/v5I79EoFnJnHTBkeHnsgVhfsiIRiJM6PJE8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jgTj6pjMV/ybwPkT55KhAQMex7OYEaok9RWh3sF7f4izlJkRlnPywmAcN+2twXU5u
	 /vGOgpa1ohwGHG1zDucBp5MFyKzVvibOutJPMVHKvZ5WxMgj3FFe33zeXUYriRYWV1
	 38tchg5fUoUps/Ra78769QTK/sWeThL+MNVJN6yAnhs4ZSxaD0G8ClKvyedGz4dYcY
	 KVLDgzQl18Zs2uxzYnGnGmtfKkar8u6Zd8zGuEGx9Dyw6jQuPSroOh6mL2KWJKRWUG
	 gvaQ2kUMt31lTXwYLQZhJBtpGiSXS3sXky9inlFC+DUfKpnbknf4O1Qgw7BFTsF9XX
	 3Lvo9kpbogILw==
Date: Tue, 23 Dec 2025 23:09:08 +0530
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
Subject: Re: [PATCH v4 01/25] dt-bindings: phy: Add mediatek,mt8196-ufsphy
 variant
Message-ID: <aUrTvAPcHNkyuTol@vaman>
References: <20251218-mt8196-ufs-v4-0-ddec7a369dd2@collabora.com>
 <20251218-mt8196-ufs-v4-1-ddec7a369dd2@collabora.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251218-mt8196-ufs-v4-1-ddec7a369dd2@collabora.com>

On 18-12-25, 13:54, Nicolas Frattaroli wrote:
> The MediaTek MT8196 SoC includes an M-PHY compatible with the already
> existing mt8183 binding.
> 
> However, one omission from the original binding was that all of these
> variants may have an optional reset.
> 
> Add the new compatible, and also the resets property, with an example.

Acked-by: Vinod Koul <vkoul@kernel.org>


-- 
~Vinod
