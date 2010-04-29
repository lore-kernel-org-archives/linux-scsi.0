From: Jonas Schwertfeger <jschwertfeger@gmail.com>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Thu, 29 Apr 2010 10:44:19 +0200
Message-ID: <4BD946E3.9030303@gmail.com>
References: <Pine.LNX.4.44L0.1004201533220.1837-100000@iolanthe.rowland.org> <4BCF0605.7080508@pobox.com> <4BCF4120.4060806@pobox.com> <4BCF4394.3080701@gmail.com> <20100426161336.GA3889@xanatos>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030504080107080107040409"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:54781 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758635Ab0D3RXj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Apr 2010 13:23:39 -0400
Received: by bwz19 with SMTP id 19so272458bwz.21
        for <linux-scsi@vger.kernel.org>; Fri, 30 Apr 2010 10:23:37 -0700 (PDT)
In-Reply-To: <20100426161336.GA3889@xanatos>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Mark Lord <mlord@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, Dinh.Nguyen@freescale.com, Sergei Shtylyov <sshtylyov@mvista.com>, James Bottomley <James.Bottomley@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>, Douglas Gilbert <dgilbert@interlog.com>

This is a multi-part message in MIME format.
--------------030504080107080107040409
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Sorry for the delay.  Attached are both a USB3 and a USB2 dmesg log of 
running the latest version of hpdarm.

-Jonas

On 04/26/2010 06:27 PM, Sarah Sharp wrote:
> Jonas,
>
> Can you include the kernel dmesg with USB mass storage debugging turned
> on for this version of hdparm?  I want to confirm the device is still
> sending a phase error to the ATA_16 IDENTIFY DEVICE command with the
> sector count set to 1.
>
> Sarah Sharp

--------------030504080107080107040409
Content-Type: text/x-log;
 name="dmesg_usb2.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg_usb2.log"

[  622.875394] hub 10-0:1.0: hub_suspend
[  622.875400] usb usb10: bus auto-suspend
[  622.875402] usb usb10: bus suspend fail, err -2
[  622.875403] hub 10-0:1.0: hub_resume
[  622.875410] xhci_hcd 0000:03:00.0: get port status, actual port 0 status  = 0x2a0
[  622.875412] xhci_hcd 0000:03:00.0: Get port status returned 0x100
[  622.875418] xhci_hcd 0000:03:00.0: get port status, actual port 1 status  = 0x2a0
[  622.875419] xhci_hcd 0000:03:00.0: Get port status returned 0x100
[  622.875423] xhci_hcd 0000:03:00.0: get port status, actual port 2 status  = 0x2a0
[  622.875424] xhci_hcd 0000:03:00.0: Get port status returned 0x100
[  622.875428] xhci_hcd 0000:03:00.0: get port status, actual port 3 status  = 0x2a0
[  622.875429] xhci_hcd 0000:03:00.0: Get port status returned 0x100
[  622.875434] hub 10-0:1.0: state 7 ports 4 chg 0000 evt 0000
[  625.881285] hub 10-0:1.0: hub_suspend
[  625.881291] usb usb10: bus auto-suspend
[  625.881293] usb usb10: bus suspend fail, err -2
[  625.881294] hub 10-0:1.0: hub_resume
[  625.881301] xhci_hcd 0000:03:00.0: get port status, actual port 0 status  = 0x2a0
[  625.881302] xhci_hcd 0000:03:00.0: Get port status returned 0x100
[  625.881308] xhci_hcd 0000:03:00.0: get port status, actual port 1 status  = 0x2a0
[  625.881309] xhci_hcd 0000:03:00.0: Get port status returned 0x100
[  625.881313] xhci_hcd 0000:03:00.0: get port status, actual port 2 status  = 0x2a0
[  625.881315] xhci_hcd 0000:03:00.0: Get port status returned 0x100
[  625.881319] xhci_hcd 0000:03:00.0: get port status, actual port 3 status  = 0x2a0
[  625.881320] xhci_hcd 0000:03:00.0: Get port status returned 0x100
[  625.881325] hub 10-0:1.0: state 7 ports 4 chg 0000 evt 0000
[  628.002800] usb-storage: queuecommand called
[  628.002840] usb-storage: *** thread awakened.
[  628.002846] usb-storage: Command (unknown command) (16 bytes)
[  628.002849] usb-storage:  85 08 2e 00 00 00 01 00 00 00 00 00 00 40 ec 00
[  628.002863] usb-storage: Bulk Command S 0x43425355 T 0x102 L 512 F 128 Trg 0 LUN 0 CL 16
[  628.002867] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[  628.003050] usb-storage: Status code 0; transferred 31/31
[  628.003052] usb-storage: -- transfer complete
[  628.003055] usb-storage: Bulk command transfer result=0
[  628.003058] usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
[  628.008790] usb-storage: Status code 0; transferred 512/512
[  628.008793] usb-storage: -- transfer complete
[  628.008795] usb-storage: Bulk data transfer result 0x0
[  628.008798] usb-storage: Attempting to get CSW...
[  628.008801] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[  628.008944] usb-storage: Status code 0; transferred 13/13
[  628.008947] usb-storage: -- transfer complete
[  628.008949] usb-storage: Bulk status result = 0
[  628.008952] usb-storage: Bulk Status S 0x53425355 T 0x102 R 0 Stat 0x0
[  628.008956] usb-storage: scsi cmd done, result=0x0
[  628.008960] usb-storage: *** thread sleeping.
[  628.009083] usb-storage: queuecommand called
[  628.009124] usb-storage: *** thread awakened.
[  628.009127] usb-storage: Command (unknown command) (16 bytes)
[  628.009130] usb-storage:  85 08 2e 00 00 00 01 00 00 00 00 00 00 40 a1 00
[  628.009143] usb-storage: Bulk Command S 0x43425355 T 0x103 L 512 F 128 Trg 0 LUN 0 CL 16
[  628.009147] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[  628.009282] usb-storage: Status code 0; transferred 31/31
[  628.009285] usb-storage: -- transfer complete
[  628.009287] usb-storage: Bulk command transfer result=0
[  628.009290] usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
[  628.009545] usb-storage: Status code -32; transferred 0/512
[  628.009549] usb-storage: clearing endpoint halt for pipe 0xc0008480
[  628.009555] usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
[  628.009670] usb-storage: usb_stor_clear_halt: result = 0
[  628.009673] usb-storage: Bulk data transfer result 0x2
[  628.009675] usb-storage: Attempting to get CSW...
[  628.009678] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[  628.009780] usb-storage: Status code 0; transferred 13/13
[  628.009783] usb-storage: -- transfer complete
[  628.009785] usb-storage: Bulk status result = 0
[  628.009788] usb-storage: Bulk Status S 0x53425355 T 0x103 R 512 Stat 0x1
[  628.009791] usb-storage: -- transport indicates command failure
[  628.009794] usb-storage: -- unexpectedly short transfer
[  628.009796] usb-storage: Issuing auto-REQUEST_SENSE
[  628.009801] usb-storage: Bulk Command S 0x43425355 T 0x104 L 96 F 128 Trg 0 LUN 0 CL 6
[  628.009804] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[  628.009905] usb-storage: Status code 0; transferred 31/31
[  628.009908] usb-storage: -- transfer complete
[  628.009910] usb-storage: Bulk command transfer result=0
[  628.009913] usb-storage: usb_stor_bulk_transfer_sglist: xfer 96 bytes, 1 entries
[  628.010034] usb-storage: Status code 0; transferred 96/96
[  628.010036] usb-storage: -- transfer complete
[  628.010039] usb-storage: Bulk data transfer result 0x0
[  628.010041] usb-storage: Attempting to get CSW...
[  628.010044] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[  628.010123] usb-storage: Status code 0; transferred 13/13
[  628.010126] usb-storage: -- transfer complete
[  628.010128] usb-storage: Bulk status result = 0
[  628.010131] usb-storage: Bulk Status S 0x53425355 T 0x104 R 0 Stat 0x0
[  628.010134] usb-storage: -- Result from auto-sense is 0
[  628.010137] usb-storage: -- code: 0x72, key: 0x0, ASC: 0x0, ASCQ: 0x1
[  628.010140] usb-storage: No Sense: Filemark detected
[  628.010144] usb-storage: scsi cmd done, result=0x2
[  628.010148] usb-storage: *** thread sleeping.
[  628.011488] usb-storage: queuecommand called
[  628.011496] usb-storage: *** thread awakened.
[  628.011500] usb-storage: Command READ_10 (10 bytes)
[  628.011502] usb-storage:  28 00 00 00 00 00 00 00 08 00
[  628.011512] usb-storage: Bulk Command S 0x43425355 T 0x105 L 4096 F 128 Trg 0 LUN 0 CL 10
[  628.011515] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[  628.011654] usb-storage: Status code 0; transferred 31/31
[  628.011656] usb-storage: -- transfer complete
[  628.011659] usb-storage: Bulk command transfer result=0
[  628.011662] usb-storage: usb_stor_bulk_transfer_sglist: xfer 4096 bytes, 1 entries
[  628.015897] usb-storage: Status code 0; transferred 4096/4096
[  628.015900] usb-storage: -- transfer complete
[  628.015903] usb-storage: Bulk data transfer result 0x0
[  628.015905] usb-storage: Attempting to get CSW...
[  628.015908] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[  628.016020] usb-storage: Status code 0; transferred 13/13
[  628.016023] usb-storage: -- transfer complete
[  628.016025] usb-storage: Bulk status result = 0
[  628.016028] usb-storage: Bulk Status S 0x53425355 T 0x105 R 0 Stat 0x0
[  628.016031] usb-storage: scsi cmd done, result=0x0
[  628.016035] usb-storage: *** thread sleeping.
[  628.875336] hub 10-0:1.0: hub_suspend
[  628.875342] usb usb10: bus auto-suspend
[  628.875343] usb usb10: bus suspend fail, err -2
[  628.875344] hub 10-0:1.0: hub_resume
[  628.875351] xhci_hcd 0000:03:00.0: get port status, actual port 0 status  = 0x2a0
[  628.875353] xhci_hcd 0000:03:00.0: Get port status returned 0x100
[  628.875359] xhci_hcd 0000:03:00.0: get port status, actual port 1 status  = 0x2a0
[  628.875360] xhci_hcd 0000:03:00.0: Get port status returned 0x100
[  628.875364] xhci_hcd 0000:03:00.0: get port status, actual port 2 status  = 0x2a0
[  628.875365] xhci_hcd 0000:03:00.0: Get port status returned 0x100
[  628.875369] xhci_hcd 0000:03:00.0: get port status, actual port 3 status  = 0x2a0
[  628.875370] xhci_hcd 0000:03:00.0: Get port status returned 0x100
[  628.875375] hub 10-0:1.0: state 7 ports 4 chg 0000 evt 0000

