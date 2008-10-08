From: Jean Delvare <khali@linux-fr.org>
Subject: Re: [lm-sensors] [PATCH 09/12] ibmpex: Automatically load on IBM
 systems via DMI
Date: Wed, 8 Oct 2008 14:01:58 +0200
Message-ID: <20081008140158.5a2e1184@hyperion.delvare>
References: <20081007011824.12701.39532.stgit@elm3a70.beaverton.ibm.com>
	<20081007011909.12701.96969.stgit@elm3a70.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:36512 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551AbYJHMCP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Oct 2008 08:02:15 -0400
In-Reply-To: <20081007011909.12701.96969.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-scsi@vger.kernel.org>, lm-sensors <lm-sensors@lm-sensors.org>

Hi Darrick,

On Mon, 06 Oct 2008 18:19:09 -0700, Darrick J. Wong wrote:
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
>  drivers/hwmon/ibmpex.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hwmon/ibmpex.c b/drivers/hwmon/ibmpex.c
> index 4e9b19c..6e3a2c4 100644
> --- a/drivers/hwmon/ibmpex.c
> +++ b/drivers/hwmon/ibmpex.c
> @@ -608,3 +608,9 @@ MODULE_LICENSE("GPL");
>  
>  module_init(ibmpex_init);
>  module_exit(ibmpex_exit);
> +
> +MODULE_ALIAS("dmi:bvnIBM:*:pnIBMSystemx3650*");
> +MODULE_ALIAS("dmi:bvnIBM:*:pnIBMSystemx3550*");
> +MODULE_ALIAS("dmi:bvnIBM:*:pnIBMSystemx3655*");
> +MODULE_ALIAS("dmi:bvnIBM:*:pnIBMSystemx3755*");
> +MODULE_ALIAS("dmi:bvnIBM:*:pnIBMSystemx3350*");

Is there no way to have an alias at the IPMI level? That is, alias on
the device itself rather than the systems it is in? This would avoid the
foreseeable requirement to add entries every time new machines are
released.

But if there is no such way then I am fine applying this patch (except
that I'd sort the entries). I also suspect that the last "*" should
actually be ":*"?

-- 
Jean Delvare
