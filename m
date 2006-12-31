From: Bjarne Thomsen <bjarne.thomsen@get2net.dk>
Subject: aic79xx+ASC39320A crash
Date: Sun, 31 Dec 2006 11:07:15 +0100
Message-ID: <1167559635.5863.28.camel@tycho.astronomy.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailfe03.tele2.dk ([212.247.154.67]:44363 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933128AbWLaLHY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 31 Dec 2006 06:07:24 -0500
Received: from [83.72.33.52] (account mp56609@get2net.dk HELO tycho.astronomy.dk)
  by mailfe03.swip.net (CommuniGate Pro SMTP 5.0.12)
  with ESMTPA id 377833861 for linux-scsi@vger.kernel.org; Sun, 31 Dec 2006 11:07:15 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have had this problem with an Adaptec ASC-39320A for more than 2 years
(using the x86_64 version of the aic79xx driver).
The 39320A board has been tried on the Tyan 2882 and 2885 MBs with
the same result: I can copy a few small files, byt when I try to
copy a directory tree with a few hundred MB the system freezes
without any traces in the syslog or on the screen.
Two older Ultra 160 Adaptec boards work fine with the 2 Tyan MBs.
The raid option has been disabled for the ASC-39320A.

Tho years ago I gave up, but I have now tested the board
with some newer linux distributions using the Tyan 2885 MB
with the latest available BIOS (for both 2885 and 39320A):
ubuntu 6.06 LTS x86_64 (2.6.15 kernel)
Mandriva 2007 x86_64 (2.6.17 and 2.6.19 kernels)
Fedora core 6 (2.6.18 kernel)

The symptom is the same: the system freezes during the copy
of files from an IDE harddisk to a SCSI disk on the 39320 controller.
I am about to give up, again.

Any advice is welcome.

 -- Bjarne



