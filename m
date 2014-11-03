From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] ipr: Convert to generic DMA API
Date: Mon, 3 Nov 2014 10:32:24 -0800
Message-ID: <20141103183224.GB26428@infradead.org>
References: <201410302227.s9UMR8qs008773@d01av04.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35331 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015AbaKCScZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Nov 2014 13:32:25 -0500
Content-Disposition: inline
In-Reply-To: <201410302227.s9UMR8qs008773@d01av04.pok.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, hch@infradead.org, linuxppc-dev@lists.ozlabs.org, anton@samba.org

Thanks, I've applied patch 3 to drivers-for-3.18, and patches 1 and 2 to
core-for-3.19.
