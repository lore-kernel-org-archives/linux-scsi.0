From: Stelian Pop <stelian@popies.net>
Subject: Re: [example PATCH - not for applying] exclude certain commands
Date: Thu, 24 Apr 2003 11:22:10 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030424092210.GC1342@deep-space-9.dsnet>
References: <UTC200304232239.h3NMdSf07801.aeb@smtp.cwi.nl> <20030424091552.GB1342@deep-space-9.dsnet>
Reply-To: Stelian Pop <stelian@popies.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from d146.dhcp212-198-27.noos.fr ([212.198.27.146]:31111 "EHLO
	deep-space-9.dsnet") by vger.kernel.org with ESMTP id S261885AbTDXJKT
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Apr 2003 05:10:19 -0400
Content-Disposition: inline
In-Reply-To: <20030424091552.GB1342@deep-space-9.dsnet>
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl
Cc: James.Bottomley@steeleye.com, afafc@rnl.ist.utl.pt, alan@lxorguk.ukuu.org.uk, greg@kroah.com, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, mike@hingston.demon.co.uk, torvalds@transmeta.com

On Thu, Apr 24, 2003 at 11:15:52AM +0200, Stelian Pop wrote:

> I confirm that this patch makes both my memory stick reader
> *and* my USB floppy drive work perfectly again.

Fergot to attach some relevant traces (with the patch):

Apr 24 10:24:04 crusoe kernel: Initializing USB Mass Storage driver...
Apr 24 10:24:04 crusoe kernel: scsi0 : SCSI emulation for USB Mass Storage devices
Apr 24 10:24:04 crusoe /sbin/hotplug: no runnable /etc/hotplug/scsi.agent is installed
Apr 24 10:24:04 crusoe kernel: WARNING: USB Mass Storage data integrity not assured
Apr 24 10:24:04 crusoe kernel: USB Mass Storage device found at 2
Apr 24 10:24:04 crusoe kernel: drivers/usb/core/usb.c: registered new driver usb-storage
Apr 24 10:24:04 crusoe kernel: USB Mass Storage support registered.
Apr 24 10:24:14 crusoe kernel: usb-storage: Had to truncate MODE_SENSE_10 buffer into MODE_SENSE.
Apr 24 10:24:14 crusoe kernel: usb-storage: outputBufferSize is 10 and length is 8.
Apr 24 10:24:14 crusoe kernel: sda: Mode Sense: 06 00 00 00
Apr 24 10:24:14 crusoe kernel: usb-storage: Had to truncate MODE_SENSE_10 buffer into MODE_SENSE.
Apr 24 10:24:14 crusoe kernel: usb-storage: outputBufferSize is 10 and length is 8.
Apr 24 10:24:14 crusoe kernel: usb-storage: Had to truncate MODE_SENSE_10 buffer into MODE_SENSE.
Apr 24 10:24:14 crusoe kernel: usb-storage: outputBufferSize is 10 and length is 8.
Apr 24 10:24:14 crusoe /sbin/hotplug: no runnable /etc/hotplug/block.agent is installed
Apr 24 10:24:14 crusoe kernel:  sda: sda1
Apr 24 10:24:15 crusoe /sbin/hotplug: no runnable /etc/hotplug/block.agent is installed
Apr 24 10:24:48 crusoe kernel: hub 1-0:0: debounce: port 1: delay 100ms stable 4 status 0x101
Apr 24 10:24:48 crusoe kernel: hub 1-0:0: new USB device on port 1, assigned address 3
Apr 24 10:24:48 crusoe /etc/hotplug/usb.agent: Bad USB agent invocation
Apr 24 10:24:49 crusoe kernel: scsi1 : SCSI emulation for USB Mass Storage devices
Apr 24 10:24:49 crusoe /sbin/hotplug: no runnable /etc/hotplug/scsi.agent is installed
Apr 24 10:24:49 crusoe kernel: WARNING: USB Mass Storage data integrity not assured
Apr 24 10:24:49 crusoe kernel: USB Mass Storage device found at 3
Apr 24 10:24:49 crusoe /sbin/hotplug: no runnable /etc/hotplug/block.agent is installed
Apr 24 10:24:52 crusoe /etc/hotplug/usb.agent: Setup usb-storage for USB product 57b/0/312
Apr 24 10:24:52 crusoe modprobe: FATAL: Module usb_storage already in kernel. 
Apr 24 10:24:52 crusoe modprobe: FATAL: Module ide_probe_mod not found. 
Apr 24 10:24:52 crusoe modprobe: FATAL: Module ide_probe not found. 
Apr 24 10:24:52 crusoe modprobe: FATAL: Module ohci1394 already in kernel. 
Apr 24 10:24:57 crusoe kernel: usb-storage: Had to truncate MODE_SENSE_10 buffer into MODE_SENSE.
Apr 24 10:24:57 crusoe kernel: usb-storage: outputBufferSize is 74 and length is 8.
Apr 24 10:24:57 crusoe kernel: sdb: Mode Sense: 46 94 00 00
Apr 24 10:24:57 crusoe kernel: sdb: assuming drive cache: write through
Apr 24 10:24:57 crusoe kernel: usb-storage: Had to truncate MODE_SENSE_10 buffer into MODE_SENSE.
Apr 24 10:24:57 crusoe kernel: usb-storage: outputBufferSize is 74 and length is 8.
Apr 24 10:24:57 crusoe kernel: sdb: Mode Sense: 46 94 00 00
Apr 24 10:24:57 crusoe kernel: sdb: assuming drive cache: write through
Apr 24 10:24:58 crusoe /sbin/hotplug: no runnable /etc/hotplug/block.agent is installed
Apr 24 10:24:58 crusoe kernel:  sdb: sdb1 sdb2 sdb4
Apr 24 10:24:58 crusoe /sbin/hotplug: no runnable /etc/hotplug/block.agent is installed

-- 
Stelian Pop <stelian@popies.net>
