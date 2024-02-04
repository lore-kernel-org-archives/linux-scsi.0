Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B9A2232B;
	Sun,  4 Feb 2024 12:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707049479; cv=none; b=JGRTXHw15qAw/37NggETwlYmnssM/jsKr6/UZN0tHUkryRly+/e9BabyIACq62/CllkXh0LN2M4p4tDdJvca+jpmi2szCvPLOIiYtsVEKs8VIGy0f53wdka3HnRuIMTTzADCsLJC+yKUzbVkaOp9nntF2o1hjC/WXJ8IIYRZDkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707049479; c=relaxed/simple;
	bh=IWDOhxLtYQKZGzCWwv4yEcoOnYNCsaZ06qa6hPrWrJY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IuSEVWNt6SJVXZi7sIJJW6QWdQ81nkVoblNgBRA1Ko9xcNOXPnasY1pl/yOKaJ+OH0ejRU71yPlKMsezv1qcsiOR+otDLZKL3y2bLPnIH26XSGtdUiRMsljJP37tAgo/nz1XVuMemJQ1yQEtuzi/P4ycuEMPl1IDW7DUzm7ljFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=uCyjzM/w; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=oEv7CUrT; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=uCyjzM/w; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=oEv7CUrT; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="uCyjzM/w";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="oEv7CUrT";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="uCyjzM/w";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="oEv7CUrT"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 74A2421F70;
	Sun,  4 Feb 2024 12:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707049475; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uBNY+fek8t+jOWJK5izk33zh56ZH0EKrotE1oDNyP10=;
	b=uCyjzM/wU17g2dyr897sNElr91e8NICnREwllpu5Ji591/hTAIbdsfOPbtOxnjdEkxI9A2
	6ThqTck7ghtZQa5zAE03xzQWrzUh71e5GSj++ScR+IK1JLfVnDEmVCY2/QGXSInhI+Fv0r
	buhYYmRuIfLvuL0mcIyRHj1WK2qpVyE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707049475;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uBNY+fek8t+jOWJK5izk33zh56ZH0EKrotE1oDNyP10=;
	b=oEv7CUrTSjzhZw0vLxDxaAgboDlLJJkyZP889r+68nEnxcQACqDcZFp3LJqSSTazRU44w5
	l3i8XVhA1ZgEGICA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707049475; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uBNY+fek8t+jOWJK5izk33zh56ZH0EKrotE1oDNyP10=;
	b=uCyjzM/wU17g2dyr897sNElr91e8NICnREwllpu5Ji591/hTAIbdsfOPbtOxnjdEkxI9A2
	6ThqTck7ghtZQa5zAE03xzQWrzUh71e5GSj++ScR+IK1JLfVnDEmVCY2/QGXSInhI+Fv0r
	buhYYmRuIfLvuL0mcIyRHj1WK2qpVyE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707049475;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uBNY+fek8t+jOWJK5izk33zh56ZH0EKrotE1oDNyP10=;
	b=oEv7CUrTSjzhZw0vLxDxaAgboDlLJJkyZP889r+68nEnxcQACqDcZFp3LJqSSTazRU44w5
	l3i8XVhA1ZgEGICA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 54A2D132DD;
	Sun,  4 Feb 2024 12:24:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id swr6Av+Bv2UWJgAAD6G6ig
	(envelope-from <hare@suse.de>); Sun, 04 Feb 2024 12:24:31 +0000
Message-ID: <9026cc14-b107-41de-994f-6b46858b6601@suse.de>
Date: Sun, 4 Feb 2024 20:24:27 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/26] block: Implement zone append emulation
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-9-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240202073104.2418230-9-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="uCyjzM/w";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=oEv7CUrT
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-8.00 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-3.00)[100.00%];
	 MIME_GOOD(-0.10)[text/plain];
	 DWL_DNSWL_HI(-3.50)[suse.de:dkim];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 DKIM_TRACE(0.00)[suse.de:+];
	 MX_GOOD(-0.01)[];
	 RCPT_COUNT_SEVEN(0.00)[8];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Score: -8.00
X-Rspamd-Queue-Id: 74A2421F70
X-Spam-Flag: NO

