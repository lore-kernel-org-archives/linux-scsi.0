From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [PATCH 0/2] pm8001 driver code cleanup
Date: Fri, 29 Nov 2013 12:34:18 +0100
Message-ID: <52987BBA.506@gmail.com>
References: <1385530846-4187-1-git-send-email-Viswas.G@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:34346 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab3K2Ldr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Nov 2013 06:33:47 -0500
Received: by mail-bk0-f51.google.com with SMTP id 6so4187090bkj.24
        for <linux-scsi@vger.kernel.org>; Fri, 29 Nov 2013 03:33:45 -0800 (PST)
In-Reply-To: <1385530846-4187-1-git-send-email-Viswas.G@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Viswas G <Viswas.G@pmcs.com>
Cc: linux-scsi@vger.kernel.org, Vasanthalakshmi.Tharmarajan@pmcs.com, Suresh.Thiagarajan@pmcs.com

On 11/27/2013 06:40 AM, Viswas G wrote:
> We are resubmitting the following patches in the new patch set
> 
> pm80xx : Removing redundant code snippets
> pm80xx : Fixed return value issue 
> 
> Please discard the previous patches we submitted for the same.
> 
> [PATCH 5/6] pm80xx : Removing redundant code snippets
> http://marc.info/?l=linux-scsi&m=138493235925253&w=2
> 
> [PATCH 6/6] pm80xx : Fixed return value issue
> http://marc.info/?l=linux-scsi&m=138493243028701&w=2
> 
> Sorry for the confusion.
> 
> This patch set has to be applied after the below patch set 
> submitted by Anand.
> 
> http://marc.info/?l=linux-scsi&m=138434875025909&w=2
> 
> 
> Viswas G (2):
>   pm80xx : Removing redundant code snippets
>   pm80xx : Fixed return value issue.
> 
>  drivers/scsi/pm8001/pm8001_ctl.c |   26 ++++++++++----------------
>  drivers/scsi/pm8001/pm8001_hwi.c |   15 +++++----------
>  2 files changed, 15 insertions(+), 26 deletions(-)
> 
You can add my reviewed-by if need.

Jack
