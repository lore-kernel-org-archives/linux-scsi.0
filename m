From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 1/3] remove Scsi_Host_Template typedef
Date: Tue, 06 Sep 2005 21:14:03 -0400
Message-ID: <431E3EDB.7070703@pobox.com>
References: <20050905124012.GA5835@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:31978 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751168AbVIGBOf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Sep 2005 21:14:35 -0400
In-Reply-To: <20050905124012.GA5835@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> Index: scsi-misc-2.6/drivers/scsi/ahci.c
> ===================================================================
> --- scsi-misc-2.6.orig/drivers/scsi/ahci.c	2005-08-31 13:59:11.000000000 +0200
> +++ scsi-misc-2.6/drivers/scsi/ahci.c	2005-09-01 22:49:33.000000000 +0200
> @@ -189,7 +189,7 @@
>  static inline int ahci_host_intr(struct ata_port *ap, struct ata_queued_cmd *qc);
>  static void ahci_remove_one (struct pci_dev *pdev);
>  
> -static Scsi_Host_Template ahci_sht = {
> +static struct scsi_host_template ahci_sht = {
>  	.module			= THIS_MODULE,
>  	.name			= DRV_NAME,
>  	.ioctl			= ata_scsi_ioctl,

> Index: scsi-misc-2.6/drivers/scsi/ata_piix.c
> ===================================================================
> --- scsi-misc-2.6.orig/drivers/scsi/ata_piix.c	2005-08-31 13:59:11.000000000 +0200
> +++ scsi-misc-2.6/drivers/scsi/ata_piix.c	2005-09-01 22:54:02.000000000 +0200
> @@ -109,7 +109,7 @@
>  	.remove			= ata_pci_remove_one,
>  };
>  
> -static Scsi_Host_Template piix_sht = {
> +static struct scsi_host_template piix_sht = {
>  	.module			= THIS_MODULE,
>  	.name			= DRV_NAME,
>  	.ioctl			= ata_scsi_ioctl,

> Index: scsi-misc-2.6/drivers/scsi/sata_nv.c
> ===================================================================
> --- scsi-misc-2.6.orig/drivers/scsi/sata_nv.c	2005-08-31 13:59:12.000000000 +0200
> +++ scsi-misc-2.6/drivers/scsi/sata_nv.c	2005-09-01 22:51:38.000000000 +0200
> @@ -189,7 +189,7 @@
>  	.remove			= ata_pci_remove_one,
>  };
>  
> -static Scsi_Host_Template nv_sht = {
> +static struct scsi_host_template nv_sht = {
>  	.module			= THIS_MODULE,
>  	.name			= DRV_NAME,
>  	.ioctl			= ata_scsi_ioctl,
> Index: scsi-misc-2.6/drivers/scsi/sata_promise.c
> ===================================================================
> --- scsi-misc-2.6.orig/drivers/scsi/sata_promise.c	2005-08-31 13:59:12.000000000 +0200
> +++ scsi-misc-2.6/drivers/scsi/sata_promise.c	2005-09-01 22:51:40.000000000 +0200
> @@ -86,7 +86,7 @@
>  static void pdc_irq_clear(struct ata_port *ap);
>  static int pdc_qc_issue_prot(struct ata_queued_cmd *qc);
>  
> -static Scsi_Host_Template pdc_ata_sht = {
> +static struct scsi_host_template pdc_ata_sht = {
>  	.module			= THIS_MODULE,
>  	.name			= DRV_NAME,
>  	.ioctl			= ata_scsi_ioctl,
> Index: scsi-misc-2.6/drivers/scsi/sata_qstor.c
> ===================================================================
> --- scsi-misc-2.6.orig/drivers/scsi/sata_qstor.c	2005-08-31 13:59:12.000000000 +0200
> +++ scsi-misc-2.6/drivers/scsi/sata_qstor.c	2005-09-01 22:51:43.000000000 +0200
> @@ -122,7 +122,7 @@
>  static void qs_irq_clear(struct ata_port *ap);
>  static void qs_eng_timeout(struct ata_port *ap);
>  
> -static Scsi_Host_Template qs_ata_sht = {
> +static struct scsi_host_template qs_ata_sht = {
>  	.module			= THIS_MODULE,
>  	.name			= DRV_NAME,
>  	.ioctl			= ata_scsi_ioctl,
> Index: scsi-misc-2.6/drivers/scsi/sata_sil.c
> ===================================================================
> --- scsi-misc-2.6.orig/drivers/scsi/sata_sil.c	2005-08-31 13:59:12.000000000 +0200
> +++ scsi-misc-2.6/drivers/scsi/sata_sil.c	2005-09-01 22:51:45.000000000 +0200
> @@ -118,7 +118,7 @@
>  	.remove			= ata_pci_remove_one,
>  };
>  
> -static Scsi_Host_Template sil_sht = {
> +static struct scsi_host_template sil_sht = {
>  	.module			= THIS_MODULE,
>  	.name			= DRV_NAME,
>  	.ioctl			= ata_scsi_ioctl,
> Index: scsi-misc-2.6/drivers/scsi/sata_sis.c
> ===================================================================
> --- scsi-misc-2.6.orig/drivers/scsi/sata_sis.c	2005-08-31 13:59:12.000000000 +0200
> +++ scsi-misc-2.6/drivers/scsi/sata_sis.c	2005-09-01 22:51:48.000000000 +0200
> @@ -73,7 +73,7 @@
>  	.remove			= ata_pci_remove_one,
>  };
>  
> -static Scsi_Host_Template sis_sht = {
> +static struct scsi_host_template sis_sht = {
>  	.module			= THIS_MODULE,
>  	.name			= DRV_NAME,
>  	.ioctl			= ata_scsi_ioctl,
> Index: scsi-misc-2.6/drivers/scsi/sata_svw.c
> ===================================================================
> --- scsi-misc-2.6.orig/drivers/scsi/sata_svw.c	2005-08-31 13:59:12.000000000 +0200
> +++ scsi-misc-2.6/drivers/scsi/sata_svw.c	2005-09-01 22:51:51.000000000 +0200
> @@ -268,7 +268,7 @@
>  #endif /* CONFIG_PPC_OF */
>  
>  
> -static Scsi_Host_Template k2_sata_sht = {
> +static struct scsi_host_template k2_sata_sht = {
>  	.module			= THIS_MODULE,
>  	.name			= DRV_NAME,
>  	.ioctl			= ata_scsi_ioctl,
> Index: scsi-misc-2.6/drivers/scsi/sata_sx4.c
> ===================================================================
> --- scsi-misc-2.6.orig/drivers/scsi/sata_sx4.c	2005-08-31 13:59:12.000000000 +0200
> +++ scsi-misc-2.6/drivers/scsi/sata_sx4.c	2005-09-01 22:51:53.000000000 +0200
> @@ -171,7 +171,7 @@
>  static int pdc20621_qc_issue_prot(struct ata_queued_cmd *qc);
>  
>  
> -static Scsi_Host_Template pdc_sata_sht = {
> +static struct scsi_host_template pdc_sata_sht = {
>  	.module			= THIS_MODULE,
>  	.name			= DRV_NAME,
>  	.ioctl			= ata_scsi_ioctl,
> Index: scsi-misc-2.6/drivers/scsi/sata_uli.c
> ===================================================================
> --- scsi-misc-2.6.orig/drivers/scsi/sata_uli.c	2005-08-31 13:59:12.000000000 +0200
> +++ scsi-misc-2.6/drivers/scsi/sata_uli.c	2005-09-01 22:51:55.000000000 +0200
> @@ -65,7 +65,7 @@
>  	.remove			= ata_pci_remove_one,
>  };
>  
> -static Scsi_Host_Template uli_sht = {
> +static struct scsi_host_template uli_sht = {
>  	.module			= THIS_MODULE,
>  	.name			= DRV_NAME,
>  	.ioctl			= ata_scsi_ioctl,
> Index: scsi-misc-2.6/drivers/scsi/sata_via.c
> ===================================================================
> --- scsi-misc-2.6.orig/drivers/scsi/sata_via.c	2005-08-31 13:59:12.000000000 +0200
> +++ scsi-misc-2.6/drivers/scsi/sata_via.c	2005-09-01 22:51:58.000000000 +0200
> @@ -85,7 +85,7 @@
>  	.remove			= ata_pci_remove_one,
>  };
>  
> -static Scsi_Host_Template svia_sht = {
> +static struct scsi_host_template svia_sht = {
>  	.module			= THIS_MODULE,
>  	.name			= DRV_NAME,
>  	.ioctl			= ata_scsi_ioctl,
> Index: scsi-misc-2.6/drivers/scsi/sata_vsc.c
> ===================================================================
> --- scsi-misc-2.6.orig/drivers/scsi/sata_vsc.c	2005-08-31 13:59:12.000000000 +0200
> +++ scsi-misc-2.6/drivers/scsi/sata_vsc.c	2005-09-01 22:52:00.000000000 +0200
> @@ -189,7 +189,7 @@
>  }
>  
>  
> -static Scsi_Host_Template vsc_sata_sht = {
> +static struct scsi_host_template vsc_sata_sht = {
>  	.module			= THIS_MODULE,
>  	.name			= DRV_NAME,
>  	.ioctl			= ata_scsi_ioctl,

> Index: scsi-misc-2.6/include/linux/libata.h
> ===================================================================
> --- scsi-misc-2.6.orig/include/linux/libata.h	2005-08-31 13:59:15.000000000 +0200
> +++ scsi-misc-2.6/include/linux/libata.h	2005-09-01 22:46:40.000000000 +0200
> @@ -194,7 +194,7 @@
>  	struct list_head	node;
>  	struct device 		*dev;
>  	struct ata_port_operations	*port_ops;
> -	Scsi_Host_Template	*sht;
> +	struct scsi_host_template	*sht;
>  	struct ata_ioports	port[ATA_MAX_PORTS];
>  	unsigned int		n_ports;
>  	unsigned int		hard_port_no;
> @@ -368,7 +368,7 @@
>  };
>  
>  struct ata_port_info {
> -	Scsi_Host_Template	*sht;
> +	struct scsi_host_template	*sht;
>  	unsigned long		host_flags;
>  	unsigned long		pio_mask;
>  	unsigned long		mwdma_mask;
> @@ -389,7 +389,7 @@
>  extern void ata_pci_remove_one (struct pci_dev *pdev);
>  #endif /* CONFIG_PCI */
>  extern int ata_device_add(struct ata_probe_ent *ent);
> -extern int ata_scsi_detect(Scsi_Host_Template *sht);
> +extern int ata_scsi_detect(struct scsi_host_template *sht);
>  extern int ata_scsi_ioctl(struct scsi_device *dev, int cmd, void __user *arg);
>  extern int ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *));
>  extern int ata_scsi_error(struct Scsi_Host *host);


Soo...   just days after I emphasized the importance of 2.4.x support in 
libata [until ATAPI is finished], you submit a patch trashing that 2.4.x 
support.  Modified a bunch of my drivers, without even CC'ing me.

Are you intentionally being rude?

Scsi_Host_Template is one of the typedefs that isn't easily upgraded, 
unlike other struct definitions that are in 2.4.x.

	Jeff


