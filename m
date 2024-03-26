Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A0374BE2;
	Tue, 26 Mar 2024 06:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711435174; cv=none; b=itU0ffhSnoXCThHlpQmylACKMtWB7AiO0oOwzqc+YAzulvDPxCM1quGfVSAbAOb9DX+2hZvilumcCtLfrVgJtIYVFb7fC1XD+STiae6lufBE3KsFMm5YkKJi+yCAe8MI9nDq/ZCi5pLm9HiXwdYGLkWlGlI47X8XtQix6zm1W8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711435174; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VxOEyvbAV5qGjBzG59cBGBWAyaeoxDGLupI9+SZWBgW6gQCUWE/T/wKUGYEbuwkO72PwQfhg0R/SFEFQ806OW3j0DV+317nDfXOQDxRe3cgNwPyEnoP79jgURMFwgFTiDn5lFku81JJr0NfL3xLF9SUGrlNVgWEN0smvzNYJRvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1753C68D37; Tue, 26 Mar 2024 07:39:30 +0100 (CET)
Date: Tue, 26 Mar 2024 07:39:29 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 05/28] block: Allow using bio_attempt_back_merge()
 internally
Message-ID: <20240326063929.GD7696@lst.de>
References: <20240325044452.3125418-1-dlemoal@kernel.org> <20240325044452.3125418-6-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240325044452.3125418-6-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
