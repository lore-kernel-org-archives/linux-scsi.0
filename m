Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F068C363C46;
	Fri, 17 Apr 2026 12:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776430513; cv=none; b=uXkfXcLXnss4/5gmOWy2+YiulzmJy2riIiyMUvoutBlMg1q24F//WplHLIdl1FeEgw30/I6Beb1gMkCRqVPkjHMBlzhMaS8TsfvYzPE4FPAHYRcw02n07xS1z3x3q1TYYg/nNDIXwZBg+Pry2g/ku7jqZUwRB2r5YC4B5awfFS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776430513; c=relaxed/simple;
	bh=1sfgNx9kfwIq2zL4H3z8w3h1EAxxVnm1pM7OpEYOVlw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IQIgkjApayv3bc/DH612ta9XoCz6kIByzATzx//qFkhuvjCA4otT0ObRFnCzz5loF53D0kyGoCiveDwtN0bpGZCoyAwLetufASwhRK5rpUouTse+iZuSuZlcK7vhsej5lhjjePH+MVmnCByyUvKgOHkUdyNQGkfxLpOqlT7c+ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C5jHRv2g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C5jHRv2g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF34C19425;
	Fri, 17 Apr 2026 12:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776430512;
	bh=1sfgNx9kfwIq2zL4H3z8w3h1EAxxVnm1pM7OpEYOVlw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=C5jHRv2gBUEdrZ6o5/e7KB2tMJo+xh4AyfGWflMmbI2a0m4qGVjo1XRWA8JMeCJCx
	 xIUuNh1WgqB0bHIV+dFc9ffTs+GGU/jywhpknKYxyk0UpBhQ2bqru1Tn3xK2wmJ7HF
	 jIqoqkB/En8f6ROrRWIV0GRf0bjXrs43pBGA23oE9ihTfSEQwD3S5zwXKfUR1oT+ML
	 sudkvvVgA6kjSRZUP+vss5fBLnmlMhMSx+Y+lZUEtpFLxrtbuReokFxuht7/28RsoL
	 QWgxHx6hM/sw3p4P/YraZ25dbl6z848Zhlz6J8n93vWBH9d6RfRafqC2o+HduxRnAk
	 4IVRxXQLsIk2A==
Message-ID: <f1a829c6-a612-4334-b6fc-993c51cc90de@kernel.org>
Date: Fri, 17 Apr 2026 14:55:07 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] dt-bindings: ufs: exynos: add ExynosAutov920
 compatible string
To: Alim Akhtar <alim.akhtar@samsung.com>, avri.altman@wdc.com,
 bvanassche@acm.org, robh@kernel.org, martin.petersen@oracle.com,
 krzk+dt@kernel.org
Cc: sowon.na@samsung.com, peter.griffin@linaro.org,
 linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
 linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
 'Krzysztof Kozlowski' <krzysztof.kozlowski@linaro.org>
References: <20260417121452.827054-1-alim.akhtar@samsung.com>
 <CGME20260417115842epcas5p1fb06d6f1663b97b1eae3aafaa6a3de0b@epcas5p1.samsung.com>
 <20260417121452.827054-3-alim.akhtar@samsung.com>
 <27b401dcce62$03bd3280$0b379780$@samsung.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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 a/A=
In-Reply-To: <27b401dcce62$03bd3280$0b379780$@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 17/04/2026 14:02, Alim Akhtar wrote:
> 
> 
>> -----Original Message-----
>> From: Alim Akhtar <alim.akhtar@samsung.com>
>> Sent: Friday, April 17, 2026 5:45 PM
>> To: avri.altman@wdc.com; bvanassche@acm.org; robh@kernel.org;
>> martin.petersen@oracle.com; krzk+dt@kernel.org
>> Cc: sowon.na@samsung.com; peter.griffin@linaro.org; linux-
>> scsi@vger.kernel.org; devicetree@vger.kernel.org; linux-samsung-
>> soc@vger.kernel.org; linux-kernel@vger.kernel.org; Krzysztof Kozlowski
>> <krzysztof.kozlowski@linaro.org>; Alim Akhtar <alim.akhtar@samsung.com>
>> Subject: [PATCH v2 2/4] dt-bindings: ufs: exynos: add ExynosAutov920
>> compatible string
>>
>> From: Sowon Na <sowon.na@samsung.com>
>>
>> Add samsung,exynosautov920-ufs compatible for ExynosAutov920 SoC.
>>
>> Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Just noticed that this email is no longer valid, In case there is a re-spin, will correct this.
> Sorry for the noise. 

The ack can stay wild email, it's fine. It still gives the credit to
previous employer.

Best regards,
Krzysztof
