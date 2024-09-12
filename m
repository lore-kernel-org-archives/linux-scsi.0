Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C9D189516;
	Thu, 12 Sep 2024 07:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726124583; cv=none; b=rj4lrY/Vj3Wxtm3qEhzn/E7IpVL+yrIRhj7neoam4s5arNgYGVGup0nCnCdP0ojKxAYFL2HVaxN4s9ZOBjYlAFRQ9DO70JLocn6y4ee34EOsGMuf9LOWfO0BTirL9i1qltyV5MO/dGp8v6yJ72PB2a0ljX6hPBdCpR7ZDnoYfs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726124583; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CFSGJly6w3S/KLWuujfJqOZ0B5FvaoOcmdF3GoIQip8zPEnN4CDGqsiBA06Mpix6BqhSWtzFFb9MBJwhbbsks7xQW/LrXuEicCDaQmCHyQ2FuBx0uiK/QcDOLEidXPBWiDGZSsemeKOMjI9dXYXya5hmFizviNj6xG37t5tC3CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4B60868B05; Thu, 12 Sep 2024 09:02:57 +0200 (CEST)
Date: Thu, 12 Sep 2024 09:02:56 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, sagi@grimberg.me,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv4 01/10] blk-mq: unconditional nr_integrity_segments
Message-ID: <20240912070256.GA7614@lst.de>
References: <20240911201240.3982856-1-kbusch@meta.com> <20240911201240.3982856-2-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240911201240.3982856-2-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

