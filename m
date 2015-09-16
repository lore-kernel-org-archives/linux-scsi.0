From: Khalid Aziz <khalid@gonehiking.org>
Subject: Re: [PATCH] [SCSI] FlashPoint: fix build warning
Date: Wed, 16 Sep 2015 08:47:43 -0600
Message-ID: <55F9810F.6030004@gonehiking.org>
References: <1442412380-1832-1-git-send-email-sudipm.mukherjee@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from resqmta-po-07v.sys.comcast.net ([96.114.154.166]:43411 "EHLO
	resqmta-po-07v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751689AbbIPOz6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Sep 2015 10:55:58 -0400
In-Reply-To: <1442412380-1832-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On 09/16/2015 08:06 AM, Sudip Mukherjee wrote:
> We have been getting a warning about non ANSI function.
> warning: non-ANSI function declaration of function 'FPT_SccbMgrTableInitAll'
>
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> ---
>   drivers/scsi/FlashPoint.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/FlashPoint.c b/drivers/scsi/FlashPoint.c
> index 5c74e4c..867b864 100644
> --- a/drivers/scsi/FlashPoint.c
> +++ b/drivers/scsi/FlashPoint.c
> @@ -2136,7 +2136,7 @@ static unsigned char FPT_SccbMgr_bad_isr(u32 p_port, unsigned char p_card,
>    *
>    *---------------------------------------------------------------------*/
>
> -static void FPT_SccbMgrTableInitAll()
> +static void FPT_SccbMgrTableInitAll(void)
>   {
>   	unsigned char thisCard;
>
>

Acked-by: Khalid Aziz <khalid@gonehiking.org>

James, please apply this to your SCSI tree.

--
Khalid
