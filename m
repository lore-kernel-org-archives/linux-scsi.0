From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] [19/2many] MAINTAINERS - IPS SCSI RAID DRIVER
Date: Mon, 13 Aug 2007 09:34:06 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01D12A94@otce2k301.adaptec.com>
References: <46bff887.tZoEfrDzIK+F6h6p%joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:42799 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030806AbXHMNer convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Aug 2007 09:34:47 -0400
Content-class: urn:content-classes:message
In-Reply-To: <46bff887.tZoEfrDzIK+F6h6p%joe@perches.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joe@perches.com, torvalds@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, AACRAID <aacraid@adaptec.com>

ACK

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: joe@perches.com [mailto:joe@perches.com] 
> Sent: Monday, August 13, 2007 2:22 AM
> To: torvalds@linux-foundation.org; 
> linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; 
> akpm@linux-foundation.org; AACRAID
> Subject: [PATCH] [19/2many] MAINTAINERS - IPS SCSI RAID DRIVER
> 
> 
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 141b08a..71e09b7 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -224,6 +224,7 @@ M:	aacraid@adaptec.com
>  L:	linux-scsi@vger.kernel.org
>  W:	http://www.adaptec.com/
>  S:	Maintained
> +F:	drivers/scsi/ips*
>  
>  DPT_I2O SCSI RAID DRIVER
>  P:	Adaptec OEM Raid Solutions
> 
