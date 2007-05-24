From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 14/25] SCSI: use irq_handler_t where appropriate
Date: Thu, 24 May 2007 16:49:38 -0400
Message-ID: <4655FA62.7080406@garzik.org>
References: <200705232141.l4NLfjq9001203@shell0.pdx.osdl.net>	 <4654BB27.6050706@garzik.org>	 <1179960902.5569.48.camel@mulgrave.il.steeleye.com>	 <465527D7.6030909@garzik.org>	 <1180015447.3692.6.camel@mulgrave.il.steeleye.com>	 <20070524081720.5675ad5d.randy.dunlap@oracle.com> <1180020539.3692.30.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:47651 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063AbXEXUtq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 May 2007 16:49:46 -0400
In-Reply-To: <1180020539.3692.30.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>

James Bottomley wrote:
> SCSI is a slightly different subsystem from almost any other in the
> kernel.  It has something like 15 active driver maintainers plus at
> least another 15-25 periodically active ones.  Most (but not all) driver
> maintainers are employed by the company who produces the board/chip and
> tend to be overloaded with a lot of non-linux work.  Requiring acks for
> maintained drivers is a courtesy to make sure we don't get maintainers
> spending time trying to resolve conflicts.  I'm not mandating any
> particular method of getting acks, just noting that cc'ing maintainers
> and having specific subject lines mentioning the driver is a reasonable
> way of getting them to notice.


Linux has never worked that way.  We always have a stream of patches 
that are multi-subsystem cleanups and the like.  Blocking these patches 
for months at a time because individual driver maintainers are off doing 
non-Linux work is just not realistic.

The system is broken, from where I sit.  In pretty much every other 
subsystem in the kernel, the subsystem maintainer makes sure patches 
don't get stuck in limbo for months.

	Jeff


