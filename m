From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: Patch: add Dell product information into rdac device handler
Date: Tue, 30 Sep 2008 10:57:16 -0700
Message-ID: <1222797436.14830.533.camel@chandra-ubuntu>
References: <00FE57DD11E3A94893D5BD54C3358BE884BF36@AUSX3MPC128.aus.amer.dell.com>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:49714 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892AbYI3R6D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Sep 2008 13:58:03 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m8UHw26i002868
	for <linux-scsi@vger.kernel.org>; Tue, 30 Sep 2008 13:58:02 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m8UHw21Q210472
	for <linux-scsi@vger.kernel.org>; Tue, 30 Sep 2008 13:58:02 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m8UHw1EC007119
	for <linux-scsi@vger.kernel.org>; Tue, 30 Sep 2008 13:58:02 -0400
In-Reply-To: <00FE57DD11E3A94893D5BD54C3358BE884BF36@AUSX3MPC128.aus.amer.dell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yanqing_Liu@Dell.com
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, mchristi@redhat.com, Shyam_Iyer@Dell.com, Charles_Rose@Dell.com

Acked-by: Chandra Seetharaman <sekharan@us.ibm.com>
On Tue, 2008-09-30 at 12:01 -0500, Yanqing_Liu@Dell.com wrote:
> Hi all, 
> 
> This patch is to add Dell Powervault storage arrays into device list
> for rdac device handler.
> 
> 
> --- linux-2.6.27-rc7/drivers/scsi/device_handler/scsi_dh_rdac.c.orig
> 2008-09-29 02:31:26.000000000 -0400 
> +++ linux-2.6.27-rc7/drivers/scsi/device_handler/scsi_dh_rdac.c
> 2008-09-30 02:06:26.000000000 -0400 
> @@ -590,6 +590,8 @@ 
>         {"STK", "OPENstorage D280"}, 
>         {"SUN", "CSM200_R"}, 
>         {"SUN", "LCSM100_F"}, 
> +       {"DELL", "MD3000"}, 
> +       {"DELL", "MD3000i"}, 
>         {NULL, NULL}, 
>  }; 
>  
> 
> Thanks, 
> Yanqing
> 

