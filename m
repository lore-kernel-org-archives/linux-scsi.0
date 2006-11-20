From: Brian King <brking@us.ibm.com>
Subject: Re: [2.6 patch] drivers/scsi/ipr.c: make 2 functions static
Date: Mon, 20 Nov 2006 08:36:05 -0600
Message-ID: <4561BD55.3090703@us.ibm.com>
References: <20061120022346.GF31879@stusta.de>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:8921 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S934199AbWKTOgJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Nov 2006 09:36:09 -0500
In-Reply-To: <20061120022346.GF31879@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

I'll merge this into a patchset I am working on for 2.6.20, since it
conflicts with another change I am making.

Thanks,

Brian

Adrian Bunk wrote:
> This patch makes two needlessly global functions static.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> ---
> 
>  drivers/scsi/ipr.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- linux-2.6.19-rc5-mm2/drivers/scsi/ipr.c.old	2006-11-20 00:50:09.000000000 +0100
> +++ linux-2.6.19-rc5-mm2/drivers/scsi/ipr.c	2006-11-20 00:50:28.000000000 +0100
> @@ -4615,7 +4615,7 @@
>   * Return value:
>   * 	0 on success / other on failure
>   **/
> -int ipr_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
> +static int ipr_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
>  {
>  	struct ipr_resource_entry *res;
> 
> @@ -4655,7 +4655,7 @@
>   * Return value:
>   * 	EH_NOT_HANDLED
>   **/
> -enum scsi_eh_timer_return ipr_scsi_timed_out(struct scsi_cmnd *scsi_cmd)
> +static enum scsi_eh_timer_return ipr_scsi_timed_out(struct scsi_cmnd *scsi_cmd)
>  {
>  	struct ipr_ioa_cfg *ioa_cfg;
>  	struct ipr_cmnd *ipr_cmd;
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
