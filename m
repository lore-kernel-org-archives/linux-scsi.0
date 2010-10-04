From: Andreas Moroder <andreas.moroder@sb-brixen.it>
Subject: raidutil: logical device created, how to add it to linux
Date: Mon, 04 Oct 2010 20:22:07 +0200
Message-ID: <i8d60f$4ke$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:43283 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755256Ab0JDSWQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Oct 2010 14:22:16 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1P2pfy-0002tx-LC
	for linux-scsi@vger.kernel.org; Mon, 04 Oct 2010 20:22:14 +0200
Received: from merlin2.provinz.bz.it ([62.101.0.30])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Mon, 04 Oct 2010 20:22:14 +0200
Received: from andreas.moroder by merlin2.provinz.bz.it with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Mon, 04 Oct 2010 20:22:14 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

we have a server with a i2o controller. We added two disks today and 
with raidutil we created a new logical devices.

"raidutil -L logical"

shows me that this device is created, but now I don't know how to tell 
the kernel about this new disk.

Can anyone please help me ?

Thanks
Andreas


