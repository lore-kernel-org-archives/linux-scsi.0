Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795188077;
	b=Fvx53GRd64i7pT7J5RylOXKZup57jQl2wh8oM8CSBHIujfzwRexQw7e3CRzBkgIOMBfg
	 pMCQPlZ6wWabgJnPcJEqP5NgvS0EtKWeBmTQUFZiquxQNksMAv0JRHjy55dgmxgBg+WF4
	 E09vgmXdpFnL/yPWSE27dxPpJzX1ugitENjquU3vtn29qcDPEInOG9IEQ0ttdSktHFSa6
	 6gHIaZWPUhQaDufTQTGb6nGygivFoq5D3NhR+2G6/PPX1Wt/OfoskCvL1MCJcyiIOxe64
	 16W0T/Y4OMlrcscnKIT5Qa1nJqmdbUDhzfrP0BSmd0bPt0nB8XXQym4JicH/0QP0vsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795188077;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=f2jluw/mRcSnVW7E2kZY/+gSsmvjZSqwf57NxDZm2oTR8P25N6Zzk+8UpXt28fROUrKl
	 oIHM+U8Wr6nBaThjm+q6KYB6bAYLq3PtNSgty2CHYpCdY55Rz4iWgchfV74os956R1R8Y
	 TvW4irHoihJ70VVdfopt+ZbljexHo04tOmTVMi0rCUUo6htaR0vq/ktFhyysq9jHPqJYQ
	 SdpPl7UmMzzMEexXMOoPJgrxZKr2KPNrJXEUyJX00XYiMjjz5tzQ7MxTn3T2PdY1NR5ay
	 7b0Yzc8nQvRbaZPxC/B693J540nSZ+kLiZSxIQ1YHVSTVWeJ7NjiZ1CTnwrSVhEh5vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C2E606A320;
	Fri, 20 Nov 2026 15:21:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4C2E606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 93EDB6732A; Fri, 20 Nov 2026 16:21:13 +0100 (CET)
Date: Fri, 20 Nov 2026 16:21:13 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v11 12/13] scsi: sd_zbc: define storage element
 management operations
Message-ID: <20261120152113.GC26913@lst.de>
References: <20261116213702.225970-1-dlemoal@kernel.org> <20261116213702.225970-13-dlemoal@kernel.org>
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
In-Reply-To: <20261116213702.225970-13-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

