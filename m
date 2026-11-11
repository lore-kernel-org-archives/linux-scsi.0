Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794410720;
	b=z6FdSPVgD2KmMwKrGNpctpfndE81uehNO/z8qHCoCoBizH5Eqe4h++oUzbyWH4/+9Q5v
	 LsL1SYp9wrYvE9Ql27liNOzkpya+OjkMAAsPYUGQp8twiaY+sgnJ/jKKDPIZJ/I51gw2K
	 lv845it5CIoKj2LYegiC375N9q8J15z5LAp0X4lOSHFl88sw22nCm29RUtfiQ8Ez5k7+Y
	 vV4m05kEkdXfkbZCQ/SSSr0d7IMbIU9di3hK9gVyuBeZykzgSK44nOb/y7d3zdU4+q3Ht
	 U2Cji1Uv0/KWnWhBRui53xhXvoNZzPeei+BoXhIPa4fW52wzRkorfVUM7mwazMZLk2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794410720;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=SjIROnLelybRFRiB7XRvo0aSBjDk4kv7yzgkHazuGH3+NhvjES6xV9a/8o7BBGkHerrh
	 NRVCrb5ekxtvFoJiugsLBsqFwP8hOOvUQ/5N7RX0XcdIwsN2/N0/Xfg7Mt7VoOyIpM5eq
	 kH3hk9EyrDTrMCABYupCeOWHMpsratr8Ht1evSOjHclH8hqhrcFCMCNTcqSqHYFhpuO+7
	 2+/gDB7gq9GJCTFxbY5QusVy2BWXqsaInGZZC0dxdYKqjvNoS5z7fYCD/yZGVtnixsHCI
	 aJjIqf8KpVbb5SDx+ar5NTCJOC6TzGGDVQEpSa/WB0GQrVHxi7KBudV4N04nTg87FZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B1F606A321;
	Wed, 11 Nov 2026 15:25:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 83B1F606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 352CA68D17; Wed, 11 Nov 2026 16:25:16 +0100 (CET)
Date: Wed, 11 Nov 2026 16:25:16 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v8 05/12] block: add storage element management ioctls
Message-ID: <20261111152516.GC12574@lst.de>
References: <20261109095144.819709-1-dlemoal@kernel.org> <20261109095144.819709-6-dlemoal@kernel.org>
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
In-Reply-To: <20261109095144.819709-6-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

