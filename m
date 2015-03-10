From: Olaf Hering <olaf@aepfle.de>
Subject: Re: [PATCH] SCSI:STORVSC Use SCSI layer to allocate memory for
 per-command device request data
Date: Tue, 10 Mar 2015 12:42:33 +0100
Message-ID: <20150310114233.GA30423@gmail.com>
References: <1419912309-13518-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35408 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920AbbCJLmf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Mar 2015 07:42:35 -0400
Content-Disposition: inline
In-Reply-To: <1419912309-13518-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: kys@microsoft.com, haiyangz@microsoft.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, devel@linuxdriverproject.org, linux-kernel@vger.kernel.org, longli@microsoft.com

On Mon, Dec 29, Christoph Hellwig wrote:

> +++ b/drivers/scsi/storvsc_drv.c

>  static struct scsi_host_template scsi_driver = {
>  	.module	=		THIS_MODULE,
>  	.name =			"storvsc_host_t",
> +	.cmd_size =             sizeof(struct storvsc_cmd_request),
>  	.bios_param =		storvsc_get_chs,
>  	.queuecommand =		storvsc_queuecommand,
>  	.eh_host_reset_handler =	storvsc_host_reset_handler,
> +	.proc_name =		"storvsc_host",

It would be nice to change .proc_name to KBUILD_MODNAME before v4.0 is
released. We carry a patch which adds this field. Of cource we can just
change the patch, but if code gets touched upstream anyway...


Olaf
