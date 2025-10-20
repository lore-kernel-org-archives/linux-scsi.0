Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E3B2F60D1;
	Mon, 20 Oct 2025 09:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760954204; cv=none; b=ppG2XVXhn6Os1QkgQES5EVDAhrRR6jHBuVb300KIT71kijn5HIsGkbIdqknElm3wW/Rhby8TLnYSBIHx4ntFJMUnYGmN4TVFTU+cAbDMu2NxBs9Vk+FXf0Vun3Gm7W16MYUeTnanZ9K+Cf1VyHswJj0n40k6I3/FsbwwmDsRn5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760954204; c=relaxed/simple;
	bh=eRscmhaBeaXNyyMb6QNngH3o5h5QCnU9xCb75nFP7+M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EhvHYhKRm8KqgOL9p8h1pWbkizxfqjXBQ9NwXI+lBLgA18iaQgapOPbSzQUCsDrxphAYqANxBlgFsSwH+8812EzBhJFhrHHrCIdDcbd0D9PsCJKslC/UBsJhIwDhhQmYFpwqrn0m5xBzMvw8BDwcQrV8TMPFLGx5htX4ZgmkvQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TTfdfeu7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TTfdfeu7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 844F3C4CEF9;
	Mon, 20 Oct 2025 09:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760954203;
	bh=eRscmhaBeaXNyyMb6QNngH3o5h5QCnU9xCb75nFP7+M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TTfdfeu7+i1jUYuaXPwGYgFpZ061KDKhmAeYU6LXSHmZVl4lLGEFxYVEEjcUeeEIQ
	 cvrGT7UgAI4lKgsp3/EPHY2EbxgElGBkCyw7GEhhjeH/DGWR7X6mpgaNoxKAkUXZZO
	 Mi6f9OrDOYt0rus2Kaq8TnBWsTs5N/gJ389bdcbWjqtJ/iuhuNbY/IIUextL4vNluy
	 +viQe9GpTDGX/6l5h/zlR2L6hMnQLjazC/sTjT5Nz84GLCCW6deVz6kg0GYBOIktNo
	 5q+icUzkiCEYEf/J1+8Nkdkq28e8cgiyQYXWb6iXDOw7MHJ9UwIDe6oAePv90frKCU
	 MAOkNIVOB4kPg==
Message-ID: <4dc420a3-cf89-4f45-84e7-4d0079240681@kernel.org>
Date: Mon, 20 Oct 2025 11:56:36 +0200
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
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 =?UTF-8?B?TWFjcGF1bCBMaW4gKOael+aZuuaWjCk=?= <Macpaul.Lin@mediatek.com>,
 "conor+dt@kernel.org" <conor+dt@kernel.org>,
 "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
 "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
 "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
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
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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 a/A=
In-Reply-To: <4b3d2678d2b724fb53ec7272ef8daf52197d4a0e.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 20/10/2025 11:44, Peter Wang (王信友) wrote:
> On Mon, 2025-10-20 at 10:28 +0200, Krzysztof Kozlowski wrote:
>>>
>>>
>>> Hi Krzysztof Kozlowski,
>>>
>>> The main reason for my objection was also clearly stated:
>>> "removing these DTS settings will make what was originally
>>> a simple task more complicated."
>>> I’m not sure if you are quoting only the "In addition"
>>> part to take it out of context?
>>
>> It is not out of context. It was the statement on its own.
> 
> Hi Krzysztof Kozlowski,
> 
> However, you haven’t addressed the main reason for my objection.
> "removing these DTS settings will make what was originally
> a simple task more complicated."


You did not object in technical matter at all here:
https://lore.kernel.org/all/ce0f9785f8f488010cd81adbbdb5ac07742fc988.camel@mediatek.com/

Look at this patch.

You said nothing about actual change, except blocking the community
maintainer. You did not raise any other concerns so what are you
speaking about "other main concerns"?

Even if such existed, they did not matter, because YOU WROTE ONLY:

"The role of MediaTek UFS maintainer is not suitable to be handed over
to someone outside of MediaTek."

This is what we discuss here.

> 
>>
>>
>>
>> You denied community to participate and now you twist the argument
>> like
>> you want Mediatek people to be involved. No one denied Mediatek to be
>> maintainer.
>>
>> It is you who denied community to join the maintainers.
>>
>> This is not acceptable and you still do not understand why.
> 
> I think I understand your point now, you believe that opposing
> this patch means opposing community participation and support, right?

Do you even read your own comments and where did you place them? Do you
understand that we discuss emails, not some unsaid or other threads?

Look at this:

https://lore.kernel.org/all/ce0f9785f8f488010cd81adbbdb5ac07742fc988.camel@mediatek.com/

	
> But it’s clear that you haven’t carefully considered the main 
> reason for my objection?

Main reason for objection? What?

> 
> 
> 
>>
>>
>> You could apologize and explain your mistakes, but instead you push
>> same
>> narrative.
>>
>> Still a red flag. I will not accept such vendor-like behaviors,
>> because
>> they significantly harm the community.
>>
>> I am very surprised that UFS maintainers did not object to it. This
>> should be clearly ostracized.
>>
>>
> 
> Sorry, I still don’t quite understand why having people who
> know the SoC better maintain the SoC driver would be considered
> harmful to the community?

You are twisting the problem, like anyone denied you being the maintainer.

YOU DENIED OTHER PEOPLE!

I finish the discussion here, I am considering your explanations
intentionally twisting the point thus I find it still harmful behavior.

Best regards,
Krzysztof
