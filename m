Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917EC3C4B93;
	Tue, 13 Oct 2026 14:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791901083; cv=none; b=nn/HlObDiSBz6QleImRrj7G6pA2TALcG2bD6QYNk8yyo+p55coaAgJpa/xhRQEAMren8eJKYadgo6vy9IjXBNeskaza9ND3as6TGyVeC4Wy6pWuFfajvmPcgWW2ZsUrn5SICf87cd8rP/C7wvdMSLUJ2731MKxTOXDUx0YysLG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791901083; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YAlexqnibx28LeXCzx5eARuIPyXKzUDYCJ2QVs3kRupGK2XZ0lGf4KCucajbbT60QxecRTe938dJLk3nD16Wuo/G8ZHZRttQK3RWrUi7WiXvA+kLvYNJgpArOKIFn0xr2qZxs4m3B7YRlq7gLo8z6bZkmxe2EBhdBHdxnu+lL+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 26855227A88; Tue, 13 Oct 2026 16:17:59 +0200 (CEST)
Date: Tue, 13 Oct 2026 16:17:58 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v6 09/10] scsi: sd_zbc: always revalidate zones for
 disks supporting head depopulation
Message-ID: <20261013141758.GE13783@lst.de>
References: <20261013122750.2237843-1-dlemoal@kernel.org> <20261013122750.2237843-10-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261013122750.2237843-10-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
