Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209794C0424
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jul 2026 14:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783001503; cv=none; b=KoylfKb1gWzpb9WJkbuRKxkt9t5CPMgOMzo5ecdhrSf98Dl8Yx6s7GbKXV1TiRRznNTwnLB5+xQ0DiQDg7++8/MtpcyXRQuU51OnRTliZs/Dcy3UFjjrng4zUZxCcbKWit/wReQaH/2mmc320MT3P+pXoXQuVlDOnReBJoO3TC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783001503; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nlmiwEL5UUDfQhaU17CtSZjWEqocYL1DijJtmHnytqy04JQqDgn6PjjJYxguRvu0STJIxWa/wTz0CAFsoKocnx3PgDGQXKiMEYJIBeRO+Ne00vjd4TQ8/eDRws24S7RuEMFReTSRqGQfaRi5x+G454ILE1KTHx3EjtULbFlGClk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A019C68C4E; Thu,  2 Jul 2026 16:11:39 +0200 (CEST)
Date: Thu, 2 Jul 2026 16:11:39 +0200
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
	m.szyprowski@samsung.com, robin.murphy@arm.com, hch@lst.de,
	linux-scsi@vger.kernel.org, iommu@lists.linux.dev,
	ionut.nechita@windriver.com
Subject: Re: [PATCH 1/2] dma-mapping: make dma_max_mapping_size() return 0
 for no DMA capability
Message-ID: <20260702141139.GB22720@lst.de>
References: <20260629085310.2298552-1-john.g.garry@oracle.com> <20260629085310.2298552-2-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629085310.2298552-2-john.g.garry@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

