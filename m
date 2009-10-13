From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: SCSI driver for VMware's virtual HBA - V5.
Date: Tue, 13 Oct 2009 14:35:57 +0000
Message-ID: <1255444557.2855.95.camel@localhost.localdomain>
References: <1254336812.19921.23.camel@ank32.eng.vmware.com>
	 <20091002004725.GP3958@sequoia.sous-sol.org>
	 <1254789028.15233.54.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760020AbZJMOgs@vger.kernel.org>
In-Reply-To: <1254789028.15233.54.camel@ank32.eng.vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
To: akataria@vmware.com
Cc: Chris Wright <chrisw@sous-sol.org>, Randy Dunlap <randy.dunlap@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, Bart Van Assche <bvanassche@acm.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>, "pv-drivers@vmware.com" <pv-drivers@vmware.com>, Roland Dreier <rdreier@cisco.com>, LKML <linux-kernel@vger.kernel.org>, "Chetan.Loke@Emulex.Com" <Chetan.Loke@Emulex.Com>, Brian King <brking@linux.vnet.ibm.com>, Rolf Eike Beer <eike-kernel@sf-tec.de>, Robert Love <robert.w.love@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Daniel Walker <dwalker@fifo99.com>, Greg KH <gregkh@suse.de>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2009-10-05 at 17:30 -0700, Alok Kataria wrote:
> > Were you still planning on renaming the driver to something less generic
> > (like vmw_pvscsi)?
> 
> 
> Yep, below is a patch with the rename, the driver is now called
> vmw_pvscsi. Do let me know if you have any other comments. Thanks.

I'm still curious to know what the 'p' in the name stands for.  Surely
this is a fully virtual driver, not a paravirtual one?

James
