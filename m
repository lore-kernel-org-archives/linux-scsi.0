From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] Make SCSI SG v4 driver enabled by default now since udev
 depends on it.
Date: Tue, 07 Jul 2009 18:05:50 +0300
Message-ID: <4A53644E.2090205@panasas.com>
References: <1246978255-19407-1-git-send-email-john@stoffel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:1248
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752977AbZGGPFx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2009 11:05:53 -0400
In-Reply-To: <1246978255-19407-1-git-send-email-john@stoffel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe <Jens.Axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On 07/07/2009 05:50 PM, John Stoffel wrote:
> Signed-off-by: John Stoffel <john@stoffel.org>
> ---
>  block/Kconfig |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/block/Kconfig b/block/Kconfig
> index e7d1278..22bf6eb 100644
> --- a/block/Kconfig
> +++ b/block/Kconfig
> @@ -46,8 +46,8 @@ config LBD
>  
>  config BLK_DEV_BSG
>  	bool "Block layer SG support v4 (EXPERIMENTAL)"

Please also remove the (EXPERIMENTAL) from the prompt as well

> -	depends on EXPERIMENTAL
> -	---help---
> +	default y
> +	help
>  	  Saying Y here will enable generic SG (SCSI generic) v4 support
>  	  for any block device.
>  
> @@ -57,7 +57,7 @@ config BLK_DEV_BSG
>  	  protocols (e.g. Task Management Functions and SMP in Serial
>  	  Attached SCSI).
>  
> -	  If unsure, say N.
> +	  If unsure, say Y.
>  
>  config BLK_DEV_INTEGRITY
>  	bool "Block layer data integrity support"

Thanks I needed that too.

BTW distro(s) have been shipping with it on for ages

Boaz
