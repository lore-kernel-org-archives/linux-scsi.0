From: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>
Subject: JFTR: SuSE Linux 9.2 uses broken megaraid driver
Date: Sat, 11 Dec 2004 12:08:33 +0100
Message-ID: <m3d5xh6qj2.fsf@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dt.E-Technik.Uni-Dortmund.DE ([129.217.163.1]:28052 "EHLO
	mail.dt.e-technik.uni-dortmund.de") by vger.kernel.org with ESMTP
	id S261486AbULKLIc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Dec 2004 06:08:32 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail.dt.e-technik.uni-dortmund.de (Postfix) with ESMTP id 58A924B6AA
	for <linux-scsi@vger.kernel.org>; Sat, 11 Dec 2004 12:08:31 +0100 (CET)
Received: from mail.dt.e-technik.uni-dortmund.de ([127.0.0.1])
 by localhost (krusty [127.0.0.1]) (amavisd-new, port 10024) with LMTP
 id 14926-02 for <linux-scsi@vger.kernel.org>;
 Sat, 11 Dec 2004 12:08:30 +0100 (CET)
Received: from m2a2.dyndns.org (p508EFDFB.dip.t-dialin.net [80.142.253.251])
	by mail.dt.e-technik.uni-dortmund.de (Postfix) with ESMTP id 8919A4B662
	for <linux-scsi@vger.kernel.org>; Sat, 11 Dec 2004 12:08:30 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by merlin.emma.line.org (Postfix) with ESMTP id 73EFC7750F
	for <linux-scsi@vger.kernel.org>; Sat, 11 Dec 2004 12:08:34 +0100 (CET)
Received: from merlin.emma.line.org ([127.0.0.1])
 by localhost (m2a2.dyndns.org [127.0.0.1]) (amavisd-new, port 10024)
 with LMTP id 12550-07-2 for <linux-scsi@vger.kernel.org>;
 Sat, 11 Dec 2004 12:08:33 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I have recently had to reinstall a SusE Linux 9.2 machine with an LSI
MegaRAID SCSI 320-1 - SuSE Linux 9.2, its 2.6.8-24 and the 2.6.8-24.3
and 2.6.8-24.5 kernels use the known broken 2.20.3.1 megaraid driver,
and I faced MASSIVE data corruption, with like 10,000 files and
directories in lost+found.

If you're running some older SuSE Linux version, hold back your 9.2
update unless you're willing to build a driver update disk and an update
for the running system. SuSE are looking into rolling the driver update
with the next security patch for the kernel, but I have no insight
whether or not they're doing a driver update disk.(*)

I can share my driver update disk for SL9.2 pro (the boxed version) and
the pair of 2.6.8-24.5 update modules if there is sufficient interest,
but they're only for i386 smp and I won't do any other.

Be sure to verify the actual kernel messages on the virtual console that
you really have the 2.20.4 driver, SuSE's linuxrc will happily report it
installed the driver update even if the kernel refused to load the
module(s) because you compiled SMP for the install system...

-----
(*) The SuSE Update media howto is in SuSE's FTP directories and mirrors
    at people/hvogel/Update-Media-HOWTO/index.html

-- 
Matthias Andree
