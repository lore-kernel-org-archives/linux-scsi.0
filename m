Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B7D12AACF;
	Tue, 26 Mar 2024 06:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711433115; cv=none; b=RCMaOIZh9nd8oe1i0MapW3K4AgK7KiiCyi5jMSbtm8t72TJ3cXS33kzAtoJ1wLVC/GjPo4CeLo8WI3CQtaVCvBeHa5mPZ661B7nBvgvcSShDtCCAK3xdz5gBvOA0Z8a8maTmGsaP37DTfCo9DJFWpYqiDBqqezJx7C7XMHZj3dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711433115; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sieOd2A3cph4AE04Vho0WzV+K6zr0UySKAyN77oaJYbQ4iDhRLfdFkf7rrlFK4+ETWYmdJVX7ulUtlta8aAgkwvL1fdE8EXc1yxXBJLffGjI8bP00U73+xTMcXSFGmnoxqlflfR8nfbZsHC/eu/tLD3+bpnE8DpfR+3vVos0iYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id F08E268D3F; Tue, 26 Mar 2024 07:05:09 +0100 (CET)
Date: Tue, 26 Mar 2024 07:05:09 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 01/28] block: Restore sector of flush requests
Message-ID: <20240326060509.GB7108@lst.de>
References: <20240325044452.3125418-1-dlemoal@kernel.org> <20240325044452.3125418-2-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240325044452.3125418-2-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
