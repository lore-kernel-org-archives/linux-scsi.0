From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] ibmvscsi: includecheck fix
Date: Fri, 04 Sep 2009 13:01:40 -0500
Message-ID: <4AA15604.1010202@linux.vnet.ibm.com>
References: <1252086978.6385.4.camel@ht.satnam>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47485 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933599AbZIDSBs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Sep 2009 14:01:48 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id n84HsvUW032704
	for <linux-scsi@vger.kernel.org>; Fri, 4 Sep 2009 13:54:57 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n84I1okQ249434
	for <linux-scsi@vger.kernel.org>; Fri, 4 Sep 2009 14:01:50 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n84HwjtZ030998
	for <linux-scsi@vger.kernel.org>; Fri, 4 Sep 2009 13:58:47 -0400
In-Reply-To: <1252086978.6385.4.camel@ht.satnam>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Robert Jennings <rcj@linux.vnet.ibm.com>, Paul Mackerras <paulus@samba.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, scsi <linux-scsi@vger.kernel.org>

Acked-by: Brian King <brking@linux.vnet.ibm.com>

Jaswinder Singh Rajput wrote:
> fix the following 'make includecheck' warning:
> 
>   drivers/scsi/ibmvscsi/ibmvscsi.c: asm/firmware.h is included more than once.
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  drivers/scsi/ibmvscsi/ibmvscsi.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
> index 9928704..d9b0e9d 100644
> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
> @@ -73,7 +73,6 @@
>  #include <linux/of.h>
>  #include <asm/firmware.h>
>  #include <asm/vio.h>
> -#include <asm/firmware.h>
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_cmnd.h>
>  #include <scsi/scsi_host.h>


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


