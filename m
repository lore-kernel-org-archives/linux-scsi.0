Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C33B1BC58;
	Tue, 20 Aug 2024 01:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724117152; cv=none; b=OtUg94z/+ewxPJ9zW3ZKipcP4pd+pI6lMRfsOfAAczghUWh9BHgyTwtNXTHUVgckSu8VfDTZMGTvEn9ux4ttgf6wIjRyyykvZxKFrx/mLmpUPhbvlX8A1N5OzXppeBK+Q+DOgzKEg1iT/imE8tQEnvhaliGFqOS2uWeunC4moMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724117152; c=relaxed/simple;
	bh=ltGNretTtu1vKis5Qr5JrJc1GRGPHP9zlVyAbsNYovg=;
	h=Subject:To:References:CC:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=LKxI2+7WJRYs/4/ITOWF1T/1T0arezYoQcSVce7zqzf5Z1M5vLOxKzd7Ydt9h367iBtR2Kb0XTIZqIVC4kS6MLj/1p8Y8E9obxovb+E7UYhMo1i6RMnGbwwawmJALImJ3qICxVPvnaYt8wx7WHqoMocQUOvV+/6JGs7t7+vleYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4WnsDj2TPgzfbdL;
	Tue, 20 Aug 2024 09:23:49 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 4160A1402E0;
	Tue, 20 Aug 2024 09:25:49 +0800 (CST)
Received: from [10.67.120.126] (10.67.120.126) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 20 Aug 2024 09:25:48 +0800
Subject: Re: [PATCH v5] scsi: sd: Ignore command SYNC CACHE error if format in
 progress
To: Bart Van Assche <bvanassche@acm.org>, Damien Le Moal <dlemoal@kernel.org>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
References: <20240819090934.2130592-1-liyihang9@huawei.com>
 <c1552d1f-e147-44d9-8cc6-5ab2110b4703@kernel.org>
 <099752c2-9cc2-43ef-8b97-56d26c148c88@acm.org>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <prime.zeng@huawei.com>, <stable@vger.kernel.org>,
	<liyihang9@huawei.com>
From: Yihang Li <liyihang9@huawei.com>
Message-ID: <e11b6850-e793-7f73-25e5-c474ef758211@huawei.com>
Date: Tue, 20 Aug 2024 09:25:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <099752c2-9cc2-43ef-8b97-56d26c148c88@acm.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemf100013.china.huawei.com (7.185.36.179)



On 2024/8/20 0:54, Bart Van Assche wrote:
> On 8/19/24 3:57 AM, Damien Le Moal wrote:
>> The patch changed significantly, so I do not think you can retain Bart's review
>> tag...
> 
> Agreed, my Reviewed-by definitely should have been removed.
> 

Sorry about that forgot remove your Reviewed-by tag.
