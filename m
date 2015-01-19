From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH 2/4] scsi: annotate sdev_prefix_printk and scmd_printk
 as printf-like
Date: Mon, 19 Jan 2015 10:32:42 -0500
Message-ID: <1421681562.3891.216.camel@localhost.localdomain>
References: <1421593891-19984-1-git-send-email-hch@lst.de>
	 <1421593891-19984-2-git-send-email-hch@lst.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbbASPcv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2015 10:32:51 -0500
In-Reply-To: <1421593891-19984-2-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <JBottomley@Parallels.com>, linux-scsi@vger.kernel.org

On Sun, 2015-01-18 at 16:11 +0100, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  include/scsi/scsi_device.h | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index d1aad4d..2e0281e 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -237,14 +237,15 @@ struct scsi_dh_data {
>   * like scmd_printk, but the device name is passed in
>   * as a string pointer
>   */
> -extern int sdev_prefix_printk(const char *, const struct scsi_device *,
> -			      const char *, const char *, ...);
> +__printf(4, 5) int
> +sdev_prefix_printk(const char *, const struct scsi_device *, const char *,
> +		const char *, ...);
>  
>  #define sdev_printk(l, sdev, fmt, a...)				\
>  	sdev_prefix_printk(l, sdev, NULL, fmt, ##a)
>  
> -extern int scmd_printk(const char *, const struct scsi_cmnd *,
> -		       const char *, ...);
> +__printf(3, 4) int
> +scmd_printk(const char *, const struct scsi_cmnd *, const char *, ...);
>  
>  #define scmd_dbg(scmd, fmt, a...)					   \
>  	do {								   \

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


