Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431DB15E5DC;
	Wed, 22 Oct 2025 07:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761116858; cv=none; b=kp/maAdfI7RGK37NGrwv0d4ipHn4G+pig/WRlLS0BlqO3G/9gdEwE+DP+qfy2vfYPPl6ETKAiLQoXhb1gvxtL9ENRFNaJykQrvIY66Mr6Unx8DPGBvHS3FC3RpubeZTyOQZUls9o+HdtHoef5ozpMbbfg3shnncIASrH48ut88s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761116858; c=relaxed/simple;
	bh=n0nrFgOm1f3njGiO+6cUro2XyE/DFYT2r3vIVZx7XTg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vxy16pZdH+FoSfuths9fidvFo0ZhbpuzAeLJE+M0Ls93nIetiSIKur48ysbnTk1qREO5WHXthm45aaix9qW/jb7ePlOa9suqZ4UGoQ85euBUUGPM7M0/YiEiGkp/wlZaC3OhgoJAox0iFIFlawTFI7eNs/+XbLGphVxBiT3ftWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B1CDF227A88; Wed, 22 Oct 2025 09:07:32 +0200 (CEST)
Date: Wed, 22 Oct 2025 09:07:32 +0200
From: Christoph Hellwig <hch@lst.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v25 07/20] block/mq-deadline: Enable zoned write
 pipelining
Message-ID: <20251022070732.GA5874@lst.de>
References: <20251014215428.3686084-1-bvanassche@acm.org> <20251014215428.3686084-8-bvanassche@acm.org> <08ce89bb-756a-4ce8-9980-ddea8baab1d1@kernel.org> <a1850fbc-a699-4e73-9fb7-48d4734c6dd3@acm.org> <136efbd2-babc-4f07-871f-f1464a2ec546@kernel.org> <f8c1581f-5337-4473-b2a0-b1e1a9ee206e@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8c1581f-5337-4473-b2a0-b1e1a9ee206e@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Oct 20, 2025 at 11:28:36AM -0700, Bart Van Assche wrote:
> The block layer changes that I'm proposing are small, easy to maintain
> and not invasive.

No, they are absolutely not.

