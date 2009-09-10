From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: [PATCH][RESUBMIT] scsi_dh_rdac: Fix for returning correct mode
	select cmd return info
Date: Thu, 10 Sep 2009 15:54:19 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF474D3F5AB@cosmail01.lsi.com>
References: <E463DF2B2E584B4A82673F53D62C2EF474C65F39@cosmail01.lsi.com>
 <1251481851.20333.3.camel@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og116.obsmtp.com ([64.18.2.219]:60602 "EHLO
	exprod7og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903AbZIJVyd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Sep 2009 17:54:33 -0400
In-Reply-To: <1251481851.20333.3.camel@chandra-ubuntu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@suse.de" <James.Bottomley@suse.de>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'dm-devel@redhat.com'" <dm-devel@redhat.com>, Chandra Seetharaman <sekharan@us.ibm.com>

James,
   Can you please pick this up for next scsi update.. I have made sure that checkpatch.pl runs fine on this . ):
Thanks
Babu Moger 

> -----Original Message-----
> From: Chandra Seetharaman [mailto:sekharan@us.ibm.com]
> Sent: Friday, August 28, 2009 12:51 PM
> To: Moger, Babu
> Cc: 'linux-scsi@vger.kernel.org'; 'dm-devel@redhat.com'; Chauhan,
> Vijay; Stankey, Robert; Dachepalli, Sudhir
> Subject: Re: [PATCH][RESUBMIT] scsi_dh_rdac: Fix for returning correct
> mode select cmd return info
> 
> 
> On Fri, 2009-08-28 at 08:18 -0600, Moger, Babu wrote:
> > The function mode_select_handle_sense returns SCSI_DH_OK even when
> there is a sense code which is incorrect. Removing it so that it
> returns SCSI_DH_IO when there is sense that is not handled by this
> function.
> >
> > Signed-off-by: Babu Moger <babu.moger@lsi.com>
> > Reviewed-by: Vijay Chauhan <vijay.chauhan@lsi.com>
> > Reviewed-by: Bob Stankey <Robert.stankey@lsi.com>
> 
> Reviewed-by: Chandra Seetharaman <sekharan@us.ibm.com>
> 
> >
> > ---
> > --- linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c.orig
> 	2009-08-22 06:20:45.000000000 -0500
> > +++ linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c	2009-
> 08-22 06:18:36.000000000 -0500
> > @@ -455,8 +455,6 @@ static int mode_select_handle_sense(stru
> >  	if (!ret)
> >  		goto done;
> >
> > -	err = SCSI_DH_OK;
> > -
> >  	switch (sense_hdr.sense_key) {
> >  	case NO_SENSE:
> >  	case ABORTED_COMMAND:
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

