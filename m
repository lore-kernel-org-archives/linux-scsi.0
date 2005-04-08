From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Hotplug support for BusLogic scsi controller
Date: Fri, 8 Apr 2005 17:46:58 +0100
Message-ID: <20050408164658.GB8669@parcelfarce.linux.theplanet.co.uk>
References: <1112977377.8880.24.camel@juerg-p4.bitron.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:50628 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S262873AbVDHQrT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Apr 2005 12:47:19 -0400
Content-Disposition: inline
In-Reply-To: <1112977377.8880.24.camel@juerg-p4.bitron.ch>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Juerg Billeter <juerg@paldo.org>
Cc: lnz@dandelion.com, linux-scsi@vger.kernel.org

On Fri, Apr 08, 2005 at 06:22:57PM +0200, Juerg Billeter wrote:
> This patch adds hotplug support to the driver for BusLogic scsi
> controllers. It's required to boot from a BusLogic controller when using
> modular kernels with hotplug-based initramfs.

It's a start, I suppose.  It's not really hotplug support though; for that
you'd need to implement the whole pci_driver infrastructure.  It'd be
worth someone doing (and the BusLogic cards are currently unmaintained,
I believe), so if you want to do that, we'd be only too happy to review
your patches.

BTW, you may want to use the PCI_DEVICE() macro to make the lines shorter.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
