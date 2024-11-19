Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02AF9460;
	Tue, 19 Nov 2024 12:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732019139; cv=none; b=Wzzq/ODCBFoImglJZlgo9CM4ZX2Dn3euIib4JSx156Vm+lnW3+WNgx6MZEjpU3roLMRaGsE20s321g9yjyAYN77+MrmJY/zJDr3cnv4DTlzOjQiUbd6+yMI0e4S8m5yQ7lhrg/7fg66lQ+1irx1oEQ0wFnfEnnnfH3nmYrsvL1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732019139; c=relaxed/simple;
	bh=Qf9Sk0EylpTUB+DcuLmcIk+0dB6alPyo909cO/AzCs8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O2LSVSpbW4x4kzzgVvex9PKqsDbYzeGaazcAxToHp3iICQaftwTNPhvZU5xkaz8FUn/UphTPe1D0UUX6gQdnrCqJy/N2gz7H7R6Dcn4JlSTGIQo7INqO1cKLmgTI0HdRYAyy9XgAzqX0sDJEbKh1uWAKTIxN0i2aeWceMF9nKVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 519E368D80; Tue, 19 Nov 2024 13:25:34 +0100 (CET)
Date: Tue, 19 Nov 2024 13:25:33 +0100
From: Christoph Hellwig <hch@lst.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH v16 00/26] Improve write performance for zoned UFS
 devices
Message-ID: <20241119122533.GA28580@lst.de>
References: <20241119002815.600608-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241119002815.600608-1-bvanassche@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Nov 18, 2024 at 04:27:49PM -0800, Bart Van Assche wrote:
> Hi Damien and Christoph,
> 
> This patch series improves small write IOPS by a factor of four (+300%) for
> zoned UFS devices on my test setup with an UFSHCI 3.0 controller.

What's your exact test setup?  Which upstream kernel support zoned UFS
device are using?

