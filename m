From: philhh <philhh@wanadoo.fr>
Subject: problem kernel 2.6.7, sym53c8xx and tekram dc390F
Date: Sun, 25 Jul 2004 09:34:33 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040725093433.330a190f.philhh@wanadoo.fr>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Sun__25_Jul_2004_09_34_33_+0200_w2XZJA6IC=CkaYL8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp3.wanadoo.fr ([193.252.22.28]:18730 "EHLO
	mwinf0303.wanadoo.fr") by vger.kernel.org with ESMTP
	id S263735AbUGYHbo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 Jul 2004 03:31:44 -0400
List-Id: linux-scsi@vger.kernel.org
To: linuxkernel_sym53c8xx <matthew@wil.cx>, linuxkernel_sym53c8xx <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.

--Multipart=_Sun__25_Jul_2004_09_34_33_+0200_w2XZJA6IC=CkaYL8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi
I use epson scanner 1640 SU + tekram DC390F. I compiled 2.6.7 kernel souces from  kernel.org.
All is fine with kernel 2.4.26 and sym53c8xx.
Sym53c8xx doesn't work on my kernel 2.6.7. May be you 'll find the answer in the boot log . I just get a red led on the scanner ! I tried options kernel 'verbose scsi error reporting' and 'scsi logging facility' and I didn't find any explaination about the problem. I tried to reload 'sym53c8xx' after the boot : nothing;
I tried to load 'sg' module : nothing .
I hope you find a solution to this problem. 
Thank you for your developping work.
Philippe 

My configuration:
Debian testing gcc-3.3.4-1 




--Multipart=_Sun__25_Jul_2004_09_34_33_+0200_w2XZJA6IC=CkaYL8
Content-Type: text/plain;
 name="syslog_sym53c8xx.txt"
Content-Disposition: attachment;
 filename="syslog_sym53c8xx.txt"
Content-Transfer-Encoding: 7bit


Jul 24 18:47:33 salix kernel: sym0: detaching ...
Jul 24 18:47:33 salix kernel: sym0: resetting chip
Jul 24 18:48:07 salix kernel: sym0: <875> rev 0x26 at pci 0000:01:09.0 irq 5
Jul 24 18:48:07 salix kernel: sym0: Tekram NVRAM, ID 7, Fast-20, SE, parity checking
Jul 24 18:48:07 salix kernel: sym0: SCSI BUS has been reset.
Jul 24 18:48:07 salix kernel: scsi1 : sym-2.1.18j
Jul 24 18:48:11 salix kernel:   Vendor: EPSON     Model: Perfection1640    Rev: 1.04
Jul 24 18:48:11 salix kernel:   Type:   Processor                          ANSI SCSI revision: 02
Jul 24 18:48:11 salix kernel: scsi(1:0:2:0): Beginning Domain Validation
Jul 24 18:48:11 salix kernel: sym0:2: FAST-10 SCSI 10.0 MB/s ST (100.0 ns, offset 15)
Jul 24 18:48:11 salix kernel: scsi(1:0:2:0): Echo buffer size 6370 is too big, trimming to 4096
Jul 24 18:48:11 salix kernel: scsi(1:0:2:0): Domain Validation detected failure, dropping back
Jul 24 18:48:11 salix kernel: sym0:2: FAST-10 SCSI 6.8 MB/s ST (148.0 ns, offset 15)
Jul 24 18:48:11 salix kernel: scsi(1:0:2:0): Domain Validation detected failure, dropping back
Jul 24 18:48:11 salix kernel: sym0:2: asynchronous.
Jul 24 18:48:21 salix kernel: sym0:2:0: ABORT operation started.
Jul 24 18:48:26 salix kernel: sym0:2:0: ABORT operation timed-out.
Jul 24 18:48:26 salix kernel: sym0:2:0: DEVICE RESET operation started.
Jul 24 18:48:30 salix kernel: sym0: unexpected disconnect
Jul 24 18:48:30 salix kernel: sym0:2:0: DEVICE RESET operation complete.
Jul 24 18:48:30 salix kernel: sym0: SCSI BUS reset detected.
Jul 24 18:48:30 salix kernel: sym0: SCSI BUS has been reset.
Jul 24 18:48:30 salix kernel: sym0:2:0: BUS RESET operation started.
Jul 24 18:48:30 salix kernel: sym0:2:0: BUS RESET operation complete.
Jul 24 18:48:30 salix kernel: sym0: SCSI BUS reset detected.
Jul 24 18:48:30 salix kernel: sym0: SCSI BUS has been reset.
Jul 24 18:48:40 salix kernel: sym0:2:0: HOST RESET operation started.
Jul 24 18:48:40 salix kernel: sym0: SCSI BUS has been reset.
Jul 24 18:48:40 salix kernel: sym0:2:0: HOST RESET operation complete.
Jul 24 18:48:51 salix kernel: scsi: Device offlined - not ready after error recovery: host 1 channel 0 id 2 lun 0
Jul 24 18:48:51 salix kernel: scsi(1:0:2:0): Write Buffer failure 100ff
Jul 24 18:48:51 salix kernel: scsi(1:0:2:0): Domain Validation detected failure, dropping back
Jul 24 18:48:51 salix kernel: scsi(1:0:2:0): Write Buffer failure 100ff
Jul 24 18:48:51 salix kernel: scsi(1:0:2:0): Domain Validation Failure, dropping back to Asynchronous
Jul 24 18:48:51 salix kernel: scsi(1:0:2:0): Ending Domain Validation
Jul 24 18:48:51 salix kernel:   Vendor: PLEXTOR   Model: CD-ROM PX-40TS    Rev: 1.12
Jul 24 18:48:51 salix kernel:   Type:   CD-ROM                             ANSI SCSI revision: 02
Jul 24 18:48:51 salix kernel: scsi(1:0:3:0): Beginning Domain Validation
Jul 24 18:48:51 salix kernel: sym0:3: FAST-20 SCSI 20.0 MB/s ST (50.0 ns, offset 15)
Jul 24 18:48:51 salix kernel: scsi(1:0:3:0): Domain Validation skipping write tests
Jul 24 18:48:51 salix kernel: scsi(1:0:3:0): Ending Domain Validation
Jul 24 18:48:51 salix kernel: sr0: scsi-1 drive
Jul 24 18:48:51 salix kernel: Attached scsi CD-ROM sr0 at scsi1, channel 0, id 3, lun 0
Jul 24 18:48:51 salix kernel:   Vendor: PLEXTOR   Model: CD-R   PX-W1210S  Rev: 1.01
Jul 24 18:48:51 salix kernel:   Type:   CD-ROM                             ANSI SCSI revision: 02
Jul 24 18:48:51 salix kernel: scsi(1:0:4:0): Beginning Domain Validation
Jul 24 18:48:51 salix kernel: sym0:4: FAST-20 SCSI 20.0 MB/s ST (50.0 ns, offset 16)
Jul 24 18:48:51 salix kernel: scsi(1:0:4:0): Domain Validation skipping write tests
Jul 24 18:48:51 salix kernel: scsi(1:0:4:0): Ending Domain Validation
Jul 24 18:48:51 salix kernel: sr1: scsi3-mmc drive: 32x/32x writer cd/rw xa/form2 cdda tray
Jul 24 18:48:51 salix kernel: Attached scsi CD-ROM sr1 at scsi1, channel 0, id 4, lun 0
Jul 24 18:50:16 salix kernel: sym0: detaching ...
Jul 24 18:50:16 salix kernel: sym0: resetting chip
Jul 24 18:50:30 salix kernel: sym0: <875> rev 0x26 at pci 0000:01:09.0 irq 5
Jul 24 18:50:30 salix kernel: sym0: Tekram NVRAM, ID 7, Fast-20, SE, parity checking
Jul 24 18:50:30 salix kernel: sym0: SCSI BUS has been reset.
Jul 24 18:50:30 salix kernel: scsi2 : sym-2.1.18j
Jul 24 18:50:34 salix kernel:   Vendor: EPSON     Model: Perfection1640    Rev: 1.04
Jul 24 18:50:34 salix kernel:   Type:   Processor                          ANSI SCSI revision: 02
Jul 24 18:50:34 salix kernel: scsi(2:0:2:0): Beginning Domain Validation
Jul 24 18:50:34 salix kernel: sym0:2: FAST-10 SCSI 10.0 MB/s ST (100.0 ns, offset 15)
Jul 24 18:50:34 salix kernel: scsi(2:0:2:0): Domain Validation skipping write tests
Jul 24 18:50:34 salix kernel: scsi(2:0:2:0): Ending Domain Validation
Jul 24 18:50:34 salix kernel:   Vendor: PLEXTOR   Model: CD-ROM PX-40TS    Rev: 1.12
Jul 24 18:50:34 salix kernel:   Type:   CD-ROM                             ANSI SCSI revision: 02
Jul 24 18:50:34 salix kernel: scsi(2:0:3:0): Beginning Domain Validation
Jul 24 18:50:34 salix kernel: sym0:3: FAST-20 SCSI 20.0 MB/s ST (50.0 ns, offset 15)
Jul 24 18:50:34 salix kernel: scsi(2:0:3:0): Domain Validation skipping write tests
Jul 24 18:50:34 salix kernel: scsi(2:0:3:0): Ending Domain Validation
Jul 24 18:50:34 salix kernel: sr0: scsi-1 drive
Jul 24 18:50:34 salix kernel: Attached scsi CD-ROM sr0 at scsi2, channel 0, id 3, lun 0
Jul 24 18:50:34 salix kernel:   Vendor: PLEXTOR   Model: CD-R   PX-W1210S  Rev: 1.01
Jul 24 18:50:34 salix kernel:   Type:   CD-ROM                             ANSI SCSI revision: 02
Jul 24 18:50:34 salix kernel: scsi(2:0:4:0): Beginning Domain Validation
Jul 24 18:50:34 salix kernel: sym0:4: FAST-20 SCSI 20.0 MB/s ST (50.0 ns, offset 16)
Jul 24 18:50:34 salix kernel: scsi(2:0:4:0): Domain Validation skipping write tests
Jul 24 18:50:34 salix kernel: scsi(2:0:4:0): Ending Domain Validation
Jul 24 18:50:34 salix kernel: sr1: scsi3-mmc drive: 32x/32x writer cd/rw xa/form2 cdda tray
Jul 24 18:50:34 salix kernel: Attached scsi CD-ROM sr1 at scsi2, channel 0, id 4, lun 0
Jul 24 19:06:09 salix -- MARK --





--Multipart=_Sun__25_Jul_2004_09_34_33_+0200_w2XZJA6IC=CkaYL8--
