From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Support for CDB length > 16
Date: Tue, 18 Nov 2003 17:46:18 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031118174618.A29310@infradead.org>
References: <OF1494DF8F.2FB4A44D-ONC2256DE2.004036A3-C2256DE2.0040B333@il.ibm.com> <3FBA186D.2060907@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:18180 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263734AbTKRRqY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Nov 2003 12:46:24 -0500
Content-Disposition: inline
In-Reply-To: <3FBA186D.2060907@torque.net>; from dougg@torque.net on Tue, Nov 18, 2003 at 11:02:37PM +1000
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Liran Schour <LIRANS@il.ibm.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

> Perhaps we should starting thinking about kmalloc()ing
> scsi_cmnd::cmnd (rather than having it as a fixed array).
> The mid-level owns that structure so it can take care
> of allocation and de-allocation. We would have to
> find code that does sizeof(scsi_cmnd::cmnd) and fix it.

That would be the way to go if we want to support that big commands,
maybe with an pre-allocated array for 12byte commands so that the
fast-path doesn't get slowed down.

But I'm not going to do that for some vapur-ware, we'll need a real-life
application for that.

