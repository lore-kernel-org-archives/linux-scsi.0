From: Jesse Barnes <jbarnes@engr.sgi.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Fri, 17 Sep 2004 10:21:20 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200409171021.20263.jbarnes@engr.sgi.com>
References: <B179AE41C1147041AA1121F44614F0B060EF48@AVEXCH02.qlogic.org> <20040916152552.232ccbe7.akpm@osdl.org> <200409161529.10122.jbarnes@engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:42450 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S268864AbUIQRVw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Sep 2004 13:21:52 -0400
In-Reply-To: <200409161529.10122.jbarnes@engr.sgi.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, linux-scsi@vger.kernel.org, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, jbarnes@cthulhu.engr.sgi.com

On Thursday, September 16, 2004 3:29 pm, Jesse Barnes wrote:
> On Thursday, September 16, 2004 3:25 pm, Andrew Morton wrote:
> > Andrew Vasquez <andrew.vasquez@qlogic.com> wrote:
> > > Andrew, please add Jesse's patch along with the patch I'm attaching to
> > > your tree.  I'll be sure to add the ia64 machine back into our test
> > > ring.
> >
> > Could someone send me Jesse's patch?
>
> Here it is.
>
> Reduce some overaggressive compensation for PCI write posting.  In some
> cases we don't actually want to read a value back, since the card could be
> resetting.
>
> Signed-off-by: Jesse Barnes <jbarnes@sgi.com>

Btw Andrew (Vasquez), there's a small doc I put together that should describe 
when you have to worry about PCI posting.  It's in the tree:  
Documentation/io_ordering.txt.  If it's incomplete or confusing, just let me 
know and I'll update it.

Thanks,
Jesse
