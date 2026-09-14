Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF32E4570D8;
	Mon, 14 Sep 2026 12:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789387448; cv=none; b=E5uxjt4EixY9kRPlmYq9WzcgV9duJQJIyNtXwpfQ0NOikNDpe7dRT6yygY43MbmeZe0XYjPtYSnIxvToDTsxXnFUlinaVZYrrNYluyovCgk3pP3pBPcXmeto2eHsC+EvuJJPiXM/SQ6gI9fEO+SxHTD2uLh8vehSF43zyLLg76Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789387448; c=relaxed/simple;
	bh=gKOpORfZZq9WL4GdKkT6J4ZawStjF0sjbadPfw+E4YI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KF5zXOeyI9xtsXN+J9FX3ujA19+x7EETxU1mqsUHJq1rQHYPBDz0w2Yyt75TkJqAdSz/0yMSqr4tMbjnBIvGDgCaes8H9PnfhJIHB4d20TWrYaeLXre8KEg5juElAl1cDA7/6+cRIoSn3P89s8pn+6vDVnyswAMgVOCxBU4nax4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=WOdQfsOx; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="WOdQfsOx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1789387444;
	bh=gKOpORfZZq9WL4GdKkT6J4ZawStjF0sjbadPfw+E4YI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WOdQfsOx/T0ceqL5oapOcdLeeiktULtm7ihs6SFh+NUe7Y/achPrLONtXSgaWdanO
	 NDfWJMUiA4gk4wNunkSvPqnZX8it41xUrl+r6OapZwOdrUlxsf3hCq6ELaE4wXM6yc
	 GzLDOkovTKeEjTAOp8CRXH1V7iGhF9WhrobFk0y4yecR9nQN2Q/toQk29E6ekCGDI3
	 beYlUSMdKVoyraor1bhH7ZTkAhqj8oqQFRuvadhAX6aObEDXXR0tzA0F2Z2C1ld9BH
	 7cUZtBoC7SRM4TuWcOVAyXJ+H6ib+Apq1uLVrbTon46L3wGmLPqONmylhoCWPojD3B
	 R3oIFKLp1hzaQ==
Received: from [100.64.1.21] (unknown [100.64.1.21])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange x25519)
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 04BFC17E091A;
	Mon, 14 Sep 2026 14:04:02 +0200 (CEST)
Message-ID: <94a11a7a-0f9e-40b5-aa1b-7d5be34c99ac@collabora.com>
Date: Mon, 14 Sep 2026 14:04:02 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 03/24] dt-bindings: ufs: mediatek,ufs: Add mt8196
 variant
To: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
 Chunfeng Yun <chunfeng.yun@mediatek.com>, Vinod Koul <vkoul@kernel.org>,
 Neil Armstrong <neil.armstrong@linaro.org>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Matthias Brugger <matthias.bgg@gmail.com>,
 Peter Wang <peter.wang@mediatek.com>,
 Chaotian Jing <chaotian.jing@mediatek.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
 <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>,
 Stanley Jhu <chu.stanley@gmail.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Philipp Zabel <p.zabel@pengutronix.de>, Liam Girdwood <lgirdwood@gmail.com>,
 Mark Brown <broonie@kernel.org>, Manivannan Sadhasivam <mani@kernel.org>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: kernel@collabora.com, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org, linux-phy@lists.infradead.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-scsi@vger.kernel.org,
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
References: <20260914-mt8196-ufs-v12-0-9279d7ef814d@collabora.com>
 <20260914-mt8196-ufs-v12-3-9279d7ef814d@collabora.com>
From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Content-Language: en-US
In-Reply-To: <20260914-mt8196-ufs-v12-3-9279d7ef814d@collabora.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/14/26 13:38, Louis-Alexis Eyraud wrote:
> From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
> 
> The MediaTek MT8196 SoC's UFS controller uses a different set of supplies.
> It is therefore not compatible with the MT8195. It also have an additional
> 0.9V supply pin (AVDD09_UFS_1), that is specific to this SoC, thus not
> currently described in the binding.
> 
> Add a compatible for this SoC and new property for the additional supply,
> and modify the binding correspondingly.
> 
> Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
> Reviewed-by: Chaotian Jing <chaotian.jing@mediatek.com>
> Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>


Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

