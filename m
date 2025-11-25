Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8894828D8F1;
	Tue, 25 Nov 2025 06:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764052331; cv=none; b=tutzagnvND7EhyP/PBCWkHIdl0dICSidJmrVyOM7toAWUNL2CtVNTLIpEkOHocz7IdzrENby+lcjGMhVtQGCd052dlH3pXbCRj8JULH3lO/UKDprwlog6VK4+Nyxrv/MRqIRpC59rG7pnKXPCiFHTM+FeOXd0QC0nUK/mzT5R8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764052331; c=relaxed/simple;
	bh=o5D3QieV1WPDDyxNHVYaUpvgcKnckOs8bDfkWeLbZss=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F2cNPJ8m3CyQEA8TO6835br/W1c1WmQ2ZXtL+g55wLv93quLBHbw15MkkkSS45pmBC3gSL447j1Azw45eNlMZ3HmnhL8sKRYq+Prt495dk+egXj1KuI0d8Alr+wwsbLr8dpG40xC6uo1FWk5sdM4OYIUWstn04b4mx25m/YDLa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XcvZrkNu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XcvZrkNu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=o5D3QieV1WPDDyxNHVYaUpvgcKnckOs8bDfkWeLbZss=; b=XcvZrkNuIoZYcURBVitDMmv7dO
	CV/T8Qx0Yfnqk3GjXffUB6x3fOvLVni+7yKkUGAWpDcv0Qax5YOB5ZoTsc6HpUV5Lpp98a+3kV6KJ
	o0rqtotEQMfjAG6gyKVmmiQIY9UXzeugm/4jeP+HKs9U0jqoGLaPotAvFGQ6DT2yhqjuPOJYeiQ2d
	5yMv8tWhZN3AmD8Fhzh21pR22hfevmrRW1v6ivW+GMKsrw2yaWusnMK5TVQiLcIPL5E0YYLIUKbcT
	dNzuhApmfpPBZOA66ngkUXNP0Uz7ZKSMgB9rPLQfFhJscpI2W5nyNEav60gVg9A0kdLifPpiEP1tg
	DS6ePBMg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vNmau-0000000CpOD-3gdN;
	Tue, 25 Nov 2025 06:32:08 +0000
Date: Mon, 24 Nov 2025 22:32:08 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@infradead.org>,
	Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH v2 1/5] block: Introduce __blk_mq_tagset_iter()
Message-ID: <aSVNaLyqg08-GAzN@infradead.org>
References: <20251124182201.737160-1-bvanassche@acm.org>
 <20251124182201.737160-2-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251124182201.737160-2-bvanassche@acm.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Why are you Ccing me on what appears 4 out of 5 patches, missing one
and the cover letter?

