Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795124175;
	b=hKXAUuLQhhWBnVGSe6JpbmjCjzEVeq7A8OM07UvdaSyzus3fYAAiVp5HrR5rJ3TFHk1C
	 6oGduYSix+I6zD+qophuJOpz614VhU0d3WWbo4lSRU2f/7TXIbXbRklmodQYGEStW4VPo
	 aKt40dsRDZauaxtmjrfhzwS0J4jOCnsk3XKqHBIe12N7nPRViNnxQCHHvpY2+mV78e4ag
	 eVZHahrjgI+gF/4J6NiNzK1hOkdzn05teBI91sqbpMhLlHXDJ0TwKLrQwzS6zxcDI8Swe
	 b2wYbT9pnrPCI0okIxMmmX6XN3oth0EhponaYaIalVHxjhyif0fub7d+65SEDPUZ/Xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795124175;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=WJ7pS3srS2heUtQdMTY4y8k5McrUc7LGudTqAoRvr8g=;
	b=pAceMLGVvsQLh08cn79zbWtwA1rIBAbubWWYZGDVfiAvHE1XywlsVZgdqB42zCJ9OHTE
	 UiIDsrVmZDJiIsDEKJ66+xIsNiDNNFqiNGV98Z37YoznYQ8RUUi2hoqzk/PNc7YNVaJL6
	 s9TBnECNt235Ly5bDCipZ7gx1d12IqgQRpyBHsUpdkLLybA5eOsHoz/toFqw//39EvDic
	 Si3vIBNXCon07hHoyBfq4aVt3rG5y3LwGneTFnWCK3obaRMiBG5JSy5LiR8yKQc/fB5a7
	 zSgOStl/+5PihXBF/eDm4rcthusDnUQUSwTN4v9trxEkMSbeVN7wlvfpAdkn2feBmGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=ZzHzJM1g;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8EE606A324;
	Thu, 19 Nov 2026 21:36:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DC8EE606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=ZzHzJM1g
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4jVsGk2Zqsz1XLwXN;
	Thu, 19 Nov 2026 21:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1795124171; x=1797716172; bh=WJ7pS3srS2heUtQdMTY4y8k5
	McrUc7LGudTqAoRvr8g=; b=ZzHzJM1gHKP58sl5NRyEq0uKkTMWytKEO7OQqiPC
	UVbhSqIjE2hb5LChLHHgNiCUYUGRH1RgfVeKfQsMV1Flsj68dkgjH8ESRshX975X
	ALe5OsCv4DbpPfESwjJuh0/PO1ct/l6o31uhLReIxOmre2tBbIImNOKOor9GYqmO
	tjN3Kb3vGtihFb3X8UlyL2S6nNXYvhklRWbHsXSTLYWGD4c5Z6pexUh6D1qL51DX
	lMpOfNIRqsNNFi5HVnxu4KKRBXFmUlff5NP+fyGOK2qWTGBGGv6HR9Bo0v019Tpl
	x/2SxKhsXPl4ruRLmTM8aEfGkXGEkQUflRD4LL40wh4mAg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id T_sHGstPrQTn; Thu, 19 Nov 2026 21:36:11 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:3bd4:4c06:4b28:5d89] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4jVsGg1ZSlz1XM6J6;
	Thu, 19 Nov 2026 21:36:11 +0000 (UTC)
Message-ID: <3dcb1a44-6e99-4d34-9b49-675d98c90da1@acm.org>
Date: Thu, 19 Nov 2026 13:36:10 -0800
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
Subject: Re: [PATCH v4 1/4] scsi: core: release SG_IO request before user
 copyback
To: Yingjie Wang <x-professor@outlook.com>,
 "Martin K. Petersen" <mkp@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 Yang Xiuwei <yangxiuwei@kylinos.cn>, James Houghton <jthoughton@google.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <cover.1794990780.git.x-professor@outlook.com>
 <1fe63161bcec115131d7004cfd59f465f0de4f69.1794990780.git.x-professor@outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1fe63161bcec115131d7004cfd59f465f0de4f69.1794990780.git.x-professor@outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/18/26 12:33 AM, Yingjie Wang wrote:
 > Four synchronous SCSI passthrough paths copy data to userspace, or unmap
 > a user buffer that needs copyback, while they still hold the completed
 > request.  If that user access faults and the fault needs I/O from the
 > same queue, the task can wait for a tag held by the request it would
 > only release after the fault returns.

Does the same dependency exist on the submission side? All four code
paths access user memory after scsi_alloc_request() has succeeded and
before blk_execute_rq() is called:
- sg_io() calls copy_from_user() from scsi_fill_sghdr_rq() and next
   calls blk_rq_map_user_io().
- sg_scsi_ioctl() calls copy_from_user() twice.
- scsi_bsg_sg_io_fn() calls copy_from_user() and blk_rq_map_user().
- sr_read_cdda_bpc() calls blk_rq_map_user().

If no I/O scheduler has been selected, the request allocated by
scsi_alloc_request() already owns a driver tag. If the host has only
one tag and if any of the above user memory accesses triggers a page
fault that requires I/O on the same queue, isn't that the same deadlock
as the one this series fixes? Pinning a data buffer that is not yet
resident seems at least as likely to me as a fault during copyback.
With mq-deadline there are two scheduler tags for a queue depth of one
so a single nested I/O request can make progress in that case.

I have not tried to trigger this. If my analysis is correct, please
either fix the submission side too or mention in the cover letter that
this series only addresses the completion side.

Thanks,

Bart.
