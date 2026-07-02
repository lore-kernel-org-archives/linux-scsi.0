Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0F84C8FEB
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jul 2026 14:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783001560; cv=none; b=C5nKHn/4otom6U1FPt+MsiMJS5VLu5uyOEXBGNAAfqVAOHLyP/9KTu8gwNQcjShfu62Pu4x4c8wT7kx5SK3ff98EzwaHulqV6qyqAWxl9pAHDDgJ+FcYwryDoTqjkkSqFp4p4fSMAd+LphPJOWzmn/P22EvMnxOLmb7mzXNSdQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783001560; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o50R89dZxl7LaTT6N4WqRU+dJjdMtELrAzOHnGlIUggnw5WNURQrAVIh6AtvC58YOzWs+vYbnl4cQ8nPg3ZUG1bAKvM+1NMM4AB2lrGXUUg3rFLfmb9Gd79t3QQ+QzNDMry59jS6vXnc5din7Cbkt0Vv/ISvOsHXirwQ4n1K0zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1B4A868C7B; Thu,  2 Jul 2026 16:12:36 +0200 (CEST)
Date: Thu, 2 Jul 2026 16:12:35 +0200
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
	m.szyprowski@samsung.com, robin.murphy@arm.com, hch@lst.de,
	linux-scsi@vger.kernel.org, iommu@lists.linux.dev,
	ionut.nechita@windriver.com
Subject: Re: [PATCH 2/2] scsi: core: Drop dev->dma_mask check in evaluating
 max_sectors
Message-ID: <20260702141235.GC22720@lst.de>
References: <20260629085310.2298552-1-john.g.garry@oracle.com> <20260629085310.2298552-3-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629085310.2298552-3-john.g.garry@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

