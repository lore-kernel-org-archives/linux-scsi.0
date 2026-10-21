Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792575770;
	b=0C0hI2Ch0XIgaYnkEHYxSqDqOytpzfMudgvoxsLL6En8qXcrJNT9jy2dlnG2z4y0eBVZ
	 6E2W0N0/mg+TrIYcxAeqzBc49yxlJWNtCxnpfJOCWD9b8/+z082YfouQ+hPzYsG97SLti
	 JnsvIJjfsXR3GeDG6hfVcGaDB1K9fTzYVRzN+NDArpmbvAMtPdL8ECpNz6RF23+LiihlF
	 tQr0YOOZ9nlMHcIOjOzjDCvfdi/cBNnjI7Ras5HZOXBhyzSKlZe1tCczPxmpDdiQTePqG
	 O426YMbZcS07TXehmheVGy8LWCd/lRkSyOaQO8fGnyFMcTrsEcty5hyWuROV/8TJ0VA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792575770;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spamd-Result:X-Spam-Score:
	 X-Spam-Level:X-Spam-Flag;
	bh=aa94jSFYIqH+zbCG3j5JRfDy6NWYVJcC8KlgrdolKjM=;
	b=yTS6DUbXgrXyrj/4hDDExOL1EvHHFAELvtNMOSkbZ2gkwJRy8WpZ4qmg3dNEuoCt4YNm
	 sFvXkngJYERw2iS7upZYsJ7G3+Fysw33FtAakKsvmz3xo8rHXntPMbhLTnFPMwwuxdX99
	 voi0nXl5KyA72A9OUdU/hLXKySyVss6z4SvheBBYUI3kBIIc8htXKuzU1OzFaEa4hUHOb
	 mDe/stkacHWHwj9VWdQuoVnzwJ5fQDoqBPIYqF2f6qxJolHoSixfF/gNM8WBwFkzvbiyj
	 oRmjEoOca0lsZ10Mmqgs2bei8M4+tP1JRlwk4oinVM8q3Pc8LcCJhOgVql75KRHDGNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=jPwb3TF5;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ebXQzDQ7;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b="zCP26Z/V";
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=bk62MuyB;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97AB0606A319;
	Wed, 21 Oct 2026 09:42:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 97AB0606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=jPwb3TF5;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ebXQzDQ7;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=zCP26Z/V;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=bk62MuyB
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EE1621F749;
	Wed, 21 Oct 2026 09:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792575768; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aa94jSFYIqH+zbCG3j5JRfDy6NWYVJcC8KlgrdolKjM=;
	b=jPwb3TF5cUpje6KRioZHOe810516iWDaUv1VfRF6wqG+o4oh4vLRoypJnNnb/E7HGtOcOQ
	kwOsl2O4ujgOH9aPJd5lfsE7lAhNdAmHxW9Fp/de0Waw7wr+onigsDpOdmXgiEItEO7mUK
	Pxlsd2DHEnGchdKZvVm6s3mvtxWIhK0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792575768;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aa94jSFYIqH+zbCG3j5JRfDy6NWYVJcC8KlgrdolKjM=;
	b=ebXQzDQ7VoDka2YUcVAarD4Iivw3JIBDD641PV5aCnCrpkanFKqUahk/t1zOk4efrFHd6h
	ShscUJhaxxfyFQAw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792575767; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aa94jSFYIqH+zbCG3j5JRfDy6NWYVJcC8KlgrdolKjM=;
	b=zCP26Z/VHLrzpAaMZ1kyY/K473h6sy9cJty4oULcdgqgJtmEl4fU7cXmvjaeH+WPoGESWC
	WqRwFaEAEAYJLENvuzuAWN5UoZegrMAxk+UpxMFexquEuK/EHvTDyiY8+RAXJQEJnxsYWc
	ssyHfwWqQ+IzYfC9cYYQd3+219a/BbY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792575767;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aa94jSFYIqH+zbCG3j5JRfDy6NWYVJcC8KlgrdolKjM=;
	b=bk62MuyBOHpxXzeI55ZtfgyRYKz9YPYUSakERbAMsv1R1gj75fZht3GRqoWK+KGhYf8Add
	IK7q273ATyV//3AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BBFE6134FD;
	Wed, 21 Oct 2026 09:42:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id M59VJReJ2GqgIwAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 21 Oct 2026 09:42:47 +0000
