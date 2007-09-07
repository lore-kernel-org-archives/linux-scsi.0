From: Peter Rasmussen <plr@udgaard.com>
Subject: Re: usb-storage and Motorola Z6
Date: Fri, 07 Sep 2007 21:15:36 +0200
Message-ID: <46E1A358.7030707@udgaard.com>
References: <Pine.LNX.4.44L0.0709011120340.6825-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-users-bounces@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.44L0.0709011120340.6825-100000@netrider.rowland.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-users>,
	<mailto:linux-usb-users-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-usb-users>
List-Post: <mailto:linux-usb-users@lists.sourceforge.net>
List-Help: <mailto:linux-usb-users-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-users>,
	<mailto:linux-usb-users-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-users-bounces@lists.sourceforge.net
Errors-To: linux-usb-users-bounces@lists.sourceforge.net
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, USB users list <linux-usb-users@lists.sourceforge.net>
List-Id: linux-scsi@vger.kernel.org

I'm sorry if this is a little late, but I had once had access to a Z6 
and believe I had it successfully connected to my Linux host, and was 
therefore puzzled by this message exchange.

I have now borrowed the device again for the weekend to check it out a 
little more.

Using Alan's patch below, otherwise my kernel is a standard 2.6.23-rc5 
(CONFIG_USB_STORAGE_DEBUG=y ) I got the following result after reboot 
and connecting the Z6.:

ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0002
ohci_hcd 0000:00:02.0: GetStatus roothub.portstatus [0] = 0x00010101 CSC 
PPS CCS
hub 1-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
hub 1-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
ohci_hcd 0000:00:02.0: GetStatus roothub.portstatus [0] = 0x00100103 
PRSC PPS PES CCS
usb 1-1: new full speed USB device using ohci_hcd and address 2
ohci_hcd 0000:00:02.0: GetStatus roothub.portstatus [0] = 0x00100103 
PRSC PPS PES CCS
usb 1-1: default language 0x0409
usb 1-1: new device strings: Mfr=3, Product=2, SerialNumber=4
usb 1-1: Product: MS
usb 1-1: Manufacturer: Motorola Inc.
usb 1-1: SerialNumber: 9013555524BA0C2005
usb 1-1: uevent
usb 1-1: usb_probe_device
usb 1-1: configuration #1 chosen from 1 choice
usb 1-1: adding 1-1:1.0 (config #1, interface 0)
usb 1-1:1.0: uevent
usb 1-1:1.0: uevent
usb-storage 1-1:1.0: usb_probe_interface
usb-storage 1-1:1.0: usb_probe_interface - got id
usb-storage: USB Mass Storage device detected
usb-storage: -- associate_dev
usb-storage: Vendor: 0x22b8, Product: 0x6426, Revision: 0x0101
usb-storage: Interface Subclass: 0x06, Protocol: 0x50
usb-storage: Transport: Bulk
usb-storage: Protocol: Transparent SCSI
scsi0 : SCSI emulation for USB Mass Storage devices
usb-storage: *** thread sleeping.
usb-storage: device found at 2
usb-storage: waiting for device to settle before scanning
drivers/usb/core/inode.c: creating file '002'
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0002
usb-storage: usb_stor_control_msg: rq=fe rqtype=a1 value=0000 index=00 len=1
usb-storage: GetMaxLUN command result is 1, data is 1
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command INQUIRY (6 bytes)
usb-storage:  12 00 00 00 24 00
usb-storage: Bulk Command S 0x43425355 T 0x1 L 36 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 36 bytes, 1 entries
usb-storage: Status code 0; transferred 36/36
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x1 R 0 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
scsi 0:0:0:0: Direct-Access     Motorola MSnc.                 PQ: 1 
ANSI: 0 CCS
scsi 0:0:0:0: Attached scsi generic sg0 type 0
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command INQUIRY (6 bytes)
usb-storage:  12 00 00 00 24 00
usb-storage: Bulk Command S 0x43425355 T 0x2 L 36 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 36 bytes, 1 entries
usb-storage: Status code 0; transferred 36/36
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x2 R 0 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
scsi 0:0:0:1: Direct-Access     Motorola MSnc.                 PQ: 1 
ANSI: 0 CCS
scsi 0:0:0:1: Attached scsi generic sg1 type 0
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Bad LUN (0:2)
usb-storage: scsi cmd done, result=0x40000
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Bad target number (1:0)
usb-storage: scsi cmd done, result=0x40000
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Bad target number (2:0)
usb-storage: scsi cmd done, result=0x40000
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Bad target number (3:0)
usb-storage: scsi cmd done, result=0x40000
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Bad target number (4:0)
usb-storage: scsi cmd done, result=0x40000
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Bad target number (5:0)
usb-storage: scsi cmd done, result=0x40000
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Bad target number (6:0)
usb-storage: scsi cmd done, result=0x40000
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Bad target number (7:0)
usb-storage: scsi cmd done, result=0x40000
usb-storage: *** thread sleeping.
usb-storage: device scan complete

What I can't understand, however, is that as this mobile phone 
supposedly runs Linux. I can't see how Motorola could break it so badly 
that the USB connection now doesn't work with a PC running Linux?

And you say that this seems to be a more widespread problem with 
Motorola devices? Do you remember which ones, and do they run Linux as well?

The following is from connecting a Z3 that supposedly isn't based on 
Linux, but works all right (and this may have been the one I thought was 
the Z6 that I claimed worked):

ohci_hcd 0000:00:02.0: auto-wakeup root hub
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0002
ohci_hcd 0000:00:02.0: GetStatus roothub.portstatus [0] = 0x00010101 CSC 
PPS CCS
hub 1-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
hub 1-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
ohci_hcd 0000:00:02.0: GetStatus roothub.portstatus [0] = 0x00100103 
PRSC PPS PES CCS
usb 1-1: new full speed USB device using ohci_hcd and address 5
ohci_hcd 0000:00:02.0: GetStatus roothub.portstatus [0] = 0x00100103 
PRSC PPS PES CCS
usb 1-1: ep0 maxpacket = 8
usb 1-1: default language 0x0409
usb 1-1: new device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-1: Product: Motorola Phone (Z3)
usb 1-1: Manufacturer: Motorola Inc.
usb 1-1: SerialNumber: 00440102299883
usb 1-1: uevent
usb 1-1: usb_probe_device
usb 1-1: configuration #1 chosen from 1 choice
usb 1-1: adding 1-1:1.0 (config #1, interface 0)
usb 1-1:1.0: uevent
usb 1-1:1.0: uevent
usb-storage 1-1:1.0: usb_probe_interface
usb-storage 1-1:1.0: usb_probe_interface - got id
usb-storage: USB Mass Storage device detected
usb-storage: -- associate_dev
usb-storage: Vendor: 0x22b8, Product: 0x4810, Revision: 0x0002
usb-storage: Interface Subclass: 0x06, Protocol: 0x50
usb-storage: Transport: Bulk
usb-storage: Protocol: Transparent SCSI
scsi3 : SCSI emulation for USB Mass Storage devices
usb-storage: *** thread sleeping.
usb-storage: device found at 5
usb-storage: waiting for device to settle before scanning
drivers/usb/core/inode.c: creating file '005'
hub 1-0:1.0: state 7 ports 3 chg 0000 evt 0002
usb-storage: usb_stor_control_msg: rq=fe rqtype=a1 value=0000 index=00 len=1
usb-storage: GetMaxLUN command result is 1, data is 0
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command INQUIRY (6 bytes)
usb-storage:  12 00 00 00 24 00
usb-storage: Bulk Command S 0x43425355 T 0x1 L 36 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 36 bytes, 1 entries
usb-storage: Status code 0; transferred 36/36
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x1 R 0 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
scsi 3:0:0:0: Direct-Access     Motorola Z3               2.31 PQ: 0 ANSI: 2
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x2 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x2 R 0 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command READ_CAPACITY (10 bytes)
usb-storage:  25 00 00 00 00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x3 L 8 F 128 Trg 0 LUN 0 CL 10
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 8 bytes, 1 entries
usb-storage: Status code 0; transferred 8/8
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x3 R 0 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
sd 3:0:0:0: [sda] 494081 512-byte hardware sectors (253 MB)
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command MODE_SENSE (6 bytes)
usb-storage:  1a 00 3f 00 c0 00
usb-storage: Bulk Command S 0x43425355 T 0x4 L 192 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 192 bytes, 1 entries
ohci_hcd 0000:00:02.0: urb c360bf00 path 1 ep2in 93120000 cc 9 --> 
status -121
usb-storage: Status code -121; transferred 12/192
usb-storage: -- short read transfer
usb-storage: Bulk data transfer result 0x1
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4 R 180 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
sd 3:0:0:0: [sda] Write Protect is off
sd 3:0:0:0: [sda] Mode Sense: 0b 00 00 08
sd 3:0:0:0: [sda] Assuming drive cache: write through
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x5 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x5 R 0 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command ALLOW_MEDIUM_REMOVAL (6 bytes)
usb-storage:  1e 00 00 00 01 00
usb-storage: Bulk Command S 0x43425355 T 0x6 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x6 R 0 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x7 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x7 R 0 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command READ_CAPACITY (10 bytes)
usb-storage:  25 00 00 00 00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x8 L 8 F 128 Trg 0 LUN 0 CL 10
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 8 bytes, 1 entries
usb-storage: Status code 0; transferred 8/8
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x8 R 0 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
sd 3:0:0:0: [sda] 494081 512-byte hardware sectors (253 MB)
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command MODE_SENSE (6 bytes)
usb-storage:  1a 00 3f 00 c0 00
usb-storage: Bulk Command S 0x43425355 T 0x9 L 192 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 192 bytes, 1 entries
ohci_hcd 0000:00:02.0: urb c360bf00 path 1 ep2in 92120000 cc 9 --> 
status -121
usb-storage: Status code -121; transferred 12/192
usb-storage: -- short read transfer
usb-storage: Bulk data transfer result 0x1
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x9 R 180 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
sd 3:0:0:0: [sda] Write Protect is off
sd 3:0:0:0: [sda] Mode Sense: 0b 00 00 08
sd 3:0:0:0: [sda] Assuming drive cache: write through
 sda:<7>usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command READ_10 (10 bytes)
usb-storage:  28 00 00 00 00 00 00 00 08 00
usb-storage: Bulk Command S 0x43425355 T 0xa L 4096 F 128 Trg 0 LUN 0 CL 10
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 4096 bytes, 1 entries
usb-storage: Status code 0; transferred 4096/4096
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0xa R 0 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
 sda1
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command ALLOW_MEDIUM_REMOVAL (6 bytes)
usb-storage:  1e 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0xb L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0xb R 0 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
sd 3:0:0:0: [sda] Attached SCSI removable disk
sd 3:0:0:0: Attached scsi generic sg0 type 0
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Bad LUN (0:1)
usb-storage: scsi cmd done, result=0x40000
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Bad target number (1:0)
usb-storage: scsi cmd done, result=0x40000
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Bad target number (2:0)
usb-storage: scsi cmd done, result=0x40000
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Bad target number (3:0)
usb-storage: scsi cmd done, result=0x40000
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Bad target number (4:0)
usb-storage: scsi cmd done, result=0x40000
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Bad target number (5:0)
usb-storage: scsi cmd done, result=0x40000
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Bad target number (6:0)
usb-storage: scsi cmd done, result=0x40000
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Bad target number (7:0)
usb-storage: scsi cmd done, result=0x40000
usb-storage: *** thread sleeping.
usb-storage: device scan complete

I hope perhaps it can provide some comparison info now with a device 
that works and one that doesn't.

If Motorola actualy has made changes to the Linux kernel they use with 
the Z6, I suppose we should be able to get the actual code. Should I 
investigate that?

Peter

Alan Stern wrote:
> On Sat, 1 Sep 2007, Andreas Koenecke wrote:
>
>   
>> I' done this, too.
>> The non-debug-messages are now:
>> ----------------------------------------------------------------------------
>> Sep  1 13:09:17 kocom kernel: usb 3-1: new high speed USB device using ehci_hcd and address 12
>> Sep  1 13:09:17 kocom kernel: usb 3-1: configuration #1 chosen from 1 choice
>> Sep  1 13:09:17 kocom kernel: Initializing USB Mass Storage driver...
>> Sep  1 13:09:17 kocom kernel: scsi7 : SCSI emulation for USB Mass Storage devices
>> Sep  1 13:09:17 kocom kernel: usb-storage: device found at 12
>> Sep  1 13:09:17 kocom kernel: usb-storage: waiting for device to settle before scanning
>> Sep  1 13:09:17 kocom kernel: usbcore: registered new interface driver usb-storage
>> Sep  1 13:09:17 kocom kernel: USB Mass Storage support registered.
>> Sep  1 13:09:22 kocom kernel: usb-storage: device scan complete
>> Sep  1 13:09:22 kocom kernel: scsi 7:0:0:0: Direct-Access     Motorola MSnc.                 PQ: 1 ANSI: 0 CCS
>> Sep  1 13:09:22 kocom kernel: scsi 7:0:0:1: Direct-Access     Motorola MSnc.                 PQ: 1 ANSI: 0 CCS
>> Sep  1 13:09:22 kocom kernel: sd 7:0:0:0: [sdb] Attached SCSI removable disk
>> Sep  1 13:09:22 kocom kernel: sd 7:0:0:0: Attached scsi generic sg2 type 0
>> Sep  1 13:09:22 kocom kernel: sd 7:0:0:1: [sdc] Attached SCSI removable disk
>> Sep  1 13:09:22 kocom kernel: sd 7:0:0:1: Attached scsi generic sg3 type 0
>> Sep  1 13:09:28 kocom kernel: sd 7:0:0:0: [sdb] 1983495 512-byte hardware sectors (1016 MB)
>> Sep  1 13:09:28 kocom kernel: sd 7:0:0:0: [sdb] Write Protect is off
>> Sep  1 13:09:28 kocom kernel: sd 7:0:0:0: [sdb] Mode Sense: 03 00 00 00
>> Sep  1 13:09:28 kocom kernel: sd 7:0:0:0: [sdb] Assuming drive cache: write through
>> Sep  1 13:09:28 kocom kernel: sd 7:0:0:0: [sdb] 1983495 512-byte hardware sectors (1016 MB)
>> Sep  1 13:09:28 kocom kernel: sd 7:0:0:0: [sdb] Write Protect is off
>> Sep  1 13:09:28 kocom kernel: sd 7:0:0:0: [sdb] Mode Sense: 03 00 00 00
>> Sep  1 13:09:28 kocom kernel: sd 7:0:0:0: [sdb] Assuming drive cache: write through
>> Sep  1 13:09:28 kocom kernel:  sdb:
>> Sep  1 13:09:28 kocom kernel: sd 7:0:0:1: [sdc] 128673 512-byte hardware sectors (66 MB)
>> Sep  1 13:09:28 kocom kernel: sd 7:0:0:1: [sdc] Write Protect is off
>> Sep  1 13:09:28 kocom kernel: sd 7:0:0:1: [sdc] Mode Sense: 03 00 00 00
>> Sep  1 13:09:28 kocom kernel: sd 7:0:0:1: [sdc] Assuming drive cache: write through
>> Sep  1 13:09:28 kocom kernel: sd 7:0:0:1: [sdc] 128673 512-byte hardware sectors (66 MB)
>> Sep  1 13:09:28 kocom kernel: sd 7:0:0:1: [sdc] Write Protect is off
>> Sep  1 13:09:28 kocom kernel: sd 7:0:0:1: [sdc] Mode Sense: 03 00 00 00
>> Sep  1 13:09:28 kocom kernel: sd 7:0:0:1: [sdc] Assuming drive cache: write through
>> Sep  1 13:09:28 kocom kernel:  sdc:
>> Sep  1 13:09:59 kocom kernel: usb 3-1: reset high speed USB device using ehci_hcd and address 12
>> Sep  1 13:10:14 kocom kernel: usb 3-1: device descriptor read/64, error -110
>> Sep  1 13:10:29 kocom kernel: usb 3-1: device descriptor read/64, error -110
>> Sep  1 13:10:29 kocom kernel: usb 3-1: reset high speed USB device using ehci_hcd and address 12
>> Sep  1 13:10:44 kocom kernel: usb 3-1: device descriptor read/64, error -110
>> Sep  1 13:11:00 kocom kernel: usb 3-1: device descriptor read/64, error -110
>> Sep  1 13:11:00 kocom kernel: usb 3-1: reset high speed USB device using ehci_hcd and address 12
>> Sep  1 13:11:05 kocom kernel: usb 3-1: device descriptor read/8, error -110
>> ------------------------------------------------------------------------------------------------
>>
>> sdb and sdc appear in /proc/partitions, but trying to access with 'fdisk -l` or
>> 'mount' freezes the phone.
>>
>> I uploaded the debug-log to:
>> <http://www.akoenecke.de/moto/usb_debug2.txt>
>>
>> The debug-log included 2 spontaneous reboots and 1 freeze (in this order) of
>> the phone without unplugging.
>>     
>
> The resets and disconnects occurred because of yet another bug in the 
> phone.  It reports that sdc has 128673 sectors, but in fact it probably 
> has only 128672.  The error occurred when the computer tried to read 
> the (non-existent) last sector.  The phone failed to follow the proper 
> protocol for reporting an error, so the computer reset it.
>
> It's not surprising; other devicees from Motorola have the same bug.  
> The patch below ought to help.  However considering the number of other 
> bugs and problems in this device, it's not clear how far you should try 
> to push it...
>
> Alan Stern
>
>
> Index: usb-2.6/drivers/usb/storage/unusual_devs.h
> ===================================================================
> --- usb-2.6.orig/drivers/usb/storage/unusual_devs.h
> +++ usb-2.6/drivers/usb/storage/unusual_devs.h
> @@ -1481,6 +1481,13 @@ UNUSUAL_DEV(  0x22b8, 0x4810, 0x0001, 0x
>  		US_SC_DEVICE, US_PR_DEVICE, NULL,
>  		US_FL_FIX_CAPACITY),
>  
> +/* Reported by Andreas Koenecke <akoenecke@akoenecke.de> */
> +UNUSUAL_DEV(  0x22b8, 0x6426, 0x0101, 0x0101,
> +		"Motorola",
> +		"MSnc Z6",
> +		US_SC_DEVICE, US_PR_DEVICE, NULL,
> +		US_FL_FIX_CAPACITY),
> +
>  /* Reported by Radovan Garabik <garabik@kassiopeia.juls.savba.sk> */
>  UNUSUAL_DEV(  0x2735, 0x100b, 0x0000, 0x9999,
>  		"MPIO",
>
>
> -------------------------------------------------------------------------
> This SF.net email is sponsored by: Splunk Inc.
> Still grepping through log files to find problems?  Stop.
> Now Search log events and configuration files using AJAX and a browser.
> Download your FREE copy of Splunk now >>  http://get.splunk.com/
> _______________________________________________
> Linux-usb-users@lists.sourceforge.net
> To unsubscribe, use the last form field at:
> https://lists.sourceforge.net/lists/listinfo/linux-usb-users
>   

-------------------------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc.
Still grepping through log files to find problems?  Stop.
Now Search log events and configuration files using AJAX and a browser.
Download your FREE copy of Splunk now >>  http://get.splunk.com/
_______________________________________________
Linux-usb-users@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-users
