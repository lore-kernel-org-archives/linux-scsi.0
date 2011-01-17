From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: remove duplicate include of
	target/target_core_device.h from drivers/target/target_core_hba.c
Date: Mon, 17 Jan 2011 14:22:31 -0800
Message-ID: <1295302951.22813.227.camel@haakon2.linux-iscsi.org>
References: <alpine.LNX.2.00.1101172242510.27021@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:55638 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab1AQWWe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Jan 2011 17:22:34 -0500
In-Reply-To: <alpine.LNX.2.00.1101172242510.27021@swampdragon.chaosbits.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

On Mon, 2011-01-17 at 22:46 +0100, Jesper Juhl wrote:
> drivers/target/target_core_hba.c includes target/target_core_device.h 
> twice - the two includes are even on two lines next to each other.
> This patch removes the duplicate include.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Committed as:

[linus-38-rc1 95f39d1] target: remove duplicate include target_core_device.h

Please let me know if you have more include cleanups so they can be git
squashed'  into a single commit for scsi-post-merge-2.6.git/for-jejb.

Thanks!

--nab


> ---
>  target_core_hba.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/target/target_core_hba.c b/drivers/target/target_core_hba.c
> index 4bbe820..74d84f7 100644
> --- a/drivers/target/target_core_hba.c
> +++ b/drivers/target/target_core_hba.c
> @@ -38,7 +38,6 @@
>  
>  #include <target/target_core_base.h>
>  #include <target/target_core_device.h>
> -#include <target/target_core_device.h>
>  #include <target/target_core_tpg.h>
>  #include <target/target_core_transport.h>
>  
> 

