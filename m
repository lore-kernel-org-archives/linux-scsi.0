From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [GIT PATCH] block,scsi,ide: unify sector and data_len, take#2
Date: Fri, 8 May 2009 11:06:07 +0900
Message-ID: <20090508110630H.fujita.tomonori@lab.ntt.co.jp>
References: <1241423927-11871-1-git-send-email-tj@kernel.org>
	<20090507192427K.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:35971 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041AbZEHCKm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 May 2009 22:10:42 -0400
In-Reply-To: <20090507192427K.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp
Cc: tj@kernel.org, axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com, mike.miller@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu, zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au, grant.likely@secretlab.ca, paul.clements@steeleye.com, tim@cyberelk.net, jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net, rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com, bharrosh@panasas.com

On Thu, 7 May 2009 19:23:34 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Mon,  4 May 2009 16:58:36 +0900
> Tejun Heo <tj@kernel.org> wrote:
> 
> > Hello,
> > 
> > Upon ack, please pull from the following git tree.
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-unify-sector-and-data_len
> > 
> > This is the second take of block-unify-sector-and-data_len patchset.
> > The primary goal of this patchset is to consolidate all the similar
> > bug slightly different current position and data length fields in
> > struct request.  For detailed description, please read the description
> > in the last take[L].  Changes from the last take[L] are
> 
> Looks really nice. Finally, the block insulates the internal! SCSI
> did two years ago ;)

btw, you are still working on the cleanups of the block API, right?

I also want to see some cleanups of request completion functions a bit
(e.g. we don't need _bidi_ stuff, we have too many completion
functions, etc...).
