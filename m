From: Don Brace <brace77070@gmail.com>
Subject: Re: [PATCH] scsi: export function scsi_scan.c:sanitize_inquiry_string
Date: Fri, 22 Jan 2016 15:17:21 -0600
Message-ID: <56A29C61.2040901@pmcs.com>
References: <20160120194028.23159.25263.stgit@brunhilda>
 <20160120194141.23159.5168.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:34440 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbcAVVRY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jan 2016 16:17:24 -0500
Received: by mail-ob0-f172.google.com with SMTP id vt7so73244134obb.1
        for <linux-scsi@vger.kernel.org>; Fri, 22 Jan 2016 13:17:24 -0800 (PST)
In-Reply-To: <20160120194141.23159.5168.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, Viswas.G@pmcs.com, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, Mahesh.Rajashekhara@pmcs.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

On 01/20/2016 01:41 PM, Don Brace wrote:
> The hpsa driver uses this function to cleanup inquiry
> data. Our new pqi driver will also use this
> function. This function was copied into both drivers.
>
> This patch exports sanitize_inquiry_string so the hpsa
> and the pqi drivers can use this function directly.
>
> Hannes recommended the change in review:
> https://www.marc.info/?l=linux-scsi&m=144619249003064&w=2
> that using the existing function in scsi_scan would be
> preferrable.
>
> Suggested-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
>   drivers/scsi/scsi_scan.c |   12 +++++++-----
>   1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 6a82066..1f02e84 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -518,7 +518,8 @@ void scsi_target_reap(struct scsi_target *starget)
It was pointed out to me by Kevin Barnett that I should also add a prototype
in scsi.h.

Any thoughts for a V1 with this addition?


