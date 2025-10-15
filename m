Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87975239E7D;
	Wed, 15 Oct 2025 08:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760516742; cv=none; b=XMnr8mqbl+h67hcyHyyLTEqs2KpsH3J5SCK5sDrP2NI2+jlhOhz5tjsf4XTgtp23i5muRWENvCrDqTeEMI7p+g+Qo+dj1Uq/HjskR7alHjxoPYQmpzfxVGbvvZDVLqQMRmi9nvL7VsIbo2jT7vtUnmKlei6n9AEVJ0OOVbpJdkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760516742; c=relaxed/simple;
	bh=C5vRLQ73Rs9hSl/5ofntob1CHll5VuYEA+yisHg++58=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R6/zKIi9PbuMlZN2a/ePiB3Z2QDrfFvCzD5HHKtB+I4+6F421rhN2R1q01uVINCj+bAQ1CZPR9s2Gt73sTcOC+XJCQncJQICo+3ZifFsOpIfTDfxJLuD+7MwuBYhDPQC3O+svHesQoSGpIlQCMy6KstNlwZH3COVFSx4IXMceRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=PU7G/s2k; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="PU7G/s2k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1760516738;
	bh=C5vRLQ73Rs9hSl/5ofntob1CHll5VuYEA+yisHg++58=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PU7G/s2kkMnYb46jq+l1lYGjvPgImVi99loaaI/Nwb5d0V2jEqq2zM2GBioEMhQmq
	 AgHYZ6Yn8pf4uNRhjQqrJxSLWT8qINRw0mzJlmqgxyHDA6/3P2KGezVZCRW8/TZPJW
	 ybi7fkKXcvsW2E96/N4uWJGkzX3AnUtlVEV42Rv8QB6aKNXrR3IJWDF5YsUZCr9EoV
	 JNdLli+/LB1yauQmEG8g5G1Cpkpw78EnALCMs15DDq9IGz9+vFI/UQCz0AcGJm1jAp
	 kYTFFDT1odfonbP/+ymFDg5ioWOz502ofSFrOchuxSXmHZDGPG44eKPHaqxP9OyGU0
	 P4avD0/ddtEyw==
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id AF73F17E055D;
	Wed, 15 Oct 2025 10:25:37 +0200 (CEST)
Message-ID: <b5fe44f0-f733-46f3-9436-37aea1330aad@collabora.com>
Date: Wed, 15 Oct 2025 10:25:37 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] MediaTek UFS Cleanup and MT8196 Enablement
To: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Matthias Brugger <matthias.bgg@gmail.com>,
 Stanley Chu <stanley.chu@mediatek.com>,
 Chunfeng Yun <chunfeng.yun@mediatek.com>, Vinod Koul <vkoul@kernel.org>,
 Kishon Vijay Abraham I <kishon@kernel.org>,
 Peter Wang <peter.wang@mediatek.com>, Stanley Jhu <chu.stanley@gmail.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Philipp Zabel <p.zabel@pengutronix.de>
Cc: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
 kernel@collabora.com, linux-scsi@vger.kernel.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org,
 linux-phy@lists.infradead.org
References: <20251014-mt8196-ufs-v1-0-195dceb83bc8@collabora.com>
From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Content-Language: en-US
In-Reply-To: <20251014-mt8196-ufs-v1-0-195dceb83bc8@collabora.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Il 14/10/25 17:10, Nicolas Frattaroli ha scritto:
> In this series, the existing MediaTek UFS binding is expanded and
> completed to correctly describe not just the existing compatibles, but
> also to introduce a new compatible in the from of the MT8196 SoC.
> 
> The resets, which until now were completely absent from both the UFS
> host controller binding and the UFS PHY binding, are introduced to both.
> This also means the driver's undocumented and, in mainline, unused reset
> logic is reworked. In particular, the PHY reset is no longer a reset of
> the host controller node, but of the PHY node.
> 
> This means the host controller can reset the PHY through the common PHY
> framework.
> 
> The resets remain optional.
> 
> Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

While series is

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

Cheers,
Angelo
