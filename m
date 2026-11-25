Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795582575;
	b=cdxp8jmlKJS2bi1KoAuRYoFm/QgyC2cerkVB/2uAdrk9kGdz5AT0EoFSqOKHh84wWkwZ
	 KogWTdm3jSk/dX1YpDrD7D9CzDTn+OQjFQ6fRYoYymnBww+r77mK4ot9gVAqyoqVSLkpY
	 yd2GlO0fUFD7DUQ9veuyCdFzeMr3ts/CKQ/PLj2tRLr3izMf9Ljj8b7zEB3iklmBs2+BD
	 RYWqvgeQvd5BxuBF056yTfO2hqKvlIcOVU77spQAkXdxvLImW3NB8g8l/v0fVcEcioHYS
	 YpoQtRh6Uk65LPRvFOITAicCH7B1/qMez6eTdfh2xryuMrw5azoXksUEGVmrn+X12ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795582575;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=Ic4MYA5yuEzTeFdemTR728htBVvMbCdEYsTs8HoNDYi3/BaoCUBcp848edBqhiFRqn1Z
	 060a1UMte5KbyXPzq1oUwj+3LrBwsApVnQ1jWciKiS2Q3ZbDv2+EOB70kCmBKAeQKvhcf
	 nwk8C9kCH9D9SwZg4F3UdzXXrD0n39KTFg7vAsVYbAbrSguCVaA7kZt8gwfBysPtsTlc2
	 PyF1M0qBqr3UJgjnrq2s53i3TBeLWQMhubJDIHcYBIjXWsb6vXIMwBqT2kFEzWjfT+Vff
	 BkfGMeeefBwRqsotIDuydfY+QqdvwdobwYG6/XLyNNXsm+5n1OMoLNdFAZKhwJPrgGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262E6606A327
	for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 04:56:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 262E6606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D5CA368AFE; Wed, 25 Nov 2026 05:56:03 +0100 (CET)
Date: Wed, 25 Nov 2026 05:56:03 +0100
From: Christoph Hellwig <hch@lst.de>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>, Hannes Reinecke <hare@suse.de>,
	Damien Le Moal <dlemoal@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi: trace: print the CDL duration limit descriptor
 index
Message-ID: <20261125045603.GA19878@lst.de>
References: <20261124124137.146673-1-johannes.thumshirn@wdc.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261124124137.146673-1-johannes.thumshirn@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

