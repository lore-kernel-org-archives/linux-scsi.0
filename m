From: Jens Axboe <axboe@suse.de>
Subject: Re: smp dead lock of io_request_lock/queue_lock patch
Date: Mon, 12 Jan 2004 16:43:45 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040112154345.GE1255@suse.de>
References: <OF2581AA2D.BFD408D2-ONC1256E19.004BE052-C1256E19.004E1561@de.ibm.com> <20040112141330.GH24638@suse.de> <1073920110.3114.268.camel@compaq.xsintricity.com> <1073921054.2186.16.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:53227 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S266299AbUALPoV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jan 2004 10:44:21 -0500
Content-Disposition: inline
In-Reply-To: <1073921054.2186.16.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Doug Ledford <dledford@redhat.com>, Martin Peschke3 <MPESCHKE@de.ibm.com>, Arjan van de Ven <arjanv@redhat.com>, Peter Yao <peter@exavio.com.cn>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi mailing list <linux-scsi@vger.kernel.org>

On Mon, Jan 12 2004, James Bottomley wrote:
> On Mon, 2004-01-12 at 10:08, Doug Ledford wrote:
> > >From my standpoint, we are going to be maintaining our 2.4 kernel RPMs
> > for a long time, so my preference is to have it in mainline.  On top of
> > the performance stuff I have also been building some actual bug fix
> > patches.  They depend on the behavior of the patched kernels, and in
> > some cases would be difficult to put on top of a non-iorl patched scsi
> > stack.  In any case, my current plans include putting my 2.4 scsi stack
> > stuff up for perusal on linux-scsi.bkbits.net/scsi-dledford-2.4 as soon
> > as I can sort through the patches and break them into small pieces.
> 
> I was thinking about opening at least a 2.4 drivers tree given some of
> the issues in 2.4 and driver updates swirling around on this list.
> 
> But, if you're going to be maintaining 2.4 for Red Hat, would you like
> to take point position for reviewing 2.4 patches and passing them on to
> Marcelo via a BK tree?

I think that would be a swell idea (assigning a 2.4 SCSI point person),
for driver updates. It'll be hard to pass tested stuff though, if it all
comes from vendor trees which are vastly different in some places.

Changing core drastically is not an option in my book, for 2.4.

-- 
Jens Axboe

