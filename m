Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793901226;
	b=exeIBwpJWigqnVm6u5JG7v5R1B4taB6CG7RkewU4Pjbzyu5E4dLaohc8e+AYqNPmP1AH
	 K/RSumXL35Fr1sffDQdMWAq3irO0H4uzQnfi5Vx195LJ7JpCvTI1mQ8EmzPRG9axARPsO
	 bTVKTVOMLLCfLkW8TU0VGZhIBtANWmiIc3CU21RBQeytReQM+WDempngKl3sgms8WWj8/
	 06zI52/+DsFQJ2jhl9VkKkSphWYfGdJa8jA8lI2CdUqCIcSlwPK52XV7yLp5b1h39ltdb
	 ZXvgW90oDEBz7T42j/dZZWZOpRxnL5/S9mtZ0wE9XmSkl4Xi2OgH5WCUu3ekakPMtZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793901226;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=24DN6uReOLKC7T3rnRPsFJ0vyMkgerb5nS+GghuFNvU=;
	b=ma3oZXigOYvigKTiSjBg8wuXTdUDHyfCi0RgUKTvMXjBvPpmYXVACVVE0n8rloQm9LZd
	 6YtEyB5IgXaBMtrLzyvCClOINaHwS9UC+QK93llsRygpS7v7sYWUeEoi2M3sdhdAhCfVV
	 6ydGU9o9a7XiDGc5jfI/wg6YH6HxfcGqlB8mcteCKsreRSIoWy4xU7ffPX8L+kitIeEKU
	 Fp6IbCToC5ryKLtBFCPVry0b+xuyTjqxgU9L9GWEjNOUeP1fWSU05gM5tISwRGtphLh8v
	 JTqJOC1hxl4FbsMz2Tm5SUllTC+MCFEXeT1yPVQsBkfP4eIUMVl7849xe+kWL/vEYFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=QiRPOTJs;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA182606A31B;
	Thu,  5 Nov 2026 17:53:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AA182606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=QiRPOTJs
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jL90T1SgHzlgyGZ;
	Thu,  5 Nov 2026 17:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1793901222; x=1796493223; bh=24DN6uReOLKC7T3rnRPsFJ0v
	yMkgerb5nS+GghuFNvU=; b=QiRPOTJsNHIAH4NkS0k/ca9hP0Q42YeS5wUwg5MU
	rAh+DarQds8lONUK/jd6pH4hc/1k2SC84UcK+bPZcf6/5/hlMtl8fuJ3VntrHNb/
	Udso7jdU3w36Fg6rMb++24eX+CR9tal6iHJZ6LRPcoXIa9AbwBLNDofz2NHtdcB5
	Mvfvn2qiNYpqTF4Y0SqQs0P4cTE9TkApuK2AUmkwjtv84MEWVpiN75kO2SVTiI8w
	7pt4FMQLos5hZOmDwMXxMZbv5/xgC4PzOdCUZyNnOTt2nmC+tlHfi6AjuznmZs2n
	CCrDcZCbSlBl8T2rVwklJFE+WgpB+qH4lVIvOcGeoX2xZw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ehe7uoKOOPA2; Thu,  5 Nov 2026 17:53:42 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jL90Q2KzlzlfcTl;
	Thu,  5 Nov 2026 17:53:42 +0000 (UTC)
Message-ID: <ec1d1fd7-b832-4ea8-b3f3-87ff3d361d80@acm.org>
Date: Thu, 5 Nov 2026 09:53:41 -0800
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/2] ufs: mcq: poll OCS after sq cleanup for device
 management commands
To: Kiwoong Kim <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, alim.akhtar@samsung.com, jejb@linux.ibm.com,
 martin.petersen@oracle.com, kwangwon.min@samsung.com, hy50.seo@samsung.com,
 cpgs@samsung.com, h10.kim@samsung.com
Cc: stable@vger.kernel.org, stanleyjhu@google.com
References: <20261105004333.1097899-1-kwmad.kim@samsung.com>
 <CGME20261105004353epcas2p1bd2370dd10156570c69f8f80da3cbcfd@epcas2p1.samsung.com>
 <20261105004333.1097899-3-kwmad.kim@samsung.com>
 <8939a53e-1b21-4dd9-b65c-cbe03b8b72ce@acm.org>
 <003701dd6cea$c396cd10$4ac46730$@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <003701dd6cea$c396cd10$4ac46730$@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/26 9:59 PM, Kiwoong Kim wrote:
>> The SQ is still stopped at this point, so this loop can stop fetching from
>> the hardware queue for up to MCQ_POLL_US (500 ms). Please move the OCS
>> poll after the ufshcd_mcq_sq_start() call.
> 
> I didn't get what you meant. The loop just reads updated OCS periodically
> and from what I know, it's based on the assumption that when a task
> is cleaned up by setting SQRTCy.ICU to one and it's successfully
> done, the host updates OCS, even if SQ is stopped. If you feel I get
> your comment wrong, please let me know.
Let's start with the approach that you proposed. Making the change I
proposed is probably unnecessary.

>> This code also waits for the interrupt handler to process the CQE. Why not
>> reap the CQE from this function? ufshcd_clear_lu_cmds() already does that
>> by calling ufshcd_mcq_poll_cqe_lock(hba, hwq) after ufshcd_clear_cmd().
>> Calling ufshcd_mcq_poll_cqe_lock() before reading the OCS would remove the
>> dependency on interrupt delivery and match the existing code.
> 
> Because a successful SQ cleanup leads to OCS update,
> which subsequently leads to raising IS.CQES when MCQ is enabled. I
> understand your idea with ufshcd_clear_lu_cmds, then do you intend 
> Ignoring IS.CQES event in this case?
That's not what I meant. An interrupt is generated after the status has 
been changed to OCS_ABORTED, isn't it? Has it been considered to wait 
for that interrupt instead of polling the OCS status?

Thanks,

Bart.
