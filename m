Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E348822314;
	Sun,  4 Feb 2024 12:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707049628; cv=none; b=Dy4D573GMNmBAiiRccOePCXRiM4hsOfaemuwHk9Q81uhS428DX8GTOynACJ2r5M0XcpB2cVNXchmt8d2hhQKsp9w1wkDcEmwYBGDC8sHrUrRNvsjrWLPYVlBQpMxUc2IyHyJNeVZHu2Lr81gma3P3BLR+QyUBwdj+5BQFPWqGK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707049628; c=relaxed/simple;
	bh=ViFNQ78iDifceRteZ9ZO3vS3UaUaUJBXZzv8Ifn2wIc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DiIkEWl8Gp58TSOESiQMHnuqLrZSD2OpohRV6fmCjGb+aXBPPOekJdCzxzKUqB/IlyFVNQKH41XOHtD95v3iM9hQMVokvCXjQ6V+mi12QmAIHbjMjQAkty9YS66ARD919R+splqjs76crDu3Ff6idX+1nj4Z+S79likK8hLU9BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=mck6Icgx; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=dSgxLsFq; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=mck6Icgx; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=dSgxLsFq; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="mck6Icgx";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="dSgxLsFq";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="mck6Icgx";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="dSgxLsFq"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 186971F80C;
	Sun,  4 Feb 2024 12:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707049625; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B2I4rqNyStAJJzbVrqLv9sFZfZvJSnkRHcGoPDGXGxk=;
	b=mck6IcgxBzw+IO1gwC25OjaGK9hek9SrsyUeck1ByetsiF/eMzxCaa5p9WIo7DgqvmasaY
	Cgm5kks1Snn4oofBxaF4Yki1mHH0mXGemqOleku7X+3InjWp+N7ZngKETmfm48OYqLsmaL
	LI81yzetcQPlU5NOAdipUy9Evk2DhFY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707049625;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B2I4rqNyStAJJzbVrqLv9sFZfZvJSnkRHcGoPDGXGxk=;
	b=dSgxLsFqYSqGn3aQ12DM9JDPFvYxEYGd0QdH10ST08zdQ9yk/wY9qnu0WnN3NBdLj69eeR
	S6gs8Lqas+1AGeCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707049625; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B2I4rqNyStAJJzbVrqLv9sFZfZvJSnkRHcGoPDGXGxk=;
	b=mck6IcgxBzw+IO1gwC25OjaGK9hek9SrsyUeck1ByetsiF/eMzxCaa5p9WIo7DgqvmasaY
	Cgm5kks1Snn4oofBxaF4Yki1mHH0mXGemqOleku7X+3InjWp+N7ZngKETmfm48OYqLsmaL
	LI81yzetcQPlU5NOAdipUy9Evk2DhFY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707049625;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B2I4rqNyStAJJzbVrqLv9sFZfZvJSnkRHcGoPDGXGxk=;
	b=dSgxLsFqYSqGn3aQ12DM9JDPFvYxEYGd0QdH10ST08zdQ9yk/wY9qnu0WnN3NBdLj69eeR
	S6gs8Lqas+1AGeCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 16C65132DD;
	Sun,  4 Feb 2024 12:27:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ceXKLpWCv2WOJgAAD6G6ig
	(envelope-from <hare@suse.de>); Sun, 04 Feb 2024 12:27:01 +0000
Message-ID: <feccafb5-d945-4d40-be3c-e4a4ac8a9cf6@suse.de>
Date: Sun, 4 Feb 2024 20:26:58 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/26] block: Allow BIO-based drivers to use
 blk_revalidate_disk_zones()
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-10-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240202073104.2418230-10-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out2.suse.de;
	none
X-Spamd-Result: default: False [-3.09 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-3.00)[100.00%];
	 MIME_GOOD(-0.10)[text/plain];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 RCPT_COUNT_SEVEN(0.00)[8];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -3.09

On 2/2/24 15:30, Damien Le Moal wrote:
> Remove the check in blk_revalidate_disk_zones() restricting the use of
> this function to mq request-based drivers to allow also BIO-based
> drivers to use it. This is safe to do as long as the BIO-based block
> device queue is already setup and usable, as it should, and can be
> safely frozen.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   block/blk-zoned.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 929c28796c41..8bf6821735f3 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -1316,8 +1316,8 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
>    * be called within the disk ->revalidate method for blk-mq based drivers.
>    * Before calling this function, the device driver must already have set the
>    * device zone size (chunk_sector limit) and the max zone append limit.
> - * For BIO based drivers, this function cannot be used. BIO based device drivers
> - * only need to set disk->nr_zones so that the sysfs exposed value is correct.
> + * BIO based drivers can also use this function as long as the device queue
> + * can be safely frozen.
>    * If the @update_driver_data callback function is not NULL, the callback is
>    * executed with the device request queue frozen after all zones have been
>    * checked.
> @@ -1334,8 +1334,6 @@ int blk_revalidate_disk_zones(struct gendisk *disk,
>   
>   	if (WARN_ON_ONCE(!blk_queue_is_zoned(q)))
>   		return -EIO;
> -	if (WARN_ON_ONCE(!queue_is_mq(q)))
> -		return -EIO;
>   
>   	if (!capacity)
>   		return -ENODEV;
Reviewed-by: Hannes Reinecke <hare@suse.de

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Ivo Totev, Andrew McDonald,
Werner Knoblich

