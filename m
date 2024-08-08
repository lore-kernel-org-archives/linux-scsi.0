Received: from mail-m49196.qiye.163.com (mail-m49196.qiye.163.com [45.254.49.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC8D188000;
	Thu,  8 Aug 2024 07:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723100410; cv=none; b=eQP1StoD8pTgVHZMZrMPQBzX8B8HYVPj0GEH5lOZxUJVpkZ2u7Jqpl2ZG53hFsJQ3UQlio0xzzZ0V1Hf9eTt+PJWO8jzsVUz1JLZD0XH2HoA1PoHvClf3nJ46v9nnfqnqBA+K/niwRWk/4Esp37VpQ+FJT3zExfKIwJwwA5lzGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723100410; c=relaxed/simple;
	bh=MvpAVpBiuX2dJnqJZTqE6TF3BJkJj6yOBd7GxHdnQBU=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=OrjTDKJjjpV8vKkfWkwhXYMQer37M220amqwJq7w1IFo/JTMOYeYyL2BoQViV6VhFpvJIDfYFo8G8dJTVclx9oTIc3dYXNcf5VE3YyWUTNOwk/X6vNbdqlP4au4RIXaWEQ05RtaXB0MQFByC7vtZipDRuDIAf1VzPttgbKq4TxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com; spf=pass smtp.mailfrom=rock-chips.com; dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b=jxtn3Rd1; arc=none smtp.client-ip=45.254.49.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b="jxtn3Rd1"
DKIM-Signature: a=rsa-sha256;
	b=jxtn3Rd1dLBgtCF2/hGkKe+XQ1bpjqEgLAv3lWNrgqm6FilohfU+F12mqV0P+BwM/XrmN8Xcj0Ip3d7Tji7nBKP7ovFnk10ZvS6il04Jvom6PgzSSpXMWw+KgnA/1wyrO+z/b9Q15wLx87U/lmE+tf3ph3r5Qrf10uqey4XVPh8=; c=relaxed/relaxed; s=default; d=rock-chips.com; v=1;
	bh=eBvF1yVRkPrWREGioo9SaAdk0UUJh165NjxJgk+YcKM=;
	h=date:mime-version:subject:message-id:from;
Received: from [172.16.12.69] (unknown [58.22.7.114])
	by smtp.qiye.163.com (Hmail) with ESMTPA id 6CD9A460411;
	Thu,  8 Aug 2024 14:10:26 +0800 (CST)
Message-ID: <659b9e09-b98d-48e0-ad0f-bfb2fe2148bc@rock-chips.com>
Date: Thu, 8 Aug 2024 14:10:26 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: shawn.lin@rock-chips.com, linux-rockchip@lists.infradead.org,
 Liang Chen <cl@rock-chips.com>, Rob Herring <robh+dt@kernel.org>,
 linux-kernel@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Conor Dooley <conor+dt@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
 Alim Akhtar <alim.akhtar@samsung.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 YiFeng Zhao <zyf@rock-chips.com>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 devicetree@vger.kernel.org,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Heiko Stuebner <heiko@sntech.de>, Avri Altman <avri.altman@wdc.com>,
 linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 2/3] dt-bindings: ufs: Document Rockchip UFS host
 controller
To: "Rob Herring (Arm)" <robh@kernel.org>
References: <1723089163-28983-1-git-send-email-shawn.lin@rock-chips.com>
 <1723089163-28983-3-git-send-email-shawn.lin@rock-chips.com>
 <172309498853.3975217.8775988957925335272.robh@kernel.org>
Content-Language: en-GB
From: Shawn Lin <shawn.lin@rock-chips.com>
In-Reply-To: <172309498853.3975217.8775988957925335272.robh@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFDSUNOT01LS0k3V1ktWUFJV1kPCRoVCBIfWUFZQkJOSlZPHU0fTEtOTB1LHkpWFRQJFh
	oXVRMBExYaEhckFA4PWVdZGBILWUFZTkNVSUlVTFVKSk9ZV1kWGg8SFR0UWUFZT0tIVUpLSUhCSE
	NVSktLVUpCS0tZBg++
X-HM-Tid: 0a91309c2dc503aekunm6cd9a460411
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MCo6Vhw5NzI9TAs5GhdJHENC
	ATIKCz1VSlVKTElIS0JMT0lMQktLVTMWGhIXVQgTGgwVVRcSFTsJFBgQVhgTEgsIVRgUFkVZV1kS
	C1lBWU5DVUlJVUxVSkpPWVdZCAFZQU5PSkM3Bg++

Hi Rob

在 2024/8/8 13:29, Rob Herring (Arm) 写道:
> 
> On Thu, 08 Aug 2024 11:52:42 +0800, Shawn Lin wrote:
>> Document Rockchip UFS host controller for RK3576 SoC.
>>
>> Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
>>
>> ---
>>
>> Changes in v2:
>> - renmae file name
>> - fix all errors and pass the dt_binding_check:
>>    make dt_binding_check DT_SCHEMA_FILES=rockchip,rk3576-ufs.yaml
>>
>>   .../bindings/ufs/rockchip,rk3576-ufs.yaml          | 96 ++++++++++++++++++++++
>>   1 file changed, 96 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/ufs/rockchip,rk3576-ufs.yaml
>>
> 
> My bot found errors running 'make dt_binding_check' on your patch:
> 
> yamllint warnings/errors:
> 
> dtschema/dtc warnings/errors:
> /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/ufs/rockchip,rk3576-ufs.yaml: $id: Cannot determine base path from $id, relative path/filename doesn't match actual path or filename
>   	 $id: http://devicetree.org/schemas/ufs/rockchip,ufs.yaml
>   	file: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/ufs/rockchip,rk3576-ufs.yaml

This is already fixed by a resend v2 2/3 patch, a moment ago. Sorry for 
that.

> Documentation/devicetree/bindings/ufs/rockchip,rk3576-ufs.example.dts:24:18: fatal error: dt-bindings/clock/rockchip,rk3576-cru.h: No such file or directory
>     24 |         #include <dt-bindings/clock/rockchip,rk3576-cru.h>
>        |                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> compilation terminated.

There are still pending patches from Rockchip in queue for review. This
patchset is based on them. I will wait for more comments and update them
after all under-review patches got merged.

Thanks.

> make[2]: *** [scripts/Makefile.lib:427: Documentation/devicetree/bindings/ufs/rockchip,rk3576-ufs.example.dtb] Error 1
> make[2]: *** Waiting for unfinished jobs....
> make[1]: *** [/builds/robherring/dt-review-ci/linux/Makefile:1430: dt_binding_check] Error 2
> make: *** [Makefile:240: __sub-make] Error 2
> 
> doc reference errors (make refcheckdocs):
> 
> See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/1723089163-28983-3-git-send-email-shawn.lin@rock-chips.com
> 
> The base for the series is generally the latest rc1. A different dependency
> should be noted in *this* patch.
> 
> If you already ran 'make dt_binding_check' and didn't see the above
> error(s), then make sure 'yamllint' is installed and dt-schema is up to
> date:
> 
> pip3 install dtschema --upgrade
> 
> Please check and re-submit after running the above command yourself. Note
> that DT_SCHEMA_FILES can be set to your schema file to speed up checking
> your schema. However, it must be unset to test all examples with your schema.
> 
