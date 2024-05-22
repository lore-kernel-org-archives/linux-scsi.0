Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601AA1EB2C;
	Wed, 22 May 2024 03:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716349921; cv=none; b=BqDAUZN1sM+L6pJxQPJLllTu+4isz9YVLNUh7QYZK8SQ+a4jmHkR5QZu8clcDouCVrQtL54B86Zsz9Zb60iuy68Rd8iEQHYYA40II82GpuBElGczKnjcCH5L5vm7u24IIdnVl4JBxcQO1fbhzH2uNQcn6AvJ41c+dwNfXqNi7Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716349921; c=relaxed/simple;
	bh=8xox/PDjOsQ4dGx+5veOoi4pG9AGPllF1yDdsefQ5n0=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=LXAsSPaHK2fPhmSiTKb7oXPK823qhdHVx3uiNM/pHBxDewlXjmJOEctnmSFOiZYaMltZMO9ZC2CpnhRFIxDVaE4/54mQLK3MfzszLkIpNLqLnWiCWzbQxublTbKgRZbnd4v4oyZ4HBRzz/+TUzRgl1cfwCZCoxjAK+BDqZx2xag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Vkcj6271Dz2Cj85;
	Wed, 22 May 2024 11:48:26 +0800 (CST)
Received: from canpemm500001.china.huawei.com (unknown [7.192.104.163])
	by mail.maildlp.com (Postfix) with ESMTPS id 0A99C1A0188;
	Wed, 22 May 2024 11:51:55 +0800 (CST)
Received: from canpemm500004.china.huawei.com (7.192.104.92) by
 canpemm500001.china.huawei.com (7.192.104.163) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 22 May 2024 11:51:53 +0800
Received: from [10.174.179.14] (10.174.179.14) by
 canpemm500004.china.huawei.com (7.192.104.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 22 May 2024 11:51:53 +0800
Subject: Re: [PATCH v2] scsi: libsas: Fix exp-attached end device cannot be
 scanned in again after probe failed
To: yangxingui <yangxingui@huawei.com>, <john.g.garry@oracle.com>,
	<jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<damien.lemoal@opensource.wdc.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <prime.zeng@hisilicon.com>,
	<chenxiang66@hisilicon.com>, <kangfenglong@huawei.com>
References: <20240424080807.8469-1-yangxingui@huawei.com>
 <c1835d80-ca48-766e-c174-d94a2d357925@huawei.com>
From: Jason Yan <yanaijie@huawei.com>
Message-ID: <a03ad30d-ecd3-0f88-cbaa-411cfed938ec@huawei.com>
Date: Wed, 22 May 2024 11:51:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <c1835d80-ca48-766e-c174-d94a2d357925@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500004.china.huawei.com (7.192.104.92)

On 2024/5/20 21:29, yangxingui wrote:
> Friendly ping ...

This looks good to me now,

Reviewed-by: Jason Yan <yanaijie@huawei.com>

Still it's better if John could have a look at this.

Thanks,
Jason

祝一切顺利
