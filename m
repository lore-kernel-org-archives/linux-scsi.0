Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AEC33537FE;
	Fri, 14 Aug 2026 06:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786689385; cv=none; b=UfjVRWAOR0ryBaaJbvZxipeb+kk6C/8f5eMp4ilP4TkORJ1lGUGvFFUhO3GBzeDGoV5/IFpWV++PSmmeA6xHVTwtbeE5wop0+rNVrJ5elD6hRPAaofjWFoWsL72olhjklt52879Qvm7KPj9oYSvjMk0/fCtXR9FoCMN2k+SIvFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786689385; c=relaxed/simple;
	bh=BkCAaL0QgMjcDACJglHNIc+mPjJVSmhB9wgz/GcnVGU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aErcpsoK2o41RPaf7PcBo/dQ46YyCoyQIrT52RJCrQbZd60DXV76DF/zhCiXCABlOweJ4ZVyNYg4ruEd0ViSnx/g6wAvFuByvJJUCw5/Fq9lfDgoZNvEozTOoyvCkcDRIthtbyZ4gsoTEU+phWBPrxAFKwLkgqKUsProsduLxVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 461F168B05; Fri, 14 Aug 2026 08:36:16 +0200 (CEST)
Date: Fri, 14 Aug 2026 08:36:16 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jesse Taube <jtaubepe@redhat.com>
Cc: linux-scsi@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Justin Tee <justin.tee@broadcom.com>,
	Naresh Gottumukkala <nareshgottumukkala83@gmail.com>,
	Paul Ely <paul.ely@broadcom.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	Hannes Reinecke <hare@suse.de>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	John Meneghini <jmeneghi@redhat.com>,
	Bryan Gurney <bgurney@redhat.com>, Chris Leech <cleech@redhat.com>,
	"Ewan D . Milne" <emilne@redhat.com>, shinichiro.kawasaki@wdc.com,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org
Subject: Re: [PATCH 00/13] nvme-fc: FPIN link integrity handling
Message-ID: <20260814063616.GA9231@lst.de>
References: <20260812181300.3712426-1-jtaubepe@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260812181300.3712426-1-jtaubepe@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

This touched a lot of core code for a fringe feature for a transport
that shouldn't even exist and is full of unmaintained and buggy code.

Why do you think we'd want to take it?

