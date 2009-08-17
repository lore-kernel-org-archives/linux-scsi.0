From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: [PATCH] add support for next generation of Dell PV array
Date: Mon, 17 Aug 2009 15:39:13 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF474B7A5E4@cosmail01.lsi.com>
References: <D00AA2C108EC0346B503219C7565A66F9E2969@ausx3mpc138.aus.amer.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og124.obsmtp.com ([64.18.2.26]:47195 "EHLO
	exprod7og124.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758176AbZHQVjS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Aug 2009 17:39:18 -0400
In-Reply-To: <D00AA2C108EC0346B503219C7565A66F9E2969@ausx3mpc138.aus.amer.dell.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>

Patch Looks good..

> -----Original Message-----
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
> On Behalf Of Yanqing_Liu@Dell.com
> Sent: Monday, August 17, 2009 2:32 PM
> To: linux-scsi@vger.kernel.org; dm-devel@redhat.com
> Subject: [dm-devel] [PATCH] add support for next generation of Dell PV
> array
> 
> Hello,
> 
> 
> This patch is to add DM support for next generation of Dell PowerVault
> storage array.
> 
> 
> Signed-off-by: Yanqing Liu <Yanqing_Liu@Dell.com>
  Reviewed by  : Babu Moger <babu.moger@lsi.com>
> 
> --- linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c.orig
> 2009-08-05 16:30:51.000000000 -0500
> +++ linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c
> 2009-08-05 16:34:00.000000000 -0500
> @@ -631,6 +631,8 @@ static const struct scsi_dh_devlist rdac
>  	{"SUN", "LCSM100_F"},
>  	{"DELL", "MD3000"},
>  	{"DELL", "MD3000i"},
> +	{"DELL", "MD32xx"},
> +	{"DELL", "MD32xxi"},
>  	{"LSI", "INF-01-00"},
>  	{"ENGENIO", "INF-01-00"},
>  	{NULL, NULL},
> 
> Thanks,
> Yanqing
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
