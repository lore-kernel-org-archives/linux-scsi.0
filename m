From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [patch 05/11] drivers/scsi/*: convert to pci_register_driver
Date: Sun, 06 Mar 2005 17:36:50 -0500
Message-ID: <422B8602.2030908@pobox.com>
References: <20050306222705.3AADE1EC90@trashy.coderock.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:3818 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261573AbVCFWhH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Mar 2005 17:37:07 -0500
In-Reply-To: <20050306222705.3AADE1EC90@trashy.coderock.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: domen@coderock.org
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, c.lucas@ifrance.com

domen@coderock.org wrote:
>  kj-domen/drivers/scsi/ahci.c         |    2 +-
>  kj-domen/drivers/scsi/ata_piix.c     |    2 +-

>  kj-domen/drivers/scsi/sata_nv.c      |    2 +-
>  kj-domen/drivers/scsi/sata_promise.c |    2 +-
>  kj-domen/drivers/scsi/sata_sil.c     |    2 +-
>  kj-domen/drivers/scsi/sata_sis.c     |    2 +-
>  kj-domen/drivers/scsi/sata_svw.c     |    2 +-
>  kj-domen/drivers/scsi/sata_sx4.c     |    2 +-
>  kj-domen/drivers/scsi/sata_uli.c     |    2 +-
>  kj-domen/drivers/scsi/sata_via.c     |    2 +-
>  kj-domen/drivers/scsi/sata_vsc.c     |    2 +-


NAK. These drivers are actively maintained in 2.4, and pci_module_init() 
is a compatibility wrapper for these drivers.

Also, you need to split off patches for these drivers and send them to 
me and linux-ide@vger.kernel.org.

	Jeff


