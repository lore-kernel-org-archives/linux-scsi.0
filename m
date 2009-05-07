From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [GIT PATCH] block,scsi,ide: unify sector and data_len, take#2
Date: Thu, 7 May 2009 19:23:34 +0900
Message-ID: <20090507192427K.fujita.tomonori@lab.ntt.co.jp>
References: <1241423927-11871-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:38424 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756850AbZEGK2L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 May 2009 06:28:11 -0400
In-Reply-To: <1241423927-11871-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tj@kernel.org
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com, mike.miller@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp, zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au, grant.likely@secretlab.ca, paul.clements@steeleye.com, tim@cyberelk.net, jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net, rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com, bharrosh@panasas.com

On Mon,  4 May 2009 16:58:36 +0900
Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> Upon ack, please pull from the following git tree.
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-unify-sector-and-data_len
> 
> This is the second take of block-unify-sector-and-data_len patchset.
> The primary goal of this patchset is to consolidate all the similar
> bug slightly different current position and data length fields in
> struct request.  For detailed description, please read the description
> in the last take[L].  Changes from the last take[L] are

Looks really nice. Finally, the block insulates the internal! SCSI
did two years ago ;)
