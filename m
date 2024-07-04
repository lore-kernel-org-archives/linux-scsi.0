Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250051A00F5;
	Thu,  4 Jul 2024 05:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720070018; cv=none; b=YQn4tW9vjQLa1oU4lhnK78SEqE2IOuocsz/DcAoIT9B8gjRY+06WYrVIHQrSPrbsqZ0XuJr6jeFzUfl8HLHiTqe18Gue3H6uasV1agV9tGrY9LtohB1WsFNjcsYhrEofeuo5s1Fahlm+ElmaZGpFVZ4Xv1TDfZb+QXmwnKWcfHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720070018; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dqsZkdqkcqd63dHO04aShGbK2FZoPWxDQlZE/1u1lNPo34aS+p1DHJzyokEv0aVN5NNeBzBvaen0LXk27XXjQCwz0SbbOdsbLGsYkgz2yOhtUwIXuc5FJT30YsNflLwmhmvwJ/SRKkFqwRrWobdyO3RDUFKHcEzzHh4aIU5MRBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4770068AFE; Thu,  4 Jul 2024 07:13:32 +0200 (CEST)
Date: Thu, 4 Jul 2024 07:13:32 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Ming Lei <ming.lei@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/5] null_blk: Introduce the zone_full parameter
Message-ID: <20240704051332.GB19411@lst.de>
References: <20240703233932.545228-1-dlemoal@kernel.org> <20240703233932.545228-2-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240703233932.545228-2-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

