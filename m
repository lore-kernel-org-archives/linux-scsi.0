From: James Smart <james.smart@avagotech.com>
Subject: Re: [RESEND][PATCH] lpfc: fix model description
Date: Fri, 10 Jul 2015 08:36:06 -0400
Message-ID: <559FBC36.1000102@avagotech.com>
References: <20150706232200.00006bd4@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:33245 "EHLO
	mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342AbbGJMgJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jul 2015 08:36:09 -0400
Received: by qkhu186 with SMTP id u186so205658041qkh.0
        for <linux-scsi@vger.kernel.org>; Fri, 10 Jul 2015 05:36:08 -0700 (PDT)
In-Reply-To: <20150706232200.00006bd4@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Herbszt <herbszt@gmx.de>, linux-scsi@vger.kernel.org

As mentioned previously, it's a nit, and not too meaningful, but fine.

If not merged prior, we'll repost as part of an upcoming commit that 
cleans up sparse warnings.

Reviewed-By:  James Smart  <james.smart@avagotech.com>

-- james s


On 7/6/2015 5:22 PM, Sebastian Herbszt wrote:
> Remove trailing space from model description.
>
> Signed-off-by: Sebastian Herbszt <herbszt@gmx.de>
> Reviewed-By: James Smart <james.smart@avagotech.com>
>
> diff -up 4.0/drivers/scsi/lpfc.orig/lpfc_init.c 4.0/drivers/scsi/lpfc/lpfc_init.c
> --- 4.0/drivers/scsi/lpfc.orig/lpfc_init.c	2015-04-15 06:18:24.673045138 +0200
> +++ 4.0/drivers/scsi/lpfc/lpfc_init.c	2015-04-22 21:03:39.203230409 +0200
> @@ -2253,7 +2253,7 @@ lpfc_get_hba_model_desc(struct lpfc_hba
>   				phba->Port);
>   		else if (max_speed == 0)
>   			snprintf(descp, 255,
> -				"Emulex %s %s %s ",
> +				"Emulex %s %s %s",
>   				m.name, m.bus, m.function);
>   		else
>   			snprintf(descp, 255,
