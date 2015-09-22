From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH 07/23] scsi: remove scsi_show_sense_hdr()
Date: Tue, 22 Sep 2015 14:36:46 -0400
Message-ID: <1442947006.4132.9.camel@localhost.localdomain>
References: <1440679281-13234-1-git-send-email-hare@suse.de>
	 <1440679281-13234-8-git-send-email-hare@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759355AbbIVSgs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Sep 2015 14:36:48 -0400
In-Reply-To: <1440679281-13234-8-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On Thu, 2015-08-27 at 14:41 +0200, Hannes Reinecke wrote:
> Last caller is gone, so remove it.
> 
> Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Reviewed-by: Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  include/scsi/scsi_dbg.h | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/include/scsi/scsi_dbg.h b/include/scsi/scsi_dbg.h
> index f8170e9..56710e0 100644
> --- a/include/scsi/scsi_dbg.h
> +++ b/include/scsi/scsi_dbg.h
> @@ -12,8 +12,6 @@ extern size_t __scsi_format_command(char *, size_t,
>  				   const unsigned char *, size_t);
>  extern void scsi_show_extd_sense(const struct scsi_device *, const char *,
>  				 unsigned char, unsigned char);
> -extern void scsi_show_sense_hdr(const struct scsi_device *, const char *,
> -				const struct scsi_sense_hdr *);
>  extern void scsi_print_sense_hdr(const struct scsi_device *, const char *,
>  				 const struct scsi_sense_hdr *);
>  extern void scsi_print_sense(const struct scsi_cmnd *);

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


