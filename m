From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: replace deprecated hosts.h file
Date: Sat, 29 May 2004 11:10:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40B8A7FA.8070802@pobox.com>
References: <20040529142126.GA31365@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:10957 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S264261AbUE2PLG
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 May 2004 11:11:06 -0400
In-Reply-To: <20040529142126.GA31365@devserv.devel.redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjanv@redhat.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

Arjan van de Ven wrote:
> diff -purN linux-2.6.6/drivers/scsi.org/ata_piix.c linux-2.6.6/drivers/scsi/ata_piix.c
> --- linux-2.6.6/drivers/scsi.org/ata_piix.c	2004-05-12 17:45:57.913960000 +0200
> +++ linux-2.6.6/drivers/scsi/ata_piix.c	2004-05-12 17:46:19.796634288 +0200
> @@ -28,7 +28,7 @@
>  #include <linux/blkdev.h>
>  #include <linux/delay.h>
>  #include "scsi.h"
> -#include "hosts.h"
> +#include <scsi/scsi_host.h>
>  #include <linux/libata.h>
>  
>  #define DRV_NAME	"ata_piix"
> diff -purN linux-2.6.6/drivers/scsi.org/sata_promise.c linux-2.6.6/drivers/scsi/sata_promise.c
> --- linux-2.6.6/drivers/scsi.org/sata_promise.c	2004-05-12 17:45:58.168922000 +0200
> +++ linux-2.6.6/drivers/scsi/sata_promise.c	2004-05-12 17:46:22.691194248 +0200
> @@ -34,7 +34,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/sched.h>
>  #include "scsi.h"
> -#include "hosts.h"
> +#include <scsi/scsi_host.h>
>  #include <linux/libata.h>
>  #include <asm/io.h>
>  #include "sata_promise.h"
> diff -purN linux-2.6.6/drivers/scsi.org/sata_sil.c linux-2.6.6/drivers/scsi/sata_sil.c
> --- linux-2.6.6/drivers/scsi.org/sata_sil.c	2004-05-12 17:45:58.169922000 +0200
> +++ linux-2.6.6/drivers/scsi/sata_sil.c	2004-05-12 17:46:22.701192728 +0200
> @@ -34,7 +34,7 @@
>  #include <linux/delay.h>
>  #include <linux/interrupt.h>
>  #include "scsi.h"
> -#include "hosts.h"
> +#include <scsi/scsi_host.h>
>  #include <linux/libata.h>
>  
>  #define DRV_NAME	"sata_sil"
> diff -purN linux-2.6.6/drivers/scsi.org/sata_sis.c linux-2.6.6/drivers/scsi/sata_sis.c
> --- linux-2.6.6/drivers/scsi.org/sata_sis.c	2004-05-12 17:45:58.170921000 +0200
> +++ linux-2.6.6/drivers/scsi/sata_sis.c	2004-05-12 17:46:22.708191664 +0200
> @@ -34,7 +34,7 @@
>  #include <linux/delay.h>
>  #include <linux/interrupt.h>
>  #include "scsi.h"
> -#include "hosts.h"
> +#include <scsi/scsi_host.h>
>  #include <linux/libata.h>
>  
>  #define DRV_NAME	"sata_sis"
> diff -purN linux-2.6.6/drivers/scsi.org/sata_svw.c linux-2.6.6/drivers/scsi/sata_svw.c
> --- linux-2.6.6/drivers/scsi.org/sata_svw.c	2004-05-12 17:45:58.171921000 +0200
> +++ linux-2.6.6/drivers/scsi/sata_svw.c	2004-05-12 17:46:22.718190144 +0200
> @@ -40,7 +40,7 @@
>  #include <linux/delay.h>
>  #include <linux/interrupt.h>
>  #include "scsi.h"
> -#include "hosts.h"
> +#include <scsi/scsi_host.h>
>  #include <linux/libata.h>
>  
>  #ifdef CONFIG_PPC_OF
> diff -purN linux-2.6.6/drivers/scsi.org/sata_sx4.c linux-2.6.6/drivers/scsi/sata_sx4.c
> --- linux-2.6.6/drivers/scsi.org/sata_sx4.c	2004-05-12 17:45:58.173921000 +0200
> +++ linux-2.6.6/drivers/scsi/sata_sx4.c	2004-05-12 17:46:22.742186496 +0200
> @@ -34,7 +34,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/sched.h>
>  #include "scsi.h"
> -#include "hosts.h"
> +#include <scsi/scsi_host.h>
>  #include <linux/libata.h>
>  #include <asm/io.h>
>  #include "sata_promise.h"
> diff -purN linux-2.6.6/drivers/scsi.org/sata_via.c linux-2.6.6/drivers/scsi/sata_via.c
> --- linux-2.6.6/drivers/scsi.org/sata_via.c	2004-05-12 17:45:58.174921000 +0200
> +++ linux-2.6.6/drivers/scsi/sata_via.c	2004-05-12 17:46:22.751185128 +0200
> @@ -33,7 +33,7 @@
>  #include <linux/blkdev.h>
>  #include <linux/delay.h>
>  #include "scsi.h"
> -#include "hosts.h"
> +#include <scsi/scsi_host.h>
>  #include <linux/libata.h>
>  #include <asm/io.h>
>  
> diff -purN linux-2.6.6/drivers/scsi.org/sata_vsc.c linux-2.6.6/drivers/scsi/sata_vsc.c
> --- linux-2.6.6/drivers/scsi.org/sata_vsc.c	2004-05-12 17:45:58.175921000 +0200
> +++ linux-2.6.6/drivers/scsi/sata_vsc.c	2004-05-12 17:46:22.760183760 +0200
> @@ -22,7 +22,7 @@
>  #include <linux/delay.h>
>  #include <linux/interrupt.h>
>  #include "scsi.h"
> -#include "hosts.h"
> +#include <scsi/scsi_host.h>
>  #include <linux/libata.h>
>  
>  #define DRV_NAME	"sata_vsc"

Rejected, libata stays with the old headers until 2.7 (when it leaves scsi).

	Jeff


