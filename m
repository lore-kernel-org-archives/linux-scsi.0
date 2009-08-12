From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: [PATCH] scsi_dh: add two SUN devices to the list of devices
	supported by default
Date: Wed, 12 Aug 2009 13:52:55 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF474AEB481@cosmail01.lsi.com>
References: <1250106200.20492.4.camel@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og117.obsmtp.com ([64.18.2.6]:55535 "EHLO
	exprod7og117.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbZHLTxQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Aug 2009 15:53:16 -0400
In-Reply-To: <1250106200.20492.4.camel@chandra-ubuntu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "sekharan@linux.vnet.ibm.com" <sekharan@linux.vnet.ibm.com>, Linux SCSI Mailing list <linux-scsi@vger.kernel.org>, "rick.brown" <rick.brown@oit.gatech.edu>, James Bottomley <James.Bot>

I have verified these devices. 

> -----Original Message-----
> From: Chandra Seetharaman [mailto:sekharan@us.ibm.com]
> Sent: Wednesday, August 12, 2009 2:43 PM
> To: Linux SCSI Mailing list; rick.brown; James Bottomley
> Cc: Moger, Babu
> Subject: [PATCH] scsi_dh: add two SUN devices to the list of devices
> supported by default
> 
> Hello all,
> 
> Yesterday, Rick has requested to add two of the sun devices to the list
> of devices supported by scsi_dh_rdac by default.
> 
> This patch adds the support.
> 
> chandra
> ----------------------
> 
> Add two SUN devices to the devlist as requested in the mailing list.
> 
> Reported-by: Rice Brown <rick.brown@oit.gatech.edu>
> Signed-Off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> Cc: Moger Babu <Babu.Moger@lsi.com>

  Reviewed-by: Babu Moger <babu.moger@lsi.com>

> ---
>  drivers/scsi/device_handler/scsi_dh_rdac.c |    2 ++
>  1 file changed, 2 insertions(+)
 
> Index: linux-2.6.31-rc4/drivers/scsi/device_handler/scsi_dh_rdac.c
> ===================================================================
> --- linux-2.6.31-rc4.orig/drivers/scsi/device_handler/scsi_dh_rdac.c
> +++ linux-2.6.31-rc4/drivers/scsi/device_handler/scsi_dh_rdac.c
> @@ -633,6 +633,8 @@ static const struct scsi_dh_devlist rdac
>  	{"DELL", "MD3000i"},
>  	{"LSI", "INF-01-00"},
>  	{"ENGENIO", "INF-01-00"},
> +	{"STK", "FLEXLINE 380"},
> +	{"SUN", "CSM100_R_FC"},
>  	{NULL, NULL},
>  };
> 
> 

