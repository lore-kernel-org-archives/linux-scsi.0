From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH] scsi: kconfig: When possible, compile drivers with
 COMPILE_TEST
Date: Wed, 14 Oct 2015 15:25:05 -0700
Message-ID: <561ED641.9090208@infradead.org>
References: <1444857220-26595-1-git-send-email-luisbg@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:41812 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbbJNWZM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Oct 2015 18:25:12 -0400
In-Reply-To: <1444857220-26595-1-git-send-email-luisbg@osg.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luis de Bethencourt <luisbg@osg.samsung.com>, linux-kernel@vger.kernel.org
Cc: JBottomley@odin.com, linux-scsi@vger.kernel.org

On 10/14/15 14:13, Luis de Bethencourt wrote:
> These drivers only have runtime but no build time dependencies, so they can
> be built for testing purposes if the Kconfig COMPILE_TEST option is enabled.
> 
> This is useful to have more build coverage and make sure that drivers are
> not affected by changes that could cause build regressions.
> 
> Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
> ---
>  drivers/scsi/Kconfig | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index d2f480b..0d8ee16 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig

> @@ -1238,7 +1238,7 @@ config SCSI_NCR53C8XX_NO_DISCONNECT
>  
>  config SCSI_PAS16
>  	tristate "PAS16 SCSI support"
> -	depends on ISA && SCSI
> +	depends on (ISA || COMPILE) && SCSI

COMPILE_TEST

>  	select SCSI_SPI_ATTRS
>  	---help---
>  	  This is support for a SCSI host adapter.  It is explained in section


-- 
~Randy
