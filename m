Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FA2421EFB;
	Mon, 12 Oct 2026 12:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791806672; cv=none; b=GOO9QBvBhxyRWmfSiHd/0AbmcSW+jpGIWM7D1NqC7f+KkxvyaNsg+p1/652xMQ+O0in5Gq58/IQh39cCap3Rd8AInZ1BKBpAtlTVfwdjzWNlNTmFxGgCp/pEaXdtG0HKhmIljRLjnRdvDbyA0LciIb82TJEYhpXka46dawfX37g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791806672; c=relaxed/simple;
	bh=JnZqybNGAmDaJ3hdxczVDiXqZWsOZLtUxviBCpo2k5Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eIczFabSokGZo3BQxwiQiulnS/9LLtmAHxtR5fLxy4L0pdGUGH4HR54bWJvDkLcajti1MLS7XwMa93MTWxsfKfFxya9jVNZOIuvohDb8K92j8aQ6Gv5KDhzQ30AozqONTJ3W39PB+gKjjZ/JmQNedjelzFfk0aBhwC1uP8PlUtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D7F7F6732A; Mon, 12 Oct 2026 14:04:25 +0200 (CEST)
Date: Mon, 12 Oct 2026 14:04:25 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v4 1/9] block: introduce disk_zone_is_offline()
Message-ID: <20261012120425.GA29954@lst.de>
References: <20261009090945.1504194-1-dlemoal@kernel.org> <20261009090945.1504194-2-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261009090945.1504194-2-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Oct 09, 2026 at 06:09:37PM +0900, Damien Le Moal wrote:
> Introduce the helper function disk_zone_is_offline() for testing if a zone
> of a gendisk has the offline condition. The zone to test is identified
> using a sector number that must belong to the target zone to check.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

