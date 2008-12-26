From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH v2 00/16] st: remove scsi_execute_async usage (the
 second half)
Date: Fri, 26 Dec 2008 11:36:29 +0900
Message-ID: <20081226113607L.fujita.tomonori@lab.ntt.co.jp>
References: <1229579391-28753-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<20081225235112T.fujita.tomonori@lab.ntt.co.jp>
	<alpine.LNX.2.00.0812252236420.24561@kai.makisara.local>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:60562 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194AbYLZCkq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Dec 2008 21:40:46 -0500
In-Reply-To: <alpine.LNX.2.00.0812252236420.24561@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi, jens.axboe@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Thu, 25 Dec 2008 23:17:51 +0200 (EET)
Kai Makisara <Kai.Makisara@kolumbus.fi> wrote:

> On Thu, 25 Dec 2008, FUJITA Tomonori wrote:
> 
> > On Thu, 18 Dec 2008 14:49:35 +0900
> > FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > 
> > > This patchset is the second version of the second half patchset to
> > > remove scsi_execute_async in st driver (IOW, this converts st driver
> > > to use the block layer functions).
> > > 
> > > http://marc.info/?l=linux-scsi&m=122900494917385&w=2
> > > 
> > > I've not changed the st patches much since the first version. No
> > > change to the #4-14 st patches except for cleanups to silence
> > > checkpatch.sh. The new #15-16 patches for st came from Kai, who
> > > greatly helped me out with this patchset.
> > 
> > Kai, can I get your ACK on these patches?
> > 
> Yes. I tested the patches and did not see any problems.

Thanks a lot!


Jens, merging the following patches for block via James' tree is ok?


> The #1-3 patches are for the block layer.
> 
> The first patch is a slightly modified version of the following fix (I
> modified it for the later changes):
> 
> http://marc.info/?l=linux-scsi&m=122927795113939&w=2
> 
> The second patch is a patch to fix the partial mappings with
> rq_map_data struct. Kai found this problem (which leads to data
> corruption).
> 
> The first and second patches fix the bugs which affect sg.
> 
> The third patch is the first patch in the previous patchset. It's a
> necessary change to the block layer to support st/osst. I slightly
> modified it due to the first and second patches.
