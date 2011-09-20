From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [dm-devel] [RESEND][PATCH] scsi_dh_rdac: Adding NetApp as a
 brand name for rdac
Date: Tue, 20 Sep 2011 08:17:36 -0500
Message-ID: <1316524656.9298.54.camel@chandra-lucid.austin.ibm.com>
References: <EE2129A8E578DC4E94D643D6C1C1C67D05D03C9A@BTCMVEXC2-PRD.hq.netapp.com>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:54083 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713Ab1ITNU3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Sep 2011 09:20:29 -0400
Received: from /spool/local
	by us.ibm.com with XMail ESMTP
	for <linux-scsi@vger.kernel.org> from <sekharan@us.ibm.com>;
	Tue, 20 Sep 2011 09:20:16 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p8KDHcdo271084
	for <linux-scsi@vger.kernel.org>; Tue, 20 Sep 2011 09:17:38 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p8KDHcS3024697
	for <linux-scsi@vger.kernel.org>; Tue, 20 Sep 2011 09:17:38 -0400
In-Reply-To: <EE2129A8E578DC4E94D643D6C1C1C67D05D03C9A@BTCMVEXC2-PRD.hq.netapp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-scsi@vger.kernel.org, "Moger, Babu" <Babu.Moger@netapp.com>, "Stankey, Robert" <Robert.Stankey@netapp.com>

Acked-by: Chandra Seetharaman <sekharan@us.ibm.com>

On Fri, 2011-09-02 at 13:26 +0530, Chauhan, Vijay wrote:
> Resending this patch. Previous post had indentation issue due to my mail settings. 
> 
> On September 02 2011 12:44 PM, Vijay Chauhan Wrote:
> > - * Engenio/LSI RDAC SCSI Device Handler
> > + * LSI/Engenio/NetApp E-Series RDAC SCSI Device Handler
> >   *
> >   * Copyright (C) 2005 Mike Christie. All rights reserved.
> >   * Copyright (C) Chandra Seetharaman, IBM Corp. 2007 @@ -941,7 +941,7 @@ static void __exit rdac_exit(void)  module_init(rdac_init);  
> > module_exit(rdac_exit);
> 
> ---
> Adding NetApp as brand name for RDAC.
> 
> Signed-off-by: Vijay Chauhan <Vijay.chauhan@netapp.com>
> Reviewed-by: Bob Stankey <Robert.stankey@netapp.com>
> Reviewed-by: Babu Moger <Babu.moger@netapp.com>
> 
> ---
> --- linux-3.0.3-orig/drivers/scsi/device_handler/scsi_dh_rdac.c	2011-08-17 23:27:16.000000000 +0530
> +++ linux-3.0.3/drivers/scsi/device_handler/scsi_dh_rdac.c	2011-08-30 19:10:49.000000000 +0530
> @@ -1,5 +1,5 @@
>  /*
> - * Engenio/LSI RDAC SCSI Device Handler
> + * LSI/Engenio/NetApp E-Series RDAC SCSI Device Handler
>   *
>   * Copyright (C) 2005 Mike Christie. All rights reserved.
>   * Copyright (C) Chandra Seetharaman, IBM Corp. 2007
> @@ -941,7 +941,7 @@ static void __exit rdac_exit(void)
>  module_init(rdac_init);
>  module_exit(rdac_exit);
> 
> -MODULE_DESCRIPTION("Multipath LSI/Engenio RDAC driver");
> +MODULE_DESCRIPTION("Multipath LSI/Engenio/NetApp E-Series RDAC driver");
>  MODULE_AUTHOR("Mike Christie, Chandra Seetharaman");
>  MODULE_VERSION("01.00.0000.0000");
>  MODULE_LICENSE("GPL");
> --
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 


