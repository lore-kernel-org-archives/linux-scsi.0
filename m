From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 3/3] pm8001: Update MAINTAINERS list
Date: Wed, 30 Jul 2014 16:12:34 +0400
Message-ID: <1406722354.4865.58.camel@jarvis>
References: <1406722063-4683-1-git-send-email-Suresh.Thiagarajan@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44608 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752441AbaG3MMj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jul 2014 08:12:39 -0400
In-Reply-To: <1406722063-4683-1-git-send-email-Suresh.Thiagarajan@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
Cc: linux-scsi@vger.kernel.org, xjtuwjp@gmail.com, thenzl@redhat.com, Viswas.G@pmcs.com, pmchba@pmcs.com

On Wed, 2014-07-30 at 17:37 +0530, Suresh Thiagarajan wrote:
> From: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
> 
> Update pmcs mail list for pm8001 driver support
> 
> Signed-off-by: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
> ---
>  MAINTAINERS |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3f2e171..a63259c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6987,6 +6987,7 @@ F:	drivers/scsi/pmcraid.*
>  PMC SIERRA PM8001 DRIVER
>  M:	xjtuwjp@gmail.com
>  M:	lindar_liu@usish.com
> +L:	pmchba@pmcs.com

This list doesn't appear to work:

<pmchba@pmcs.com>: host smtp.pmc-sierra.com[216.241.235.148] said: 550 5.1.1
    <pmchba@pmcs.com>: Recipient address rejected: User unknown in local
    recipient table (in reply to RCPT TO command)

James


