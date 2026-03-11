Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D60B23BD06;
	Wed, 11 Mar 2026 13:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773236332; cv=none; b=XbBcyzA8cfSuylyLG6Hz4aa54x9pbn7OrDC6E3UABokbJv/4ApjPWPtzVQvax5X1AX4AVN7uoYd18/yTQSq7fAok5eYUo/amgOXcg9gviQYswPSK4zJ0sqtZ8t3+T5x9cVr0W8Ar/fJPEp7WhhAyzmQf4oZHvMdNJQnLDpjkqSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773236332; c=relaxed/simple;
	bh=83+AL1G5IjctdEzN79fL2AQOUtbDP1LaT+2LvqXasSQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B2qwkQoKjQnI6MqXNJkZeTGjzuhgl811mvvoGoKQZAMIWf7+FR2sFeNgvzQ1wBLnwPn0+SQWs+S/SEsdP43M7PY1yFmjizNjY32gvR0ig8uGzFqf1iF97c3MNfbuPHb9+7STzY9uxkwa3fp19f10NVK0NDlL4TOdvOeDwV2oQZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n0jPqmxH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n0jPqmxH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB64AC4CEF7;
	Wed, 11 Mar 2026 13:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773236332;
	bh=83+AL1G5IjctdEzN79fL2AQOUtbDP1LaT+2LvqXasSQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=n0jPqmxHMmhrWuCJw/ogpqucrTqJxBu+5CxqPDRZIymfmJVosYpzOY1OJ7ZQrm7Ao
	 /AdPSw3h3gS0e/fbGkz9jckrpfqLY0Qk3AQYN9tgiNY9L3PO56cHMlNxuCJoHB8APB
	 Gd/celBIM771LyMe0P2K4s2ikT5ekFTnUCLN5bmdGjVDEiyEBPEA3jUraEW1drM5RF
	 obWLIxyQlSDubUErZsu/yJf6bTNWDUzdLGjG6F9T+jaguElvi44TevTl0Ia3zGTWCY
	 KpACuXEH2/cWsk0PK4fh6sWfAkOztqhgaIpfJu/hYCNB/UBhzNxY0r82Q6QGuKx7sr
	 c745PV7nvkpqg==
Message-ID: <f6ac4bb9-2a4d-4432-93e4-111cad73fc85@kernel.org>
Date: Wed, 11 Mar 2026 14:38:48 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] scsi: ufs: drockchip,rk3576-ufshc: dt-bindings: Add
 new mphy reset item
To: Shawn Lin <shawn.lin@rock-chips.com>
Cc: "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Heiko Stuebner <heiko@sntech.de>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, devicetree@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-rockchip@lists.infradead.org
References: <1773193218-215988-1-git-send-email-shawn.lin@rock-chips.com>
 <1773193218-215988-2-git-send-email-shawn.lin@rock-chips.com>
 <20260311-ultraviolet-shrew-of-management-ca536b@quoll>
 <6d4e61eb-0b1b-c61f-faba-f790774b6cec@rock-chips.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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 a/A=
In-Reply-To: <6d4e61eb-0b1b-c61f-faba-f790774b6cec@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 11/03/2026 14:29, Shawn Lin wrote:
> Hi Krzysztof
> 
> 在 2026/03/11 星期三 21:10, Krzysztof Kozlowski 写道:
>> On Wed, Mar 11, 2026 at 09:40:17AM +0800, Shawn Lin wrote:
>>> Add the mphy reset property to the devicetree bindings for the Rockchip
>>> RK3576 UFS host controller. The mphy reset signal is used to reset the
>>> physical adapter. Resetting other components while leaving the mphy
>>> unreset may occasionally prevent the UFS controller from successfully
>>> linking up with the device.
>>>
>>> Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
>>> ---
>>>
>>>   Documentation/devicetree/bindings/ufs/rockchip,rk3576-ufshc.yaml | 7 ++++---
>>>   1 file changed, 4 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/Documentation/devicetree/bindings/ufs/rockchip,rk3576-ufshc.yaml b/Documentation/devicetree/bindings/ufs/rockchip,rk3576-ufshc.yaml
>>> index c7d17cf4..e738153 100644
>>> --- a/Documentation/devicetree/bindings/ufs/rockchip,rk3576-ufshc.yaml
>>> +++ b/Documentation/devicetree/bindings/ufs/rockchip,rk3576-ufshc.yaml
>>> @@ -41,7 +41,7 @@ properties:
>>>       maxItems: 1
>>>   
>>>     resets:
>>> -    maxItems: 4
>>> +    maxItems: 5
>>>   
>>>     reset-names:
>>>       items:
>>> @@ -49,6 +49,7 @@ properties:
>>>         - const: sys
>>>         - const: ufs
>>>         - const: grf
>>> +      - const: mphy
>>
>> ABI break here and in the driver. Considering this was merged year ago,
>> so for sure it was tested and was working. Otherwise commit msg would
>> explain the actual bug affecting users.
>>
> 
> Thanks for your review.
> 
> You are absolutely right that this change technically breaks the ABI in
> the device tree bindings by increasing maxItems and adding a new entry.
> Although the driver is using devm_reset_control_array_get_exclusive(),
> so the old DTB and new DTB should both work.

Ah, I missed that. Please mention it briefly in commit msg to indicate
that Linux is not affected.

> 
> The issue this series fixes (UFS link-up failure when mphy is not
> explicitly reset) is an intermittent hardware bug that is difficult to
> reproduce. It only occurs under specific timing conditions with certain
> chips. We recently encountered this issue consistently in our downstream
> testing and identified the root cause. We are syncing this critical fix
> to upstream immediately to prevent stability issues for users. I will
> update the commit message to explicitly describe this hard-to-reproduce
> bug and the specific failure mode, and probably add a fixes tag.
> 
> Does the above sound the right approach to you?

Yes, please include parts of above, that it is hard to reproduce but it
does happen, in the commit msg.


Best regards,
Krzysztof
