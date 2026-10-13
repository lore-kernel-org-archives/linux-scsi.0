Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9444C3C9ED9;
	Tue, 13 Oct 2026 14:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791900895; cv=none; b=FpbN5Kl82Upqz6azWtLhjSGAYw4uQA4sGB3T4OMStncWQVaYE7kJllQhQX7SV9vs481Q/0SMsX8lbKixZdzaPTRG3oUVi1pHUcFm82JyS0bDwA1sFqD/fMpCc5bGPNihcOWC8QldRjJlFm5lfr3KwQKtLjJkvhLE70pgnVSzmXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791900895; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TZ5SOWxUG21R4ShUryZ4JfutNcdsaKEh3QMw/+QYPca9pLQcBF3frlb8wHdX8kFqDH1QMk7SMLJyEBP8gqu3i8eE3b1j45uN5yqeYNrqLqygknLys51PTIMB1u6NARoGLWIHmL9JGWOVPc2T3D6OABhCte5hLWxmMoIMbvp+qx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EDE9A227A8E; Tue, 13 Oct 2026 16:14:48 +0200 (CEST)
Date: Tue, 13 Oct 2026 16:14:48 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v6 03/10] block: introduce storage element management
Message-ID: <20261013141448.GA13783@lst.de>
References: <20261013122750.2237843-1-dlemoal@kernel.org> <20261013122750.2237843-4-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261013122750.2237843-4-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
