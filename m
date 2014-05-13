From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH] iscsi_ibft: search for broadcom specific ibft sign
Date: Tue, 13 May 2014 14:54:10 -0400
Message-ID: <20140513185410.GA8624@phenom.dumpdata.com>
References: <1399453220-21663-1-git-send-email-vikas.chaudhary@qlogic.com>
 <536A831C.4060307@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48247 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbaEMSzE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 May 2014 14:55:04 -0400
Content-Disposition: inline
In-Reply-To: <536A831C.4060307@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: vikas.chaudhary@qlogic.com, jbottomley@parallels.com, pjones@redhat.com, konrad@kernel.org, linux-scsi@vger.kernel.org, giridhar.malavali@qlogic.com, iscsi-driver@qlogic.com

On Wed, May 07, 2014 at 02:01:48PM -0500, Mike Christie wrote:
> On 05/07/2014 04:00 AM, vikas.chaudhary@qlogic.com wrote:
> > From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> > 
> > Broadcom iscsi offload firmware uses a non standard ibft sign of "BIFT".
> > This patch modifies the ibft search code to search for "BIFT" along
> > with the other possible values.
> > 
> > Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> > Acked-by: Kevin Tran <ktran@broadcom.com>
> > Acked-by: Eddie Wai <eddie.wai@broadcom.com>
> > ---
> >  drivers/firmware/iscsi_ibft.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/firmware/iscsi_ibft.c b/drivers/firmware/iscsi_ibft.c
> > index 3ee852c..071c2c9 100644
> > --- a/drivers/firmware/iscsi_ibft.c
> > +++ b/drivers/firmware/iscsi_ibft.c
> > @@ -756,6 +756,7 @@ static const struct {
> >  	 */
> >  	{ ACPI_SIG_IBFT },
> >  	{ "iBFT" },
> > +	{ "BIFT" },	/* Broadcom iSCSI Offload */
> >  };
> >  
> >  static void __init acpi_find_ibft_region(void)
> > 
> 
> Patch looks ok to me.
> 
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

I've converted your SoB in an Ack-by as this patch is not going
through your tree but mine.
