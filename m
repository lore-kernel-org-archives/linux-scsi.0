Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794386003;
	b=3bsEIyDDv7i7NlzKOJ9NnG3kMK5E9OiJBoR9RR9o5bkdjTUbvC3MC8R0/I7ww4zEASpF
	 iM8Xifompwgzr7SYAtnihRYxXYk9JkVaNqPjBk1Z92f2y1F2i7gQb8yIfY+HVUHqzi8tZ
	 QfxEUqndkVt+OI/sGTkFUIDN8VqUlGK7kJB594sRbZ5z/GEoK7iAas6KD5Bcmf2eEGDFA
	 rBI+BWISp/VKUXbdduwB/aXiKsCXIx7d+oVk3VY/6TRRGqDa/ObkILbAoJrQfUbj9tG8f
	 iMCXLYfb6Tj2NTJQdJTzElwHJXpww5GUXjy6kih4JrhR48wce1LfoUR6Vxw0MXbuMGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794386003;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spamd-Result:X-Spam-Score:
	 X-Spam-Level:X-Spam-Flag;
	bh=H0M5fe4rX4y34P5lBmCgNpazH6znzrtF06bCILqdQ8c=;
	b=uBmq2/mB1fEPkGf3vWtxCEZJ5884d8KQ+1d9a6MZMUpOveccOAfC0lQrFLb9J6CSCduv
	 sPZP+WiaMJEYea67eGURL5JB6Azloi8drTOWtfBhkWwlVwfd0MTR+2+1/g/g+gJSn8n3h
	 +j1vyhBoqhSmRfa/K3pPAnLhAyB4ZpGDAOW2S6NyZKVzflfyysViOmcjJbN608nXAHXXa
	 X6kckpEskQjIySuKWsNRhwc4NeXRhyv1QxClq2CPqhgiLjksXd8GDeP5CPbPt0IeYuXHs
	 qg4WNz1lK0fySRgPPgJ6UPxQ12+buDjR7JwZ4Rpv6XH/yq5rCJc4EiYkGAKf9RJOuYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b="NevRc/mE";
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=qFJWrNmv;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=SGhWk30V;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="/6xDbCJy";
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F06606A31C;
	Wed, 11 Nov 2026 08:33:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 25F06606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=NevRc/mE;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=qFJWrNmv;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=SGhWk30V;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=/6xDbCJy
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D979A1F7D0;
	Wed, 11 Nov 2026 08:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794386001; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H0M5fe4rX4y34P5lBmCgNpazH6znzrtF06bCILqdQ8c=;
	b=NevRc/mEi8ZJc3hliO0mG1FBmlSzwoNOz2jEZ2JyqtRKzYMSVcAMtmCMmrbE6qW6zWYpMe
	xnWs9KBAZwJK66ZCnEg9REglAVysp+z52XHkXSdJSGUq5J4jC2DP8aWzUGkd2IkoiI5Zwd
	GNAC9KDWX0pfeemYwAum5FoyG7OxVLs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794386001;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H0M5fe4rX4y34P5lBmCgNpazH6znzrtF06bCILqdQ8c=;
	b=qFJWrNmv4CLe/5C1SQvxs3QndTRPbrKd69B9QVwsSVOH8uVseyUywKGc6V+ov17kvEO+Dg
	8MHkrBGzOyhvnJBA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794386000; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H0M5fe4rX4y34P5lBmCgNpazH6znzrtF06bCILqdQ8c=;
	b=SGhWk30VBhd62jpddglsk19NkKL0M5KwwJBNZweS+cug8L6uMAgErfqbX3d5gqjiuitLbH
	GYxMF1Pb1lGwweUZgxfw3t8r2Cf9NPA8hVkCHMPB46pmealNYNw4n/yAW4zGgyJFtsJnFM
	x0K34uWGdLIHzlmsEO7AjvUyIQ0/9XY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794386000;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H0M5fe4rX4y34P5lBmCgNpazH6znzrtF06bCILqdQ8c=;
	b=/6xDbCJyNCGkwW1qFbsULEYdx5bNT3YbMvyc+YajRon3Pgw2cplfgjfFU/CCZLRFdrGAKE
	KT5a/GKlQtrpj3Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7ACFB134E5;
	Wed, 11 Nov 2026 08:33:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vhiNFFAo9Gp0GgAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 11 Nov 2026 08:33:20 +0000
Message-ID: <c0fff7fe-e23b-4161-a25c-dfd74e89201c@suse.de>
Date: Wed, 11 Nov 2026 09:33:19 +0100
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
Subject: Re: [PATCH v3] scsi: lpfc: Fix race conditions in ELS retry handling
To: Kyle Mahlkuch <kmahlkuc@linux.ibm.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, mkp@kernel.org
Cc: Paul Ely <paul.ely@broadcom.com>, msmurthy@linux.ibm.com
References: <e893d431-79ef-4fae-bca4-38903fc8f49d@linux.ibm.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <e893d431-79ef-4fae-bca4-38903fc8f49d@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-13.27 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-0.98)[-0.985];
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
X-Spam-Score: -13.27
X-Spam-Level: 
X-Spam-Flag: NO

