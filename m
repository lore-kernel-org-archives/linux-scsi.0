Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4C4F513;
	Thu, 28 Mar 2024 04:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711601472; cv=none; b=Yz/kXYcsEJMXxRd1WUooOsFgF8+BOABx2LfOt9vGkG0YWk2YmzJBrGEV0Z9tOxijXxs/wGJEJu8pq8yk/KAwjYaWr57hfDy37g9tJNl9DIIwFC+R4sKNVO7sucTL0fkmNsNYMCAuQ5fKzBFONgEynhjTrp+1g+Mm2K7Gv1L5xU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711601472; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JYV3RjhAzoVOGPzpOeOBjmy4njU8qgugI49C6TkGMAmLSy+45d0WWkTq6Kim0oMSiaOfPDBQk2j+iVOM5wEpT7zGGCbTn4iU/7fnstzX7rpQa6+T65/pX2+O/psf3gHt7ODcTPnQzHwtYdsN1Dj3iai85EW2A3/ZG3JLLunxHxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E5E1D68B05; Thu, 28 Mar 2024 05:51:07 +0100 (CET)
Date: Thu, 28 Mar 2024 05:51:07 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 17/30] null_blk: Do not request
 ELEVATOR_F_ZBD_SEQ_WRITE elevator feature
Message-ID: <20240328045107.GG14113@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org> <20240328004409.594888-18-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240328004409.594888-18-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
