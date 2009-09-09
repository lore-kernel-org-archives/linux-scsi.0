From: Alok Kataria <akataria@vmware.com>
Subject: Re: [PATCH] SCSI driver for VMware's virtual HBA - V4.
Date: Wed, 09 Sep 2009 09:56:52 -0700
Message-ID: <1252515412.16631.6.camel@ank32.eng.vmware.com>
References: <1252458903.24914.73.camel@ank32.eng.vmware.com>
	 <1252459596.14793.46.camel@desktop>
	 <1252472481.2508.20.camel@ank32.eng.vmware.com>
	 <200909090754.22778.eike-kernel@sf-tec.de>
Reply-To: akataria@vmware.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:54703 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752845AbZIIQ4t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Sep 2009 12:56:49 -0400
In-Reply-To: <200909090754.22778.eike-kernel@sf-tec.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Daniel Walker <dwalker@fifo99.com>, James Bottomley <James.Bottomley@suse.de>, Brian King <brking@linux.vnet.ibm.com>, "Chetan.Loke@Emulex.Com" <Chetan.Loke@emulex.com>, Matthew Wilcox <matthew@wil.cx>, Roland Dreier <rdreier@cisco.com>, Bart Van Assche <bvanassche@acm.org>, Robert Love <robert.w.love@intel.com>, Randy Dunlap <randy.dunlap@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "pv-drivers@vmware.com" <pv-drivers@vmware.com>

Hi Eike,

On Tue, 2009-09-08 at 22:54 -0700, Rolf Eike Beer wrote:
> Alok Kataria wrote:
> 
> > +/* Command line parameters */
> > +static int pvscsi_ring_pages     = PVSCSI_DEFAULT_NUM_PAGES_PER_RING;
> > +static int pvscsi_msg_ring_pages = PVSCSI_DEFAULT_NUM_PAGES_MSG_RING;
> > +static int pvscsi_cmd_per_lun    = PVSCSI_DEFAULT_QUEUE_DEPTH;
> > +static int pvscsi_disable_msi;
> > +static int pvscsi_disable_msix;
> > +static int pvscsi_use_msg        = true;
> 
> Should be bool.

Yeah, could be done, though I think I will do this later as an
incremental change or piggyback it if something else comes up.

> 
> Do I get annoying? ;)

:) Do you want the truth ? ;).

Actually its good that the code is being reviewed in so much details.
Thanks for your time on this.

--Alok 

> 
> Eike

