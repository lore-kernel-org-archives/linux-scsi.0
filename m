Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DADCC3A71B0;
	Fri, 22 May 2026 09:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779441726; cv=none; b=bVosnWyCYgeRbzyT1ddRf9FCac/wOYi7ORmvAIBWv9vYDk+RPSkC0OEe+m4wndZxqSHs/1Q4qWT1DMFGyi5rvom/CWzJ+oK1pRbXiieAsG7gRw4OM1B2BOwbRUE8hCChmvWc+9FSWlX0KDfcB8I+ZqGC8pgVsZzQpPViaT7Ea2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779441726; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y2Nl2P7HX/tPWbtjDqexZL5vTO2icZ5Gw3k8Kg72mgibW/k0jFvAwrkyKJwql3RlSlwej5W8e9qi9RWy0W64NXmo/aK3NUNpeT2PH+8rS8xaucqn2POboF4NPqe/x6IXzL/cDSqv//DVU2fZbkvIeXxfG8PGVZm0NpE1TkXShWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9249568AFE; Fri, 22 May 2026 11:22:01 +0200 (CEST)
Date: Fri, 22 May 2026 11:22:01 +0200
From: Christoph Hellwig <hch@lst.de>
To: Michael Bommarito <michael.bommarito@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	Shyam Sundar <ssundar@marvell.com>,
	James Smart <james.smart@broadcom.com>,
	Hannes Reinecke <hare@kernel.org>,
	John Meneghini <jmeneghi@redhat.com>,
	Bryan Gurney <bgurney@redhat.com>,
	Justin Tee <justin.tee@broadcom.com>,
	Christoph Hellwig <hch@lst.de>,
	David Laight <david.laight.linux@gmail.com>,
	Keith Busch <kbusch@kernel.org>, Kees Cook <kees@kernel.org>,
	linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v4] scsi: scsi_transport_fc: widen FPIN pname walker
 counter to u32
Message-ID: <20260522092201.GB8708@lst.de>
References: <20260519190615.2761667-1-michael.bommarito@gmail.com> <20260520133015.1018937-1-michael.bommarito@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520133015.1018937-1-michael.bommarito@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

