Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0058E158DD1;
	Sat,  4 Jan 2025 22:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736028716; cv=none; b=UDr1yoj1YR+hSGJpoxUCtEiIadxRLu/ekdyvxPJBCc5hqFRhmgTYKPxm2To3IC0y+AAWo1upb4LJEKUej6gtlCA4BnLZzdlOoYy+KVCFPsYoVvwEBwHnnOr5cxCHJKa2CKlaWDIrsEJugyAnHQVBOaijgt/I0G1H8gy+Z9KXb/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736028716; c=relaxed/simple;
	bh=TJx2Ue7fcmfEgPv14nyW21GWFh1A6MoxTvozqu/FP04=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N09GFAqhz1cHOvmk9R8P+rj9CJXMTmuoMtse/n5u4cAu6vSUMuwF4PqgZ0qeMqI2biAMAGGT4kwO7VMUovSOJzdxE2Aa9S9OUz516kP5CD7tol2GTGmVR9XylGgvY2wGrW9UGcECPT6JoECDRekDisM0jYxfX6Ow9acRMstWSAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-38633b5dbcfso12728777f8f.2;
        Sat, 04 Jan 2025 14:11:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736028712; x=1736633512;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9gzwuWqYv4WT+H+v0TerIu3OK3suNQQflQ7F88x5UxU=;
        b=nPCkF5V+YvBYq0U6rmZVtdWO77P+Cign3wtZqTxK3qbKltH19q/yfWFBhMCEcBokYB
         g1jprDKoLe5eO/S8NJYSyJWGrgFQAdagEVF1Yy03b4hbW8ImdWZ58mG+6cs6IWsjPj2C
         i5lUdNDpyGEAypYDCt+leHkjqE7W+GwqkmQw8eV/7w456uTFYfs2fPzZ42RyIRV5S/2e
         YumL5wJMRnhrjzVFmEnfwEPjk7an8znMy3eg083SlWEYySSsidmgqcFAo0jiy1rnTeJU
         m4FYuvX7k7a6WdAkZJbUKc/ifmmxwgV2cujimtO/BAQ9NIpVUvWwp76hk6VNw1octcta
         UPdw==
X-Forwarded-Encrypted: i=1; AJvYcCVxSOeAfa+FG34a+kW7NzdnFUHFpLxj6nhu7qFABcluelHM3+RZAbOB79wMM+50x9BYBHBXG6DvIZ5GJEoO@vger.kernel.org, AJvYcCX4NZPEMhFxVMMIEk+btNTTXPuPtJwHAYClJfdZidGiH5utecWuNWwBy5lHToaYkYRGGJtLfy04oviF@vger.kernel.org
X-Gm-Message-State: AOJu0YzRL0wwox3IEOoeSLr3QYin20hRITwRBDx1Owy0AZ4tLe0Z36Dv
	3Zm5pI6XHlWd/Un76pWgTbXiJtEWV4bkAfEcMF8Xd9/d6F9FqO3AyTcwJQ==
X-Gm-Gg: ASbGnct92rUG69EpqFupB9lP4Q71jIYvkSjsMbDf4YDfpHAtukmekaKhygPfXCZEBgg
	/5i3yKY7+x7B1eEtqvo0/+U/OLRbFJMJuLu2vQOkyJPratOiy3zUdPvO9GsBMTAdu4v7j6xrgiT
	c5b0MP1y58IzIS1yb0moUvKeHKXZQWPQF4K+YiS0jpewKrkMTczG0K1395LIbQa58fF/B5jEGQg
	pFfZ7oowgH3FFQeyNSXvS6Rf5qEmUNNTVU2Un4quOwNOU4jK4P7C33dbNSJGRhtMQw0Bi+1S2GC
	wzBItKceMU39cXiHPyBAqxg=
X-Google-Smtp-Source: AGHT+IEiRIDWXXsDhHRNseRHXez167n6bJKIibbf12N1+gxvi9iEsPrcDoH7/JL4Dulr48TlIQniHA==
X-Received: by 2002:a05:6000:4023:b0:385:e5dc:e285 with SMTP id ffacd0b85a97d-38a22406d4emr47237244f8f.58.1736028711931;
        Sat, 04 Jan 2025 14:11:51 -0800 (PST)
Received: from [10.100.102.74] (CBL217-132-142-53.bb.netvision.net.il. [217.132.142.53])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43656b417afsm562520085e9.36.2025.01.04.14.11.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Jan 2025 14:11:51 -0800 (PST)
Message-ID: <65b1b566-a9e1-4015-a750-2fe7a8fe4f9b@grimberg.me>
Date: Sun, 5 Jan 2025 00:11:50 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] block: remove bio_add_pc_page
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20250103073417.459715-1-hch@lst.de>
 <20250103073417.459715-2-hch@lst.de>
Content-Language: en-US
From: Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20250103073417.459715-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>



