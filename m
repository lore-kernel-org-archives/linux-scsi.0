Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794257386;
	b=cfuxLuXga4uFjr5pU6DSu8WGVGnId7uCKnjaCICVKpmxLFf/CSVmcwj5CQq+ZrleE4zq
	 xqeWKTEFZPF1/23ARIExR+XolJftsb4k8vSLYNFI03cfKIUZfk7ep9PfhC/zRiboKdfKy
	 K5/kTsNvbvPpJoQ3/jWlZPsFbfCamRxku6kX/qMZrWEJgWFFgfP/a/zvgehJbtJyFzXfq
	 jnwKdJeDF7TlfjNvDJTmJBdZ/ijtPvrzLdBSs1RVVBsIv5D6xw+0nxaR4BxYGFMx1Cw4s
	 2r+U+uQzAiF0QgcZZ18EpO34covHXAeYEIfOF8qYdC+SHeJ+SA1dx/tXtMgkRLnhJKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794257386;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=+XBSa+YGEqD13zOBtk291Un527MF5DVJf78DjKI+IVc=;
	b=B4iv5bAk5MsL8cFw5fF6f8bCwAJfHcE5+70DzD999N6buYJRUUVSTw2kmyCTV8k3AkeL
	 MKdUbxn14bKTNPY0pVzQMQVMPKKG0EjXO9ujZviz2TBFBPRQo5QgZ8iCAjwt1MAXVU1V0
	 5B0FhPdmZiNCNrDNTWk4iTzlQQa7AX5ZKBBnLQy5jA1dNo5M+c1B4XVBpqEe6Q0upxfnq
	 7T2Q23vmX1RjcwaNhCCnMqWXq3JwOx1IzA9vg4IIidXofnXG3u0iH1Y8LI4F0Pe3DoEjj
	 HZ3Gv4/4hjUEFcc323IXNh9jrlm22h5AkYmvxtT47Xo8984ErR51ptRbz0FS38d4Vaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=WLENZ+09;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63AA6606A321
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 20:49:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 63AA6606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=WLENZ+09
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4jNhjh5FQlz1XM5kD;
	Mon,  9 Nov 2026 20:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1794257379; x=1796849380; bh=+XBSa+YGEqD13zOBtk291Un5
	27MF5DVJf78DjKI+IVc=; b=WLENZ+09mXAG6136e0lXt2JwmfE2aliftklXzG1K
	KhGskVuxetgZ4yjJz1/04VKiopEc3XmEbzDKEbNicw3FhPka/jWz+YbBy6axxmkm
	l+0PmN145aE5xuk/Gc/tb6ZdGij2TuOQCCynOVZM/4EMM0ExJCXyPYiBAEFqubUZ
	vfszHdDE3EbduZxMfptfJwJ9e/KU8z800E2VygAZbHXBAxFw67Iw2fXwtrwNWZti
	T7aKmhqouK5BUuRTji1hiSZUR5hGMtZq/ivEJl5BwKU5w4OJiZdXnySBi0hpxi2z
	eNJjDJIAuASUz/pbZZhvGgPex8JvxFPX4NkqSz/Xx8GEBA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 22iWdORwNULS; Mon,  9 Nov 2026 20:49:39 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4jNhjZ6pjRz1XM4Tn;
	Mon,  9 Nov 2026 20:49:38 +0000 (UTC)
Message-ID: <060d5e0d-764e-40bd-8bb7-ead8d4ada5b0@acm.org>
Date: Mon, 9 Nov 2026 12:49:38 -0800
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
Subject: Re: [PATCH v9 01/29] scsi: core: Clear cmd->flags for terminal
 queuing error
To: John Garry <john.garry@linux.dev>, james.bottomley@hansenpartnership.com,
 mkp@kernel.org
Cc: hare@suse.com, linux-nvme@lists.infradead.org,
 linux-scsi@vger.kernel.org, snitzer@kernel.org, jmeneghi@redhat.com,
 bmarzins@redhat.com, dm-devel@lists.linux.dev, hch@lst.de,
 michael.christie@oracle.com
References: <20261108204733.557995-1-john.garry@linux.dev>
 <20261108204733.557995-2-john.garry@linux.dev>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261108204733.557995-2-john.garry@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/8/26 12:47 PM, John Garry wrote:
 > If a request can't be queued in scsi_queue_rq(), then we error out
 > with a blk_status_t code. Such a scenario may be the scsi_device has
 > its transport offline. For BLK_STS_RESOURCE or BLK_STS_AGAIN, the
 > request will be requeued in the block layer.

This is not correct for BLK_STS_AGAIN. Only BLK_STS_RESOURCE and
BLK_STS_DEV_RESOURCE cause the block layer to requeue a request. For
all other status codes, including BLK_STS_AGAIN,
blk_mq_dispatch_rq_list() and blk_mq_try_issue_directly() call
blk_mq_end_request().

 > For other errors, the block layer ends the request and so we won't
 > see it again (until recycled). Normally when a request completes
 > scmd->flags is cleared in scsi_end_request(). However for the error
 > scenario mentioned above, scsi_end_request() is not called and so
 > scmd->flags is not cleared. As such, when the request is recycled we
 > see the old value in scmd->flags.

Please describe the consequences of this bug in the patch description.
As far as I can tell there are at least two:
- SCMD_FAIL_IF_RECOVERING is part of SCMD_PRESERVED_FLAGS and
   scsi_execute_cmd() ORs new flags into scmd->flags. If a command
   submitted with SCMD_FAIL_IF_RECOVERING is failed with BLK_STS_OFFLINE
   because the host is in recovery, the flag leaks into the next request
   that is allocated with the same tag. That request will then be failed
   instead of requeued if it is submitted while the SCSI error handler
   is active.
- If SCMD_INITIALIZED leaks, scsi_init_command() skips
   scsi_initialize_rq() for the next filesystem request. Hence,
   jiffies_at_alloc and retries are not reinitialized and that request
   may be failed prematurely by scsi_cmd_runtime_exceeded().

 > Fix this issue by clearing scmd->flags in the error scenario mentioned
 > by calling scsi_cleanup_rq().

Please add Fixes: and Cc: stable tags. For the SCMD_FAIL_IF_RECOVERING
leak, I think this should be:

Fixes: 310bcaef6d7e ("scsi: core: Support failing requests while 
recovering")

 > @@ -1994,8 +1994,8 @@ static blk_status_t scsi_queue_rq(struct 
blk_mq_hw_ctx *hctx,
 >  		 * we hit an error, as we will never see this command
 >  		 * again.
 >  		 */
 > -		if (req->rq_flags & RQF_DONTPREP)
 > -			scsi_mq_uninit_cmd(cmd);
 > +		scsi_cleanup_rq(req);
 > +		scsi_run_queue_async(sdev);

Since the block layer also ends requests for which scsi_queue_rq()
returns BLK_STS_AGAIN, the BLK_STS_AGAIN case has the same issue.
Please convert that case too:

	case BLK_STS_AGAIN:
		cmd->result = DID_BUS_BUSY << 16;
		scsi_cleanup_rq(req);
		break;

Although no SCSI driver returns BLK_STS_AGAIN today, I think both
error paths should handle this in the same way.

Thanks,

Bart.
