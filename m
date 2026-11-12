Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794486886;
	b=bKmF8fXzbtfMKvBzeQzz6mlsiYiHSkhQgtppIJNtMTKK5I+JZ6veWtdMELdu7byTkn4C
	 6pG7GQSrb7uiSBGQ2VbtC6QZoklkGeNveQbNq+ofVhPthfrneUwZns1LgpT9hfYl0QtO+
	 Lwf8UIA9PxL9yv0DWnS7Pjd0JOeVWo7Nj/tPIkQcKEgLEjwJGYOC+UJLmkanWhVfLclu6
	 FyyjtABqBCWh9YRZdH4Y3GwkTMwMBdGBDMl1Qf+GTrRDYTZDw3WB5RGz+/DKdaZQAVAL7
	 lAqoQQtI7UT1joVYbxdxG0LsW5ORNylo97zWTjs/A9wMcB6ZIYyBY9wG+oMKy71Cj9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794486886;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spam-Flag:X-Spam-Level:
	 X-Spamd-Result:X-Spam-Score;
	bh=AVpTm882LR63Nx8Y/IB3i5PfkrhJS41OXvMZP0egeqY=;
	b=XDESYSOjqQZMOzgN3R2UeuEIQB5IlfvvCbgdfEcnjYDGWtpi/EPkDofSkOCKyCF/Z/Fq
	 c9aPGYABevSvkmXFikO+NLK6eHmXVFPI8DoezXC56qey//ca/1Z8Dj68/G3u/7KLjMvds
	 xrgS0dGpZI9NThus7bgYOfBIUPuNDfVvGHTkJXq2rHCKiV49iaReuNcUPpPEQBpGpqjTY
	 sZDynpVQxQFWhYOTZ6Lffvp9jR+U079s3ff6Q3nwv5i39cBTrjwrKe63ZMWBY0wFvMGaQ
	 1QbiAkCKibVHM9tvEsMCYCUWxkT5QCdepjzfChc1jeqk8/jyyVPcv8hNyxr8cFDQ/qQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=L62Q1giR;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=1gWYc4Ws;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=Jio2CM6N;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=fSran0kT;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13946606A31C;
	Thu, 12 Nov 2026 12:34:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 13946606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=L62Q1giR;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=1gWYc4Ws;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=Jio2CM6N;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=fSran0kT
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E773F1F792;
	Thu, 12 Nov 2026 12:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794486884; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AVpTm882LR63Nx8Y/IB3i5PfkrhJS41OXvMZP0egeqY=;
	b=L62Q1giRe+H/EBOE4JkcAWNBf0a3UhArANwEaFd+UrPCYxVo6EF7ljn7si4tmndWUx+sQT
	LpMRBudEBPcZ3o7k5xQWkDXbSgEQfDThIZoGZrduOOmWy2LOIxdZL1t0DwcNP6TqgrDqxZ
	uL0bJhGSbUD7EtK7j9M4iG6qi0KIPpI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794486884;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AVpTm882LR63Nx8Y/IB3i5PfkrhJS41OXvMZP0egeqY=;
	b=1gWYc4Ws6/lwWuEIazTSdiECqBXv0mjLcvDQtwksMKlmCsbN9JvwluBRyaK80Vw1ZsgE7J
	bZrfTNK8oap/QeCQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794486883; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AVpTm882LR63Nx8Y/IB3i5PfkrhJS41OXvMZP0egeqY=;
	b=Jio2CM6N4HBiMXCth/l0GaykiEzFmrELqiU4WzBWro7gNGbc7RBxLB7Mxgx7rb7pnkhH1e
	RT9g3Vix0JJbkhSZxQZnJDsogQnpeP9gVGmB5+Omn4SnChtl5JtvoCTIl61+nwov6EYNXt
	V8w5PY+ZFfB8u7x8gUkd2Cx3/AXDD9w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794486883;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AVpTm882LR63Nx8Y/IB3i5PfkrhJS41OXvMZP0egeqY=;
	b=fSran0kT0+RVJaDHSIavj7Dxo0K3cU0Qcl39YFXDcoGT/wewaJ1J5SjuSZQvRG202ll145
	67OMDWnLkEIXw9DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AD3D513432;
	Thu, 12 Nov 2026 12:34:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id b2qbIWOy9Wp7SgAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 12 Nov 2026 12:34:43 +0000
Message-ID: <03c4b56f-efcc-4de2-b49c-2305bb3e3997@suse.de>
Date: Thu, 12 Nov 2026 13:34:43 +0100
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
Subject: Re: [PATCH v4] scsi: lpfc: Fix race conditions in ELS retry handling
To: Kyle Mahlkuch <kmahlkuc@linux.ibm.com>, linux-kernel@vger.kernel.org,
 linux-scsi@vger.kernel.org, Paul Ely <paul.ely@broadcom.com>
Cc: msmurthy@linux.ibm.com, mkp@kernel.org
References: <dcea48dd-f76c-4bb0-9275-c12ef9bd78a2@linux.ibm.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <dcea48dd-f76c-4bb0-9275-c12ef9bd78a2@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-13.29 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-0.998];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -13.29

