From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] scsi_debug: correct parameter default text
Date: Mon, 11 Jun 2007 14:45:37 -0400
Message-ID: <466D9851.6070009@torque.net>
References: <20070611113640.a2ec2afd.randy.dunlap@oracle.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:49856 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbXFKSqN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jun 2007 14:46:13 -0400
In-Reply-To: <20070611113640.a2ec2afd.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: jejb <james.bottomley@steeleye.com>, scsi <linux-scsi@vger.kernel.org>

Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Correct the module info text for the default value of
> "every_nth" to 0.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Douglas Gilbert <dougg@torque.net>

Doug Gilbert

> ---
>  drivers/scsi/scsi_debug.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-2622-rc4.orig/drivers/scsi/scsi_debug.c
> +++ linux-2622-rc4/drivers/scsi/scsi_debug.c
> @@ -2405,7 +2405,7 @@ MODULE_PARM_DESC(add_host, "0..127 hosts
>  MODULE_PARM_DESC(delay, "# of jiffies to delay response(def=1)");
>  MODULE_PARM_DESC(dev_size_mb, "size in MB of ram shared by devs(def=8)");
>  MODULE_PARM_DESC(dsense, "use descriptor sense format(def=0 -> fixed)");
> -MODULE_PARM_DESC(every_nth, "timeout every nth command(def=100)");
> +MODULE_PARM_DESC(every_nth, "timeout every nth command(def=0)");
>  MODULE_PARM_DESC(fake_rw, "fake reads/writes instead of copying (def=0)");
>  MODULE_PARM_DESC(max_luns, "number of LUNs per target to simulate(def=1)");
>  MODULE_PARM_DESC(no_lun_0, "no LU number 0 (def=0 -> have lun 0)");
> 

