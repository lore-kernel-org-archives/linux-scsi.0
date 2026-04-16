Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 466B6366806;
	Thu, 16 Apr 2026 05:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776316916; cv=none; b=fdQ0nX2MwOG7pQ47CxnLcAfpQY9vn1DAUL93EGJ+Z7qcCD6sLuGmlNi6TUY2zKeB6ffvExl2GpXAroQ9T00O2IpJiGzGC/Uj4rlT/cbCDSsT1ZPRRvxM3eYQVMttGlvfCAR0FDLvwbGqFVtsfSF7wO5LZJx3N3XCCPWcEZDMDG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776316916; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MRWzz6HqD6bV3AxItA5pMbinqgulvdfKDhV4PnaaDUtHP5XNkLk/BaQaHV7HDFEXw3d0Mgj7twfz1Oo5U0my9VDHTn6sSHqp/aYxCLx1rhr+eRlxjFCjj/2DViVsMWh1C+dkecLp6WwwRFriUCBLzzfQHPhwXLOic4PgOiGtF5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BB97C68CFE; Thu, 16 Apr 2026 07:21:52 +0200 (CEST)
Date: Thu, 16 Apr 2026 07:21:52 +0200
From: Christoph Hellwig <hch@lst.de>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/6] bio-integrity-fs: use integrity interval
 instead of sector as seed
Message-ID: <20260416052152.GD14950@lst.de>
References: <20260416002214.2048150-1-csander@purestorage.com> <20260416002214.2048150-5-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260416002214.2048150-5-csander@purestorage.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

