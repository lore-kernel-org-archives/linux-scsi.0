From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: RE: [dm-devel] [PATCH] scsi_dh_rdac: Adding couple more vendor product	ids
Date: Fri, 20 May 2011 17:08:32 -0400
Message-ID: <47D23AD8469A2B448F33C24BD7A39BD90DAF451E@RTPMVEXC1-PRD.hq.netapp.com>
References: <E463DF2B2E584B4A82673F53D62C2EF4FF7DC637@cosmail01.lsi.com> <E463DF2B2E584B4A82673F53D62C2EF4FFAC8CFB@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:51108 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754774Ab1ETVIg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 May 2011 17:08:36 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org
Cc: dmilburn@redhat.com

Pinging again.  This patch was not picked up yet. James let me know if you want me to resubmit again..  


> -----Original Message-----
> From: Moger, Babu
> Sent: Friday, May 06, 2011 8:39 AM
> To: linux-scsi@vger.kernel.org
> Cc: 'James Bottomley'
> Subject: RE: [dm-devel] [PATCH] scsi_dh_rdac: Adding couple more vendor
> product ids
> 
> I did not see this patch being picked up..  Forwarding again..
> 
> > -----Original Message-----
> > From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
> > On Behalf Of Moger, Babu
> > Sent: Tuesday, April 05, 2011 3:35 PM
> > To: linux-scsi@vger.kernel.org
> > Cc: device-mapper development
> > Subject: [dm-devel] [PATCH] scsi_dh_rdac: Adding couple more vendor
> > product ids
> >
> > This patch adds couple more Vendor/Product IDs for RDAC.. There are no
> > functional changes.
> >
> > Signed-off-by: Babu Moger <babu.moger@lsi.com>
> > ---
> > --- linux-2.6.39-rc1/drivers/scsi/device_handler/scsi_dh_rdac.c.orig
> > 	2011-04-05 15:01:52.000000000 -0500
> > +++ linux-2.6.39-rc1/drivers/scsi/device_handler/scsi_dh_rdac.c	2011-
> > 04-05 15:06:18.000000000 -0500
> > @@ -755,6 +755,7 @@ static const struct scsi_dh_devlist rdac
> >  	{"IBM", "3526"},
> >  	{"SGI", "TP9400"},
> >  	{"SGI", "TP9500"},
> > +	{"SGI", "TP9700"},
> >  	{"SGI", "IS"},
> >  	{"STK", "OPENstorage D280"},
> >  	{"SUN", "CSM200_R"},
> > @@ -774,6 +775,7 @@ static const struct scsi_dh_devlist rdac
> >  	{"SUN", "CSM100_R_FC"},
> >  	{"SUN", "STK6580_6780"},
> >  	{"SUN", "SUN_6180"},
> > +	{"SUN", "ArrayStorage"},
> >  	{NULL, NULL},
> >  };
> >
> >
> >
> >
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