On 11/10/26 9:16 PM, Kyle Mahlkuch wrote:
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
> Changes since v2:
> - Capture ndlp and clear evt_arg1 under hbalock while dequeuing
>    LPFC_EVT_ELS_RETRY in lpfc_work_list_done(). A requeue by
>    lpfc_els_retry_delay() could cause a NULL dereference in the worker.
>    (AI review)
> - Whitespace and line-wrapping cleanup.
> 
> Link: https://lore.kernel.org/lkml/29073ebc-b616-475b- 
> bc05-384da09fbb54@linux.ibm.com/T/#u
> 
> Changes since v1:
> - Leave test_and_clear_bit op and timer_delete_sync at the beginning of
>    lpfc_cancel_retry_delay_tmo() outside of lock. (Paul Ely)
> 
> Link: https://lore.kernel.org/lkml/1c8a764c-fce1-4ce1- 
> b797-47ac328cf3f2@linux.ibm.com/T/#u
> ---
>   drivers/scsi/lpfc/lpfc_els.c     | 29 +++++++++++++++++++++++------
>   drivers/scsi/lpfc/lpfc_hbadisc.c | 11 ++++++++++-
>   2 files changed, 33 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index 6f6394a0047c..98d1824aefe1 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -4477,18 +4477,35 @@ lpfc_issue_els_edc(struct lpfc_vport *vport, 
> uint8_t retry)
>   void
>   lpfc_cancel_retry_delay_tmo(struct lpfc_vport *vport, struct 
> lpfc_nodelist *nlp)
>   {
> -    struct lpfc_work_evt *evtp;
> +    struct lpfc_hba *phba = vport->phba;
> +    struct lpfc_work_evt *evtp = &nlp->els_retry_evt;
> +    struct lpfc_nodelist *arg_ndlp = NULL;
> +    unsigned long flags;
> 
>       if (!test_and_clear_bit(NLP_DELAY_TMO, &nlp->nlp_flag))
>           return;
>       timer_delete_sync(&nlp->nlp_delayfunc);
>       nlp->nlp_last_elscmd = 0;
> -    if (!list_empty(&nlp->els_retry_evt.evt_listp)) {
> -        list_del_init(&nlp->els_retry_evt.evt_listp);
> -        /* Decrement nlp reference count held for the delayed retry */
> -        evtp = &nlp->els_retry_evt;
> -        lpfc_nlp_put((struct lpfc_nodelist *)evtp->evt_arg1);
> +
> +    /*
> +     * If retry event is queued, remove it under lock and consume
> +     * its payload to prevent double-put. The event holds a reference
> +     * to the nodelist that must be released exactly once.
> +     */
> +    spin_lock_irqsave(&phba->hbalock, flags);
> +    if (!list_empty(&evtp->evt_listp)) {
> +        list_del_init(&evtp->evt_listp);
> +        /* Take local copy and clear to prevent reuse */
> +        arg_ndlp = (struct lpfc_nodelist *)evtp->evt_arg1;
> +        evtp->evt_arg1 = NULL;
> +        smp_wmb(); /* Ensure NULL visible before unlock */
>       }
> +    spin_unlock_irqrestore(&phba->hbalock, flags);
> +
> +    /* Drop the event-held reference outside the lock */
> +    if (arg_ndlp)
> +        lpfc_nlp_put(arg_ndlp);
> +
>       if (test_and_clear_bit(NLP_NPR_2B_DISC, &nlp->nlp_flag)) {
>           if (vport->num_disc_nodes) {
>               if (vport->port_state < LPFC_VPORT_READY) {
> diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/ 
> lpfc_hbadisc.c
> index 4c673dffa671..75457f19d4ea 100644
> --- a/drivers/scsi/lpfc/lpfc_hbadisc.c
> +++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
> @@ -840,12 +840,21 @@ lpfc_work_list_done(struct lpfc_hba *phba)
>       while (!list_empty(&phba->work_list)) {
>           list_remove_head((&phba->work_list), evtp, typeof(*evtp),
>                    evt_listp);
> +        /*
> +         * The ELS retry event can be requeued by lpfc_els_retry_delay()
> +         * as soon as hbalock is dropped. Consume the payload within the
> +         * hbalock to prevent reuse or double-put.
> +         */
> +        if (evtp->evt == LPFC_EVT_ELS_RETRY) {
> +            ndlp = (struct lpfc_nodelist *)(evtp->evt_arg1);
> +            evtp->evt_arg1 = NULL;
> +        }
>           spin_unlock_irq(&phba->hbalock);
>           hba_pci_err = test_bit(HBA_PCI_ERR, &phba->bit_flags);
>           free_evt = 1;
>           switch (evtp->evt) {
>           case LPFC_EVT_ELS_RETRY:
> -            ndlp = (struct lpfc_nodelist *) (evtp->evt_arg1);
> +            /* ndlp was already captured under hbalock */
>               if (!hba_pci_err) {
>                   lpfc_els_retry_delay_handler(ndlp);
>                   free_evt = 0; /* evt is part of ndlp */

Good catch.

Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
