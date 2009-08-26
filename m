From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH] scsi_dh_rdac: Add support for Sun StorageTek ST2500,
	ST2510 and ST2530
Date: Wed, 26 Aug 2009 15:56:48 -0700
Message-ID: <1251327408.14423.14.camel@chandra-ubuntu>
References: <Pine.LNX.4.64.0908261411370.13027@e-smith.charlieb.ott.istop.com>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:40778 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbZHZW4r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Aug 2009 18:56:47 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n7QMsl1W023581
	for <linux-scsi@vger.kernel.org>; Wed, 26 Aug 2009 16:54:47 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n7QMulcE211196
	for <linux-scsi@vger.kernel.org>; Wed, 26 Aug 2009 16:56:47 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n7QMukVg002952
	for <linux-scsi@vger.kernel.org>; Wed, 26 Aug 2009 16:56:47 -0600
In-Reply-To: <Pine.LNX.4.64.0908261411370.13027@e-smith.charlieb.ott.istop.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Charlie Brady <charlieb-dm-devel@budge.apana.org.au>
Cc: linux-scsi@vger.kernel.org, dm-devel@redhat.com

Reviewed-by: Chandra Seetharaman <sekharan@us.ibm.com>

On Wed, 2009-08-26 at 14:16 -0400, Charlie Brady wrote:
> [Re-submit - ST2500 added.]
> 
> These storage arrays can use RDAC when configured with 'linux' as the 
> initiator.
> 
> http://www.sun.com/storage/disk_systems/workgroup/2500/
> http://www.sun.com/storage/disk_systems/workgroup/2510/
> http://www.sun.com/storage/disk_systems/workgroup/2530/
> 
> Signed-off-by: Charlie Brady <charlieb@budge.apana.org.au>
> 
> --- linux-2.6/drivers/scsi/device_handler/scsi_dh_rdac.c	2009-08-25 14:56:42.000000000 -0400
> +++ linux-2.6/drivers/scsi/device_handler/scsi_dh_rdac.c.sun	2009-08-26 14:11:53.000000000 -0400
> @@ -628,6 +628,9 @@
>   	{"SGI", "IS"},
>   	{"STK", "OPENstorage D280"},
>   	{"SUN", "CSM200_R"},
> +	{"SUN", "LCSM100_I"},
> +	{"SUN", "LCSM100_S"},
> +	{"SUN", "LCSM100_E"},
>   	{"SUN", "LCSM100_F"},
>   	{"DELL", "MD3000"},
>   	{"DELL", "MD3000i"},
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

