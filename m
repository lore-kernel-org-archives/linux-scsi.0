From: Marco De Benedetto <debe@galliera.it>
Subject: I can't use aic79xx with RAID
Date: Fri, 18 Apr 2003 17:44:52 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030418154452.GA27820@galliera.it>
Reply-To: debe@galliera.it
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.galliera.it ([62.101.86.54]:16322 "EHLO smtp.galliera.it")
	by vger.kernel.org with ESMTP id S263118AbTDRPc5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Apr 2003 11:32:57 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp.galliera.it (Postfix) with ESMTP id 0143024EB8D
	for <linux-scsi@vger.kernel.org>; Fri, 18 Apr 2003 17:44:54 +0200 (CEST)
Received: from paz.ceed (paz.ceed [10.0.5.80])
	by smtp.galliera.it (Postfix) with ESMTP id 9A48024EB8C
	for <linux-scsi@vger.kernel.org>; Fri, 18 Apr 2003 17:44:52 +0200 (CEST)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have a NEC Express 2800 with Adaptec AIC-7902 U320 and two disks.

I have compiled the kernel 2.4.20 with the 2.4.21-pre7 patch and the
support for aic79xx, now I can see the two disks but after creating
the RAID(0/1) the kernel does not see any disk.  I have also tried the
latest drivers from Justin T. Gibbs.

Is it supposed that aic79xx should work with RAID?

BTW, does someone know what are the performance of the Linux sw RAID1
with respect to hw RAID1?

-- 
thank you,
Marco De Benedetto
