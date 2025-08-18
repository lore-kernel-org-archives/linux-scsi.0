Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8137F8632B
	for <linux-scsi@vger.kernel.org>; Mon, 18 Aug 2025 03:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755486449; cv=none; b=FShtxRGjgTEf5U/UC40VOSHt2K5XGslQFPjViktMFzgIYYcmpX+5TPPYlV1Vlv3Zy9jnZ8D90jvdicN6qHTvSGuiqxFkU5Oam4wz3vIki08ZugZl0EORcaP3VRbLgEnDAE1FxRg7kN1bg/eM/gYbqgreL4wv0ThuQRQWVNaK36c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755486449; c=relaxed/simple;
	bh=Wwt1JDVe6knZRt4ngR2UNWkiCmpBmCDEOCWIiUaS014=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=HtIarpBXxCkzK895LXKRb2i05EDl9hn1gRmSdPJjvUGfCYYHEWbLx70gPR6u6GwIw6M+GdQmiJBc4Z8wui/Y3aMut2wQgVSDvvn8nmkXCaEkwbh8zMufhgUohenhmo27sM1zMT0BIIFvEsHqGkA17Vh4DXs8UTtPfOGCbW9zhcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4c4yFd3fbmzdcM3;
	Mon, 18 Aug 2025 11:03:01 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id 8054C1401F0;
	Mon, 18 Aug 2025 11:07:23 +0800 (CST)
Received: from [10.174.176.253] (10.174.176.253) by
 dggpemf500002.china.huawei.com (7.185.36.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 18 Aug 2025 11:07:22 +0800
Message-ID: <7180a7f0-4bc2-4e82-8b3f-60b9bc6f6d0f@huawei.com>
Date: Mon, 18 Aug 2025 11:07:21 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/10] scsi: libsas: Add dev_parent_is_expander()
 helper
To: Niklas Cassel <cassel@kernel.org>, John Garry <john.g.garry@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K.
 Petersen" <martin.petersen@oracle.com>
CC: Damien Le Moal <dlemoal@kernel.org>, <linux-scsi@vger.kernel.org>
References: <20250814173215.1765055-12-cassel@kernel.org>
 <20250814173215.1765055-15-cassel@kernel.org>
From: Jason Yan <yanaijie@huawei.com>
In-Reply-To: <20250814173215.1765055-15-cassel@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf500002.china.huawei.com (7.185.36.57)

在 2025/8/15 1:32, Niklas Cassel 写道:
> Many libsas drivers check if the parent of the device is an expander.
> Create a helper that the libsas drivers will use in follow up commits.
> 
> Suggested-by: Damien Le Moal<dlemoal@kernel.org>
> Signed-off-by: Niklas Cassel<cassel@kernel.org>
> ---
>   drivers/scsi/libsas/sas_expander.c | 5 +----
>   include/scsi/libsas.h              | 8 ++++++++
>   2 files changed, 9 insertions(+), 4 deletions(-)

Reviewed-by: Jason Yan <yanaijie@huawei.com>
