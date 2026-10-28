Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793205076;
	b=BOlhrAhCBEa0COKW53P5MlKQoMEXDod/zrI6qH0Yv1/Gs15QEbt0Cj+nBm6s3HiWqg1V
	 J4+1c1Q1Xv7hCp1m8SH/JjxyOKjyao5lcO+OLqIQzPfq7dd7uYoFZbSr7saNSrBqzIQAq
	 67oKX6o+yG49EJngZ71bqPnUDrp6U9x41SE9hyLfuSb/TS9nC6CmXGrs7BXZkxRrhZn8j
	 pMZy4fDZ6EQckr8fon9I3WSk2uKlPlN4L9OviWm7AZENkmvom2MHKTnFScfeKl9f2HsCP
	 nmEmp1BP4Wrq7x7I+8hDQahHUhCpEg35RsUfdYzXP9Pzmfa+UOtYkLG19l/ooMTq/Cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793205076;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=SiDJzQNNiaXisgm/f+wDPqvHV3X9BnaBJ6gge1NHcq0DGly+hA6/3TSsKn+3W0aReDmM
	 BV4AP3RFMpo3kyrvlYYs4LMyS2iTTefGhUCObG22lZ3vfVkFH0EshWHmUbilge1BPrJIN
	 KFOTBPMUWh8qYZn9z3Zdq0PjRqS9n9cfwZkvT9O4U6gYyMqdeCdRqKEzX6DbOgP5BKukt
	 MDR5n8i6jEbPxeBHG7SwBaSOQ9W+e7qOZ5b7ZbdzaLR74qutl3O5GP2B2YyplVAMfInya
	 mr0ARVyOZjQJifuyKlIHqscpF7X1n+iMzUu7zi0714RbDSsEBFekN/kiMwEk5CgNgGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63AA6606A321;
	Wed, 28 Oct 2026 16:31:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 63AA6606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 60B8E68BFE; Wed, 28 Oct 2026 17:31:12 +0100 (CET)
Date: Wed, 28 Oct 2026 17:31:11 +0100
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj1072538@gmail.com>
Cc: axboe@kernel.dk, asml.silence@gmail.com, kbusch@kernel.org, hch@lst.de,
	sagi@grimberg.me, James.Bottomley@HansenPartnership.com,
	mkp@kernel.org, bernd@bsbernd.com, joannelkoong@gmail.com,
	miklos@szeredi.hu, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org, fuse-devel@lists.linux.dev,
	joshi.k@samsung.com, anuj20.g@samsung.com
Subject: Re: [PATCH v2 5/5] nvme: support dma-buf registered buffers for
 passthrough
Message-ID: <20261028163111.GB22862@lst.de>
References: <20261022144501.2478417-1-anuj1072538@gmail.com> <20261022144501.2478417-6-anuj1072538@gmail.com>
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
In-Reply-To: <20261022144501.2478417-6-anuj1072538@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

