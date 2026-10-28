Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793205062;
	b=F2IClynd29VKH70NJRONnTNMDQ4BKEwLpasW67qLnKiLsAQOVOhA6/HrgyAaKUBc7Lrs
	 HkIwlzCFyNcsfEGIyZ9Oz1mP3ofRsHL5YsddG08jBRdgMVADhIZBp7rvrg3b/Eumv64zz
	 Y9KYw67d6tlj1jvtLVlTjLeiunMGB+VoOIEfH67dLsU7GGmey0ND/rEC5Zy3VY0Us6eBc
	 hrxFhJ+InyfpbI1ei+2Xs8DnWsbEKyRIzMNXpL4idSyBXMG+Rbxzcw3vp/aXjE/Nw5Xi+
	 KQ5hwIA/0LDUrcbS0CpkhfiP3+DmVSy7TAQA3xl0A2TmtzK34janu2vGSQ37FKLQVdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793205062;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=0VX6PQVoi1TebUVdoHcBEnmdLn+31WkH+ZgTAhxT67kCg349GuyP6ej1CE0GeioSu6ao
	 pfub50+fsKk8a/Ffq9WFJ3QgpQN5Idlt2a4RMw3BfgypSVzAYglKPJaOTzMr4Zokn2SRX
	 VLT5PyWC59G9RVsdP7ttfhf/JbgIJCMG9Q4OXyM8rk1IIB6biy4lKY1LFTcCcwJLYX3iW
	 Jyelc3yJfUiZi9b1mTtkgfRGw2WAYCwDsTC6RMUOayMWKj/th2CSikZLBIK/G2///lEi8
	 wTfdje3aYnY1xlLwuhjgy7DvJ60bxTX5TGHRZCf357bZBqU+ZZTEOQPk7coJP2Ti9Fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0F9606A325;
	Wed, 28 Oct 2026 16:31:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EF0F9606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DFE5968AFE; Wed, 28 Oct 2026 17:30:54 +0100 (CET)
Date: Wed, 28 Oct 2026 17:30:54 +0100
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj1072538@gmail.com>
Cc: axboe@kernel.dk, asml.silence@gmail.com, kbusch@kernel.org, hch@lst.de,
	sagi@grimberg.me, James.Bottomley@HansenPartnership.com,
	mkp@kernel.org, bernd@bsbernd.com, joannelkoong@gmail.com,
	miklos@szeredi.hu, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org, fuse-devel@lists.linux.dev,
	joshi.k@samsung.com, anuj20.g@samsung.com
Subject: Re: [PATCH v2 4/5] block: map dma-buf iterators in
 blk_rq_map_user_iov()
Message-ID: <20261028163054.GA22862@lst.de>
References: <20261022144501.2478417-1-anuj1072538@gmail.com> <20261022144501.2478417-5-anuj1072538@gmail.com>
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
In-Reply-To: <20261022144501.2478417-5-anuj1072538@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

