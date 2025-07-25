Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4583F2882C3
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2025 06:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753424605; cv=none; b=u33t2hqf81C4xMuv97JZsGWzLGy5yZQbBdSdR2wY5JDpDQsHQCqZnAs1tafb/XpfJQfyy6KI/f7ukiffRuJKcUEVZi01otkXndf1A8D82yUSFq3HXcApL5DNEYw8EN7Esjky/ubEKMllPUNqQCfPpt+GBeRnmTxE35NnbO2Up2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753424605; c=relaxed/simple;
	bh=Qd7hZSHuFw5av6IWn9atnHryN7UphkIiyYdWxqKujiI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=O2WTqhvzuBAkTbuPUmameZ4Rs5fTb4RS4s7cwjby3/O4aHn8CoXtkV9kUFQrZ8/wlYtMf/4Qa/uMC50rfIfFQ4Xcl6Iayiv0Kw/vRyuyNPDlC/NMlod3NTHSo4e0KwH+4tj1FmcYIyFqbHIRM3u5sMGfHzuazyiu3F/ToPFluVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4bpHnF1mggz2RVxn;
	Fri, 25 Jul 2025 14:21:05 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id F1DB3140145;
	Fri, 25 Jul 2025 14:23:20 +0800 (CST)
Received: from [10.174.176.253] (10.174.176.253) by
 dggpemf500002.china.huawei.com (7.185.36.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 25 Jul 2025 14:23:20 +0800
Message-ID: <36a13492-2c20-4753-ae81-3dbe5ab0cc8f@huawei.com>
Date: Fri, 25 Jul 2025 14:23:19 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/5] scsi: libsas: Move declarations of internal
 functions to sas_internal.h
To: Damien Le Moal <dlemoal@kernel.org>, <linux-scsi@vger.kernel.org>, "Martin
 K . Petersen" <martin.petersen@oracle.com>, John Garry
	<john.g.garry@oracle.com>
References: <20250725015818.171252-1-dlemoal@kernel.org>
 <20250725015818.171252-5-dlemoal@kernel.org>
From: Jason Yan <yanaijie@huawei.com>
In-Reply-To: <20250725015818.171252-5-dlemoal@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf500002.china.huawei.com (7.185.36.57)

在 2025/7/25 9:58, Damien Le Moal 写道:
> Move the declaration of all functions used only within libsas from
> include/scsi/sas_ata.h to drivers/scsi/libsas/sas_internal.h.
> 
> No functional changes.
> 
> Signed-off-by: Damien Le Moal<dlemoal@kernel.org>
> Reviewed-by: Johannes Thumshirn<johannes.thumshirn@wdc.com>
> Reviewed-by: John Garry<john.g.garry@oracle.com>
> ---
>   drivers/scsi/libsas/sas_internal.h | 74 ++++++++++++++++++++++++++++++
>   include/scsi/sas_ata.h             | 68 +--------------------------
>   2 files changed, 75 insertions(+), 67 deletions(-)

Reviewed-by: Jason Yan <yanaijie@huawei.com>
