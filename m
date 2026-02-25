Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9F73AE6F0;
	Wed, 25 Feb 2026 12:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772023468; cv=none; b=VEuTxi6b0z2INiz4uFAo1b7gC/Fg/kNZzwP2F9y1zUM6GMu2RH9CPnSOea1m4G0xi78MmDgw3OvCHMPxthaYX1vokVKPfed19cS2IPPlwfNRmlVGHWpiE2xqQeHzoNYu+lGO54fsA/Thzgf/HQzdXMCO6uIRSgGBZrG6R2oQcCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772023468; c=relaxed/simple;
	bh=wJo7H+wg7oWjDPXBu3O5+/hGWpnIf4Wz8/+O3JhSsoY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lTogt2hrJ+P3RgIV0DeVHygudOl0NWxid49tx7xrCIXEOIQ34AuaFUgE6SIi90wZWWArgU/OxdtJzMLTSmmdpkyvsGMJI5IkGawNGGQ78TeFpDBokU/lnxYcVxU/Ygoy4VuY4pNWMRM4w2N8sk5aejglv2WGRFetic1hhya0JZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=ROxU34RD; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="ROxU34RD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1772023459;
	bh=wJo7H+wg7oWjDPXBu3O5+/hGWpnIf4Wz8/+O3JhSsoY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ROxU34RDm7sR9Vf1z2KVIJOAc33DQRkColUGHO9bPXNdfSXDKCWB+kgKzU/2LahbC
	 IN2jKNzQGcZbLJ9PVmjr3InHvPCLUq/KKnrb8n5HYQg5Lh5ftnWAzx8chNslc9RTVq
	 NfzXDc5kK9IQcM/6uZoFCAQoTrm9pGb9fLjUgJ8kRqEL6oY5uDdn+XkRWCqK7eyZk6
	 eO4ja1rhXmf0aTJhPhhqnL3lckGI/QJKVaTWxkIXtFVzIVhdEgGWpqM9a6bQGuxz/F
	 ghh74A4oAgJgKSFzLwI/sXuUDRZkWBTEhNID/9IlYsvGoFNAeXsmUakRKmQeXcQJBb
	 0tJf+Pq55HDKA==
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits))
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id AEEBE17E012E;
	Wed, 25 Feb 2026 13:44:18 +0100 (CET)
Message-ID: <821f0078-9d4d-4548-ae6f-5f43cf5bcd6d@collabora.com>
Date: Wed, 25 Feb 2026 13:44:18 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 22/23] scsi: ufs: mediatek: Remove undocumented
 "clk-scale-up-vcore-min"
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "chu.stanley@gmail.com" <chu.stanley@gmail.com>,
 "robh@kernel.org" <robh@kernel.org>,
 =?UTF-8?B?Q2h1bmZlbmcgWXVuICjkupHmmKXls7Ap?= <Chunfeng.Yun@mediatek.com>,
 "kishon@kernel.org" <kishon@kernel.org>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "bvanassche@acm.org" <bvanassche@acm.org>,
 "neil.armstrong@linaro.org" <neil.armstrong@linaro.org>,
 "conor+dt@kernel.org" <conor+dt@kernel.org>,
 =?UTF-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
 <Chaotian.Jing@mediatek.com>, "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
 "nicolas.frattaroli@collabora.com" <nicolas.frattaroli@collabora.com>,
 "vkoul@kernel.org" <vkoul@kernel.org>,
 "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
 "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
 "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "broonie@kernel.org" <broonie@kernel.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>,
 "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
 Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
 "kernel@collabora.com" <kernel@collabora.com>
References: <20260216-mt8196-ufs-v7-0-b5f2907c6da7@collabora.com>
 <20260216-mt8196-ufs-v7-22-b5f2907c6da7@collabora.com>
 <e452951498ae82433337ca428bd49c7358194dd8.camel@mediatek.com>
From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Content-Language: en-US
In-Reply-To: <e452951498ae82433337ca428bd49c7358194dd8.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Il 25/02/26 11:37, Peter Wang (王信友) ha scritto:
> On Mon, 2026-02-16 at 14:37 +0100, Nicolas Frattaroli wrote:
>> The MediaTek UFS driver contains support for an undocumented,
>> non-vendor-prefixed u32 property named "clk-scale-up-vcore-min".
>>
>> Since it is not part of any binding, and would not pass a bindings
>> review in its current form, remove it.
>>
>> To return this functionality, it needs to be resubmitted in a series
>> that also introduces it to the binding, and justifies what it is used
>> for. Compatibility with downstream device trees is not a valid
>> justification for its existence.
>>
>> Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
> 
> Can MT8196 work on Gear 5 without raising Vcore?
> I'm afraid it might cause problems.
> Maybe we can add the correct binding for MT8196?
> 

Might cause problems as much as literally on every other MediaTek SoC with the
current version of this driver.

Besides, the right way of declaring freq<->voltage relationship is with OPP
tables, not with custom properties invented out of the blue - and support for OPPs
being generic is already supported in UFSHCI, so... moral of the story:

As long as the platform is correctly configured in the devicetree, it's going to
work without any kind of issues.

Regards,
Angelo

> Thanks
> Peter


