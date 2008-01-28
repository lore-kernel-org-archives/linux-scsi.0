From: Greg KH <greg@kroah.com>
Subject: Re: [BUG] 2.6.24-git usb reset problems
Date: Mon, 28 Jan 2008 13:21:14 -0800
Message-ID: <20080128212114.GA15586@kroah.com>
References: <20080128204935.GI15220@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:43479 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649AbYA1VWs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Jan 2008 16:22:48 -0500
Content-Disposition: inline
In-Reply-To: <20080128204935.GI15220@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Jan 28, 2008 at 09:49:35PM +0100, Jens Axboe wrote:
> Hi,
> 
> Running latest -git (head 91525300baf162e83e923b09ca286f9205e21522) and
> connecting my cf usb storage device yields and endless stream of:
> 
> Initializing USB Mass Storage driver...
> scsi6 : SCSI emulation for USB Mass Storage devices
> usb-storage: device found at 2
> usb-storage: waiting for device to settle before scanning
> usbcore: registered new interface driver usb-storage
> USB Mass Storage support registered.
> scsi 6:0:0:0: Direct-Access     Generic  STORAGE DEVICE   0125 PQ: 0
> ANSI: 0
> sd 6:0:0:0: [sdb] 4001760 512-byte hardware sectors (2049 MB)
> sd 6:0:0:0: [sdb] Write Protect is off
> sd 6:0:0:0: [sdb] Mode Sense: 02 00 00 00
> sd 6:0:0:0: [sdb] Assuming drive cache: write through
> sd 6:0:0:0: [sdb] 4001760 512-byte hardware sectors (2049 MB)
> sd 6:0:0:0: [sdb] Write Protect is off
> sd 6:0:0:0: [sdb] Mode Sense: 02 00 00 00
> sd 6:0:0:0: [sdb] Assuming drive cache: write through
>  sdb: sdb1
> sd 6:0:0:0: [sdb] Attached SCSI removable disk
> sd 6:0:0:0: Attached scsi generic sg1 type 0
> scsi 6:0:0:1: Direct-Access     Generic  STORAGE DEVICE   0125 PQ: 0
> ANSI: 0
> usb 5-1: reset high speed USB device using ehci_hcd and address 2
> usb 5-1: reset high speed USB device using ehci_hcd and address 2
> usb 5-1: reset high speed USB device using ehci_hcd and address 2
> usb 5-1: reset high speed USB device using ehci_hcd and address 2
> usb 5-1: reset high speed USB device using ehci_hcd and address 2
> usb 5-1: reset high speed USB device using ehci_hcd and address 2
> usb 5-1: reset high speed USB device using ehci_hcd and address 2
> [...]
> 
> until I disconnect it. The device doesn't work. Worked fine in 2.6.24.
> I'm attaching boot messages and my .config.

That's a bit wierd, as we haven't added any USB patches to the -git tree
yet after 2.6.24 :)

Could this be caused by some scsi changes perhaps?

thanks,

greg k-h
