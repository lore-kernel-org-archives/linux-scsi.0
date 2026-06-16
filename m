Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90B0349B19;
	Tue, 16 Jun 2026 11:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781609613; cv=none; b=lTF9gGJGND4VkmsXOFKK+U0QvzeISv45BScBkrG/JyKqbA80IGopNo5W3FySATD1GWfvYNCSzBU2UERFkH16hRSNqcvU7GwIPShk4rArIUHGpTDDu2/R+/UPDaTvkMIRed+YgWYCFevvjgYBen+vlizcv9/kifDfKWGTXgkf/4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781609613; c=relaxed/simple;
	bh=jO2EQS1eMENaMxYKwwdaafvhE9VeswxK+Tht650orUA=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=YH6byEjdR7jF6559XlzAIhGSPrcE1aET08PsABmh9eqPLt7Qmy2/Xl52CV+yMHDbt+frxwJxUtkaaVoE/V2o9fIJBCtA4uUbklWa/v3AbI0yrQBOD7g6ZOfqcHH+6ZpYWM10x4ZPuoEJeeENBmPV+Uufp50wzud53Ouz+mHimQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=fgNPcwQH; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="fgNPcwQH"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Y5iP/6wM6lXFdwlTmZRHjapFJuc/IMBjLQslUX/pMUg=;
	b=fgNPcwQHlPjEpMFptjKSLMmxbGyFXD/Adc+R8yRCNkNE0bc4pYxTtm7z1FJ6yM2BeAtMhpOG+
	AGwE/0dueTc2aHNMpGuzpXBDaEWsJvWBu9hk4j2OaUJD9EMCA+k05VZ2p7BrW2avNtvCXNdMmWK
	dXrvCRqLktbU5/XOm9R0C0Q=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4gfl5w5Y5qzpStZ;
	Tue, 16 Jun 2026 19:25:24 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id 4F00940363;
	Tue, 16 Jun 2026 19:33:26 +0800 (CST)
Received: from [10.174.179.11] (10.174.179.11) by
 dggpemf500002.china.huawei.com (7.185.36.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 16 Jun 2026 19:33:25 +0800
Message-ID: <28cd53d2-4b5b-48af-ae20-1fec785a1993@huawei.com>
Date: Tue, 16 Jun 2026 19:33:24 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: Update HiSilicon hisi_sas driver maintainer
 to Xingui Yang
To: Yihang Li <liyihang9@huawei.com>, <martin.petersen@oracle.com>,
	<James.Bottomley@HansenPartnership.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@h-partners.com>, <liuyonglong@huawei.com>,
	<prime.zeng@hisilicon.com>
References: <20260616032051.1268608-1-liyihang9@huawei.com>
From: Jason Yan <yanaijie@huawei.com>
In-Reply-To: <20260616032051.1268608-1-liyihang9@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf500002.china.huawei.com (7.185.36.57)

在 2026/6/16 11:20, Yihang Li 写道:
> Replace myself with Xingui Yang who is very familiar with the HiSilicon
> hisi_sas drivers.
> 
> Signed-off-by: Yihang Li <liyihang9@huawei.com>
> ---
>   MAINTAINERS | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a068db0ade61..6760865a2bad 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11675,7 +11675,7 @@ F:	Documentation/devicetree/bindings/infiniband/hisilicon-hns-roce.txt
>   F:	drivers/infiniband/hw/hns/
>   
>   HISILICON SAS Controller
> -M:	Yihang Li <liyihang9@h-partners.com>
> +M:	Xingui Yang <yangxingui@huawei.com>
>   S:	Supported
>   W:	http://www.hisilicon.com
>   F:	Documentation/devicetree/bindings/scsi/hisilicon-sas.txt


Reviewed-by: Jason Yan <yanaijie@huawei.com>
