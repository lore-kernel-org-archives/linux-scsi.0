Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25377E59A;
	Fri, 24 May 2024 09:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716543510; cv=none; b=LVeVOv0rtLOghH9eBxrSHksOMVSruEdzrg92bfyaKbfBHpgliY/XASWCU4LIR334z5HTA9aNKUqlMDcgl13A4WhvxirBK54Bz/WjoiVCyOSSvpDBapqMTRDD5phVfIL0S2rnFu0h9hbd2B2OY3o2z2gJclcf9jzrxAnF1T8mutI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716543510; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KIr1yV+StAWxJhgo8uL0dzmYxbjIJvATD07E10xPrULT5AMmU4JIhU54G3oJKdukqs1On/WI/LM+8pEaWayjPAPK2RObe7GaWfzfFG154TqB/taGswgH9FNbEjdk5y/OhQlbyDrhsmEk+BTlNbFGuushm5QlYccWjX6FAneYxso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B27C768B05; Fri, 24 May 2024 11:38:23 +0200 (CEST)
Date: Fri, 24 May 2024 11:38:23 +0200
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: axboe@kernel.dk, martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com, hch@lst.de,
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
	himanshu.madhani@oracle.com
Subject: Re: [PATCH 1/2] scsi: core: Pass sdev to blk_mq_alloc_queue()
Message-ID: <20240524093823.GA25514@lst.de>
References: <20240524084829.2132555-1-john.g.garry@oracle.com> <20240524084829.2132555-2-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240524084829.2132555-2-john.g.garry@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
