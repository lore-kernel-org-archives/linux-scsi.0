From: Russell Coker <russell@coker.com.au>
Subject: 2.5.56 aha1542 driver
Date: Sat, 11 Jan 2003 18:39:34 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200301111839.34330.russell@coker.com.au>
Reply-To: Russell Coker <russell@coker.com.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lyta.coker.com.au (localhost [127.0.0.1])
	by tsv.sws.net.au (Postfix) with ESMTP id 4F62792732
	for <linux-scsi@vger.kernel.org>; Sun, 12 Jan 2003 04:39:47 +1100 (EST)
Received: from localhost (localhost [127.0.0.1])
	by lyta.coker.com.au (Postfix) with ESMTP id EE476785A
	for <linux-scsi@vger.kernel.org>; Sat, 11 Jan 2003 18:39:34 +0100 (CET)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


If you have CONFIG_SCSI_AHA1542 enabled but don't have ISA PNP enabled then
the kernel won't compile:
drivers/scsi/aha1542.c: In function `aha1542_detect':
drivers/scsi/aha1542.c:1152: warning: implicit declaration of function
`isapnp_find_dev'
drivers/scsi/aha1542.c:1153: warning: assignment makes pointer from integer
without a cast
drivers/scsi/aha1542.c:1160: structure has no member named `prepare'
drivers/scsi/aha1542.c:1168: structure has no member named `activate'
make[2]: *** [drivers/scsi/aha1542.o] Error 1

In 2.4.x kernels you could compile it with such options.  Ideally in 2.5.x it
would still be possible to compile such a configuration, but it would be OK
if the kernel configuration refused to allow AHA1542 to be supported without
ISAPNP.

-- 
http://www.coker.com.au/selinux/   My NSA Security Enhanced Linux packages
http://www.coker.com.au/bonnie++/  Bonnie++ hard drive benchmark
http://www.coker.com.au/postal/    Postal SMTP/POP benchmark
http://www.coker.com.au/~russell/  My home page

