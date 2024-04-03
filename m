Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3609E17997;
	Wed,  3 Apr 2024 04:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712119434; cv=none; b=A8DS4V50t1ioFhg/NVrYxOHstycsOo9UVt6khwLxoAXQM4eJYOBOKlOmhPKulNUDXjSRACZlUHnD8+uZo3O15AuYnOuxKhMvJQstsjda+nVuXPC1tB6yzwNqZP5gpFbsyxwEwDYJt5ZMgN8+bKjbh6iiew5oHdXOsX+pmg7o9M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712119434; c=relaxed/simple;
	bh=k8AjWpBehNsP3mtB+SJcke+IXdBkpLY0xQfSYB8Ip14=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MhaI9P652Zd2c8/MCjOsfn3byLgU9rqjCnJGtz7L79tZZjqzV1DW+r94u2q6jpA91rsuigo7yVxaF27IztGFsGAovP1YIBpf9/eLE4kyZypMtEIikoiSsJc+RBuwTRcq5kugsEVYyo84ppbnKSaqYOUGaFEeSSMkLutLpVYcp0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 249C468BFE; Wed,  3 Apr 2024 06:43:48 +0200 (CEST)
Date: Wed, 3 Apr 2024 06:43:47 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>,
	linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 17/28] null_blk: Introduce fua attribute
Message-ID: <20240403044347.GA23048@lst.de>
References: <20240402123907.512027-1-dlemoal@kernel.org> <20240402123907.512027-18-dlemoal@kernel.org> <7a3be43c-39d9-472a-9593-89a1c4e03004@gmail.com> <3b35dca4-e548-427b-a304-e21f3ee483e0@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b35dca4-e548-427b-a304-e21f3ee483e0@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Apr 03, 2024 at 12:58:51PM +0900, Damien Le Moal wrote:
> No particular reason. I probably followed the pattern around the code when I
> added it.
> 
> Personnally, I find this checkpatch warning about S_IRUGO silly as it is far
> more readable than 0444... Just my 2 cents. I can make the change if you insist.

Checkpatch is useless.  Follow the code around it.

