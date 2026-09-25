Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559BB3D75D1
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 07:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790320376; cv=none; b=Dnt6fTOdMh3+7TLy5T3lpUVgwhmGdBQKPwpo8uaeYKHLYr8kWsGdNtIRh37nCBWQ8oaGaIf+6OL7fELc2muIMelnlHj/EZXGscjp/tisnuVNQ9NQIdxmu4tMskiecnyU6Dpk5MRq2MCJmIqBsMMSM4aoHIlFAAU+m2tIUbPwkls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790320376; c=relaxed/simple;
	bh=9dHP31M+j3RCVMPylkuDkQ8p3NqiJvTy+kUPHQbwOcE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s3r+ViRnSejnCgnJpVStPcH0xSKZFpD70GbqXz8LhTDxAkzxpy20XwgS7KHQiDThYd1tb+vRd+VQrRH5fAM42LJkKWFkL6ChPEw3ZD5v8JQB7bA8B6/6ul4V234/+boe4UzZukkaQoGsXIsVrUsLsiQEM7fqlGMWL/8iSUI/Ru4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5D2DE68C4E; Fri, 25 Sep 2026 09:12:51 +0200 (CEST)
Date: Fri, 25 Sep 2026 09:12:51 +0200
From: Christoph Hellwig <hch@lst.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 5/7] scsi: scsi_debug: Split resp_write_dt0()
Message-ID: <20260925071251.GE4621@lst.de>
References: <cover.1790290089.git.bvanassche@acm.org> <ace4490b7a25e7699b9021bd4a1030d6ca64ede7.1790290090.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ace4490b7a25e7699b9021bd4a1030d6ca64ede7.1790290090.git.bvanassche@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Sep 24, 2026 at 03:54:41PM -0700, Bart Van Assche wrote:
> Prepare for enabling lock context analysis by eliminating conditional
> locking.

Same comments as for the last patch here.

