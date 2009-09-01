From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] SCSI driver for VMware's virtual HBA.
Date: Tue, 1 Sep 2009 14:38:37 -0400
Message-ID: <20090901183837.GA22551@infradead.org>
References: <1251415060.16297.58.camel@ank32.eng.vmware.com> <adaws4iod8k.fsf@cisco.com> <20090901161651.GO22870@parisc-linux.org> <200909010933.50571.dtor@vmware.com> <1251823925.3864.216.camel@mulgrave.site> <adaocpuo9vs.fsf@cisco.com> <1251826804.12482.47.camel@mulgrave.site> <1251827676.16169.152.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51325 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbZIASip (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Sep 2009 14:38:45 -0400
Content-Disposition: inline
In-Reply-To: <1251827676.16169.152.camel@ank32.eng.vmware.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alok Kataria <akataria@vmware.com>
Cc: James Bottomley <James.Bottomley@suse.de>, Roland Dreier <rdreier@cisco.com>, Dmitry Torokhov <dtor@vmware.com>, Matthew Wilcox <matthew@wil.cx>, Bart Van Assche <bvanassche@acm.org>, Robert Love <robert.w.love@intel.com>, Randy Dunlap <randy.dunlap@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Rolf Eike Beer <eike-kernel@sf-tec.de>, Maxime Austruy <maustruy@vmware.com>

On Tue, Sep 01, 2009 at 05:54:36PM +0000, Alok Kataria wrote:
> Also note that, the way all these things are implemented for each of the
> hypervisor devices will differ and getting every hv-vendor to agree on a
> common set of things is not very attractive proposition ( atleast, this
> I can say from my past experiences).

virtio is shared by three or four hypervisors depending on how you
count it, with others under development.

