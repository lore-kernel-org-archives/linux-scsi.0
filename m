Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793030152;
	b=ZkUnFui3Kn8bwtVPPARJNH4j2OzYV7oHM7t+KMYKQnUtea2olFNV4xyMTfR8os2958W5
	 4Rkuu2/AJZ7wUCasBRw3tSE6QAPPFaGDHy0nwr208hhueDaW8zkXAXAH+Ekn6ySN9Dz2u
	 mmJTXvpix2AHXu0fmsb4uRSDRwsnabIvl51vWfOzbwVTDrrMUBDbRzmd3A8Y/JlQ82fSm
	 WHtGwEX/7MdPbpuYaby63yNSHitNv5l+Ws9qpy7migMCVkcUF+/0dzBBBjs7EhpfhkWAt
	 1aXcH1zqCWsswpYY/DTTgp6Go/AhNz19USWx0m8RgCTjB328fRfsrD2MMz6q8PLMUMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793030152;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=xNAxryTOyQCvrRQFKqSTs1l85XtBO0K4mQDy2zGtBog=;
	b=kYvVeYt05JOPrxpaHgVx7d9qo6BZqtoTwfEDRDQ4YlZCsmZWmFe00NKiwh0H2PvnF2Ws
	 KgrY8BE5n7q4UyVhhavOcIZJVTJFhQcNMGnCbuY2TXoqgnLZrsEK+UH9QbicPK69Y66Nu
	 A5eYYuHg2xKg7kwnjH2S9mP4wFGwEa6K8jvmoSaCRjJgHrP7NZ0m8RdpN/FAB0+0QSXfl
	 SblaoWXXbkSkIok36AvMcC+kGipZrjm/lBOtvv6XEytJEBA6WO28d+cRNh3jeEG6bhxIA
	 iHULkXVnwBQMZHc7X4FFCpmue0QOD4VO3UJKpCaLNz7sHRR13vktqYyDEkupaoHE0KA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=ghhwYbIa;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81412606A31B;
	Mon, 26 Oct 2026 15:55:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 81412606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=ghhwYbIa
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jCys264tSzlfvpW;
	Mon, 26 Oct 2026 15:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1793030138; x=1795622139; bh=xNAxryTOyQCvrRQFKqSTs1l8
	5XtBO0K4mQDy2zGtBog=; b=ghhwYbIaPhgR5T/zPfNMxPUSR3yHwwHSc3fr6YvG
	wIbTCKsOoWzzXDujDnOiX3ZVcKEVPFHE0Q7nIXngEtclJGt/pxyn+hPsMKq7qq9U
	3WTpi8RoiW9886d1kuToIaT48WUlsE8uY3GkKGWYUGnWZqF4MFPKgnZLR/Kw9jx4
	1rifM6/DbUj9r0vqaATa6VgkG3kw+8n2yw4Az3FM+ZNtFRFu5Dw2gjGQTHmIragK
	DDTKkTyclZEWkJAD+LB2lE3SNMAo5jHu/ech7edXZehqh3LQt3plMc+NtXaBHJfV
	9Xvf4NPcT7oo0+sa1GcZajJ3hiSAZBxWLeBT+zgFUDAFLA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id XcgT5SWHerWb; Mon, 26 Oct 2026 15:55:38 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:829f:7082:d079:ed8b] (unknown [104.135.182.43])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jCyrn2yPdzlfvpT;
	Mon, 26 Oct 2026 15:55:37 +0000 (UTC)
Message-ID: <a7f072a8-01be-42e3-b17d-4bcda4c7cb55@acm.org>
Date: Mon, 26 Oct 2026 08:55:36 -0700
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
Subject: Re: [PATCH] scsi: ufs: mcq: Reap aborted CQEs before returning from
 abort
To: Jeuk Kim <jeuk20.kim@gmail.com>, linux-scsi@vger.kernel.org
Cc: alim.akhtar@samsung.com, James.Bottomley@HansenPartnership.com,
 mkp@kernel.org, peter.wang@mediatek.com, vamshigajjela@google.com,
 cw9316.lee@samsung.com, hyenc.jeong@samsung.com, stanleyjhu@google.com,
 beanhuo@micron.com, can.guo@oss.qualcomm.com, rafael.j.wysocki@intel.com,
 avri.altman@sandisk.com, john.garry@linux.dev, ping.gao@samsung.com,
 linux-kernel@vger.kernel.org, j-young.choi@samsung.com,
 jeuk20.kim@samsung.com
