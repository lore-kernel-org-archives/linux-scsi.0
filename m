From: Dmitry Torokhov <dtor@vmware.com>
Subject: Re: [PATCH] SCSI driver for VMware's virtual HBA.
Date: Tue, 1 Sep 2009 09:33:50 -0700
Message-ID: <200909010933.50571.dtor@vmware.com>
References: <1251415060.16297.58.camel@ank32.eng.vmware.com> <adaws4iod8k.fsf@cisco.com> <20090901161651.GO22870@parisc-linux.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:41524 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755123AbZIAQds (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Sep 2009 12:33:48 -0400
In-Reply-To: <20090901161651.GO22870@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Roland Dreier <rdreier@cisco.com>, Bart Van Assche <bvanassche@acm.org>, James Bottomley <James.Bottomley@suse.de>, Alok Kataria <akataria@vmware.com>, Robert Love <robert.w.love@intel.com>, Randy Dunlap <randy.dunlap@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Rolf Eike Beer <eike-kernel@sf-tec.de>, Maxime Austruy <maustruy@vmware.com>

On Tuesday 01 September 2009 09:16:51 am Matthew Wilcox wrote:
> On Tue, Sep 01, 2009 at 09:12:43AM -0700, Roland Dreier wrote:
> > I'm not really sure we should be trying to force drivers to share just
> > because they are paravirtualized -- if there is real commonality, then
> > sure put it in common code, but different hypervisors are probably as
> > different as different hardware.
> 
> I really disagree.  This kind of virtualised drivers are pretty much
> communication protocols, and not hardware.  As such, why design a new one?
> If there's an infelicity in the ibmvscsi protocol, it makes sense to
> design a new one.  But being different for the sake of being different
> is just a way to generate a huge amount of make-work.
> 

The same thing can be said about pretty much anything. We don't have
single SCSI, network, etc driver handling every devices in their
respective class, I don't see why it would be different here.
A hypervisor presents the same interface to the guest OS (whether
it is Linux, Solaris or another OS) much like a piece of silicone
does and it may very well be different form other hypervisors.

-- 
Dmitry
