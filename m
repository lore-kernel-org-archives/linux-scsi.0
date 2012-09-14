From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 42/42] qla2xxx: Update version number to 8.04.00.07-k.
Date: Fri, 14 Sep 2012 18:20:36 +0100
Message-ID: <1347643236.2450.19.camel@dabdike.int.hansenpartnership.com>
References: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
	 <1345659696-3670-43-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59351 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759508Ab2INRUj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Sep 2012 13:20:39 -0400
In-Reply-To: <1345659696-3670-43-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

On Wed, 2012-08-22 at 14:21 -0400, Chad Dupuis wrote:
> Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
> Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/qla_version.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
> index e6a5270..cfe934e 100644
> --- a/drivers/scsi/qla2xxx/qla_version.h
> +++ b/drivers/scsi/qla2xxx/qla_version.h
> @@ -7,9 +7,9 @@
>  /*
>   * Driver version
>   */
> -#define QLA2XXX_VERSION      "8.04.00.03-k"
> +#define QLA2XXX_VERSION      "8.04.00.07-k"
>  
>  #define QLA_DRIVER_MAJOR_VER	8
>  #define QLA_DRIVER_MINOR_VER	4
>  #define QLA_DRIVER_PATCH_VER	0
> -#define QLA_DRIVER_BETA_VER	3
> +#define QLA_DRIVER_BETA_VER	0

Shouldn't this be 7 not 0?

James


