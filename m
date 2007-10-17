From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [GIT PATCH] SCSI updates for 2.6.24
Date: Wed, 17 Oct 2007 08:08:03 -0400
Message-ID: <1192622883.28752.15.camel@localhost.localdomain>
References: <1192421381.3429.6.camel@localhost.localdomain>
	 <20071017132026D.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:56613 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753874AbXJQMIH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Oct 2007 08:08:07 -0400
In-Reply-To: <20071017132026D.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 2007-10-17 at 13:20 +0900, FUJITA Tomonori wrote:
> On Mon, 15 Oct 2007 00:09:41 -0400
> James Bottomley <James.Bottomley@SteelEye.com> wrote:
> 
> > This is the accumulated updates queued for 2.6.24.  It contains the
> > usual slew of driver updates, plus some gdth and advansys rewrites.  We
> > still have some outstanding bugs in gdth and fc4 for which I'm hoping to
> > sweep fixes into the next update.
> > 
> > The patch is available here:
> > 
> > master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
> > 
> > The short changelog is:
> 
> (snip)
> 
> > James Bottomley (4):
> >       Fix device not ready printk
> >       sg: use idr to replace static arrays
> >       move ULD attachment into the prep function
> >       arcmsr: fix compile problems
> 
> The patch to beautify supported_mode and active_mode in sysfs?
> 
> http://marc.info/?l=linux-kernel&m=119077857701415&w=2

Well, I suppose losing your own patches is a sign of fairness in patch
loss ... OK I'll stick them in.

James


