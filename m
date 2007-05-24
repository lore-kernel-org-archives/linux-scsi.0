From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 14/25] SCSI: use irq_handler_t where appropriate
Date: Thu, 24 May 2007 16:52:46 -0400
Message-ID: <4655FB1E.7050701@garzik.org>
References: <200705232141.l4NLfjq9001203@shell0.pdx.osdl.net>	 <4654BB27.6050706@garzik.org>	 <1179960902.5569.48.camel@mulgrave.il.steeleye.com>	 <465527D7.6030909@garzik.org> <1180015447.3692.6.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:47688 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbXEXUwt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 May 2007 16:52:49 -0400
In-Reply-To: <1180015447.3692.6.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org, "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>

James Bottomley wrote:
> On Thu, 2007-05-24 at 01:51 -0400, Jeff Garzik wrote:
>> James Bottomley wrote:
>>> It's not a bug fix or even an enhancement.  Historically, it is quite
>>> difficult to get maintainers to ack these ... particularly if you don't
>>> cc them.
>> If neither you nor the maintainers are reading and responding to patches 
>> sent to linux-scsi, I don't think the problem is sitting in my chair.
> 
> Oh come off it ... You've been around long enough to know that
> maintainers are not always watching everything ... it would be nice if
> they were, but to give a patch the best shot at review, you try to
> attract their attention.  Specifically, in this case, you should cc the
> maintainers and you should have a subject line explaining that you are
> modifying their driver.  It is very easy to ignore a patch that's simply
> waved at the SCSI list with a generic subject line.

If individual driver maintainers are not paying attention to what is 
going on in their subsystem, and in the kernel as a whole, then the 
problem does not lie with the external patch author.

	Jeff



