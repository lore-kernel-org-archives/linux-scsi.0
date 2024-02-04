Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A245F2230F;
	Sun,  4 Feb 2024 12:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707048003; cv=none; b=KpPuqRvHQGHsxr8ip67Dj+hWEAshMnjbJpgRxYD38O5pyMpCV3o6EFaf3Zau9Rug/OQGk6BoaCzZDINtFn3eIQQDHKaaWZiarUcfdNCI/YcyjxE7a1pY9yFC0180hCUqiu17eqXT327TsiCvumMlet2rShCcimmxlBg8alC2j1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707048003; c=relaxed/simple;
	bh=c2K3NInGBCxCaCYF7MEZ9vPbzhIeJbjvZ/taKVpwHsc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ijmVr9L9zRdynorj+MbJ3BY9lxJDd1TEH4VsXRxYCs+ds5hR0ssxlNIr14eplTZk5ynbCUNgGWf5hgsO2OvdnC7ZOlfRebhWFfnPWnxsx5C2bIiSSuMFYRC17N1tp2DY1+50+m3CjvAWhdSBwAgsmWHZzm6Q+0+1ecGdGB/znFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=b4Eckj7G; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=zoR8tQ75; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=b4Eckj7G; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=zoR8tQ75; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="b4Eckj7G";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="zoR8tQ75";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="b4Eckj7G";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="zoR8tQ75"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BE52C21D97;
	Sun,  4 Feb 2024 11:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707047999; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rgOT9brjgC+d9tfMCqOxoiBpu9k5vxq+xkUiJDgn6zk=;
	b=b4Eckj7GF5UxFa49Ei2a01mquSgxsoEt3wX9hrN2si9Daw4burtn6BhFIhG0DJOt8ak1jt
	u2zF+F9n6Lu9qWwR6Z1dWuV0gRpDEaC1Ve1r3xp/7/bHB5ML6Xp1Dc8Wuadc7BG+GjSdQf
	wi6g2AXLhn6Tv6D5EIpYHYDnlgb6QuM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707047999;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rgOT9brjgC+d9tfMCqOxoiBpu9k5vxq+xkUiJDgn6zk=;
	b=zoR8tQ75fTs09LJQRAk7UgbLDcMzsK3rh2OGWPcSv57lpqXq28972cID4YZTVHwFFP2th5
	nhJtnudCu0f2a+BA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707047999; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rgOT9brjgC+d9tfMCqOxoiBpu9k5vxq+xkUiJDgn6zk=;
	b=b4Eckj7GF5UxFa49Ei2a01mquSgxsoEt3wX9hrN2si9Daw4burtn6BhFIhG0DJOt8ak1jt
	u2zF+F9n6Lu9qWwR6Z1dWuV0gRpDEaC1Ve1r3xp/7/bHB5ML6Xp1Dc8Wuadc7BG+GjSdQf
	wi6g2AXLhn6Tv6D5EIpYHYDnlgb6QuM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707047999;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rgOT9brjgC+d9tfMCqOxoiBpu9k5vxq+xkUiJDgn6zk=;
	b=zoR8tQ75fTs09LJQRAk7UgbLDcMzsK3rh2OGWPcSv57lpqXq28972cID4YZTVHwFFP2th5
	nhJtnudCu0f2a+BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4A0051338E;
	Sun,  4 Feb 2024 11:59:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qNirNzt8v2WjIAAAD6G6ig
	(envelope-from <hare@suse.de>); Sun, 04 Feb 2024 11:59:55 +0000
Message-ID: <555a08c2-6480-4a11-8f38-1d2b004a926f@suse.de>
Date: Sun, 4 Feb 2024 19:59:55 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/26] block: Introduce blk_zone_complete_request_bio()
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-5-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240202073104.2418230-5-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=b4Eckj7G;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zoR8tQ75
X-Spamd-Result: default: False [-3.30 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-3.00)[100.00%];
	 MIME_GOOD(-0.10)[text/plain];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 DKIM_TRACE(0.00)[suse.de:+];
	 MX_GOOD(-0.01)[];
	 RCPT_COUNT_SEVEN(0.00)[8];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: BE52C21D97
