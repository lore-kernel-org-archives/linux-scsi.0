From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 0/8] pm8001: Resend previous patches
Date: Wed, 09 Jul 2014 15:03:52 +0200
Message-ID: <53BD3DB8.9080402@redhat.com>
References: <1404906441-15631-1-git-send-email-Suresh.Thiagarajan@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932151AbaGINFI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Jul 2014 09:05:08 -0400
In-Reply-To: <1404906441-15631-1-git-send-email-Suresh.Thiagarajan@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>, linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com, JBottomley@parallels.com, Viswas.G@pmcs.com, rickard_strandqvist@spectrumdigital.se, bgrove@attotech.com, mlombard@redhat.com

Hi Suresh,

thanks for resending, please have a look and review also the patches I sent out
two days ago beginning with [PATCH 1/4] scsi: pm8001: fix a memory leak in nvmd_resp,
(I'm afraid they will get otherwise lost the in the pm8001 patchflood)

Cheers, Tomas


On 07/09/2014 01:47 PM, Suresh Thiagarajan wrote:

> From: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
>
> Updated comments for pm8001: honor return value
> Remaining patches are resend
>
> Suresh Thiagarajan (8):
>   pm8001: Fix to remove null pointer checks that could never happen
>   pm8001: Cleaning up uninitialized variables
>   pm8001: Fix hibernation issue
>   pm8001: Fix potential null pointer dereference and memory leak.
>   pm8001: clean bitmap management functions
>   pm8001: honor return value
>   pm8001: add a new spinlock to protect the CCB
>   pm8001: more fixes to honor return value
>
>  drivers/scsi/pm8001/pm8001_ctl.c  |    5 +++-
>  drivers/scsi/pm8001/pm8001_hwi.c  |   45 +++++++++++++++++++++++----------
>  drivers/scsi/pm8001/pm8001_init.c |   48 +++++++++++++++++++++++++++++++-----
>  drivers/scsi/pm8001/pm8001_sas.c  |   38 ++++++++++-------------------
>  drivers/scsi/pm8001/pm8001_sas.h  |    2 +-
>  drivers/scsi/pm8001/pm80xx_hwi.c  |   48 +++++++++++++++++++++++++++----------
>  6 files changed, 125 insertions(+), 61 deletions(-)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

