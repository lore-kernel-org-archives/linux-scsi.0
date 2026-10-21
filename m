Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792576744;
	b=b4yr2sy82fnPtoba+RVOOcknEoZR48eFmGEly34srBhdOhQmcAugy7yRM4wfdk8tvLhY
	 a/I5f2JkKqSjmgVmyKLO1wR+eSeb1bqeW9BIpzNCUukXiozmlZN+/CpeNpjyw9pYicDiY
	 /iR4k3T1EdBhH3fWOpuUlSBm/AJJIsernnuQ9ylNltFeTO/WyHo8Yo/97recVYnRVweom
	 kmh8RaX6eF/gSlngkmLhkteC8hfJ1c8N6EsNQ/kuOJ32B7kXVjO8DBSbxs59p91HeSdWJ
	 jbOnAT/a396iEQuqiu2du7bNoAaTP+YzwVQ9LLohUZOv2nI5pczhTDFiBUd9QCm4t9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792576744;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:References:From:Content-Language:Organization:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=AnjfbEYEjN/DXkm3ZmYlXb7fwNuVlJxfvkxwzOYXktU=;
	b=IpZjNCoNKwyVSmfGMpccfR7rlE/Jc6ENZ9pN5gtZq/oYxrrCfOyeCy4mjIs0MP/0nYFy
	 K6+lAUSxtplYHO8b8y05eliyVzAuNJL6XhkAecZUKjyn5gGF9h1/ODptOqQz3c8jL5SNu
	 u8FU+V8BuWEF8Uya9O4JBhbNOrE+cXG/Tuq+y03LT0D3YiCg5bJ5BCRW2Sa2nrlyTGWSz
	 gBXsC7qOfPOL7JlTJN5M9qQL9XT/jH4Pv5IStyXcQ+YuK8mM2IXWUL9mCK88exr8V7XeS
	 +rdb73Z8n6VjHWUedLI5/HaPAhzkdSdWiAoo2q9+G00eOyHlEEtJNbQUsnTJWVT0oMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ogtsZhbO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1E1606A31A;
	Wed, 21 Oct 2026 09:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ogtsZhbO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD281F000CA;
	Wed, 21 Oct 2026 09:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792576743;
	bh=AnjfbEYEjN/DXkm3ZmYlXb7fwNuVlJxfvkxwzOYXktU=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=ogtsZhbOKSWzPnLdJ3sLITzsE0+mUkqi8Yu+U+67qNzeI1sAdGBTkrcWxu0SmEcx6
	 xG87JxQuDnpB2rrUc4y+XgJDeZZ091S+Oz1VyRDx39RoAqoRYqdkUCpM2J6idMV7yH
	 9szpCHY1+nhKuazm0xaAXyLKyozRb/oyC5wqxot0SDZiXbihC5qscZhPEoUei+0T+S
	 FHR2SHirSIhM5C/NiESvQzeQSQsa8tSL4x1mdv83AbJSZvKYuaf1+5/zBRFXkXQJaA
	 6pMRG/m2aQmlN1rVz52xmsnUG/e56NmnOmk5lzinkoTTeNsHy/chdYWMELKwE2vQ3G
	 xoqydeElvEh7g==
Message-ID: <4b86ac66-2a56-4168-81c2-d1e445cc5edf@kernel.org>
Date: Wed, 21 Oct 2026 11:59:00 +0200
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
To: Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20261013122750.2237843-1-dlemoal@kernel.org>
 <20261013122750.2237843-4-dlemoal@kernel.org>
 <0746196e-d95f-4d5e-ab44-507d7035fd37@suse.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <0746196e-d95f-4d5e-ab44-507d7035fd37@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/10/21 11:42, Hannes Reinecke wrote:
