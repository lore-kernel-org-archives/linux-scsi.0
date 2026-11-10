Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794294521;
	b=l90Nrj7nqqsiprGSZrabzyVltC/tjZW2tBU+JQG9rjyRZn7rDN7OqUvYvciOYHxojDex
	 yq5j7hZndEcjRmEsYy1skmMRSyw5v388OYxVYdOeQVH1ROaooYPJR6cVqnoXE3GpYBvca
	 8hIRWv8uDnF+pLIwtsNa8kxJYoWCj73rbhOyfHU3sVLLJVLEVrdMjnLyXT6UY1+y+JAP2
	 2UgC1Xla1fVU96zYagHR1fAJAQCCF28Knm6alcU4dDk9Ql6GVQuPa8KHlHbTZt0OCrWPB
	 pHFm7A0McnqsZf1fLPoRywWo+f8REwPwa4zrenCF/9VIOdWE2wnUxpmy2CUwmVxTlUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794294521;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spamd-Result:X-Spam-Score:
	 X-Spam-Level:X-Spam-Flag;
	bh=6sCa3I8uqBY+mwKPbmC2PKEeRslYE8O+JX9d1UmOmt0=;
	b=KkpmG4P2h1rSv3Yg2smLE75ikKccxgztJ0Vr1bxy9WqGCnT4ZWgbhqfZqDXuqSHBsxXX
	 PoqmUiAQ2P3BBaPPwvC0cQzrlCaJ7P9GAN648/insI+hul0CFxKNmkNjY5IJcXfVsSMS3
	 ASOhRVWAQQMkRSnt4o/Ob5VVoZPoHZxxsf8v9rYMt1rPfZ94IhMom17Fe/3sOHNWHopCr
	 pgEbBX8IEb38jHd4eyhGRsxxVJ0H24j7z6c/YHunP3TVbWr+otnAagT+UVf3l5llsbM7p
	 W392IVg/FNypraGMotu7449BkVyG68s/qWYq8a4gmrdiW3KIJD+Scoj96vlehWqONBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=K+8WGg1C;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=OGdzpwF0;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=K+8WGg1C;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=OGdzpwF0;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43AAB606A321;
	Tue, 10 Nov 2026 07:08:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 43AAB606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=K+8WGg1C;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=OGdzpwF0;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=K+8WGg1C;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=OGdzpwF0
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3A8DF1F457;
	Tue, 10 Nov 2026 07:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794294519; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6sCa3I8uqBY+mwKPbmC2PKEeRslYE8O+JX9d1UmOmt0=;
	b=K+8WGg1CV6bYfnxFH4W6t4xzeUFMUmmiQwagZA0P/InbAEbZmYUjsuRiVUErSLIRMJ/Hyt
	LOkLtMrY5T+lIt1KL9GftvqfzqSC/OsdntBc9D/u2uYPhi8HyCcSYVTTWTEWz6CVypfCl8
	u/elO9pFLx0Vk3Iaju0/lOGmP+Oh4cA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794294519;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6sCa3I8uqBY+mwKPbmC2PKEeRslYE8O+JX9d1UmOmt0=;
	b=OGdzpwF0SdzKJ1PaLGYF2+JuZS9q1jaMOqUe81ra00GH2K24TaU12qfPF9hNOpwFToRbna
	l4sDBa/mxPM2bfCw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794294519; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6sCa3I8uqBY+mwKPbmC2PKEeRslYE8O+JX9d1UmOmt0=;
	b=K+8WGg1CV6bYfnxFH4W6t4xzeUFMUmmiQwagZA0P/InbAEbZmYUjsuRiVUErSLIRMJ/Hyt
	LOkLtMrY5T+lIt1KL9GftvqfzqSC/OsdntBc9D/u2uYPhi8HyCcSYVTTWTEWz6CVypfCl8
	u/elO9pFLx0Vk3Iaju0/lOGmP+Oh4cA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794294519;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6sCa3I8uqBY+mwKPbmC2PKEeRslYE8O+JX9d1UmOmt0=;
	b=OGdzpwF0SdzKJ1PaLGYF2+JuZS9q1jaMOqUe81ra00GH2K24TaU12qfPF9hNOpwFToRbna
	l4sDBa/mxPM2bfCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C3CA31339F;
	Tue, 10 Nov 2026 07:08:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QRpwHvbC8mqjXAAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 10 Nov 2026 07:08:38 +0000
