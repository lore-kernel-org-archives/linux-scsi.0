Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0C71552E1;
	Thu, 12 Sep 2024 07:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726127005; cv=none; b=dbjFtH0HmjLEC4cx7UPJNyTqSpJ9Cy6nRysblivWkc5XiCeAp8x8WUCT8PdCMTyCWTFd0Wj1vW7ly+jAmTux0o7QCz9Ia+A8LQlP99XL9FOFJBFGL3HwZyg4dizb5GtJMjiIuiUZMzTVdKtUaQy5tEtFigcDfjFzUxEflrhKAVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726127005; c=relaxed/simple;
	bh=5ay8Cpg82kuP8v3Ac6+SORc14pOdrqzMMcNUtX0eeoc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YDO5Wfzeh5mwFwmXWHLhY2pkQHoxjpwfi+bL1NwpFSyKsts+/zm2T2SPBk86u8ROS/bh1eGwZbU3Y3je36fHBQu5eQz4H7CqKpAXYsr7cgqHh7S7ieUILtUs6BoPLT3RhBc5Vi3U8yBmR7H/l8usuA9b72EA+zg8BrsPp8o7+nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1AC7E68AFE; Thu, 12 Sep 2024 09:43:20 +0200 (CEST)
Date: Thu, 12 Sep 2024 09:43:19 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, sagi@grimberg.me,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv4 05/10] block: provide a request helper for user
 integrity segments
Message-ID: <20240912074319.GA8375@lst.de>
References: <20240911201240.3982856-1-kbusch@meta.com> <20240911201240.3982856-6-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240911201240.3982856-6-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Sep 11, 2024 at 01:12:35PM -0700, Keith Busch wrote:
> +static inline int blk_rq_integrity_map_user(struct request *rq, void __user *ubuf,
> +			      ssize_t bytes, u32 seed)

Please avoid the overly long line here and maybe use normal two tab
indents for the second line.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

