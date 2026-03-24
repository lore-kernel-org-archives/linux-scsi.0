Received: from mail-m3295.qiye.163.com (mail-m3295.qiye.163.com [220.197.32.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73877329C48;
	Tue, 24 Mar 2026 07:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.32.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774337521; cv=none; b=gYz5i19n8+VNW47QSiPUfoyzLCctD3P2nFmRL43VYJ7/VDYwKrSx+k5qWY68HrH7+o3yGvRhK2m53+3FKt3317KfeB6mcDh6Rce2hZhQ7j0IdAaAIbna7RPUNLypWW2ER1raug5DgNs/J4Y+okGy698jY+g1Xert0NCJgEYDP2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774337521; c=relaxed/simple;
	bh=9/Y0gTQsbY8e/pvAsINKkFu1K23v0cKgJ6ZimmcaCo4=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=dubXbHhpF/Zy5/huHj73RTluwCzLtvkMwFyZp9cocTNK5HZvG5bHACPe4UDHU0LOTta1fa7B/35ksqBZLr90iFI1FKniYivaSqgYzqSmYG1jCt52IrEuYVvtqDk0S0XDkWwVwL+vuo/hNTVgmjHlfzx0vYX748DbOJdHNpFG5No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com; spf=pass smtp.mailfrom=rock-chips.com; dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b=JeS80Zun; arc=none smtp.client-ip=220.197.32.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b="JeS80Zun"
Received: from [172.16.12.17] (unknown [58.22.7.114])
	by smtp.qiye.163.com (Hmail) with ESMTP id 3812347a3;
	Tue, 24 Mar 2026 15:31:39 +0800 (GMT+08:00)
Message-ID: <418f84d2-fb2c-c4a3-6690-c86ec44d594f@rock-chips.com>
Date: Tue, 24 Mar 2026 15:31:38 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Cc: shawn.lin@rock-chips.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Heiko Stuebner <heiko@sntech.de>
Subject: Re: [PATCH v1 1/1] scsi: ufs: rockchip: Drop unused include
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20260320215606.3236516-1-andriy.shevchenko@linux.intel.com>
From: Shawn Lin <shawn.lin@rock-chips.com>
In-Reply-To: <20260320215606.3236516-1-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9d1ec1a10009cckunm623cadc09c6d83
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFDSUNOT01LS0k3V1ktWUFJV1kPCRoVCBIfWUFZQkJIGFZOHktDHU4fGBlPSx9WFRQJFh
	oXVRMBExYaEhckFA4PWVdZGBILWUFZTkNVSUlVTFVKSk9ZV1kWGg8SFR0UWUFZT0tIVUpLSU9PT0
	hVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=JeS80Zun1dOnGKzrio4K+VZ2PPPO3DJFTJeTYaTN0KG9mrg7FpwvVzLlzn0yn68uopv2X3SaR7uJB5V+MDT19eqNh/qx9zSRpDRIduhrPQlhgxz8gIM2qC3IXcagu6h0nhTePVbJpqG0j1j+qgFzlWpHkLOiGKh/NISYsnpiN3g=; s=default; c=relaxed/relaxed; d=rock-chips.com; v=1;
	bh=RqovqAVOh/J3GxdWkjwkCOMcif7wlkSPNm8sBdge6o4=;
	h=date:mime-version:subject:message-id:from;

在 2026/03/21 星期六 5:56, Andy Shevchenko 写道:
> This driver includes the legacy header <linux/gpio.h> but does
> not use any symbols from it. Drop the inclusion.

Reviewed-by: Shawn Lin <shawn.lin@rock-chips.com>

> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>   drivers/ufs/host/ufs-rockchip.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/ufs/host/ufs-rockchip.c b/drivers/ufs/host/ufs-rockchip.c
> index 7fff34513a60..bac68f238e1c 100644
> --- a/drivers/ufs/host/ufs-rockchip.c
> +++ b/drivers/ufs/host/ufs-rockchip.c
> @@ -6,7 +6,6 @@
>    */
>   
>   #include <linux/clk.h>
> -#include <linux/gpio.h>
>   #include <linux/gpio/consumer.h>
>   #include <linux/mfd/syscon.h>
>   #include <linux/of.h>
