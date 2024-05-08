Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670E33EA71
	for <linux-scsi@vger.kernel.org>; Wed,  8 May 2024 12:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715172001; cv=none; b=JgY25qS6Wsg/a6Ofw7kqpa5V06hI45dC9Dl63jgOsMcTRPMFEv72BKez4/TY2RhztIhRmq4s8B8isKdwJPBgoIZu5q745w5dwuXq74L6a4hUspldrG2QUdThKPQ+uSQi8JX4wiMfcgbaGDKfDUgY0mBWmlpwCXxszx7She4WfPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715172001; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AGZ+2XYvVpWrNaymJn7WF/M/nsRSivJfT+StMpxw4d+ZfH3kPUgzaHsPbWXABLlvyywOo3oXm6oWklPb6L5QPONIWfGiBg9Oym1N8D6EDsZFXvt5xQ1qB6BDyDRWXOrM1b9FFXvEcM4sZr8sOKn80TLsTsLstHaW4TLWEijSSo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5EA0268AFE; Wed,  8 May 2024 14:39:54 +0200 (CEST)
Date: Wed, 8 May 2024 14:39:54 +0200
From: Christoph Hellwig <hch@lst.de>
To: Martin Wilck <martin.wilck@suse.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
	James Bottomley <jejb@linux.vnet.ibm.com>,
	Ewan Milne <emilne@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v4] I/O errors for ALUA state transitions
Message-ID: <20240508123954.GA3880@lst.de>
References: <20240508102426.19358-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240508102426.19358-1-mwilck@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

