Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794410887;
	b=ZQx1CmYLMVA6atRxxR51pLwn/OyPHCy2DbrnAhR8iUVNmTzu18hS0PyZIM+zxHfrwLXV
	 jIU4GEbnop6cMiy69Wn/CqL98iTQvWRWMHPjE78DKXjOEKid8hW7LGFwzLvV+Z4GVo49z
	 UaVNH/mr65QEgMD7uLRj/j5paVyzLZQ7S9/MFIaU7WkmXh45T/rJv2UkSJnWoj0Gwd44e
	 x2uSWlAmPZw/qMzUZqf2FMg9wBoOrrjgQg+vEZAXr1vbxnrAaxx73cqfxOPi781otOXVR
	 K+ePdqFg6XP34uF/Euayxj7m8szTcGK6Q4swXece84LETJ5nr1ZNYyN/VHCzNlFVPQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794410887;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=FOcaLOZj3kHAmuMna8jWzX239wDUEGEB8tw+ZGbSLWSXypLJ/cJYGaIm5WqWT27R1iaF
	 IRck+ztw4c3p3TKyvELZs5WfPq/ks9gYAfDHBjUzpM0qEY8JOv8LNu0JukQjVqyDgUCpd
	 dmEgliEi4pAsGiXR4VyQvxtByQ7N+Y0eJ863k+M6exKGBoYKcBfkeS9PtaLuw34nXVUKl
	 4qGRhOeOWgoT6mZNuv4emd6cQPtyxYfZ5x1rUDx2vLnCQMlEjadTfiAGZ+pj0AQwOKcXj
	 bQ7PmKXMyZ1J4MgPvNMXOofWV9AQE6N26q56cnvll9OWV01bdVd6qF/P5hCqxTQKDPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17DBE606A331;
	Wed, 11 Nov 2026 15:28:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 17DBE606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DAD8C68D17; Wed, 11 Nov 2026 16:28:03 +0100 (CET)
Date: Wed, 11 Nov 2026 16:28:03 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v8 09/12] scsi: scsi_proto: refine the definition of
 storage element health
Message-ID: <20261111152803.GE12574@lst.de>
References: <20261109095144.819709-1-dlemoal@kernel.org> <20261109095144.819709-10-dlemoal@kernel.org>
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
In-Reply-To: <20261109095144.819709-10-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

