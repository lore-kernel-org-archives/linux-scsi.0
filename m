From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: rootfs on sda & async scan?
Date: Sun, 17 Jun 2007 00:42:44 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0706170035450.3805@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:42016 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756399AbXFPWmo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 16 Jun 2007 18:42:44 -0400
Received: from lyakh (helo=localhost)
	by poirot.grange with local-esmtp (Exim 3.36 #1 (Debian))
	id 1Hzgyi-0000HE-00
	for <linux-scsi@vger.kernel.org>; Sun, 17 Jun 2007 00:42:44 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi

This is a basic confusion: if I read kernel config help to SCSI_SCAN_ASYNC 
correctly "If you build your SCSI drivers into the kernel, then everything         
will work fine if you say Y here." means I can have async "on" and root on 
sd* as long as the respective ldd is linked into the kernel. Now, this 
just didn't work for me under 2.6.22-rc3-... (scsi-misc-2.6) with 
sym53c8xx_2. I'd expected it would let scan run asynchronously, but wait 
as long as root on an sd* is requested. Do I understand it wrong or is 
this a bug somewhere. I also have 2 more ldd's compiled as modules.

Thanks
Guennadi
---
Guennadi Liakhovetski
