From: rick.brown@oit.gatech.edu
Subject: Re: [PATCH] scsi_dh: add two SUN devices to the list of devices
 supported by default
Date: Mon, 17 Aug 2009 15:48:00 -0400 (EDT)
Message-ID: <1077051204.2661971250538480433.JavaMail.root@mail6.gatech.edu>
References: <194845336.2661641250538435313.JavaMail.root@mail6.gatech.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from deliverator3.ecc.gatech.edu ([130.207.185.173]:33864 "EHLO
	deliverator3.ecc.gatech.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755061AbZHQTsH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Aug 2009 15:48:07 -0400
In-Reply-To: <194845336.2661641250538435313.JavaMail.root@mail6.gatech.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Babu Moger <Babu.Moger@lsi.com>
Cc: sekharan@linux.vnet.ibm.com, Linux SCSI Mailing list <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>

I have tested this patch and it works as expected.  

----- "Babu Moger" <Babu.Moger@lsi.com> wrote:

> From: "Babu Moger" <Babu.Moger@lsi.com>
> To: sekharan@linux.vnet.ibm.com, "Linux SCSI Mailing list" <linux-scsi@vger.kernel.org>, "rick.brown"
> <rick.brown@oit.gatech.edu>, "James Bottomley" <James.Bottomley@HansenPartnership.com>
> Sent: Wednesday, August 12, 2009 3:52:55 PM GMT -05:00 US/Canada Eastern
> Subject: RE: [PATCH] scsi_dh: add two SUN devices to the list of devices supported by default
>
> I have verified these devices. 
> 
> > -----Original Message-----
> > From: Chandra Seetharaman [mailto:sekharan@us.ibm.com]
> > Sent: Wednesday, August 12, 2009 2:43 PM
> > To: Linux SCSI Mailing list; rick.brown; James Bottomley
> > Cc: Moger, Babu
> > Subject: [PATCH] scsi_dh: add two SUN devices to the list of
> devices
> > supported by default
> > 
> > Hello all,
> > 
> > Yesterday, Rick has requested to add two of the sun devices to the
> list
> > of devices supported by scsi_dh_rdac by default.
> > 
> > This patch adds the support.
> > 
> > chandra
> > ----------------------
> > 
> > Add two SUN devices to the devlist as requested in the mailing
> list.
> > 
> > Reported-by: Rice Brown <rick.brown@oit.gatech.edu>
> > Signed-Off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> > Cc: Moger Babu <Babu.Moger@lsi.com>
> 
>   Reviewed-by: Babu Moger <babu.moger@lsi.com>
> 
> > ---
> >  drivers/scsi/device_handler/scsi_dh_rdac.c |    2 ++
> >  1 file changed, 2 insertions(+)
>  
> > Index: linux-2.6.31-rc4/drivers/scsi/device_handler/scsi_dh_rdac.c
> > ===================================================================
> > ---
> linux-2.6.31-rc4.orig/drivers/scsi/device_handler/scsi_dh_rdac.c
> > +++ linux-2.6.31-rc4/drivers/scsi/device_handler/scsi_dh_rdac.c
> > @@ -633,6 +633,8 @@ static const struct scsi_dh_devlist rdac
> >  	{"DELL", "MD3000i"},
> >  	{"LSI", "INF-01-00"},
> >  	{"ENGENIO", "INF-01-00"},
> > +	{"STK", "FLEXLINE 380"},
> > +	{"SUN", "CSM100_R_FC"},
> >  	{NULL, NULL},
> >  };
> > 
> >

-- 
Rick Brown
Office of Information Technology
Georgia Institute of Technology
258 4th Street N.W.  Atlanta, GA  30332-0715
rick@gatech.edu
(404) 894-6175
