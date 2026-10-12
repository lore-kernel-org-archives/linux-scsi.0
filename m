Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DECD486628
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 12:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791807813; cv=none; b=C/gL2EBJz2Sghofu0gKJ3cnxs7fNVEycG4rVtgq65y7mXlYMYmtmbm2s3HnGnj6FP0pkrvzJAbj5vVbK0lH6M6WKqDdhER5+tycEkXOgxEFelqolqQbJs46wt7KP8sawD/2+lGudyKCZFop+LFTsuKqfp+NswheTx9XRS19HleE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791807813; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NhcHs+b8ZeBFyJMbn8Wqg9KXMm6paYLbcj+XV823L9YiIzBBpGpJMLXeDvEuGAlt/otl8DUlcUI6F0j17qVZR1fHun1gpkObP/UedLmymRcnJjMRbwoOgCumJh5ZyS4zcq84Ik+lJFOJCjEeirbwpFbP4SOuI2CJEtnT0ZulISg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3849068B05; Mon, 12 Oct 2026 14:23:27 +0200 (CEST)
Date: Mon, 12 Oct 2026 14:23:27 +0200
From: Christoph Hellwig <hch@lst.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, John Garry <john.garry@linux.dev>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5 4/8] scsi: scsi_debug: Split resp_read_dt0()
Message-ID: <20261012122327.GA31394@lst.de>
References: <cover.1791499174.git.bvanassche@acm.org> <5336162520371fc22ebde7bd4080a9465908dd2a.1791499174.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5336162520371fc22ebde7bd4080a9465908dd2a.1791499174.git.bvanassche@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

