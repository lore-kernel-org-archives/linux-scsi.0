From: Domen Puncer <domen@coderock.org>
Subject: Re: [patch 05/11] drivers/scsi/*: convert to pci_register_driver
Date: Sun, 6 Mar 2005 23:49:10 +0100
Message-ID: <20050306224910.GC32564@nd47.coderock.org>
References: <20050306222705.3AADE1EC90@trashy.coderock.org> <422B8602.2030908@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from coderock.org ([193.77.147.115]:22192 "EHLO trashy.coderock.org")
	by vger.kernel.org with ESMTP id S261602AbVCFWtQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Mar 2005 17:49:16 -0500
Content-Disposition: inline
In-Reply-To: <422B8602.2030908@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, c.lucas@ifrance.com

On 06/03/05 17:36 -0500, Jeff Garzik wrote:
> domen@coderock.org wrote:
> > kj-domen/drivers/scsi/ahci.c         |    2 +-
> > kj-domen/drivers/scsi/ata_piix.c     |    2 +-
> 
> > kj-domen/drivers/scsi/sata_nv.c      |    2 +-
> > kj-domen/drivers/scsi/sata_promise.c |    2 +-
> > kj-domen/drivers/scsi/sata_sil.c     |    2 +-
> > kj-domen/drivers/scsi/sata_sis.c     |    2 +-
> > kj-domen/drivers/scsi/sata_svw.c     |    2 +-
> > kj-domen/drivers/scsi/sata_sx4.c     |    2 +-
> > kj-domen/drivers/scsi/sata_uli.c     |    2 +-
> > kj-domen/drivers/scsi/sata_via.c     |    2 +-
> > kj-domen/drivers/scsi/sata_vsc.c     |    2 +-
> 
> 
> NAK. These drivers are actively maintained in 2.4, and pci_module_init() 
> is a compatibility wrapper for these drivers.

Same goes for "real scsi" ones, I guess.
Sorry for the noise.

> 
> Also, you need to split off patches for these drivers and send them to 
> me and linux-ide@vger.kernel.org.

Ok.
Thanks.


	Domen
