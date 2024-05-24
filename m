Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4A882872;
	Fri, 24 May 2024 08:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716538248; cv=none; b=ETqXzJOaW0BSvdWYCeJLvYWw0c5cZ7gI7OJCw2x0uwwUHrTj+YoCOrSkqiXFH7jBRotKAxtivxljaqHRnO8/ttuew/6qPuGhSIFa+/PKYK7FdD36SR7vDwQFY5pLXPi3Ema8p2/b24r/gsQ0jN5cqTdaJuVxJhAyBlETVRcUXNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716538248; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gwpo7Q778egMKmCak62nXOQm+66NPTUDXDuATGO4o+WKPVGc86jvX84G1pkvtW+YlSUdaC4TJKrNhZ3l0+AFfBDWnulNTR0WXXYZsCj9gchyUDnpUYrKqS/V/GUmJU9DNbMOhHqC0+2frhBWJZhnINkYWi79Xq/RWezaQnIIjS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LJ8M8Ldu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LJ8M8Ldu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=LJ8M8Ldu3rYZKRj6KgFkCCdw5Z
	ZlRwwe6kR/km7kPntI1+cW4Cs/oZqz+I30xzCb29jszk4o954XZKy3G21z1vZ6kw8+ZVPZzUPmA/Y
	okcE+FPo62FWEHZSoXGnZAS5VPeapj6DrcJGt1RtKmtB95ANJTtCmxr6WCjAm3Trc9WTvZ1PVrzy7
	eSN+ogMm1zZGtAcm2gAtNWc1uBHV2pNu3nlSL0VUnoZSp86b3WzvvrYw8XlaknMPbWEzKh3JKqb0P
	h2EMgOvTdAHJ4eqc/xO9/x+QthtLzcvN9IleoclH/hLOKF1HPJAeezw1baCr8edOV10EQ0cOK2qFq
	p/LhPq1g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sAQ0k-00000008LfA-1ts7;
	Fri, 24 May 2024 08:10:46 +0000
Date: Fri, 24 May 2024 01:10:46 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org,
	Peter Schneider <pschneider1968@googlemail.com>
Subject: Re: [PATCH] scsi: core: Handle devices which return an unusually
 large VPD page count
Message-ID: <ZlBLhpQA-2iSXvaL@infradead.org>
References: <eec6ebbf-061b-4a7b-96dc-ea748aa4d035@googlemail.com>
 <20240521023040.2703884-1-martin.petersen@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240521023040.2703884-1-martin.petersen@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
