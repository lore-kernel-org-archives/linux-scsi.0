From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] SCSI driver for VMware's virtual HBA.
Date: Tue, 1 Sep 2009 10:16:51 -0600
Message-ID: <20090901161651.GO22870@parisc-linux.org>
References: <1251415060.16297.58.camel@ank32.eng.vmware.com> <1251739735.16169.20.camel@ank32.eng.vmware.com> <1251741624.18828.83.camel@mulgrave.site> <e2e108260909010412p41fae86ckb6df5cd8a81e3c37@mail.gmail.com> <adaws4iod8k.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:41185 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020AbZIAQQu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Sep 2009 12:16:50 -0400
Content-Disposition: inline
In-Reply-To: <adaws4iod8k.fsf@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <rdreier@cisco.com>
Cc: Bart Van Assche <bvanassche@acm.org>, James Bottomley <James.Bottomley@suse.de>, akataria@vmware.com, Robert Love <robert.w.love@intel.com>, Randy Dunlap <randy.dunlap@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Dmitry Torokhov <dtor@vmware.com>, Rolf Eike Beer <eike-kernel@sf-tec.de>, Maxime Austruy <maustruy@vmware.com>

On Tue, Sep 01, 2009 at 09:12:43AM -0700, Roland Dreier wrote:
> I'm not really sure we should be trying to force drivers to share just
> because they are paravirtualized -- if there is real commonality, then
> sure put it in common code, but different hypervisors are probably as
> different as different hardware.

I really disagree.  This kind of virtualised drivers are pretty much
communication protocols, and not hardware.  As such, why design a new one?
If there's an infelicity in the ibmvscsi protocol, it makes sense to
design a new one.  But being different for the sake of being different
is just a way to generate a huge amount of make-work.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
