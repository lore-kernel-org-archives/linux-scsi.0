Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C445F85272;
	Fri, 24 May 2024 09:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716543524; cv=none; b=uLDWdltejMmHKgv+t6XreVvZbWC9o/zO7fkauBT6UsjLXCFu+jlpIuL71Wn2WtKiqQ2nYDrBdwfvpKDLnSfb3VuKSdBNQ/7SlFCleSJ35AAAku83EC/PM+/A/tadTDPUFl0KYduwjS86QOw/TVP3w9dIGn0kI1X4t674ygzbvzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716543524; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b6NEFKqNGfkRwuTYfNIZ8tPt/rjF5J/lNVDSuCF09Ex/wOV3DpGPIs8Bjg0ENs2jpbc82IMDAsjw9jFzUVEf2U/EMzgzdZQEU5529ik9yAKbJikzo13JC2g0MVNhfPEU9enjn96MnCsxQffgU3EhtHfbvpbV4AA9ndvrfXX97SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9E4E768B05; Fri, 24 May 2024 11:38:38 +0200 (CEST)
Date: Fri, 24 May 2024 11:38:38 +0200
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: axboe@kernel.dk, martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com, hch@lst.de,
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
	himanshu.madhani@oracle.com
Subject: Re: [PATCH 2/2] scsi: bsg: Pass dev to blk_mq_alloc_queue()
Message-ID: <20240524093838.GB25514@lst.de>
References: <20240524084829.2132555-1-john.g.garry@oracle.com> <20240524084829.2132555-3-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240524084829.2132555-3-john.g.garry@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
