Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 264C43403F9;
	Sat, 30 May 2026 17:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162408; cv=none; b=Pu8AFO1jxt9NV4HRw3Ln5AkBrb5QbOgjeiK53d5NHM7u2jBPjYPn1ut6W8bCpaRT7BIExkOJlgM6f42qUy7pZQ+R0mgmPRpJKTdxue3GUTwHHCphs83/ZBwQO/rl0WQUIe/5nOzCFH8/xW8ZgUwuJ6sUi7wQI5ahD7JKq/BdCzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162408; c=relaxed/simple;
	bh=Cwzmcd1bXpq1ItCP3waaFojujM6EvxkPRqBPiv4+6EE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L02waWwGwSsa5C4hkQCkWEkGMXHFdVnwDWAXbA7q4xyjR9+/Qn/pwA/lzENyJEPU2J8nQ/vNLi0ZXjU6mTxHe6wo8cf/fxxJLa8hImMbm5eLwkOCKUp4oYg6KjGLmFHRU3ypFt14ZOoiah4n+hSM3f2vi5DVYFXjHmj27hDGlx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DtB1Ks3p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DtB1Ks3p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4BC1F00893;
	Sat, 30 May 2026 17:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780162406;
	bh=uAflBWOHLMczVAx0OqWwLrWmJzNPKJqnt7OnFqzNt6g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DtB1Ks3pddrvkt5ANvMit/Nr8FN17UEKfuMv2Qi/BtHKQyho9447UtfHZj+UeLCAc
	 09J6ceCqzucIPNqZtuXbMHDjr4ws45MU4fPPOnF2nMWLDJSi7Xy9YXGzwQDii0YrUS
	 xqSj+RKNT8jbK0/5+wUTEiPeXdH/RHgcHb/m3anLXeuAKrSoPHv4VTSq/6dykdEP47
	 XdsWrzVjZB1mNd1igVz3RKG4798No2SYhFHLns+U3v1oUPlG9wpK3duXFV/Fc9aZsU
	 0QIFapivknON4x62Ec46BzEa/orUxdutBwrkh0w/NOxD+N8A3O+hCnrSSx6439d7bj
	 Ob5C2TZg2QF/g==
Message-ID: <b445e9e3-dfda-45d6-bafb-a2deb3357144@kernel.org>
Date: Sat, 30 May 2026 19:33:20 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/2] dt-bindings: ufs: Document static TX Equalization
 settings properties
To: Can Guo <can.guo@oss.qualcomm.com>
Cc: bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com,
 martin.petersen@oracle.com, mani@kernel.org, linux-scsi@vger.kernel.org,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>, Matthias Brugger
 <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Zhaoming Luo <zhml@posteo.com>, Ram Kumar Dwivedi
 <quic_rdwivedi@quicinc.com>,
 "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
 <devicetree@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>,
 "moderated list:ARM/Mediatek SoC support:Keyword:mediatek"
 <linux-arm-kernel@lists.infradead.org>,
 "moderated list:ARM/Mediatek SoC support:Keyword:mediatek"
 <linux-mediatek@lists.infradead.org>
References: <20260529113338.984301-1-can.guo@oss.qualcomm.com>
 <20260529113338.984301-2-can.guo@oss.qualcomm.com>
 <20260529-neat-bright-shellfish-eab5e8@quoll>
 <ada65ce2-6736-44fe-9396-d3ed632274ce@oss.qualcomm.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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 a/A=
In-Reply-To: <ada65ce2-6736-44fe-9396-d3ed632274ce@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 30/05/2026 14:45, Can Guo wrote:
> 
> 
> On 5/30/2026 12:58 AM, Krzysztof Kozlowski wrote:
>> On Fri, May 29, 2026 at 04:33:37AM -0700, Can Guo wrote:
>>> UFS v5.0/UFSHCI v5.0 add HS-G6 support (46.6 Gbps/lane) via UniPro v3.0
>>> and M-PHY v6.0. In these specs, TX Equalization is defined for all High
>>> Speed Gears (not only HS-G6) to compensate channel loss and improve signal
>>> integrity at high speed operation.
>>>
>>> For HS-G6, M-PHY uses PAM4 1b1b line coding, Pre-Coding may also be
>>> required depending on channel characteristics.
>>>
>>> Add vendor-neutral DT properties:
>>>
>>> - patternProperties for txeq-preshoot-g[1-6] and txeq-deemphasis-g[1-6]
>>> - fixed property tx-precode-enable-g6
>>>
>>> Each property is a uint32 array of per-lane tuples:
>>> <Host_Lane0 Device_Lane0>, [<Host_Lane1 Device_Lane1>]
>>>
>>> Accept 2 or 4 values (x1/x2 lane configs). PreShoot and DeEmphasis values
>>> are 0..7. Precode enable values are 0/1 and only applicable to HS-G6.
>>>
>>> Acked-by: Manivannan Sadhasivam <mani@kernel.org>
>>> Reviewed-by: Bean Huo <beanhuo@micron.com>
>>> Reviewed-by: Peter Wang <peter.wang@mediatek.com>
>>> Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
>>> ---
>>>   .../devicetree/bindings/ufs/ufs-common.yaml   | 45 +++++++++++++++++++
>>>   1 file changed, 45 insertions(+)
>>>
>>> diff --git a/Documentation/devicetree/bindings/ufs/ufs-common.yaml b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
>>> index ed97f5682509..d90cf25adfa5 100644
>>> --- a/Documentation/devicetree/bindings/ufs/ufs-common.yaml
>>> +++ b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
>>> @@ -105,6 +105,51 @@ properties:
>>>         Restricts the UFS controller to rate-a or rate-b for both TX and
>>>         RX directions.
>>>   
>>> +  tx-precode-enable-g6:
>>> +    $ref: /schemas/types.yaml#/definitions/uint32-array
>>> +    oneOf:
>>> +      - minItems: 2
>>> +        maxItems: 2
>>> +      - minItems: 4
>>> +        maxItems: 4
>>> +    items:
>>> +      enum: [0, 1]
>>> +    description: |
>>> +      Static TX Precode enable values for HS-G6 only.
>>> +      Values are specified as per-lane tuples:
>>> +      <Host_Lane0 Device_Lane0>, [<Host_Lane1 Device_Lane1>].
>> You need to include them in any of applicable examples, otherwise
>> nothing here is validated.
> Hi Krzysztof,
> 
> Thanks for the review.
> 
> Since no UFS5-capable SoC binding exists upstream yet (the target SoC is

I would imagine cover letter or commit msg would briefly mention that.

> still pre-CS), there is no vendor-specific YAML to attach the example to.
> 
> Is a synthetic example directly in ufs-common.yaml OK to you?

Skip example in such case.

>>
>> Why values cannot be on or off? Or even better: why you cannot just list
>> all the lanes which has it enabled, assuming disabled is by default?
> Thanks for the suggestions.
> 
> For the "just list enabled lanes" suggestion: precode must be configured
> independently for the Host-side TX and Device-side TX transceivers within
> the same physical lane. A lane index list alone cannot capture this
> two-dimensional per-lane state. The tuple format <Host_LaneN Device_LaneN>
> is the minimal encoding that covers both.

Again, why do you need to encode '0'?

> 
> For the "on/off" suggestion: the on/off string pattern is used with
> single-value properties (e.g. LED default-state) read via
> of_property_read_string(). I am not aware of precedent for on/off as a
> string array for per-lane tuples.

git grep string-array. Plenty of precedents.

Best regards,
Krzysztof
