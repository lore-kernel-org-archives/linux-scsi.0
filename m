Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795188022;
	b=pxK9X4ZGht4FQiRdTSBlQsbUz+nMysByGLjgbIdMTEExINLPQtTkX6h+IYlwmJvctiZC
	 h7wF6iNFp4Wz6AtSqPZUZ+CdcstOSWAU4Pg2ERbPQdKad05/bvgrUZltQJ35vgxyd72RT
	 lVpElEEtNsXjSEwKuwA94SjBpuCO0i9v0r7tzXWwYXmOyETL9y+Ir6JnLK6HEpEsCaz/j
	 cy+ZIq+uFlWKlDkpKEGo9FUzBLvRivhUpvr8sPjA8n1m/CYde5hVHoxukm2Fl2c/vptmU
	 w5svQhXvvvM9A8tn1A1SV58dU2zIN9xZn/h1SZjwSXiy0/fNru7PZh2rAvg5UnxtwUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795188022;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=Bvhz4wKfsw1PUr2Vi3dlpuAn+9L8okzs1G/4CgcOsePTF49OZP1jdfZfacOFXlTRz2pq
	 +Dz7U2gO/Jyvo4DceLIOUi6Z+zgqqU3SBm178bLta2UANe/V+B7Tm/fEv2HICBt4Sz2Te
	 AoRInlY2h90qBVwv4RXP5T7yMUqNg9R6aE1hSFpEmajQhe/m2ziFHkWIJp6iKlzPqna/6
	 K9YbCl44+evNvZ1FPTEdJI6PQXhI9jpjKLVUJyK0BF9G/FuRrR94GIesHqxQ4bo7jlR4o
	 K0I2pON8Dq8FDpkD7LDGDF81OSck6tIZdiOo3l40IVLVK9Sxueg9s/pLzL2I3wsfyrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9B7606A325;
	Fri, 20 Nov 2026 15:20:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B9B7606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 45DAB6732A; Fri, 20 Nov 2026 16:20:10 +0100 (CET)
Date: Fri, 20 Nov 2026 16:20:10 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v11 06/13] zloop: fix ordered zone append handling
Message-ID: <20261120152010.GA26913@lst.de>
References: <20261116213702.225970-1-dlemoal@kernel.org> <20261116213702.225970-7-dlemoal@kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116213702.225970-7-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

