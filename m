From: Ingvar Hagelund <ingvar@linpro.no>
Subject: Re: Qlogic ISP 1020
Date: 31 Oct 2004 22:30:42 +0100
Message-ID: <ujc1xfevam5.fsf@nfsd.linpro.no>
References: <1080004793.5848.34.camel@localhost>
	<20040323062912.B29405@infradead.org>
	<1080075653.2457.11.camel@localhost>
	<20041021091116.GA2130@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from head.linpro.no ([80.232.36.1]:29576 "EHLO head.linpro.no")
	by vger.kernel.org with ESMTP id S261381AbUJaVbK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 31 Oct 2004 16:31:10 -0500
In-Reply-To: <20041021091116.GA2130@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeff Layton <jtlayton@poochiereds.net>, Norbert Preining <preining@logic.at>, Scott Bailey <scott.bailey@eds.com>, Linux SCSI List <linux-scsi@vger.kernel.org>

* Christoph Hellwig
> > > https://verein.lst.de/~hch/qla1280-isp1040.diff.bz2 has my current patch.
(...)
> > > So far I only kno it works with 1040B's on SGI Origins.  If you
> > > want to give it a try apply the patch and make sure you have the
> > > qla1280 but not the qlogicisp driver in the kernel.
> > >
> > > I'll try to split the patch into reasoable chunk soon and feed
> > > it to Jes.

* Jeff Layton
> > I tried this out today, and the results were mixed.

* Christoph Hellwig
> In current mainline the qla1280 driver supports the 1020 now. Care
> to test again?  I've heard success reports for both i386 and alpha
> so far.

Just to mention it, I tried this driver on our Alpha with 2.4.27 (with
the mentioned patch), and it runs rock stable, at least after the
first 24 hours. This finally solved my problems with md raid1 on the
1020, see posting <ujcwty6lp0n.fsf@nfsd.linpro.no>,
 "oops in qlogicisp.c when running 2.4.27 with md RAID1 on Alpha". 
The driver was patched upon 3.24.3 (stolen from kernel 2.6.8.1) and
compiles easily on kernel 2.4.27 with some minor updates in
include/asm-alpha/io.h. It is also a lot more stable than the infamous
feral driver.

Thanks guys, this really made my day.

Norbert, could this be something for the Debian alpha kernels?

Ingvar

-- 
Many that live deserve death. And some that die deserve life. Can you
give it to them? Then do not be too eager to deal out death in
judgement. For even the very wise cannot see all ends.
								Gandalf
