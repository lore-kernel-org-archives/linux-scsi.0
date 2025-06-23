Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C41482AD0C;
	Mon, 23 Jun 2025 05:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750655989; cv=none; b=iXFj4ZkLXNTVMYg100HhDvxU8NeD4eKeP4ItMcKLF2AlIY5X8traCVwrBTIRmjQwSQy1Mqza3Wouo1io+2rOqXqRuRQlAu4hcRwevxAartDH0LV9AZTzXS2CEkxUsTc+iG/R4fPcEPX0DM55qnTVAE59mbgyBpurKLIggIfcai8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750655989; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rxuF4uHqIus3sRtOJtKbxLzSwnluxinT6oPFKXI5Ipi7gdNo98vQfZhWlICLYYpOmYre+83bsL1eQdiCE296IybF0SWy22mvju8PW6vj8ioVHdBL3ay6QKf7ukdRxb4kVRVJc92gX1XnnP8Ox2DDBYpr8bHHLB0iTUr5+D350vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 379D868AFE; Mon, 23 Jun 2025 07:19:34 +0200 (CEST)
Date: Mon, 23 Jun 2025 07:19:34 +0200
From: Christoph Hellwig <hch@lst.de>
To: Daniel Wagner <wagi@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Costa Shulyupin <costa.shul@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Waiman Long <llong@redhat.com>, Ming Lei <ming.lei@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Hannes Reinecke <hare@suse.de>, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
	storagedev@microchip.com, virtualization@lists.linux.dev,
	GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH 1/5] lib/group_cpus: Let group_cpu_evenly() return the
 number of initialized masks
Message-ID: <20250623051934.GA29628@lst.de>
References: <20250617-isolcpus-queue-counters-v1-0-13923686b54b@kernel.org> <20250617-isolcpus-queue-counters-v1-1-13923686b54b@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250617-isolcpus-queue-counters-v1-1-13923686b54b@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

