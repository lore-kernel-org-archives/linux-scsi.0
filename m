From: Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH] SCSI driver for VMware's virtual HBA.
Date: Tue, 01 Sep 2009 10:25:11 -0700
Message-ID: <adaocpuo9vs.fsf@cisco.com>
References: <1251415060.16297.58.camel@ank32.eng.vmware.com>
	<adaws4iod8k.fsf@cisco.com> <20090901161651.GO22870@parisc-linux.org>
	<200909010933.50571.dtor@vmware.com>
	<1251823925.3864.216.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-3.cisco.com ([171.71.176.72]:3083 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbZIARZL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Sep 2009 13:25:11 -0400
In-Reply-To: <1251823925.3864.216.camel@mulgrave.site> (James Bottomley's
	message of "Tue, 01 Sep 2009 11:52:05 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Dmitry Torokhov <dtor@vmware.com>, Matthew Wilcox <matthew@wil.cx>, Bart Van Assche <bvanassche@acm.org>, Alok Kataria <akataria@vmware.com>, Robert Love <robert.w.love@intel.com>, Randy Dunlap <randy.dunlap@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Rolf Eike Beer <eike-kernel@sf-tec.de>, Maxime Austruy <maustruy@vmware.com>


 > Nobody said you had to have the exact same driver for every hypervisor.
 > What people are suggesting is that we look at commonalities in the
 > interfaces both from a control plane point of view (transport class) and
 > from a code sharing point of view (libscsivirt).  However, all the
 > hypervisor interfaces I've seen are basically DMA rings ...

I don't think that's anything special about hypervisors though -- pretty
much all modern device interfaces are basically DMA rings, aren't they?
I'm definitely in favor of common code to handle commonality but on the
other hand I don't see what's so special about virtual devices vs. real
HW devices.  One the one side we have VMware's closed hypervisor code
and on the other side we have vendor XYZ's closed RTL and firmware code.

 - R.
