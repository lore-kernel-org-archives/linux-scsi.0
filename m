From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: broken dpt_i2o in 2.6.23 (was: ext2_check_page: bad entry in
 directory)
Date: Wed, 5 Dec 2007 23:08:33 -0800
Message-ID: <20071205230833.546a1da9.akpm@linux-foundation.org>
References: <20071205103054B.fujita.tomonori@lab.ntt.co.jp>
	<20071204185152.880af2cf.akpm@linux-foundation.org>
	<20071205101441.GO7697@1und1.de>
	<20071206144937T.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43097 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753040AbXLFHJL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Dec 2007 02:09:11 -0500
In-Reply-To: <20071206144937T.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: anders.henke@1und1.de, matthew@wil.cx, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, James Bottomley <James.Bottomley@steeleye.com>

On Thu, 06 Dec 2007 14:49:37 +0900 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> > >  drivers/scsi/dpt_i2o.c |  132 ++++++++++++++++++---------------------
> > >  drivers/scsi/dpti.h    |    9 ++
> > >  2 files changed, 68 insertions(+), 73 deletions(-)
> > 
> > I've done the following:
> > 
> > -untared a clean 2.6.24-rc4 and compiled it with my 2.6.23.1-settings in order
> >  to verify that the driver is still broken: checked, the box still won't 
> >  boot.
> > 
> > -patched the just compiled kernel source with your patch, "make dist-clean"
> >  (by means of "make-kpkg clean") and recompile: box boots fine.
> >
> > I've put the captured console logs to
> > http://w.sysiphus.de/dpt_i2o/bootlog.2624-rc4-pristine
> > http://w.sysiphus.de/dpt_i2o/bootlog.2624-rc4-patched
> > ... and the kernelconfig (which shouldn't matter) to
> > http://w.sysiphus.de/dpt_i2o/kernelconfig.2624-rc4
> 
> Thanks for testing. So reverting Matthew's hotplug patch fixes the
> problem though I have no idea how the patch leads to this. Seems that
> nobody has any clue on that. We need to revert that patch for the
> moment.

OK, thanks.  Let's leave it a couple of days for people to register objections,
have bright ideas, etc.

