From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [Fwd: New driver aacraid-1.1.5.2391 for kernels 2.4.x problem.]
Date: Fri, 1 Apr 2005 08:21:30 -0500
Message-ID: <60807403EABEB443939A5A7AA8A7458BFF1788@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:48321 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261750AbVDANVg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Apr 2005 08:21:36 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Konstantin Khorenko <khorenko@sw.ru>
Cc: linux-scsi@vger.kernel.org, Vasily Averin <vvs@sw.ru>

A recent patch to linit.c:

         error = pci_register_driver(&aac_pci_driver);
-        if (error)
+        if (error < 0)
                 return error;

Sincerely -- Mark Salyzyn

-----Original Message-----
From: Konstantin Khorenko [mailto:khorenko@sw.ru] 
Sent: Friday, April 01, 2005 5:34 AM
To: Salyzyn, Mark
Cc: linux-scsi@vger.kernel.org; Vasily Averin
Subject: [Fwd: New driver aacraid-1.1.5.2391 for kernels 2.4.x problem.]


    Hello!

It seems to me that card initialization is broken in new driver
aacraid-1.1.5.2391.
The problem arises on Linux kernels 2.4.x, if the driver is compiled
into the kernel.

In that case kernel doesn't find root device to mount, if it locates on
a disk, connected to adaptec scsi controller.
(Card finds the controller, but finds out no devices on it.)

In the case the driver is compiled as a module, it works fine (at the
first glance).

Please, could you find out what the problem is?

P.S. the previous driver i use (1.1.4) worked fine compiled into the
kernel.


Best regards,

Konstantin Khorenko
SWsoft, Inc.


