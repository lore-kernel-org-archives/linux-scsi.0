Received: from mail-m1826.xmail.ntesmail.com (mail-m1826.xmail.ntesmail.com [45.195.18.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77CB79D0;
	Fri,  9 Aug 2024 00:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.195.18.26
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723163705; cv=none; b=k60yHEWXzU9SJb6pSeSPkU+lVh03JBWtqHMHCe3Ue2IebxPaEv+Ibd9MkT5qUfzM+fls8muelJhcsVTZNErn91tvzY8r1WaXTCZxNrfCtacql0x2N+GVOwyC1vckNANCJttINTczt01j1Ls6ji5sqow/v3ZgU2sqQNWQ7TprVc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723163705; c=relaxed/simple;
	bh=NOUA8uBOnVyXK1muBe0S1GGnrSoVftaHERh6PrFYKO0=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=nHrQjI0NtADmlWv2TfcP6CNlKhXH+DvAylOwV+646tUCzPIVNrAebSUK2lbV3DA4Gh4F5Oxi+zv74U9GL0xCNLSsUbxTIWHfe3RKKqHGWcr2DS/eCHn6aUOa4b2y6FFoXUcw3pCjqm6P3EJv5d1cikT5qlR+xlOBnKDwdNMTmbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com; spf=pass smtp.mailfrom=rock-chips.com; dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b=edXVeSU/; arc=none smtp.client-ip=45.195.18.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b="edXVeSU/"
DKIM-Signature: a=rsa-sha256;
	b=edXVeSU/tlo0ib3//1REPLrCrGzPmMGAbJm3CAlzPZhvvjtYXdpURz6fzWJRqREK209rGKFl4Mnfknvt4rURR71c6gbI97NTm64sCSnBJLfCptEdKn/b/XaPbkfgyt40oaizOpr81o53CLWEUmp/dczw5VCDwwFNDGDv8Go4JX4=; c=relaxed/relaxed; s=default; d=rock-chips.com; v=1;
	bh=0psmqwAZQghCEzaJP7VMmOIMVcUsXtkRYcmJbJCNZ2Q=;
	h=date:mime-version:subject:message-id:from;
Received: from [172.16.12.69] (unknown [58.22.7.114])
	by smtp.qiye.163.com (Hmail) with ESMTPA id EE3AE4601EB;
	Fri,  9 Aug 2024 08:33:56 +0800 (CST)
Message-ID: <009a9eb8-ff0f-4d77-8ff9-d54b92be5f0d@rock-chips.com>
Date: Fri, 9 Aug 2024 08:33:56 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: shawn.lin@rock-chips.com,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Heiko Stuebner <heiko@sntech.de>, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>,
 YiFeng Zhao <zyf@rock-chips.com>, Liang Chen <cl@rock-chips.com>,
 linux-scsi@vger.kernel.org, linux-rockchip@lists.infradead.org,
 linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 2/3] dt-bindings: ufs: Document Rockchip UFS host
 controller
To: Krzysztof Kozlowski <krzk@kernel.org>, Rob Herring <robh+dt@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>
References: <1723089163-28983-1-git-send-email-shawn.lin@rock-chips.com>
 <1723089163-28983-3-git-send-email-shawn.lin@rock-chips.com>
 <a4f8059f-efe0-4874-8746-24e4cf9b9e89@kernel.org>
Content-Language: en-GB
From: Shawn Lin <shawn.lin@rock-chips.com>
In-Reply-To: <a4f8059f-efe0-4874-8746-24e4cf9b9e89@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFDSUNOT01LS0k3V1ktWUFJV1kPCRoVCBIfWUFZGRhPQ1ZJS0MYQkoYT0tKQhlWFRQJFh
	oXVRMBExYaEhckFA4PWVdZGBILWUFZTkNVSUlVTFVKSk9ZV1kWGg8SFR0UWUFZT0tIVUpLSUhCSE
	NVSktLVUpCS0tZBg++
X-HM-Tid: 0a91348e790003aekunmee3ae4601eb
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Mxg6LQw*MjI9HwlNDyEZIRUU
	M0wKFAlVSlVKTElISk1ITUhDT0xOVTMWGhIXVQgTGgwVVRcSFTsJFBgQVhgTEgsIVRgUFkVZV1kS
	C1lBWU5DVUlJVUxVSkpPWVdZCAFZQU9PTEw3Bg++

Hi Krzysztof

在 2024/8/8 18:34, Krzysztof Kozlowski 写道:
> On 08/08/2024 05:52, Shawn Lin wrote:
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
> 
> 
> You did much more. Some properties appeared which were here not
> before... The way you send patches makes it difficult to review. Look:
> 

Yes, will update full changelog next version.

> b4 diff '<1723089163-28983-3-git-send-email-shawn.lin@rock-chips.com>'
> Grabbing thread from
> lore.kernel.org/all/1723089163-28983-3-git-send-email-shawn.lin@rock-chips.com/t.mbox.gz
> Checking for older revisions
> Grabbing search results from lore.kernel.org
>    Added from v1: 4 patches
> ---
> Analyzing 18 messages in the thread
> WARNING: duplicate messages found at index 2
>     Subject 1: dt-bindings: ufs: Document Rockchip UFS host controller
>     Subject 2: dt-bindings: ufs: Document Rockchip UFS host controller
>    2 is not a reply... assume additional patch
> Looking for additional code-review trailers on lore.kernel.org
> Analyzing 0 code-review messages
> Preparing fake-am for v1: Init support for RK3576 UFS controller
>    range: e86f0d80765d..3ae8e722f6ab
> Preparing fake-am for v2: scsi: ufs: core: Export
> ufshcd_dme_link_startup() helper
> ERROR: v2 series incomplete; unable to create a fake-am range
> ---
> Could not create fake-am range for upper series v2
> 
> 
> So how can we handle it? Your job is to use standard process so life of
> reviewers is not more difficult than it should be.
> 
> Provide FULL CHANGELOG with explanation what happened here.

Sorry for that. I'll improve them when the dependency is solved.

> 
> Best regards,
> Krzysztof
> 