X-Spam-Level: 
X-Spam-Score: -3.30
X-Spam-Flag: NO

On 2/2/24 15:30, Damien Le Moal wrote:
> On completion of a zone append request, the request sector indicates the
> location of the written data. This value must be returned to the user
> through the BIO iter sector. This is done in 2 places: in
> blk_complete_request() and in req_bio_endio(). Introduce the inline
> helper function blk_zone_complete_request_bio() to avoid duplicating
> this BIO update for zone append requests, and to compile out this
> helper call when CONFIG_BLK_DEV_ZONED is not enabled.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   block/blk-mq.c | 11 +++++------
>   block/blk.h    | 19 ++++++++++++++++++-
>   2 files changed, 23 insertions(+), 7 deletions(-)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index bfebb8fcd248..f02e486a02ae 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -822,11 +822,11 @@ static void blk_complete_request(struct request *req)
>   		/* Completion has already been traced */
>   		bio_clear_flag(bio, BIO_TRACE_COMPLETION);
>   
> -		if (req_op(req) == REQ_OP_ZONE_APPEND)
> -			bio->bi_iter.bi_sector = req->__sector;
> -
> -		if (!is_flush)
> +		if (!is_flush) {
> +			blk_zone_complete_request_bio(req, bio);
>   			bio_endio(bio);
> +		}
> +
>   		bio = next;
>   	} while (bio);
>   
> @@ -928,8 +928,7 @@ bool blk_update_request(struct request *req, blk_status_t error,
>   
>   		/* Don't actually finish bio if it's part of flush sequence */
>   		if (!bio->bi_iter.bi_size && !is_flush) {
> -			if (req_op(req) == REQ_OP_ZONE_APPEND)
> -				bio->bi_iter.bi_sector = req->__sector;
> +			blk_zone_complete_request_bio(req, bio);
>   			bio_endio(bio);
>   		}
>   
> diff --git a/block/blk.h b/block/blk.h
> index 913c93838a01..23f76b452e70 100644
> --- a/block/blk.h
> +++ b/block/blk.h
> @@ -396,12 +396,29 @@ static inline struct bio *blk_queue_bounce(struct bio *bio,
>   
>   #ifdef CONFIG_BLK_DEV_ZONED
>   void disk_free_zone_bitmaps(struct gendisk *disk);
> +static inline void blk_zone_complete_request_bio(struct request *rq,
> +						 struct bio *bio)
> +{
> +	/*
> +	 * For zone append requests, the request sector indicates the location
> +	 * at which the BIO data was written. Return this value to the BIO
> +	 * issuer through the BIO iter sector.
> +	 */
> +	if (req_op(rq) == REQ_OP_ZONE_APPEND)
> +		bio->bi_iter.bi_sector = rq->__sector;
> +}
>   int blkdev_report_zones_ioctl(struct block_device *bdev, unsigned int cmd,
>   		unsigned long arg);
>   int blkdev_zone_mgmt_ioctl(struct block_device *bdev, blk_mode_t mode,
>   		unsigned int cmd, unsigned long arg);
>   #else /* CONFIG_BLK_DEV_ZONED */
> -static inline void disk_free_zone_bitmaps(struct gendisk *disk) {}
> +static inline void disk_free_zone_bitmaps(struct gendisk *disk)
> +{
> +}
> +static inline void blk_zone_complete_request_bio(struct request *rq,
> +						 struct bio *bio)
> +{
> +}
>   static inline int blkdev_report_zones_ioctl(struct block_device *bdev,
>   		unsigned int cmd, unsigned long arg)
>   {

Well, it doesn't _actually_ complete the request nor the bio.
What about blk_zone_update_request_bio()?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Ivo Totev, Andrew McDonald,
Werner Knoblich

