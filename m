From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH v2 00/16] st: remove scsi_execute_async usage (the second half)
Date: Fri, 26 Dec 2008 20:04:46 +0100
Message-ID: <20081226190445.GP32491@kernel.dk>
References: <1229579391-28753-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <20081225235112T.fujita.tomonori@lab.ntt.co.jp> <alpine.LNX.2.00.0812252236420.24561@kai.makisara.local> <20081226113607L.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:9420 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbYLZTFc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Dec 2008 14:05:32 -0500
Content-Disposition: inline
In-Reply-To: <20081226113607L.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Kai.Makisara@kolumbus.fi, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Fri, Dec 26 2008, FUJITA Tomonori wrote:
> On Thu, 25 Dec 2008 23:17:51 +0200 (EET)
> Kai Makisara <Kai.Makisara@kolumbus.fi> wrote:
> 
> > On Thu, 25 Dec 2008, FUJITA Tomonori wrote:
> > 
> > > On Thu, 18 Dec 2008 14:49:35 +0900
> > > FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > > 
> > > > This patchset is the second version of the second half patchset to
> > > > remove scsi_execute_async in st driver (IOW, this converts st driver
> > > > to use the block layer functions).
> > > > 
> > > > http://marc.info/?l=linux-scsi&m=122900494917385&w=2
> > > > 
> > > > I've not changed the st patches much since the first version. No
> > > > change to the #4-14 st patches except for cleanups to silence
> > > > checkpatch.sh. The new #15-16 patches for st came from Kai, who
> > > > greatly helped me out with this patchset.
> > > 
> > > Kai, can I get your ACK on these patches?
> > > 
> > Yes. I tested the patches and did not see any problems.
> 
> Thanks a lot!
> 
> 
> Jens, merging the following patches for block via James' tree is ok?

Yes, you can add my acked-by to them as well.

-- 
Jens Axboe

