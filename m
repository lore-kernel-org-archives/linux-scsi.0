From: James Beckett <jmb@xyzzy.demon.co.uk>
Subject: continuous "PCI error Interrupt" on Adaptec 29160
Date: Fri, 17 Jan 2003 03:04:49 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E2772D1.D9BD66C2@xyzzy.demon.co.uk>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------F9BAD2877319617906A1D30E"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xyzzy.demon.co.uk ([158.152.68.19])
	by anchor-post-34.mail.demon.net with esmtp (Exim 3.35 #1)
	id 18ZMoO-000Kme-0Y
	for linux-scsi@vger.kernel.org; Fri, 17 Jan 2003 03:04:53 +0000
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------F9BAD2877319617906A1D30E
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

I've found a couple of mentions of this in web/news searches but always as
an "occasional" error; I'm getting /continuous/ error interrupts at a
rate of 6-8 per second from when I `insmod aic7xxx` until I rmmod it.

	scsi0: PCI error Interrupt at seqaddr = 0x9
	scsi0: Data Parity Error Detected during address or write data phase

The seqaddr given always seems to be 8 or 9.

Just writing the syslog has a serious impact on the system.

There's no IRQ sharing, but I've tried the card in different slots anyway;
I've tried it without any devices connected (even cables); I've tried
changing the parity settings in the onboard BIOS screens - no change.
BIOS "PnP O/S" is "No".

Previous 2944UW had no problem.

Can anyone explain what's going on?

RedHat 8.0 (kernel-2.4.18)
aic7xxx 6.2.8
Adaptec 29160
Asus AX59Pro (VIA MPV3), lates rev bios

-- 
James Beckett
--------------F9BAD2877319617906A1D30E
Content-Type: text/plain; charset=us-ascii;
 name="scsi-log-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi-log-1"

Jan 16 03:44:48 xyzzy kernel: PCI: Enabling device 00:09.0 (0006 -> 0007)
Jan 16 03:44:48 xyzzy kernel: PCI: Found IRQ 12 for device 00:09.0
Jan 16 03:44:48 xyzzy kernel: scsi0: PCI error Interrupt at seqaddr = 0x8
Jan 16 03:44:48 xyzzy kernel: scsi0: Data Parity Error Detected during address or write data phase
Jan 16 03:44:48 xyzzy kernel: scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.8
Jan 16 03:44:48 xyzzy kernel:         <Adaptec 29160 Ultra160 SCSI adapter>
Jan 16 03:44:48 xyzzy kernel:         aic7892: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs
Jan 16 03:44:48 xyzzy kernel: 
Jan 16 03:44:48 xyzzy kernel: blk: queue c145ee14, I/O limit 4095Mb (mask 0xffffffff)
Jan 16 03:44:48 xyzzy kernel: scsi0: PCI error Interrupt at seqaddr = 0x9
Jan 16 03:44:48 xyzzy kernel: scsi0: Data Parity Error Detected during address or write data phase
Jan 16 03:44:48 xyzzy kernel: scsi0: PCI error Interrupt at seqaddr = 0x9
Jan 16 03:44:48 xyzzy kernel: scsi0: Data Parity Error Detected during address or write data phase
Jan 16 03:44:48 xyzzy kernel: scsi0: PCI error Interrupt at seqaddr = 0x9
Jan 16 03:44:48 xyzzy kernel: scsi0: Data Parity Error Detected during address or write data phase
Jan 16 03:44:48 xyzzy kernel: scsi0: PCI error Interrupt at seqaddr = 0x9
Jan 16 03:44:48 xyzzy kernel: scsi0: Data Parity Error Detected during address or write data phase
Jan 16 03:44:48 xyzzy kernel: scsi0: PCI error Interrupt at seqaddr = 0x9
Jan 16 03:44:48 xyzzy kernel: scsi0: Data Parity Error Detected during address or write data phase
Jan 16 03:44:48 xyzzy kernel: scsi0: PCI error Interrupt at seqaddr = 0x9
Jan 16 03:44:48 xyzzy kernel: scsi0: Data Parity Error Detected during address or write data phase


--------------F9BAD2877319617906A1D30E--

