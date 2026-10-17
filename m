Received: from mail-m49238.qiye.163.com (mail-m49238.qiye.163.com [45.254.49.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4C619F137
	for <linux-scsi@vger.kernel.org>; Sat, 17 Oct 2026 00:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792198712; cv=none; b=Qy4gVK/+v9tpoaG8w29+IVQVZCjdSFfup8F1w5jD6uhIITJp83mSpNQ+54gBdQSKi0dn5+voxojwruzFYLlMLjzmcLGn2HJCj8JshK1/laP4VqFU2NrebJm0dAJGW4sgeRE32QWYBqhpm8GQ5n1bkE5zbqSR42HjHyDJp4slVRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792198712; c=relaxed/simple;
	bh=2IVtI0ZOyynCR71m1oORQXrIfqNNolm1NHK/SOVfTfU=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=r3vrFoiyuzn9J4ZKLRSZgm/zOWw117JNSXjjPJADe1L5ecm7JSrCS04OSyo6jUO0zcyKtnviEfsgt/fjofYO8AgR9OvsOHdsheF5ezddvCs1GJum2HPkEUm5d4Cq/2qNPE0oaI0jfXLXkVKvXxBENt4RKxadYe+5f4no0EhA0J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com; spf=pass smtp.mailfrom=rock-chips.com; dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b=kin1VVYb; arc=none smtp.client-ip=45.254.49.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b="kin1VVYb"
Received: from [172.16.12.48] (unknown [61.154.14.86])
	by smtp.qiye.163.com (Hmail) with ESMTP id 515d6b213;
	Sat, 17 Oct 2026 08:22:53 +0800 (GMT+08:00)
Message-ID: <30527684-8f5d-4203-b02a-f166bf438515@rock-chips.com>
Date: Sat, 17 Oct 2026 08:22:50 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: shawn.lin@rock-chips.com, linux-scsi@vger.kernel.org,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: core: Fix stale comment in
 ufshcd_mcq_config_nr_queues()
To: Bart Van Assche <bvanassche@acm.org>
References: <1792133053-143069-1-git-send-email-shawn.lin@rock-chips.com>
 <9727e883-c2fa-462a-ab30-481a0e4f77c4@acm.org>
From: Shawn Lin <shawn.lin@rock-chips.com>
In-Reply-To: <9727e883-c2fa-462a-ab30-481a0e4f77c4@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa1473d7a8403a4kunmcc7e30294f32dc
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCGRlCVkxMHk9LHx0ZQ0hJTFYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlNSlVKTk9VSk9VQ01ZV1kWGg8SFR0UWUFZT0tIVUJCSU
	5LVUpLS1VKQktCWQY+
DKIM-Signature: a=rsa-sha256;
	b=kin1VVYb1bJHfPDs2HJ+3fDnIudAulEHNKJB/nHVsGb/QMfzPhZZ1FsGZ1GTZbPdUJpBX95Pt3BtoBET2EifmGhDHWI9LSzfdpYu2aNNMzvJ1WMFSeZ3ClhuFid3qaFFrTruHlVnIJwczTKRjKVjLEQV9bA52RW8w4gJ0XvjRyE=; c=relaxed/relaxed; s=default; d=rock-chips.com; v=1;
	bh=rzH0JHN+JVobCMpjL0/t40jCPT6/giJ+3+MYL89WZl4=;
	h=date:mime-version:subject:message-id:from;

在 2026/10/17 星期六 2:18, Bart Van Assche 写道:
> On 10/15/26 11:44 PM, Shawn Lin wrote:
>> diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
>> index df293b6..15401e1 100644
>> --- a/drivers/ufs/core/ufs-mcq.c
>> +++ b/drivers/ufs/core/ufs-mcq.c
>> @@ -184,7 +184,7 @@ static int ufshcd_mcq_config_nr_queues(struct 
>> ufs_hba *hba)
>>       /*
>>        * Device should support at least one I/O queue to handle device
>> -     * commands via hba->dev_cmd_queue.
>> +     * commands, which cannot be handled by a poll queue.
>>        */
>>       if (hba_maxq == poll_queues) {
>>           dev_err(hba->dev, "At least one non-poll queue required\n");
> 
> A few comments:
> - "Device" in the existing comment is inaccurate since hba_maxq is a
>    host controller capability rather than a UFS device property.
> - At least one non-poll (HCTX_TYPE_DEFAULT) queue is required not only
>    for UFS device management commands, but also for all non-polled SCSI
>    commands. How about updating the comment to:
>      /*
>       * At least one non-poll (HCTX_TYPE_DEFAULT) queue is required for
>       * non-polled SCSI commands and UFS device management commands.
>       */
> - Please drop the Fixes: tag since this patch only updates a comment.
> 

Sure, will do.

> Thanks,
> 
> Bart.
> 

