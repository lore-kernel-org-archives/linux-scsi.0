Received: from mail-m19731110.qiye.163.com (mail-m19731110.qiye.163.com [220.197.31.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF61250C06;
	Wed, 11 Mar 2026 13:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773235801; cv=none; b=GX8czVxT2whXGMiDdtcQVRrhOsDEry5o88JISrG4s4as5akmUpDybNWCp8Fu3mgXIt+ibM8YaB84rp1ubU5Upzsssr2pO+falnKreuAqiOvrvtXv0I6fmf5H8GLkHr+9O//VHuaRpBa2W9Ue593nAXNoRJD7YUpkxsNqVirYtRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773235801; c=relaxed/simple;
	bh=o/47pB6NJAGoZlUckC04kmsWK5+kmHPCrbZikA+mOCQ=;
	h=Cc:Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=DnFEKY5CLPmc+7hDxhaYtfgHucgDe9HCD+fFjOFwpxchVl5b+4tMimqMwnv8XdqVBPvqWOcIE+ODefm0Ym5NpXnd85L1OYvH7NHBkaNPufY728m8/D+JFCGNx6W+jSoNQSfFzsSwx0fslr7VSYVI7M7v1sB9c67JQcycAyysR+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com; spf=pass smtp.mailfrom=rock-chips.com; dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b=VyrwhSQj; arc=none smtp.client-ip=220.197.31.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b="VyrwhSQj"
Received: from [172.16.12.17] (unknown [58.22.7.114])
	by smtp.qiye.163.com (Hmail) with ESMTP id 3692741de;
	Wed, 11 Mar 2026 21:29:46 +0800 (GMT+08:00)
Cc: shawn.lin@rock-chips.com,
 "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Heiko Stuebner <heiko@sntech.de>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, devicetree@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-rockchip@lists.infradead.org
Subject: Re: [PATCH 1/2] scsi: ufs: drockchip,rk3576-ufshc: dt-bindings: Add
 new mphy reset item
To: Krzysztof Kozlowski <krzk@kernel.org>
References: <1773193218-215988-1-git-send-email-shawn.lin@rock-chips.com>
 <1773193218-215988-2-git-send-email-shawn.lin@rock-chips.com>
 <20260311-ultraviolet-shrew-of-management-ca536b@quoll>
From: Shawn Lin <shawn.lin@rock-chips.com>
Message-ID: <6d4e61eb-0b1b-c61f-faba-f790774b6cec@rock-chips.com>
Date: Wed, 11 Mar 2026 21:29:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260311-ultraviolet-shrew-of-management-ca536b@quoll>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9cdd16d2cf09cckunm38650987127e6
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFDSUNOT01LS0k3V1ktWUFJV1kPCRoVCBIfWUFZGh8YGlZJQxhLGE0YS0tMSEtWFRQJFh
	oXVRMBExYaEhckFA4PWVdZGBILWUFZTkNVSUlVTFVKSk9ZV1kWGg8SFR0UWUFZT0tIVUpLSU9PT0
	hVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=VyrwhSQjgF4MFS8VWaLpm2i8qJDXusKWPb55KonMghZio0yDfXYgY8Zc2oj8WjB8Fa8eouMMmKFPVp0lqCxt1iWp9xUHstYQFTSCliOS0BGANRTOrqGfHFNibOf1RB69t4gR9nU58jigNX7mB1P7kWIjoRU+rV72bkZJHUjqdwY=; s=default; c=relaxed/relaxed; d=rock-chips.com; v=1;
	bh=F8pt31l0VsJfdCSmcYNuEWgW6arHaqOf4wSdISGjeAw=;
	h=date:mime-version:subject:message-id:from;

Hi Krzysztof

在 2026/03/11 星期三 21:10, Krzysztof Kozlowski 写道:
> On Wed, Mar 11, 2026 at 09:40:17AM +0800, Shawn Lin wrote:
>> Add the mphy reset property to the devicetree bindings for the Rockchip
>> RK3576 UFS host controller. The mphy reset signal is used to reset the
>> physical adapter. Resetting other components while leaving the mphy
>> unreset may occasionally prevent the UFS controller from successfully
>> linking up with the device.
>>
>> Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
>> ---
>>
>>   Documentation/devicetree/bindings/ufs/rockchip,rk3576-ufshc.yaml | 7 ++++---
>>   1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/ufs/rockchip,rk3576-ufshc.yaml b/Documentation/devicetree/bindings/ufs/rockchip,rk3576-ufshc.yaml
>> index c7d17cf4..e738153 100644
>> --- a/Documentation/devicetree/bindings/ufs/rockchip,rk3576-ufshc.yaml
>> +++ b/Documentation/devicetree/bindings/ufs/rockchip,rk3576-ufshc.yaml
>> @@ -41,7 +41,7 @@ properties:
>>       maxItems: 1
>>   
>>     resets:
>> -    maxItems: 4
>> +    maxItems: 5
>>   
>>     reset-names:
>>       items:
>> @@ -49,6 +49,7 @@ properties:
>>         - const: sys
>>         - const: ufs
>>         - const: grf
>> +      - const: mphy
> 
> ABI break here and in the driver. Considering this was merged year ago,
> so for sure it was tested and was working. Otherwise commit msg would
> explain the actual bug affecting users.
> 

Thanks for your review.

You are absolutely right that this change technically breaks the ABI in
the device tree bindings by increasing maxItems and adding a new entry.
Although the driver is using devm_reset_control_array_get_exclusive(),
so the old DTB and new DTB should both work.

The issue this series fixes (UFS link-up failure when mphy is not
explicitly reset) is an intermittent hardware bug that is difficult to
reproduce. It only occurs under specific timing conditions with certain
chips. We recently encountered this issue consistently in our downstream
testing and identified the root cause. We are syncing this critical fix
to upstream immediately to prevent stability issues for users. I will
update the commit message to explicitly describe this hard-to-reproduce
bug and the specific failure mode, and probably add a fixes tag.

Does the above sound the right approach to you?


> Best regards,
> Krzysztof
> 
> 
