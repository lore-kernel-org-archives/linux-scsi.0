From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [patch 04/28] MODULE_ALIAS_{BLOCK,CHAR}DEV_MAJOR for drivers/scsi
Date: Wed, 8 Mar 2006 10:32:30 +0200 (EET)
Message-ID: <Pine.LNX.4.63.0603081027510.26270@kai.makisara.local>
References: <200603080816.k288G97w002160@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep30-0.kolumbus.fi ([193.229.0.32]:10305 "EHLO
	fep30-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S1751448AbWCHI32 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Mar 2006 03:29:28 -0500
In-Reply-To: <200603080816.k288G97w002160@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, rene.herman@keyaccess.nl, greg@kroah.com, hch@lst.de

On Wed, 8 Mar 2006, akpm@osdl.org wrote:

> 
> From: Rene Herman <rene.herman@keyaccess.nl>
> 
> Add device-major aliases in drivers/scsi, allowing kmod autoload:
> 
> MODULE_ALIAS_CHARDEV_MAJOR(SCSI_CHANGER_MAJOR)
> MODULE_ALIAS_CHARDEV_MAJOR(OSST_MAJOR)
> MODULE_ALIAS_CHARDEV_MAJOR(SCSI_TAPE_MAJOR)
> MODULE_ALIAS_BLOCKDEV_MAJOR(SCSI_CDROM_MAJOR)
> MODULE_ALIAS_BLOCKDEV_MAJOR(SCSI_DISKN_MAJOR)
> 
> Submitted the SCSI_TAPE_MAJOR before to the driver author, but never got
> a reply:
> 
I am sorry, I have somehow missed this.

Acked-by: Kai Makisara <kai.makisara@kolumbus.fi>
