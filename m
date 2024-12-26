Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0021614D6E1
	for <linux-scsi@vger.kernel.org>; Thu, 26 Dec 2024 12:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735215062; cv=none; b=bVVZM50I/hsldXyie5UWTJBFB6vaNrbLmly4qBZ0czkX/23hGKBlrJ4EsjqfiCIq+PCPgHKQDQS8B4xp6cL0cB3z+KpsF5/eD2W4WxQqehi6bkUEjKxE975K9vSoVz+YFGCyrvtZuslw6vG9ryH40A8ukUUBRGXQzzB6KOQIbcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735215062; c=relaxed/simple;
	bh=2N9UeHKHDzRwrpKHnsiJQHNTkgG5HSilvcdDGfspsa0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KBRymdMpvejNc/Qnj57JBphy+M7BwOh3NppakxpCvoye219V8ZWleafPBGeIvZQ+3TBlfykhor+YZDrCfnCeWgKWh8c+JN29RGoG5lc6QO8RJ0G/Xve+NB8tX2ARHAJWV5iejmYuCAzNOZg+W2Ttm4Mfc9YmQcfQH4Ok2ccOz68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=yfrp0id0; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="yfrp0id0"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1735215051; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=2N9UeHKHDzRwrpKHnsiJQHNTkgG5HSilvcdDGfspsa0=;
	b=yfrp0id0zkJ87qeCABE5g2hwpKRLEVPrQFmdsrS37SImd7lyxvXEGERAYFaqVtRK6VJJejAdhvhOw1QPR6AalSS72fJ9nB4EyFziH7droImS7MvPoE0QNPaPAkme+FWYuycNzqtA0QP5mWsI+PfkeEuYrKNs09zhSS9DhaDWVeQ=
Received: from 30.221.144.142(mailfrom:kanie@linux.alibaba.com fp:SMTPD_---0WMIBpfl_1735215049 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 26 Dec 2024 20:10:50 +0800
Message-ID: <e46c9836-86f6-4eb7-8edf-522ade067b49@linux.alibaba.com>
Date: Thu, 26 Dec 2024 20:10:49 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: =?UTF-8?B?TW96aWxsYSBUaHVuZGVyYmlyZCDmtYvor5XniYg=?=
Subject: Re: [PATCH v2] scsi: mpi3mr: fix possible crash when setup bsg fail
To: Bart Van Assche <bvanassche@acm.org>,
 Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org
References: <20241217110408.126413-1-kanie@linux.alibaba.com>
 <8e783802-a74f-42f9-b0cd-9b831179c472@linux.alibaba.com>
 <dc5c5de8-4bd9-4e57-a989-06d9e9213f68@acm.org>
From: Guixin Liu <kanie@linux.alibaba.com>
In-Reply-To: <dc5c5de8-4bd9-4e57-a989-06d9e9213f68@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2024/12/21 01:19, Bart Van Assche 写道:
> On 12/19/24 5:37 PM, Guixin Liu wrote:
>> Gentle ping...
>
> Has this patch been tested?
>
> Bart.

Yes, I will send a v3 patch with the crash stack,

Best Regards,

Guixin Liu

