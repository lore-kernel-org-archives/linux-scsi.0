Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9E938911C;
	Mon, 16 Mar 2026 09:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773653689; cv=none; b=W9p/dO2NenHPlIIZAv6ARyuy4eM3gq205mGDnOjtNz7aHeHVmIbtTjTjXInxWVE/K89TBW88fd6IoNYAkYAVoNCbobLFqyYD8yZ44ex0JSTTZoG0SoNEiNwdW+GC5042UHu0ovNLfs8MHuu1dwkKgCXJp4JGAGze3/U2I/5V9yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773653689; c=relaxed/simple;
	bh=huznZbedhmfKAQ7o1PThsloEGLLlgDE3FaFdxbHkFzM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=us2aIcYvyIBfkBXqthdPDsdC0CdPrqAQelbuSU/C4f+AgmWVSszAkquaK6CrgmoZgInlGViLi+0QApIzKYTeTdYmV77rs8S7wzXDHP4G2ncEhhB6xP3xBI5VqDH01GyFB2pwLUFJPDO2UDsMNUVXzG8S41R6CV0cHQEqWH5pm0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=KVh9wOn6; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="KVh9wOn6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1773653685;
	bh=huznZbedhmfKAQ7o1PThsloEGLLlgDE3FaFdxbHkFzM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KVh9wOn6flNT06ymoubOrhTAc4HQuH2n0xoQOqvRKKGz3l4L4JyXkaQyt/I5gJGHy
	 q1gH4+D44ARcUdx6BB4s2Ls6kxck50Z4lBz9HtwSXt7zl71FDLdy1iLtPgAOjnt8Yw
	 md1peYXCFL5bjCSoTdqA8Ije8wf5cFEZtFrXLqht0jfh0bJyRe/dTl/x77D/M0u1hM
	 qAWf/3Ia48qQkh8e5rxXn1+bcrvjsGDLvM71CwedhfosOI4DErzMw0JRln+49FSkVb
	 gNqx+5UnbTE01bR3Y6zenuTDqRj6Y601tfI731khfggd6ltvBTxXfqMGuzhOPg/1PW
	 4Jkb8AyypdR+w==
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 1986E17E0EF1;
	Mon, 16 Mar 2026 10:34:44 +0100 (CET)
Message-ID: <538cb0a5-046d-4ec1-bd4c-d5a01dae7b06@collabora.com>
Date: Mon, 16 Mar 2026 10:34:43 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 03/23] dt-bindings: ufs: mediatek,ufs: Add mt8196
 variant
To: Rob Herring <robh@kernel.org>,
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 Bart Van Assche <bvanassche@acm.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Matthias Brugger <matthias.bgg@gmail.com>,
 Chunfeng Yun <chunfeng.yun@mediatek.com>, Vinod Koul <vkoul@kernel.org>,
 Kishon Vijay Abraham I <kishon@kernel.org>,
 Peter Wang <peter.wang@mediatek.com>, Stanley Jhu <chu.stanley@gmail.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Philipp Zabel <p.zabel@pengutronix.de>, Liam Girdwood <lgirdwood@gmail.com>,
 Mark Brown <broonie@kernel.org>, Chaotian Jing <Chaotian.Jing@mediatek.com>,
 Neil Armstrong <neil.armstrong@linaro.org>,
 Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
 kernel@collabora.com, linux-scsi@vger.kernel.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org,
 linux-phy@lists.infradead.org, Conor Dooley <conor.dooley@microchip.com>
References: <20260306-mt8196-ufs-v9-0-55b073f7a830@collabora.com>
 <4089450.ElGaqSPkdT@workhorse> <yq14imrwp3z.fsf@ca-mkp.ca.oracle.com>
 <5973984.DvuYhMxLoT@workhorse>
 <CAL_JsqKGxrNuaTb9+n3ZYjAdY=UHC6z-neXK-aieTXeROCN5og@mail.gmail.com>
From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Content-Language: en-US
In-Reply-To: <CAL_JsqKGxrNuaTb9+n3ZYjAdY=UHC6z-neXK-aieTXeROCN5og@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Il 10/03/26 19:21, Rob Herring ha scritto:
> On Mon, Mar 9, 2026 at 5:04 AM Nicolas Frattaroli
> <nicolas.frattaroli@collabora.com> wrote:
>>
>> On Saturday, 7 March 2026 19:01:17 Central European Standard Time Martin K. Petersen wrote:
>>>
>>> Nicolas,
>>>
>>>>> "ufs" is redundant as all the clocks are for UFS. Same comment on prior
>>>>> patch.
>>>>
>>>> Is this naming a big enough concern to block this series with two
>>>> explicit acks on this patch that fixes a wholly broken and useless
>>>> binding?
>>>
>>> It is if it comes from one of the DT maintainers.
>>>
>>>> I am trying to put out this dumpster fire of a downstream turd that
>>>> made its way into mainline as the review process has been completely
>>>> subverted, and is only getting worse with each passing month
>>>
>>> This has to stop. Please read Documentation/process/code-of-conduct.rst.
> 
> I have little doubt that that is an accurate description of
> downstream. And if properties are getting added without bindings, then
> that is certainly a problem that should be complained about.
> 
>>>
>>>
>>
>> I apologise for my tone, it's my frustration getting the better of me.
>>
>> I'll be handing off this series to someone else, so you won't have to
>> deal with me anymore.
>>
>> I do ask however that you don't apply patches from MediaTek blindly;
>> if there's code to read an OF property, and that OF property is not
>> in the binding, then the patch should be rejected, even if there's an
>> Ack from the MediaTek maintainer.
> 
> There's functionality to find undocumented compatibles in kernel code
> (make dt_compatible_check), but not properties. Sounds like I need to
> add that.

Rob: yes please, that would help a lot in general, not just with this UFS driver.

Cheers,
Angelo

> 
> Rob


