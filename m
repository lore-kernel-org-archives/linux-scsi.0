From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 0/6] qla2xxx device removal fixups
Date: Tue, 26 Aug 2014 15:52:23 +0200
Message-ID: <20140826135223.GB30461@lst.de>
References: <1403100139-1798-1-git-send-email-joe.lawrence@stratus.com> <20140826092055.53a2ff26@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:43491 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754404AbaHZNwZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Aug 2014 09:52:25 -0400
Content-Disposition: inline
In-Reply-To: <20140826092055.53a2ff26@jlaw-desktop.mno.stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Don Zickus <dzickus@redhat.com>, Prarit Bhargava <prarit@redhat.com>, Bill Kuzeja <william.kuzeja@stratus.com>, Dave Bulkow <david.bulkow@stratus.com>, Christoph Hellwig <hch@lst.de>

On Tue, Aug 26, 2014 at 09:20:55AM -0400, Joe Lawrence wrote:
> > The final four patches are more invasive and modify the scsi_qla_host
> > structure to avoid device removal race conditions.  These changes were
> > written to demonstrate the problem at hand and minimally fix them in
> > order to continue testing.  (For example, adding completely a new
> > pci_flags member to scsi_qla_host is probably overkill.) 
> > 
> > We would welcome any feedback or questions about our testing.
> 
> Chad ack'd the series on 28 Jul 2014.  Any chance this can make into
> hch's queue for 3.18?

Can you please resend the patches with the collected ACKs against the
drivers-for-3.18 branch?  Thanks!

