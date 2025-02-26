Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857C7254857;
	Wed, 26 Feb 2025 03:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740540204; cv=none; b=ZKAHuyJp3xcoGL1u0l07XUGKgUML/I5Kf2/B8utvqEDlBQsT+6r+qLap2w0BohdrgK4PpOE0gOq0+0+75PqbXTrRlQ6gC5XWGH1TpE8Lfl6QBsLKP2JA2sJbTNxaLwWH+KxTFiUm4Iguqr0chjNFAAIAhkzQyad4ZcOcZMp7XSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740540204; c=relaxed/simple;
	bh=E6VSR6K728OMUlzwLKUHKnCA1Yaf4YvBW3bW1m6CoXk=;
	h=Subject:To:References:CC:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Q9qPpUEE7WUgqEg4ziGl/Uwaupg0W45dlWTtSGRWalvcajtzjK1g3v4YLIYU7fgOdfld/JEI3PWUCUCs0ayOav8rJh7t7SsPSl2o1MSCwGCWqRQ0iT6eQoc9Nc80Z1ZIaLiEOv31ixGgnrcs+9G9lpa7h9xOwh6k+jSkduTXXIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Z2fs73mdRzTmys;
	Wed, 26 Feb 2025 11:21:47 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 98C0A14034E;
	Wed, 26 Feb 2025 11:23:19 +0800 (CST)
Received: from [10.67.120.126] (10.67.120.126) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 26 Feb 2025 11:23:19 +0800
Subject: Re: [PATCH] scsi: hisi: remove incorrect ACPI_PTR annotations
To: Arnd Bergmann <arnd@kernel.org>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>
References: <20250225163637.4169300-1-arnd@kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, Damien Le Moal <dlemoal@kernel.org>, John
 Garry <john.g.garry@oracle.com>, Bart Van Assche <bvanassche@acm.org>,
	=?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@baylibre.com>, Jason Yan
	<yanaijie@huawei.com>, Igor Pylypiv <ipylypiv@google.com>,
	<linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<liyihang9@huawei.com>
From: Yihang Li <liyihang9@huawei.com>
Message-ID: <49419ea6-5535-3612-c1c4-5ac58f2bc012@huawei.com>
Date: Wed, 26 Feb 2025 11:23:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250225163637.4169300-1-arnd@kernel.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemf100013.china.huawei.com (7.185.36.179)

On 2025/2/26 0:36, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Building with W=1 shows a warning about sas_v2_acpi_match being unused when
> CONFIG_OF is disabled:
> 
>     drivers/scsi/hisi_sas/hisi_sas_v2_hw.c:3635:36: error: unused variable 'sas_v2_acpi_match' [-Werror,-Wunused-const-variable]
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Looks good. So Reviewed-by: Yihang Li <liyihang9@huawei.com>
