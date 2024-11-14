Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854BC42052
	for <linux-scsi@vger.kernel.org>; Thu, 14 Nov 2024 04:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731557805; cv=none; b=FTnSotECyzjO2UZSE5ehPPFRttCAL+8LOniV8mR5cMI5Sk88rfcTKF2w11lScy/KTXbfYtAbkW+yFDOM+NBkprbDmY65vR4Yvs2OeVNsMXXZ4Ple0laKX5bjnlaMKU07dczgI3LgAsIeZNyOLEvCyjADBPbIly3N9US2B+haNRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731557805; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hmgSmFBYTYkdm0ccJl7Rwf9+Nqb5RD7bLY87g8dhk9cY2MCq58mlLL/ESjyIcn6DuTiLjEGtjiLmM9KR5n/rkpXK+2xaxgXgURqfG3u5IUi37MGx792Le2xZzBo9kzbGsvfQyhrO78bM/IV0PPIw+Rb+6JrtT3xglgzdNY0BV2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LyfvNu79; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LyfvNu79"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=LyfvNu79HqccyGuaunc1ctUMSh
	lUQvUdp0LQjushe6fc2q5iythx14gpQ8hoWrbRgCo4pAgAgJOEMY0sjgIn30qilc68pYzwgm3XHQq
	oSTcGRAmln/WcegfW+4PmzsgWwIVmLDIjfwRpsHWCxqr6NBsoOHej5ZMnK098n4JBlk7c10lPJwGL
	BJjnCPhJ8i20RyAPIQIT170u6lAhdQlPhaKcbvKeQxik+Qk7bBAhQNMD/73JtAUMtSrtudkilUmYr
	w/M1jHhmR+AQRSSYzRrKNj9PnBkqTxTSb6X4QBkxVsLbPjTSBEV5YtT2Ums+1nMr4ZJ7zLiHJO2mR
	Zep6PrnA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tBRHf-00000008kYI-0f74;
	Thu, 14 Nov 2024 04:16:43 +0000
Date: Wed, 13 Nov 2024 20:16:43 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Magnus Lindholm <linmag7@gmail.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com,
	hch@infradead.org, martin.petersen@oracle.com
Subject: Re: [PATCH v2] scsi: qla1280: Fix hw revision numbering for
 ISP1020/1040
Message-ID: <ZzV5qwQv_bQTaYSS@infradead.org>
References: <20241113225636.2276-1-linmag7@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241113225636.2276-1-linmag7@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

