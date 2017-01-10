From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 192281] New: support of USB controller: NEC Corporation
 uPD720200 USB 3.0 Host Controller (rev 03) (prog-if 30 [XHCI]) is broken
Date: Tue, 10 Jan 2017 22:10:25 +0000
Message-ID: <bug-192281-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:43998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755063AbdAJWK2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Jan 2017 17:10:28 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 9D4FB20263
        for <linux-scsi@vger.kernel.org>; Tue, 10 Jan 2017 22:10:26 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 940D52024C
        for <linux-scsi@vger.kernel.org>; Tue, 10 Jan 2017 22:10:25 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=192281

            Bug ID: 192281
           Summary: support of USB controller: NEC Corporation uPD720200
                    USB 3.0 Host Controller (rev 03) (prog-if 30 [XHCI])
                    is broken
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 4.4.0-58-generic
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: dbazim@gmail.com
        Regression: No

I have home on USB 3.0 box. If I use USB 3.0 connection the driver stopped to
respond to system soon after boot up. I see the following messages in log:
ata14.00: exception Emask 0x1 SAct 0x0 SErr 0x0 action 0x6
ata14.00: irq_stat 0x40000001
ata14.00 cmd a0/01:0000:00:01/00:00:00:00/a0 tag 1 dma 16640 in
         Inquiry 12 01 00 00 ff 00res 00/00:00:00:00:00/00:00:00:00:00/00 Emask
0x3 (HSM vilation)
ata14: hard resetting link
ata14: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata14.00 configured for UDMA/66
ata14: EH complete
scsi 13:0:0:0: Attached scsi generic sg3 type 3

sd 14:0:0:0: [sda] tag#4 CDB: Write(10) 2a 00 41 00 70 29 00 00 08 00
sd 14:0:0:0: [sda] tag#3 uas_eh_abort_handler 0 uas-tag 4 inflight:

scsi host144: uas_eh_bus_reset_handler start
usb 10-2: reset SuperSpeed USB device number 2 using xhci_hcd
scsi host14: uas_eh_bus_reset_handler success

usb10-2: cmd cmplt err -2

task rs:main Q:reg:1720 blocked for more then 120 seconds.
Tainted: P OE 4.4.0-58-generic #79-Ubuntu

blk_update_request: I/O error, dev sda, sector 1653898361
Buffer I/O error on dev sda3, logical block 70423762, lost async page write

usb 10-2: stat urb: no pending cmd for uas tag 7

-- 
You are receiving this mail because:
You are the assignee for the bug.
