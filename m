Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12CF52EBB9E;
	Mon, 20 Oct 2025 08:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760948938; cv=none; b=aq9ZbucQWselrJXpsnAGSJVrhtODVYHG/yIJRFVnM5ZbTlwT/KVQpQuqD6ax/fv+DYh74GjlWgQdA/6QGMrKkAGhG5QncQb+lAH7bI2TRs9EvlDpdbf1nchCh1EL7SyTqoY2dS0/vsTK2AS8t+r2MyHjBufcNnOtvOUHdzC13Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760948938; c=relaxed/simple;
	bh=25hfAnvscR1U4cXixXqpwGfnnw5o7TPh3bpW0tfuVu4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=roTrtZvkcQtgYCGBQv8HyYLabwI+MURKkvSJPkE2zl7whqGQNr7Azgx55QJMirLaA9lcdIdbORsaUyc4lffGD0q8kFMZltVChQ3D2o2liupLcy5vb3W0lPwX+O4A5NFGTyjTtN3qZkdxWKBfWA2Y3+Gnf5AvPZ8yNUZl7byv5Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hmmB7Yl2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hmmB7Yl2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3376C4CEF9;
	Mon, 20 Oct 2025 08:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760948937;
	bh=25hfAnvscR1U4cXixXqpwGfnnw5o7TPh3bpW0tfuVu4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hmmB7Yl2UA6kpshuw/7MLcZjnNzAfzMGBi6uif6jlmm0ocr8CYagEs2bf/Z2wbqC4
	 0XSbSwGj33+uZ3c6Bn6gKlya7o8IkRPIPEhCvrdIqqhOt7fDeLTC0RhBJuU1oF6vB6
	 6GWo0gODk3tpOSlXjE3bGp8N1MRBysvpPx2QXnRYYqmY54VfqlWwDCvp7TiYm44ZCD
	 +mG57VfAlSuV9x1YfmpMaCLmlD3u+fwbDKrzOjEeclUTKmJPCqGN9OB90mQxcHC3vC
	 gGeDLo80fdcfpbgzBr+QtQxXLw1OrHoArKUQCSLz/wo0vIaz7wkJOZrfKjzpAKqx8V
	 aEAjNgCC3OZPg==
Message-ID: <7f285723-ecd7-4df6-8c9b-f2e786ce3602@kernel.org>
Date: Mon, 20 Oct 2025 10:28:52 +0200
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
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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 a/A=
In-Reply-To: <a9bf15e48afd8496ca9b015e7f5b03821863a0b2.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 20/10/2025 10:13, Peter Wang (王信友) wrote:
> On Sun, 2025-10-19 at 12:19 +0200, Krzysztof Kozlowski wrote:
>>
>> You did.
>>
>> You wrote very clearly here:
>> https://lore.kernel.org/all/eb47587159484abca8e6d65dddcf0844822ce99f.camel@mediatek.com/
>>
>> "In addition, it will require MediaTek to put in extra
>> effort to migrate the kernel. "
>>
> 
> Hi Krzysztof Kozlowski,
> 
> The main reason for my objection was also clearly stated:
> "removing these DTS settings will make what was originally
> a simple task more complicated."
> I’m not sure if you are quoting only the "In addition"
> part to take it out of context?

It is not out of context. It was the statement on its own.

> 
> 
> 
>>
>> Also you wrote:
>> "The role of MediaTek UFS maintainer is not suitable to be handed
>> over
>> to someone outside of MediaTek."
>>
>> https://lore.kernel.org/all/ce0f9785f8f488010cd81adbbdb5ac07742fc988.camel@mediatek.com/
>>
>> Holy molly, you really wrote this!
>>
> 
> "The role of MediaTek UFS maintainer is not suitable to be handed
> over to someone outside of MediaTek."
> My main point is that MediaTek’s internal personnel certainly 
> have a better understanding of the SoC architecture than external
> parties.
> Wouldn’t it be more appropriate for maintainers to be internal staff?


You denied community to participate and now you twist the argument like
you want Mediatek people to be involved. No one denied Mediatek to be
maintainer.

It is you who denied community to join the maintainers.

This is not acceptable and you still do not understand why.

> 
> 
> 
>> That's completely unacceptable. You don't understand how upstream
>> development works and you push your downstream narrative which for us
>> does not matter. You also object community led efforts, because you
>> apparently want to control the upstream process.
>>
> 
> I don’t see how this relates to upstream/downstream?
> Aren’t you reading too much into this? My objection is purely
> because I don’t want to complicate a simple matter, not 
> because I object to community-led efforts.
> Please don’t misunderstand my intention.


You could apologize and explain your mistakes, but instead you push same
narrative.

Still a red flag. I will not accept such vendor-like behaviors, because
they significantly harm the community.

I am very surprised that UFS maintainers did not object to it. This
should be clearly ostracized.


> 
> 
> 
>> That is red flag.
>>
>> I think you should step down from maintainer position and find more
>> suitable person, who is willing to work with the community, or
>> rethink
>> how upstream process works and understand that your downstream goals
>> do
>> not matter completely.
>>
>> I will be watching closely this and if situation does not improve, I
>> believe we should mark the driver orphaned until we find maintainer
>> caring about community, not about corporate goals.
>>
>> Best regards,
>> Krzysztof
> 
> 
> Mediatek will add a few more maintainers internally,


Consider stepping down and choosing them if they better understand how
upstream works.

As Rob wrote earlier:

"Sounds like we need a new maintainer then. They clearly don't
understand that downstream doesn't exist."


Best regards,
Krzysztof