Message-ID: <0746196e-d95f-4d5e-ab44-507d7035fd37@suse.de>
Date: Wed, 21 Oct 2026 11:42:47 +0200
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
Subject: Re: [PATCH v6 03/10] block: introduce storage element management
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20261013122750.2237843-1-dlemoal@kernel.org>
 <20261013122750.2237843-4-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261013122750.2237843-4-dlemoal@kernel.org>
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
> Recent SCSI (SBC) and ATA (ACS) standards define the storage element
> depopulation feature. This feature is intended for managing hard-disks
> heads, either combined read-write heads or pairs of read and write heads,
> allowing to keep disks with defective heads longer in production by
> allowing "depopulating" (removing) defective heads.
> 
> This feature comes in two different flavors:
>   - A destructive version which removes a head and reformats the disk at a
>     lower capacity point, restoaring a fully functional contiguous LBA
>     address space.
>   - A data preserving version restricted to host-managed zoned disks, which
>     marks the zones served by a removed head as offline or read-only.
> 
> In preparation for using the data-preserving flavor of the depopulation
> feature in file systems natively supporting zoned block devices, introduce
> a set of storage element management operations and functions to define
> generic calls into block device drivers for managing storage elements.
> 
> The set of operations is defined with struct blk_se_ops and includes three
> operations:
>   - report_elements: get information on a device storage elements state
>     reported with the new struct blk_se.
>   - remove_element: depopulate a defective storage element
>   - restore_elements: restore depopulated storage elements
> 
> Each operation is called from the functions
> bdev_report_storage_elements(), bdev_remove_storage_element() and
> bdev_restore_storage_elements().
> 
> Removing a healthy storage element from a device is possible and useful
> for testing. The storage element restoration operation restore_elements
> allows repopulating such healthy element. Repopulating defective storage
> elements is generally not allowed by devices. The remove_element and
> restore_elements operations are executed under the zone revalidation lock
> so that they are serialized iand also serialized against user initiated
> device revalidation, thus allowing to always have a consistent view of the
> device zone conditions.
> 
> The device drivers of zoned block devices can indicate support for the
> storage element depopulation feature by specifying the storage element
> management operations with the se_ops field of struct
> block_device_operations.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   block/blk-zoned.c             | 291 +++++++++++++++++++++++++++++++++-
>   block/blk.h                   |   5 +
>   block/genhd.c                 |   4 +
>   include/linux/blkdev.h        |  22 +++
>   include/uapi/linux/blkzoned.h |  62 ++++++++
>   5 files changed, 383 insertions(+), 1 deletion(-)
> 
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index acec8a7e648e..252d12254692 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -18,6 +18,7 @@
>   #include <linux/mempool.h>
>   #include <linux/kthread.h>
>   #include <linux/freezer.h>
> +#include <linux/delay.h>
>   
>   #include <trace/events/block.h>
>   
> @@ -2721,5 +2722,293 @@ int queue_zone_wplugs_show(void *data, struct seq_file *m)
>   
>   	return 0;
>   }
> -
>   #endif
> +
> +static int disk_se_mgmt_in_progress(struct gendisk *disk,
> +				     struct blk_se *elements,
> +				     bool *in_progress)
> +{
> +	unsigned int i, nr_se = disk->nr_storage_elements;
> +	int ret;
> +
> +	/*
> +	 * Check if we have storage elements being removed or restored.
> +	 */
> +	ret = disk->fops->se_ops->report_elements(disk, elements, &nr_se);
> +	if (ret) {
> +		pr_err("Failed to get storage elements\n");
> +		return ret;
> +	}
> +
> +	for (i = 0; i < nr_se; i++) {
> +		switch (elements[i].status) {
> +		case BLK_SE_STS_REMOVE_IN_PROGRESS:
> +		case BLK_SE_STS_RESTORE_IN_PROGRESS:
> +			*in_progress = true;
> +			return 0;
> +		default:
> +			break;
> +		}
> +	}
> +
> +	*in_progress = false;
> +
> +	return 0;
> +}
> +
> +static int disk_check_remove_error(struct gendisk *disk,
> +				   struct blk_se *elements,
> +				   unsigned int element_id)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < disk->nr_storage_elements; i++) {
> +		if (elements[i].id == element_id &&
> +		    elements[i].status == BLK_SE_STS_REMOVE_ERROR)
> +			return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static int disk_wait_for_se_mgmt_completion(struct gendisk *disk,
> +					    struct blk_se *elements,
> +					    unsigned int element_id)
> +{
> +	bool in_progress;
> +	int ret;
> +
> +	/*
> +	 * Poll the storage elements heath state to detect the end of a
> +	 * removal or restoration operation. Since we do not know how long the
> +	 * operation may take, we cannot have a timeout on this loop. So check
> +	 * for fatal signals so that the user can terminate this retry loop if
> +	 * the device misbehaves.
> +	 */
> +	while (1) {
> +		ret = disk_se_mgmt_in_progress(disk, elements, &in_progress);
> +		if (ret || !in_progress)
> +			break;
> +
> +		if (fatal_signal_pending(current)) {
> +			ret = -EINTR;
> +			break;
> +		}
> +
> +		/* Not done yet: wait and retry. */
> +		msleep(1000);
> +	}
> +
I always feel a bit uncomfortable having to poll without a dedicated
end time.
Care to add a timeout here to avoid an infinite wait?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
