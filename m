From: Jeff Garzik <jgarzik@pobox.com>
Subject: SCSI breaks 'make allyesconfig'
Date: Wed, 17 Nov 2004 08:30:58 -0500
Message-ID: <419B5292.7080305@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:46807 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262316AbUKQNbR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Nov 2004 08:31:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Latest -bk:

[jgarzik@pretzel linux-2.6]$ make
   CHK     include/linux/version.h
make[1]: `arch/i386/kernel/asm-offsets.s' is up to date.
   CHK     include/linux/compile.h
   CHK     usr/initramfs_list
   LD      drivers/scsi/built-in.o
drivers/scsi/osst.o(.bss+0x0): In function `exit_osst':
drivers/scsi/osst.c:195: multiple definition of `ST_partstat'
drivers/scsi/st.o(.bss+0x0):drivers/scsi/st.c:244: first defined here
make[2]: *** [drivers/scsi/built-in.o] Error 1
make[1]: *** [drivers/scsi] Error 2
make: *** [drivers] Error 2

