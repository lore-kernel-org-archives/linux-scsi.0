From: Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: Re: [PATCH 5/5] ibmvfc: Driver version 1.0.11
Date: Tue, 16 Apr 2013 15:25:23 -0500
Message-ID: <20130416202523.GC17614@linux.vnet.ibm.com>
References: <201304121325.r3CDPJIQ025089@d01av05.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:38563 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936128Ab3DPUZb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Apr 2013 16:25:31 -0400
Received: from /spool/local
	by e28smtp02.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <rcj@linux.vnet.ibm.com>;
	Wed, 17 Apr 2013 01:50:11 +0530
Received: from d28relay05.in.ibm.com (d28relay05.in.ibm.com [9.184.220.62])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id 8B1801258055
	for <linux-scsi@vger.kernel.org>; Wed, 17 Apr 2013 01:56:55 +0530 (IST)
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay05.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r3GKPMEb59441298
	for <linux-scsi@vger.kernel.org>; Wed, 17 Apr 2013 01:55:22 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r3GKPPbr025729
	for <linux-scsi@vger.kernel.org>; Wed, 17 Apr 2013 06:25:25 +1000
Content-Disposition: inline
In-Reply-To: <201304121325.r3CDPJIQ025089@d01av05.pok.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

* Brian King (brking@linux.vnet.ibm.com) wrote:
> 
> Bump driver version to 1.0.11.
> 
> 
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
Acked-by: Robert Jennings <rcj@linux.vnet.ibm.com>
> ---
> 
>  drivers/scsi/ibmvscsi/ibmvfc.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff -puN drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_version_1_0_11 drivers/scsi/ibmvscsi/ibmvfc.h
> --- linux/drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_version_1_0_11	2013-04-10 15:51:55.000000000 -0500
> +++ linux-bjking1/drivers/scsi/ibmvscsi/ibmvfc.h	2013-04-12 08:22:33.000000000 -0500
> @@ -29,8 +29,8 @@
>  #include "viosrp.h"
> 
>  #define IBMVFC_NAME	"ibmvfc"
> -#define IBMVFC_DRIVER_VERSION		"1.0.10"
> -#define IBMVFC_DRIVER_DATE		"(August 24, 2012)"
> +#define IBMVFC_DRIVER_VERSION		"1.0.11"
> +#define IBMVFC_DRIVER_DATE		"(April 12, 2013)"
> 
>  #define IBMVFC_DEFAULT_TIMEOUT	60
>  #define IBMVFC_ADISC_CANCEL_TIMEOUT	45
> _

