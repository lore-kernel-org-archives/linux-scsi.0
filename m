From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v2 0/7] scsi_debug: several bug fixes and enable clustering
 support
Date: Sun, 19 Jan 2014 10:59:58 -0500
Message-ID: <52DBF67E.9030807@interlog.com>
References: <1390139503-11519-1-git-send-email-akinobu.mita@gmail.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:46506 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337AbaASQAH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Jan 2014 11:00:07 -0500
In-Reply-To: <1390139503-11519-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>, linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 14-01-19 08:51 AM, Akinobu Mita wrote:
> This patch set includes several bug fixes and patches for enabling
> clustering support for scsi_debug.
>
> The reason why I would like to enable clustering is to test commands
> with huge transfer length.  Without enabling clustering support, the
> transfer length for read and write scsi commands is limited upto 8MB
> when page size is 4KB and sg_tablesize is 2048
> (= SCSI_MAX_SG_CHAIN_SEGMENTS).
>
> Changes from v1:
> - remove unnecessary irqsave/irqrestore while iterating sg mapping
> - protect device access with atomic_rw lock
> - make clustering module parameter writable
>
> Akinobu Mita (7):
>    scsi_debug: fix false positive logical block reference tag check fail
>    scsi_debug: make pseudo_primary static
>    scsi_debug: fix duplicate dif_errors increment
>    scsi_debug: fix resp_xdwriteread() return value when running out of
>      memory
>    scsi_debug: prepare to enable clustering
>    scsi_debug: protect device access with atomic_rw lock
>    scsi_debug: add ability to enable clustering
>
>   drivers/scsi/scsi_debug.c | 141 +++++++++++++++++++++++++++-------------------
>   1 file changed, 82 insertions(+), 59 deletions(-)
>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: Douglas Gilbert <dgilbert@interlog.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org

The parts of this patch that I understand look fine. Perhaps
Martin should "ack" it, if he sees fit.

Reviewed-by: Douglas Gilbert <dgilbert@interlog.com>

