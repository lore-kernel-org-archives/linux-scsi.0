From: lego_12239@rambler.ru
Subject: mptscsih dmesg messages
Date: Wed, 15 Apr 2009 23:08:48 +0400
Message-ID: <20090415190848.GA21142@debian>
Reply-To: lego_12239@rambler.ru
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mxb.rambler.ru ([81.19.66.30]:62916 "EHLO mxb.rambler.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831AbZDOTPt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Apr 2009 15:15:49 -0400
Received: from maild.rambler.ru (maild.rambler.ru [81.19.66.33])
	by mxb.rambler.ru (Postfix) with ESMTP id 192A71C8107
	for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2009 23:10:15 +0400 (MSD)
Received: from localhost (unknown [89.178.146.16])
	(Authenticated sender: lego_12239@rambler.ru)
	by maild.rambler.ru (Postfix) with ESMTP id 18CF884467
	for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2009 23:08:52 +0400 (MSD)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

  Hi.

  I have Debian 4.0r4a installation on a server with SAS1064E built-in 
controller:

~$ lspci | grep LSI
04:00.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1064E PCI-Express Fusion-MPT SAS (rev 02)

Vanilla kernel with aufs2-base5 patch:

~$ uname -a
Linux ftp 2.6.28.7-aufs #10 Fri Mar 6 19:34:56 UTC 2009 i686 GNU/Linux

There are six sata hard disks connected through SAS HDD Hub box to the 
controller on the motherboard by two sata cables. Everything work all right, 
but dmesg shows many annoying lines like this:

[ 1876.212880] mptscsih: ioc0: attempting task abort! (sc=f6ff1c80)
[ 1876.212953] sd 8:0:5:0: [sdh] CDB: Write(10): 2a 00 17 42 ee 0f 00 04 00 00
[ 1876.213635] mptscsih: ioc0: task abort: SUCCESS (sc=f6ff1c80)
[ 1876.213973] mptscsih: ioc0: attempting task abort! (sc=d1fc18c0)
[ 1876.214046] sd 8:0:5:0: [sdh] CDB: Read(10): 28 00 17 10 c0 3f 00 00 08 00
[ 1876.214727] mptscsih: ioc0: task abort: SUCCESS (sc=d1fc18c0)
[ 1876.215081] mptscsih: ioc0: attempting target reset! (sc=d1fc1ec0)
[ 1876.215154] sd 8:0:5:0: [sdh] CDB: Write(10): 2a 00 17 42 b1 ff 00 04 00 00
[ 1877.735588] mptscsih: ioc0: target reset: SUCCESS (sc=d1fc1ec0)

sdh is a sata Western Digital disk, model WD10EADS.

Is this a firmware problem?

In the mailing list archive I saw similar problem, but I don't sure.

Thanks.