--------------030504080107080107040409
Content-Type: text/x-log;
 name="dmesg_usb3.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg_usb3.log"


[  296.030320] usb-storage: queuecommand called
[  296.030366] usb-storage: *** thread awakened.
[  296.030372] usb-storage: Command (unknown command) (16 bytes)
[  296.030375] usb-storage:  85 08 2e 00 00 00 01 00 00 00 00 00 00 40 ec 00
[  296.030389] usb-storage: Bulk Command S 0x43425355 T 0x102 L 512 F 128 Trg 0 LUN 0 CL 16
[  296.030393] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[  296.030401] usb 10-2: ep 0x2 - urb len = 0x1f (31), addr = 0xcf4c7000, num_trbs = 1
[  296.030405] xhci_hcd 0000:03:00.0: Endpoint state = 0x1
[  296.030410] xhci_hcd 0000:03:00.0: Ring enq = 0xcf46e4c0 (DMA)
[  296.030415] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900058ac804, 32'h4, 4'hf);
[  296.030442] xhci_hcd 0000:03:00.0: op reg status = 00000008
[  296.030445] xhci_hcd 0000:03:00.0: ir set irq_pending = 00000003
[  296.030448] xhci_hcd 0000:03:00.0: Event ring dequeue ptr:
[  296.030452] xhci_hcd 0000:03:00.0: @cf439520 cf46e4b0 00000000 01000000 01048001
[  296.030457] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900058ac024, 32'h8, 4'hf);
[  296.030463] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900058ac620, 32'h3, 4'hf);
[  296.030469] xhci_hcd 0000:03:00.0: In xhci_handle_event
[  296.030472] xhci_hcd 0000:03:00.0: xhci_handle_event - OS owns TRB
[  296.030475] xhci_hcd 0000:03:00.0: xhci_handle_event - calling handle_tx_event
[  296.030478] xhci_hcd 0000:03:00.0: In handle_tx_event
[  296.030481] xhci_hcd 0000:03:00.0: handle_tx_event - ep index = 3
[  296.030484] xhci_hcd 0000:03:00.0: handle_tx_event - checking for list empty
[  296.030487] xhci_hcd 0000:03:00.0: handle_tx_event - getting list entry
[  296.030490] xhci_hcd 0000:03:00.0: handle_tx_event - looking for TD
[  296.030494] xhci_hcd 0000:03:00.0: handle_tx_event - found event_seg = ffff880225d66c40
[  296.030497] xhci_hcd 0000:03:00.0: Event TRB with TRB type ID 32
[  296.030500] xhci_hcd 0000:03:00.0: Offset 0x00 (buffer lo) = 0xcf46e4b0
[  296.030504] xhci_hcd 0000:03:00.0: Offset 0x04 (buffer hi) = 0x0
[  296.030507] xhci_hcd 0000:03:00.0: Offset 0x08 (transfer length) = 0x1000000
[  296.030510] xhci_hcd 0000:03:00.0: Offset 0x0C (flags) = 0x1048001
[  296.030513] xhci_hcd 0000:03:00.0: Successful bulk transfer!
[  296.030517] usb 10-2: ep 0x2 - asked for 31 bytes, 0 bytes untransferred
[  296.030521] xhci_hcd 0000:03:00.0: Ring deq = 0xcf46e4c0 (DMA)
[  296.030524] xhci_hcd 0000:03:00.0: Event ring deq = 0xcf439530 (DMA)
[  296.030531] xhci_hcd 0000:03:00.0: // Write event ring dequeue pointer, preserving EHB bit
[  296.030535] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc900058ac638, 64'hcf439530, 4'hf);
[  296.030539] xhci_hcd 0000:03:00.0: Giveback URB ffff8801fe851b40, len = 31, status = 0
[  296.030545] xhci_hcd 0000:03:00.0: xhci_handle_event - returned from handle_tx_event
[  296.030548] xhci_hcd 0000:03:00.0: In xhci_handle_event
[  296.030555] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc900058ac638, 64'hcf439538, 4'hf);
[  296.030564] usb-storage: Status code 0; transferred 31/31
[  296.030566] usb-storage: -- transfer complete
[  296.030569] usb-storage: Bulk command transfer result=0
[  296.030572] usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
[  296.030579] xhci_hcd 0000:03:00.0: count sg list trbs: 
[  296.030583] xhci_hcd 0000:03:00.0:  sg #0: dma = 0x23bc5000, len = 0x200 (512), num_trbs = 1
[  296.030587] xhci_hcd 0000:03:00.0: 
[  296.030590] usb 10-2: ep 0x81 - urb len = 512, sglist used, num_trbs = 1
[  296.030593] xhci_hcd 0000:03:00.0: Endpoint state = 0x1
[  296.030596] xhci_hcd 0000:03:00.0: First length to xfer from 1st sglist entry = 512
[  296.030601] xhci_hcd 0000:03:00.0:  sg entry: dma = 0x23bc5000, len = 0x200 (512), 64KB boundary at 0x23bd0000, end dma = 0x23bc5200
[  296.030605] xhci_hcd 0000:03:00.0: Ring enq = 0xcf46e130 (DMA)
[  296.030611] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900058ac804, 32'h3, 4'hf);
[  296.036237] xhci_hcd 0000:03:00.0: op reg status = 00000008
[  296.036240] xhci_hcd 0000:03:00.0: ir set irq_pending = 00000003
[  296.036243] xhci_hcd 0000:03:00.0: Event ring dequeue ptr:
[  296.036247] xhci_hcd 0000:03:00.0: @cf439530 cf46e120 00000000 01000000 01038001
[  296.036253] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900058ac024, 32'h8, 4'hf);
[  296.036258] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900058ac620, 32'h3, 4'hf);
[  296.036264] xhci_hcd 0000:03:00.0: In xhci_handle_event
[  296.036267] xhci_hcd 0000:03:00.0: xhci_handle_event - OS owns TRB
[  296.036270] xhci_hcd 0000:03:00.0: xhci_handle_event - calling handle_tx_event
[  296.036273] xhci_hcd 0000:03:00.0: In handle_tx_event
[  296.036276] xhci_hcd 0000:03:00.0: handle_tx_event - ep index = 2
[  296.036279] xhci_hcd 0000:03:00.0: handle_tx_event - checking for list empty
[  296.036283] xhci_hcd 0000:03:00.0: handle_tx_event - getting list entry
[  296.036286] xhci_hcd 0000:03:00.0: handle_tx_event - looking for TD
[  296.036289] xhci_hcd 0000:03:00.0: handle_tx_event - found event_seg = ffff880225d66e00
[  296.036293] xhci_hcd 0000:03:00.0: Event TRB with TRB type ID 32
[  296.036296] xhci_hcd 0000:03:00.0: Offset 0x00 (buffer lo) = 0xcf46e120
[  296.036299] xhci_hcd 0000:03:00.0: Offset 0x04 (buffer hi) = 0x0
[  296.036302] xhci_hcd 0000:03:00.0: Offset 0x08 (transfer length) = 0x1000000
[  296.036305] xhci_hcd 0000:03:00.0: Offset 0x0C (flags) = 0x1038001
[  296.036308] xhci_hcd 0000:03:00.0: Successful bulk transfer!
[  296.036312] usb 10-2: ep 0x81 - asked for 512 bytes, 0 bytes untransferred
[  296.036315] xhci_hcd 0000:03:00.0: Ring deq = 0xcf46e130 (DMA)
[  296.036319] xhci_hcd 0000:03:00.0: Event ring deq = 0xcf439540 (DMA)
[  296.036325] xhci_hcd 0000:03:00.0: // Write event ring dequeue pointer, preserving EHB bit
[  296.036329] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc900058ac638, 64'hcf439540, 4'hf);
[  296.036333] xhci_hcd 0000:03:00.0: Giveback URB ffff8801ed927000, len = 512, status = 0
[  296.036339] xhci_hcd 0000:03:00.0: xhci_handle_event - returned from handle_tx_event
[  296.036343] xhci_hcd 0000:03:00.0: In xhci_handle_event
[  296.036349] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc900058ac638, 64'hcf439548, 4'hf);
[  296.036361] usb-storage: Status code 0; transferred 512/512
[  296.036363] usb-storage: -- transfer complete
[  296.036366] usb-storage: Bulk data transfer result 0x0
[  296.036368] usb-storage: Attempting to get CSW...
[  296.036371] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[  296.036376] usb 10-2: ep 0x81 - urb len = 0xd (13), addr = 0xcf4c7000, num_trbs = 1
[  296.036379] xhci_hcd 0000:03:00.0: Endpoint state = 0x1
[  296.036383] xhci_hcd 0000:03:00.0: Ring enq = 0xcf46e140 (DMA)
[  296.036388] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900058ac804, 32'h3, 4'hf);
[  296.036411] xhci_hcd 0000:03:00.0: op reg status = 00000008
[  296.036414] xhci_hcd 0000:03:00.0: ir set irq_pending = 00000003
[  296.036417] xhci_hcd 0000:03:00.0: Event ring dequeue ptr:
[  296.036421] xhci_hcd 0000:03:00.0: @cf439540 cf46e130 00000000 01000000 01038001
[  296.036426] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900058ac024, 32'h8, 4'hf);
[  296.036432] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900058ac620, 32'h3, 4'hf);
[  296.036437] xhci_hcd 0000:03:00.0: In xhci_handle_event
[  296.036440] xhci_hcd 0000:03:00.0: xhci_handle_event - OS owns TRB
[  296.036443] xhci_hcd 0000:03:00.0: xhci_handle_event - calling handle_tx_event
[  296.036446] xhci_hcd 0000:03:00.0: In handle_tx_event
[  296.036450] xhci_hcd 0000:03:00.0: handle_tx_event - ep index = 2
[  296.036453] xhci_hcd 0000:03:00.0: handle_tx_event - checking for list empty
[  296.036456] xhci_hcd 0000:03:00.0: handle_tx_event - getting list entry
[  296.036459] xhci_hcd 0000:03:00.0: handle_tx_event - looking for TD
[  296.036462] xhci_hcd 0000:03:00.0: handle_tx_event - found event_seg = ffff880225d66e00
[  296.036466] xhci_hcd 0000:03:00.0: Event TRB with TRB type ID 32
[  296.036469] xhci_hcd 0000:03:00.0: Offset 0x00 (buffer lo) = 0xcf46e130
[  296.036472] xhci_hcd 0000:03:00.0: Offset 0x04 (buffer hi) = 0x0
[  296.036475] xhci_hcd 0000:03:00.0: Offset 0x08 (transfer length) = 0x1000000
[  296.036478] xhci_hcd 0000:03:00.0: Offset 0x0C (flags) = 0x1038001
[  296.036481] xhci_hcd 0000:03:00.0: Successful bulk transfer!
[  296.036485] usb 10-2: ep 0x81 - asked for 13 bytes, 0 bytes untransferred
[  296.036488] xhci_hcd 0000:03:00.0: Ring deq = 0xcf46e140 (DMA)
[  296.036491] xhci_hcd 0000:03:00.0: Event ring deq = 0xcf439550 (DMA)
[  296.036497] xhci_hcd 0000:03:00.0: // Write event ring dequeue pointer, preserving EHB bit
[  296.036501] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc900058ac638, 64'hcf439550, 4'hf);
[  296.036506] xhci_hcd 0000:03:00.0: Giveback URB ffff8801fe851b40, len = 13, status = 0
[  296.036510] xhci_hcd 0000:03:00.0: xhci_handle_event - returned from handle_tx_event
[  296.036514] xhci_hcd 0000:03:00.0: In xhci_handle_event
[  296.036520] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc900058ac638, 64'hcf439558, 4'hf);
[  296.036529] usb-storage: Status code 0; transferred 13/13
[  296.036531] usb-storage: -- transfer complete
[  296.036533] usb-storage: Bulk status result = 0
[  296.036536] usb-storage: Bulk Status S 0x53425355 T 0x102 R 0 Stat 0x0
[  296.036540] usb-storage: scsi cmd done, result=0x0
[  296.036544] usb-storage: *** thread sleeping.
[  296.036685] usb-storage: queuecommand called
[  296.036725] usb-storage: *** thread awakened.
[  296.036729] usb-storage: Command (unknown command) (16 bytes)
[  296.036731] usb-storage:  85 08 2e 00 00 00 01 00 00 00 00 00 00 40 a1 00
[  296.036745] usb-storage: Bulk Command S 0x43425355 T 0x103 L 512 F 128 Trg 0 LUN 0 CL 16
[  296.036748] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[  296.036754] usb 10-2: ep 0x2 - urb len = 0x1f (31), addr = 0xcf4c7000, num_trbs = 1
[  296.036757] xhci_hcd 0000:03:00.0: Endpoint state = 0x1
[  296.036761] xhci_hcd 0000:03:00.0: Ring enq = 0xcf46e4d0 (DMA)
[  296.036766] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900058ac804, 32'h4, 4'hf);
[  296.036792] xhci_hcd 0000:03:00.0: op reg status = 00000008
[  296.036795] xhci_hcd 0000:03:00.0: ir set irq_pending = 00000003
[  296.036798] xhci_hcd 0000:03:00.0: Event ring dequeue ptr:
[  296.036802] xhci_hcd 0000:03:00.0: @cf439550 cf46e4c0 00000000 01000000 01048001
[  296.036807] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900058ac024, 32'h8, 4'hf);
[  296.036813] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900058ac620, 32'h3, 4'hf);
[  296.036818] xhci_hcd 0000:03:00.0: In xhci_handle_event
[  296.036821] xhci_hcd 0000:03:00.0: xhci_handle_event - OS owns TRB
[  296.036824] xhci_hcd 0000:03:00.0: xhci_handle_event - calling handle_tx_event
[  296.036828] xhci_hcd 0000:03:00.0: In handle_tx_event
[  296.036831] xhci_hcd 0000:03:00.0: handle_tx_event - ep index = 3
[  296.036834] xhci_hcd 0000:03:00.0: handle_tx_event - checking for list empty
[  296.036837] xhci_hcd 0000:03:00.0: handle_tx_event - getting list entry
[  296.036840] xhci_hcd 0000:03:00.0: handle_tx_event - looking for TD
[  296.036843] xhci_hcd 0000:03:00.0: handle_tx_event - found event_seg = ffff880225d66c40
[  296.036847] xhci_hcd 0000:03:00.0: Event TRB with TRB type ID 32
[  296.036850] xhci_hcd 0000:03:00.0: Offset 0x00 (buffer lo) = 0xcf46e4c0
[  296.036853] xhci_hcd 0000:03:00.0: Offset 0x04 (buffer hi) = 0x0
[  296.036856] xhci_hcd 0000:03:00.0: Offset 0x08 (transfer length) = 0x1000000
[  296.036859] xhci_hcd 0000:03:00.0: Offset 0x0C (flags) = 0x1048001
[  296.036862] xhci_hcd 0000:03:00.0: Successful bulk transfer!
[  296.036866] usb 10-2: ep 0x2 - asked for 31 bytes, 0 bytes untransferred
[  296.036870] xhci_hcd 0000:03:00.0: Ring deq = 0xcf46e4d0 (DMA)
[  296.036873] xhci_hcd 0000:03:00.0: Event ring deq = 0xcf439560 (DMA)
[  296.036879] xhci_hcd 0000:03:00.0: // Write event ring dequeue pointer, preserving EHB bit
[  296.036883] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc900058ac638, 64'hcf439560, 4'hf);
[  296.036888] xhci_hcd 0000:03:00.0: Giveback URB ffff8801fe851b40, len = 31, status = 0
[  296.036893] xhci_hcd 0000:03:00.0: xhci_handle_event - returned from handle_tx_event
[  296.036896] xhci_hcd 0000:03:00.0: In xhci_handle_event
[  296.036903] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc900058ac638, 64'hcf439568, 4'hf);
[  296.036912] usb-storage: Status code 0; transferred 31/31
[  296.036915] usb-storage: -- transfer complete
[  296.036917] usb-storage: Bulk command transfer result=0
[  296.036920] usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
[  296.036926] xhci_hcd 0000:03:00.0: count sg list trbs: 
[  296.036930] xhci_hcd 0000:03:00.0:  sg #0: dma = 0x23bc5800, len = 0x200 (512), num_trbs = 1
[  296.036933] xhci_hcd 0000:03:00.0: 
[  296.036936] usb 10-2: ep 0x81 - urb len = 512, sglist used, num_trbs = 1
[  296.036940] xhci_hcd 0000:03:00.0: Endpoint state = 0x1
[  296.036943] xhci_hcd 0000:03:00.0: First length to xfer from 1st sglist entry = 512
[  296.036948] xhci_hcd 0000:03:00.0:  sg entry: dma = 0x23bc5800, len = 0x200 (512), 64KB boundary at 0x23bd0000, end dma = 0x23bc5a00
[  296.036952] xhci_hcd 0000:03:00.0: Ring enq = 0xcf46e150 (DMA)
[  296.036957] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900058ac804, 32'h3, 4'hf);
[  296.037072] xhci_hcd 0000:03:00.0: op reg status = 00000008
[  296.037076] xhci_hcd 0000:03:00.0: ir set irq_pending = 00000003
[  296.037079] xhci_hcd 0000:03:00.0: Event ring dequeue ptr:
[  296.037082] xhci_hcd 0000:03:00.0: @cf439560 cf46e140 00000000 06000200 01038001
[  296.037088] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900058ac024, 32'h8, 4'hf);
[  296.037094] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900058ac620, 32'h3, 4'hf);
[  296.037099] xhci_hcd 0000:03:00.0: In xhci_handle_event
[  296.037102] xhci_hcd 0000:03:00.0: xhci_handle_event - OS owns TRB
[  296.037105] xhci_hcd 0000:03:00.0: xhci_handle_event - calling handle_tx_event
[  296.037109] xhci_hcd 0000:03:00.0: In handle_tx_event
[  296.037112] xhci_hcd 0000:03:00.0: handle_tx_event - ep index = 2
[  296.037115] xhci_hcd 0000:03:00.0: handle_tx_event - checking for list empty
[  296.037118] xhci_hcd 0000:03:00.0: handle_tx_event - getting list entry
[  296.037121] xhci_hcd 0000:03:00.0: handle_tx_event - looking for TD
[  296.037125] xhci_hcd 0000:03:00.0: handle_tx_event - found event_seg = ffff880225d66e00
[  296.037128] xhci_hcd 0000:03:00.0: Event TRB with TRB type ID 32
[  296.037131] xhci_hcd 0000:03:00.0: Offset 0x00 (buffer lo) = 0xcf46e140
[  296.037134] xhci_hcd 0000:03:00.0: Offset 0x04 (buffer hi) = 0x0
[  296.037137] xhci_hcd 0000:03:00.0: Offset 0x08 (transfer length) = 0x6000200
[  296.037141] xhci_hcd 0000:03:00.0: Offset 0x0C (flags) = 0x1038001
[  296.037143] xhci_hcd 0000:03:00.0: WARN: Stalled endpoint
[  296.037148] usb 10-2: ep 0x81 - asked for 512 bytes, 512 bytes untransferred
[  296.037151] xhci_hcd 0000:03:00.0: Event ring deq = 0xcf439570 (DMA)
[  296.037158] xhci_hcd 0000:03:00.0: // Write event ring dequeue pointer, preserving EHB bit
[  296.037162] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc900058ac638, 64'hcf439570, 4'hf);
[  296.037166] xhci_hcd 0000:03:00.0: Giveback URB ffff8801ed927000, len = 0, status = -32
[  296.037172] xhci_hcd 0000:03:00.0: xhci_handle_event - returned from handle_tx_event
[  296.037175] xhci_hcd 0000:03:00.0: In xhci_handle_event
[  296.037182] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc900058ac638, 64'hcf439578, 4'hf);
[  296.037193] usb-storage: Status code -32; transferred 0/512
[  296.037196] usb-storage: clearing endpoint halt for pipe 0xc0008280
[  296.037201] usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
[  296.037205] xhci_hcd 0000:03:00.0: Queueing ctrl tx for slot id 1, ep 0
[  296.037209] xhci_hcd 0000:03:00.0: Endpoint state = 0x1
[  296.037212] xhci_hcd 0000:03:00.0: Ring enq = 0xcf4399e0 (DMA)
[  296.037215] xhci_hcd 0000:03:00.0: Ring enq = 0xcf4399f0 (DMA)
[  296.037220] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900058ac804, 32'h1, 4'hf);
[  296.037516] xhci_hcd 0000:03:00.0: op reg status = 00000008
[  296.037519] xhci_hcd 0000:03:00.0: ir set irq_pending = 00000003
[  296.037522] xhci_hcd 0000:03:00.0: Event ring dequeue ptr:
[  296.037526] xhci_hcd 0000:03:00.0: @cf439570 cf4399e0 00000000 01000000 01018001
[  296.037531] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900058ac024, 32'h8, 4'hf);
[  296.037537] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900058ac620, 32'h3, 4'hf);
[  296.037543] xhci_hcd 0000:03:00.0: In xhci_handle_event
[  296.037545] xhci_hcd 0000:03:00.0: xhci_handle_event - OS owns TRB
[  296.037549] xhci_hcd 0000:03:00.0: xhci_handle_event - calling handle_tx_event
[  296.037552] xhci_hcd 0000:03:00.0: In handle_tx_event
[  296.037555] xhci_hcd 0000:03:00.0: handle_tx_event - ep index = 0
[  296.037558] xhci_hcd 0000:03:00.0: handle_tx_event - checking for list empty
[  296.037561] xhci_hcd 0000:03:00.0: handle_tx_event - getting list entry
[  296.037564] xhci_hcd 0000:03:00.0: handle_tx_event - looking for TD
[  296.037568] xhci_hcd 0000:03:00.0: handle_tx_event - found event_seg = ffff880225d66dc0
[  296.037571] xhci_hcd 0000:03:00.0: Event TRB with TRB type ID 32
[  296.037574] xhci_hcd 0000:03:00.0: Offset 0x00 (buffer lo) = 0xcf4399e0
[  296.037577] xhci_hcd 0000:03:00.0: Offset 0x04 (buffer hi) = 0x0
[  296.037580] xhci_hcd 0000:03:00.0: Offset 0x08 (transfer length) = 0x1000000
[  296.037584] xhci_hcd 0000:03:00.0: Offset 0x0C (flags) = 0x1018001
[  296.037587] xhci_hcd 0000:03:00.0: DMA address or buffer contents= 3477314016
[  296.037591] xhci_hcd 0000:03:00.0: Successful control transfer!
[  296.037594] xhci_hcd 0000:03:00.0: Ring deq = 0xcf4399e0 (DMA)
[  296.037597] xhci_hcd 0000:03:00.0: Ring deq = 0xcf4399f0 (DMA)
[  296.037600] xhci_hcd 0000:03:00.0: Event ring deq = 0xcf439580 (DMA)
[  296.037606] xhci_hcd 0000:03:00.0: // Write event ring dequeue pointer, preserving EHB bit
[  296.037610] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc900058ac638, 64'hcf439580, 4'hf);
[  296.037615] xhci_hcd 0000:03:00.0: Giveback URB ffff8801fe851b40, len = 0, status = 0
[  296.037620] xhci_hcd 0000:03:00.0: xhci_handle_event - returned from handle_tx_event
[  296.037624] xhci_hcd 0000:03:00.0: In xhci_handle_event
[  296.037630] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc900058ac638, 64'hcf439588, 4'hf);
[  296.037640] xhci_hcd 0000:03:00.0: Queueing reset endpoint command
[  296.037644] xhci_hcd 0000:03:00.0: Command ring enq = 0xcf439040 (DMA)
[  296.037647] xhci_hcd 0000:03:00.0: Cleaning up stalled endpoint ring
[  296.037650] xhci_hcd 0000:03:00.0: Finding segment containing stopped TRB.
[  296.037653] xhci_hcd 0000:03:00.0: Finding endpoint context
[  296.037656] xhci_hcd 0000:03:00.0: Finding segment containing last TRB in TD.
[  296.037659] xhci_hcd 0000:03:00.0: New dequeue segment = ffff880225d66e00 (virtual)
[  296.037663] xhci_hcd 0000:03:00.0: New dequeue pointer = 0xcf46e150 (DMA)
[  296.037666] xhci_hcd 0000:03:00.0: Setting dequeue pointer in internal ring state.
[  296.037669] xhci_hcd 0000:03:00.0: Queueing new dequeue state
[  296.037673] xhci_hcd 0000:03:00.0: Set TR Deq Ptr cmd, new deq seg = ffff880225d66e00 (0xcf46e000 dma), new deq ptr = ffff8800cf46e150 (0xcf46e150 dma), new cycle = 1
[  296.037678] xhci_hcd 0000:03:00.0: Command ring enq = 0xcf439050 (DMA)
[  296.037681] xhci_hcd 0000:03:00.0: // Ding dong!
[  296.037686] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900058ac800, 32'h0, 4'hf);
[  296.037691] usb-storage: usb_stor_clear_halt: result = 0
[  296.037694] usb-storage: Bulk data transfer result 0x2
[  296.037697] usb-storage: Attempting to get CSW...
[  296.037699] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[  296.037705] usb 10-2: ep 0x81 - urb len = 0xd (13), addr = 0xcf4c7000, num_trbs = 1
[  296.037708] xhci_hcd 0000:03:00.0: Endpoint state = 0x2
[  296.037711] xhci_hcd 0000:03:00.0: WARN halted endpoint, queueing URB anyway.
[  296.037714] xhci_hcd 0000:03:00.0: Ring enq = 0xcf46e160 (DMA)
[  296.037849] xhci_hcd 0000:03:00.0: op reg status = 00000008
[  296.037852] xhci_hcd 0000:03:00.0: ir set irq_pending = 00000003
[  296.037855] xhci_hcd 0000:03:00.0: Event ring dequeue ptr:
[  296.037859] xhci_hcd 0000:03:00.0: @cf439580 cf439030 00000000 01000000 01008401
[  296.037864] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900058ac024, 32'h8, 4'hf);
[  296.037870] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900058ac620, 32'h3, 4'hf);
[  296.037876] xhci_hcd 0000:03:00.0: In xhci_handle_event
[  296.037878] xhci_hcd 0000:03:00.0: xhci_handle_event - OS owns TRB
[  296.037882] xhci_hcd 0000:03:00.0: xhci_handle_event - calling handle_cmd_completion
[  296.037885] xhci_hcd 0000:03:00.0: Ignoring reset ep completion code of 1
[  296.037889] xhci_hcd 0000:03:00.0: Command ring deq = 0xcf439040 (DMA)
[  296.037892] xhci_hcd 0000:03:00.0: xhci_handle_event - returned from handle_cmd_completion
[  296.037896] xhci_hcd 0000:03:00.0: Event ring deq = 0xcf439590 (DMA)
[  296.037902] xhci_hcd 0000:03:00.0: // Write event ring dequeue pointer, preserving EHB bit
[  296.037906] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc900058ac638, 64'hcf439590, 4'hf);
[  296.037910] xhci_hcd 0000:03:00.0: In xhci_handle_event
[  296.037912] xhci_hcd 0000:03:00.0: xhci_handle_event - OS owns TRB
[  296.037916] xhci_hcd 0000:03:00.0: xhci_handle_event - calling handle_cmd_completion
[  296.037919] xhci_hcd 0000:03:00.0: Successful Set TR Deq Ptr cmd, deq = @cf46e151
[  296.037925] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900058ac804, 32'h3, 4'hf);
[  296.037930] xhci_hcd 0000:03:00.0: Command ring deq = 0xcf439050 (DMA)
[  296.037933] xhci_hcd 0000:03:00.0: xhci_handle_event - returned from handle_cmd_completion
[  296.037937] xhci_hcd 0000:03:00.0: Event ring deq = 0xcf4395a0 (DMA)
[  296.037943] xhci_hcd 0000:03:00.0: // Write event ring dequeue pointer, preserving EHB bit
[  296.037947] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc900058ac638, 64'hcf4395a0, 4'hf);
[  296.037951] xhci_hcd 0000:03:00.0: In xhci_handle_event
[  296.037954] xhci_hcd 0000:03:00.0: xhci_handle_event - OS owns TRB
[  296.037957] xhci_hcd 0000:03:00.0: xhci_handle_event - calling handle_tx_event
[  296.037960] xhci_hcd 0000:03:00.0: In handle_tx_event
[  296.037963] xhci_hcd 0000:03:00.0: handle_tx_event - ep index = 2
[  296.037966] xhci_hcd 0000:03:00.0: handle_tx_event - checking for list empty
[  296.037970] xhci_hcd 0000:03:00.0: handle_tx_event - getting list entry
[  296.037973] xhci_hcd 0000:03:00.0: handle_tx_event - looking for TD
[  296.037976] xhci_hcd 0000:03:00.0: handle_tx_event - found event_seg = ffff880225d66e00
[  296.037980] xhci_hcd 0000:03:00.0: Event TRB with TRB type ID 32
[  296.037983] xhci_hcd 0000:03:00.0: Offset 0x00 (buffer lo) = 0xcf46e150
[  296.037986] xhci_hcd 0000:03:00.0: Offset 0x04 (buffer hi) = 0x0
[  296.037989] xhci_hcd 0000:03:00.0: Offset 0x08 (transfer length) = 0x1000000
[  296.037992] xhci_hcd 0000:03:00.0: Offset 0x0C (flags) = 0x1038001
[  296.037995] xhci_hcd 0000:03:00.0: Successful bulk transfer!
[  296.037999] usb 10-2: ep 0x81 - asked for 13 bytes, 0 bytes untransferred
[  296.038002] xhci_hcd 0000:03:00.0: Ring deq = 0xcf46e160 (DMA)
[  296.038005] xhci_hcd 0000:03:00.0: Event ring deq = 0xcf4395b0 (DMA)
[  296.038012] xhci_hcd 0000:03:00.0: // Write event ring dequeue pointer, preserving EHB bit
[  296.038016] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc900058ac638, 64'hcf4395b0, 4'hf);
[  296.038020] xhci_hcd 0000:03:00.0: Giveback URB ffff8801fe851b40, len = 13, status = 0
[  296.038025] xhci_hcd 0000:03:00.0: xhci_handle_event - returned from handle_tx_event
[  296.038029] xhci_hcd 0000:03:00.0: In xhci_handle_event
[  296.038035] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc900058ac638, 64'hcf4395b8, 4'hf);
[  296.038045] usb-storage: Status code 0; transferred 13/13
[  296.038048] usb-storage: -- transfer complete
[  296.038050] usb-storage: Bulk status result = 0
[  296.038053] usb-storage: Bulk Status S 0x53425355 T 0x103 R 512 Stat 0x1
[  296.038056] usb-storage: -- transport indicates command failure
[  296.038059] usb-storage: -- unexpectedly short transfer
[  296.038061] usb-storage: Issuing auto-REQUEST_SENSE
[  296.038065] usb-storage: Bulk Command S 0x43425355 T 0x104 L 96 F 128 Trg 0 LUN 0 CL 6
[  296.038069] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[  296.038074] usb 10-2: ep 0x2 - urb len = 0x1f (31), addr = 0xcf4c7000, num_trbs = 1
[  296.038077] xhci_hcd 0000:03:00.0: Endpoint state = 0x1
[  296.038081] xhci_hcd 0000:03:00.0: Ring enq = 0xcf46e4e0 (DMA)
[  296.038086] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900058ac804, 32'h4, 4'hf);
[  296.038124] xhci_hcd 0000:03:00.0: op reg status = 00000008
[  296.038127] xhci_hcd 0000:03:00.0: ir set irq_pending = 00000003
[  296.038130] xhci_hcd 0000:03:00.0: Event ring dequeue ptr:
[  296.038134] xhci_hcd 0000:03:00.0: @cf4395b0 cf46e4d0 00000000 01000000 01048001
[  296.038139] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900058ac024, 32'h8, 4'hf);
[  296.038145] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900058ac620, 32'h3, 4'hf);
[  296.038151] xhci_hcd 0000:03:00.0: In xhci_handle_event
[  296.038154] xhci_hcd 0000:03:00.0: xhci_handle_event - OS owns TRB
[  296.038157] xhci_hcd 0000:03:00.0: xhci_handle_event - calling handle_tx_event
[  296.038160] xhci_hcd 0000:03:00.0: In handle_tx_event
[  296.038163] xhci_hcd 0000:03:00.0: handle_tx_event - ep index = 3
[  296.038166] xhci_hcd 0000:03:00.0: handle_tx_event - checking for list empty
[  296.038169] xhci_hcd 0000:03:00.0: handle_tx_event - getting list entry
[  296.038172] xhci_hcd 0000:03:00.0: handle_tx_event - looking for TD
[  296.038176] xhci_hcd 0000:03:00.0: handle_tx_event - found event_seg = ffff880225d66c40
[  296.038179] xhci_hcd 0000:03:00.0: Event TRB with TRB type ID 32
[  296.038182] xhci_hcd 0000:03:00.0: Offset 0x00 (buffer lo) = 0xcf46e4d0
[  296.038186] xhci_hcd 0000:03:00.0: Offset 0x04 (buffer hi) = 0x0
[  296.038189] xhci_hcd 0000:03:00.0: Offset 0x08 (transfer length) = 0x1000000
[  296.038192] xhci_hcd 0000:03:00.0: Offset 0x0C (flags) = 0x1048001
[  296.038195] xhci_hcd 0000:03:00.0: Successful bulk transfer!
[  296.038198] usb 10-2: ep 0x2 - asked for 31 bytes, 0 bytes untransferred
[  296.038202] xhci_hcd 0000:03:00.0: Ring deq = 0xcf46e4e0 (DMA)
[  296.038205] xhci_hcd 0000:03:00.0: Event ring deq = 0xcf4395c0 (DMA)
[  296.038212] xhci_hcd 0000:03:00.0: // Write event ring dequeue pointer, preserving EHB bit
[  296.038215] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc900058ac638, 64'hcf4395c0, 4'hf);
[  296.038220] xhci_hcd 0000:03:00.0: Giveback URB ffff8801fe851b40, len = 31, status = 0
[  296.038225] xhci_hcd 0000:03:00.0: xhci_handle_event - returned from handle_tx_event
[  296.038229] xhci_hcd 0000:03:00.0: In xhci_handle_event
[  296.038235] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc900058ac638, 64'hcf4395c8, 4'hf);
[  296.038245] usb-storage: Status code 0; transferred 31/31
[  296.038247] usb-storage: -- transfer complete
[  296.038250] usb-storage: Bulk command transfer result=0
[  296.038253] usb-storage: usb_stor_bulk_transfer_sglist: xfer 96 bytes, 1 entries
[  296.038258] xhci_hcd 0000:03:00.0: count sg list trbs: 
[  296.038263] xhci_hcd 0000:03:00.0:  sg #0: dma = 0x23bc6000, len = 0x60 (96), num_trbs = 1
[  296.038266] xhci_hcd 0000:03:00.0: 
[  296.038269] usb 10-2: ep 0x81 - urb len = 96, sglist used, num_trbs = 1
[  296.038272] xhci_hcd 0000:03:00.0: Endpoint state = 0x1
[  296.038275] xhci_hcd 0000:03:00.0: First length to xfer from 1st sglist entry = 96
[  296.038280] xhci_hcd 0000:03:00.0:  sg entry: dma = 0x23bc6000, len = 0x60 (96), 64KB boundary at 0x23bd0000, end dma = 0x23bc6060
[  296.038284] xhci_hcd 0000:03:00.0: Ring enq = 0xcf46e170 (DMA)
[  296.038289] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900058ac804, 32'h3, 4'hf);
[  296.038312] xhci_hcd 0000:03:00.0: op reg status = 00000008
[  296.038315] xhci_hcd 0000:03:00.0: ir set irq_pending = 00000003
[  296.038318] xhci_hcd 0000:03:00.0: Event ring dequeue ptr:
[  296.038322] xhci_hcd 0000:03:00.0: @cf4395c0 cf46e160 00000000 01000000 01038001
[  296.038327] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900058ac024, 32'h8, 4'hf);
[  296.038333] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900058ac620, 32'h3, 4'hf);
[  296.038338] xhci_hcd 0000:03:00.0: In xhci_handle_event
[  296.038341] xhci_hcd 0000:03:00.0: xhci_handle_event - OS owns TRB
[  296.038344] xhci_hcd 0000:03:00.0: xhci_handle_event - calling handle_tx_event
[  296.038348] xhci_hcd 0000:03:00.0: In handle_tx_event
[  296.038351] xhci_hcd 0000:03:00.0: handle_tx_event - ep index = 2
[  296.038354] xhci_hcd 0000:03:00.0: handle_tx_event - checking for list empty
[  296.038357] xhci_hcd 0000:03:00.0: handle_tx_event - getting list entry
[  296.038360] xhci_hcd 0000:03:00.0: handle_tx_event - looking for TD
[  296.038363] xhci_hcd 0000:03:00.0: handle_tx_event - found event_seg = ffff880225d66e00
[  296.038367] xhci_hcd 0000:03:00.0: Event TRB with TRB type ID 32
[  296.038370] xhci_hcd 0000:03:00.0: Offset 0x00 (buffer lo) = 0xcf46e160
[  296.038373] xhci_hcd 0000:03:00.0: Offset 0x04 (buffer hi) = 0x0
[  296.038376] xhci_hcd 0000:03:00.0: Offset 0x08 (transfer length) = 0x1000000
[  296.038379] xhci_hcd 0000:03:00.0: Offset 0x0C (flags) = 0x1038001
[  296.038382] xhci_hcd 0000:03:00.0: Successful bulk transfer!
[  296.038386] usb 10-2: ep 0x81 - asked for 96 bytes, 0 bytes untransferred
[  296.038389] xhci_hcd 0000:03:00.0: Ring deq = 0xcf46e170 (DMA)
[  296.038392] xhci_hcd 0000:03:00.0: Event ring deq = 0xcf4395d0 (DMA)
[  296.038399] xhci_hcd 0000:03:00.0: // Write event ring dequeue pointer, preserving EHB bit
[  296.038403] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc900058ac638, 64'hcf4395d0, 4'hf);
[  296.038407] xhci_hcd 0000:03:00.0: Giveback URB ffff8801ed927000, len = 96, status = 0
[  296.038412] xhci_hcd 0000:03:00.0: xhci_handle_event - returned from handle_tx_event
[  296.038415] xhci_hcd 0000:03:00.0: In xhci_handle_event
[  296.038422] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc900058ac638, 64'hcf4395d8, 4'hf);
[  296.038431] usb-storage: Status code 0; transferred 96/96
[  296.038433] usb-storage: -- transfer complete
[  296.038436] usb-storage: Bulk data transfer result 0x0
[  296.038438] usb-storage: Attempting to get CSW...
[  296.038441] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[  296.038445] usb 10-2: ep 0x81 - urb len = 0xd (13), addr = 0xcf4c7000, num_trbs = 1
[  296.038449] xhci_hcd 0000:03:00.0: Endpoint state = 0x1
[  296.038452] xhci_hcd 0000:03:00.0: Ring enq = 0xcf46e180 (DMA)
[  296.038461] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900058ac804, 32'h3, 4'hf);
[  296.038508] xhci_hcd 0000:03:00.0: op reg status = 00000008
[  296.038511] xhci_hcd 0000:03:00.0: ir set irq_pending = 00000003
[  296.038513] xhci_hcd 0000:03:00.0: Event ring dequeue ptr:
[  296.038517] xhci_hcd 0000:03:00.0: @cf4395d0 cf46e170 00000000 01000000 01038001
[  296.038523] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900058ac024, 32'h8, 4'hf);
[  296.038528] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900058ac620, 32'h3, 4'hf);
[  296.038534] xhci_hcd 0000:03:00.0: In xhci_handle_event
[  296.038537] xhci_hcd 0000:03:00.0: xhci_handle_event - OS owns TRB
[  296.038540] xhci_hcd 0000:03:00.0: xhci_handle_event - calling handle_tx_event
[  296.038543] xhci_hcd 0000:03:00.0: In handle_tx_event
[  296.038546] xhci_hcd 0000:03:00.0: handle_tx_event - ep index = 2
[  296.038549] xhci_hcd 0000:03:00.0: handle_tx_event - checking for list empty
[  296.038552] xhci_hcd 0000:03:00.0: handle_tx_event - getting list entry
[  296.038555] xhci_hcd 0000:03:00.0: handle_tx_event - looking for TD
[  296.038559] xhci_hcd 0000:03:00.0: handle_tx_event - found event_seg = ffff880225d66e00
[  296.038562] xhci_hcd 0000:03:00.0: Event TRB with TRB type ID 32
[  296.038565] xhci_hcd 0000:03:00.0: Offset 0x00 (buffer lo) = 0xcf46e170
[  296.038568] xhci_hcd 0000:03:00.0: Offset 0x04 (buffer hi) = 0x0
[  296.038571] xhci_hcd 0000:03:00.0: Offset 0x08 (transfer length) = 0x1000000
[  296.038575] xhci_hcd 0000:03:00.0: Offset 0x0C (flags) = 0x1038001
[  296.038578] xhci_hcd 0000:03:00.0: Successful bulk transfer!
[  296.038581] usb 10-2: ep 0x81 - asked for 13 bytes, 0 bytes untransferred
[  296.038584] xhci_hcd 0000:03:00.0: Ring deq = 0xcf46e180 (DMA)
[  296.038588] xhci_hcd 0000:03:00.0: Event ring deq = 0xcf4395e0 (DMA)
[  296.038594] xhci_hcd 0000:03:00.0: // Write event ring dequeue pointer, preserving EHB bit
[  296.038598] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc900058ac638, 64'hcf4395e0, 4'hf);
[  296.038602] xhci_hcd 0000:03:00.0: Giveback URB ffff8801fe851b40, len = 13, status = 0
[  296.038607] xhci_hcd 0000:03:00.0: xhci_handle_event - returned from handle_tx_event
[  296.038610] xhci_hcd 0000:03:00.0: In xhci_handle_event
[  296.038617] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc900058ac638, 64'hcf4395e8, 4'hf);
[  296.038625] usb-storage: Status code 0; transferred 13/13
[  296.038627] usb-storage: -- transfer complete
[  296.038630] usb-storage: Bulk status result = 0
[  296.038633] usb-storage: Bulk Status S 0x53425355 T 0x104 R 0 Stat 0x0
[  296.038636] usb-storage: -- Result from auto-sense is 0
[  296.038639] usb-storage: -- code: 0x72, key: 0x0, ASC: 0x0, ASCQ: 0x1
[  296.038642] usb-storage: No Sense: Filemark detected
[  296.038646] usb-storage: scsi cmd done, result=0x2
[  296.038650] usb-storage: *** thread sleeping.
[  296.040100] usb-storage: queuecommand called
[  296.040139] usb-storage: *** thread awakened.
[  296.040143] usb-storage: Command READ_10 (10 bytes)
[  296.040145] usb-storage:  28 00 00 00 00 00 00 00 08 00
[  296.040156] usb-storage: Bulk Command S 0x43425355 T 0x105 L 4096 F 128 Trg 0 LUN 0 CL 10
[  296.040159] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
[  296.040165] usb 10-2: ep 0x2 - urb len = 0x1f (31), addr = 0xcf4c7000, num_trbs = 1
[  296.040168] xhci_hcd 0000:03:00.0: Endpoint state = 0x1
[  296.040172] xhci_hcd 0000:03:00.0: Ring enq = 0xcf46e4f0 (DMA)
[  296.040178] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900058ac804, 32'h4, 4'hf);
[  296.040201] xhci_hcd 0000:03:00.0: op reg status = 00000008
[  296.040204] xhci_hcd 0000:03:00.0: ir set irq_pending = 00000003
[  296.040207] xhci_hcd 0000:03:00.0: Event ring dequeue ptr:
[  296.040211] xhci_hcd 0000:03:00.0: @cf4395e0 cf46e4e0 00000000 01000000 01048001
[  296.040216] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900058ac024, 32'h8, 4'hf);
[  296.040222] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900058ac620, 32'h3, 4'hf);
[  296.040228] xhci_hcd 0000:03:00.0: In xhci_handle_event
[  296.040231] xhci_hcd 0000:03:00.0: xhci_handle_event - OS owns TRB
[  296.040234] xhci_hcd 0000:03:00.0: xhci_handle_event - calling handle_tx_event
[  296.040237] xhci_hcd 0000:03:00.0: In handle_tx_event
[  296.040240] xhci_hcd 0000:03:00.0: handle_tx_event - ep index = 3
[  296.040243] xhci_hcd 0000:03:00.0: handle_tx_event - checking for list empty
[  296.040246] xhci_hcd 0000:03:00.0: handle_tx_event - getting list entry
[  296.040249] xhci_hcd 0000:03:00.0: handle_tx_event - looking for TD
[  296.040253] xhci_hcd 0000:03:00.0: handle_tx_event - found event_seg = ffff880225d66c40
[  296.040256] xhci_hcd 0000:03:00.0: Event TRB with TRB type ID 32
[  296.040259] xhci_hcd 0000:03:00.0: Offset 0x00 (buffer lo) = 0xcf46e4e0
[  296.040262] xhci_hcd 0000:03:00.0: Offset 0x04 (buffer hi) = 0x0
[  296.040266] xhci_hcd 0000:03:00.0: Offset 0x08 (transfer length) = 0x1000000
[  296.040269] xhci_hcd 0000:03:00.0: Offset 0x0C (flags) = 0x1048001
[  296.040272] xhci_hcd 0000:03:00.0: Successful bulk transfer!
[  296.040275] usb 10-2: ep 0x2 - asked for 31 bytes, 0 bytes untransferred
[  296.040279] xhci_hcd 0000:03:00.0: Ring deq = 0xcf46e4f0 (DMA)
[  296.040282] xhci_hcd 0000:03:00.0: Event ring deq = 0xcf4395f0 (DMA)
[  296.040288] xhci_hcd 0000:03:00.0: // Write event ring dequeue pointer, preserving EHB bit
[  296.040292] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc900058ac638, 64'hcf4395f0, 4'hf);
[  296.040297] xhci_hcd 0000:03:00.0: Giveback URB ffff8801fe851b40, len = 31, status = 0
[  296.040302] xhci_hcd 0000:03:00.0: xhci_handle_event - returned from handle_tx_event
[  296.040306] xhci_hcd 0000:03:00.0: In xhci_handle_event
[  296.040312] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc900058ac638, 64'hcf4395f8, 4'hf);
[  296.040322] usb-storage: Status code 0; transferred 31/31
[  296.040324] usb-storage: -- transfer complete
[  296.040326] usb-storage: Bulk command transfer result=0
[  296.040330] usb-storage: usb_stor_bulk_transfer_sglist: xfer 4096 bytes, 1 entries
[  296.040335] xhci_hcd 0000:03:00.0: count sg list trbs: 
[  296.040339] xhci_hcd 0000:03:00.0:  sg #0: dma = 0x23bc6800, len = 0x1000 (4096), num_trbs = 1
[  296.040343] xhci_hcd 0000:03:00.0: 
[  296.040346] usb 10-2: ep 0x81 - urb len = 4096, sglist used, num_trbs = 1
[  296.040349] xhci_hcd 0000:03:00.0: Endpoint state = 0x1
[  296.040352] xhci_hcd 0000:03:00.0: First length to xfer from 1st sglist entry = 4096
[  296.040357] xhci_hcd 0000:03:00.0:  sg entry: dma = 0x23bc6800, len = 0x1000 (4096), 64KB boundary at 0x23bd0000, end dma = 0x23bc7800
[  296.040361] xhci_hcd 0000:03:00.0: Ring enq = 0xcf46e190 (DMA)
[  296.040367] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900058ac804, 32'h3, 4'hf);
[  296.047358] xhci_hcd 0000:03:00.0: op reg status = 00000008
[  296.047362] xhci_hcd 0000:03:00.0: ir set irq_pending = 00000003
[  296.047364] xhci_hcd 0000:03:00.0: Event ring dequeue ptr:
[  296.047368] xhci_hcd 0000:03:00.0: @cf4395f0 cf46e180 00000000 01000000 01038001
[  296.047374] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900058ac024, 32'h8, 4'hf);
[  296.047380] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900058ac620, 32'h3, 4'hf);
[  296.047385] xhci_hcd 0000:03:00.0: In xhci_handle_event
[  296.047388] xhci_hcd 0000:03:00.0: xhci_handle_event - OS owns TRB
[  296.047391] xhci_hcd 0000:03:00.0: xhci_handle_event - calling handle_tx_event
[  296.047394] xhci_hcd 0000:03:00.0: In handle_tx_event
[  296.047397] xhci_hcd 0000:03:00.0: handle_tx_event - ep index = 2
[  296.047400] xhci_hcd 0000:03:00.0: handle_tx_event - checking for list empty
[  296.047404] xhci_hcd 0000:03:00.0: handle_tx_event - getting list entry
[  296.047407] xhci_hcd 0000:03:00.0: handle_tx_event - looking for TD
[  296.047410] xhci_hcd 0000:03:00.0: handle_tx_event - found event_seg = ffff880225d66e00
[  296.047414] xhci_hcd 0000:03:00.0: Event TRB with TRB type ID 32
[  296.047417] xhci_hcd 0000:03:00.0: Offset 0x00 (buffer lo) = 0xcf46e180
[  296.047420] xhci_hcd 0000:03:00.0: Offset 0x04 (buffer hi) = 0x0
[  296.047423] xhci_hcd 0000:03:00.0: Offset 0x08 (transfer length) = 0x1000000
[  296.047426] xhci_hcd 0000:03:00.0: Offset 0x0C (flags) = 0x1038001
[  296.047429] xhci_hcd 0000:03:00.0: Successful bulk transfer!
[  296.047433] usb 10-2: ep 0x81 - asked for 4096 bytes, 0 bytes untransferred
[  296.047436] xhci_hcd 0000:03:00.0: Ring deq = 0xcf46e190 (DMA)
[  296.047440] xhci_hcd 0000:03:00.0: Event ring deq = 0xcf439600 (DMA)
[  296.047446] xhci_hcd 0000:03:00.0: // Write event ring dequeue pointer, preserving EHB bit
[  296.047450] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc900058ac638, 64'hcf439600, 4'hf);
[  296.047454] xhci_hcd 0000:03:00.0: Giveback URB ffff8801ed927000, len = 4096, status = 0
[  296.047460] xhci_hcd 0000:03:00.0: xhci_handle_event - returned from handle_tx_event
[  296.047463] xhci_hcd 0000:03:00.0: In xhci_handle_event
[  296.047470] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc900058ac638, 64'hcf439608, 4'hf);
[  296.047482] usb-storage: Status code 0; transferred 4096/4096
[  296.047484] usb-storage: -- transfer complete
[  296.047486] usb-storage: Bulk data transfer result 0x0
[  296.047489] usb-storage: Attempting to get CSW...
[  296.047491] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
[  296.047496] usb 10-2: ep 0x81 - urb len = 0xd (13), addr = 0xcf4c7000, num_trbs = 1
[  296.047500] xhci_hcd 0000:03:00.0: Endpoint state = 0x1
[  296.047503] xhci_hcd 0000:03:00.0: Ring enq = 0xcf46e1a0 (DMA)
[  296.047508] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900058ac804, 32'h3, 4'hf);
[  296.047532] xhci_hcd 0000:03:00.0: op reg status = 00000008
[  296.047535] xhci_hcd 0000:03:00.0: ir set irq_pending = 00000003
[  296.047538] xhci_hcd 0000:03:00.0: Event ring dequeue ptr:
[  296.047541] xhci_hcd 0000:03:00.0: @cf439600 cf46e190 00000000 01000000 01038001
[  296.047547] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900058ac024, 32'h8, 4'hf);
[  296.047553] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900058ac620, 32'h3, 4'hf);
[  296.047558] xhci_hcd 0000:03:00.0: In xhci_handle_event
[  296.047561] xhci_hcd 0000:03:00.0: xhci_handle_event - OS owns TRB
[  296.047564] xhci_hcd 0000:03:00.0: xhci_handle_event - calling handle_tx_event
[  296.047567] xhci_hcd 0000:03:00.0: In handle_tx_event
[  296.047570] xhci_hcd 0000:03:00.0: handle_tx_event - ep index = 2
[  296.047573] xhci_hcd 0000:03:00.0: handle_tx_event - checking for list empty
[  296.047576] xhci_hcd 0000:03:00.0: handle_tx_event - getting list entry
[  296.047579] xhci_hcd 0000:03:00.0: handle_tx_event - looking for TD
[  296.047583] xhci_hcd 0000:03:00.0: handle_tx_event - found event_seg = ffff880225d66e00
[  296.047586] xhci_hcd 0000:03:00.0: Event TRB with TRB type ID 32
[  296.047589] xhci_hcd 0000:03:00.0: Offset 0x00 (buffer lo) = 0xcf46e190
[  296.047592] xhci_hcd 0000:03:00.0: Offset 0x04 (buffer hi) = 0x0
[  296.047596] xhci_hcd 0000:03:00.0: Offset 0x08 (transfer length) = 0x1000000
[  296.047599] xhci_hcd 0000:03:00.0: Offset 0x0C (flags) = 0x1038001
[  296.047602] xhci_hcd 0000:03:00.0: Successful bulk transfer!
[  296.047605] usb 10-2: ep 0x81 - asked for 13 bytes, 0 bytes untransferred
[  296.047608] xhci_hcd 0000:03:00.0: Ring deq = 0xcf46e1a0 (DMA)
[  296.047611] xhci_hcd 0000:03:00.0: Event ring deq = 0xcf439610 (DMA)
[  296.047618] xhci_hcd 0000:03:00.0: // Write event ring dequeue pointer, preserving EHB bit
[  296.047622] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc900058ac638, 64'hcf439610, 4'hf);
[  296.047626] xhci_hcd 0000:03:00.0: Giveback URB ffff8801fe851b40, len = 13, status = 0
[  296.047631] xhci_hcd 0000:03:00.0: xhci_handle_event - returned from handle_tx_event
[  296.047634] xhci_hcd 0000:03:00.0: In xhci_handle_event
[  296.047641] xhci_hcd 0000:03:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc900058ac638, 64'hcf439618, 4'hf);
[  296.047649] usb-storage: Status code 0; transferred 13/13
[  296.047651] usb-storage: -- transfer complete
[  296.047654] usb-storage: Bulk status result = 0
[  296.047657] usb-storage: Bulk Status S 0x53425355 T 0x105 R 0 Stat 0x0
[  296.047660] usb-storage: scsi cmd done, result=0x0
[  296.047663] usb-storage: *** thread sleeping.

--------------030504080107080107040409--
