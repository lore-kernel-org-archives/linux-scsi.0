Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57FD19ABC6;
	Tue, 10 Sep 2024 15:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725982209; cv=none; b=bZopAqLPtnpMvCdCdjBDsstFRzESHia8abGSJDYISZoS+/aD2YRWdgm7HkFTKTkQR2uZGj5cxE+bgqj6lq8DPlsG+FZbeZ6MOLe4wco3ULsKXpY8g9FeQ7+pqq0A9YOESyobQhw/a0uGGT0PaPknsLdoQSdG+Qw0HSb1uzW6d+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725982209; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VagjNOqwm/67YLFwq9hEk27eXgjw9Kzsu/RhO/jb38Aps6D3/uTSVxTsIC8HodqW07YK3dqnJP1lvPXRZy/xDYDcQyFoTg0TTu2vxdK7UdwKE4gGg5c3M0UQSYtB9QiZMLibl/uKhvmoY26ZDtv6yXAVjSBETQDX+in0ExcxsMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 18EB7227AAE; Tue, 10 Sep 2024 17:30:00 +0200 (CEST)
Date: Tue, 10 Sep 2024 17:29:59 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, sagi@grimberg.me,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv3 01/10] blk-mq: set the nr_integrity_segments from bio
Message-ID: <20240910152959.GA23805@lst.de>
References: <20240904152605.4055570-1-kbusch@meta.com> <20240904152605.4055570-2-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240904152605.4055570-2-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

