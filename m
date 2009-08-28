From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH][RESUBMIT] scsi_dh_rdac: Fix for returning correct mode
	select cmd return info
Date: Fri, 28 Aug 2009 10:50:51 -0700
Message-ID: <1251481851.20333.3.camel@chandra-ubuntu>
References: <E463DF2B2E584B4A82673F53D62C2EF474C65F39@cosmail01.lsi.com>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:39733 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbZH1Ruu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Aug 2009 13:50:50 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n7SHfUnq017711
	for <linux-scsi@vger.kernel.org>; Fri, 28 Aug 2009 11:41:30 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n7SHonLP188090
	for <linux-scsi@vger.kernel.org>; Fri, 28 Aug 2009 11:50:50 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n7SHonBe023679
	for <linux-scsi@vger.kernel.org>; Fri, 28 Aug 2009 11:50:49 -0600
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF474C65F39@cosmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@lsi.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'dm-devel@redhat.com'" <dm-devel@redhat.com>, "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>, "Stankey, Robert" <Robert.Stankey@lsi.com>, "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>


On Fri, 2009-08-28 at 08:18 -0600, Moger, Babu wrote:
> The function mode_select_handle_sense returns SCSI_DH_OK even when there is a sense code which is incorrect. Removing it so that it returns SCSI_DH_IO when there is sense that is not handled by this function.
> 
> Signed-off-by: Babu Moger <babu.moger@lsi.com>
> Reviewed-by: Vijay Chauhan <vijay.chauhan@lsi.com>
> Reviewed-by: Bob Stankey <Robert.stankey@lsi.com>

Reviewed-by: Chandra Seetharaman <sekharan@us.ibm.com>

> 
> ---
> --- linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2009-08-22 06:20:45.000000000 -0500
> +++ linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c	2009-08-22 06:18:36.000000000 -0500
> @@ -455,8 +455,6 @@ static int mode_select_handle_sense(stru
>  	if (!ret)
>  		goto done;
> 
> -	err = SCSI_DH_OK;
> -
>  	switch (sense_hdr.sense_key) {
>  	case NO_SENSE:
>  	case ABORTED_COMMAND:
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