> On 10/13/26 2:27 PM, Damien Le Moal wrote:
>> Recent SCSI (SBC) and ATA (ACS) standards define the storage element
>> depopulation feature. This feature is intended for managing hard-disks
>> heads, either combined read-write heads or pairs of read and write heads,
>> allowing to keep disks with defective heads longer in production by
>> allowing "depopulating" (removing) defective heads.
>>
>> This feature comes in two different flavors:
>>   - A destructive version which removes a head and reformats the disk at a
>>     lower capacity point, restoaring a fully functional contiguous LBA
>>     address space.
>>   - A data preserving version restricted to host-managed zoned disks, which
>>     marks the zones served by a removed head as offline or read-only.
>>
>> In preparation for using the data-preserving flavor of the depopulation
>> feature in file systems natively supporting zoned block devices, introduce
>> a set of storage element management operations and functions to define
>> generic calls into block device drivers for managing storage elements.
>>
>> The set of operations is defined with struct blk_se_ops and includes three
>> operations:
>>   - report_elements: get information on a device storage elements state
>>     reported with the new struct blk_se.
>>   - remove_element: depopulate a defective storage element
>>   - restore_elements: restore depopulated storage elements
>>
>> Each operation is called from the functions
>> bdev_report_storage_elements(), bdev_remove_storage_element() and
>> bdev_restore_storage_elements().
>>
>> Removing a healthy storage element from a device is possible and useful
>> for testing. The storage element restoration operation restore_elements
>> allows repopulating such healthy element. Repopulating defective storage
>> elements is generally not allowed by devices. The remove_element and
>> restore_elements operations are executed under the zone revalidation lock
>> so that they are serialized iand also serialized against user initiated
>> device revalidation, thus allowing to always have a consistent view of the
>> device zone conditions.
>>
>> The device drivers of zoned block devices can indicate support for the
>> storage element depopulation feature by specifying the storage element
>> management operations with the se_ops field of struct
>> block_device_operations.
>>
>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
>> ---
>>   block/blk-zoned.c             | 291 +++++++++++++++++++++++++++++++++-
>>   block/blk.h                   |   5 +
>>   block/genhd.c                 |   4 +
>>   include/linux/blkdev.h        |  22 +++
>>   include/uapi/linux/blkzoned.h |  62 ++++++++
>>   5 files changed, 383 insertions(+), 1 deletion(-)
>>
>> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
>> index acec8a7e648e..252d12254692 100644
>> --- a/block/blk-zoned.c
>> +++ b/block/blk-zoned.c
>> @@ -18,6 +18,7 @@
>>   #include <linux/mempool.h>
>>   #include <linux/kthread.h>
>>   #include <linux/freezer.h>
>> +#include <linux/delay.h>
>>   
>>   #include <trace/events/block.h>
>>   
>> @@ -2721,5 +2722,293 @@ int queue_zone_wplugs_show(void *data, struct seq_file *m)
>>   
>>   	return 0;
>>   }
>> -
>>   #endif
>> +
>> +static int disk_se_mgmt_in_progress(struct gendisk *disk,
>> +				     struct blk_se *elements,
>> +				     bool *in_progress)
>> +{
>> +	unsigned int i, nr_se = disk->nr_storage_elements;
>> +	int ret;
>> +
>> +	/*
>> +	 * Check if we have storage elements being removed or restored.
>> +	 */
>> +	ret = disk->fops->se_ops->report_elements(disk, elements, &nr_se);
>> +	if (ret) {
>> +		pr_err("Failed to get storage elements\n");
>> +		return ret;
>> +	}
>> +
>> +	for (i = 0; i < nr_se; i++) {
>> +		switch (elements[i].status) {
>> +		case BLK_SE_STS_REMOVE_IN_PROGRESS:
>> +		case BLK_SE_STS_RESTORE_IN_PROGRESS:
>> +			*in_progress = true;
>> +			return 0;
>> +		default:
>> +			break;
>> +		}
>> +	}
>> +
>> +	*in_progress = false;
>> +
>> +	return 0;
>> +}
>> +
>> +static int disk_check_remove_error(struct gendisk *disk,
>> +				   struct blk_se *elements,
>> +				   unsigned int element_id)
>> +{
>> +	unsigned int i;
>> +
>> +	for (i = 0; i < disk->nr_storage_elements; i++) {
>> +		if (elements[i].id == element_id &&
>> +		    elements[i].status == BLK_SE_STS_REMOVE_ERROR)
>> +			return -EIO;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int disk_wait_for_se_mgmt_completion(struct gendisk *disk,
>> +					    struct blk_se *elements,
>> +					    unsigned int element_id)
>> +{
>> +	bool in_progress;
>> +	int ret;
>> +
>> +	/*
>> +	 * Poll the storage elements heath state to detect the end of a
>> +	 * removal or restoration operation. Since we do not know how long the
>> +	 * operation may take, we cannot have a timeout on this loop. So check
>> +	 * for fatal signals so that the user can terminate this retry loop if
>> +	 * the device misbehaves.
>> +	 */
>> +	while (1) {
>> +		ret = disk_se_mgmt_in_progress(disk, elements, &in_progress);
>> +		if (ret || !in_progress)
>> +			break;
>> +
>> +		if (fatal_signal_pending(current)) {
>> +			ret = -EINTR;
>> +			break;
>> +		}
>> +
>> +		/* Not done yet: wait and retry. */
>> +		msleep(1000);
>> +	}
>> +
> I always feel a bit uncomfortable having to poll without a dedicated
> end time.
> Care to add a timeout here to avoid an infinite wait?

That's why the loop is interruptible with a signal... I fear that a timeout
could cause problem for "slow" drives, causing failures when everything is fine.
I could add a timeout of several minutes, but then who says that all drives can
depop a head in less than that timeout?



-- 
Damien Le Moal
Western Digital Research
