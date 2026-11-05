Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793842224;
	b=Chrq1rdadsnaEZwMOhKgE1uzVvJRkF1U5HEwpsDTlwlG7UeQ/gKKVypttkRUQ9444bFL
	 QalG47F0vCY4gOJl5hhU53L7ZEksp+Ly57GsBtBe9cBfe0nTVEwdSSZUGaFy4HtgHt9yW
	 JEwUKsZyahy3rE7xSbiRB/dB9hjtZqGFwax80/fKAgqhQ0jrd2YoZSvvn0sn85s6upSl/
	 1GKIwEux4NFEP9tMnR8/lC1YzzINke8DjkC4W1vefPa/lg/DUmEpJnglhQ8jhzpTXE6Q5
	 9SMnEqMDvcxowhWHbBRKNhLpA6D95vcKc4bB4+9JOHI1xlHKMqBFcLytYf1l6w7u1gQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793842224;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=c9FyyRrDIJiM+pdGziNyvrHRdlHPw/S0AzKsVTLflEI=;
	b=TuzcjoZcPAjd5UtoEW5qW8NTbM+xMB+SG2Sapu2Yx3tIwPDGPTxJe0hYn2W0SUXp9ByM
	 9OQY+uJ8qWJ/QtDDY1gWqvDIGtKs9BIOvmPA2zUsQJYKo6IjEqDXMtqoHqXBwMB/Da0JY
	 di1C1qMYqFJDiWwyF63U/gWMuHZIoK0wHzqbakEYu5LH9u2LuFlDgNbBgTjl8zZd+AuYl
	 yEhEOcW5JWL7dsARHPLVwU3GCTKHMGk/YckPaDhBZR6SpFOv/LRrNJCvKWtC8DUGgB8Jp
	 RrtCHABwK+pebOqwxZQ/wGHnf4flMQU2X7gaoMh1XE6JUtEfOIliJRRTKO78/DT0eMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=379Ifg0I;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8822A606A31B;
	Thu,  5 Nov 2026 01:30:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8822A606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=379Ifg0I
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4jKl9q0BDkz1XM6J5;
	Thu,  5 Nov 2026 01:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1793842219; x=1796434220; bh=c9FyyRrDIJiM+pdGziNyvrHR
	dlHPw/S0AzKsVTLflEI=; b=379Ifg0Ib0caxg0l9GbqU9TMQhYkAGveaJG+hZ3H
	fuPeFG4/ZhcbGW4stmdFYjb3oebrIJMu/xsf01+nldFVTMMG+ff5Rb/gGcK73x/T
	0EW2vrx3RpYmkjNl9jIpPUD1ZNzhrZKZLW0R+N3C7t3aOdc7MzUDgcjcXPmOQ6pj
	X4XHmDSdW9rKA6D/1njpzP+cf8sjWXzuyTAiSbuYqghR1jCwHeS8rVwqBDZ2FiUA
	1jqIIVWeroXw3AQNZMA6y4McvroqTpAhijspIAxY6ds5VWzGPNLN0hN9Z5oorbpC
	uIPhqCF3PLRh62dTim9O+fl3jPigB6sHr/guh/bUS/+rtA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id D5KUB14VwKHN; Thu,  5 Nov 2026 01:30:19 +0000 (UTC)
Received: from [192.168.51.14] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4jKl9l0s7wz1XM311;
	Thu,  5 Nov 2026 01:30:19 +0000 (UTC)
Message-ID: <8939a53e-1b21-4dd9-b65c-cbe03b8b72ce@acm.org>
Date: Wed, 4 Nov 2026 17:30:18 -0800
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
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261105004333.1097899-3-kwmad.kim@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/26 4:43 PM, Kiwoong Kim wrote:
 > Here is the timeline of an actual case for this that happened with 
kernel 6.18.
 > [ ... ]
 > 2. So after the query was timed out, the driver did SQ cleanup.
 > Then the host updated CQ update and raised IS.CQES,
 > Unfortunately, complete() was called the driver's ISR afterward.

This timeline describes code that no longer exists upstream. Since
commit 08b12cda6c44 ("scsi: ufs: core: Switch to
scsi_get_internal_cmd()"), the device management path no longer calls
complete(). Please describe the race in terms of the current code:
the query times out, the SCSI error handler calls ufshcd_abort() ->
ufshcd_mcq_abort() -> ufshcd_mcq_sq_cleanup(), the request is finished,
and the retry reuses the same reserved tag, struct scsi_cmnd and devman
UCD. A late CQE for the first query then maps to hba->dev_cmd.tag via
devman_ucd_dma_addr and completes the retry too early. That is why
cq_lock matters here. Please also keep lines in the patch description
at 75 columns or less.

 > +static enum utp_ocs ufshcd_mcq_read_ocs(struct ufs_hw_queue *hwq,
 > +					struct ufshcd_lrb *lrbp)
 > +{
 > +	guard(spinlock_irqsave)(&hwq->cq_lock);
 > +	return READ_ONCE(lrbp->utr_descriptor_ptr->header.ocs);
 > +}

READ_ONCE() is not necessary since the OCS is read with cq_lock held.

 > +	if (!err && blk_mq_is_reserved_rq(rq)) {
 > +		enum utp_ocs ocs;
 > +
 > +		err = read_poll_timeout(ufshcd_mcq_read_ocs, ocs,
 > +					ocs != OCS_INVALID_COMMAND_STATUS, 20,
 > +					MCQ_POLL_US, false, hwq, lrbp);
 > +		if (err)
 > +			dev_err(hba->dev, "%s: OCS not updated. hwq=%d, tag=%d err=%d\n",
 > +				__func__, id, task_tag, err);
 > +	}
 > +
 >  	if (ufshcd_mcq_sq_start(hba, hwq))
 >  		err = -ETIMEDOUT;

The SQ is still stopped at this point, so this loop can stop fetching
from the hardware queue for up to MCQ_POLL_US (500 ms). Please move the
OCS poll after the ufshcd_mcq_sq_start() call.

This code also waits for the interrupt handler to process the CQE. Why
not reap the CQE from this function? ufshcd_clear_lu_cmds() already
does that by calling ufshcd_mcq_poll_cqe_lock(hba, hwq) after
ufshcd_clear_cmd(). Calling ufshcd_mcq_poll_cqe_lock() before reading
the OCS would remove the dependency on interrupt delivery and match
the existing code.

Additionally, does the UFSHCI specification guarantee that the host
controller posts a CQE (e.g. with OCS = ABORTED) for every command
that has been cleaned up? If not, this patch turns cases that are
harmless today into a host reset. Please cite the relevant section of
the UFSHCI specification in the patch description or in a source code
comment.

Thanks,

Bart.
