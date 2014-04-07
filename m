From: Khalid Aziz <khalid@gonehiking.org>
Subject: Re: [PATCH] [SCSI] FlashPoint: Fix non-ANSI function declaration
Date: Sun, 06 Apr 2014 20:59:29 -0600
Message-ID: <1396839569.2360.73.camel@rhapsody>
References: <1982826.16T5d6eoLo@daeseok-laptop.cloud.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:41334 "EHLO
	qmta06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754736AbaDGDGO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Apr 2014 23:06:14 -0400
In-Reply-To: <1982826.16T5d6eoLo@daeseok-laptop.cloud.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, 2014-04-07 at 11:51 +0900, Daeseok Youn wrote:
> sparse says:
>  non-ANSI function declaration of function 'FPT_SccbMgrTableInitAll'
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
>  drivers/scsi/FlashPoint.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/FlashPoint.c b/drivers/scsi/FlashPoint.c
> index 5c74e4c..867b864 100644
> --- a/drivers/scsi/FlashPoint.c
> +++ b/drivers/scsi/FlashPoint.c
> @@ -2136,7 +2136,7 @@ static unsigned char FPT_SccbMgr_bad_isr(u32 p_port, unsigned char p_card,
>   *
>   *---------------------------------------------------------------------*/
>  
> -static void FPT_SccbMgrTableInitAll()
> +static void FPT_SccbMgrTableInitAll(void)
>  {
>  	unsigned char thisCard;
>  

Acked-by: Khalid Aziz <khalid@gonehiking.org>

