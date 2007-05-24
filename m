From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [patch 14/25] SCSI: use irq_handler_t where appropriate
Date: Thu, 24 May 2007 08:17:20 -0700
Message-ID: <20070524081720.5675ad5d.randy.dunlap@oracle.com>
References: <200705232141.l4NLfjq9001203@shell0.pdx.osdl.net>
	<4654BB27.6050706@garzik.org>
	<1179960902.5569.48.camel@mulgrave.il.steeleye.com>
	<465527D7.6030909@garzik.org>
	<1180015447.3692.6.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:11782 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbXEXPL4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 May 2007 11:11:56 -0400
In-Reply-To: <1180015447.3692.6.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jeff Garzik <jeff@garzik.org>, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>

On Thu, 24 May 2007 09:04:06 -0500 James Bottomley wrote:

> On Thu, 2007-05-24 at 01:51 -0400, Jeff Garzik wrote:
> > James Bottomley wrote:
> > > It's not a bug fix or even an enhancement.  Historically, it is quite
> > > difficult to get maintainers to ack these ... particularly if you don't
> > > cc them.
> > 
> > If neither you nor the maintainers are reading and responding to patches 
> > sent to linux-scsi, I don't think the problem is sitting in my chair.
> 
> Oh come off it ... You've been around long enough to know that
> maintainers are not always watching everything ... it would be nice if
> they were, but to give a patch the best shot at review, you try to
> attract their attention.  Specifically, in this case, you should cc the
> maintainers and you should have a subject line explaining that you are
> modifying their driver.  It is very easy to ignore a patch that's simply
> waved at the SCSI list with a generic subject line.

I can understand subsystem maintainers ignoring lkml, but ignoring
the subsystem mailing list makes no sense to me, especially if the
subject contains "[PATCH]".

> > If others have SCSI patches that have been sitting in limbo for weeks or 
> > months, send them to me, and I'll queue them in misc-2.6.git#scsi.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
