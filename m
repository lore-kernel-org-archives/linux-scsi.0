From: Bill Judd <wbj@mac.com>
Subject: 2.4.20 scsi module build error?
Date: Thu, 24 Apr 2003 23:36:49 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <7911845.1051252609188.JavaMail.wbj@mac.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from A17-250-248-88.apple.com ([17.250.248.88]:45263 "EHLO
	smtpout.mac.com") by vger.kernel.org with ESMTP id S263050AbTDYGYj
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2003 02:24:39 -0400
Received: from webmail04.mac.com (webmail04-en1 [10.13.11.146])
	by smtpout.mac.com (Xserve/MantshX 2.0) with ESMTP id h3P6aniL012371
	for <linux-scsi@vger.kernel.org>; Thu, 24 Apr 2003 23:36:49 -0700 (PDT)
Received: from webmail04 (localhost [127.0.0.1])
	by webmail04.mac.com (8.12.2/8.12.2) with ESMTP id h3P6anJT008845
	for <linux-scsi@vger.kernel.org>; Thu, 24 Apr 2003 23:36:49 -0700 (PDT)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I'm running on a Red Hat 8.0 system.  I downloaded 2.4.20 kernel sources from www.kernel.org and proceeded to build the kernel.

While "making modules", I get this error:

make[2]: Entering directory `/usr/src/linux-2.4.20/drivers/scsi'
ld -m elf_i386 -r -o scsi_mod.o scsi.o hosts.o scsi_ioctl.o constants.o scsicam.o scsi_proc.o scsi_error.o scsi_obsolete.o scsi_queue.o scsi_lib.o scsi_merge.o
scsi_dma.o scsi_scan.o scsi_syms.o
ln -sf sim710.scr fake7.c
gcc -E -D__KERNEL__ -I/usr/src/linux-2.4.20/include -traditional -DCHIP=710 fake7.c | grep -v '^#' | perl -s script_asm.pl -ncr710
script_asm.pl : Illegal combination of registers in line 72 :   MOVE CTEST7 & 0xef TO CTEST7
        Either source and destination registers must be the same,
        or either source or destination register must be SFBR.
make[2]: *** [sim710_d.h] Error 255
make[2]: Leaving directory `/usr/src/linux-2.4.20/drivers/scsi'
make[1]: *** [_modsubdir_scsi] Error 2
make[1]: Leaving directory `/usr/src/linux-2.4.20/drivers'
make: *** [_mod_drivers] Error 2
[root@localhost linux-2.4.20]#

Thanks for info on what's going on.

Best regards,

Bill Judd
