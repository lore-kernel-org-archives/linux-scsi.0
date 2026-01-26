Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2452FF151;
	Mon, 26 Jan 2026 14:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769439187; cv=none; b=BU8T3D4Yn3aoo0xQpFXzRaIK14c0/MCquOgkVF2CSdtHDI0/i+8LEnlxP6J/aKFFAFQCID0WaoSq9XKiZWiU0k89IcwZmsLraoc66KENhPg0LSm13hsdg176yjouJZUpj+etXXUuvrWrQ6SefyLEUwZL9+RgxPi/sFtSlLcrZc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769439187; c=relaxed/simple;
	bh=GT4929KDy5PqpA3gBq0fVgekZu4eZCi/voc1Cx4I1as=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=koYJ5BNyvw2c7PPLOL7WD2OaIVUa5s5epV5g6UdvsYXnloP1v9w0vLbcP6De/3fDD8x6GFLGvtH+qZoAmKNGrAiXo9wRgvli18/mrnOrQMWrJU6cBQd/R8nN2CUyniFXn83HNUBN3sy/ojOhbekYwPztGXd66ZW1eN/qXAOqyFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=evbz8Uvy; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="evbz8Uvy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1769439184;
	bh=GT4929KDy5PqpA3gBq0fVgekZu4eZCi/voc1Cx4I1as=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=evbz8UvyEOzZnE8SFDytJikkrW3Jv2+T+Upwsc0bmWbMVnRwWI/rL4PzxBGPqGN67
	 TqgPDewslKzVt5kjkQMlif7DE78SRyG4ieTFEjvsnvrD2P3gO7TNZ2EqRZOGpN/lKT
	 a04mgYXnvWsY1w7Yp9R+ApIwHVODnC7irlYBch/EJPGoF+lyGCQl08VOvfcVdLgCcT
	 8cBFewH2kEjmq9STmuVf5zY0VkGEG428LwE0vwd2NQLuMAthnSK2UhzH8uTqiE7OZt
	 EC23/BpmiXZKrYi22uo8waLPT5IP1IZTOG8eeJ0Q03es8v55ZOlgevD+NhrWjwvZBW
	 Lk+a0XH20hbbQ==
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 50B0117E0E6C;
	Mon, 26 Jan 2026 15:53:03 +0100 (CET)
Message-ID: <0fe71377-df0a-4e8e-a787-73455eddc133@collabora.com>
Date: Mon, 26 Jan 2026 15:53:02 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 23/24] scsi: ufs: mediatek: Remove undocumented
 "clk-scale-up-vcore-min"
To: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Matthias Brugger <matthias.bgg@gmail.com>,
 Chunfeng Yun <chunfeng.yun@mediatek.com>, Vinod Koul <vkoul@kernel.org>,
 Kishon Vijay Abraham I <kishon@kernel.org>,
 Peter Wang <peter.wang@mediatek.com>, Stanley Jhu <chu.stanley@gmail.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Philipp Zabel <p.zabel@pengutronix.de>, Liam Girdwood <lgirdwood@gmail.com>,
 Mark Brown <broonie@kernel.org>, Chaotian Jing <Chaotian.Jing@mediatek.com>,
 Neil Armstrong <neil.armstrong@linaro.org>
Cc: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
 kernel@collabora.com, linux-scsi@vger.kernel.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org,
 linux-phy@lists.infradead.org
References: <20260124-mt8196-ufs-v6-0-e7c005b60028@collabora.com>
 <20260124-mt8196-ufs-v6-23-e7c005b60028@collabora.com>
From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Content-Language: en-US
In-Reply-To: <20260124-mt8196-ufs-v6-23-e7c005b60028@collabora.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Il 24/01/26 13:01, Nicolas Frattaroli ha scritto:
> The MediaTek UFS driver contains support for an undocumented,
> non-vendor-prefixed u32 property named "clk-scale-up-vcore-min".
> 
> Since it is not part of any binding, and would not pass a bindings
> review in its current form, remove it.
> 
> To return this functionality, it needs to be resubmitted in a series
> that also introduces it to the binding, and justifies what it is used
> for. Compatibility with downstream device trees is not a valid
> justification for its existence.
> 
> Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

Not sure what this is used for, because then UFS DVFS for gears should be managed
with OPPs (either dynamic or static) anyway, so the vcore (I guess this is the scp
vcore in dvfsrc regulators) should be scaled like so, without ugly init hacks like
the one that you just removed.

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>


