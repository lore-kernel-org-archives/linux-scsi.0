From: Christoph Hellwig <hch@lst.de>
Subject: [rant] can we get asane ic7xxx/79xx probing _please_
Date: Mon, 6 Sep 2004 20:24:02 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040906182402.GA25103@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:27272 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S268448AbUIFSYG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2004 14:24:06 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: luben_tuikov@adaptec.com
Cc: linux-scsi@vger.kernel.org

Sorry to complain to you for Justins mess, but could you please fixup
the damn pci probing?  Andi sent you a patch to add proper pci tables,
and not ignoring the pci_module_init retval would be trivial if the
module initialization wasn't split over three routines.

Curretly hotplug loads the adaptec drivers for every PCI scsi adapter
in the system, see

	http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=270102

for details
