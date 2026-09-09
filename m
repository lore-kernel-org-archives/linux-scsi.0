Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8D8403EA1
	for <linux-scsi@vger.kernel.org>; Wed,  9 Sep 2026 09:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788946411; cv=none; b=Teim/bXCdcuUQyOdablOGbu3AVy9n3WFvZjRXJkGd3UIFFt80c80WPNimy3SnjvQiwk2gvCs5OJypk59eGrKcaNRXiSsSrOCt/Wi5f7SdZHbovYmFJ575ZOAy+ME4c6zTWiO2kNJXEhvqQ/zfL29vqmX/sZd6SEieKOMCDeOCnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788946411; c=relaxed/simple;
	bh=oYm9hZ9oiO9Bjj0eMQMf2WQxoTXXj32OWZHcxdpZtLA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=ri++lWOhBIsJLSxwePJitKdC8egoM+mv0ckJ7fAVvVtgxGwUHeEx01qwZUoDBF1LMUkKlqLIwPWLiYpXkI4Nh6xFytMhMb/QFTNaQFZ2PSW3dqawjFeFSLo0f0RmRUuIqp/N7sBhsc6ZLirbkVIzRWwAuhNBhs0uviqEDFjqRbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=C/kV9M3W; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="C/kV9M3W"
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20260909093317euoutp014b7c7b816d6cb91aa7482d096ee97720~TnUUoVh6C0830208302euoutp01a
	for <linux-scsi@vger.kernel.org>; Wed,  9 Sep 2026 09:33:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20260909093317euoutp014b7c7b816d6cb91aa7482d096ee97720~TnUUoVh6C0830208302euoutp01a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1788946397;
	bh=zfo8YHC50Fl3ZDYN0nijYPMjYSxHIoKJMO4F8frAXnU=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=C/kV9M3WRkFTIiHUJ8QOf7pYfyOw1aBdcGtpVshU7iADJls+5G5Y/T0CnXV1edH1N
	 hctXOFL6mdtwRf0+dLYQJkrQapMtxjuEHvnqiKRWzNGvxCBsqWlbkpYyRu4Mt1ivjc
	 OeTpprLX7QLGy3VH+Y5XHvsyrM1OSac2eb0MvMoo=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20260909093316eucas1p29c13790e88a78fc6dee44d78e1498080~TnUUAa8EZ0620106201eucas1p2j;
	Wed,  9 Sep 2026 09:33:16 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260909093315eusmtip27dce3e492bedeac71737c1cb92630b08~TnUSkSu-H2587025870eusmtip2v;
	Wed,  9 Sep 2026 09:33:15 +0000 (GMT)
Message-ID: <565dcd03-4787-4e0f-a37b-9d04a9296b78@samsung.com>
Date: Wed, 9 Sep 2026 11:33:14 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH] dma-mapping: rename dma_opt_mapping_size()
To: John Garry <john.g.garry@oracle.com>, robin.murphy@arm.com,
	joro@8bytes.org, will@kernel.org, axboe@kernel.dk, hch@lst.de,
	sagi@grimberg.me, James.Bottomley@HansenPartnership.com, mkp@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, John Garry <john.garry@linux.dev>
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20260831093620.3481337-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260909093316eucas1p29c13790e88a78fc6dee44d78e1498080
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260831093715eucas1p296758c633e8ab3c48b3070ae4f5e2f1f
X-EPHeader: CA
X-CMS-RootMailID: 20260831093715eucas1p296758c633e8ab3c48b3070ae4f5e2f1f
References: <CGME20260831093715eucas1p296758c633e8ab3c48b3070ae4f5e2f1f@eucas1p2.samsung.com>
	<20260831093620.3481337-1-john.g.garry@oracle.com>

