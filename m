From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [PATCH 0/2] pm80xx: Fix ATTO pm8001 based HBA support
Date: Fri, 20 Dec 2013 11:50:48 +0100
Message-ID: <52B42108.4040408@gmail.com>
References: <1387468257-3177-1-git-send-email-bgrove@attotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:49354 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932292Ab3LTKuv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Dec 2013 05:50:51 -0500
Received: by mail-bk0-f54.google.com with SMTP id v16so1148371bkz.27
        for <linux-scsi@vger.kernel.org>; Fri, 20 Dec 2013 02:50:50 -0800 (PST)
In-Reply-To: <1387468257-3177-1-git-send-email-bgrove@attotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bradley Grove <bgrove@attotech.com>
Cc: linux-scsi@vger.kernel.org, jbottomley@parallels.com, vasanthalakshmi.tharmarajan@pmcs.com, suresh.thiagarajan@pmcs.com, viswas.g@pmcs.com

On 12/19/2013 04:50 PM, Bradley Grove wrote:
> Addresses issues that we uncovered during testing with our HBAs.
> For the most part, we just enabled code that was already being used 
> for other vendor's HBAs.
> 
> Bradley Grove (2):
>   pm80xx: Read saved WWN from NVMD for ATTO pm8001 based HBAs.
>   pm80xx: Enable BAR shift to avoid BIOS conflict with MPI space for    
>     ATTO pm8001 based HBAs.
> 
>  drivers/scsi/pm8001/pm8001_hwi.c  |  6 +++---
>  drivers/scsi/pm8001/pm8001_init.c | 10 +++++-----
>  2 files changed, 8 insertions(+), 8 deletions(-)
> 
Looks fine, thanks
 Acked-by: Jack Wang <xjtuwjp@gmail.com>
