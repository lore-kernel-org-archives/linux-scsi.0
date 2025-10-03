Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9483A1CD15;
	Fri,  3 Oct 2025 10:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759486523; cv=none; b=a2UOKsEAHOCL3rFiZR8leK4Jmn0fqTDS4nv97Ie6cqIMs9JZrCR9SEVUhN75b0L1+xqFb4HQRpaWRF5NZwIZuy6HwR2UdED6EkaQ+7fxgHbCSYzwm0Z5E4jmjf/xkdWKAuXmpJ9vUygYTkxI7BgeKzQhNxY4mBWrpZjPOr1WPXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759486523; c=relaxed/simple;
	bh=ZtHmKJPpy5MpT63RZ7j5eHyj8SMDL3lY5IQBo2rtn9E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s5z9dxpRNF3GEHkKEcDBf4RiMyuouzNtVC9NW/CeAkDYp6s/AaImHKKX+yZtWfzVmjvNEMqEPjsrfROChhtJFu/qvCT5S6U0AdGRBJJHgri2r1O+eAa0rOaw6kcFBCDJar/8xi7Y/96mEPeFKAtlnGYSoZdVa8U4HUPL9C/Uogo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7459F227AAC; Fri,  3 Oct 2025 12:15:17 +0200 (CEST)
Date: Fri, 3 Oct 2025 12:15:17 +0200
From: Christoph Hellwig <hch@lst.de>
To: John Meneghini <jmeneghi@redhat.com>
Cc: hare@suse.de, kbusch@kernel.org, martin.petersen@oracle.com,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	bgurney@redhat.com, axboe@kernel.dk, emilne@redhat.com,
	gustavoars@kernel.org, hch@lst.de, james.smart@broadcom.com,
	kees@kernel.org, linux-hardening@vger.kernel.org,
	njavali@marvell.com, sagi@grimberg.me
Subject: Re: [PATCH v10 03/11] nvme-fc: marginal path handling
Message-ID: <20251003101517.GC15826@lst.de>
References: <20250926000200.837025-1-jmeneghi@redhat.com> <20250926000200.837025-4-jmeneghi@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250926000200.837025-4-jmeneghi@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Please don't hide core changes in patches marked nvme-fc.

