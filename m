From: Viktor Hornak <hornak@csb.sunysb.edu>
Subject: limit on size of a SCSI drive?
Date: 27 Mar 2003 12:14:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1048785293.26909.49.camel@frodo.bio.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from frodo.bio.sunysb.edu (frodo.bio.sunysb.edu [129.49.94.57])
	by ilion.bio.sunysb.edu (SGI-8.12.5/8.12.5) with ESMTP id h2RHT6Ud398173
	for <linux-scsi@vger.kernel.org>; Thu, 27 Mar 2003 12:29:06 -0500 (EST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I was wondering if someone could help with the following issue. We are
planning to buy a Promise UltraTrak SX8000 drive enclosure, which can
hold up to 8 IDE disks. The UltraTrak presents itself as a single SCSI
drive. With the disks we are planning to buy, the size of this 'fake'
SCSI drive would be about 2.1TB! Now, my question is if SCSI module or
linux kernel have any limitations on a size of a single SCSI drive, i.e.
if we will have troubles to get such a monstrous SCSI drive running. We
are using RedHat Linux 7.3 with kernel 2.4.18 (we can upgrade to newer
kernel if that would solve the potential problem though).

Please respond to my e-mail address because I am not a regular member of
the SCSI reflector.

Many thanks,

-Viktor


