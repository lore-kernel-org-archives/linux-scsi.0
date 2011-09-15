From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] scsi: qla4xxx needs libiscsi.o
Date: Thu, 15 Sep 2011 16:41:41 -0500
Message-ID: <4E727115.8060603@cs.wisc.edu>
References: <20110831150137.acb3b3805bd599ac57ce96c8@canb.auug.org.au> <20110831150200.54bec12e.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:36078 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935035Ab1IOVhV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Sep 2011 17:37:21 -0400
In-Reply-To: <20110831150200.54bec12e.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, scsi <linux-scsi@vger.kernel.org>, iscsi-driver@qlogic.com, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, jejbscsi <jbottomley@parallels.com>, akpm <akpm@linux-foundation.org>

On 08/31/2011 05:02 PM, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> qla4xxx driver needs to be linked with libiscsi.o to fix
> build errors.  This happens when no other drivers that use
> libiscsi.o are enabled.
> 
> Found in linux-next but applies to mainline also.
> 
> ERROR: "iscsi_conn_stop" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
> ERROR: "iscsi_conn_get_addr_param" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
> ERROR: "iscsi_session_teardown" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
> ERROR: "iscsi_host_alloc" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
> ERROR: "iscsi_conn_start" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
> ERROR: "iscsi_conn_send_pdu" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
> ERROR: "iscsi_session_get_param" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
> ERROR: "iscsi_conn_get_param" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
> ERROR: "iscsi_set_param" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
> ERROR: "iscsi_session_failure" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
> ERROR: "iscsi_complete_pdu" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
> ERROR: "iscsi_session_setup" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
> ERROR: "iscsi_conn_bind" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
> ERROR: "iscsi_conn_setup" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
> ERROR: "iscsi_itt_to_task" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> ---
>  drivers/scsi/Makefile |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-next-20110831.orig/drivers/scsi/Makefile
> +++ linux-next-20110831/drivers/scsi/Makefile
> @@ -88,7 +88,7 @@ obj-$(CONFIG_SCSI_QLOGIC_FAS)	+= qlogicf
>  obj-$(CONFIG_PCMCIA_QLOGIC)	+= qlogicfas408.o
>  obj-$(CONFIG_SCSI_QLOGIC_1280)	+= qla1280.o 
>  obj-$(CONFIG_SCSI_QLA_FC)	+= qla2xxx/
> -obj-$(CONFIG_SCSI_QLA_ISCSI)	+= qla4xxx/
> +obj-$(CONFIG_SCSI_QLA_ISCSI)	+= libiscsi.o qla4xxx/
>  obj-$(CONFIG_SCSI_LPFC)		+= lpfc/
>  obj-$(CONFIG_SCSI_BFA_FC)	+= bfa/
>  obj-$(CONFIG_SCSI_PAS16)	+= pas16.o


Sorry. Mixed this patch up with the other one sent that day. Looks ok.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