On 2/2/24 15:30, Damien Le Moal wrote:
> Given that zone write plugging manages all writes to zones of a zoned
> block device, we can track the write pointer position of all zones in
> order to implement zone append emulation using regular write operations.
> This is needed for devices that do not natively support the zone append
> command, e.g. SMR hard-disks.
> 
> This commit adds zone write pointer tracking similarly to how the SCSI
> disk driver (sd) does, that is, in the form of a 32-bits number of
> sectors equal to the offset within the zone of the zone write pointer.
> The wp_offset field is added to struct blk_zone_wplug for this. Write
> pointer tracking is only enabled for zoned devices that requested
> zone append emulation by setting the max_zone_append_sectors queue
> limit of the disk to 0.
> 
> For zoned devices that requested zone append emulation, wp_offset is
> managed as follows:
>   - It is incremented when a write BIO is prepared for submission or
>     merged into a new request. This is done in
>     blk_zone_wplug_prepare_bio() when a BIO is unplugged, in
>     blk_zone_write_plug_bio_merged() when a new unplugged BIO is merged
>     before zone write plugging and in blk_zone_write_plug_attempt_merge()
>     when plugged BIOs are merged into a new request.
>   - The helper functions blk_zone_handle_reset() and
>     blk_zone_handle_reset_all() are added to set the write pointer
>     offset to 0 for the targeted zones of REQ_OP_ZONE_RESET and
>     REQ_OP_ZONE_RESETALL operations.
>   - The helper function blk_zone_handle_finish() is added to set the
>     write pointer offset to the zone size for the target zone of a
>     REQ_OP_ZONE_FINISH operation.
> 
> The function blk_zone_wplug_prepare_bio() also checks and prepares a BIO
> for submission. Preparation involves changing zone append BIOs into
> non-mergeable regular write BIOs for devices that require zone append
> emulation. Modified zone append BIOs are flagged with the new BIO flag
> BIO_EMULATES_ZONE_APPEND. This flag is checked on completion of the
> BIO in blk_zone_complete_requests_bio() to restore the original
> REQ_OP_ZONE_APPEND operation code of the BIO.
> 
> If a write error happens, the wp_offset value may become incorrect and
> out of sync with the device managed write pointer. This is handled using
> the new zone write plug flag BLK_ZONE_WPLUG_ERROR. The function
> blk_zone_wplug_handle_error() is called from the new disk zone write
> plug work when this flag is set. This function executes a report zone to
> update the zone write pointer offset to the current value as indicated
> by the device. The disk zone write plug work is scheduled whenever a BIO
> flagged with BIO_ZONE_WRITE_PLUGGING completes with an error or when
> bio_zone_wplug_prepare_bio() detects an unaligned write. Once scheduled,
> the disk zone write plugs work keeps running until all zone errors are
> handled.
> 
> The block layer internal inline helper function bio_is_zone_append() is
> added to test if a BIO is either a native zone append operation
> (REQ_OP_ZONE_APPEND operation code) or if it is flagged with
> BIO_EMULATES_ZONE_APPEND. Given that both native and emulated zone
> append BIO completion handling should be similar, The functions
> blk_update_request() and blk_zone_complete_request_bio() are modified to
> use bio_is_zone_append() to execute blk_zone_complete_request_bio() for
> both native and emulated zone append operations.
> 
> This commit contains contributions from Christoph Hellwig <hch@lst.de>.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   block/blk-mq.c            |   2 +-
>   block/blk-zoned.c         | 457 ++++++++++++++++++++++++++++++++++++--
>   block/blk.h               |  14 +-
>   include/linux/blk_types.h |   1 +
>   include/linux/blkdev.h    |   3 +
>   5 files changed, 452 insertions(+), 25 deletions(-)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index aa49bebf1199..a112298a6541 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -909,7 +909,7 @@ bool blk_update_request(struct request *req, blk_status_t error,
>   
>   		if (bio_bytes == bio->bi_iter.bi_size) {
>   			req->bio = bio->bi_next;
> -		} else if (req_op(req) == REQ_OP_ZONE_APPEND) {
> +		} else if (bio_is_zone_append(bio)) {
>   			/*
>   			 * Partial zone append completions cannot be supported
>   			 * as the BIO fragments may end up not being written
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 661ef61ca3b1..929c28796c41 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -42,6 +42,8 @@ struct blk_zone_wplug {
>   	unsigned int		flags;
>   	struct bio_list		bio_list;
>   	struct work_struct	bio_work;
> +	unsigned int		wp_offset;
> +	unsigned int		capacity;
>   };
>   
>   /*
> @@ -51,9 +53,12 @@ struct blk_zone_wplug {
>    *  - BLK_ZONE_WPLUG_PLUGGED: Indicate that the zone write plug is plugged,
>    *    that is, that write BIOs are being throttled due to a write BIO already
>    *    being executed or the zone write plug bio list is not empty.
> + *  - BLK_ZONE_WPLUG_ERROR: Indicate that a write error happened which will be
> + *    recovered with a report zone to update the zone write pointer offset.
>    */
>   #define BLK_ZONE_WPLUG_CONV	(1U << 0)
>   #define BLK_ZONE_WPLUG_PLUGGED	(1U << 1)
> +#define BLK_ZONE_WPLUG_ERROR	(1U << 2)
>   
>   /**
>    * blk_zone_cond_str - Return string XXX in BLK_ZONE_COND_XXX.
> @@ -480,6 +485,28 @@ static int blk_zone_wplug_abort(struct gendisk *disk,
>   	return nr_aborted;
>   }
>   
> +static void blk_zone_wplug_abort_unaligned(struct gendisk *disk,
> +					   struct blk_zone_wplug *zwplug)
> +{
> +	unsigned int wp_offset = zwplug->wp_offset;
> +	struct bio_list bl = BIO_EMPTY_LIST;
> +	struct bio *bio;
> +
> +	while ((bio = bio_list_pop(&zwplug->bio_list))) {
> +		if (wp_offset >= zwplug->capacity ||
> +		    (bio_op(bio) != REQ_OP_ZONE_APPEND &&
> +		     bio_offset_from_zone_start(bio) != wp_offset)) {
> +			blk_zone_wplug_bio_io_error(bio);
> +			continue;
> +		}
> +
> +		wp_offset += bio_sectors(bio);
> +		bio_list_add(&bl, bio);
> +	}
> +
> +	bio_list_merge(&zwplug->bio_list, &bl);
> +}
> +
>   /*
>    * Return the zone write plug for sector in sequential write required zone.
>    * Given that conventional zones have no write ordering constraints, NULL is
> @@ -506,6 +533,87 @@ static inline struct blk_zone_wplug *bio_lookup_zone_wplug(struct bio *bio)
>   				      bio->bi_iter.bi_sector);
>   }
>   
> +/*
> + * Set a zone write plug write pointer offset to either 0 (zone reset case)
> + * or to the zone size (zone finish case). This aborts all plugged BIOs, which
> + * is fine to do as doing a zone reset or zone finish while writes are in-flight
> + * is a mistake from the user which will most likely cause all plugged BIOs to
> + * fail anyway.
> + */
> +static void blk_zone_wplug_set_wp_offset(struct gendisk *disk,
> +					 struct blk_zone_wplug *zwplug,
> +					 unsigned int wp_offset)
> +{
> +	/*
> +	 * Updating the write pointer offset puts back the zone
> +	 * in a good state. So clear the error flag and decrement the
> +	 * error count if we were in error state.
> +	 */
> +	if (zwplug->flags & BLK_ZONE_WPLUG_ERROR) {
> +		zwplug->flags &= ~BLK_ZONE_WPLUG_ERROR;
> +		atomic_dec(&disk->zone_nr_wplugs_with_error);
> +	}
> +
> +	/* Update the zone write pointer and abort all plugged BIOs. */
> +	zwplug->wp_offset = wp_offset;
> +	blk_zone_wplug_abort(disk, zwplug);
> +}
> +
> +static bool blk_zone_wplug_handle_reset_or_finish(struct bio *bio,
> +						  unsigned int wp_offset)
> +{
> +	struct blk_zone_wplug *zwplug = bio_lookup_zone_wplug(bio);
> +	unsigned long flags;
> +
> +	/* Conventional zones cannot be reset nor finished. */
> +	if (!zwplug) {
> +		bio_io_error(bio);
> +		return true;
> +	}
> +
> +	if (!bdev_emulates_zone_append(bio->bi_bdev))
> +		return false;
> +
> +	/*
> +	 * Set the zone write pointer offset to 0 (reset case) or to the
> +	 * zone size (finish case). This will abort all BIOs plugged for the
> +	 * target zone. It is fine as resetting or finishing zones while writes
> +	 * are still in-flight will result in the writes failing anyway.
> +	 */
> +	blk_zone_wplug_lock(zwplug, flags);
> +	blk_zone_wplug_set_wp_offset(bio->bi_bdev->bd_disk, zwplug, wp_offset);
> +	blk_zone_wplug_unlock(zwplug, flags);
> +
> +	return false;
> +}
> +
> +static bool blk_zone_wplug_handle_reset_all(struct bio *bio)
> +{
> +	struct gendisk *disk = bio->bi_bdev->bd_disk;
> +	struct blk_zone_wplug *zwplug = &disk->zone_wplugs[0];
> +	unsigned long flags;
> +	unsigned int i;
> +
> +	if (!bdev_emulates_zone_append(bio->bi_bdev))
> +		return false;
> +
> +	/*
> +	 * Set the write pointer offset of all zones to 0. This will abort all
> +	 * plugged BIOs. It is fine as resetting zones while writes are still
> +	 * in-flight will result in the writes failing anyway..
> +	 */
> +	for (i = 0; i < disk->nr_zones; i++, zwplug++) {
> +		/* Ignore conventional zones. */
> +		if (zwplug->flags & BLK_ZONE_WPLUG_CONV)
> +			continue;
> +		blk_zone_wplug_lock(zwplug, flags);
> +		blk_zone_wplug_set_wp_offset(disk, zwplug, 0);
> +		blk_zone_wplug_unlock(zwplug, flags);
> +	}
> +
> +	return false;
> +}
> +
>   static inline void blk_zone_wplug_add_bio(struct blk_zone_wplug *zwplug,
>   					  struct bio *bio, unsigned int nr_segs)
>   {
> @@ -543,7 +651,26 @@ static inline void blk_zone_wplug_add_bio(struct blk_zone_wplug *zwplug,
>    */
>   void blk_zone_write_plug_bio_merged(struct bio *bio)
>   {
> +	struct blk_zone_wplug *zwplug = bio_lookup_zone_wplug(bio);
> +	unsigned long flags;
> +
> +	/*
> +	 * If the BIO was already plugged, then this we were called through
> +	 * blk_zone_write_plug_attempt_merge() -> blk_attempt_bio_merge().
> +	 * For this case, blk_zone_write_plug_attempt_merge() will handle the
> +	 * zone write pointer offset update.
> +	 */
> +	if (bio_flagged(bio, BIO_ZONE_WRITE_PLUGGING))
> +		return;
> +
> +	blk_zone_wplug_lock(zwplug, flags);
> +
>   	bio_set_flag(bio, BIO_ZONE_WRITE_PLUGGING);
> +
> +	/* Advance the zone write pointer offset. */
> +	zwplug->wp_offset += bio_sectors(bio);
> +
> +	blk_zone_wplug_unlock(zwplug, flags);
>   }
>   
>   /*
> @@ -572,7 +699,8 @@ void blk_zone_write_plug_attempt_merge(struct request *req)
>   	 * into the back of the request.
>   	 */
>   	blk_zone_wplug_lock(zwplug, flags);
> -	while ((bio = bio_list_peek(&zwplug->bio_list))) {
> +	while (zwplug->wp_offset < zwplug->capacity &&
> +	       (bio = bio_list_peek(&zwplug->bio_list))) {
>   		if (bio->bi_iter.bi_sector != req_back_sector ||
>   		    !blk_rq_merge_ok(req, bio))
>   			break;
> @@ -589,15 +717,86 @@ void blk_zone_write_plug_attempt_merge(struct request *req)
>   
>   		/*
>   		 * Drop the extra reference on the queue usage we got when
> -		 * plugging the BIO.
> +		 * plugging the BIO and advance the write pointer offset.
>   		 */
>   		blk_queue_exit(q);
> +		zwplug->wp_offset += bio_sectors(bio);
>   
>   		req_back_sector += bio_sectors(bio);
>   	}
>   	blk_zone_wplug_unlock(zwplug, flags);
>   }
>   
> +static inline void blk_zone_wplug_set_error(struct gendisk *disk,
> +					    struct blk_zone_wplug *zwplug)
> +{
> +	if (!(zwplug->flags & BLK_ZONE_WPLUG_ERROR)) {
> +		zwplug->flags |= BLK_ZONE_WPLUG_ERROR;
> +		atomic_inc(&disk->zone_nr_wplugs_with_error);
> +	}
> +}
> +
> +/*
> + * Prepare a zone write bio for submission by incrementing the write pointer and
> + * setting up the zone append emulation if needed.
> + */
> +static bool blk_zone_wplug_prepare_bio(struct blk_zone_wplug *zwplug,
> +				       struct bio *bio)
> +{
> +	/*
> +	 * If we do not need to emulate zone append, zone write pointer offset
> +	 * tracking is not necessary and we have nothing to do.
> +	 */
> +	if (!bdev_emulates_zone_append(bio->bi_bdev))
> +		return true;
> +
> +	/*
> +	 * Check that the user is not attempting to write to a full zone.
> +	 * We know such BIO will fail, and that would potentially overflow our
> +	 * write pointer offset, causing zone append BIOs for one zone to be
> +	 * directed at the following zone.
> +	 */
> +	if (zwplug->wp_offset >= zwplug->capacity)
> +		goto err;
> +
> +	if (bio_op(bio) == REQ_OP_ZONE_APPEND) {
> +		/*
> +		 * Use a regular write starting at the current write pointer.
> +		 * Similarly to native zone append operations, do not allow
> +		 * merging.
> +		 */
> +		bio->bi_opf &= ~REQ_OP_MASK;
> +		bio->bi_opf |= REQ_OP_WRITE | REQ_NOMERGE;
> +		bio->bi_iter.bi_sector += zwplug->wp_offset;
> +
> +		/*
> +		 * Remember that this BIO is in fact a zone append operation
> +		 * so that we can restore its operation code on completion.
> +		 */
> +		bio_set_flag(bio, BIO_EMULATES_ZONE_APPEND);
> +	} else {
> +		/*
> +		 * Check for non-sequential writes early because we avoid a
> +		 * whole lot of error handling trouble if we don't send it off
> +		 * to the driver.
> +		 */
> +		if (bio_offset_from_zone_start(bio) != zwplug->wp_offset)
> +			goto err;
> +	}
> +
> +	/* Advance the zone write pointer offset. */
> +	zwplug->wp_offset += bio_sectors(bio);
> +
> +	return true;
> +
> +err:
> +	/* We detected an invalid write BIO: schedule error recovery. */
> +	blk_zone_wplug_set_error(bio->bi_bdev->bd_disk, zwplug);
> +	kblockd_mod_delayed_work_on(WORK_CPU_UNBOUND,
> +				&bio->bi_bdev->bd_disk->zone_wplugs_work, 0);
> +	return false;
> +}
> +
>   static bool blk_zone_wplug_handle_write(struct bio *bio, unsigned int nr_segs)
>   {
>   	struct blk_zone_wplug *zwplug;
> @@ -617,8 +816,17 @@ static bool blk_zone_wplug_handle_write(struct bio *bio, unsigned int nr_segs)
>   	}
>   
>   	zwplug = bio_lookup_zone_wplug(bio);
> -	if (!zwplug)
> +	if (!zwplug) {
> +		/*
> +		 * Zone append operations to conventional zones are not
> +		 * allowed.
> +		 */
> +		if (bio_op(bio) == REQ_OP_ZONE_APPEND) {
> +			bio_io_error(bio);
> +			return true;
> +		}
>   		return false;
> +	}
>   
>   	blk_zone_wplug_lock(zwplug, flags);
>   
> @@ -626,34 +834,48 @@ static bool blk_zone_wplug_handle_write(struct bio *bio, unsigned int nr_segs)
>   	bio_set_flag(bio, BIO_ZONE_WRITE_PLUGGING);
>   
>   	/*
> -	 * If the zone is already plugged, add the BIO to the plug BIO list.
> -	 * Otherwise, plug and let the BIO execute.
> +	 * If the zone is already plugged or has a pending error, add the BIO
> +	 * to the plug BIO list. Otherwise, plug and let the BIO execute.
>   	 */
> -	if (zwplug->flags & BLK_ZONE_WPLUG_PLUGGED) {
> -		blk_zone_wplug_add_bio(zwplug, bio, nr_segs);
> -		blk_zone_wplug_unlock(zwplug, flags);
> -		return true;
> -	}
> +	if (zwplug->flags & (BLK_ZONE_WPLUG_PLUGGED | BLK_ZONE_WPLUG_ERROR))
> +		goto plug;
> +
> +	/*
> +	 * If an error is detected when preparing the BIO, add it to the BIO
> +	 * list so that error recovery can deal with it.
> +	 */
> +	if (!blk_zone_wplug_prepare_bio(zwplug, bio))
> +		goto plug;
>   
>   	zwplug->flags |= BLK_ZONE_WPLUG_PLUGGED;
>   
>   	blk_zone_wplug_unlock(zwplug, flags);
>   
>   	return false;
> +
> +plug:
> +	zwplug->flags |= BLK_ZONE_WPLUG_PLUGGED;
> +	blk_zone_wplug_add_bio(zwplug, bio, nr_segs);
> +
> +	blk_zone_wplug_unlock(zwplug, flags);
> +
> +	return true;
>   }
>   
>   /**
>    * blk_zone_write_plug_bio - Handle a zone write BIO with zone write plugging
>    * @bio: The BIO being submitted
>    *
> - * Handle write and write zeroes operations using zone write plugging.
> - * Return true whenever @bio execution needs to be delayed through the zone
> - * write plug. Otherwise, return false to let the submission path process
> - * @bio normally.
> + * Handle write, write zeroes and zone append operations requiring emulation
> + * using zone write plugging. Return true whenever @bio execution needs to be
> + * delayed through the zone write plug. Otherwise, return false to let the
> + * submission path process @bio normally.
>    */
>   bool blk_zone_write_plug_bio(struct bio *bio, unsigned int nr_segs)
>   {
> -	if (!bio->bi_bdev->bd_disk->zone_wplugs)
> +	struct block_device *bdev = bio->bi_bdev;
> +
> +	if (!bdev->bd_disk->zone_wplugs)
>   		return false;
>   
>   	/*
> @@ -682,11 +904,30 @@ bool blk_zone_write_plug_bio(struct bio *bio, unsigned int nr_segs)
>   	 * machinery operates at the request level, below the plug, and
>   	 * completion of the flush sequence will go through the regular BIO
>   	 * completion, which will handle zone write plugging.
> +	 * Zone append operations that need emulation must also be plugged so
> +	 * that these operations can be changed into regular writes.
> +	 * Zone reset, reset all and finish commands need special treatment
> +	 * to correctly track the write pointer offset of zones when zone
> +	 * append emulation is needed. These commands are not plugged as we do
> +	 * not need serialization with write and append operations. It is the
> +	 * responsibility of the user to not issue reset and finish commands
> +	 * when write operations are in flight.
>   	 */
>   	switch (bio_op(bio)) {
> +	case REQ_OP_ZONE_APPEND:
> +		if (!bdev_emulates_zone_append(bdev))
> +			return false;
> +		fallthrough;
>   	case REQ_OP_WRITE:
>   	case REQ_OP_WRITE_ZEROES:
>   		return blk_zone_wplug_handle_write(bio, nr_segs);
> +	case REQ_OP_ZONE_RESET:
> +		return blk_zone_wplug_handle_reset_or_finish(bio, 0);
> +	case REQ_OP_ZONE_FINISH:
> +		return blk_zone_wplug_handle_reset_or_finish(bio,
> +						bdev_zone_sectors(bdev));
> +	case REQ_OP_ZONE_RESET_ALL:
> +		return blk_zone_wplug_handle_reset_all(bio);
>   	default:
>   		return false;
>   	}
> @@ -695,12 +936,24 @@ bool blk_zone_write_plug_bio(struct bio *bio, unsigned int nr_segs)
>   }
>   EXPORT_SYMBOL_GPL(blk_zone_write_plug_bio);
>   
> -static void blk_zone_write_plug_unplug_bio(struct blk_zone_wplug *zwplug)
> +static void blk_zone_write_plug_unplug_bio(struct gendisk *disk,
> +					   struct blk_zone_wplug *zwplug)
>   {
>   	unsigned long flags;
>   
>   	blk_zone_wplug_lock(zwplug, flags);
>   
> +	/*
> +	 * If we had an error, schedule error recovery. The recovery work
> +	 * will restart submission of plugged BIOs.
> +	 */
> +	if (zwplug->flags & BLK_ZONE_WPLUG_ERROR) {
> +		blk_zone_wplug_unlock(zwplug, flags);
> +		kblockd_mod_delayed_work_on(WORK_CPU_UNBOUND,
> +					    &disk->zone_wplugs_work, 0);
> +		return;
> +	}
> +
>   	/* Schedule submission of the next plugged BIO if we have one. */
>   	if (!bio_list_empty(&zwplug->bio_list))
>   		kblockd_schedule_work(&zwplug->bio_work);
> @@ -712,19 +965,35 @@ static void blk_zone_write_plug_unplug_bio(struct blk_zone_wplug *zwplug)
>   
>   void blk_zone_write_plug_bio_endio(struct bio *bio)
>   {
> +	struct gendisk *disk = bio->bi_bdev->bd_disk;
> +	struct blk_zone_wplug *zwplug = bio_lookup_zone_wplug(bio);
> +
>   	/* Make sure we do not see this BIO again by clearing the plug flag. */
>   	bio_clear_flag(bio, BIO_ZONE_WRITE_PLUGGING);
>   
> +	/*
> +	 * If this is a regular write emulating a zone append operation,
> +	 * restore the original operation code.
> +	 */
> +	if (bio_flagged(bio, BIO_EMULATES_ZONE_APPEND)) {
> +		bio->bi_opf &= ~REQ_OP_MASK;
> +		bio->bi_opf |= REQ_OP_ZONE_APPEND;
> +	}
> +
> +	/*
> +	 * If the BIO failed, mark the plug as having an error to trigger
> +	 * recovery.
> +	 */
> +	if (bio->bi_status != BLK_STS_OK)
> +		blk_zone_wplug_set_error(disk, zwplug);
> +
>   	/*
>   	 * For BIO-based devices, blk_zone_write_plug_complete_request()
>   	 * is not called. So we need to schedule execution of the next
>   	 * plugged BIO here.
>   	 */
> -	if (bio->bi_bdev->bd_has_submit_bio) {
> -		struct blk_zone_wplug *zwplug = bio_lookup_zone_wplug(bio);
> -
> -		blk_zone_write_plug_unplug_bio(zwplug);
> -	}
> +	if (bio->bi_bdev->bd_has_submit_bio)
> +		blk_zone_write_plug_unplug_bio(disk, zwplug);
>   }
>   
>   void blk_zone_write_plug_complete_request(struct request *req)
> @@ -735,7 +1004,7 @@ void blk_zone_write_plug_complete_request(struct request *req)
>   
>   	req->rq_flags &= ~RQF_ZONE_WRITE_PLUGGING;
>   
> -	blk_zone_write_plug_unplug_bio(zwplug);
> +	blk_zone_write_plug_unplug_bio(disk, zwplug);
>   }
>   
>   static void blk_zone_wplug_bio_work(struct work_struct *work)
> @@ -758,6 +1027,13 @@ static void blk_zone_wplug_bio_work(struct work_struct *work)
>   		return;
>   	}
>   
> +	if (!blk_zone_wplug_prepare_bio(zwplug, bio)) {
> +		/* Error recovery will decide what to do with the BIO. */
> +		bio_list_add_head(&zwplug->bio_list, bio);
> +		blk_zone_wplug_unlock(zwplug, flags);
> +		return;
> +	}
> +
>   	blk_zone_wplug_unlock(zwplug, flags);
>   
>   	/*
> @@ -771,6 +1047,120 @@ static void blk_zone_wplug_bio_work(struct work_struct *work)
>   	submit_bio_noacct_nocheck(bio);
>   }
>   
> +static unsigned int blk_zone_wp_offset(struct blk_zone *zone)
> +{
> +	switch (zone->cond) {
> +	case BLK_ZONE_COND_IMP_OPEN:
> +	case BLK_ZONE_COND_EXP_OPEN:
> +	case BLK_ZONE_COND_CLOSED:
> +		return zone->wp - zone->start;
> +	case BLK_ZONE_COND_FULL:
> +		return zone->len;
> +	case BLK_ZONE_COND_EMPTY:
> +		return 0;
> +	case BLK_ZONE_COND_NOT_WP:
> +	case BLK_ZONE_COND_OFFLINE:
> +	case BLK_ZONE_COND_READONLY:
> +	default:
> +		/*
> +		 * Conventional, offline and read-only zones do not have a valid
> +		 * write pointer.
> +		 */
> +		return UINT_MAX;
> +	}
> +}
> +
> +static int blk_zone_wplug_get_zone_cb(struct blk_zone *zone,
> +				      unsigned int idx, void *data)
> +{
> +	struct blk_zone *zonep = data;
> +
> +	*zonep = *zone;
> +	return 0;
> +}
> +
> +static void blk_zone_wplug_handle_error(struct gendisk *disk,
> +					struct blk_zone_wplug *zwplug)
> +{
> +	unsigned int zno = zwplug - disk->zone_wplugs;
> +	sector_t zone_start_sector = bdev_zone_sectors(disk->part0) * zno;
> +	unsigned int noio_flag;
> +	struct blk_zone zone;
> +	unsigned long flags;
> +	int ret;
> +
> +	/* Check if we have an error and clear it if we do. */
> +	blk_zone_wplug_lock(zwplug, flags);
> +	if (!(zwplug->flags & BLK_ZONE_WPLUG_ERROR))
> +		goto unlock;
> +	zwplug->flags &= ~BLK_ZONE_WPLUG_ERROR;
> +	atomic_dec(&disk->zone_nr_wplugs_with_error);
> +	blk_zone_wplug_unlock(zwplug, flags);
> +

Don't you need to quiesce the drive here?
After all, I/O (or a reset zone) might be executed after the call to 
report zones, but before we lock the zone, no?

> +	/* Get the current zone information from the device. */
> +	noio_flag = memalloc_noio_save();
> +	ret = disk->fops->report_zones(disk, zone_start_sector, 1,
> +				       blk_zone_wplug_get_zone_cb, &zone);
> +	memalloc_noio_restore(noio_flag);
> +
> +	blk_zone_wplug_lock(zwplug, flags);
> +
> +	if (ret != 1) {
> +		/*
> +		 * We failed to get the zone information, likely meaning that
> +		 * something is really wrong with the device. Abort all
> +		 * remaining plugged BIOs as otherwise we could endup waiting
> +		 * forever on plugged BIOs to complete if there is a revalidate
> +		 * or queue freeze on-going.
> +		 */
> +		blk_zone_wplug_abort(disk, zwplug);
> +		goto unplug;
> +	}
> +
> +	/* Update the zone capacity and write pointer offset. */
> +	zwplug->wp_offset = blk_zone_wp_offset(&zone);
> +	zwplug->capacity = zone.capacity;
> +
> +	blk_zone_wplug_abort_unaligned(disk, zwplug);
> +
> +	/* Restart BIO submission if we still have any BIO left. */
> +	if (!bio_list_empty(&zwplug->bio_list)) {
> +		WARN_ON_ONCE(!(zwplug->flags & BLK_ZONE_WPLUG_PLUGGED));
> +		kblockd_schedule_work(&zwplug->bio_work);
> +		goto unlock;
> +	}
> +
> +unplug:
> +	zwplug->flags &= ~BLK_ZONE_WPLUG_PLUGGED;
> +
> +unlock:
> +	blk_zone_wplug_unlock(zwplug, flags);
> +}
> +
> +static void disk_zone_wplugs_work(struct work_struct *work)
> +{
> +	struct gendisk *disk =
> +		container_of(work, struct gendisk, zone_wplugs_work.work);
> +	struct blk_zone_wplug *zwplug;
> +	unsigned int i;
> +
> +	while (atomic_read(&disk->zone_nr_wplugs_with_error)) {
> +		/* Serialize against revalidate. */
> +		mutex_lock(&disk->zone_wplugs_mutex);
> +
> +		zwplug = disk->zone_wplugs;
> +		if (!zwplug) {
> +			mutex_unlock(&disk->zone_wplugs_mutex);
> +			return;
> +		}
> +
> +		for (i = 0; i < disk->nr_zones; i++, zwplug++)
> +			blk_zone_wplug_handle_error(disk, zwplug);
> +
> +		mutex_unlock(&disk->zone_wplugs_mutex);
> +	}
> +}
> +
>   static struct blk_zone_wplug *blk_zone_alloc_write_plugs(unsigned int nr_zones)
>   {
>   	struct blk_zone_wplug *zwplugs;
> @@ -794,6 +1184,7 @@ static void blk_zone_free_write_plugs(struct gendisk *disk,
>   				      unsigned int nr_zones)
>   {
>   	struct blk_zone_wplug *zwplug = zwplugs;
> +	unsigned long flags;
>   	unsigned int i, n;
>   
>   	if (!zwplug)
> @@ -801,7 +1192,13 @@ static void blk_zone_free_write_plugs(struct gendisk *disk,
>   
>   	/* Make sure we do not leak any plugged BIO. */
>   	for (i = 0; i < nr_zones; i++, zwplug++) {
> +		blk_zone_wplug_lock(zwplug, flags);
> +		if (zwplug->flags & BLK_ZONE_WPLUG_ERROR) {
> +			atomic_dec(&disk->zone_nr_wplugs_with_error);
> +			zwplug->flags &= ~BLK_ZONE_WPLUG_ERROR;
> +		}
>   		n = blk_zone_wplug_abort(disk, zwplug);
> +		blk_zone_wplug_unlock(zwplug, flags);
>   		if (n)
>   			pr_warn_ratelimited("%s: zone %u, %u plugged BIOs aborted\n",
>   					    disk->disk_name, i, n);
> @@ -812,6 +1209,9 @@ static void blk_zone_free_write_plugs(struct gendisk *disk,
>   
>   void disk_free_zone_resources(struct gendisk *disk)
>   {
> +	if (disk->zone_wplugs)
> +		cancel_delayed_work_sync(&disk->zone_wplugs_work);
> +
>   	kfree(disk->conv_zones_bitmap);
>   	disk->conv_zones_bitmap = NULL;
>   	kfree(disk->seq_zones_wlock);
> @@ -819,6 +1219,8 @@ void disk_free_zone_resources(struct gendisk *disk)
>   
>   	blk_zone_free_write_plugs(disk, disk->zone_wplugs, disk->nr_zones);
>   	disk->zone_wplugs = NULL;
> +
> +	mutex_destroy(&disk->zone_wplugs_mutex);
>   }
>   
>   struct blk_revalidate_zone_args {
> @@ -890,6 +1292,8 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
>   			if (!args->seq_zones_wlock)
>   				return -ENOMEM;
>   		}
> +		args->zone_wplugs[idx].capacity = zone->capacity;
> +		args->zone_wplugs[idx].wp_offset = blk_zone_wp_offset(zone);
>   		break;
>   	case BLK_ZONE_TYPE_SEQWRITE_PREF:
>   	default:
> @@ -964,6 +1368,13 @@ int blk_revalidate_disk_zones(struct gendisk *disk,
>   	if (!args.zone_wplugs)
>   		goto out_restore_noio;
>   
> +	if (!disk->zone_wplugs) {
> +		mutex_init(&disk->zone_wplugs_mutex);
> +		atomic_set(&disk->zone_nr_wplugs_with_error, 0);
> +		INIT_DELAYED_WORK(&disk->zone_wplugs_work,
> +				  disk_zone_wplugs_work);
> +	}
> +

Same question here about device quiesce ...

>   	ret = disk->fops->report_zones(disk, 0, UINT_MAX,
>   				       blk_revalidate_zone_cb, &args);
>   	if (!ret) {
> @@ -989,12 +1400,14 @@ int blk_revalidate_disk_zones(struct gendisk *disk,
>   	 */
>   	blk_mq_freeze_queue(q);

And this, I guess, comes to late.
We've already read the zone list, so any write I/O submitted after the 
report zone but befor here will cause things to be iffy.

>   	if (ret > 0) {
> +		mutex_lock(&disk->zone_wplugs_mutex);
>   		disk->nr_zones = args.nr_zones;
>   		swap(disk->seq_zones_wlock, args.seq_zones_wlock);
>   		swap(disk->conv_zones_bitmap, args.conv_zones_bitmap);
>   		swap(disk->zone_wplugs, args.zone_wplugs);
>   		if (update_driver_data)
>   			update_driver_data(disk);
> +		mutex_unlock(&disk->zone_wplugs_mutex);
>   		ret = 0;
>   	} else {
>   		pr_warn("%s: failed to revalidate zones\n", disk->disk_name);
> diff --git a/block/blk.h b/block/blk.h
> index d0ecd5a2002c..7fbef6bb1aee 100644
> --- a/block/blk.h
> +++ b/block/blk.h
> @@ -408,6 +408,11 @@ static inline bool bio_zone_write_plugging(struct bio *bio)
>   {
>   	return bio_flagged(bio, BIO_ZONE_WRITE_PLUGGING);
>   }
> +static inline bool bio_is_zone_append(struct bio *bio)
> +{
> +	return bio_op(bio) == REQ_OP_ZONE_APPEND ||
> +		bio_flagged(bio, BIO_EMULATES_ZONE_APPEND);
> +}
>   void blk_zone_write_plug_bio_merged(struct bio *bio);
>   void blk_zone_write_plug_attempt_merge(struct request *rq);
>   static inline void blk_zone_complete_request_bio(struct request *rq,
> @@ -417,8 +422,9 @@ static inline void blk_zone_complete_request_bio(struct request *rq,
>   	 * For zone append requests, the request sector indicates the location
>   	 * at which the BIO data was written. Return this value to the BIO
>   	 * issuer through the BIO iter sector.
> -	 * For plugged zone writes, we need the original BIO sector so
> -	 * that blk_zone_write_plug_bio_endio() can lookup the zone write plug.
> +	 * For plugged zone writes, which include emulated zone append, we need
> +	 * the original BIO sector so that blk_zone_write_plug_bio_endio() can
> +	 * lookup the zone write plug.
>   	 */
>   	if (req_op(rq) == REQ_OP_ZONE_APPEND || bio_zone_write_plugging(bio))
>   		bio->bi_iter.bi_sector = rq->__sector;
> @@ -437,6 +443,10 @@ static inline bool bio_zone_write_plugging(struct bio *bio)
>   {
>   	return false;
>   }
> +static inline bool bio_is_zone_append(struct bio *bio)
> +{
> +	return false;
> +}
>   static inline void blk_zone_write_plug_bio_merged(struct bio *bio)
>   {
>   }
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 19839d303289..5c5343099800 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -309,6 +309,7 @@ enum {
>   	BIO_REMAPPED,
>   	BIO_ZONE_WRITE_LOCKED,	/* Owns a zoned device zone write lock */
>   	BIO_ZONE_WRITE_PLUGGING, /* bio handled through zone write plugging */
> +	BIO_EMULATES_ZONE_APPEND, /* bio emulates a zone append operation */
>   	BIO_FLAG_LAST
>   };
>   
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 87fba5af34ba..e619e10847bd 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -195,6 +195,9 @@ struct gendisk {
>   	unsigned long		*conv_zones_bitmap;
>   	unsigned long		*seq_zones_wlock;
>   	struct blk_zone_wplug	*zone_wplugs;
> +	struct mutex		zone_wplugs_mutex;
> +	atomic_t		zone_nr_wplugs_with_error;
> +	struct delayed_work	zone_wplugs_work;
>   #endif /* CONFIG_BLK_DEV_ZONED */
>   
>   #if IS_ENABLED(CONFIG_CDROM)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Ivo Totev, Andrew McDonald,
Werner Knoblich

