Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED0728030E;
	Mon, 20 Oct 2025 11:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760958282; cv=none; b=qdo5PjTRR4cQtF5liUe6v9qfcp7ibC7y0cIDNbaC8xUDio4eUxjQDg9ifMKxfQm24p9ZbGQi87F39XMehYnljHMpj55zXhfpBRmeTQjLzDt8v6rHAdK6oSA+Vptu4upsEC8/gJiZ3Iv2YAvT8Fl+v2304ERrw2SoAwCKOeCHsj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760958282; c=relaxed/simple;
	bh=S0gr+beW66g6d7RoCiZR+zG9DA0elSFkbETKy2N04NQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V0rOehDLGAuTdfhkdOPembiQWqGmn3yyyUEaeP+Wddu/z9+EqFFLTkm+0SpdiwOA9fC+ct8p+NbeFikxkVVHzR4I6S+cKGQRHBmM3B1eggsKORTCVqN1eO8nkwV3DbsOuPE31Ki8cu5exuvoxccwdtCNhfo1XEsigGsLEZWtUlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=pXHJc2FN; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="pXHJc2FN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1760958278;
	bh=S0gr+beW66g6d7RoCiZR+zG9DA0elSFkbETKy2N04NQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pXHJc2FNtClHFj9eM8P+MyxeRQdr3hjyYE/NHTr5gplDQ6b0FiKkWh5+fuUUQkh3P
	 vxdY1/NaeT9+p2F3MhtS2T9bHSVCDDKn1xekNXcd7dj4hrGGIMWnF5KMnw9eU5rLDj
	 YF4t+XHI6biYGH551ZAOJy6amFub7ICBmQhDdLNSajlQNojcVHxGWvTEawdLIS+tZT
	 6Iv3iigIVPbECkhtd8AHkNijp7q1myT076F/rJA9Vtwby0IcWla2ll8T8TEdhq3h75
	 aDaCIsbsp/5qnbTNJvb1vW5fe/ZY+G82ZRdY3ETCuFL1X91mTu5xt0fa0/hMCrzNV9
	 hgJulVcqYJNcw==
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id A83D117E0C54;
	Mon, 20 Oct 2025 13:04:37 +0200 (CEST)
Message-ID: <6de4477a-5c2e-413f-9aa2-77b7262ebb38@collabora.com>
Date: Mon, 20 Oct 2025 13:04:37 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] dt-bindings: ufs: mediatek,ufs: add MT8195
 compatible and update clock nodes
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "chu.stanley@gmail.com" <chu.stanley@gmail.com>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>, "robh@kernel.org"
 <robh@kernel.org>, "bvanassche@acm.org" <bvanassche@acm.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 =?UTF-8?B?TWFjcGF1bCBMaW4gKOael+aZuuaWjCk=?= <Macpaul.Lin@mediatek.com>,
 "conor+dt@kernel.org" <conor+dt@kernel.org>,
 "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
 "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
 "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
 "krzk@kernel.org" <krzk@kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "macpaul@gmail.com" <macpaul@gmail.com>,
 =?UTF-8?B?UGFibG8gU3VuICjlravmr5Pnv5Qp?= <pablo.sun@mediatek.com>,
 Project_Global_Chrome_Upstream_Group
 <Project_Global_Chrome_Upstream_Group@mediatek.com>,
 =?UTF-8?B?QmVhciBXYW5nICjokKnljp/mg5/lvrcp?= <bear.wang@mediatek.com>,
 =?UTF-8?B?UmFtYXggTG8gKOe+heaYjumBoCk=?= <Ramax.Lo@mediatek.com>
References: <20250722085721.2062657-1-macpaul.lin@mediatek.com>
 <20250722085721.2062657-3-macpaul.lin@mediatek.com>
 <b90956e8-adf9-4411-b6f9-9212fcd14b59@collabora.com>
 <438077d191833bb4f628b2c6da3b86b3ecfb40e6.camel@mediatek.com>
 <cb173df9-4c70-4619-b36d-8e99272551b6@kernel.org>
 <a9bf15e48afd8496ca9b015e7f5b03821863a0b2.camel@mediatek.com>
 <7f285723-ecd7-4df6-8c9b-f2e786ce3602@kernel.org>
 <4b3d2678d2b724fb53ec7272ef8daf52197d4a0e.camel@mediatek.com>
 <4dc420a3-cf89-4f45-84e7-4d0079240681@kernel.org>
 <95d3fe686abcd4a6070c6613392fdb9605bdd73e.camel@mediatek.com>
