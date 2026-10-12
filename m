Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C062481FC9;
	Mon, 12 Oct 2026 12:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791806701; cv=none; b=FvT8g218A4DWy4ziS93B6fV1wvAA28OSCFMO0EKcS7vYDxOo7iePURx7VaQ9162A80A5KqU38Je8ZxSUutVouJ/+1l6R6Pt3Z3c7ZkBqfeRmy4sj9sw2aoLzkaypF8JbcQ7shkXjsaPQEj3PjyHHmvtytYAAzWY8OLBKalUE9iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791806701; c=relaxed/simple;
	bh=PWsykM0B27fUbVqcbkoMLF6UzXoRb9d4T6+2kum4ddw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U5UyGKv7/yh7GjaqeG8ROU+onaYV6s6Rbb6K5/sddQmHo1YMWp08p1zdEsm6iEJHHn3R9NxZYl9w/jICyGwdiGjC1CcwE5mIjCJdZiwht5sCfgblLWyBB0Lq3Pito3h6H49cwrPT0PFd+Ce1cuqg1aQga9RTIzywfB9GVNGiKLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AA4BF6732A; Mon, 12 Oct 2026 14:04:55 +0200 (CEST)
Date: Mon, 12 Oct 2026 14:04:55 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v4 2/9] block: refactor blk_revalidate_disk_zones()
Message-ID: <20261012120455.GB29954@lst.de>
References: <20261009090945.1504194-1-dlemoal@kernel.org> <20261009090945.1504194-3-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261009090945.1504194-3-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Oct 09, 2026 at 06:09:38PM +0900, Damien Le Moal wrote:
> Split out most of the code of blk_revalidate_disk_zones() into the
> internal function disk_revalidate_zones(). This will allow calling this
> new helper together with other code under the zone revalidation mutex.
> No functional change.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

