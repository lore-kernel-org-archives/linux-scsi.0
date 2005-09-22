From: "Juraj Hantak" <hantak@webglobe.sk>
Subject: aacraid bug?
Date: Thu, 22 Sep 2005 21:41:13 +0200 (CEST)
Message-ID: <3664.82.119.107.113.1127418073.squirrel@mail.wg.sk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.webglobe.sk ([217.67.22.78]:19634 "HELO
	mailhub.webglobe.sk") by vger.kernel.org with SMTP id S1030187AbVIVTlP
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Sep 2005 15:41:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

Yesterday I upgrade my box to newest latest stable kernel and after a time
I got an error from my raid 10 array:

After reboot the array was OK and the system is running  OK but how long?

Please give me an addvice what to do ;-)

Best Regards

Juraj Hantak


Kernel: latest stable: 2.6.13-2

dmesg:

Sep 22 12:22:25 mailhub kernel: Red Hat/Adaptec aacraid driver (1.1.2-lk2
Sep 20 2005)
Sep 22 12:22:25 mailhub kernel: ACPI: PCI Interrupt 0000:03:08.0[A] -> GSI
17 (level, low) -> IRQ 169
Sep 22 12:22:25 mailhub kernel: AAC0: kernel 4.2-0[7348]
Sep 22 12:22:25 mailhub kernel: AAC0: monitor 4.2-0[7348]
Sep 22 12:22:25 mailhub kernel: AAC0: bios 4.2-0[7348]
Sep 22 12:22:25 mailhub kernel: AAC0: serial c3c94b
Sep 22 12:22:25 mailhub kernel: scsi0 : aacraid
Sep 22 12:22:25 mailhub kernel: Vendor: ADAPTEC   Model: mailusers        
Rev: V1.0
Sep 22 12:22:25 mailhub kernel: Type:   Direct-Access                     
ANSI SCSI revision: 02


diagnostic dump text

        Remote Computer: .
             Device Name: AAC0
         Controller Type: Adaptec 2810SA
             Access Mode: READ-WRITE
Controller Serial Number: Last Six Digits = C3C94B
         Number of Buses: 1
         Devices per Bus: 15
Controller Physical Slot: 2
          Controller CPU: i960 series
    Controller CPU Speed: 100 Mhz
       Controller Memory: 64 Mbytes
           Battery State: Not Present

SYSLOG:
Sep 22 11:54:59 mailhub kernel: irq 169: nobody cared (try booting with
the "irqpoll" option)
Sep 22 11:54:59 mailhub kernel: [<c013a89a>] __report_bad_irq+0x2a/0xa0
Sep 22 11:54:59 mailhub kernel: [<c013a0e0>] handle_IRQ_event+0x30/0x70
Sep 22 11:54:59 mailhub kernel: [<c013a9b0>] note_interrupt+0x80/0xf0
Sep 22 11:54:59 mailhub kernel: [<c013a23b>] __do_IRQ+0x11b/0x120
Sep 22 11:54:59 mailhub kernel: [<c01056e9>] do_IRQ+0x19/0x30
Sep 22 11:54:59 mailhub kernel: [<c0103a2e>] common_interrupt+0x1a/0x20
Sep 22 11:54:59 mailhub kernel: handlers:
Sep 22 11:54:59 mailhub kernel: [<c02e4b20>] (aac_rx_intr+0x0/0xf0)
Sep 22 11:54:59 mailhub kernel: [<c0281fe0>] (e1000_intr+0x0/0x130)
Sep 22 11:54:59 mailhub kernel: Disabling IRQ #169
Sep 22 11:55:30 mailhub kernel: aacraid: Host adapter reset request. SCSI
hang ?
Sep 22 11:56:30 mailhub kernel: aacraid: SCSI bus appears hung
Sep 22 11:56:30 mailhub kernel: scsi: Device offlined - not ready after
error recovery: host 0 channel 0 id 0 lun 0
Sep 22 11:56:30 mailhub kernel: SCSI error : <0 0 0 0> return code =
0x6000000
Sep 22 11:56:30 mailhub kernel: end_request: I/O error, dev sda, sector
1056492327
Sep 22 11:56:30 mailhub kernel: Buffer I/O error on device sda1, logical
block 132061533
Sep 22 11:56:30 mailhub kernel: lost page write due to I/O error on sda1
Sep 22 11:56:30 mailhub kernel: scsi0 (0:0): rejecting I/O to offline device
Sep 22 11:56:30 mailhub kernel: EXT3-fs error (device sda1): ext3_readdir:
directory #29492069 contains a hole at offset 0
Sep 22 11:56:30 mailhub kernel: Aborting journal on device sda1.
Sep 22 11:56:30 mailhub kernel: scsi0 (0:0): rejecting I/O to offline device
Sep 22 11:56:30 mailhub kernel: Buffer I/O error on device sda1, logical
block 128235520
Sep 22 11:56:30 mailhub kernel: lost page write due to I/O error on sda1
Sep 22 11:56:30 mailhub kernel: scsi0 (0:0): rejecting I/O to offline device
Sep 22 11:56:30 mailhub kernel: Buffer I/O error on device sda1, logical
block 132030489
Sep 22 11:56:30 mailhub kernel: lost page write due to I/O error on sda1



