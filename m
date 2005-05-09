From: Andreas Moroder <andreas.moroder@sb-brixen.it>
Subject: Add hotplug scsi disks
Date: Mon, 09 May 2005 16:21:37 +0200
Message-ID: <d5nr9j$fpu$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:19620 "EHLO ciao.gmane.org")
	by vger.kernel.org with ESMTP id S261406AbVEIPIW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 May 2005 11:08:22 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1DV9aH-0005iJ-QJ
	for linux-scsi@vger.kernel.org; Mon, 09 May 2005 16:50:15 +0200
Received: from merlin2.provinz.bz.it ([62.101.0.30])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Mon, 09 May 2005 16:50:13 +0200
Received: from andreas.moroder by merlin2.provinz.bz.it with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Mon, 09 May 2005 16:50:13 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I hope this is not the wrong list. If it is please tell me where I can 
send my question.

we have a dtp raid array controller. I added two disk and used dptutil 
to put them in raid1.

I tried with mkreiserfs but it tells me that

	mkreiserfs 3.6.2 (2002)

	count_blocks: open failed (No such device or address)
	Aborted


What command must I use to let Linux know about this additional disk ?

Regards
Andreas

