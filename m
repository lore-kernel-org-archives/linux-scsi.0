Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ABDB38B7AC
	for <linux-scsi@vger.kernel.org>; Tue, 24 Feb 2026 14:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771943870; cv=none; b=FVl66BigkzouogoP1TiidtyQGq1w5gc/IKV4QOqP3UTZb1tRvWif+nzOIMdwIRG7miiaqe2d1qebH/Qrl/m/HTAglAkckURB508uK/1ELratU7/U/dPbpCXze7JmkA1yRFR64cCjwKS255xVnycThAHcPdY5QaSJMBUcU4NmzAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771943870; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RggN8x2KP9AR/O2KGLwJVKG9GVtFmpV0DvQaL8p9FeTWQz2YHVSoVpWAbjXYPpsm+3g439hhplutBOEJnbJseMTqwCLzJGns9hjKJo4t27ng62eB9T+xDo9T1C8LFeADWSuYv7R2OLy4/r5TUlW21ci8OxkDiJOlP5oQf9r2By4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 853DD68D05; Tue, 24 Feb 2026 15:37:45 +0100 (CET)
Date: Tue, 24 Feb 2026 15:37:45 +0100
From: Christoph Hellwig <hch@lst.de>
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: kbusch@kernel.org, hch@lst.de, hare@suse.de, chaitanyak@nvidia.com,
	bvanassche@acm.org, linux-scsi@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	James.Bottomley@HansenPartnership.com, mlombard@arkamax.eu,
	jmeneghi@redhat.com, emilne@redhat.com, bgurney@redhat.com
Subject: Re: [PATCH V2 2/3] nvme-core: register namespaces in order during
 async scan
Message-ID: <20260224143745.GB12308@lst.de>
References: <20260224122505.52401-1-mlombard@redhat.com> <20260224122505.52401-3-mlombard@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260224122505.52401-3-mlombard@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
