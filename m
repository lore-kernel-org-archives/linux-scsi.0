From: "James" <jdaniel@dakotacom.net>
Subject: Initio 9100 Ultra Driver -- Compiler Errors
Date: Tue, 9 Dec 2003 11:40:02 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <003001c3be83$dbb521a0$0200000a@nightsky>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from breaker.dakotacom.net ([66.192.152.146]:27824 "EHLO
	breaker.dakotacom.net") by vger.kernel.org with ESMTP
	id S266056AbTLISjw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Dec 2003 13:39:52 -0500
Received: from nightsky (smurf@ip09.nen01.tus.dakotacom.net [208.1.28.10])
	by breaker.dakotacom.net (8.12.2/x.y.z) with SMTP id hB9Idvxc022699
	for <linux-scsi@vger.kernel.org>; Tue, 9 Dec 2003 11:39:57 -0700 (MST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

These appear to be an extension of the errors someone had mailed the list
about back in
MAY 2002! Is anyone going to fix this before 2.6.0 is released? Kinda short
on time here,
and I would love to actually be able to compile the kernel when it's
released as "stable"...

  CC      drivers/scsi/ini9100u.o
drivers/scsi/ini9100u.c:111:2: #error Please convert me to
Documentation/DMA-mapping.txt
drivers/scsi/ini9100u.c:146: warning: initialization from incompatible
pointer type
drivers/scsi/ini9100u.c:151: warning: initialization from incompatible
pointer type
drivers/scsi/ini9100u.c:152: warning: initialization from incompatible
pointer type
drivers/scsi/ini9100u.c: In function `i91uAppendSRBToQueue':
drivers/scsi/ini9100u.c:241: structure has no member named `next'
drivers/scsi/ini9100u.c:246: structure has no member named `next'
drivers/scsi/ini9100u.c: In function `i91uPopSRBFromQueue':
drivers/scsi/ini9100u.c:268: structure has no member named `next'
drivers/scsi/ini9100u.c:269: structure has no member named `next'
drivers/scsi/ini9100u.c: In function `i91uBuildSCB':
drivers/scsi/ini9100u.c:507: structure has no member named `address'
drivers/scsi/ini9100u.c:516: structure has no member named `address'
make[2]: *** [drivers/scsi/ini9100u.o] Error 1
make[1]: *** [drivers/scsi] Error 2
make: *** [drivers] Error 2


