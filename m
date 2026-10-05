Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89054078E8;
	Mon,  5 Oct 2026 10:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791197592; cv=none; b=crQhfwN2ezCu4nYNDeXXsbEWHphxF2uB5r4dk0c3Up385fVghA3pVWNFKhQyV8rIwwD75JvP9aLMkFJus7zvqvjg0E3XG9NYqnZgivcEb3QSpfHUw0JC6Xa+xA8Fh+3ZON7L3p8kXZk4Xlwg6hc0E7c1hEjfqcoqHl7GHh/Dw7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791197592; c=relaxed/simple;
	bh=h3yJ8754VeatmCKy80bM75+npW6DnBDuW+HVC/9YU3M=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=JNMzOJJeG3QwtRnkGCgizUjDDijdgNGuJgP/6PAvSzjB4MAKMjRmRXeXXosF2+T8/vvGJO3wflSSpnxBvB4LnYN2fv7xl8FvpcVEDqr2+AP0zUtV5M2Si5t+hiDHLoyJUmrSetDwlvWivR6seaz28apmPne41aLLOeC/5EZ3Ij4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=XbypQrsn; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=elyZSkzg; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=euruPDk1; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=+PhXWsoN; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="XbypQrsn";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="elyZSkzg";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="euruPDk1";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="+PhXWsoN"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 62D8D21E8D;
	Mon,  5 Oct 2026 10:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791197584; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=omV0zKFCC//gNzdXX6iEmBgVnfOMppneWSVbNMuHd7E=;
	b=XbypQrsnr4/o97mFj9Xqp95HBnDk5TEJTvhjxa9EzXRwQYxYqC7tFiZ6/Ik1CMOsbnAMC5
	aQEZ4PKsorCQs1SLujEQjmuc5bjw64J4AR07TQmnyO98skzqf2mSEUMDDdcPpC0aNMh1lY
	yyG6/tSEw7ZjIwSQOjoGoaKvWItzOB4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791197584;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=omV0zKFCC//gNzdXX6iEmBgVnfOMppneWSVbNMuHd7E=;
	b=elyZSkzgVNKLQITfahx06kpIWcTqQ7BLhm4tmPX1Ga9hNFqXXiTi8JxNO+KwlPWhbZDjrc
	gkx0E8OOb5wEK0CA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791197580; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=omV0zKFCC//gNzdXX6iEmBgVnfOMppneWSVbNMuHd7E=;
	b=euruPDk1vv6jmpBivd3puffPAcuUjOuoorpNb77yM9cW+F4ZgrFQ4b37jjKsaMNS8QKzOV
	jDhLNycXv0ruSVF205UEZGB5EAXl3AeotgqvodtXJslevszX8RwTQcbMkVi7FvJApF4U9b
	0xq0dsQT88zaIPoAptYCmwAJztnv8sc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791197580;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=omV0zKFCC//gNzdXX6iEmBgVnfOMppneWSVbNMuHd7E=;
	b=+PhXWsoNeH9Gzj6bkkYdmKLxcIkkAmfWBGCpgZobjGbvWzM7HRaW5PRFtHHUxjEtn9hoYq
	w/CUd5wBZ5NYkvCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2FB92132D3;
	Mon,  5 Oct 2026 10:53:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Zq6RM4uBw2pdQQAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 05 Oct 2026 10:53:00 +0000
Message-ID: <631af119-40fb-47c9-8637-41405a1751a0@suse.de>
Date: Mon, 5 Oct 2026 12:52:51 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] block: introduce storage element management
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20261005094632.580753-1-dlemoal@kernel.org>
 <20261005094632.580753-3-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261005094632.580753-3-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,lst.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

