Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7A624E4AF;
	Tue, 24 Feb 2026 12:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771936920; cv=none; b=GFn8O2nBQNXc8mXBbIHEQoF5vjuk05a5DSPFM1+MCtFzZ6pLz0dPk/3v8UQEcMO2MzcJgVk8YVzB6LXVbCaEew9fKxU8dKsu5PuGWGz9iVeBb72bBteo85mJHiuwIhWSf5uF6zmLxVxBLEU3OavXrJea1Q5cQ4iy010a/iyILN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771936920; c=relaxed/simple;
	bh=frB8S6YZv/co/jpO+5WGrKt5NldRYnBoH/LpqHatns4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=romTSytFAEmPgwL8qbjJgZDd/oppjfDVf9bIa7XuZ/iJ4jo2D5kPckELmrhq1TifgLdwioIB2ekutwYc56ofc9WnH4LeYr6c2oQbfU1PO7VdaZa5xXjHxjHjcrSOw2kFw7b2WmMRz61t21uL09RYpfSYwrfQ6dfOZh+DoFWIDAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=Hofm1Fmk; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="Hofm1Fmk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1771936912;
	bh=frB8S6YZv/co/jpO+5WGrKt5NldRYnBoH/LpqHatns4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Hofm1FmknMdxMcYB2Z9ugTxcQrVBLUQ58wZjxd6lEJIY0Boufzx4xMv4R8B9QniKX
	 xUO2t55T1YHIicluD5f6tlcEch2cxVBzHYJ0yWpYWdvg9paQFmi6nptrAoOKpNoYT6
	 YmYULapPXMJfwekKZWfPwYYNdfLOzqI42ZqNyG67I0VyOddjJf3eOQXVrUGsJFamEN
	 LLWBBVeSkvUxguMDWCs/1LuEev+Bmjw+zIXTQT1OwP89ubC5BQe6utspBMEn9xlG7/
	 ebFtKS6XI5jWeiIbljCQx8CjAwNc5qYAz738Gg8cK/hlmVrWx4T/qNh+IEYhr3BbG6
	 FJoruteFLdhOA==
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 52F4A17E06CA;
	Tue, 24 Feb 2026 13:41:51 +0100 (CET)
Message-ID: <24445e6d-c308-4df2-8b3e-7ee8a8e3f2fe@collabora.com>
Date: Tue, 24 Feb 2026 13:41:50 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 10/23] scsi: ufs: mediatek: Handle misc host voltage
 regulators
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
 <20260216-mt8196-ufs-v7-10-b5f2907c6da7@collabora.com>
 <2c7c84a2df19624ba9f207fd3fee47a8bdd9d8dc.camel@mediatek.com>
From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Content-Language: en-US
In-Reply-To: <2c7c84a2df19624ba9f207fd3fee47a8bdd9d8dc.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Il 24/02/26 13:38, Peter Wang (王信友) ha scritto:
> On Mon, 2026-02-16 at 14:37 +0100, Nicolas Frattaroli wrote:
>> @@ -1188,8 +1190,21 @@ static int ufs_mtk_get_supplies(struct
>> ufs_mtk_host *host)
>>   {
>>   	struct device *dev = host->hba->dev;
>>   	const struct ufs_mtk_soc_data *data =
>> of_device_get_match_data(dev);
>> +	int ret;
>> +
>> +	if (!data)
>> +		return 0;
>> +
>> +	if (data->num_reg_names) {
>> +		ret = devm_regulator_bulk_get_enable(dev, data-
>>> num_reg_names,
>> +						     data-
>>> reg_names);
> 
> Hi Nicolas,
> 
> If these regulators are only acquired and enabled once,
> why not just set regulator-always-on in the device tree?
> 

Because:
  1. The UFS driver has to acquire the correct supplies regardless of them
     being on, guaranteeing both a readable power tree (sysfs/debugfs) and
     a correct hardware description in devicetree.
  2. A future update might get those regulators disabled during deep sleep

Regards,
Angelo

> Thanks
> Peter
> 

