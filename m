Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E5937714;
	Thu, 28 Mar 2024 04:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711599040; cv=none; b=n7IlfMNd+TxxAGodf8kuv2N5Le1nRLcdsMwOz6wXvAfm98VsHfdBiu02dIo2+mO3eQfsytkRTTSCY45oyrHi0awyxCoK2DNxsX5fQpgd8POBqrUV7tsU/+woQbuNYWKQkLPA6p2GMIt3OmeyxOYzJTmqT/cQDOWCmR4PxYM0ZrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711599040; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qjAVNvl5hv0kimcNgYOUOyU4cN/E9Jpz0vkg/6RhKW3WlxkqSR65Oe9yfS4Cwqqdr0P+s+Wp+cIFyp+E5PZMdS8uSKbXCZkPnq8XIBk93xLw5tQTbmwRrcVl6DCRoIEp71YEgczDJmTnrODIZtVyf5avnSotrXglGzOwSQkyLrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 25AF368B05; Thu, 28 Mar 2024 05:10:33 +0100 (CET)
Date: Thu, 28 Mar 2024 05:10:33 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 01/30] block: Do not force full zone append
 completion in req_bio_endio()
Message-ID: <20240328041033.GA13510@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org> <20240328004409.594888-2-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240328004409.594888-2-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
