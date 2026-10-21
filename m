Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792576129;
	b=2GW3L3X+S3B7R461i97eb6qc2gDABzs8m4miAVPYNqpBQMsTb3FaKxUSJf5miTC7mxoS
	 Kyvbs3phJS9QKFreVMvQ2y2BV1JUFqYCHBrK+6Z43vYGSj9/VuHgrjlW7481kAr9Q/Dnp
	 z786sEqehoVjcdeBOWyCJDsl5YpQLgLaOOpaiBzy94jyN8q40fBjulYH3qHL7Mzx1R4Lb
	 klhgmcj449T7J3Coti2eY61bPdxQS9xefh8niCI1dZ404PT4fChtCTeWrd3LMUassToUP
	 etMNznF0LTs6fL1E1iDexuAPpF/leWvlOTWMzoRlvZ8qQQ7erCVMXBgUDxqE9So4ucA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792576129;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spamd-Result:X-Spam-Score:
	 X-Spam-Level:X-Spam-Flag;
	bh=xUQXbNAIHVk+ZZ/pSJTiJ3A6vVaHx6CLPqTEQV2JEsM=;
	b=TSQtAPc9Vuajb5cXPeI06sYDmJh2CVU1mkW/nWfauFuabNNmgQbVXr+vA2B30FfwBOw3
	 TaW+VV5Dluc4/LZKJrf6q0pBAILavWqE6NyTHgs++SXGKilm0EDQ8rtCIINunMXmtvbbk
	 k1RQhXMuVDnjo5HEpZIbmePPJu87jDYhiQ7pLzcbqW4kRZXjCV6XOJXa7PgmxTsVHcL5g
	 bswJGgrV2QiUjJB4nA9wKd5/Wi7TuTl3hF00l7kppYSWhhVwNMmV7YqcwhiKXrF7H+dxg
	 7lZ9m7UbfsLAHF+oaf5Vuv1B62JjbcDgu5abm0G+6xsaJTmOVyzOQn4Iilb8V/U0sBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=ijEY8gWp;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=5TGFOLmQ;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=ijEY8gWp;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=5TGFOLmQ;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3988D606A31B;
	Wed, 21 Oct 2026 09:48:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3988D606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=ijEY8gWp;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=5TGFOLmQ;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=ijEY8gWp;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=5TGFOLmQ
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8044B21DEB;
	Wed, 21 Oct 2026 09:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792576126; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xUQXbNAIHVk+ZZ/pSJTiJ3A6vVaHx6CLPqTEQV2JEsM=;
	b=ijEY8gWpjBAHF3zH5UC2dZkfSVWYvZraYKiKIUGtBi0epux23FXf9CjWDcHDcDPZt+eQy/
	4t/lWDN6cZMHcmn+g2Pq73iBrroCMcToFJVR5MrLviBkaCk7xpbKCH6/B/66NPPY7KU5PV
	bdgqSR+JSU/uyWq/30VN5gVXLk1RZY0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792576126;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xUQXbNAIHVk+ZZ/pSJTiJ3A6vVaHx6CLPqTEQV2JEsM=;
	b=5TGFOLmQsyG1/Md+sYxqaOvZ3IdxzVOC7YAki62kS+Bc+p5tofjUdI6pVO7SPfVjaFUQzW
	HHpDCdT3cczKSYDA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792576126; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xUQXbNAIHVk+ZZ/pSJTiJ3A6vVaHx6CLPqTEQV2JEsM=;
	b=ijEY8gWpjBAHF3zH5UC2dZkfSVWYvZraYKiKIUGtBi0epux23FXf9CjWDcHDcDPZt+eQy/
	4t/lWDN6cZMHcmn+g2Pq73iBrroCMcToFJVR5MrLviBkaCk7xpbKCH6/B/66NPPY7KU5PV
	bdgqSR+JSU/uyWq/30VN5gVXLk1RZY0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792576126;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xUQXbNAIHVk+ZZ/pSJTiJ3A6vVaHx6CLPqTEQV2JEsM=;
	b=5TGFOLmQsyG1/Md+sYxqaOvZ3IdxzVOC7YAki62kS+Bc+p5tofjUdI6pVO7SPfVjaFUQzW
	HHpDCdT3cczKSYDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3DAB9134FD;
	Wed, 21 Oct 2026 09:48:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HKbOBH6K2GoGKgAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 21 Oct 2026 09:48:46 +0000
