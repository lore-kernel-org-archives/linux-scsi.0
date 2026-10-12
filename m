Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4FAA3BFE4F;
	Mon, 12 Oct 2026 14:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791815895; cv=none; b=FKkXMLXCw4vwx9D/K9VLKjSteyJMI2L1pGNuH5Zb453feHU8qybNUrZetKxwbTRDamuRxe05nax4p34CDdVTBuYJu+Qv6mALE0WdNc5/aXL1kRjVMBbPGktIiXIOSzhqU5APHv2MyZtCBk1WzhMZA43Ku6lvn9rIsc0qRn0JeTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791815895; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c8+5aHD3U6NiW5kP3NaK25lTnBWRijnEq42p76GmB230u5571/rMBvO5LAH1DXygTeKWefRNxiKiRWW5nUzmogj4dK9WntK7tseQvla0mPoSq75WN0u1brA0NUMuiYhMcBylg0o81I+7xqlrcbri57peIhx6InyMHhocM+3cRsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5C64A227A88; Mon, 12 Oct 2026 16:38:11 +0200 (CEST)
Date: Mon, 12 Oct 2026 16:38:11 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v5 9/9] scsi: sd_zbc: define storage element management
 operations
Message-ID: <20261012143811.GE8609@lst.de>
References: <20261012130121.1902634-1-dlemoal@kernel.org> <20261012130121.1902634-10-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012130121.1902634-10-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

