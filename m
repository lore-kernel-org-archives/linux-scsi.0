From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH] Revert accidental Makefile change
Date: Wed, 27 Jul 2005 11:03:24 -0700
Message-ID: <20050727180324.GH7114@plap.qlogic.org>
References: <1122486845.2757.19.camel@dv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:34875 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S261336AbVG0SDZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jul 2005 14:03:25 -0400
Content-Disposition: inline
In-Reply-To: <1122486845.2757.19.camel@dv>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pavel Roskin <proski@gnu.org>
Cc: linux-scsi@vger.kernel.org

On Wed, 27 Jul 2005, Pavel Roskin wrote:

> In the current git kernel, the qla2xxx.ko module is build and installed,
> although I have never requested it and I don't have any modules enabled.
> 
> I found the corresponding entry in the git log (commit
> fca297037127e524e8f61b3fc1c7a1886e5d757b), and it looks like that
> the change in drivers/scsi/qla2xxx/Makefile was committed accidentally.
> The comment doesn't refer to Makefile.
> 
> Signed-off-by: Pavel Roskin <proski@gnu.org>
> 
> diff --git a/drivers/scsi/qla2xxx/Makefile b/drivers/scsi/qla2xxx/Makefile
> --- a/drivers/scsi/qla2xxx/Makefile
> +++ b/drivers/scsi/qla2xxx/Makefile
> @@ -1,6 +1,4 @@
>  EXTRA_CFLAGS += -DUNIQUE_FW_NAME
> -CONFIG_SCSI_QLA24XX=m
> -EXTRA_CFLAGS += -DCONFIG_SCSI_QLA24XX -DCONFIG_SCSI_QLA24XX_MODULE
>  
>  qla2xxx-y := qla_os.o qla_init.o qla_mbx.o qla_iocb.o qla_isr.o qla_gs.o \
>  		qla_dbg.o qla_sup.o qla_rscn.o qla_attr.o
> @@ -16,4 +14,3 @@ obj-$(CONFIG_SCSI_QLA22XX) += qla2xxx.o 
>  obj-$(CONFIG_SCSI_QLA2300) += qla2xxx.o qla2300.o
>  obj-$(CONFIG_SCSI_QLA2322) += qla2xxx.o qla2322.o
>  obj-$(CONFIG_SCSI_QLA6312) += qla2xxx.o qla6312.o
> -obj-$(CONFIG_SCSI_QLA24XX) += qla2xxx.o

I had already submitted a patch which took care of this:

http://marc.theaimsgroup.com/?l=linux-scsi&m=112143863232467&w=2

There also appears to be some other (separate) Kbuild issues which I'm
hashing through...

Regards,
Andrew Vasquez
