From: Alok Kataria <akataria@vmware.com>
Subject: Re: SCSI driver for VMware's virtual HBA - V5.
Date: Tue, 13 Oct 2009 15:13:01 -0700
Message-ID: <1255471981.12792.126.camel@ank32.eng.vmware.com>
References: <1254336812.19921.23.camel@ank32.eng.vmware.com>
	 <20091002004725.GP3958@sequoia.sous-sol.org>
	 <1254789028.15233.54.camel@ank32.eng.vmware.com>
	 <20091013053726.GE17547@sequoia.sous-sol.org>
	 <1255469294.12792.93.camel@ank32.eng.vmware.com>
	 <20091013220013.GB2908@sequoia.sous-sol.org>
Reply-To: akataria@vmware.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:51299 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761513AbZJMWNh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Oct 2009 18:13:37 -0400
In-Reply-To: <20091013220013.GB2908@sequoia.sous-sol.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Wright <chrisw@sous-sol.org>
Cc: James Bottomley <James.Bottomley@suse.de>, Randy Dunlap <randy.dunlap@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, Bart Van Assche <bvanassche@acm.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>, "pv-drivers@vmware.com" <pv-drivers@vmware.com>, Roland Dreier <rdreier@cisco.com>, LKML <linux-kernel@vger.kernel.org>, "Chetan.Loke@Emulex.Com" <Chetan.Loke@Emulex.Com>, Brian King <brking@linux.vnet.ibm.com>, Rolf Eike Beer <eike-kernel@sf-tec.de>, Robert Love <robert.w.love@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Daniel Walker <dwalker@fifo99.com>, Greg KH <gregkh@suse.de>, "virtualization@lists.linux-foundataion.org" <virtualization@lists.linux-foundataion.org>


On Tue, 2009-10-13 at 15:00 -0700, Chris Wright wrote:
> * Alok Kataria (akataria@vmware.com) wrote:
> > On Mon, 2009-10-12 at 22:37 -0700, Chris Wright wrote:
> > > > +     pvscsi_template.can_queue =
> > > > +             min(PVSCSI_MAX_NUM_PAGES_REQ_RING, pvscsi_ring_pages) *
> > > > +             PVSCSI_MAX_NUM_REQ_ENTRIES_PER_PAGE;
> > > > +     pvscsi_template.cmd_per_lun =
> > > > +             min(pvscsi_template.can_queue, pvscsi_cmd_per_lun);
> > > 
> > > When/how are these tunables used?  Are they still useful?
> > 
> > cmd_per_lun, is a commandline parameter.
> 
> Actually I meant how is a user supposed to use these?  They looked to me
> like tunables that were part of developing a driver that may not be
> needed any longer.  
> What are the right values, what are the tradeoffs,
> etc?  Or should they just be removed?

The defaults are the right values, and though a normal user won't change
those in practice (he can if he wants to by passing values during
insmod), a developer working on performance tuning can use it. 

So I would like to keep these tunables around as it helps any future
performance work. 

Thanks,
Alok

> 
> thanks,
> -chris

