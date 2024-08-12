Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E18016D336;
	Mon, 12 Aug 2024 09:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723453626; cv=none; b=dqegpn2pR9DEDuMBPR+hTfhHL9fE0u2HzrEZ6o5qSd/OpZVlz9j/AAMSJDgYB8fTeV1tJagNGJmd7AeyqVIFpit57rWUwHRpaLoTXaDpjUOwAtENDP0MmES4E/+ZunXmElWMQDON87bN/UFBuf+ruS1R/nUQc3Ysownap6prFi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723453626; c=relaxed/simple;
	bh=xCVIybzFXtO90Va28ZXPh+hDyytpysKWwTzTspdhcSw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XchvYKNYiShqF1M/Vo6EMblmYeNf5CV5BgzhioII0KzRyorbIBXpwRTsmfs5dkaojPRq2ednryokP264Xw4CMVVum0uM9Z3GS12698C0g2539nvguSHKp5SBz4/IZp45HGuw21PEEImrWuE2uyVjNVsx+94RRkMtJS5UYopLnYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 53914227A8E; Mon, 12 Aug 2024 11:07:02 +0200 (CEST)
Date: Mon, 12 Aug 2024 11:07:02 +0200
From: Christoph Hellwig <hch@lst.de>
To: Daniel Wagner <dwagner@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Thomas Gleixner <tglx@linutronix.de>,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	Jonathan Corbet <corbet@lwn.net>,
	Frederic Weisbecker <frederic@kernel.org>,
	Mel Gorman <mgorman@suse.de>, Hannes Reinecke <hare@suse.de>,
	Sridhar Balaraman <sbalaraman@parallelwireless.com>,
	"brookxu.cn" <brookxu.cn@gmail.com>, Ming Lei <ming.lei@redhat.com>,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	virtualization@lists.linux.dev, megaraidlinux.pdl@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com,
	storagedev@microchip.com, linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 06/15] virtio: blk/scs: replace
 blk_mq_virtio_map_queues with blk_mq_dev_map_queues
Message-ID: <20240812090701.GG5497@lst.de>
References: <20240806-isolcpus-io-queues-v3-0-da0eecfeaf8b@suse.de> <20240806-isolcpus-io-queues-v3-6-da0eecfeaf8b@suse.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240806-isolcpus-io-queues-v3-6-da0eecfeaf8b@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

What is blk/scs supposed to mean?

The code changes themselves look fine to me.
