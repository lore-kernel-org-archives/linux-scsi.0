From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 1/5] ibmvscsi: Remove unnecessary map_sg check
Date: Wed, 13 Jun 2007 18:30:54 -0400
Message-ID: <4670701E.2010404@garzik.org>
References: <11817727312836-patch-mail.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:40476 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754313AbXFMWa5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jun 2007 18:30:57 -0400
In-Reply-To: <11817727312836-patch-mail.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: santil@linux.vnet.ibm.com, rcjenn@linux.vnet.ibm.com, linux-scsi@vger.kernel.org

Brian King wrote:
> Since sg_tablesize is set appropriately in the scsi host template,
> remove the unnecessary check to make sure it is not exceeded
> following the dma_map_sg call.
> 
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
> ---
> 
>  linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c |    7 -------
>  1 file changed, 7 deletions(-)

Patches 1-5 look OK to me... modulo the question I just sent


