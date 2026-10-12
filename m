Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8902B470130;
	Mon, 12 Oct 2026 14:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791815787; cv=none; b=FOyLzwx6niiIrUBnDkTx4d1Yhc6hywwynmrwSwQCxTK6gWC5L8SFJpGZPSc+k4uiOCOpJCOO/R0hWLc8ZXPMQrps3FFC9rwJShM1ef1SRxcEbWvOBgu0/S/vuSdh3RKQq9626iaKafBA+meZDSrLBR6ujC6tCh2b0AvbFpmkf54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791815787; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ecaYcJm/O78WTTW7+P+BB8/rEiNvZ5UemEnXK6eoSkBp0kFY0+fqUDeudujaNp/qRygIt/SEzG1JVPwbisRgqGhi8aeMLZa6Qcp+4NnMUAP1zgYOR4kDXC6C2K4xA4O2akAaIGLaD1Mnw2Z9qoBw2Hk7Pgz27KmRx4M1zp2vmWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A0157227A88; Mon, 12 Oct 2026 16:36:20 +0200 (CEST)
Date: Mon, 12 Oct 2026 16:36:20 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v5 7/9] scsi: sd: fail read commands to offline zones
 early
Message-ID: <20261012143620.GC8609@lst.de>
References: <20261012130121.1902634-1-dlemoal@kernel.org> <20261012130121.1902634-8-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012130121.1902634-8-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

