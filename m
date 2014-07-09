From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [PATCH 0/8] pm8001: Resend previous patches
Date: Wed, 09 Jul 2014 13:56:32 +0200
Message-ID: <53BD2DF0.3040005@gmail.com>
References: <1404906441-15631-1-git-send-email-Suresh.Thiagarajan@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:44561 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaGIL4c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jul 2014 07:56:32 -0400
Received: by mail-wg0-f45.google.com with SMTP id z12so5464117wgg.28
        for <linux-scsi@vger.kernel.org>; Wed, 09 Jul 2014 04:56:31 -0700 (PDT)
In-Reply-To: <1404906441-15631-1-git-send-email-Suresh.Thiagarajan@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
Cc: linux-scsi@vger.kernel.org, JBottomley@parallels.com, Viswas.G@pmcs.com, rickard_strandqvist@spectrumdigital.se, bgrove@attotech.com, mlombard@redhat.com, thenzl@redhat.com

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
The whole patch set looks good to me.
Thanks for resending.

Acked-by: Jack Wang <xjtuwjp@gmail.com>
