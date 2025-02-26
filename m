Received: from mail-m49236.qiye.163.com (mail-m49236.qiye.163.com [45.254.49.236])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D5E2258CCB;
	Wed, 26 Feb 2025 08:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.236
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740557091; cv=none; b=u2iinM3ewDtgUSX/bEmBUjkfdE5mCBaxYHw+xSXXdrXOakTEGbpvHkGCF6qxRSdtIqNo9R42IVUD3mwLyArpJGdaMe82volLu7Rznh3Z6E2iRHPUJ2gwToVnAbvPvXcCqxz2v688Es5FWwbd5BZ2Gf4J7zD3hz4t6yQIOaf8w3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740557091; c=relaxed/simple;
	bh=l8E5RKP2L+w9L35Iyf+g+FiycmYARSKEIs/aumVhbF8=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=HzT+vILxpjNC0TvE5yK7DqRtZLehQwW9RCk0tLTZhu+eh/WxOoqv1t8yig2WJzaLXnzSvjOaEjSHPDTOm2LGjD6w1FiRwsU3HkYrejKgQdAL7kWatBm3HN/dFOVIibnFl+wgnsNrAzxJzt8gREXAhvC+YKXCRS/ZbB3OISZLRF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com; spf=pass smtp.mailfrom=rock-chips.com; dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b=M1sany9x; arc=none smtp.client-ip=45.254.49.236
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b="M1sany9x"
Received: from [172.16.12.45] (unknown [58.22.7.114])
	by smtp.qiye.163.com (Hmail) with ESMTP id c3c2a2d3;
	Wed, 26 Feb 2025 14:48:58 +0800 (GMT+08:00)
Message-ID: <a4f43d3e-2e41-4163-8938-5aa1592db371@rock-chips.com>
Date: Wed, 26 Feb 2025 14:48:59 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: shawn.lin@rock-chips.com, kernel-janitors@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] scsi: ufs: rockchip: Fix spelling mistake "susped"
 -> "suspend"
To: Colin Ian King <colin.i.king@gmail.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Heiko Stuebner <heiko@sntech.de>, linux-scsi@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-rockchip@lists.infradead.org
References: <20250225101142.161474-1-colin.i.king@gmail.com>
Content-Language: en-GB
From: Shawn Lin <shawn.lin@rock-chips.com>
In-Reply-To: <20250225101142.161474-1-colin.i.king@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFDSUNOT01LS0k3V1ktWUFJV1kPCRoVCBIfWUFZQkNCHlYdTBlJHhodGBpOSENWFRQJFh
	oXVRMBExYaEhckFA4PWVdZGBILWUFZTkNVSUlVTFVKSk9ZV1kWGg8SFR0UWUFZT0tIVUpLSU9PT0
	hVSktLVUpCS0tZBg++
X-HM-Tid: 0a9541040a1509cckunmc3c2a2d3
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Ngg6PBw4UTILHQsaTh4TMzIq
	VhkKCSNVSlVKTE9LTk5JTkhCTEpJVTMWGhIXVQgTGgwVVRcSFTsJFBgQVhgTEgsIVRgUFkVZV1kS
	C1lBWU5DVUlJVUxVSkpPWVdZCAFZQUNNTjcG
DKIM-Signature:a=rsa-sha256;
	b=M1sany9xNBK7VREkWV+9K9oI/K7EOJWY8i/mkHFni5If+uuFp4nTfsfWo9NCBVfDJdv9SDXXVnASaacyLeGHJB5rIQt9n3k0cBugM1hAYPP0B+QlPaT6e/DmwYoHFTvU8BUo6xe397yo4rW3fLRhW2Du3oV/FRStof5aetgnBqQ=; s=default; c=relaxed/relaxed; d=rock-chips.com; v=1;
	bh=vU92AfkXpo1upHQPW1E57oSrBRV5YkhXMeN9wMA5lys=;
	h=date:mime-version:subject:message-id:from;

在 2025/2/25 18:11, Colin Ian King 写道:
> There is a spelling mistake in a dev_err message. Fix it.
> 

Acked-by: Shawn Lin <shawn.lin@rock-chips.com>

Thanks Colin.


> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>   drivers/ufs/host/ufs-rockchip.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/host/ufs-rockchip.c b/drivers/ufs/host/ufs-rockchip.c
> index 5b0ea9820767..dddff5f538b9 100644
> --- a/drivers/ufs/host/ufs-rockchip.c
> +++ b/drivers/ufs/host/ufs-rockchip.c
> @@ -307,7 +307,7 @@ static int ufs_rockchip_system_suspend(struct device *dev)
>   
>   	err = ufshcd_system_suspend(dev);
>   	if (err) {
> -		dev_err(hba->dev, "UFSHCD system susped failed %d\n", err);
> +		dev_err(hba->dev, "UFSHCD system suspend failed %d\n", err);
>   		return err;
>   	}
>   

