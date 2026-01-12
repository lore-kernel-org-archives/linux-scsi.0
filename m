Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F482DD60F;
	Mon, 12 Jan 2026 15:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768230182; cv=none; b=eThKWYU/s6m56vw3wVr30zFrqkdyH09Llwmww/jQKMee7KvZ9j80c2JCbJ/9V77KVmVpbPO+M/ue3iw+t3QJu83Rfws06XxudjuoVyH+U9ocwVQriGgpya5I0WzYLPtQKe+F3YSLjURdQtIowVzeGwWtLZ/pAFXz7ejmPgk3RMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768230182; c=relaxed/simple;
	bh=L8or3v6iZqrpLG7v8P5SZLYbYdbPGHmvZtbWstQCXis=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XJHo1cSucI0O+/wEeuUQdSmtKYCbElQXhvwnZlhrgcmg+P2bBTPKtOaXoqF7PGqEa+Ih+1C+XoWRuoakWcZGP4TB0rSV7JkbMc3YABtZuJTg3s4o8nu1oiAQ7jM4PFrPARyXRmsGZCz83VtaDF+qZBsGEVJ4prq0X5fgowWpHRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=oFuM3PXQ; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="oFuM3PXQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1768230178;
	bh=L8or3v6iZqrpLG7v8P5SZLYbYdbPGHmvZtbWstQCXis=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oFuM3PXQ6KC4yt+dpdSV2jD9qpBTJQN12cbkZTyofIHJdFu9irgkEQSzuepDTp0Nz
	 0xiVCTtGtze+t+mMgNP/5st2JUv49OKCvT262OVD9VW9/0MI+slisJ3rLKCt5lHz9h
	 eN3PsNhsKw1Opd9tANFEcqIR9TYM/cOUz4ZY0tPlULcjDTGGEQLnY3ikCV/SSElYs3
	 d+NqlbjVFzZJo/IN7bGWmE7Okj5upYx9tEjamPNv60ZWu121Vi5Z1wxlgkKmCH+T2U
	 7vSwxZn6HnR55FYLoCZORcxBQmcsEU8Eu/nm1wjdFDZstYMPbFESsCgU83Um6MJ9OA
	 DGRQ62xDTZ+LQ==
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 9529717E138B;
	Mon, 12 Jan 2026 16:02:57 +0100 (CET)
Message-ID: <26c68bb1-1e63-4b47-babc-21ae27e3205e@collabora.com>
Date: Mon, 12 Jan 2026 16:02:56 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 11/24] scsi: ufs: mediatek: Rework probe function
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "chu.stanley@gmail.com" <chu.stanley@gmail.com>,
 "robh@kernel.org" <robh@kernel.org>,
 =?UTF-8?B?Q2h1bmZlbmcgWXVuICjkupHmmKXls7Ap?= <Chunfeng.Yun@mediatek.com>,
 "kishon@kernel.org" <kishon@kernel.org>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "bvanassche@acm.org" <bvanassche@acm.org>,
 =?UTF-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
 <Chaotian.Jing@mediatek.com>, "conor+dt@kernel.org" <conor+dt@kernel.org>,
 "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
 "nicolas.frattaroli@collabora.com" <nicolas.frattaroli@collabora.com>,
 "vkoul@kernel.org" <vkoul@kernel.org>,
 "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
 "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
 "krzk@kernel.org" <krzk@kernel.org>,
 "neil.armstrong@linaro.org" <neil.armstrong@linaro.org>,
 "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "broonie@kernel.org" <broonie@kernel.org>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>,
 "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
 Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
 "kernel@collabora.com" <kernel@collabora.com>
References: <20260108-mt8196-ufs-v5-0-49215157ec41@collabora.com>
 <20260108-mt8196-ufs-v5-11-49215157ec41@collabora.com>
 <81ed17eb-2170-4e97-b56d-488b5335ff5c@kernel.org>
 <dd2eba99adaddf7517f06acf7805d32e261fafa4.camel@mediatek.com>
 <87887adf-2c94-48c2-8f83-4e772ab50f60@kernel.org>
 <e9a6da3998195b9dbda5abd26bc6dd5d3aca07ff.camel@mediatek.com>
 <66ca211a-c909-4d0c-a22c-9cbd3489d372@kernel.org>
 <46cb450f92887ceba07614dc85ed495f6af7f602.camel@mediatek.com>
From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Content-Language: en-US
In-Reply-To: <46cb450f92887ceba07614dc85ed495f6af7f602.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Il 09/01/26 10:16, Peter Wang (王信友) ha scritto:
> On Fri, 2026-01-09 at 09:43 +0100, Krzysztof Kozlowski wrote:
>> On 09/01/2026 09:38, Peter Wang (王信友) wrote:
>>> On Fri, 2026-01-09 at 08:24 +0100, Krzysztof Kozlowski wrote:
>>>> On 09/01/2026 07:22, Peter Wang (王信友) wrote:
>>>>>
>>>>>
>>>>> Is it sufficient for us to supplement the ABI document?
>>>>> This ABI might affect the ability to reset and recover after
>>>>> an UFS error in upstream world.
>>>>
>>>>
>>>> In normal case yes, but I cannot imagine arguments justifying
>>>> your
>>>> usage
>>>> of TI properties. Basically it would not pass review.
>>>>
>>>> Best regards,
>>>> Krzysztof
>>>
>>>
>>> Yes, this part is indeed because MediaTek’s reset hardware
>>> implementation is the same as TI’s.

No, MediaTek's reset hardware implementation is not the same as Texas Instruments.
It was *very similar* to TI in the past (years ago, around the MT6795 Helio
generation times).

MediaTek's reset controller - by hardware - is definitely different from the one
found in TI SoCs.

Regards,
Angelo

>>> That’s why we used “compatible”
>>> instead of actually implementing MediaTek’s own reset controller.
>>
>> So that's another purely downstream code. Additionally very poor
>> quality
>> downstream code.
>>
>>> So, are you suggesting that we upstream a MediaTek reset
>>> controller,
>>> even though the code is almost identical to TI’s?
>>
>> If you ask about DT, this is already answered in writing bindings
>> document. You cannot use someone else's compatible. Was also re-
>> iterated
>> on mailing list bazillions of times.
>>
>> Best regards,
>> Krzysztof
> 
> Okay, we will correct these incorrect usages.
> 
> Thanks
> Peter
> 
> 
> 


