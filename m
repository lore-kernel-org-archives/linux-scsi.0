From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 14/25] SCSI: use irq_handler_t where appropriate
Date: Wed, 23 May 2007 17:55:02 -0500
Message-ID: <1179960902.5569.48.camel@mulgrave.il.steeleye.com>
References: <200705232141.l4NLfjq9001203@shell0.pdx.osdl.net>
	 <4654BB27.6050706@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:45542 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756070AbXEWWzE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 May 2007 18:55:04 -0400
In-Reply-To: <4654BB27.6050706@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org, "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>

On Wed, 2007-05-23 at 18:07 -0400, Jeff Garzik wrote:
> akpm@linux-foundation.org wrote:
> > From: Jeff Garzik <jeff@garzik.org>
> > 
> > Signed-off-by: Jeff Garzik <jeff@garzik.org>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> > 
> >  drivers/scsi/aacraid/aacraid.h |    2 +-
> >  drivers/scsi/qla2xxx/qla_isr.c |    2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> hrm.  This appears to have been sent to linux-scsi at least three times.
> 
> If it doesn't stick, I'll go ahead and send it up myself.

It's not a bug fix or even an enhancement.  Historically, it is quite
difficult to get maintainers to ack these ... particularly if you don't
cc them.

James


