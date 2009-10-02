From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: SCSI driver for VMware's virtual HBA - V5.
Date: Fri, 02 Oct 2009 01:43:12 +0000
Message-ID: <1254447792.3885.72.camel@mulgrave.site>
References: <1254336812.19921.23.camel@ank32.eng.vmware.com>
	 <20091002004725.GP3958@sequoia.sous-sol.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34403 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932068AbZJBBnV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Oct 2009 21:43:21 -0400
In-Reply-To: <20091002004725.GP3958@sequoia.sous-sol.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Wright <chrisw@sous-sol.org>
Cc: Alok Kataria <akataria@vmware.com>, Randy Dunlap <randy.dunlap@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, Bart Van Assche <bvanassche@acm.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>, "pv-drivers@vmware.com" <pv-drivers@vmware.com>, Roland Dreier <rdreier@cisco.com>, LKML <linux-kernel@vger.kernel.org>, "Chetan.Loke@Emulex.Com" <Chetan.Loke@Emulex.Com>, Brian King <brking@linux.vnet.ibm.com>, Rolf Eike Beer <eike-kernel@sf-tec.de>, Robert Love <robert.w.love@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Daniel Walker <dwalker@fifo99.com>, Greg KH <gregkh@suse.de>

On Thu, 2009-10-01 at 17:47 -0700, Chris Wright wrote:
> * Alok Kataria (akataria@vmware.com) wrote:
> > VMware PVSCSI driver - v5.
> 
> Were you still planning on renaming the driver to something less generic
> (like vmw_pvscsi)?

Actually it's not a paravirt driver either, so something like
vmwarevscsi would be fine.

James


