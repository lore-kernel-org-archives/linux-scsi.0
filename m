Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EEDC7262B;
	Mon,  6 Apr 2026 06:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775457350; cv=none; b=PtzvNIMxXkECpmdKs2d4g+xn0GXELWtqeVk1v3A3HUyEsAjsiP4rjxu71SZXkgpdYsv6T2TJJoKmzh3hlDWh4fXtVt1R5lqdXH1nVLSfLOVUdoYCFqIHAt1+CscK0G+ZjKezHa1QwG1hlzrBuP4WMNzJLIasGBZw9zkFLwkcTIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775457350; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m+cm9+w7EIw2z10Wk02hBSSP2XbZxunult1spR1Miq6w4/L88NOrbFigX3WtdhtdW4l//8goCNooaEQacWbN6K6w7jaWWArIk1fcvLcEzgkP155V9BaNli65bcakWpUIUrfd2MKiONjp6LEAvAh8HLX3lQpjn4maywcFN09Qayg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Hkzwi8BW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Hkzwi8BW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Hkzwi8BW3I0C9eN54/FSoDpBYx
	6fg2ND555VKj0arSWZ51nu4p+9tQLww8ian8fEvSXf8sAoCOpgP8SyziBHebg7j2hGbz9+yfUZkIT
	/yMpeHqIssu3J6GPBynBcSab/c36ke+khCAgeyd2jNO3DD1vsafsYl4Lf263WHEc/Twp8jeIWOZ7r
	HeX83YsejV72rRQ0scT+qFlXlp/bNFUTpeff5kXsGSDvjql1VWynMy3krBpdK9H1E918MpawJ1qIG
	TZxlxKRObxiZSudKm00EfDQiwHnoH0sDPZeTAjgvDTLuNOQrK1E9SS3mY6SgSi6XhY2saWDX4BTfT
	pgqYN4cQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w9dYp-00000004qqT-1md6;
	Mon, 06 Apr 2026 06:35:47 +0000
Date: Sun, 5 Apr 2026 23:35:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: Re: [PATCH 3/6] bio-integrity-fs: pass data iter to
 bio_integrity_verify()
Message-ID: <adNUQ3j9EAsVv_5o@infradead.org>
References: <20260403194109.2255933-1-csander@purestorage.com>
 <20260403194109.2255933-4-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260403194109.2255933-4-csander@purestorage.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

