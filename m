Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1470148DB52
	for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 18:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792174722; cv=none; b=GJtD6caEov924Rx1u2EfecjInIe1canwteDk9kwCRDyDod6jmmL1iXpybQhObq9z+5khAKbSJJI0hmRdBVqlSWidX0/DGHP/Va92kJz0Q9/BRnMgnopR30FwnCwCQXh3eVUOc+4BhqGdo/rVBkL9B8HVHUlBNSYbMr5rP4L26pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792174722; c=relaxed/simple;
	bh=7gJh36C82uWbS/T4P6kI6wFl4iMe7Ec0ytSCZzIOrvQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NwtEQlHUGcxdDSrYRUR2iPws7WLEYj0cyebvzP7yW0kkfRgGpNqoPPOSPcfF1R0UZ4YJ3pUQvkSmQ5RYftnMTMhctysNPHLbcA9py7n9d3RrepcrW5EnjYqp0LTPggubZL2cfoKZEz0HpOf3cTLYv9KvjhpuvOPuSAOdXkjZmbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=NiOded6F; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="NiOded6F"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4j5tVS3KkSz1XM5kD;
	Fri, 16 Oct 2026 18:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1792174717; x=1794766718; bh=isCQ390Ncwnb6nDLI/mH04FR
	JujGMwevpQjj4Iwvmo4=; b=NiOded6FVR/oGMXX3mulSrLF59c/qIQ1XuwoUHaM
	k2PgzKzL9U6pC09ukDfTzM1FwCrrqZx8Tv9Zgw8O8UtOYEaqU/KS+bYlTcco2F0m
	0K0ppehYi4ZNiXcbqOzFlaitFxJUV7oajrfYrYLEXC6ivf3SaDRr8VXPfN1V/jRM
	06gLuiNhq5TJmDWg3SUsGSTEIqvEIpKvnlxI564F9KCaRw08Y2IaPoddUGjy5s52
	aMbr4bQUqkEhr44ZUiEzXuHygq0/NwqHxpj9dF+VC97kNpysBNhlcdCFc56Ruspy
	oZ+xz2ph1DfO0BRE5B8EWzVxltCxVNJe7w859as750wUVA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id kGGtojFv4IpK; Fri, 16 Oct 2026 18:18:37 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4j5tVP4s6zz1XM4Tl;
	Fri, 16 Oct 2026 18:18:37 +0000 (UTC)
Message-ID: <9727e883-c2fa-462a-ab30-481a0e4f77c4@acm.org>
Date: Fri, 16 Oct 2026 11:18:37 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: Fix stale comment in
 ufshcd_mcq_config_nr_queues()
To: Shawn Lin <shawn.lin@rock-chips.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <1792133053-143069-1-git-send-email-shawn.lin@rock-chips.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1792133053-143069-1-git-send-email-shawn.lin@rock-chips.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/15/26 11:44 PM, Shawn Lin wrote:
> diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
> index df293b6..15401e1 100644
> --- a/drivers/ufs/core/ufs-mcq.c
> +++ b/drivers/ufs/core/ufs-mcq.c
> @@ -184,7 +184,7 @@ static int ufshcd_mcq_config_nr_queues(struct ufs_hba *hba)
>   
>   	/*
>   	 * Device should support at least one I/O queue to handle device
> -	 * commands via hba->dev_cmd_queue.
> +	 * commands, which cannot be handled by a poll queue.
>   	 */
>   	if (hba_maxq == poll_queues) {
>   		dev_err(hba->dev, "At least one non-poll queue required\n");

A few comments:
- "Device" in the existing comment is inaccurate since hba_maxq is a
   host controller capability rather than a UFS device property.
- At least one non-poll (HCTX_TYPE_DEFAULT) queue is required not only
   for UFS device management commands, but also for all non-polled SCSI
   commands. How about updating the comment to:
	/*
	 * At least one non-poll (HCTX_TYPE_DEFAULT) queue is required for
	 * non-polled SCSI commands and UFS device management commands.
	 */
- Please drop the Fixes: tag since this patch only updates a comment.

Thanks,

Bart.