On 10/5/26 11:46 AM, Damien Le Moal wrote:
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
> The set of operations is defined with struct blk_storage_elements_ops and
> includes three operations:
>   - report_elements: get information on a device storage elements state
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
> elements is generally not allowed by devices.
> 
> The device drivers of zoned block devices can indicate support for the
> storage element depopulation feature by specifying the storage element
> management operations with the se_ops field of struct
> block_device_operations.
> 
> Co-developed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   block/blk-zoned.c             | 168 +++++++++++++++++++++++++++++++++-
>   include/linux/blkdev.h        |  16 ++++
>   include/uapi/linux/blkzoned.h |  67 ++++++++++++++
>   3 files changed, 250 insertions(+), 1 deletion(-)
> 
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 131c9f50b3da..b713512f7d48 100644
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
> @@ -2718,5 +2719,170 @@ int queue_zone_wplugs_show(void *data, struct seq_file *m)
>   
>   	return 0;
>   }
> -
>   #endif
> +
> +static void disk_wait_for_se_mgmt_completion(struct gendisk *disk)
> +{
> +	struct blk_storage_element *elements, *e;
> +	unsigned int i, nr_se, nr_elements = 0;
> +	int ret;
> +
> +	ret = (disk->fops->se_ops->report_elements)(disk, &nr_elements, NULL);
> +	if (ret) {
> +		pr_err("Failed to get number of storage elements\n");
> +		return;
> +	}
> +
> +	elements = kzalloc_objs(struct blk_storage_element, nr_elements);
> +	if (!elements)
> +		return;
> +
> +	while (1) {
> +		/*
> +		 * Check if we have storage elements being removed or restored.
> +		 */
> +		nr_se = nr_elements;
> +		ret = (disk->fops->se_ops->report_elements)(disk,
> +						&nr_elements, elements);
> +		if (ret) {
> +			pr_err("Failed to get storage elements\n");
> +			break;
> +		}
> +
> +		e = elements;
> +		for (i = 0; i < nr_se; i++, e++) {
> +			if (e->status == BLK_SE_STS_REMOVE_IN_PROGRESS ||
> +			    e->status == BLK_SE_STS_RESTORE_IN_PROGRESS)
> +				break;
> +		}
> +		if (i >= nr_se)
> +			break;
> +
> +		/* Not done yet: wait and retry. */
> +		msleep(500);
> +	}
> +
> +	kfree(elements);
> +}
> +
> +/**
> + * bdev_report_storage_elements - report the storage elements of a block device
> + *
> + * Fill at most @nr_elements storage element descriptors in the array @elements.
> + * The number of storage elements filled in the array is returned using
> + * @nr_elements. If @elements is NULL, only @nr_elements is returned.
> + *
> + * Returns 0 on success and a negative error code on failure.
> + */
> +int bdev_report_storage_elements(struct block_device *bdev,
> +				 unsigned int *nr_elements,
> +				 struct blk_storage_element *elements)
> +{
> +	struct gendisk *disk = bdev->bd_disk;
> +
> +	if (!bdev_is_zoned(bdev) || !disk->fops->se_ops)
> +		return -EOPNOTSUPP;
> +
> +	if (!nr_elements)
> +		return -EINVAL;
> +
> +	if (*nr_elements && !elements)
> +		return -EINVAL;
> +
> +	return (disk->fops->se_ops->report_elements)(disk, nr_elements,
> +						     elements);
> +}
> +EXPORT_SYMBOL_GPL(bdev_report_storage_elements);
> +
> +/**
> + * bdev_remove_storage_element - Remove (depopulate) a storage element of a
> + *				 block device
> + *
> + * Remove (depopulate) the storage element identified by @element_id from the
> + * block device @bdev.
> + *
> + * Returns 0 on success and a negative error code on failure.
> + */
> +int bdev_remove_storage_element(struct block_device *bdev,
> +				unsigned int element_id)
> +{
> +	struct gendisk *disk = bdev->bd_disk;
> +	unsigned int memflags;
> +	int ret;
> +
> +	if (!bdev_is_zoned(bdev) || !disk->fops->se_ops)
> +		return -EOPNOTSUPP;
> +
> +	/* Zero is not a valid storage element ID. */
> +	if (!element_id)
> +		return -EINVAL;
> +
> +	/*
> +	 * Freeze and unfreeze the queue to flush any outstanding command.
> +	 * The caller is responsible for not queuing up more I/Os by higher
> +	 * level means.
> +	 */

The 'caller' is the ioctl, so it can only issue I/O _after_ the ioctl.
Maybe 'user' is a better wording here.

> +	memflags = blk_mq_freeze_queue(disk->queue);
> +	blk_mq_unfreeze_queue(disk->queue, memflags);
> +
> +	/*
> +	 * Flush the volatile write cache if there is any. Note that this may
> +	 * lead to errors if degraded storage elements are used. So ignore
> +	 * errors here.
> +	 */
> +	blkdev_issue_flush(disk->part0);
Do you need a flush here?
I would have thought that the freeze/unfreeze above would take care
of it.
But what do I know.

> +
> +	/* Invalidate all cached data. */
> +	invalidate_inode_pages2_range(bdev->bd_mapping, 0,
> +				      get_capacity(disk) << SECTOR_SHIFT);
> +
> +	ret = (disk->fops->se_ops->remove_element)(disk, element_id);
> +	if (ret)
> +		return ret;
> +
> +	/* Revalidate the device zones once the opration completes. */
> +	disk_wait_for_se_mgmt_completion(disk);
> +
> +	return blk_revalidate_disk_zones(disk);
> +}
> +EXPORT_SYMBOL_GPL(bdev_remove_storage_element);
> +
> +/**
> + * bdev_restore_storage_elements - Restore all depopulated storage elements of a
> + *				   block device
> + *
> + * Restore all storage elements of @bdev that have been depopulated. Not all
> + * elements may be restored by this operation.
> + *
> + * Returns 0 on success and a negative error code on failure.
> + */
> +int bdev_restore_storage_elements(struct block_device *bdev)
> +{
> +	struct gendisk *disk = bdev->bd_disk;
> +	unsigned int memflags;
> +	int ret;
> +
> +	if (!bdev_is_zoned(bdev) || !disk->fops->se_ops)
> +		return -EOPNOTSUPP;
> +
> +	/*
> +	 * Freeze and unfreeze the queue to flush any outstanding commands.
> +	 * The caller is responsible for not queuing up more I/O by higher
> +	 * level means.
> +	 */

See above for 'the caller is responsible'.

> +	memflags = blk_mq_freeze_queue(disk->queue);
> +	blk_mq_unfreeze_queue(disk->queue, memflags);
> +
> +	/* Invalidate all cached data. */
> +	invalidate_inode_pages2_range(bdev->bd_mapping, 0,
> +				      get_capacity(disk) << SECTOR_SHIFT);
> +
> +	ret = (disk->fops->se_ops->restore_elements)(disk);
> +	if (ret)
> +		return ret;
> +
> +	disk_wait_for_se_mgmt_completion(disk);
> +
> +	return blk_revalidate_disk_zones(disk);
> +}
> +EXPORT_SYMBOL_GPL(bdev_restore_storage_elements);
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index d003a9d2d1f6..0b2013c96cad 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1574,6 +1574,21 @@ enum blk_unique_id {
>   	BLK_UID_NAA	= 3,
>   };
>   
> +struct blk_storage_elements_ops {
> +	int (*report_elements)(struct gendisk *disk,
> +			       unsigned int *nr_elements,
> +			       struct blk_storage_element *elements);
> +	int (*remove_element)(struct gendisk *disk, unsigned int element_id);
> +	int (*restore_elements)(struct gendisk *disk);
> +};
> +
> +int bdev_report_storage_elements(struct block_device *bdev,
> +				 unsigned int *nr_elements,
> +				 struct blk_storage_element *elements);
> +int bdev_remove_storage_element(struct block_device *bdev,
> +				unsigned int element_id);
> +int bdev_restore_storage_elements(struct block_device *bdev);
> +
>   struct block_device_operations {
>   	void (*submit_bio)(struct bio *bio);
>   	int (*poll_bio)(struct bio *bio, struct io_comp_batch *iob,
> @@ -1601,6 +1616,7 @@ struct block_device_operations {
>   			enum blk_unique_id id_type);
>   	struct module *owner;
>   	const struct pr_ops *pr_ops;
> +	const struct blk_storage_elements_ops	*se_ops;
Indent?

>   
>   	/*
>   	 * Special callback for probing GPT entry at a given sector.
> diff --git a/include/uapi/linux/blkzoned.h b/include/uapi/linux/blkzoned.h
> index 663836120966..3a4bacfe7979 100644
> --- a/include/uapi/linux/blkzoned.h
> +++ b/include/uapi/linux/blkzoned.h
> @@ -208,4 +208,71 @@ struct blk_zone_range {
>   #define BLKFINISHZONE	_IOW(0x12, 136, struct blk_zone_range)
>   #define BLKREPORTZONEV2	_IOWR(0x12, 142, struct blk_zone_report)
>   
> +/**
> + * enum blk_storage_element_status - Statuc of a zoned device storage elements.
> + *
> + * @BLK_SE_RDWR: The storage element handles both reads and writes.
> + * @BLK_SE_READ: The storage element handles reads only.
> + * @BLK_SE_WRITE: The storage element handles writes only.
> + * @BLK_SE_WRITE: The storage element type is unknown.
> + */
> +enum blk_storage_element_type {
> +	BLK_SE_TYPE_RDWR		= 0x01,
> +	BLK_SE_TYPE_READ		= 0x02,
> +	BLK_SE_TYPE_WRITE		= 0x03,
> +	BLK_SE_TYPE_UNKNOWN		= 0xFF,
> +};
> +
> +/**
> + * enum blk_storage_element_status - Status of a zoned device storage elements.
> + *
> + * @BLK_SE_STS_OK: The storage element is operating normally.
> + * @BLK_SE_STS_DEGRADED: The storage element has degraded and is not operating
> + *			 normally.
> + * @BLK_SE_STS_REMOVE_IN_PROGRESS: The storage element is being removed.
> + * @BLK_SE_STS_REMOVE_ERROR: The storage element removal failed.
> + * @BLK_SE_STS_RESTORE_IN_PROGRESS: The storage element is being restored.
> + * @BLK_SE_STS_RESTORE_ERROR: The storage element restoration failed.
> + * @BLK_SE_STS_REMOVED: The storage element was removed.
> + * @BLK_SE_STS_UNKNOWN: The storage element status is unknown.
> + */
> +enum blk_storage_element_status {
> +	BLK_SE_STS_OK			= 0x01,
> +	BLK_SE_STS_DEGRADED		= 0x02,
> +	BLK_SE_STS_REMOVE_IN_PROGRESS	= 0x03,
> +	BLK_SE_STS_REMOVE_ERROR		= 0x04,
> +	BLK_SE_STS_RESTORE_IN_PROGRESS	= 0x05,
> +	BLK_SE_STS_RESTORE_ERROR	= 0x06,
> +	BLK_SE_STS_REMOVED		= 0x07,
> +	BLK_SE_STS_UNKOWN		= 0xFF,
> +};
> +
> +/**
> + * struct blk_storage_element - Zoned device storage element descriptor.
> + *
> + * @id: The ID of the element (cannot be 0).
> + * @paired_id: The ID of the paired element for an element that is not
> + *	       of type BLK_SE_TYPE_RDWR.
> + * @type: The type of the storage element (enum blk_storage_element_type).
> + * @status: The health status of the storage element
> + *	    (enum blk_storage_element_status).
> + * @restore_allowed: Indicate if the storage element can be restored.
> + * @nr_zones: The number of zones that the storage element handles.
> + */
> +struct blk_storage_element {
> +	__u32	id;
> +	__u32	paired_id;
> +	__u64	nr_zones;
> +	__u8	type;
> +	__u8	status;
> +	__u8	restore_allowed;
> +	__u8	reserved[5];
> +};
> +
> +struct blk_storage_elements_report {
> +	__u32				nr_elements;
> +	__u32				reserved;
> +	struct blk_storage_element	elements[];
> +};
> +
>   #endif /* _UAPI_BLKZONED_H */

Otherwise looks good.

Cheers

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
