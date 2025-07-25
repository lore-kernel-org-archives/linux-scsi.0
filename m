Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0305E286424
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2025 06:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753424557; cv=none; b=jJpJ8NlG3ytHvGCCJMRYtc67CbT6NC49oDACV2MySO96czOatmWkAbRGefupJiIP7iAOAfIf3ALhMea23rPBgFDET2VFCmAOzvV2XCs+1++JN2ArYunFg2Lkh4YJvL5ce5vWcrK82jeSKBROjloMKGbwKe2JT8GaYqaGNtM5uwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753424557; c=relaxed/simple;
	bh=wj60LROqWJYBVs6qdpzRc3ARpOZ+72FxIdjOG+EPkXw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=WJ+mAxGsqGAt/cjMcpeFut8obZYgh73V4DAp+2HqFuK1FxFHGsPxFv9d/U6wQPl6WTX7n7ZqdqlP16hcup4LybK/t7RR9hFJAXl+mMAWxllnd3iVNoK8ZOHm95vsF63rtu4543+JA9jvQPHWOvafFUU2eRb3f4CwQfL5OB4Y/us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4bpHjg1w5jzYdRp;
	Fri, 25 Jul 2025 14:17:59 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id 33AC81400DC;
	Fri, 25 Jul 2025 14:22:32 +0800 (CST)
Received: from [10.174.176.253] (10.174.176.253) by
 dggpemf500002.china.huawei.com (7.185.36.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 25 Jul 2025 14:22:31 +0800
Message-ID: <0ba54ba3-34d4-4494-b2f5-0598e5fdae3a@huawei.com>
Date: Fri, 25 Jul 2025 14:22:30 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/5] scsi: libsas: Make sas_get_ata_info() static
To: Damien Le Moal <dlemoal@kernel.org>, <linux-scsi@vger.kernel.org>, "Martin
 K . Petersen" <martin.petersen@oracle.com>, John Garry
	<john.g.garry@oracle.com>
References: <20250725015818.171252-1-dlemoal@kernel.org>
 <20250725015818.171252-4-dlemoal@kernel.org>
From: Jason Yan <yanaijie@huawei.com>
In-Reply-To: <20250725015818.171252-4-dlemoal@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf500002.china.huawei.com (7.185.36.57)

在 2025/7/25 9:58, Damien Le Moal 写道:
> The function sas_get_ata_info() is used only in
> drivers/scsi/libsas/sas_ata.c. Remove its definition from
> include/scsi/sas_ata.h and make this function static.
> 
> No functional changes.
> 
> Signed-off-by: Damien Le Moal<dlemoal@kernel.org>
> Reviewed-by: Johannes Thumshirn<johannes.thumshirn@wdc.com>
> Reviewed-by: John Garry<john.g.garry@oracle.com>
> ---
>   drivers/scsi/libsas/sas_ata.c | 2 +-
>   include/scsi/sas_ata.h        | 6 ------
>   2 files changed, 1 insertion(+), 7 deletions(-)

Reviewed-by: Jason Yan <yanaijie@huawei.com>