On 11/11/26 6:47 PM, Kyle Mahlkuch wrote:
> This patch addresses a race condition in the lpfc driver's ELS retry
> event handling that can lead to a use-after-free in the
> lpfc_cancel_retry_delay_tmo(), where the NLP_DELAY_TMO flag is cleared
> before acquiring the lock to check if the retry event is queued. This
> creates a window where the timer can be rescheduled and fire, causing
> both the cancel path and the worker thread to release the same reference,
> resulting in a double-put and use-after-free.
> 
> Moved capture ndlp and clear evt_arg1 under hbalock while dequeuing
> LPFC_EVT_ELS_RETRY in lpfc_work_list_done().
> 
> Signed-off-by: Kyle Mahlkuch <kmahlkuc@linux.ibm.com>
> ---
> Changes since v3:
> - More whitespace cleanup. (Paul Ely)
> 
> Changes since v2:
> - Capture ndlp and clear evt_arg1 under hbalock while dequeuing
>    LPFC_EVT_ELS_RETRY in lpfc_work_list_done(). A requeue by
>    lpfc_els_retry_delay() could cause a NULL dereference in the worker.
>    (AI review)
> - Whitespace and line-wrapping cleanup.
> 
> Link: https://lore.kernel.org/lkml/29073ebc-b616-475b-bc05-384da09fbb54@linux.ibm.com/T/#u
> 
> Changes since v1:
> - Leave test_and_clear_bit op and timer_delete_sync at the beginning of
>    lpfc_cancel_retry_delay_tmo() outside of lock. (Paul Ely)
> 
> Link: https://lore.kernel.org/lkml/1c8a764c-fce1-4ce1-b797-47ac328cf3f2@linux.ibm.com/T/#u
> ---
>   drivers/scsi/lpfc/lpfc_els.c     | 29 +++++++++++++++++++++++------
>   drivers/scsi/lpfc/lpfc_hbadisc.c | 11 ++++++++++-
>   2 files changed, 33 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index 6f6394a0047c..98d1824aefe1 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -4477,18 +4477,35 @@ lpfc_issue_els_edc(struct lpfc_vport *vport, uint8_t retry)
>   void
>   lpfc_cancel_retry_delay_tmo(struct lpfc_vport *vport, struct lpfc_nodelist *nlp)
>   {
> -	struct lpfc_work_evt *evtp;
> +	struct lpfc_hba *phba = vport->phba;
> +	struct lpfc_work_evt *evtp = &nlp->els_retry_evt;
> +	struct lpfc_nodelist *arg_ndlp = NULL;
> +	unsigned long flags;
>   
>   	if (!test_and_clear_bit(NLP_DELAY_TMO, &nlp->nlp_flag))
>   		return;
>   	timer_delete_sync(&nlp->nlp_delayfunc);
>   	nlp->nlp_last_elscmd = 0;
> -	if (!list_empty(&nlp->els_retry_evt.evt_listp)) {
> -		list_del_init(&nlp->els_retry_evt.evt_listp);
> -		/* Decrement nlp reference count held for the delayed retry */
> -		evtp = &nlp->els_retry_evt;
> -		lpfc_nlp_put((struct lpfc_nodelist *)evtp->evt_arg1);
> +
> +	/*
> +	 * If retry event is queued, remove it under lock and consume
> +	 * its payload to prevent double-put. The event holds a reference
> +	 * to the nodelist that must be released exactly once.
> +	 */
> +	spin_lock_irqsave(&phba->hbalock, flags);
> +	if (!list_empty(&evtp->evt_listp)) {
> +		list_del_init(&evtp->evt_listp);
> +		/* Take local copy and clear to prevent reuse */
> +		arg_ndlp = (struct lpfc_nodelist *)evtp->evt_arg1;
> +		evtp->evt_arg1 = NULL;
> +		smp_wmb(); /* Ensure NULL visible before unlock */
>   	}
> +	spin_unlock_irqrestore(&phba->hbalock, flags);
> +
> +	/* Drop the event-held reference outside the lock */
> +	if (arg_ndlp)
> +		lpfc_nlp_put(arg_ndlp);
> +
>   	if (test_and_clear_bit(NLP_NPR_2B_DISC, &nlp->nlp_flag)) {
>   		if (vport->num_disc_nodes) {
>   			if (vport->port_state < LPFC_VPORT_READY) {
> diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
> index 4c673dffa671..75457f19d4ea 100644
> --- a/drivers/scsi/lpfc/lpfc_hbadisc.c
> +++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
> @@ -840,12 +840,21 @@ lpfc_work_list_done(struct lpfc_hba *phba)
>   	while (!list_empty(&phba->work_list)) {
>   		list_remove_head((&phba->work_list), evtp, typeof(*evtp),
>   				 evt_listp);
> +		/*
> +		 * The ELS retry event can be requeued by lpfc_els_retry_delay()
> +		 * as soon as hbalock is dropped. Consume the payload within the
> +		 * hbalock to prevent reuse or double-put.
> +		 */
> +		if (evtp->evt == LPFC_EVT_ELS_RETRY) {
> +			ndlp = (struct lpfc_nodelist *)(evtp->evt_arg1);
> +			evtp->evt_arg1 = NULL;
> +		}
>   		spin_unlock_irq(&phba->hbalock);
>   		hba_pci_err = test_bit(HBA_PCI_ERR, &phba->bit_flags);
>   		free_evt = 1;
>   		switch (evtp->evt) {
>   		case LPFC_EVT_ELS_RETRY:
> -			ndlp = (struct lpfc_nodelist *) (evtp->evt_arg1);
> +			/* ndlp was already captured under hbalock */
>   			if (!hba_pci_err) {
>   				lpfc_els_retry_delay_handler(ndlp);
>   				free_evt = 0; /* evt is part of ndlp */
> --
> 2.55.0

I thought I already did so, but here it is again:

Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