On 31.08.2026 11:36, John Garry wrote:
> From: John Garry <john.garry@linux.dev>
>
> Function dma_opt_mapping_size() implies from its name that it returns a
> target or sweet spot DMA mapping size. However, it is just an upper limit
> optimal DMA mapping size. Above this size, DMA mapping performance may
> significantly degrade.
>
> Rename to dma_max_opt_mapping_size() to reflect the real behaviour. Also
> rename the internal DMA mapping symbols to align with this.
>
> The DMA API documentation already described this behaviour properly (so
> there is nothing to update).
>
> Signed-off-by: John Garry <john.garry@linux.dev>
Applied to dma-mapping-for-next, thanks!
> diff --git a/Documentation/core-api/dma-api.rst b/Documentation/core-api/dma-api.rst
> index ba23a472f7948..69d4ebe4f96db 100644
> --- a/Documentation/core-api/dma-api.rst
> +++ b/Documentation/core-api/dma-api.rst
> @@ -154,7 +154,7 @@ others should not be larger than the returned value.
>  ::
>  
>  	size_t
> -	dma_opt_mapping_size(struct device *dev);
> +	dma_max_opt_mapping_size(struct device *dev);
>  
>  Returns the maximum optimal size of a mapping for the device.
>  
> diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
> index 58c624513cd43..1b26c9ce4aabe 100644
> --- a/drivers/iommu/dma-iommu.c
> +++ b/drivers/iommu/dma-iommu.c
> @@ -1762,7 +1762,7 @@ unsigned long iommu_dma_get_merge_boundary(struct device *dev)
>  	return (1UL << __ffs(domain->pgsize_bitmap)) - 1;
>  }
>  
> -size_t iommu_dma_opt_mapping_size(void)
> +size_t iommu_dma_max_opt_mapping_size(void)
>  {
>  	return iova_rcache_range();
>  }
> diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
> index da93b505d2394..d87d268037d81 100644
> --- a/drivers/nvme/host/pci.c
> +++ b/drivers/nvme/host/pci.c
> @@ -3747,7 +3747,7 @@ static struct nvme_dev *nvme_pci_alloc_dev(struct pci_dev *pdev,
>  	 */
>  	dev->ctrl.max_hw_sectors = min_t(u32,
>  			NVME_MAX_BYTES >> SECTOR_SHIFT,
> -			dma_opt_mapping_size(&pdev->dev) >> 9);
> +			dma_max_opt_mapping_size(&pdev->dev) >> SECTOR_SHIFT);
>  	dev->ctrl.max_segments = NVME_MAX_SEGS;
>  	dev->ctrl.max_integrity_segments = 1;
>  	return dev;
> diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
> index d689b9ed08a6c..aaa47552a215c 100644
> --- a/drivers/scsi/scsi_transport_sas.c
> +++ b/drivers/scsi/scsi_transport_sas.c
> @@ -223,8 +223,8 @@ static int sas_bsg_initialize(struct Scsi_Host *shost, struct sas_rphy *rphy)
>  
>  /*
>   * Set shost->opt_sectors from the DMA optimal mapping size, but only
> - * when dma_opt_mapping_size() is strictly less than dma_max_mapping_size(),
> - * indicating a genuine optimization hint from an IOMMU or DMA backend.
> + * when dma_max_opt_mapping_size() is strictly less than
> + * dma_max_mapping_size(), indicating a genuine optimization hint.
>   * When the two are equal (e.g. IOMMU disabled / passthrough), no real
>   * hint exists, so leave opt_sectors at 0 to avoid bogus optimal_io_size
>   * values that break filesystem geometry (e.g. mkfs.xfs stripe alignment).
> @@ -232,16 +232,16 @@ static int sas_bsg_initialize(struct Scsi_Host *shost, struct sas_rphy *rphy)
>  static void sas_dma_setup_opt_sectors(struct Scsi_Host *shost)
>  {
>  	struct device *dma_dev = shost->dma_dev;
> -	size_t opt = dma_opt_mapping_size(dma_dev);
> +	size_t max_opt = dma_max_opt_mapping_size(dma_dev);
>  	size_t max = dma_max_mapping_size(dma_dev);
>  	unsigned int opt_sectors;
>  
> -	/* opt >= max means no real hint was provided by the DMA layer */
> -	if (opt >= max)
> +	/* max_opt >= max means no real hint was provided by the DMA layer */
> +	if (max_opt >= max)
>  		return;
>  
>  	/* Clamp to max_sectors to avoid overflow in sector arithmetic */
> -	opt_sectors = min_t(unsigned int, opt >> SECTOR_SHIFT,
> +	opt_sectors = min_t(unsigned int, max_opt >> SECTOR_SHIFT,
>  			    shost->max_sectors);
>  
>  	/* Guard against zero before rounddown_pow_of_two() */
> diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-map-ops.h
> index 8fae2b7deb20d..eee6de5188c76 100644
> --- a/include/linux/dma-map-ops.h
> +++ b/include/linux/dma-map-ops.h
> @@ -60,7 +60,7 @@ struct dma_map_ops {
>  	int (*dma_supported)(struct device *dev, u64 mask);
>  	u64 (*get_required_mask)(struct device *dev);
>  	size_t (*max_mapping_size)(struct device *dev);
> -	size_t (*opt_mapping_size)(void);
> +	size_t (*max_opt_mapping_size)(void);
>  	unsigned long (*get_merge_boundary)(struct device *dev);
>  };
>  
> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index a3e880649fa41..efde0e5a58dc2 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -207,7 +207,7 @@ int dma_set_coherent_mask(struct device *dev, u64 mask);
>  u64 dma_get_required_mask(struct device *dev);
>  bool dma_addressing_limited(struct device *dev);
>  size_t dma_max_mapping_size(struct device *dev);
> -size_t dma_opt_mapping_size(struct device *dev);
> +size_t dma_max_opt_mapping_size(struct device *dev);
>  unsigned long dma_get_merge_boundary(struct device *dev);
>  struct sg_table *dma_alloc_noncontiguous(struct device *dev, size_t size,
>  		enum dma_data_direction dir, gfp_t gfp, unsigned long attrs);
> @@ -326,7 +326,7 @@ static inline size_t dma_max_mapping_size(struct device *dev)
>  {
>  	return 0;
>  }
> -static inline size_t dma_opt_mapping_size(struct device *dev)
> +static inline size_t dma_max_opt_mapping_size(struct device *dev)
>  {
>  	return 0;
>  }
> diff --git a/include/linux/iommu-dma.h b/include/linux/iommu-dma.h
> index 060f6e23ab3c8..fae5d50e4f277 100644
> --- a/include/linux/iommu-dma.h
> +++ b/include/linux/iommu-dma.h
> @@ -39,7 +39,7 @@ int iommu_dma_get_sgtable(struct device *dev, struct sg_table *sgt,
>  		void *cpu_addr, dma_addr_t dma_addr, size_t size,
>  		unsigned long attrs);
>  unsigned long iommu_dma_get_merge_boundary(struct device *dev);
> -size_t iommu_dma_opt_mapping_size(void);
> +size_t iommu_dma_max_opt_mapping_size(void);
>  size_t iommu_dma_max_mapping_size(struct device *dev);
>  void iommu_dma_free(struct device *dev, size_t size, void *cpu_addr,
>  		dma_addr_t handle, unsigned long attrs);
> diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
> index bf2651a70b7c2..82e701648d604 100644
> --- a/kernel/dma/mapping.c
> +++ b/kernel/dma/mapping.c
> @@ -1012,19 +1012,19 @@ size_t dma_max_mapping_size(struct device *dev)
>  }
>  EXPORT_SYMBOL_GPL(dma_max_mapping_size);
>  
> -size_t dma_opt_mapping_size(struct device *dev)
> +size_t dma_max_opt_mapping_size(struct device *dev)
>  {
>  	const struct dma_map_ops *ops = get_dma_ops(dev);
>  	size_t size = SIZE_MAX;
>  
>  	if (use_dma_iommu(dev))
> -		size = iommu_dma_opt_mapping_size();
> -	else if (ops && ops->opt_mapping_size)
> -		size = ops->opt_mapping_size();
> +		size = iommu_dma_max_opt_mapping_size();
> +	else if (ops && ops->max_opt_mapping_size)
> +		size = ops->max_opt_mapping_size();
>  
>  	return min(dma_max_mapping_size(dev), size);
>  }
> -EXPORT_SYMBOL_GPL(dma_opt_mapping_size);
> +EXPORT_SYMBOL_GPL(dma_max_opt_mapping_size);
>  
>  unsigned long dma_get_merge_boundary(struct device *dev)
>  {

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