Message-ID: <41aae956-1ece-4af3-99e0-1e9ee1f840d3@suse.de>
Date: Tue, 10 Nov 2026 08:08:38 +0100
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
Subject: Re: [PATCH] scsi: libfc: Fix rport kref leak in
 fc_rport_enter_ready()
To: weidongw@illinois.edu, "Martin K. Petersen" <mkp@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261108-h123-send-v1-1-b7672ff849f0@illinois.edu>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261108-h123-send-v1-1-b7672ff849f0@illinois.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-13.29 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-0.998];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -13.29
X-Spam-Level: 
X-Spam-Flag: NO

On 11/8/26 10:01 AM, Weidong Wang via B4 Relay wrote:
> From: Weidong Wang <weidongw@illinois.edu>
> 
> fc_rport_enter_ready() takes a reference on the rport unconditionally,
> but only queues event_work, whose handler drops that reference, when no
> event is pending. If rdata->event is already set, the && short-circuits
> past both queue_work() and the compensating kref_put(), so the reference
> is leaked and the fc_rport_priv is never freed.
> 
> This is reachable from the wire: a PLOGI from a well-known address goes
> straight to fc_rport_enter_ready(), and a second PLOGI for the same
> S_ID while RPORT_EV_READY is still pending enters it again. After the
> rport is logged out, kmemleak reports:
> 
>    unreferenced object 0xffff888... (size 512):
>    backtrace:
>      __kmalloc_noprof
>      fc_rport_create
>      fc_rport_recv_req
>      fc_lport_recv_els_req
>      fc_lport_recv
>      fcoe_receive_work
> 
> Commit 823a65409c89 ("scsi: libfc: Skip additional kref updating work
> event") fixed the same pattern in fc_rport_enter_delete(). Do the same
> here: only take the reference when no event is pending, i.e. when the
> work is actually going to be queued.
> 
> The issue was found with an LLM-based bug-finding tool; the reproducer,
> fix and changelog were drafted with AI assistance (Claude), then
> reviewed and tested by the submitter.
> 
> Fixes: 4d2095cc42a2 ("scsi: libfc: Revisit kref handling")
> Cc: stable@vger.kernel.org
> Signed-off-by: Weidong Wang <weidongw@illinois.edu>
> ---
> Tested on v7.4-rc1 (05441d697f7f), x86_64, KASAN + kmemleak, QEMU/KVM.
> Reproducer: software FCoE instance on lo; raw FCoE ELS frames injected
> with AF_PACKET (PLOGI from well-known S_IDs 0xfffc01.., a second PLOGI
> for the same S_ID while RPORT_EV_READY is pending, then LOGO), 120 rports.
> 
>                     2nd enter_ready with    kmemleak unreferenced
>                     event pending           fc_rport_priv (512 B)
>    unpatched        116                     99
>    patched          104                     0
> 
> READY/delete work events are processed the same with and without the
> patch; no KASAN/UBSAN/WARN splats. checkpatch clean, no new W=1 warnings.
> The reproducer can be shared on request.
> ---
>   drivers/scsi/libfc/fc_rport.c | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
> index c25979d96..7b0938544 100644
> --- a/drivers/scsi/libfc/fc_rport.c
> +++ b/drivers/scsi/libfc/fc_rport.c
> @@ -550,10 +550,11 @@ static void fc_rport_enter_ready(struct fc_rport_priv *rdata)
>   
>   	FC_RPORT_DBG(rdata, "Port is Ready\n");
>   
> -	kref_get(&rdata->kref);
> -	if (rdata->event == RPORT_EV_NONE &&
> -	    !queue_work(rport_event_queue, &rdata->event_work))
> -		kref_put(&rdata->kref, fc_rport_destroy);
> +	if (rdata->event == RPORT_EV_NONE) {
> +		kref_get(&rdata->kref);
> +		if (!queue_work(rport_event_queue, &rdata->event_work))
> +			kref_put(&rdata->kref, fc_rport_destroy);
> +	}
>   
>   	rdata->event = RPORT_EV_READY;
>   }
> 
> ---
> base-commit: 05441d697f7f9a927264f4058cbbc6a03dfcac9d
> change-id: 20261108-h123-send-723aeb555069
> 
> Best regards,
> --
> Weidong Wang <weidongw@illinois.edu>
> 
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
