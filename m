Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0DDC191F9B;
	Tue, 10 Sep 2024 15:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725983358; cv=none; b=h0FOZ785QyqGElL33zZBh3yzP+PSh9swfiCToanNF0dro027lWwN6ri+kmZE/xA5qN1Ryb+aaP75J9IZfkTzuaETUD6iGPjbC00mHR2/kNO4m/TWHL5Qa3GbzuLQv6wqKnizXvPKrEYXbjgeuyS8au25lhmHjV7KbMDH3PyJeYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725983358; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bq/dkfzKBd5XPC7Q3OKObqAWtBGLKm82LiUrU9yRaKopA0li+L8IoiJG3nloav6Ti34aLaQ0lwrDetFM1ZK1MBEQxXoJqVZPpljn8tMdtTYIOBbPbEBEeUadOFbbDPCZajzeP0+BGu3p+zYWadkXOBmxaaR6Fl5vpz9eUk/Vf68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7686568B05; Tue, 10 Sep 2024 17:49:13 +0200 (CEST)
Date: Tue, 10 Sep 2024 17:49:13 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, sagi@grimberg.me,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv3 10/10] blk-merge: properly account for integrity
 segments
Message-ID: <20240910154913.GJ23805@lst.de>
References: <20240904152605.4055570-1-kbusch@meta.com> <20240904152605.4055570-11-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240904152605.4055570-11-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

