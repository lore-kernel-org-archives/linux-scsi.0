Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65CB23F421
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2025 06:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753424256; cv=none; b=iw9nNp8bmdryR/dMeECbr0RBEK5RbbSWK1Ox/WtNErJci82ODQsrNe/aSnZo4PB7vCfoYBMVJv07H8EvzDbjkVZR7zvbdX8hPYz2+acMPXUZcHeXa4nbly/gqBFsULbr9QPWyo+GNXl75FbfaoWB/+Q+iZVByf0rPNTeiDJDnSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753424256; c=relaxed/simple;
	bh=iV2aDKNj9gPGUh2+oB55nD+ow4wDRm6Xr/eSAKewTAc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=kf7q4mF4nY1dLCzZGZ/0OtCJVzI67wfMp7/rgjY4VsFdSTwt/Qm0xt5x0thJBWMQYd5OnGsYPMJffq/xeAiVro5/SWp8Rjjo+zVQfPdyvK3AFCGIGXikISvy43C6bq82i0BZod9Ky26qcz6J6KFg60mEAdSaDLDu+P7klMwHgag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4bpHcH4cz4z2CfwJ;
	Fri, 25 Jul 2025 14:13:19 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id 9FFFE1A016C;
	Fri, 25 Jul 2025 14:17:30 +0800 (CST)
Received: from [10.174.176.253] (10.174.176.253) by
 dggpemf500002.china.huawei.com (7.185.36.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 25 Jul 2025 14:17:30 +0800
Message-ID: <b95b0050-c87c-40a0-8d1e-fe80b09f0402@huawei.com>
Date: Fri, 25 Jul 2025 14:17:28 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/5] scsi: libsas: Refactor dev_is_sata()
To: Damien Le Moal <dlemoal@kernel.org>, <linux-scsi@vger.kernel.org>, "Martin
 K . Petersen" <martin.petersen@oracle.com>, John Garry
	<john.g.garry@oracle.com>
References: <20250725015818.171252-1-dlemoal@kernel.org>
 <20250725015818.171252-2-dlemoal@kernel.org>
From: Jason Yan <yanaijie@huawei.com>
In-Reply-To: <20250725015818.171252-2-dlemoal@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf500002.china.huawei.com (7.185.36.57)

在 2025/7/25 9:58, Damien Le Moal 写道:
> Use a switch statement in dev_is_sata() to make the code more readable
> (and probably slightly better than a series of or conditions). Also have
> this inline function return a boolean instead of an integer.
> 
> No functional changes.
> 
> Signed-off-by: Damien Le Moal<dlemoal@kernel.org>
> Reviewed-by: John Garry<john.g.garry@oracle.com>
> ---
>   include/scsi/sas_ata.h | 17 ++++++++++++-----
>   1 file changed, 12 insertions(+), 5 deletions(-)

Reviewed-by: Jason Yan <yanaijie@huawei.com>
