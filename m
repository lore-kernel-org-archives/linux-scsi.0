Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EEA9271454;
	Wed, 23 Jul 2025 09:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753262781; cv=none; b=sA+IJ7mIwyq0XgN14dzSLsyO9NyJqOs7S/eaP9Xfhs3hv24M4Jpg52x3Mpi0Khto06Ddf8kDdf6BbUX0rU5On1YDSRRYMMSKJjgfrsHMTGwcwwdc0Y2kjBOr+G+kCcT8pHzWc/0VUGcjJDpe5ihi2AMsoDsZfonnyOOtIO5Tq+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753262781; c=relaxed/simple;
	bh=7xNXxrvUumKxQi8n26P3wHBPJX8mTzGQeQysCUFywaI=;
	h=Message-ID:Date:From:MIME-Version:To:CC:Subject:References:
	 In-Reply-To:Content-Type; b=Q9vJC364ZaLZC3oimM/iAsiBq0OXNA997N+H7eoeXpmoixJzah51WAcUKk9kSx2vzjSC00DLJd8kQEUfef+Kcuy2Rqppdlz8zSjtsByTASPyVujqDMywWVZTfT2oJNQt4r0/sLnN6cllP5barVUYKRCxMKBYabYIJzUqVz9BF6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4bn7wN4zqJz13Mfx;
	Wed, 23 Jul 2025 17:23:16 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id A92C2140258;
	Wed, 23 Jul 2025 17:26:13 +0800 (CST)
Received: from kwepemq100003.china.huawei.com (7.202.195.72) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 23 Jul 2025 17:26:13 +0800
Received: from [10.67.113.98] (10.67.113.98) by kwepemq100003.china.huawei.com
 (7.202.195.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 23 Jul
 2025 17:26:12 +0800
Message-ID: <6880AAB4.4080103@hisilicon.com>
Date: Wed, 23 Jul 2025 17:26:12 +0800
From: Wei Xu <xuwei5@hisilicon.com>
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
To: Yihang Li <liyihang9@huawei.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Yihang Li <liyihang9@h-partners.com>
CC: <James.Bottomley@HansenPartnership.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
	<liuyonglong@huawei.com>, xuwei 00615891 <xuwei5@huawei.com>,
	<xuwei5@hisilicon.com>
Subject: Re: [PATCH] scsi: MAINTAINERS: Update hisi_sas entry
References: <20250702012423.1947238-1-liyihang9@h-partners.com> <yq1ms967jj5.fsf@ca-mkp.ca.oracle.com> <09fe7faa-cae5-6dff-4f35-2c2744c73cc0@huawei.com>
In-Reply-To: <09fe7faa-cae5-6dff-4f35-2c2744c73cc0@huawei.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq100003.china.huawei.com (7.202.195.72)

Hi Martin,

On 2025/7/23 17:14, Yihang Li wrote:
> CC hisilicon SOC maintainer: xuwei5@huawei.com
> 
> On 2025/7/15 1:52, Martin K. Petersen wrote:
>>
>> Hi Yihang!
>>
>>> liyihang9@huawei.com no longer works. So update information for hisi_sas.
>>
>> In situations where affiliation changes it is customary to receive an
>> acknowledgement from the institution which previously held the
>> maintainership.
>>
> .
> 

Yihang's mail has been changed to: liyihang9@h-partners.com. So

Acked-by: Wei Xu <xuwei5@hisilicon.com>

Thanks!

Best Regards,
Wei
