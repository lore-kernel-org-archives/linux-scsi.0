From: Fabien Penso <penso@linuxfr.org>
Subject: megaraid problem
Date: Sun, 28 Mar 2004 01:27:25 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <87vfkp24uq.fsf@linuxfr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.uucpssh.org ([212.27.33.224]:42625 "EHLO main.uucpssh.org")
	by vger.kernel.org with ESMTP id S262000AbUC1Abt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Mar 2004 19:31:49 -0500
Received: from localhost (localhost [127.0.0.1])
	by main.uucpssh.org (Postfix) with ESMTP id 7CD982A841
	for <linux-scsi@vger.kernel.org>; Sun, 28 Mar 2004 01:31:44 +0100 (CET)
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@"@vger.kernel.org

Hi to everyone.

I have a megaraid raid card :

  Vendor: MegaRAID  Model: LD0 RAID5 52095R  Rev:   E 
  Type:   Direct-Access                      ANSI SCSI revision: 02

We used to run 2.4.23 very well for a long time, but we need to upgrade
because of all the security problems (never too late :) to 2.4.25. I've
tried for days with no luck; booting gives us :

megarid: Waiting for 3 commands to flush: iter:1000
megarid: Waiting for 3 commands to flush: iter:2000

and so on. I tried to copy the megaraid2.c/megaraid2.h from 2.4.23 (who
knows...) but it doesn't work better.

I am out of ideas here, so I just wonder if someone has a solution.

Thanks.
