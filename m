From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V6 3/5] Introduce xen-scsifront module
Date: Sun, 31 Aug 2014 15:33:01 -0700
Message-ID: <20140831223301.GA27016@infradead.org>
References: <1409201053-6223-1-git-send-email-jgross@suse.com>
 <1409201053-6223-4-git-send-email-jgross@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48698 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaHaWdD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Aug 2014 18:33:03 -0400
Content-Disposition: inline
In-Reply-To: <1409201053-6223-4-git-send-email-jgross@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Juergen Gross <jgross@suse.com>
Cc: linux-scsi@vger.kernel.org, JBottomley@parallels.com, xen-devel@lists.xen.org, hch@infradead.org, target-devel@vger.kernel.org, david.vrabel@citrix.com, JBeulich@suse.com, nab@linux-iscsi.org, konrad.wilk@oracle.com

Looks good to me from the SCSI POV. As discussed earlier I'm fine with
picking this up via the Xen tree.  If you really want it to go through
the SCSI tree and I'd be happy to pick it up once I get another full
review.


Acked-by: Christoph Hellwig <hch@lst.de>