From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Content-Language: en-US
In-Reply-To: <95d3fe686abcd4a6070c6613392fdb9605bdd73e.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Il 20/10/25 12:46, Peter Wang (王信友) ha scritto:
> On Mon, 2025-10-20 at 11:56 +0200, Krzysztof Kozlowski wrote:
>>
>> On 20/10/2025 11:44, Peter Wang (王信友) wrote:
>>> On Mon, 2025-10-20 at 10:28 +0200, Krzysztof Kozlowski wrote:
>>>>>
>>>>>
>>>>> Hi Krzysztof Kozlowski,
>>>>>
>>>>> The main reason for my objection was also clearly stated:
>>>>> "removing these DTS settings will make what was originally
>>>>> a simple task more complicated."
>>>>> I’m not sure if you are quoting only the "In addition"
>>>>> part to take it out of context?
>>>>
>>>> It is not out of context. It was the statement on its own.
>>>
>>> Hi Krzysztof Kozlowski,
>>>
>>> However, you haven’t addressed the main reason for my objection.
>>> "removing these DTS settings will make what was originally
>>> a simple task more complicated."
>>
>>
>> You did not object in technical matter at all here:
>> https://lore.kernel.org/all/ce0f9785f8f488010cd81adbbdb5ac07742fc988.camel@mediatek.com/
>>
>> Look at this patch.
>>
>> You said nothing about actual change, except blocking the community
>> maintainer. You did not raise any other concerns so what are you
>> speaking about "other main concerns"?
>>
>> Even if such existed, they did not matter, because YOU WROTE ONLY:
>>
>> "The role of MediaTek UFS maintainer is not suitable to be handed
>> over
>> to someone outside of MediaTek."
>>
>> This is what we discuss here.
>>
>> Do you even read your own comments and where did you place them? Do
>> you
>> understand that we discuss emails, not some unsaid or other threads?
>>
>> Look at this:
>>
>> https://lore.kernel.org/all/ce0f9785f8f488010cd81adbbdb5ac07742fc988.camel@mediatek.com/
>>
>>
>>> But it’s clear that you haven’t carefully considered the main
>>> reason for my objection?
>>
>> Main reason for objection? What?
>>
> 
> Hi Krzysztof Kozlowski,
> 
> I think you misunderstood—these are different patches.
> This one only changes the maintainer. What I was referring to
> is another patch that removes parts of the DTS setting.
> https://lore.kernel.org/all/eb47587159484abca8e6d65dddcf0844822ce99f.camel@mediatek.com/
> 
> 
> I don’t know who AngeloGioacchino is,

Sorry Peter, but a 10 seconds research on your side would have made you aware of
who I am.

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/MAINTAINERS?h=v6.6#n2346

...then a 60 seconds research would reveal way more than just that about me,
and also your colleagues know me quite a bit :-)

Besides, you don't really need to know who somebody is to make an upstream review:
this is a community, and a good patch may come from old and recognized contributors
as much as from new ones sending their first patch upstream.

> so isn’t it reasonable for
> me to oppose directly changing the maintainer?
> Or do you think everyone should know who AngeloGioacchino is
> and just accept this change?
> 
> 
> Let’s put it this way: if a strager you don’t know suddenly comes
> to your home and says they’re now the maintainer of your house,
> would you be comfortable with that?
> 
> 
> 
>>
>>
>> You are twisting the problem, like anyone denied you being the
>> maintainer.
>>
>> YOU DENIED OTHER PEOPLE!
>>
>> I finish the discussion here, I am considering your explanations
>> intentionally twisting the point thus I find it still harmful
>> behavior.

Krzysztof, many thanks for taking time to defend the community.

Regards,
Angelo

>>
>> Best regards,
>> Krzysztof
> 
> I think you’re the one twisting my words.
> What I said was that I oppose people OUTSIDE of MediaTek becoming
> maintainers, not that I oppose other people in GENERAL.
> In fact, I also mentioned that other MediaTek maintainers
> would be joining.
> 
> 
> Thanks
> Peter
> 
> 

