From: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] MAINTAINERS: ibmvscsi driver maintainer change
Date: Wed, 14 Jan 2015 14:06:32 -0600
Message-ID: <54B6CC48.70205@linux.vnet.ibm.com>
References: <1421109095-18613-1-git-send-email-tyreld@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:35318 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309AbbANUGi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jan 2015 15:06:38 -0500
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <nfont@linux.vnet.ibm.com>;
	Wed, 14 Jan 2015 15:06:38 -0500
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id E6D3638C8059
	for <linux-scsi@vger.kernel.org>; Wed, 14 Jan 2015 15:06:34 -0500 (EST)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t0EK6Yt320185202
	for <linux-scsi@vger.kernel.org>; Wed, 14 Jan 2015 20:06:34 GMT
Received: from d01av03.pok.ibm.com (localhost [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t0EK6YVd028660
	for <linux-scsi@vger.kernel.org>; Wed, 14 Jan 2015 15:06:34 -0500
In-Reply-To: <1421109095-18613-1-git-send-email-tyreld@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org
Cc: brking@linux.vnet.ibm.com, linux-kernel@vger.linux.org, linuxppc-dev@lists.ozlabs.org

On 01/12/2015 06:31 PM, Tyrel Datwyler wrote:
> Change maintainer of ibmvscsi driver to Tyrel Datwyler.
> 
> Signed-off-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
> Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>
> Cc: Brian King <brking@linux.vnet.ibm.com>

Acked-by: Nathan Fontenot <nfont@linux.vnet.ibm.com>

> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 79b2e4b..a646b94 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4754,7 +4754,7 @@ S:	Supported
>  F:	drivers/net/ethernet/ibm/ibmveth.*
>  
>  IBM Power Virtual SCSI Device Drivers
> -M:	Nathan Fontenot <nfont@linux.vnet.ibm.com>
> +M:	Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
>  L:	linux-scsi@vger.kernel.org
>  S:	Supported
>  F:	drivers/scsi/ibmvscsi/ibmvscsi*
> 

