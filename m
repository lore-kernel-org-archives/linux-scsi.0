From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/2] struct scsi_lun preparation
Date: Mon, 11 Sep 2006 08:42:35 -0600
Message-ID: <20060911144235.GI29775@parisc-linux.org>
References: <20060911143406.GA12991@havoc.gtf.org> <20060911143458.GA13318@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:51334 "EHLO
	mail.parisc-linux.org") by vger.kernel.org with ESMTP
	id S932231AbWIKOmg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Sep 2006 10:42:36 -0400
Content-Disposition: inline
In-Reply-To: <20060911143458.GA13318@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org

On Mon, Sep 11, 2006 at 10:34:58AM -0400, Jeff Garzik wrote:
> @@ -1313,8 +1313,7 @@ EXPORT_SYMBOL(scsi_print_sense);
>  void scsi_print_command(struct scsi_cmnd *cmd)
>  {
>  	/* Assume appended output (i.e. not at start of line) */
> -	sdev_printk("", cmd->device, "\n");
> -	printk(KERN_INFO "        command: ");
> +	scmd_printk(KERN_INFO, cmd, "command:\n\t");
>  	scsi_print_cdb(cmd->cmnd, cmd->cmd_len, 0);

Did you not read the comment above the code you're changing?  Or are you
changing all callers?  If so, you need to remove the comment as well.
