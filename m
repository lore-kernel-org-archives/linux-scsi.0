From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH] add support for next generation of Dell PV array
Date: Mon, 17 Aug 2009 17:13:15 -0700
Message-ID: <1250554395.355.15.camel@chandra-ubuntu>
References: <D00AA2C108EC0346B503219C7565A66F9E2969@ausx3mpc138.aus.amer.dell.com>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:55967 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbZHRAIz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Aug 2009 20:08:55 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n7I06w2E026919
	for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2009 18:06:58 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n7I08tHq211974
	for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2009 18:08:55 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n7I08sHW020462
	for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2009 18:08:54 -0600
In-Reply-To: <D00AA2C108EC0346B503219C7565A66F9E2969@ausx3mpc138.aus.amer.dell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yanqing_Liu@Dell.com
Cc: linux-scsi@vger.kernel.org, dm-devel@redhat.com

Looks good to me and Moger Babu verified the vendor/product IDs

Acked-by: Chandra Seetharaman <sekharan@us.ibm.com>

On Mon, 2009-08-17 at 14:31 -0500, Yanqing_Liu@Dell.com wrote:
> Hello,
> 
> 
> This patch is to add DM support for next generation of Dell PowerVault
> storage array.
> 
> 
> Signed-off-by: Yanqing Liu <Yanqing_Liu@Dell.com>
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

