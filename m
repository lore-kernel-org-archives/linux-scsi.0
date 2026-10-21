Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792575965;
	b=BJ0+mBcrGvBaDVoPM/vsWTjsvziLcPYqnxE4Z0fwhP1b/CpzNMcWcG36YlNtjI6a3Wqs
	 cnaDTvcUnjp7Je+ZwARvFEol9B2VNGzEY8OO34Q/KUjaaA+BWysZlj1AAJMRQPe6WtxEC
	 pf7TiQXP17gdSJBSqQ+UjOS3Gn469ofHilhWmReOe4wZQS/RSst8FdZ2V5TsmsmJ81s+U
	 uxapjZrsMNDKSlRwhOEp+3t2HVGNJ+dvKQXc38SBjDKHUCK1mTT4DI5ujgD9fpSCl5M07
	 aua/lDd8fHmSiCtQoD8Crqj7DMfScVnRadxMD/zJasCbIQDRZP12RVgW2gIS9see1cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792575965;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spamd-Result:X-Spam-Score:
	 X-Spam-Level:X-Spam-Flag;
	bh=94pDiD4nM4E4WevUILRY7xdeQQFnrIXJErGN81yO8gM=;
	b=ebJjxgcDuNJDz1haVRmDSL9oMHyuGCAkny34zmlRw+dyyd/Nef+6SEhs5NnmQr6LsKr2
	 6sfROJsSdOr1fyPXA/hR4Yw1/Ciu6kL68tkd7LeNK06YfQ/3QQjHDPdczuH0ZAlfonAO8
	 3KvIAKmNJNdTzrWMYTKO9LaKAGAOcSCMkZMGE7p6Khyc2+BZDMWqn86LsU0VMcv69W7Et
	 fhmTFdj7FMYjUgARKx+jck+hStl67xQF+1OqC3dr8lEf3qn1+adStxTaKSCY77sbtrhOr
	 3eh2/nQ6s/kjZQrInDSq+MBCZ2Wxy+58UlfW6nNe41qk9Lpv0HaMK4RtW9ob6g18cMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=GF1ki+Hv;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=k1tCRrE8;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=GF1ki+Hv;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=k1tCRrE8;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0E9606A321;
	Wed, 21 Oct 2026 09:46:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0B0E9606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=GF1ki+Hv;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=k1tCRrE8;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=GF1ki+Hv;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=k1tCRrE8
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6F3F41F461;
	Wed, 21 Oct 2026 09:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792575963; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=94pDiD4nM4E4WevUILRY7xdeQQFnrIXJErGN81yO8gM=;
	b=GF1ki+HvgQoECxQSOdHAvLVK1X7Z8bVvobTCHExbQkIzSgP73hjN1dIyCx1b+TO8jKPxYR
	ar8UVWCCNingktihV+2ed345KvQi/63iVaNAsM5gxrZrr/sELqLEb2jS6SnKzJ/p2ddOK2
	E+iCLQ8iN/gO8X3gYI2EwApnND9BWNQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792575963;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=94pDiD4nM4E4WevUILRY7xdeQQFnrIXJErGN81yO8gM=;
	b=k1tCRrE8XIWzdj7FRrjM6MMzszS7pXH6t/k1CKnR9lZVQOk3QQffegKFUCh+K7d0im1Neu
	dL8zfuT2Eqz8UFCQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792575963; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=94pDiD4nM4E4WevUILRY7xdeQQFnrIXJErGN81yO8gM=;
	b=GF1ki+HvgQoECxQSOdHAvLVK1X7Z8bVvobTCHExbQkIzSgP73hjN1dIyCx1b+TO8jKPxYR
	ar8UVWCCNingktihV+2ed345KvQi/63iVaNAsM5gxrZrr/sELqLEb2jS6SnKzJ/p2ddOK2
	E+iCLQ8iN/gO8X3gYI2EwApnND9BWNQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792575963;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=94pDiD4nM4E4WevUILRY7xdeQQFnrIXJErGN81yO8gM=;
	b=k1tCRrE8XIWzdj7FRrjM6MMzszS7pXH6t/k1CKnR9lZVQOk3QQffegKFUCh+K7d0im1Neu
	dL8zfuT2Eqz8UFCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3A428134FD;
	Wed, 21 Oct 2026 09:46:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qoCqBNuJ2Gr2JgAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 21 Oct 2026 09:46:03 +0000
Message-ID: <1030c0b6-5cb8-40de-b4db-988cc1c4c95d@suse.de>
Date: Wed, 21 Oct 2026 11:46:02 +0200
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
Subject: Re: [PATCH v6 05/10] zloop: avoid potential wp_lock deadlocks
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20261013122750.2237843-1-dlemoal@kernel.org>
 <20261013122750.2237843-6-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261013122750.2237843-6-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-0.997];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email]
X-Spam-Score: -4.29
X-Spam-Level: 
X-Spam-Flag: NO

On 10/13/26 2:27 PM, Damien Le Moal wrote:
> zloop_queue_rq() maybe called from softirq context with interrupts
> disabled. However, zloop_queue_rq() may call
> zloop_set_zone_append_sector() which takes a zone wp_lock using a simple
> spin_lock(). This can cause deadlocks with competing contexts that have
> already taken that lock. Avoid this by using the irq disabling/enabling
> variants of spin_lock/unlock. While at it, zloop_report_zones() is also
> modified to take the wp_lock around both the write pointer and the zone
> condition reporting to ensure that both values are consistent for a
> report.
> 
> Fixes: fcc6eaa3a03a ("zloop: introduce the ordered_zone_append configuration parameter")
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/block/zloop.c | 37 ++++++++++++++++++++++---------------
>   1 file changed, 22 insertions(+), 15 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
