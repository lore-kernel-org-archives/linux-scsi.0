Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CAA12882B7
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2025 06:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753424657; cv=none; b=STjAj+XXNg70LpT5KAJlpPUaQHPc7fQj/6NkjZLCVgC1lADyWuKCabLqZHNpqgfzVIyHcTKFsJE3/I/4ryyqZMs6P5bjgd0VyhqUG7z4Gzv14urDPjsXVrXsB+p8isfohMw7QpBB0GXY39odcGY5akKdjkZKLcl8XxYU9is6tl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753424657; c=relaxed/simple;
	bh=jk6EkqarGR5k8WFM0eekxOthQsmMZZ3m6f5uoI7huGk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=R77IftBFFuIIaSw5Zw1Ic6ahUqQD4cLikGCKzXFY4GAnjxK7PpgwCc4A4B8LQYdtK8p9mruEbkvZaeAgmfAWLaN55gTyfH6QeMvbwR1EU7xyFx6Ii0Nd5t0Y6CBGhq3l9Hzp0ZccbYUoHyM1gSmMPhGKlVRTew9y9Argbo4y7RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4bpHt10RwLz27j3c;
	Fri, 25 Jul 2025 14:25:13 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id 798751A016C;
	Fri, 25 Jul 2025 14:24:12 +0800 (CST)
Received: from [10.174.176.253] (10.174.176.253) by
 dggpemf500002.china.huawei.com (7.185.36.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 25 Jul 2025 14:24:11 +0800
Message-ID: <4aa156ec-c71b-4155-b5fe-7a1ed08c5d4c@huawei.com>
Date: Fri, 25 Jul 2025 14:24:10 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/5] scsi: libsas: Use a bool for sas_deform_port()
 second argument
To: Damien Le Moal <dlemoal@kernel.org>, <linux-scsi@vger.kernel.org>, "Martin
 K . Petersen" <martin.petersen@oracle.com>, John Garry
	<john.g.garry@oracle.com>
References: <20250725015818.171252-1-dlemoal@kernel.org>
 <20250725015818.171252-6-dlemoal@kernel.org>
From: Jason Yan <yanaijie@huawei.com>
In-Reply-To: <20250725015818.171252-6-dlemoal@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf500002.china.huawei.com (7.185.36.57)

在 2025/7/25 9:58, Damien Le Moal 写道:
> Change the type of the "gone" argument of sas_deform_port() from int to
> bool. Simliarly, to be consistent, do the same change to the function
> sas_unregister_domain_devices().
> 
> No functional changes.
> 
> Signed-off-by: Damien Le Moal<dlemoal@kernel.org>
> Reviewed-by: Johannes Thumshirn<johannes.thumshirn@wdc.com>
> Reviewed-by: John Garry<john.g.garry@oracle.com>
> ---
>   drivers/scsi/libsas/sas_discover.c |  2 +-
>   drivers/scsi/libsas/sas_internal.h |  4 ++--
>   drivers/scsi/libsas/sas_phy.c      |  6 +++---
>   drivers/scsi/libsas/sas_port.c     | 13 ++++++-------
>   4 files changed, 12 insertions(+), 13 deletions(-)

Reviewed-by: Jason Yan <yanaijie@huawei.com>
