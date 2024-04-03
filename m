Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8716F13443A;
	Wed,  3 Apr 2024 09:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712137397; cv=none; b=ZH/stshtDQKUhvcU0inetO9P71K1O4NQgnCD745LcQASTpWrpuwuKFK6pNpy/SFiqBGku3tp6yhe9AZ94HXZs3L7mT8RVeXCu0qjquOC+sO/Y8LLZq4UFGu2224tuGXgjzEOm8RGQk0GzcF+9KM+y7B4DGJPLzRsHraYhz00uTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712137397; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f8QeKZ7i0AhgqzWiwpMpsFTeyRTThA2cqstaXjdSHK2qt4FPrJGxiQiSIawLVV79TZI+V6CoATA8llumL02E2yZaGCzuo7omf3dTb0zKyMkpdUAIfsVe/rll0auUvEm5zygUDiMbi0xt5Q4TXH1RiI7frVyrzAiXmicu/OU5IiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AA82568BFE; Wed,  3 Apr 2024 11:43:13 +0200 (CEST)
Date: Wed, 3 Apr 2024 11:43:13 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5 08/28] block: Fake max open zones limit when there
 is no limit
Message-ID: <20240403094313.GB4828@lst.de>
References: <20240403084247.856481-1-dlemoal@kernel.org> <20240403084247.856481-9-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240403084247.856481-9-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
