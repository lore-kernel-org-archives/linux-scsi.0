From: Adrian Bunk <bunk@fs.tum.de>
Subject: 2.6: SCSI advansys.c doesn't compilefor !PCI
Date: Thu, 13 May 2004 00:52:54 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040512225254.GA21408@fs.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hermes.fachschaften.tu-muenchen.de ([129.187.202.12]:65238 "HELO
	hermes.fachschaften.tu-muenchen.de") by vger.kernel.org with SMTP
	id S262996AbUELWxD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 May 2004 18:53:03 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: support@connectcom.net
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

I got the following compile error in 2.6.6-mm1 (but it doesn't seem to 
be specific to -mm) with CONFIG_PCI=n:

<--   snip  -->

...
  CC      drivers/scsi/advansys.o
drivers/scsi/advansys.c: In function `advansys_detect':
drivers/scsi/advansys.c:4770: error: `pci_devp' undeclared (first use in this function)
drivers/scsi/advansys.c:4770: error: (Each undeclared identifier is reported only once
drivers/scsi/advansys.c:4770: error: for each function it appears in.)
drivers/scsi/advansys.c: In function `DvcAdvWritePCIConfigByte':
drivers/scsi/advansys.c:9154: warning: `return' with a value, in function returning void
drivers/scsi/advansys.c: In function `AscInitFromAscDvcVar':
drivers/scsi/advansys.c:12306: error: dereferencing pointer to incomplete type
make[2]: *** [drivers/scsi/advansys.o] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

