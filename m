Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A143AA1A1;
	Wed, 25 Feb 2026 13:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772025502; cv=none; b=gRHkpdcrnDYcRs/5/7yPqOZVCT71Kymqy8BmlKOXybb/tucmDT3Fb9vmTfnlgKd8IMmNVgiQss1845DAyxgXUgg0OdzfvXANowa9IZKG+IZA5s82EFMO08rZ9jWFwXn+IfVbRgFh3qpz2v4a29n80qgznn68mcSbCQwhKYjEd4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772025502; c=relaxed/simple;
	bh=OBPmVel8etDOsFPwy09vRPFiPn+XOTirLp8VxPuWQT8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nnjUS0MWMCFXfYvXctmemm08GrE5jg0M0bgBUlPFPqAxqIDG84kGVbI8cR7xuuWjL0d5W2wum8UvQIKv2ucG6Qh/imNl4hwztd3Yy6SIZ8UawwpjHxiHUZ1CvbKN0vUDmesoJBzl7fpw4dwXNzdSSdIgytT3ne6TpZt4OErE0ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=CXnqqRVO; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="CXnqqRVO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1772025499;
	bh=OBPmVel8etDOsFPwy09vRPFiPn+XOTirLp8VxPuWQT8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=CXnqqRVOU+5ZupZeqTybWiwyfo1yrPseMhCvtva473bH2wisFSulL2HVy9FKbSS1v
	 E41wbZNfMQm3KQxssJS21aB8or0/0zUL0Homdt9CXse6Zt/DtfZIv22FaUguvmDB9W
	 8ZzsrJK3J4R+3l5imK23d90P/YLdNoDxDdUg4nwxLPPOWkZbHqlkP2s3Q7DF4LsY7A
	 cDeqsAZhpvshMV65GGlgP3g9r5idEW/JfDkWy//f7GsbDfV2+5xWIwTlK8jUSqmnq5
	 B0R+3IcU5+SJoAIN4NRHXomy28whqZJsv+ehM5MvvHd45PddBXTyW64J4p6W5gIK7N
	 g8WnRnhJAuDEw==
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 1673117E03E6;
	Wed, 25 Feb 2026 14:18:18 +0100 (CET)
Message-ID: <f0e97a38-a11b-4e69-902a-e0ccd0dc4540@collabora.com>
Date: Wed, 25 Feb 2026 14:18:17 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 16/23] scsi: ufs: mediatek: Clean up logging prints
To: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
 "chu.stanley@gmail.com" <chu.stanley@gmail.com>,
 "robh@kernel.org" <robh@kernel.org>,
 =?UTF-8?B?Q2h1bmZlbmcgWXVuICjkupHmmKXls7Ap?= <Chunfeng.Yun@mediatek.com>,
 "kishon@kernel.org" <kishon@kernel.org>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@hansenpartnership.com>,
 "bvanassche@acm.org" <bvanassche@acm.org>,
 "neil.armstrong@linaro.org" <neil.armstrong@linaro.org>,
 "conor+dt@kernel.org" <conor+dt@kernel.org>,
 =?UTF-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
 <Chaotian.Jing@mediatek.com>, "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
 "vkoul@kernel.org" <vkoul@kernel.org>,
 "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
 "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
 "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "broonie@kernel.org" <broonie@kernel.org>,
 =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
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
 <20260216-mt8196-ufs-v7-16-b5f2907c6da7@collabora.com>
 <c333898413d249c017430d4ae98bc7be3bf33a64.camel@mediatek.com>
 <2575185.irdbgypaU6@workhorse>
From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Content-Language: en-US
In-Reply-To: <2575185.irdbgypaU6@workhorse>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Il 25/02/26 14:05, Nicolas Frattaroli ha scritto:
> On Tuesday, 24 February 2026 13:47:28 Central European Standard Time Peter Wang (王信友) wrote:
>> On Mon, 2026-02-16 at 14:37 +0100, Nicolas Frattaroli wrote:
>>>   drivers/ufs/host/ufs-mediatek.c | 99 ++++++++++++++++++-------------
>>> ----------
>>>   1 file changed, 43 insertions(+), 56 deletions(-)
>>>
>>> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-
>>> mediatek.c
>>> index ecf16e82a326..2b1f26b55782 100644
>>> --- a/drivers/ufs/host/ufs-mediatek.c
>>> +++ b/drivers/ufs/host/ufs-mediatek.c
>>> [... snip ...]
>>> @@ -810,11 +806,11 @@ static void ufs_mtk_mcq_set_irq_affinity(struct
>>> ufs_hba *hba, unsigned int cpu)
>>>   	_cpu = (cpu == 0) ? 3 : cpu;
>>>   	ret = irq_set_affinity(irq, cpumask_of(_cpu));
>>>   	if (ret) {
>>> -		dev_err(hba->dev, "set irq %d affinity to CPU %d
>>> failed\n",
>>> +		dev_err(hba->dev, "setting irq %d affinity to CPU %d
>>> failed\n",
>>>   			irq, _cpu);
>>>   		return;
>>>   	}
>>> -	dev_info(hba->dev, "set irq %d affinity to CPU: %d\n", irq,
>>> _cpu);
>>> +	dev_dbg(hba->dev, "set irq %d affinity to CPU %d\n", irq,
>>> _cpu);
>>>
>>
>> Is it more appropriate to use dev_info for state changes or for setting
>> changes?
> 
> Is this information a user would want to see in their bootup log in
> every case? My understanding right now is no.
> 
>>> [... snip ...]
>>> @@ -1571,7 +1559,7 @@ static int ufs_mtk_device_reset(struct ufs_hba
>>> *hba)
>>>   	/* Some devices may need time to respond to rst_n */
>>>   	usleep_range(10000, 15000);
>>>   
>>> -	dev_info(hba->dev, "device reset done\n");
>>> +	dev_dbg(hba->dev, "device reset done\n");
>>>   
>>
>> Is it more appropriate to use dev_info for state changes or for setting
>> changes?
> 
> Depends on your view of what's useful information for the user.
> 
> I can change both of these back to _info if I have to send out a next
> revision, just to get this through though.
> 

Definitely don't change that back to dev_info() as this is debugging information
that spams the kernel log for no reason.

This has to be dev_dbg().

Regards,
Angelo

>>
>> Thanks
>> Peter
>>
> 
> 
> 
> 

