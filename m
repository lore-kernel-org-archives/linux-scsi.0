From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/2] wd719x: Introduce Western Digital WD7193/7197/7296
 PCI SCSI card driver
Date: Wed, 1 Oct 2014 11:19:07 -0700
Message-ID: <20141001181907.GA668@infradead.org>
References: <1411757808-12530-1-git-send-email-linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43772 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbaJASTJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2014 14:19:09 -0400
Content-Disposition: inline
In-Reply-To: <1411757808-12530-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Kernel development list <linux-kernel@vger.kernel.org>

On Fri, Sep 26, 2014 at 08:56:46PM +0200, Ondrej Zary wrote:
> The card requires firmware that can be cut out of the Windows NT driver that 
> can be downloaded from WD at: 
> http://support.wdc.com/product/download.asp?groupid=801&sid=27&lang=en
> There is no license anywhere in the file or on the page - so I guess that the 
> firmware cannot be added to linux-firmware.
> 
> This script downloads and extracts the firmware:
> 
> #!/bin/sh
> wget http://support.wdc.com/download/archive/pciscsi.exe
> lha xi pciscsi.exe pci-scsi.exe
> lha xi pci-scsi.exe nt/wd7296a.sys
> rm pci-scsi.exe
> dd if=wd7296a.sys of=wd719x-risc.bin bs=1 skip=5760 count=14336
> dd if=wd7296a.sys of=wd719x-wcs.bin bs=1 skip=20096 count=514
> rm wd7296a.sys

Might be worth to add this script to the tree somewhere.

I'd be happy to merge the driver, but I'd love to get a second review
for it first.

