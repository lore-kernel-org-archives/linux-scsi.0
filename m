From: Darsen <darsen@micro.ee.nthu.edu.tw>
Subject: Re: Handling erroneous READ CAPACITY response in sd.c
Date: Tue, 26 Oct 2004 05:54:31 +0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <417D7617.3030005@micro.ee.nthu.edu.tw>
References: <Pine.LNX.4.44L0.0410241306060.26683-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from msr52.hinet.net ([168.95.4.152]:39908 "EHLO msr52.hinet.net")
	by vger.kernel.org with ESMTP id S261267AbUJYV7E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Oct 2004 17:59:04 -0400
In-Reply-To: <Pine.LNX.4.44L0.0410241306060.26683-100000@netrider.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Adriaan Penning <a.penning@luon.net>, Eero Volotinen <eero@ping-viini.org>, Luben Tuikov <luben_tuikov@adaptec.com>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern wrote:

>>(I eliminated the usb-storage verbose debug messages because it was too 
>>long, if you need them I can send it to you.)
>>    
>>
>
>Yes, please.  Maybe it contains something useful.  Like why your device 
>crashed when it used to work okay.
>  
>

Here it is,

---------------------------------------------------------
parport: PnPBIOS parport detected.
parport0: PC-style at 0x378, irq 7 [PCSPP,EPP]
lp0: using parport0 (interrupt-driven).
lp0: console ready
mtrr: 0xe8000000,0x4000000 overlaps existing 0xe8000000,0x100000
atkbd.c: Spurious ACK on isa0060/serio0. Some program, like XFree86, 
might be trying access hardware directly.
atkbd.c: Spurious ACK on isa0060/serio0. Some program, like XFree86, 
might be trying access hardware directly.
SCSI subsystem initialized
st: Version 20040403, fixed bufsize 32768, s/g segs 256
ohci_hcd 0000:00:06.0: wakeup
usb 2-2: new full speed USB device using address 2
Initializing USB Mass Storage driver...
usb-storage: USB Mass Storage device detected
usb-storage: altsetting is 0, id_index is 111
usb-storage: -- associate_dev
usb-storage: Transport: Bulk
usb-storage: Protocol: Transparent SCSI
usb-storage: Endpoints: In: 0xbd18c9f4 Out: 0xbd18c9e0 Int: 0x00000000 
(Period 0)
usb-storage: usb_stor_control_msg: rq=fe rqtype=a1 value=0000 index=00 len=1
usb-storage: GetMaxLUN command result is 1, data is 0
usb-storage: *** thread sleeping.
scsi0 : SCSI emulation for USB Mass Storage devices
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command INQUIRY (6 bytes)
usb-storage:  12 00 00 00 24 00
usb-storage: Bulk Command S 0x43425355 T 0x1 L 36 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_buf: xfer 36 bytes
usb-storage: Status code 0; transferred 36/36
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x1 R 0 Stat 0x0
usb-storage: Fixing INQUIRY data to show SCSI rev 2 - was 4
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
  Vendor: SigmaTel  Model: MSCN              Rev: 0001
  Type:   Direct-Access                      ANSI SCSI revision: 02
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
usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
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
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command READ_CAPACITY (10 bytes)
usb-storage:  25 00 00 03 d7 ff 00 00 01 00
usb-storage: Bulk Command S 0x43425355 T 0x4 L 8 F 128 Trg 0 LUN 0 CL 10
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
usb-storage: command_abort called
usb-storage: usb_stor_stop_transport called
usb-storage: -- cancelling URB
usb-storage: Status code -104; transferred 0/8
usb-storage: -- transfer cancelled
usb-storage: Bulk data transfer result 0x4
usb-storage: -- command was aborted
usb-storage: usb_stor_Bulk_reset called
usb-storage: usb_stor_control_msg: rq=ff rqtype=21 value=0000 index=00 len=0
usb-storage: Timeout -- cancelling URB
usb-storage: Soft reset failed: -104
usb-storage: scsi command aborted
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: command_abort called
usb-storage: usb_stor_stop_transport called
usb-storage: -- cancelling URB
usb-storage: Status code -104; transferred 0/31
usb-storage: -- transfer cancelled
usb-storage: Bulk command transfer result=4
usb-storage: -- command was aborted
usb-storage: usb_stor_Bulk_reset called
usb-storage: usb_stor_control_msg: rq=ff rqtype=21 value=0000 index=00 len=0
usb-storage: Soft reset failed: -110
usb-storage: scsi command aborted
usb-storage: *** thread sleeping.
usb-storage: device_reset called
usb-storage: usb_stor_Bulk_reset called
usb-storage: usb_stor_control_msg: rq=ff rqtype=21 value=0000 index=00 len=0
usb-storage: Soft reset failed: -110
usb-storage: bus_reset called
usb 2-2: reset full speed USB device using address 2
usb 2-2: device not accepting address 2, error -110
usb-storage: usb_reset_device returns -19
scsi: Device offlined - not ready after error recovery: host 0 channel 0 
id 0 lun 0
sd_read_true_cap: sda: PMI not supported
scsi0 (0:0): rejecting I/O to offline device
sd_read_format_cap: sda: READ FORMAT CAPACITIES not supported
SCSI device sda: 251905 512-byte hdwr sectors (129 MB)
sda: assuming Write Enabled
sda: assuming drive cache: write through
Attached scsi removable disk sda at scsi0, channel 0, id 0, lun 0
Attached scsi generic sg0 at scsi0, channel 0, id 0, lun 0,  type 0
usb-storage: queuecommand called
usb 2-2: USB disconnect, address 2
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
USB Mass Storage device found at 2
usbcore: registered new driver usb-storage
USB Mass Storage support registered.
usb-storage: storage_disconnect() called
usb-storage: usb_stor_stop_transport called
usb-storage: -- usb_stor_release_resources
usb-storage: -- sending exit command to thread
usb-storage: *** thread awakened.
usb-storage: -- exit command received
usb-storage: -- dissociate_dev
usb 2-2: new full speed USB device using address 3
usb 2-2: device not accepting address 3, error -110
usb 2-2: new full speed USB device using address 4
usb 2-2: device not accepting address 4, error -110

