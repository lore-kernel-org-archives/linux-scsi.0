From: Sven Neuhaus <sven@ping.de>
Subject: SMSC USB 2.0 8-in-1 card reader requires max_luns=6 option
Date: Sun, 6 Jun 2004 18:54:21 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040606165421.GA819@ping.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lilly.ping.de ([83.97.42.2]:65289 "HELO lilly.ping.de")
	by vger.kernel.org with SMTP id S263810AbUFFQy0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Jun 2004 12:54:26 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Sven Neuhaus <sven@ping.de>

Hello,

my USB 2.0 8-in-1 card reader requires the parameter
max_luns=6 in order to show all devices with kernel 2.6.
Please add it to the list of devices to probe all luns.
Here's the dmesg output:

============================8<=====================================
SCSI subsystem initialized
usb 3-6: new high speed USB device using address 7
Initializing USB Mass Storage driver...
scsi0 : SCSI emulation for USB Mass Storage devices
  Vendor: SMSC      Model: 223 U HS-CF       Rev: 1.95
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: SMSC      Model: 223 U HS-MS       Rev: 1.95
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: SMSC      Model: 223 U HS-SM       Rev: 1.95
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: SMSC      Model: 223 U HS-SD/MMC   Rev: 1.95
  Type:   Direct-Access                      ANSI SCSI revision: 02
Attached scsi removable disk sda at scsi0, channel 0, id 0, lun 0
Attached scsi removable disk sdb at scsi0, channel 0, id 0, lun 1
Attached scsi removable disk sdc at scsi0, channel 0, id 0, lun 2
SCSI device sdd: 250880 512-byte hdwr sectors (128 MB)
sdd: assuming Write Enabled
sdd: assuming drive cache: write through
 sdd: sdd1
Attached scsi removable disk sdd at scsi0, channel 0, id 0, lun 3
USB Mass Storage device found at 7
usbcore: registered new driver usb-storage
USB Mass Storage support registered.
Device not ready.  Make sure there is a disc in the drive.
Device not ready.  Make sure there is a disc in the drive.
Device not ready.  Make sure there is a disc in the drive.
Device not ready.  Make sure there is a disc in the drive.
Device not ready.  Make sure there is a disc in the drive.
Device not ready.  Make sure there is a disc in the drive.
============================8<=====================================

Here's the "lsusb" output:

============================8<=====================================
Bus 003 Device 007: ID 0424:223a Standard Microsystems Corp. 
Bus 003 Device 001: ID 0000:0000  
Bus 002 Device 002: ID 046d:c00e Logitech, Inc. Optical Mouse
Bus 002 Device 001: ID 0000:0000  
Bus 001 Device 002: ID 0731:0528 Susteen, Inc. 
Bus 001 Device 001: ID 0000:0000  
============================8<=====================================

Here's /proc/scsi/usb-storage/0:

============================8<=====================================
   Host scsi0: usb-storage
       Vendor: SMSC
      Product: 223 USB97C223
Serial Number: 031017200000
     Protocol: Transparent SCSI
    Transport: Bulk
       Quirks:
============================8<=====================================

If you need anything else, let me know.

Thanks,
-Sven Neuhaus
-- 
index, n.:
	Alphabetical list of words of no possible interest where an
	alphabetical list of subjects with references ought to be.
