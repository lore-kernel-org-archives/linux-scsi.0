From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] scsi: timeout reset timer before command is queued
Date: Mon, 14 Dec 2009 19:59:23 -0700
Message-ID: <20091215025923.GL7812@parisc-linux.org>
References: <4B21B143.0@mvista.com> <4B24B962.4070804@panasas.com> <4B26E38C.1000605@mvista.com> <20091215022126.GK7812@parisc-linux.org> <4B26F70D.6090409@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:50063 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759077AbZLOC7Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Dec 2009 21:59:24 -0500
Content-Disposition: inline
In-Reply-To: <4B26F70D.6090409@mvista.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Min Zhang <mzhang@mvista.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

On Mon, Dec 14, 2009 at 06:40:13PM -0800, Min Zhang wrote:
> Try again, don't know which white space you refer to or how to fix it:
> +++ b/drivers/scsi/scsi.c
> @@ -743,6 +743,9 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
>      */
>     scsi_cmd_get_serial(host, cmd);
>
> +    /* Timeout error handler can start processing cmd now */
> +    cmd->eh_eflags &= ~SCSI_EH_RESET_TIMER;
> +
>     if (unlikely(host->shost_state == SHOST_DEL)) {
>         cmd->result = (DID_NO_CONNECT << 16);
>         scsi_done(cmd);

Your indent appears to be four spaces.  The file uses tabs for indents.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
