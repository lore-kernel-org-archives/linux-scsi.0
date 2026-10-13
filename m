Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429EE3CFF6B;
	Tue, 13 Oct 2026 14:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791901025; cv=none; b=CrZa2dWS503xhSGqhXKUR4wAG49Q3FnUSBj1R2L8WEbWXNpQQNphAyyVtlQqC/Sjl3b5JrZRDJGi+GvqqnGlly+l6mIyF+mZl8o2re792v6fzJ9VvjDy7xF05NRuNpr99XEGoD+61gd/REVwEgKMK0H2rsCMf3xSb625vXzsNQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791901025; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kFTxJW6O9P/r+kM8WRaezlCuQPm4W+EBral44qnnf3j6dRC3VD4e2HcYOjM4XSTGSS/fEjD9Xyj1+9ddBxlENpHTFfbOdmmIzhsFMLoH4MVCkpMJybSFZHsJHtaLHM612IS80MxylRAjaDitVx40TigordCMmu8G797jfJDaMe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DF70B227A88; Tue, 13 Oct 2026 16:17:00 +0200 (CEST)
Date: Tue, 13 Oct 2026 16:17:00 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v6 05/10] zloop: avoid potential wp_lock deadlocks
Message-ID: <20261013141700.GC13783@lst.de>
References: <20261013122750.2237843-1-dlemoal@kernel.org> <20261013122750.2237843-6-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261013122750.2237843-6-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

