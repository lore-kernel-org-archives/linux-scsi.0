From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] SCSI driver for VMware's virtual HBA.
Date: Wed, 2 Sep 2009 11:50:50 +0200
Message-ID: <e2e108260909020250i60c0a697r84ed900b823544cd@mail.gmail.com>
References: <1251415060.16297.58.camel@ank32.eng.vmware.com>
	 <adaws4iod8k.fsf@cisco.com> <20090901161651.GO22870@parisc-linux.org>
	 <200909010933.50571.dtor@vmware.com>
	 <1251823925.3864.216.camel@mulgrave.site> <adaocpuo9vs.fsf@cisco.com>
	 <1251826804.12482.47.camel@mulgrave.site>
	 <1251827676.16169.152.camel@ank32.eng.vmware.com>
	 <20090901183837.GA22551@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:56001 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbZIBJuu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2009 05:50:50 -0400
In-Reply-To: <20090901183837.GA22551@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Alok Kataria <akataria@vmware.com>, James Bottomley <James.Bottomley@suse.de>, Roland Dreier <rdreier@cisco.com>, Dmitry Torokhov <dtor@vmware.com>, Matthew Wilcox <matthew@wil.cx>, Robert Love <robert.w.love@intel.com>, Randy Dunlap <randy.dunlap@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Rolf Eike Beer <eike-kernel@sf-tec.de>, Maxime Austruy <maustruy@vmware.com>

On Tue, Sep 1, 2009 at 8:38 PM, Christoph Hellwig<hch@infradead.org> wrote:
> On Tue, Sep 01, 2009 at 05:54:36PM +0000, Alok Kataria wrote:
>> Also note that, the way all these things are implemented for each of the
>> hypervisor devices will differ and getting every hv-vendor to agree on a
>> common set of things is not very attractive proposition ( atleast, this
>> I can say from my past experiences).
>
> virtio is shared by three or four hypervisors depending on how you
> count it, with others under development.

Research is ongoing about how to reach higher throughput and lower
latency than what is possible with the virtio interface. See also Jake
Edge, AlacrityVM, August 5, 2009 (http://lwn.net/Articles/345296/).

Bart.