Message-ID: <4e75f8d2-7d73-4e32-94de-1f67350603dc@suse.de>
Date: Wed, 21 Oct 2026 11:48:45 +0200
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
Subject: Re: [PATCH v6 04/10] block: add storage element management ioctls
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20261013122750.2237843-1-dlemoal@kernel.org>
 <20261013122750.2237843-5-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261013122750.2237843-5-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-0.998];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -4.29
X-Spam-Level: 
X-Spam-Flag: NO

On 10/13/26 2:27 PM, Damien Le Moal wrote:
> Define the new ioctl commands BLKREPORTSTORELEMS, BLKREMOVESTORELEM, and
> BLKRESTORESTORELEMS to provide users accessing zoned block devices
> directly with an interface to the storage elements management operations
> of the block layer.
> 
> The ioctl BLKREPORTSTORELEMS allows to get the total number of storage
> elements of a zoned block device and to get an array of storage element
> descriptors (struct blk_se) describing the current state of the device
> storage elements.
> 
> The ioctl BLKREMOVESTORELEM can be used to remove (depopulate) a storage
> element that has a degraded status (i.e. BLK_SE_STS_DEGRADED).
> 
> Finally, the BLKRESTORESTORELEMS ioctl interfaces with
> bdev_restore_storage_elements() to restore the depopulated storage
> elements of a zoned device.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   block/blk-zoned.c             | 134 ++++++++++++++++++++++++++++++++++
>   block/blk.h                   |   9 +++
>   block/ioctl.c                 |   4 +
>   include/uapi/linux/blkzoned.h |  36 +++++++++
>   include/uapi/linux/fs.h       |   1 +
>   5 files changed, 184 insertions(+)
> 
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 252d12254692..580b26ff3aa7 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -19,6 +19,7 @@
>   #include <linux/kthread.h>
>   #include <linux/freezer.h>
>   #include <linux/delay.h>
> +#include <linux/uaccess.h>
>   
>   #include <trace/events/block.h>
>   
> @@ -2846,6 +2847,46 @@ int bdev_report_storage_elements(struct block_device *bdev,
>   }
>   EXPORT_SYMBOL_GPL(bdev_report_storage_elements);
>   
> +static int blkdev_ioctl_report_storage_elements(struct block_device *bdev,
> +						void __user *argp)
> +{
> +	struct gendisk *disk = bdev->bd_disk;
> +	struct blk_se_report *rep;
> +	unsigned int nr_elements;
> +	int ret;
> +
> +	rep = kzalloc_flex(*rep, elements, disk->nr_storage_elements);
> +	if (!rep)
> +		return -ENOMEM;
> +
> +	if (copy_from_user(rep, argp, sizeof(struct blk_se_report))) {
> +		ret = -EFAULT;
> +		goto free_rep;
> +	}
> +
> +	nr_elements = rep->nr_elements;
> +	if (nr_elements < disk->nr_storage_elements)
> +		rep->nr_reported_elements = nr_elements;
> +	else
> +		rep->nr_reported_elements = disk->nr_storage_elements;
> +	rep->nr_elements = disk->nr_storage_elements;
> +
> +	if (rep->nr_reported_elements) {
> +		ret = bdev_report_storage_elements(bdev, rep->elements,
> +						   &rep->nr_reported_elements);
> +		if (ret)
> +			goto free_rep;
> +	}
> +
> +	if (copy_to_user(argp, rep,
> +			struct_size(rep, elements, rep->nr_reported_elements)))
> +		ret = -EFAULT;
> +
> +free_rep:
> +	kfree(rep);
> +	return ret;
> +}
> +
>   /**
>    * bdev_remove_storage_element - Remove (depopulate) a storage element of a
>    *				 zoned block device
> @@ -2916,6 +2957,53 @@ int bdev_remove_storage_element(struct block_device *bdev,
>   }
>   EXPORT_SYMBOL_GPL(bdev_remove_storage_element);
>   
> +static int blkdev_flush_and_truncate(struct block_device *bdev,
> +				     blk_mode_t mode)
> +{
> +	int ret;
> +
> +	inode_lock(bdev->bd_mapping->host);
> +	filemap_invalidate_lock(bdev->bd_mapping);
> +	ret = blkdev_issue_flush(bdev->bd_disk->part0);
> +	if (!ret)
> +		ret = truncate_bdev_range(bdev, mode, 0,
> +					  bdev_nr_bytes(bdev) - 1);
> +	filemap_invalidate_unlock(bdev->bd_mapping);
> +	inode_unlock(bdev->bd_mapping->host);
> +
> +	return ret;
> +}
> +
> +static int blkdev_ioctl_remove_storage_element(struct block_device *bdev,
> +					       blk_mode_t mode,
> +					       unsigned int __user *argp)
> +{
> +	unsigned int element_id;
> +	int ret;
> +
> +	if (!(mode & BLK_OPEN_WRITE))
> +		return -EBADF;
> +	if (bdev_read_only(bdev))
> +		return -EPERM;
> +
> +	if (get_user(element_id, argp))
> +		return -EFAULT;
> +
> +	/*
> +	 * Flush the device volatile write cache and invalidate all cached data
> +	 * so that reads do not return old data for zones that went offline.
> +	 * Since a user can only write to zoned devices using direct IOs, we
> +	 * should never have any dirty page invalidated and so no data loss as
> +	 * long as the device cache flush succeeds, that is, as long as the
> +	 * flush does not use degraded storage elements.
> +	 */
> +	ret = blkdev_flush_and_truncate(bdev, mode);
> +	if (ret)
> +		return ret;
> +
> +	return bdev_remove_storage_element(bdev, element_id);
> +}
> +
>   /**
>    * bdev_restore_storage_elements - Restore all depopulated storage elements of
>    *				   a zoned block device
> @@ -2980,6 +3068,29 @@ int bdev_restore_storage_elements(struct block_device *bdev)
>   }
>   EXPORT_SYMBOL_GPL(bdev_restore_storage_elements);
>   
> +static int blkdev_ioctl_restore_storage_elements(struct block_device *bdev,
> +						 blk_mode_t mode)
> +{
> +	int ret;
> +
> +	if (!(mode & BLK_OPEN_WRITE))
> +		return -EBADF;
> +	if (bdev_read_only(bdev))
> +		return -EPERM;
> +
> +	/*
> +	 * Storage element restoration is a destructive operation that will
> +	 * reset all zones. So flush the device volatile write cache and
> +	 * invalidate all cached data that we may have so that old data cannot
> +	 * be read once the operation completes.
> +	 */
> +	ret = blkdev_flush_and_truncate(bdev, mode);
> +	if (ret)
> +		return ret;
> +
> +	return bdev_restore_storage_elements(bdev);
> +}
> +
>   int disk_init_storage_element_mgmt(struct gendisk *disk)
>   {
>   	int ret;
> @@ -3012,3 +3123,26 @@ int disk_init_storage_element_mgmt(struct gendisk *disk)
>   
>   	return 0;
>   }
> +
> +int blkdev_zone_storage_elements_ioctl(struct block_device *bdev,
> +				       blk_mode_t mode, unsigned int cmd,
> +				       void __user *argp)
> +{
> +	struct gendisk *disk = bdev->bd_disk;
> +
> +	if (!disk->nr_storage_elements)
> +		return -ENOTTY;
> +
> +	switch (cmd) {
> +	case BLKREPORTSTORELEMS:
> +		return blkdev_ioctl_report_storage_elements(bdev, argp);
> +	case BLKREMOVESTORELEM:
> +		return blkdev_ioctl_remove_storage_element(bdev, mode, argp);
> +	case BLKRESTORESTORELEMS:
> +		return blkdev_ioctl_restore_storage_elements(bdev, mode);
> +	default:
> +		break;
> +	}
> +
> +	return -ENOTTY;
> +}
> diff --git a/block/blk.h b/block/blk.h
> index 39d90747b40f..bbf523c9579c 100644
> --- a/block/blk.h
> +++ b/block/blk.h
> @@ -579,6 +579,9 @@ int blkdev_report_zones_ioctl(struct block_device *bdev, unsigned int cmd,
>   int blkdev_zone_mgmt_ioctl(struct block_device *bdev, blk_mode_t mode,
>   		unsigned int cmd, unsigned long arg);
>   bool bdev_zone_mgmt_allowed(struct block_device *bdev, sector_t sector);
> +int blkdev_zone_storage_elements_ioctl(struct block_device *bdev,
> +				       blk_mode_t mode, unsigned int cmd,
> +				       void __user *argp);
>   #else /* CONFIG_BLK_DEV_ZONED */
>   static inline int disk_init_storage_element_mgmt(struct gendisk *disk)
>   {
> @@ -630,6 +633,12 @@ static inline bool bdev_zone_mgmt_allowed(struct block_device *bdev,
>   {
>   	return false;
>   }
> +static inline int blkdev_zone_storage_elements_ioctl(struct block_device *bdev,
> +					blk_mode_t mode, unsigned int cmd,
> +					void __user *argp)
> +{
> +	return -ENOTTY;
> +}
>   #endif /* CONFIG_BLK_DEV_ZONED */
>   
>   struct block_device *bdev_alloc(struct gendisk *disk, u8 partno);
> diff --git a/block/ioctl.c b/block/ioctl.c
> index 64b4e6c0f696..e886ca9f7dd1 100644
> --- a/block/ioctl.c
> +++ b/block/ioctl.c
> @@ -679,6 +679,10 @@ static int blkdev_common_ioctl(struct block_device *bdev, blk_mode_t mode,
>   		return put_uint(argp, bdev_zone_sectors(bdev));
>   	case BLKGETNRZONES:
>   		return put_uint(argp, bdev_nr_zones(bdev));
> +	case BLKREPORTSTORELEMS:
> +	case BLKREMOVESTORELEM:
> +	case BLKRESTORESTORELEMS:
> +		return blkdev_zone_storage_elements_ioctl(bdev, mode, cmd, argp);
>   	case BLKROGET:
>   		return put_int(argp, bdev_read_only(bdev) != 0);
>   	case BLKSSZGET: /* get block device logical block size */
> diff --git a/include/uapi/linux/blkzoned.h b/include/uapi/linux/blkzoned.h
> index f9ecd54210d0..9e2b7a6de1d9 100644
> --- a/include/uapi/linux/blkzoned.h
> +++ b/include/uapi/linux/blkzoned.h
> @@ -270,4 +270,40 @@ struct blk_se {
>   	__u8	reserved[13];
>   };
>   
> +/**
> + * struct blk_se_report - Zoned device storage element descripor report for the
> + *			  BLKREPORTSTORELEMS ioctl.
> + *
> + * @nr_elements: on input, this indicates the size of the @elements array. On
> + *		 output, this indicates the maximum number of storage elements
> + *		 of the device. If this field specifies 0 on input, the array
> + *		 @elements is not filled and the maximum number of storage
> + *		 elements of the device returned.
> + * @nr_reported_elements: output only to indicate the number of storage element
> + *			  descriptors filled in the array @elements.
> + * @reserved: reserved space for future use and structure field alignment.
> + * @elements: array of storage element descriptors with a maximum number of
> + *	      entries specified by @nr_elements on input and by
> + *	      @nr_reported_elements on output.
> + */
> +struct blk_se_report {
> +	__u32		nr_elements;
> +	__u32		nr_reported_elements;
> +	__u64		reserved;
> +	struct blk_se	elements[];
> +};
> +
> +/**
> + * Zoned block device storage element management ioctl's:
> + *
> + * @BLKREPORTSTORELEMS: Get the number of storage elements of a device and
> + *			the device storage element descriptors.
> + * @BLKREMOVESTORELEM: Remove (depopulate) one storage element of a device.
> + * @BLKRESTORESTORELEM: Restore (repopulate if possible) all storage elements
> + *			that have been removed.
> + */
> +#define BLKREPORTSTORELEMS  _IOWR(0x12, 143, struct blk_se_report)
> +#define BLKREMOVESTORELEM   _IOW(0x12, 144, __u32)
> +#define BLKRESTORESTORELEMS _IO(0x12, 145)
> +
>   #endif /* _UAPI_BLKZONED_H */
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index 34c6f219462a..1ec7406ec312 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -309,6 +309,7 @@ struct file_attr {
>   /* 130-136 and 142 are used by zoned block device ioctls (uapi/linux/blkzoned.h) */
>   /* 137-141 are used by blk-crypto ioctls (uapi/linux/blk-crypto.h) */
>   #define BLKTRACESETUP2 _IOWR(0x12, 142, struct blk_user_trace_setup2)
> +/* 143-145 are used by storage element management for zoned block devices. */
>   
>   #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
>   #define FIBMAP	   _IO(0x00,1)	/* bmap access */


-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
