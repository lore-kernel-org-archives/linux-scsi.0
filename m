From: Don Brace <Don.Brace@pmcs.com>
Subject: RE: [PATCH 1/2] cciss: remove duplicate entries from board_type
 struct
Date: Mon, 18 May 2015 21:36:01 +0000
Message-ID: <07F70BBF6832E34FA1C923241E8833AB486A9D77@BBYEXM01.pmc-sierra.internal>
References: <1424191222-30570-1-git-send-email-thenzl@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:37639 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754143AbbERVgD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 May 2015 17:36:03 -0400
In-Reply-To: <1424191222-30570-1-git-send-email-thenzl@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>

> -----Original Message-----
> From: Tomas Henzl [mailto:thenzl@redhat.com]
> Sent: Tuesday, February 17, 2015 10:40 AM
> To: linux-scsi@vger.kernel.org
> Cc: Don Brace; linux-kernel@vger.kernel.org; axboe@kernel.dk
> Subject: [PATCH 1/2] cciss: remove duplicate entries from board_type struct
> 
> and devices not supported by this driver from unresettable list
> 
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> ---
>  drivers/block/cciss.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index ff20f192b0..48498220cd 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -139,8 +139,6 @@ static struct board_type products[] = {
>  	{0x3214103C, "Smart Array E200i", &SA5_access},
>  	{0x3215103C, "Smart Array E200i", &SA5_access},
>  	{0x3237103C, "Smart Array E500", &SA5_access},
> -	{0x3223103C, "Smart Array P800", &SA5_access},
> -	{0x3234103C, "Smart Array P400", &SA5_access},
>  	{0x323D103C, "Smart Array P700m", &SA5_access},
>  };
> 
> @@ -574,8 +572,6 @@ static void cciss_procinit(ctlr_info_t *h)
> 
>  /* List of controllers which cannot be hard reset on kexec with reset_devices */
>  static u32 unresettable_controller[] = {
> -	0x324a103C, /* Smart Array P712m */
> -	0x324b103C, /* SmartArray P711m */
>  	0x3223103C, /* Smart Array P800 */
>  	0x3234103C, /* Smart Array P400 */
>  	0x3235103C, /* Smart Array P400i */
> --
> 1.9.3

Looks good
