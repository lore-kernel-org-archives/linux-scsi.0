Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4512612B94;
	Thu, 27 Nov 2025 00:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764205192; cv=none; b=fM4uys0b0Jh4Rp4EQ+Nmfarpq4yVL0Ynk73YoD7JvLMnu9BxHV/o5AH1G5KGoa1t3gRaqQLEr13F5tCwMcG3GAh0dYyTKyHE3WHNFJUxA/AEOYo3wmwdhepCwV6vhlCipBAE2v+W8uhf86TXJcbkPQwnGT1FrYfp/mdthB9S6yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764205192; c=relaxed/simple;
	bh=9tckUlbgGrHZ8ZgywRmXJKA2obmBPuu3PG1KJzbyvfU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=VIeU6QSzsKTCCbd1xMEQdvF9CjAj11DydSet5DH+rDAnewyHqKicGlLSef8sNmeIsbVt7de34dQPodqe98+RwSMHrdPealo9F1eRH+UIHAHkBQh/+fPO0o2H7Q5Y+NYQoRvBN8J5RScxEpMS8I+bJyTm0u0D8gyV1RBpBX3zBzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=dFn/N/op; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="dFn/N/op"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=bALN4vBfPiVn8XhZSRW81vm8RNSbyIyqru3W3nduG9w=;
	b=dFn/N/opp6TBcpxgZHbWHB2ocqcHqEnf3gtwt7HeRuVPlJx9BBwRrBTkbuZVxrnrP1qC6Txtw
	EPFrpLmjO90DczMmrrLMcOcXQjp+kBo8ngxhRSPTSS36qwzV5mnUQCTVsrQKj+UWXvbaktZhbiA
	sMKXbvRaTpYaKZO5rlxQBwg=
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4dGyhg6Mwpz1prLM;
	Thu, 27 Nov 2025 08:57:55 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id 578BB1402CC;
	Thu, 27 Nov 2025 08:59:45 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 27 Nov 2025 08:59:44 +0800
Message-ID: <88a3dd70-69a7-affd-8495-9333f95350d0@huawei.com>
Date: Thu, 27 Nov 2025 08:59:44 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH] Revert "scsi: libsas: Fix exp-attached device scan after
 probe failure scanned in again after probe failed"
Content-Language: en-CA
To: <john.g.garry@oracle.com>, <yanaijie@huawei.com>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@h-partners.com>, <liuyonglong@huawei.com>,
	<kangfenglong@huawei.com>
References: <20251021073438.3441934-1-yangxingui@huawei.com>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <20251021073438.3441934-1-yangxingui@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepemh200004.china.huawei.com (7.202.181.111) To
 kwepemj100018.china.huawei.com (7.202.194.12)

Kindly ping for upstream.

On 2025/10/21 15:34, Xingui Yang wrote:
> This reverts commit ab2068a6fb84751836a84c26ca72b3beb349619d.
> 
> As the disk may fall into an abnormal loop of probe when it fails to probe
> due to physical reasons and cannot be repaired.
> 
> Signed-off-by: Xingui Yang <yangxingui@huawei.com>
> ---
>   drivers/scsi/libsas/sas_internal.h | 14 --------------
>   1 file changed, 14 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
> index 03d6ec1eb970..85948963fb97 100644
> --- a/drivers/scsi/libsas/sas_internal.h
> +++ b/drivers/scsi/libsas/sas_internal.h
> @@ -145,20 +145,6 @@ static inline void sas_fail_probe(struct domain_device *dev, const char *func, i
>   		func, dev->parent ? "exp-attached" :
>   		"direct-attached",
>   		SAS_ADDR(dev->sas_addr), err);
> -
> -	/*
> -	 * If the device probe failed, the expander phy attached address
> -	 * needs to be reset so that the phy will not be treated as flutter
> -	 * in the next revalidation
> -	 */
> -	if (dev->parent && !dev_is_expander(dev->dev_type)) {
> -		struct sas_phy *phy = dev->phy;
> -		struct domain_device *parent = dev->parent;
> -		struct ex_phy *ex_phy = &parent->ex_dev.ex_phy[phy->number];
> -
> -		memset(ex_phy->attached_sas_addr, 0, SAS_ADDR_SIZE);
> -	}
> -
>   	sas_unregister_dev(dev->port, dev);
>   }
>   
> 
