From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [patch 14/25] SCSI: use irq_handler_t where appropriate
Date: Thu, 24 May 2007 10:28:31 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF019E1CEF@otce2k301.adaptec.com>
References: <1180015447.3692.6.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:48222 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbXEXO2d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 May 2007 10:28:33 -0400
Content-class: urn:content-classes:message
In-reply-to: <1180015447.3692.6.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jeff Garzik <jeff@garzik.org>
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>

Not being defensive.

This is not just a maintainer's issue. We see the silent ACK treatment
all the time from all avenues of inspection whether they be maintainers,
illuminati, interested parties or JAFO. There is a little bit of a
volunteer in every one of us.

Requiring the maintainer to be cc'd is a burden on the submitter, I do
not want to spank someone that comes up with a useful patch that fails
some bureaucratic litmus test. It is still a good idea, but lets try a
different tactic?

James, you are a volunteer, so I can not require an increase in your
burden. But it would be 'nice' if you had a git tree that reported
pending approval (so that makes three persistent trees if I am correct,
scsi-misc-2.6, scsi-rc-fixes-2.6 and scsi-pending-2.6?). This way we can
tell that you saw it, and as a maintainer we can see a change even if we
missed the patch email. It does make it hard for the maintainer to
report *which* patch to approve, but he could do a blanket approval of
what he sees in the pending tree? AndrewM can tell that he no longer
needs to track the patch, as it is now the SCSI list's responsibility
once it is in the pending tree.

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
> Sent: Thursday, May 24, 2007 10:04 AM
> To: Jeff Garzik
> Cc: akpm@linux-foundation.org; linux-scsi@vger.kernel.org; 
> Salyzyn, Mark; Andrew Vasquez
> Subject: Re: [patch 14/25] SCSI: use irq_handler_t where appropriate
> 
> 
> On Thu, 2007-05-24 at 01:51 -0400, Jeff Garzik wrote:
> > James Bottomley wrote:
> > > It's not a bug fix or even an enhancement.  Historically, 
> it is quite
> > > difficult to get maintainers to ack these ... 
> particularly if you don't
> > > cc them.
> > 
> > If neither you nor the maintainers are reading and 
> responding to patches 
> > sent to linux-scsi, I don't think the problem is sitting in 
> my chair.
> 
> Oh come off it ... You've been around long enough to know that
> maintainers are not always watching everything ... it would be nice if
> they were, but to give a patch the best shot at review, you try to
> attract their attention.  Specifically, in this case, you 
> should cc the
> maintainers and you should have a subject line explaining that you are
> modifying their driver.  It is very easy to ignore a patch 
> that's simply
> waved at the SCSI list with a generic subject line.
> 
> > If others have SCSI patches that have been sitting in limbo 
> for weeks or 
> > months, send them to me, and I'll queue them in misc-2.6.git#scsi.
> 
> James
> 
> 
> 
