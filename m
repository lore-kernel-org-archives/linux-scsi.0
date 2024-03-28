Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5893FB9F;
	Thu, 28 Mar 2024 04:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711601608; cv=none; b=OfQo2OORoS3/6dEnebGFRxc9Eukb6A909n+o0UqaWSKZZ2bqvgHB894d5OoClADsjVeVkIe2xmS0cZJeWsCowoBD+keBfv1OAGYf3iTuhX6TvVvZ+ZUpikqG8fynp5OcqQOxQuzHjYDryNhxxc5p9K9e8qKPnR9FVukzKDxxBkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711601608; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UNl1iQzqvv3nhXomIs6SVuR0kEZR1Qrgn6vvXxSW4dkjFIIBQIRhIPs1vauNxgyTl9UWguugXXroVCIRx1QKSGTe9Gb7WbfnSsSY4E+cgQQLr8thgdEqOZVdsXrnllvfCWJuiU5FXPbQI7ESOp3T6HkySbkYDvp2uCQvv8DT/00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 38EB068B05; Thu, 28 Mar 2024 05:53:24 +0100 (CET)
Date: Thu, 28 Mar 2024 05:53:23 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 29/30] block: Do not force select mq-deadline with
 CONFIG_BLK_DEV_ZONED
Message-ID: <20240328045323.GM14113@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org> <20240328004409.594888-30-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240328004409.594888-30-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
