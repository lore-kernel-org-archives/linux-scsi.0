From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [usb-storage] Re: Time to conclude the Sony USB mass storage thread
Date: Fri, 14 Nov 2003 18:13:12 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031114181312.A1790@beaverton.ibm.com>
References: <20031114125648.A5811@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:16621 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261267AbTKOCN1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Nov 2003 21:13:27 -0500
Content-Disposition: inline
In-Reply-To: <20031114125648.A5811@beaverton.ibm.com>; from patmans@us.ibm.com on Fri, Nov 14, 2003 at 12:56:48PM -0800
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, mdharm-scsi@one-eyed-alien.net, usb-storage@one-eyed-alien.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

I went ahead and tested the patch with a Sony / Sony DSC on my laptop with
no problems.

James, Matthew, etc. - are you OK with the patch?

Here's usb storage debug output on attach of the device, note the lack of
any MODE SENSE:

Nov 14 18:01:47 laptop patman: NOTE attaching NOTE
Nov 14 18:01:56 laptop kernel: usb-storage: USB Mass Storage device detected
Nov 14 18:01:56 laptop kernel: usb-storage: act_altsetting is 0, id_index is 25
Nov 14 18:01:56 laptop kernel: usb-storage: -- associate_dev
Nov 14 18:01:56 laptop kernel: usb-storage: Vendor: Sony
Nov 14 18:01:56 laptop kernel: usb-storage: Product: DSC-S30/S70/S75/505V/F505/F707/F717/P8
Nov 14 18:01:56 laptop kernel: usb-storage: Transport: Control/Bulk
Nov 14 18:01:56 laptop kernel: usb-storage: Protocol: Transparent SCSI
Nov 14 18:01:56 laptop kernel: usb-storage: Endpoints: In: 0xca8bb280 Out: 0xca8bb294 Int: 0xca8bb2a8 (Period 255)
Nov 14 18:01:56 laptop kernel: usb-storage: *** thread sleeping.
Nov 14 18:01:56 laptop kernel: usb-storage: queuecommand called
Nov 14 18:01:56 laptop kernel: usb-storage: *** thread awakened.
Nov 14 18:01:56 laptop kernel: usb-storage: Command INQUIRY (6 bytes)
Nov 14 18:01:56 laptop kernel: usb-storage:  12 00 00 00 24 00
Nov 14 18:01:56 laptop kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Nov 14 18:01:56 laptop kernel: usb-storage: Status code 0; transferred 6/6
Nov 14 18:01:56 laptop kernel: usb-storage: -- transfer complete
Nov 14 18:01:56 laptop kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Nov 14 18:01:56 laptop kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 36 bytes
Nov 14 18:01:56 laptop kernel: usb-storage: Status code 0; transferred 36/36
Nov 14 18:01:56 laptop kernel: usb-storage: -- transfer complete
Nov 14 18:01:56 laptop kernel: usb-storage: CB data stage result is 0x0
Nov 14 18:01:56 laptop kernel: usb-storage: -- CB transport device requiring auto-sense
Nov 14 18:01:56 laptop kernel: usb-storage: Issuing auto-REQUEST_SENSE
Nov 14 18:01:56 laptop kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Nov 14 18:01:56 laptop kernel: usb-storage: Status code 0; transferred 6/6
Nov 14 18:01:56 laptop kernel: usb-storage: -- transfer complete
Nov 14 18:01:56 laptop kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Nov 14 18:01:56 laptop kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Nov 14 18:01:56 laptop kernel: usb-storage: Status code 0; transferred 18/18
Nov 14 18:01:56 laptop kernel: usb-storage: -- transfer complete
Nov 14 18:01:56 laptop kernel: usb-storage: CB data stage result is 0x0
Nov 14 18:01:56 laptop kernel: usb-storage: -- Result from auto-sense is 0
Nov 14 18:01:56 laptop kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Nov 14 18:01:56 laptop kernel: usb-storage: No Sense: No additional sense information
Nov 14 18:01:56 laptop kernel: usb-storage: Fixing INQUIRY data to show SCSI rev 2 - was 0
Nov 14 18:01:56 laptop kernel: usb-storage: scsi cmd done, result=0x0
Nov 14 18:01:56 laptop kernel: usb-storage: *** thread sleeping.
Nov 14 18:01:56 laptop kernel: usb-storage: queuecommand called
Nov 14 18:01:56 laptop kernel: usb-storage: *** thread awakened.
Nov 14 18:01:56 laptop kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
Nov 14 18:01:56 laptop kernel: usb-storage:  00 00 00 00 00 00
Nov 14 18:01:56 laptop kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Nov 14 18:01:56 laptop kernel: usb-storage: Status code 0; transferred 6/6
Nov 14 18:01:56 laptop kernel: usb-storage: -- transfer complete
Nov 14 18:01:56 laptop kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Nov 14 18:01:56 laptop kernel: usb-storage: -- CB transport device requiring auto-sense
Nov 14 18:01:56 laptop kernel: usb-storage: Issuing auto-REQUEST_SENSE
Nov 14 18:01:56 laptop kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Nov 14 18:01:56 laptop kernel: usb-storage: Status code 0; transferred 6/6
Nov 14 18:01:56 laptop kernel: usb-storage: -- transfer complete
Nov 14 18:01:56 laptop kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Nov 14 18:01:56 laptop kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Nov 14 18:01:56 laptop kernel: usb-storage: Status code 0; transferred 18/18
Nov 14 18:01:56 laptop kernel: usb-storage: -- transfer complete
Nov 14 18:01:56 laptop kernel: usb-storage: CB data stage result is 0x0
Nov 14 18:01:56 laptop kernel: usb-storage: -- Result from auto-sense is 0
Nov 14 18:01:56 laptop kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Nov 14 18:01:56 laptop kernel: usb-storage: No Sense: No additional sense information
Nov 14 18:01:56 laptop kernel: usb-storage: scsi cmd done, result=0x0
Nov 14 18:01:56 laptop kernel: usb-storage: *** thread sleeping.
Nov 14 18:01:56 laptop kernel: usb-storage: queuecommand called
Nov 14 18:01:56 laptop kernel: usb-storage: *** thread awakened.
Nov 14 18:01:56 laptop kernel: usb-storage: Command READ_CAPACITY (10 bytes)
Nov 14 18:01:56 laptop kernel: usb-storage:  25 00 00 00 00 00 00 00 00 00
Nov 14 18:01:56 laptop kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Nov 14 18:01:56 laptop kernel: usb-storage: Status code 0; transferred 10/10
Nov 14 18:01:56 laptop kernel: usb-storage: -- transfer complete
Nov 14 18:01:56 laptop kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Nov 14 18:01:56 laptop kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 8 bytes
Nov 14 18:01:56 laptop kernel: usb-storage: Status code 0; transferred 8/8
Nov 14 18:01:56 laptop kernel: usb-storage: -- transfer complete
Nov 14 18:01:56 laptop kernel: usb-storage: CB data stage result is 0x0
Nov 14 18:01:56 laptop kernel: usb-storage: -- CB transport device requiring auto-sense
Nov 14 18:01:56 laptop kernel: usb-storage: Issuing auto-REQUEST_SENSE
Nov 14 18:01:56 laptop kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Nov 14 18:01:56 laptop kernel: usb-storage: Status code 0; transferred 6/6
Nov 14 18:01:56 laptop kernel: usb-storage: -- transfer complete
Nov 14 18:01:56 laptop kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Nov 14 18:01:56 laptop kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Nov 14 18:01:56 laptop kernel: usb-storage: Status code 0; transferred 18/18
Nov 14 18:01:56 laptop kernel: usb-storage: -- transfer complete
Nov 14 18:01:56 laptop kernel: usb-storage: CB data stage result is 0x0
Nov 14 18:01:56 laptop kernel: usb-storage: -- Result from auto-sense is 0
Nov 14 18:01:56 laptop kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Nov 14 18:01:56 laptop kernel: usb-storage: No Sense: No additional sense information
Nov 14 18:01:56 laptop kernel: usb-storage: scsi cmd done, result=0x0
Nov 14 18:01:56 laptop kernel: usb-storage: *** thread sleeping.
Nov 14 18:01:56 laptop kernel: usb-storage: queuecommand called
Nov 14 18:01:56 laptop kernel: usb-storage: *** thread awakened.
Nov 14 18:01:56 laptop kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
Nov 14 18:01:56 laptop kernel: usb-storage:  00 00 00 00 00 00
Nov 14 18:01:56 laptop kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Nov 14 18:01:56 laptop kernel: usb-storage: Status code 0; transferred 6/6
Nov 14 18:01:56 laptop kernel: usb-storage: -- transfer complete
Nov 14 18:01:56 laptop kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Nov 14 18:01:56 laptop kernel: usb-storage: -- CB transport device requiring auto-sense
Nov 14 18:01:56 laptop kernel: usb-storage: Issuing auto-REQUEST_SENSE
Nov 14 18:01:56 laptop kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Nov 14 18:01:56 laptop kernel: usb-storage: Status code 0; transferred 6/6
Nov 14 18:01:56 laptop kernel: usb-storage: -- transfer complete
Nov 14 18:01:57 laptop kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Nov 14 18:01:57 laptop kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Nov 14 18:01:57 laptop kernel: usb-storage: Status code 0; transferred 18/18
Nov 14 18:01:57 laptop kernel: usb-storage: -- transfer complete
Nov 14 18:01:57 laptop kernel: usb-storage: CB data stage result is 0x0
Nov 14 18:01:57 laptop kernel: usb-storage: -- Result from auto-sense is 0
Nov 14 18:01:57 laptop kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Nov 14 18:01:57 laptop kernel: usb-storage: No Sense: No additional sense information
Nov 14 18:01:57 laptop kernel: usb-storage: scsi cmd done, result=0x0
Nov 14 18:01:57 laptop kernel: usb-storage: *** thread sleeping.
Nov 14 18:01:57 laptop kernel: usb-storage: queuecommand called
Nov 14 18:01:57 laptop kernel: usb-storage: *** thread awakened.
Nov 14 18:01:57 laptop kernel: usb-storage: Command ALLOW_MEDIUM_REMOVAL (6 bytes)
Nov 14 18:01:57 laptop kernel: usb-storage:  1e 00 00 00 01 00
Nov 14 18:01:57 laptop kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Nov 14 18:01:57 laptop kernel: usb-storage: Status code -32; transferred 6/6
Nov 14 18:01:57 laptop kernel: usb-storage: -- stall on control pipe
Nov 14 18:01:57 laptop kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 2
Nov 14 18:01:57 laptop kernel: usb-storage: -- CB transport device requiring auto-sense
Nov 14 18:01:57 laptop kernel: usb-storage: -- transport indicates command failure
Nov 14 18:01:57 laptop kernel: usb-storage: Issuing auto-REQUEST_SENSE
Nov 14 18:01:57 laptop kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Nov 14 18:01:57 laptop kernel: usb-storage: Status code 0; transferred 6/6
Nov 14 18:01:57 laptop kernel: usb-storage: -- transfer complete
Nov 14 18:01:57 laptop kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Nov 14 18:01:57 laptop kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Nov 14 18:01:57 laptop kernel: usb-storage: Status code 0; transferred 18/18
Nov 14 18:01:57 laptop kernel: usb-storage: -- transfer complete
Nov 14 18:01:57 laptop kernel: usb-storage: CB data stage result is 0x0
Nov 14 18:01:57 laptop kernel: usb-storage: -- Result from auto-sense is 0
Nov 14 18:01:57 laptop kernel: usb-storage: -- code: 0x70, key: 0x5, ASC: 0x20, ASCQ: 0x0
Nov 14 18:01:57 laptop kernel: usb-storage: Illegal Request: Invalid command operation code
Nov 14 18:01:57 laptop kernel: usb-storage: scsi cmd done, result=0x2
Nov 14 18:01:57 laptop kernel: usb-storage: *** thread sleeping.
Nov 14 18:01:57 laptop kernel: usb-storage: *** thread awakened.
Nov 14 18:01:57 laptop kernel: usb-storage: Command READ_10 (10 bytes)
Nov 14 18:01:57 laptop kernel: usb-storage:  28 00 00 00 00 00 00 00 08 00
Nov 14 18:01:57 laptop kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=10
Nov 14 18:01:57 laptop kernel: usb-storage: Status code 0; transferred 10/10
Nov 14 18:01:57 laptop kernel: usb-storage: -- transfer complete
Nov 14 18:01:57 laptop kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Nov 14 18:01:57 laptop kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 4096 bytes, 1 entries
Nov 14 18:01:57 laptop kernel: usb-storage: Status code 0; transferred 4096/4096
Nov 14 18:01:57 laptop kernel: usb-storage: -- transfer complete
Nov 14 18:01:57 laptop kernel: usb-storage: CB data stage result is 0x0
Nov 14 18:01:57 laptop kernel: usb-storage: -- CB transport device requiring auto-sense
Nov 14 18:01:57 laptop kernel: usb-storage: Issuing auto-REQUEST_SENSE
Nov 14 18:01:57 laptop kernel: usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 len=6
Nov 14 18:01:57 laptop kernel: usb-storage: Status code 0; transferred 6/6
Nov 14 18:01:57 laptop kernel: usb-storage: -- transfer complete
Nov 14 18:01:57 laptop kernel: usb-storage: Call to usb_stor_ctrl_transfer() returned 0
Nov 14 18:01:57 laptop kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
Nov 14 18:01:57 laptop kernel: usb-storage: Status code 0; transferred 18/18
Nov 14 18:01:57 laptop kernel: usb-storage: -- transfer complete
Nov 14 18:01:57 laptop kernel: usb-storage: CB data stage result is 0x0
Nov 14 18:01:57 laptop kernel: usb-storage: -- Result from auto-sense is 0
Nov 14 18:01:57 laptop kernel: usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Nov 14 18:01:57 laptop kernel: usb-storage: No Sense: No additional sense information
Nov 14 18:01:57 laptop kernel: usb-storage: scsi cmd done, result=0x0
Nov 14 18:01:57 laptop kernel: usb-storage: *** thread sleeping.
Nov 14 18:01:57 laptop kernel: usb-storage: queuecommand called
Nov 14 18:01:57 laptop kernel: usb-storage: *** thread awakened.
Nov 14 18:01:57 laptop kernel: usb-storage: Bad target number (1:0)
Nov 14 18:01:57 laptop kernel: usb-storage: scsi cmd done, result=0x40000
Nov 14 18:01:57 laptop kernel: usb-storage: *** thread sleeping.
Nov 14 18:01:57 laptop kernel: usb-storage: queuecommand called
Nov 14 18:01:57 laptop kernel: usb-storage: *** thread awakened.
Nov 14 18:01:57 laptop kernel: usb-storage: Bad target number (2:0)
Nov 14 18:01:57 laptop kernel: usb-storage: scsi cmd done, result=0x40000
Nov 14 18:01:57 laptop kernel: usb-storage: *** thread sleeping.
Nov 14 18:01:57 laptop kernel: usb-storage: queuecommand called
Nov 14 18:01:57 laptop kernel: usb-storage: *** thread awakened.
Nov 14 18:01:57 laptop kernel: usb-storage: Bad target number (3:0)
Nov 14 18:01:57 laptop kernel: usb-storage: scsi cmd done, result=0x40000
Nov 14 18:01:57 laptop kernel: usb-storage: *** thread sleeping.
Nov 14 18:01:57 laptop kernel: usb-storage: queuecommand called
Nov 14 18:01:57 laptop kernel: usb-storage: *** thread awakened.
Nov 14 18:01:57 laptop kernel: usb-storage: Bad target number (4:0)
Nov 14 18:01:57 laptop kernel: usb-storage: scsi cmd done, result=0x40000
Nov 14 18:01:57 laptop kernel: usb-storage: *** thread sleeping.
Nov 14 18:01:57 laptop kernel: usb-storage: queuecommand called
Nov 14 18:01:57 laptop kernel: usb-storage: *** thread awakened.
Nov 14 18:01:57 laptop kernel: usb-storage: Bad target number (5:0)
Nov 14 18:01:57 laptop kernel: usb-storage: scsi cmd done, result=0x40000
Nov 14 18:01:57 laptop kernel: usb-storage: *** thread sleeping.
Nov 14 18:01:57 laptop kernel: usb-storage: queuecommand called
Nov 14 18:01:57 laptop kernel: usb-storage: *** thread awakened.
Nov 14 18:01:57 laptop kernel: usb-storage: Bad target number (6:0)
Nov 14 18:01:57 laptop kernel: usb-storage: scsi cmd done, result=0x40000
Nov 14 18:01:57 laptop kernel: usb-storage: *** thread sleeping.
Nov 14 18:01:57 laptop kernel: usb-storage: queuecommand called
Nov 14 18:01:57 laptop kernel: usb-storage: *** thread awakened.
Nov 14 18:01:57 laptop kernel: usb-storage: Bad target number (7:0)
Nov 14 18:01:57 laptop kernel: usb-storage: scsi cmd done, result=0x40000
Nov 14 18:01:57 laptop kernel: usb-storage: *** thread sleeping.
Nov 14 18:01:57 laptop kernel: WARNING: USB Mass Storage data integrity not assured
Nov 14 18:01:57 laptop kernel: USB Mass Storage device found at 3
Nov 14 18:02:11 laptop patman: NOTE attach COMPLETED NOTE
