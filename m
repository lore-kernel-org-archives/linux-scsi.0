From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 17/19] be2iscsi: patch from Randy Dunlap
Date: Thu, 22 Jul 2010 17:32:35 -0500
Message-ID: <4C48C703.70907@cs.wisc.edu>
References: <20100721225949.GA9808@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:51889 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751472Ab0GVW3B (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jul 2010 18:29:01 -0400
In-Reply-To: <20100721225949.GA9808@serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kalickal <jayamohank@serverengines.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de

On 07/21/2010 05:59 PM, Jayamohan Kallickal wrote:
>    This patch add NET because be2iscsi is using sysfs_format_mac function
>    Found and patch originally submitted by Randy Dunlap
>
> Signed-off-by: Randy Dunlap<randy.dunlap@oracle.com>
> Signed-off-by: Jayamohan Kallickal<jayamohank@serverengines.com>
> ---
>   drivers/scsi/be2iscsi/Kconfig   |    2 +-
>   drivers/scsi/be2iscsi/be_main.h |    1 +
>   2 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/scsi/be2iscsi/Kconfig b/drivers/scsi/be2iscsi/Kconfig
> index 2952fcd..9d57142 100644
> --- a/drivers/scsi/be2iscsi/Kconfig
> +++ b/drivers/scsi/be2iscsi/Kconfig
> @@ -1,7 +1,7 @@
>   config BE2ISCSI
>   	tristate "ServerEngines' 10Gbps iSCSI - BladeEngine 2"
>   	depends on PCI&&  SCSI
> -	select SCSI_ISCSI_ATTRS
> +	select SCSI_ISCSI_ATTRS&&  NET
>

Bah. Ok the code in the patches looks ok, but with this patch I get:

scripts/kconfig/mconf arch/x86/Kconfig
drivers/scsi/be2iscsi/Kconfig:4: invalid option
make[1]: *** [menuconfig] Error 1
make: *** [menuconfig] Error 2

when I try to do

make menuconfig
or
make oldconfig
