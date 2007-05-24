From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [patch 14/25] SCSI: use irq_handler_t where appropriate
Date: Thu, 24 May 2007 09:32:58 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF019E1CB7@otce2k301.adaptec.com>
References: <1179960902.5569.48.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:47146 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757044AbXEXNdB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 May 2007 09:33:01 -0400
Content-class: urn:content-classes:message
In-reply-to: <1179960902.5569.48.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jeff Garzik <jeff@garzik.org>
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>

I ACK the portion that resides in aacraid.h, and will track and push it
in the future if it does not stick ;->

I will comment for any dpt_i2o, ips or aacraid patches posted to the
SCSI list from submissions from folks not working at Adaptec once unit
tested, accepted into the Adaptec upstreamed source or code inspected;
as a matter of form. There will be no *requirement* to cc my maintainer
address.

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
> Sent: Wednesday, May 23, 2007 6:55 PM
> To: Jeff Garzik
> Cc: akpm@linux-foundation.org; linux-scsi@vger.kernel.org; 
> Salyzyn, Mark; Andrew Vasquez
> Subject: Re: [patch 14/25] SCSI: use irq_handler_t where appropriate
> 
> 
> On Wed, 2007-05-23 at 18:07 -0400, Jeff Garzik wrote:
> > akpm@linux-foundation.org wrote:
> > > From: Jeff Garzik <jeff@garzik.org>
> > > 
> > > Signed-off-by: Jeff Garzik <jeff@garzik.org>
> > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > > ---
> > > 
> > >  drivers/scsi/aacraid/aacraid.h |    2 +-
> > >  drivers/scsi/qla2xxx/qla_isr.c |    2 +-
> > >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > hrm.  This appears to have been sent to linux-scsi at least 
> three times.
> > 
> > If it doesn't stick, I'll go ahead and send it up myself.
> 
> It's not a bug fix or even an enhancement.  Historically, it is quite
> difficult to get maintainers to ack these ... particularly if 
> you don't
> cc them.
> 
> James
> 
> 
> 
