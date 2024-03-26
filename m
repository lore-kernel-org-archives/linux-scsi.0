Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64AAF80056;
	Tue, 26 Mar 2024 06:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711435208; cv=none; b=gMdWwjQ2oklp7gtvC8mwhrC09sbHUnvxVVa3wZRIWZUlHkgBSnsPR4zweN+uCDkhKXfFPQvTzXG8PkWIb5Ikr0qaHzB3MDIiG94+SmV5oKuvHugvoOKcgSz5EGNnTzgWxue5GHyhfyKXrN+qyTZtbXUYlfLdM44ml4c2sfP/ypc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711435208; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nVK0V041Rebtbfr9y5hI8QmNnGxh6pJHm4ChRTSOI3D/MO1dKb8RMjjZso/Hl1QzXu9/qibFk2Ail/vmM/05gc0mbLFI/LKMO2RfnP1Wp0Xrs9SzCFzSAi5PIDda57rNVZy4ryuVFXQVaiVKUl5tgd7C64cVufsyMk6EXJpHBiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 16FA868D37; Tue, 26 Mar 2024 07:40:04 +0100 (CET)
Date: Tue, 26 Mar 2024 07:40:03 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 06/28] block: Remember zone capacity when
 revalidating zones
Message-ID: <20240326064003.GE7696@lst.de>
References: <20240325044452.3125418-1-dlemoal@kernel.org> <20240325044452.3125418-7-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240325044452.3125418-7-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
