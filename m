Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDFBFC02;
	Thu,  4 Jul 2024 05:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720070040; cv=none; b=BDAiBU3qpOSyVZY/kBCyoJOwy82D3jBar2WyhQMZVhysZVKe7/xLVHYK/YJ769lril8XkPGBWzZpjXU5WJWc1NcMwBUhByOsJBsoNAzlcFDQxTm6bgt9FmaOFNczqEOmXfmlAUiVAASslblJH8Oz5C4Zq+R0EKgx0dWsa7jsgog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720070040; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l2/8/4MEVU7+58Miks+OqsUM9MYailsM3Svogq/TzISisgSuEY2NjjO2HDl++W50YfKJLsyviYqDWflqCshbaqDW8wQyq0VyYndmW+dr99HRrZCVbN5ukLfiYSOQELxLBFSDltFed4qxpCp3R2tl11VioJD94wRUhyKHxiY3tXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D706B68AFE; Thu,  4 Jul 2024 07:13:54 +0200 (CEST)
Date: Thu, 4 Jul 2024 07:13:54 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Ming Lei <ming.lei@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/5] dm: Refactor is_abnormal_io()
Message-ID: <20240704051354.GC19411@lst.de>
References: <20240703233932.545228-1-dlemoal@kernel.org> <20240703233932.545228-3-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240703233932.545228-3-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

