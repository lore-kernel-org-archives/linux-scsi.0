From: Konstantin Khorenko <khorenko@sw.ru>
Subject: [Fwd: New driver aacraid-1.1.5.2391 for kernels 2.4.x problem.]
Date: Fri, 01 Apr 2005 14:34:02 +0400
Message-ID: <424D239A.5020006@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:29195 "EHLO relay.sw.ru")
	by vger.kernel.org with ESMTP id S262694AbVDAKcM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2005 05:32:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
Cc: linux-scsi@vger.kernel.org, Vasily Averin <vvs@sw.ru>


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

P.S. the previous driver i use (1.1.4) worked fine compiled into the kernel.


Best regards,

Konstantin Khorenko
SWsoft, Inc.


