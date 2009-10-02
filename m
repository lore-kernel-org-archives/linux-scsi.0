From: Alok Kataria <akataria@vmware.com>
Subject: Re: SCSI driver for VMware's virtual HBA - V5.
Date: Thu, 01 Oct 2009 21:37:56 -0700
Message-ID: <1254458276.8491.30.camel@ank32.eng.vmware.com>
References: <1254336812.19921.23.camel@ank32.eng.vmware.com>
	 <20091002004725.GP3958@sequoia.sous-sol.org>
	 <1254447792.3885.72.camel@mulgrave.site>
Reply-To: akataria@vmware.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:54678 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751569AbZJBEhw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2009 00:37:52 -0400
In-Reply-To: <1254447792.3885.72.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Chris Wright <chrisw@sous-sol.org>, Randy Dunlap <randy.dunlap@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, Bart Van Assche <bvanassche@acm.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>, "pv-drivers@vmware.com" <pv-drivers@vmware.com>, Roland Dreier <rdreier@cisco.com>, LKML <linux-kernel@vger.kernel.org>, "Chetan.Loke@Emulex.Com" <Chetan.Loke@Emulex.Com>, Brian King <brking@linux.vnet.ibm.com>, Rolf Eike Beer <eike-kernel@sf-tec.de>, Robert Love <robert.w.love@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Daniel Walker <dwalker@fifo99.com>, Greg KH <gregkh@suse.de>


On Thu, 2009-10-01 at 18:43 -0700, James Bottomley wrote:
> On Thu, 2009-10-01 at 17:47 -0700, Chris Wright wrote:
> > * Alok Kataria (akataria@vmware.com) wrote:
> > > VMware PVSCSI driver - v5.
> > 
> > Were you still planning on renaming the driver to something less generic
> > (like vmw_pvscsi)?
> 

Yeah I will rename it.  Though, I will skip renaming all the function
names, they have a pvscsi_ prefix right now. Since they are defined
static it should be okay to keep them as is, I think.

Yeah, I will make sure that the proc file name and other printk prefixes
are modified with the new module name.

> Actually it's not a paravirt driver either, so something like
> vmwarevscsi would be fine.

I would prefer keeping pvscsi in the module name just so that existing
users are not confused, the adapter that the backend exports is named as
pvscsi too. So something like vmw_pvscsi should be good enough to be
non-generic at the same time being close to our existing module name. 

Thanks,
Alok


