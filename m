From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 05/17] scsi: remove scsi_show_sense_hdr()
Date: Thu, 7 May 2015 13:49:25 +0200
Message-ID: <554B5145.3010503@sandisk.com>
References: <1430743343-47174-1-git-send-email-hare@suse.de>
 <1430743343-47174-6-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0092.outbound.protection.outlook.com ([65.55.169.92]:14172
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751464AbbEGLtb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 May 2015 07:49:31 -0400
In-Reply-To: <1430743343-47174-6-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 05/04/15 14:42, Hannes Reinecke wrote:
> Last caller is gone, so remove it.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   include/scsi/scsi_dbg.h | 2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/include/scsi/scsi_dbg.h b/include/scsi/scsi_dbg.h
> index f8170e9..56710e0 100644
> --- a/include/scsi/scsi_dbg.h
> +++ b/include/scsi/scsi_dbg.h
> @@ -12,8 +12,6 @@ extern size_t __scsi_format_command(char *, size_t,
>   				   const unsigned char *, size_t);
>   extern void scsi_show_extd_sense(const struct scsi_device *, const char *,
>   				 unsigned char, unsigned char);
> -extern void scsi_show_sense_hdr(const struct scsi_device *, const char *,
> -				const struct scsi_sense_hdr *);
>   extern void scsi_print_sense_hdr(const struct scsi_device *, const char *,
>   				 const struct scsi_sense_hdr *);
>   extern void scsi_print_sense(const struct scsi_cmnd *);

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
