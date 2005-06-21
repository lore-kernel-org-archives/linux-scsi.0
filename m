From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH 1/11]  qla2xxx: Add ISP24xx definitions.
Date: Tue, 21 Jun 2005 11:23:05 -0700
Message-ID: <20050621182305.GC7510@plap.qlogic.org>
References: <20050614053136.12127.506.sendpatchset@plap.qlogic.com> <20050614053141.12127.35841.sendpatchset@plap.qlogic.com> <20050614215030.GA5849@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:795 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S261824AbVFUSXG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Jun 2005 14:23:06 -0400
Content-Disposition: inline
In-Reply-To: <20050614215030.GA5849@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 14 Jun 2005, Christoph Hellwig wrote:

> > +#ifndef PCI_DEVICE_ID_QLOGIC_ISP2512
> > +#define PCI_DEVICE_ID_QLOGIC_ISP2512	0x2512
> > +#endif
> > +
> > +#ifndef PCI_DEVICE_ID_QLOGIC_ISP2522
> > +#define PCI_DEVICE_ID_QLOGIC_ISP2522	0x2522
> > +#endif
> 
> It's only an historic accident that the older ids are in here, care
> to remove all and move them to pci_ids.h instead?
> 
> > +	int		(*start_scsi)(srb_t *);
> 
> umm, that's most of ->queuecommand, isn't it?  Shouldn't you define
> a separate scsi_host_template for 24xx/25xx?
> 
> > +//ISP24xx
> 
> please try to avoid C++-style comments
> 
> > +	volatile uint16_t mailbox0;
> > +	volatile uint16_t mailbox1;
> > +	volatile uint16_t mailbox2;
> 
> never use volatile, always use proper kernel primitives to access
> hardware or atomic_t for atomic in-kernel variables.

No problem.  I'll have another patchset which hopefully addresses the
concerns and with a bit of additional testing in the next week or so.

Thanks,
Andrew
