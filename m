Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46FC039902D;
	Wed,  7 Oct 2026 13:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791380424; cv=none; b=GQEC1RjGJOcedFESHmjxSv7litxpVoCaxaN1U5PcR1w9jkT5K9uYsKw3Wt88xToDTAbsNIMepzRqcaxKmniSamYO7HfAGy9yhSST1tUV9vbAuZ8skN6Vu4y1JzVHboZKddXQoetYtHHzkFRGKG7XYYuFF91+OUudacT4n6zkBF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791380424; c=relaxed/simple;
	bh=FPnMeekD/5d0Me+3dtqbkRXBg6pG9f7jYIlbPyLCY5M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m6pQfm9WXOIm405HpAfNLEFbChBLbmS5blrQjn6VsVhdouzSAASR5T+ePmG9H7feF8eRdCO8HG8OjMinyAKziYiSdXHLGBqX3TJIRZYPuEGAKFjUsfdwGzIQ8gnuNECdK5k28fW+ijY85OlSyhSMhrriVIf7o7fHEsvMms2zoME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 37A2C227A88; Wed,  7 Oct 2026 15:40:13 +0200 (CEST)
Date: Wed, 7 Oct 2026 15:40:12 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 4/7] zloop: add storage element emulation
Message-ID: <20261007134012.GD31906@lst.de>
References: <20261007082344.1049179-1-dlemoal@kernel.org> <20261007082344.1049179-5-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007082344.1049179-5-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good modulo the corner cases pointed out by Sashiko.

