From: "Jeffrey W. Baker" <jwbaker@acm.org>
Subject: aic79xx: are these hardware or software errors?
Date: Tue, 10 Feb 2004 12:48:38 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1076446118.2154.2.camel@heat>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [65.198.37.67] ([65.198.37.67]:64188 "EHLO gghcwest.com")
	by vger.kernel.org with ESMTP id S265636AbUBJUsp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Feb 2004 15:48:45 -0500
Received: from pc105.gghcwest.com (pc105.gghcwest.com [192.168.168.105])
	by gghcwest.com (8.12.10/8.12.9) with ESMTP id i1AKmaXA018144
	for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2004 12:48:42 -0800
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I believe these indicate problems with our SCSI hardware or bus, and are
not problems with the kernel or driver.  Correct?

scsi0:0:0:0: Attempting to abort cmd f77e1e00: 0x28 0x0 0x6 0x85 0x29 0x2f 0x0 0x0 0x50 0x0
scsi0:0:0:0: Command not found
scsi0:0:0:0: Attempting to abort cmd f77e2000: 0x28 0x0 0x6 0x85 0x29 0x7f 0x0 0x0 0x10 0x0
scsi0:0:0:0: Command not found
scsi0:0:0:0: Attempting to abort cmd f77e2200: 0x28 0x0 0x6 0x85 0x29 0x8f 0x0 0x0 0x10 0x0
scsi0:0:0:0: Command not found
scsi0:0:0:0: Attempting to abort cmd f77e2400: 0x28 0x0 0x6 0x85 0x29 0x9f 0x0 0x0 0x8 0x0
scsi0:0:0:0: Command not found
scsi0:0:0:0: Attempting to abort cmd f77e2600: 0x28 0x0 0x6 0x85 0x29 0xa7 0x0 0x0 0x20 0x0
scsi0:0:0:0: Command not found

Our SCSI bus currently consists of one Adaptec 39320D PCI-X HBA with one
RAID controller attached to it on channel A.  Kernel is 2.4.25-rc1 with
aic79xx driver 1.3.10.  It's a pretty simple setup that we're trying to
diagnose.

-jwb

