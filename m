Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3FD516DECD;
	Thu,  1 Aug 2024 14:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722522037; cv=none; b=eZgZJHiiPFH+A7ATZHD0QSt0dq9EMIzBiILjIirCJe5eb8VZru8GofiGbS2cWJUAQ3ABiZlry22QnhwV7iBc404b+IAat/nSoRlR33Sw500vfHFAC2ZJTLu4eDm2qwH0ZX/F5vDuEl/NER0BaNKn+1mGKGOmNcVNaqloxdaRuUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722522037; c=relaxed/simple;
	bh=ulUGw6GMaeZywscKFaVl2LJTatC/4DohJ8TmhvJMZKE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kNOoQEJhhGG6wRRgk5p6UXp1EtkuwJaTXFxTJOMCL8t4W7N6odqvqvKHFonT0EZy9GoxO5mfgI6vGBMRWINVHBWzw6u4++vtV+Vp0aDwd2j9Iuvpggm/an80lwPcnoXS15bbOB7rqlMx+Nz+E60Spm6HujxX883MEXuOknA7aCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0067468D0A; Thu,  1 Aug 2024 16:20:30 +0200 (CEST)
Date: Thu, 1 Aug 2024 16:20:30 +0200
From: Christoph Hellwig <hch@lst.de>
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, Coelho@lst.de,
	Luciano <luciano.coelho@intel.com>, Saarinen@lst.de,
	Jani <jani.saarinen@intel.com>
Subject: Re: [PATCH] scsi: sd: Move sd_read_cpr() out of the q->limits_lock
 region
Message-ID: <20240801142030.GA5228@lst.de>
References: <20240801054234.540532-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240801054234.540532-1-shinichiro.kawasaki@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good, thanks!

Reviewed-by: Christoph Hellwig <hch@lst.de>
