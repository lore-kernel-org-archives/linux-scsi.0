Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19F4126C02
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 07:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790320128; cv=none; b=ivARdhSL1a9173UBDokYk8oYvEmYrenxxsj6BzlF7JbdUDuR5MFq1gtEh5+G06tbI6D+jMUsogtgCPVPt2wtOE3zGeH4BCEFC2pxQzNKia3p7VR4goUgj/dBcVT5mdiS6WYyLMgcLS0rjaW4prpl9WacDVs/fRRdckumX3iyAxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790320128; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RicwqTx5j77nkojmjq7a+8oW4H0uSgIoVSwDAdCBbsX4CDMXDvyic39oV5PYoQqxpSS1LWkCGDHhBgs9VgV2R5aZ2bmrqcR2o3/vMtMNHkm5AoQlBhbzoq2YQ3nvCk0l/MYxrxGYddr18VoOXV1Tt8B6T57vg80maJq+9Dk+D6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AFEC668C4E; Fri, 25 Sep 2026 09:08:43 +0200 (CEST)
Date: Fri, 25 Sep 2026 09:08:43 +0200
From: Christoph Hellwig <hch@lst.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH v2 2/7] scsi: scsi_debug: Split resp_write_same()
Message-ID: <20260925070843.GB4621@lst.de>
References: <cover.1790290089.git.bvanassche@acm.org> <20122153e730550db9b05401ed14d0a8a20d4773.1790290090.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20122153e730550db9b05401ed14d0a8a20d4773.1790290090.git.bvanassche@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

