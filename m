Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BE93090C7;
	Wed, 15 Oct 2025 16:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760546030; cv=none; b=IdYiSEQRaGU+LBWex3NKW1G3Y/7QCR2LpgBdw+5Vvbg20ZG4UyPYRm0t9qqun02cac/LqFigaydw9L0hd8T140ACDV5+ACideDAdz458aKVC6OcXRA/iSNZhzyWUCpdBlND7pFpzOTdJiAo7cBuW76ZiTdv4E+HKDrv0DfzkUGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760546030; c=relaxed/simple;
	bh=rRt+5tdHeTr6zj8ytNWoAEJn93yzLX38mTBs4paCDLY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hyyv1q5dDVDsPdGSWB+JGchUdjt/nWNAOzJSwAoIbJv7ziEuAcbZm2uXhbz0Li+SXLm+7p+uw61n70E3ozjO7RISG3RR/u6X+gub9dAb1WjJbusAsCUNjcmVQreZo+GVdRclBsWJINbvslYJ07SJk2Aub0i8VJmJcsoCK41FgNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=oN6XFE56; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="oN6XFE56"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cmxVL1g9Zzm0yQg;
	Wed, 15 Oct 2025 16:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1760546024; x=1763138025; bh=zy06mBsVyx0R0ke/rr91Q7C/
	I5vZd9/4Hl5o2fwmx40=; b=oN6XFE56cK4nf4QhoVCQiWp6JbWN6QCnVEb26DK+
	WSxHlgnYxksgFLWjEpzT0G2Ve2j2K5Fzw2gXvZKtZ7dMCshs/1sWjlj30e6HeibR
	aHEH7wshCnQ5JKmYhARlMX5/bQBJaRttspS0WyS/55zdzS2MHT7m539aHEaU/nE/
	TH9atClzOgbmPliQNDdQfpItTqiY0a/A71PLkRDw7vNVA6mhTOhUKLbbVNY7yizv
	ktTJQosSqPsyQHnblc3Adx4i+hDc1SMviSjT9geb6QfL4OpiuAZyV0ib3qB/iF0u
	y3hrxxi/wDngua1Qs+edFzNPmWW27yUQ5Gtyc0H5UOrC1Q==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 4RYxllBrR-Th; Wed, 15 Oct 2025 16:33:44 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cmxVF6MQ7zm0ytB;
	Wed, 15 Oct 2025 16:33:40 +0000 (UTC)
Message-ID: <d2852a97-5568-41f0-b7eb-a18075d723eb@acm.org>
Date: Wed, 15 Oct 2025 09:33:39 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v25 08/20] blk-zoned: Fix a typo in a source code comment
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20251014215428.3686084-1-bvanassche@acm.org>
 <20251014215428.3686084-9-bvanassche@acm.org>
 <57a601c8-ee0b-45c4-b64f-90858e75c233@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <57a601c8-ee0b-45c4-b64f-90858e75c233@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/15/25 12:32 AM, Damien Le Moal wrote:
> On 2025/10/15 6:54, Bart Van Assche wrote:
>> Remove a superfluous parenthesis that was introduced by commit fa8555630b32
>> ("blk-zoned: Improve the queue reference count strategy documentation").
>>
>> Cc: Damien Le Moal <dlemoal@kernel.org>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> 
> This can be sent independently of this series.

Agreed, but I think that Jens has made it clear more than once that he doesn't
like patches that modify source code comments only except if these are part of
a larger series that also makes functional changes.

Thanks,

Bart.
