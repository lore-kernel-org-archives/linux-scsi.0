From: Khalid Aziz <khalid@gonehiking.org>
Subject: Re: [PATCH] scsi/FlashPoint.c: Add void declaration in zero-arg
 functions.
Date: Mon, 07 Jul 2014 08:12:32 -0600
Message-ID: <1404742352.7217.6.camel@rhapsody>
References: <1404392889-14745-1-git-send-email-fempsci@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:51836
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752563AbaGGOMy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jul 2014 10:12:54 -0400
In-Reply-To: <1404392889-14745-1-git-send-email-fempsci@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chi Pham <fempsci@gmail.com>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org

On Thu, 2014-07-03 at 15:08 +0200, Chi Pham wrote:
> Added explicit void declarations to zero-argument function headers.
> The following coccinelle script was used:
> @addvoid@
> identifier f;
> @@
> 
> f(
> + void
>  ) { ... }
> 
> Signed-off-by: Chi Pham <fempsci@gmail.com>
> ---
>  drivers/scsi/FlashPoint.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
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

Please cc linux-scsi@vger.kernel.org on scsi patches.

--
Khalid

