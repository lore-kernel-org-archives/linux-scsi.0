From: Mattia <mattia@p2pforum.it>
Subject: scsi cd bug?
Date: Sun, 1 Mar 2009 16:22:47 +0100
Message-ID: <f5137ef20903010722o6cef0972w29bbc3bf18f4d1c9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f176.google.com ([209.85.220.176]:46366 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613AbZCAPWv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Mar 2009 10:22:51 -0500
Received: by fxm24 with SMTP id 24so1666489fxm.37
        for <linux-scsi@vger.kernel.org>; Sun, 01 Mar 2009 07:22:48 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all,
since the release of Linux 2.6.25, my USB DVD writer does not work anymore.

With kernel 2.6.24 or previous, when I turn on the device and start
k3b, the dmesg says:

usb 5-2: new high speed USB device using ehci_hcd and address 3
usb 5-2: configuration #1 chosen from 1 choice
Initializing USB Mass Storage driver...
scsi2 : SCSI emulation for USB Mass Storage devices
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usb-storage: device found at 3
usb-storage: waiting for device to settle before scanning
usb-storage: device scan complete
scsi 2:0:0:0: CD-ROM            TSSTcorp CD/DVDW TS-H552U US07 PQ: 0 ANSI: 0
Driver 'sr' needs updating - please use bus_type methods
sr0: scsi3-mmc drive: 7x/48x writer cd/rw xa/form2 cdda tray
sr 2:0:0:0: Attached scsi CD-ROM sr0
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 1:0:0:0: Attached scsi generic sg1 type 0
sr 2:0:0:0: Attached scsi generic sg2 type 5
end_request: I/O error, dev sr0, sector 0
Buffer I/O error on device sr0, logical block 0
end_request: I/O error, dev sr0, sector 0
Buffer I/O error on device sr0, logical block 0
cdrom: This disc doesn't have any tracks I recognize!
usb 5-2: reset high speed USB device using ehci_hcd and address 3
usb 5-2: reset high speed USB device using ehci_hcd and address 3
usb 5-2: reset high speed USB device using ehci_hcd and address 3
usb 5-2: reset high speed USB device using ehci_hcd and address 3

But the empty dvd-r medium is correctly recognised and I can burn it.

With kernel 2.6.25 or above:

[   95.176013] usb 5-2: new high speed USB device using ehci_hcd and address 4
[   95.308002] usb 5-2: configuration #1 chosen from 1 choice
[   95.308002] scsi3 : SCSI emulation for USB Mass Storage devices
[   95.308002] usb 5-2: New USB device found, idVendor=0409, idProduct=0056
[   95.308002] usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   95.308002] usb 5-2: Product: USB 2.0 IDE Bridge
[   95.308002] usb 5-2: Manufacturer: NEC Electronics
[   95.308002] usb 5-2: SerialNumber: 3669000295
[   95.308002] usb-storage: device found at 4
[   95.308002] usb-storage: waiting for device to settle before scanning
[  100.308195] usb-storage: device scan complete
[  100.313676] scsi 3:0:0:0: CD-ROM            TSSTcorp CD/DVDW
TS-H552U US07 PQ: 0 ANSI: 0
[  100.592003] sr0: scsi3-mmc drive: 7x/48x writer cd/rw xa/form2 cdda tray
[  100.592003] sr 3:0:0:0: Attached scsi CD-ROM sr0
[  100.592003] sr 3:0:0:0: Attached scsi generic sg2 type 5
[  114.789037] cdrom: This disc doesn't have any tracks I recognize!
[  132.320028] usb 5-2: reset high speed USB device using ehci_hcd and address 4
[  152.044009] cdrom: This disc doesn't have any tracks I recognize!
[  159.400037] usb 5-2: reset high speed USB device using ehci_hcd and address 4
[  178.993227] cdrom: This disc doesn't have any tracks I recognize!
[  186.144037] usb 5-2: reset high speed USB device using ehci_hcd and address 4
[  204.808030] cdrom: This disc doesn't have any tracks I recognize!
[  212.212035] usb 5-2: reset high speed USB device using ehci_hcd and address 4

It continues to give these usb reset messages, so i can't burn the dvd.
This appens with all version of k3b I could try and with wodim via
command-line too.
I asked for help on the debian mailing-list with no luck.
I hope you can help me.

Mattia