References: <20261026091745.1490707-1-jeuk20.kim@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261026091745.1490707-1-jeuk20.kim@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/26/26 2:17 AM, Jeuk Kim wrote:
 > ufshcd_mcq_abort() can return before the OCS_ABORTED CQE is reaped.
 > If the command is retried or reused, the late CQE can unmap its new
 > DMA buffers or access a freed SG table, triggering a KASAN
 > null-ptr-deref in dma_direct_unmap_sg().

This also needs a second sentence. If the late CQE arrives after the
command has been resubmitted, ufshcd_compl_one_cqe() also overwrites
cmd->result and calls scsi_done() for the new instance of the command,
because SCMD_STATE_COMPLETE was cleared when the command was
resubmitted. Hence, making ufshcd_release_scsi_cmd() idempotent is not
enough on its own. What matters is that the CQE is reaped before the
abort handler returns.

 > +	/* Wait for any CQ handler still releasing the command. */
 > +	scoped_guard(spinlock_irqsave, &hwq->cq_lock)
 > +		ufshcd_release_scsi_cmd(hba, cmd);
 > +
 > +	if (err) {
 > +		dev_err(hba->dev, "%s: no completion for aborted tag %d\n",
 > +			__func__, tag);
 > +		lrbp->req_abort_skip = true;
 > +		return -ETIMEDOUT;
 > +	}

If the poll times out, this unmaps the data buffer (and with swiotlb, 
frees the bounce buffer) while the controller may still own the command. 
The host reset only runs later, in ufshcd_abort(). That is the same 
use-after-unmap this patch tries to fix, just moved to a different 
place. Please release the command only after the host reset has 
completed in the timeout case. Note that ufshcd_mcq_force_compl_one() 
skips commands with SCMD_STATE_COMPLETE set, so the abort path does 
still have to release timed-out commands itself.

 > +	err = read_poll_timeout(ufshcd_mcq_cmd_reaped, reaped, reaped, 20,
 > +				MCQ_POLL_US, false, hba, hwq, cmd);

UFSHCD_LRB_RELEASED is used for two things here: "resources released" 
and "CQE reaped". That is why reserved commands need a special case. 
Have you considered setting a separate "completed" bit in 
ufshcd_compl_one_cqe() for every command type? Then the reserved-command 
special case goes away, and ufshcd_release_scsi_cmd() keeps its current 
semantics, so double releases elsewhere would no longer be silently hidden.

Also, ufshcd_clear_lu_cmds() polls the CQ only once after 
ufshcd_clear_cmd(). Does UFSHCI guarantee that the OCS_ABORTED CQE has 
been posted by the time SQRTSy.CUS is set? If so, please say so in the 
commit message and explain why polling is needed here. If not, 
ufshcd_clear_lu_cmds() has the same race and should be fixed too.

 > - * Return: SUCCESS or FAILED error codes
 > + * Return: SUCCESS, FAILED, or -ETIMEDOUT if the CQE was not reaped.

Please don't mix SCSI EH return codes with negative errno values in one 
return value. It would be cleaner to do the host reset (followed by the 
release) inside ufshcd_mcq_abort(), or to report the timeout some other way.

 > +		/* A LU reset cannot invalidate a late CQE. */
 > +		if (err == -ETIMEDOUT)
 > +			err = ufshcd_eh_host_reset_handler(cmd);

Calling ufshcd_eh_host_reset_handler() from ufshcd_abort() is completely
unacceptable. Only the SCSI core is allowed to call
ufshcd_eh_host_reset_handler(). Additionally, calls of
ufshcd_eh_host_reset_handler() must only happen after all commands
either have timed out or have been aborted.

 > +	lrbp->flags = 0;

The kernel-doc for @flags should say which bits it holds (UFSHCD_LRB_*).
I'd also define the bit next to struct ufshcd_lrb rather than in
ufshcd-priv.h.

The email was sent From: jeuk20.kim@gmail.com, but the Signed-off-by is 
@samsung.com, and the body has no `From:` line. `git am` will record the 
gmail address as the author, so checkpatch will complain about the 
mismatch. Please add an in-body `From: Jeuk Kim 
<jeuk20.kim@samsung.com>` line.

Please add `Cc: stable@vger.kernel.org`.

Thanks,

Bart.

