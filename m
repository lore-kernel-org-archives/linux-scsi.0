From: Anton Blanchard <anton@samba.org>
Subject: Re: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b2).
Date: Fri, 30 May 2003 01:33:37 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030529153336.GA1027@krispykreme>
References: <20030519225728.GA17279@praka.local.home> <20030521173215.GA25137@praka.local.home> <20030521222635.GB21124@krispykreme> <20030529061913.GA27199@praka.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dp.samba.org ([66.70.73.150]:2225 "EHLO lists.samba.org")
	by vger.kernel.org with ESMTP id S262297AbTE2PV3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 May 2003 11:21:29 -0400
Content-Disposition: inline
In-Reply-To: <20030529061913.GA27199@praka.local.home>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <praka@san.rr.com>, linux-scsi@vger.kernel.org

 
> > > +	mmapbase &= PCI_BASE_ADDRESS_MEM_MASK;
> > > +
> > > +	/* Find proper memory chunk for memory map I/O reg */
> > > +	base = mmapbase & PAGE_MASK;
> > > +	page_offset = mmapbase - base;
> > 
> > Is that correct?
> > 

I was more interested in the next bit, shouldnt base be 
mmapbase & ~PAGE_MASK? Based on your next question it can go away
anyway.

> Is it safe to assume *all* platforms will handle this case internally,
> or should drivers perform the pre-process?

Yes, ioremap should handle non page aligned addresses.

Anton
