From: Jamie Lenehan <lenehan@twibble.org>
Subject: Re: [2.6 patch] SCSI dc395x.c: make a function static
Date: Tue, 16 Nov 2004 07:22:32 +1100
Message-ID: <20041115202231.GA26873@twibble.org>
References: <20041115015609.GG2249@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nynaeve.twibble.org ([202.173.155.194]:665 "EHLO
	nynaeve.twibble.org") by vger.kernel.org with ESMTP id S261679AbUKOUWf
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Nov 2004 15:22:35 -0500
Content-Disposition: inline
In-Reply-To: <20041115015609.GG2249@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: aliakc@web.de, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

On Mon, Nov 15, 2004 at 02:56:09AM +0100, Adrian Bunk wrote:
> The patch below makes the needlessly global function adapter_init_chip 
> static.

James,

please apply this patch.

Thanks.
Jamie.

> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> --- linux-2.6.10-rc1-mm5-full/drivers/scsi/dc395x.c.old	2004-11-13 20:58:56.000000000 +0100
> +++ linux-2.6.10-rc1-mm5-full/drivers/scsi/dc395x.c	2004-11-13 20:59:09.000000000 +0100
> @@ -4447,7 +4447,7 @@
>   *
>   * @acb: The adapter which we are to init.
>   **/
> -void __init adapter_init_chip(struct AdapterCtlBlk *acb)
> +static void __init adapter_init_chip(struct AdapterCtlBlk *acb)
>  {
>          struct NvRamType *eeprom = &acb->eeprom;
>          
> 

-- 
 Jamie Lenehan <lenehan@twibble.org>