On 03/01/2025 9:33, Christoph Hellwig wrote:
> Lift bio_split_rw_at into blk_rq_append_bio so that it validates the
> hardware limits.  With this all passthrough callers can simply add
> bio_add_page to build the bio and delay checking for exceeding of limits
> to this point instead of doing it for each page.
>
> While this looks like adding a new expensive loop over all bio_vecs,
> blk_rq_append_bio is already doing that just to counter the number of
> segments.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   block/bio.c                        | 107 ++------------------------
>   block/blk-map.c                    | 118 +++++++----------------------
>   block/blk.h                        |   8 --
>   drivers/nvme/target/passthru.c     |  18 +++--
>   drivers/nvme/target/zns.c          |   3 +-
>   drivers/target/target_core_pscsi.c |   6 +-
>   include/linux/bio.h                |   2 -
>   7 files changed, 48 insertions(+), 214 deletions(-)
>
> diff --git a/block/bio.c b/block/bio.c
> index d5bdc31d88d3..4e1a27d312c9 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -946,8 +946,11 @@ static bool bvec_try_merge_page(struct bio_vec *bv, struct page *page,
>   
>   /*
>    * Try to merge a page into a segment, while obeying the hardware segment
> - * size limit.  This is not for normal read/write bios, but for passthrough
> - * or Zone Append operations that we can't split.
> + * size limit.
> + *
> + * This is kept around for the integrity metadata, which is still tries
> + * to build the initial bio to the hardware limit and doesn't have proper
> + * helpers to split.  Hopefully this will go away soon.
>    */
>   bool bvec_try_merge_hw_page(struct request_queue *q, struct bio_vec *bv,
>   		struct page *page, unsigned len, unsigned offset,
> @@ -964,106 +967,6 @@ bool bvec_try_merge_hw_page(struct request_queue *q, struct bio_vec *bv,
>   	return bvec_try_merge_page(bv, page, len, offset, same_page);
>   }
>   
> -/**
> - * bio_add_hw_page - attempt to add a page to a bio with hw constraints
> - * @q: the target queue
> - * @bio: destination bio
> - * @page: page to add
> - * @len: vec entry length
> - * @offset: vec entry offset
> - * @max_sectors: maximum number of sectors that can be added
> - * @same_page: return if the segment has been merged inside the same page
> - *
> - * Add a page to a bio while respecting the hardware max_sectors, max_segment
> - * and gap limitations.
> - */
> -int bio_add_hw_page(struct request_queue *q, struct bio *bio,
> -		struct page *page, unsigned int len, unsigned int offset,
> -		unsigned int max_sectors, bool *same_page)
> -{
> -	unsigned int max_size = max_sectors << SECTOR_SHIFT;
> -
> -	if (WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED)))
> -		return 0;
> -
> -	len = min3(len, max_size, queue_max_segment_size(q));
> -	if (len > max_size - bio->bi_iter.bi_size)
> -		return 0;
> -
> -	if (bio->bi_vcnt > 0) {
> -		struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt - 1];
> -
> -		if (bvec_try_merge_hw_page(q, bv, page, len, offset,
> -				same_page)) {
> -			bio->bi_iter.bi_size += len;
> -			return len;
> -		}
> -
> -		if (bio->bi_vcnt >=
> -		    min(bio->bi_max_vecs, queue_max_segments(q)))
> -			return 0;
> -
> -		/*
> -		 * If the queue doesn't support SG gaps and adding this segment
> -		 * would create a gap, disallow it.
> -		 */
> -		if (bvec_gap_to_prev(&q->limits, bv, offset))
> -			return 0;
> -	}
> -
> -	bvec_set_page(&bio->bi_io_vec[bio->bi_vcnt], page, len, offset);
> -	bio->bi_vcnt++;
> -	bio->bi_iter.bi_size += len;
> -	return len;
> -}
> -
> -/**
> - * bio_add_hw_folio - attempt to add a folio to a bio with hw constraints
> - * @q: the target queue
> - * @bio: destination bio
> - * @folio: folio to add
> - * @len: vec entry length
> - * @offset: vec entry offset in the folio
> - * @max_sectors: maximum number of sectors that can be added
> - * @same_page: return if the segment has been merged inside the same folio
> - *
> - * Add a folio to a bio while respecting the hardware max_sectors, max_segment
> - * and gap limitations.
> - */
> -int bio_add_hw_folio(struct request_queue *q, struct bio *bio,
> -		struct folio *folio, size_t len, size_t offset,
> -		unsigned int max_sectors, bool *same_page)
> -{
> -	if (len > UINT_MAX || offset > UINT_MAX)
> -		return 0;
> -	return bio_add_hw_page(q, bio, folio_page(folio, 0), len, offset,
> -			       max_sectors, same_page);
> -}
> -
> -/**
> - * bio_add_pc_page	- attempt to add page to passthrough bio
> - * @q: the target queue
> - * @bio: destination bio
> - * @page: page to add
> - * @len: vec entry length
> - * @offset: vec entry offset
> - *
> - * Attempt to add a page to the bio_vec maplist. This can fail for a
> - * number of reasons, such as the bio being full or target block device
> - * limitations. The target block device must allow bio's up to PAGE_SIZE,
> - * so it is always possible to add a single page to an empty bio.
> - *
> - * This should only be used by passthrough bios.
> - */
> -int bio_add_pc_page(struct request_queue *q, struct bio *bio,
> -		struct page *page, unsigned int len, unsigned int offset)
> -{
> -	bool same_page = false;
> -	return bio_add_hw_page(q, bio, page, len, offset,
> -			queue_max_hw_sectors(q), &same_page);
> -}
> -EXPORT_SYMBOL(bio_add_pc_page);
> -
>   /**
>    * __bio_add_page - add page(s) to a bio in a new segment
>    * @bio: destination bio
> diff --git a/block/blk-map.c b/block/blk-map.c
> index 894009b2d881..67a2da3b7ed9 100644
> --- a/block/blk-map.c
> +++ b/block/blk-map.c
> @@ -189,7 +189,7 @@ static int bio_copy_user_iov(struct request *rq, struct rq_map_data *map_data,
>   			}
>   		}
>   
> -		if (bio_add_pc_page(rq->q, bio, page, bytes, offset) < bytes) {
> +		if (bio_add_page(bio, page, bytes, offset) < bytes) {
>   			if (!map_data)
>   				__free_page(page);
>   			break;
> @@ -272,86 +272,27 @@ static struct bio *blk_rq_map_bio_alloc(struct request *rq,
>   static int bio_map_user_iov(struct request *rq, struct iov_iter *iter,
>   		gfp_t gfp_mask)
>   {
> -	iov_iter_extraction_t extraction_flags = 0;
> -	unsigned int max_sectors = queue_max_hw_sectors(rq->q);
>   	unsigned int nr_vecs = iov_iter_npages(iter, BIO_MAX_VECS);
>   	struct bio *bio;
>   	int ret;
> -	int j;
>   
>   	if (!iov_iter_count(iter))
>   		return -EINVAL;
>   
>   	bio = blk_rq_map_bio_alloc(rq, nr_vecs, gfp_mask);
> -	if (bio == NULL)
> +	if (!bio)
>   		return -ENOMEM;
> -
> -	if (blk_queue_pci_p2pdma(rq->q))
> -		extraction_flags |= ITER_ALLOW_P2PDMA;
> -	if (iov_iter_extract_will_pin(iter))
> -		bio_set_flag(bio, BIO_PAGE_PINNED);
> -
> -	while (iov_iter_count(iter)) {
> -		struct page *stack_pages[UIO_FASTIOV];
> -		struct page **pages = stack_pages;
> -		ssize_t bytes;
> -		size_t offs;
> -		int npages;
> -
> -		if (nr_vecs > ARRAY_SIZE(stack_pages))
> -			pages = NULL;
> -
> -		bytes = iov_iter_extract_pages(iter, &pages, LONG_MAX,
> -					       nr_vecs, extraction_flags, &offs);
> -		if (unlikely(bytes <= 0)) {
> -			ret = bytes ? bytes : -EFAULT;
> -			goto out_unmap;
> -		}
> -
> -		npages = DIV_ROUND_UP(offs + bytes, PAGE_SIZE);
> -
> -		if (unlikely(offs & queue_dma_alignment(rq->q)))
> -			j = 0;
> -		else {
> -			for (j = 0; j < npages; j++) {
> -				struct page *page = pages[j];
> -				unsigned int n = PAGE_SIZE - offs;
> -				bool same_page = false;
> -
> -				if (n > bytes)
> -					n = bytes;
> -
> -				if (!bio_add_hw_page(rq->q, bio, page, n, offs,
> -						     max_sectors, &same_page))
> -					break;
> -
> -				if (same_page)
> -					bio_release_page(bio, page);
> -				bytes -= n;
> -				offs = 0;
> -			}
> -		}
> -		/*
> -		 * release the pages we didn't map into the bio, if any
> -		 */
> -		while (j < npages)
> -			bio_release_page(bio, pages[j++]);
> -		if (pages != stack_pages)
> -			kvfree(pages);
> -		/* couldn't stuff something into bio? */
> -		if (bytes) {
> -			iov_iter_revert(iter, bytes);
> -			break;
> -		}
> -	}
> -
> +	ret = bio_iov_iter_get_pages(bio, iter);
> +	if (ret)
> +		goto out_put;

This looks like a more involved change than converting bio_add_hw_page. 
Perhaps should go into a separate patch? Other than that, looks good 
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
