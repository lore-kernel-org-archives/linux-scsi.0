From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/8] mvsas: fill in error info record and phy
	mode6	bits.
Date: Thu, 27 Mar 2008 08:35:34 -0700
Message-ID: <1206632134.3239.21.camel@localhost.localdomain>
References: <47E39568.60407@marvell.com>
	 <1206565072.3019.39.camel@localhost.localdomain>
	 <47EB4AF5.1070500@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:58486 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753906AbYC0Pfp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Mar 2008 11:35:45 -0400
In-Reply-To: <47EB4AF5.1070500@marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kewei@marvell.com
Cc: linux-scsi@vger.kernel.org, jeff@garzik.org, jacky@marvell.com, qzhao@marvell.com, qswang@marvell.com

On Thu, 2008-03-27 at 15:21 +0800, Ke Wei wrote:
> James Bottomley wrote:
> > On Fri, 2008-03-21 at 19:00 +0800, Ke Wei wrote:
> >> and remove some unused members from struct.
> > 
> > This patch (and the following ones) look great.  I'm afraid I can't
> > apply them, though ... it looks like your mail tool has stripped some
> > leading spaces:
> > 
> >> @@ -37,11 +37,13 @@
> >> #include <linux/dma-mapping.h>
> >> #include <linux/ctype.h>
> >> #include <scsi/libsas.h>
> >> +#include <scsi/scsi_tcq.h>
> >> +#include <scsi/sas_ata.h>
> >> #include <asm/io.h>
> > 
> > And also added line breaks:
> > 
> >> +    PHY_MODE6_MUCNT_EN    = (1U << 24),    /* u Count Enable */
> >> +    PHY_MODE6_SEL_MUCNT_LEN    = (1U << 22),    /* Training Length
> >> Select */
> >> +    PHY_MODE6_SELMUPI    = (1U << 20),    /* Phase Multi Select (init) */
> > 
> > If you need to add the patches as an attachment to get them through your
> > mailer undamaged, that's fine ... the tools we have will cope with that.
> > 
> > Thanks,
> > 
> > James
> > 
> > 
> 
> Hello James:
> 	I resended mvsas patch set to community. Thank you for your help. I
> am moving my email client from Outlook to Thunderbird. So sometimes I
> need to try some configuration. 

Thanks ... although we have contributors whose use of outlook is
mandated by their companies ... although they tend to have to attach
patches instead of inlining them.

Thunderbird apparently can be a bit of a problem.  There's a section
about configuring it in the kernel documentation:

Documentation/email-clients.txt

> 	I have already past mvsas driver testing. By far, look well. If you
> have any suggestions to help me, pls let me know.

Will do ... let me review the patches first (got a long flight coming
up).

Thanks,

James



