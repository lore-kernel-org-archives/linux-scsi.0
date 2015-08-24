From: Wouter Depuydt <wouter.depuydt@gmail.com>
Subject: Re: [BUG] hpsa: Controller lockup detected: 0x00150028
Date: Mon, 24 Aug 2015 10:02:40 +0000 (UTC)
Message-ID: <loom.20150824T115915-623@post.gmane.org>
References: <20150518124058.GH21418@twins.programming.kicks-ass.net> <EC48209BE0009041A0D3C6A996EAD2AE27A7FAEE@G9W0754.americas.hpqcorp.net> <20150518152034.GC5404@twins.programming.kicks-ass.net> <20150518160345.GA18673@twins.programming.kicks-ass.net> <20150518161146.GB18673@twins.programming.kicks-ass.net> <555F46F4.2090002@redhat.com> <20150522164002.GJ3644@twins.programming.kicks-ass.net> <2C438B34CAC8264398F5C7AF7411910A6347343E@G9W0731.americas.hpqcorp.net> <loom.20150824T113849-717@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:32913 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649AbbHXKC4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Aug 2015 06:02:56 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1ZToab-0002oD-FH
	for linux-scsi@vger.kernel.org; Mon, 24 Aug 2015 12:02:53 +0200
Received: from kulnet-nat-2.kulnet.kuleuven.be ([134.58.253.57])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Mon, 24 Aug 2015 12:02:53 +0200
Received: from wouter.depuydt by kulnet-nat-2.kulnet.kuleuven.be with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Mon, 24 Aug 2015 12:02:53 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Wouter Depuydt <wouter.depuydt <at> gmail.com> writes:

> 
> > -----Original Message-----
> > From: Peter Zijlstra [mailto:peterz <at> infradead.org] 
> > Sent: Friday, May 22, 2015 11:40 AM
> > To: Tomas Henzl
> > Cc: Oelke, Mark; don.brace <at> pmcs.com; ISS StorageDev; storagedev <at>
> pmcs.com; linux-scsi <at> vger.kernel.org
> > Subject: Re: [BUG] hpsa: Controller lockup detected: 0x00150028
> > 
> > On Fri, May 22, 2015 at 05:10:44PM +0200, Tomas Henzl wrote:
> > > >> I've updated to 6.62 and it appears to be working now; or rather,
it has
> > 
> > I've since gotten 6.64 from HP to test; which does not seem public yet.
> > 
> > 6.64 actually fixes the issue for me.
> > 
> 
> Hi everone,
> 
> I've experienced a similar problem with a P411 controller in HBA mode.
> Serial Number	PDNMH0ARH8P04A
> Model	HP Smart Array P441 Controller
> Firmware Version	2.52
> 

Other System info:

HP Proliant D380p Gen9
Ubuntu LTS 14.04
ii  linux-image-3.19.0-26-generic
ii  linux-image-extra-3.19.0-26-generic
ii  linux-image-generic-lts-vivid       

