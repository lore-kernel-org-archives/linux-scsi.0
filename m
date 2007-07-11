From: MikeW <mw_phil@yahoo.co.uk>
Subject: Re: [PATCH] dtc: Coding police and printk levels
Date: Wed, 11 Jul 2007 08:08:02 +0000 (UTC)
Message-ID: <loom.20070711T100510-576@post.gmane.org>
References: <20070622142629.52519e47@the-village.bc.nu> <20070622180005.GF7535@tree.beaverton.ibm.com> <20070622202802.16118c92@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:38283 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754961AbXGKIKG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jul 2007 04:10:06 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1I8XGr-0006v7-V6
	for linux-scsi@vger.kernel.org; Wed, 11 Jul 2007 10:10:01 +0200
Received: from 57.66.65.38 ([57.66.65.38])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Wed, 11 Jul 2007 10:10:01 +0200
Received: from mw_phil by 57.66.65.38 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Wed, 11 Jul 2007 10:10:01 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Alan Cox <alan <at> lxorguk.ukuu.org.uk> writes:

> 
> On Fri, 22 Jun 2007 11:00:06 -0700
> "Darrick J. Wong" <djwong <at> us.ibm.com> wrote:
> 
> > On Fri, Jun 22, 2007 at 02:26:29PM +0100, Alan Cox wrote:
> > >  <at>  <at>  -244,7 +242,7  <at>  <at> 
> > >  					if (check_signature(base + signatures[sig].offset,
signatures[sig].string,
> strlen(signatures[sig].string))) {
> > >  						addr = bases[current_base].address;
> > >  #if (DTCDEBUG & DTCDEBUG_INIT)
> > > -						printk("scsi-dtc : detected board.\n");
> > > +						printk(KERB_DEBUG "scsi-dtc : detected board.\n");
> > 
> > I think you meant KERN_DEBUG ?
> 
> Thanks - thats a path thats not compiled and I missed that. Will fix it.
> -

I guess we should always test-compile all edited build paths to ensure
we have not broken someone else's build. That's going into my checklist !

Thanks,
MikeW




