Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8004C242915;
	Wed,  5 Mar 2025 13:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741181566; cv=none; b=ZheUa3C31Qp3/OHqZ7XsBv8i4c7lmdBnBYI2aoScoEG1LtHRjjhs175pNFvPfcFa8pDYAnp56PgaT1c/cPz9QGTss7iuN8a1kZpFRRk4ee8meuqksZdWxVntjcGjJc6Zd148Zcs2CrqDlyn+NXQmhs18ng33PSvGCkD4da0d7sI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741181566; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VcgNfujLD36vQLjFu3FMaSKXco7b3VLWu+xUngTicxLho/S3LsvngMfWY8ibIZlnkHzJi8abhH3V5xLRBBX63UiBgHl4DlP1dukZXNGCPRQqmMEOklgxwJFZM6Ag7Q1TcYmBj9AXZffGOMCGHFNtE4q4Y9JU6+mcoI1AlmKfkWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E7D2868C7B; Wed,  5 Mar 2025 14:32:36 +0100 (CET)
Date: Wed, 5 Mar 2025 14:32:36 +0100
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
	anuj1072538@gmail.com, nikh1092@linux.ibm.com,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org, dm-devel@lists.linux.dev
Subject: Re: [PATCH v3 2/2] block: Correctly initialize
 BLK_INTEGRITY_NOGENERATE and BLK_INTEGRITY_NOVERIFY
Message-ID: <20250305133236.GB16755@lst.de>
References: <20250305063033.1813-1-anuj20.g@samsung.com> <CGME20250305063903epcas5p46a5f908f6500fc34795b8330534d0c15@epcas5p4.samsung.com> <20250305063033.1813-3-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250305063033.1813-3-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

