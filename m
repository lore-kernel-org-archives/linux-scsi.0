From: "Roman M. Parparov" <romm@empire.tau.ac.il>
Subject: SCSI problems - Promise UltraTrak/RedHat 9.0
Date: Sun, 4 Jul 2004 11:46:48 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040704084648.GC19631@empire.tau.ac.il>
Reply-To: romm@empire.tau.ac.il
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from empire.tau.ac.il ([132.66.152.50]:44197 "EHLO empire.tau.ac.il")
	by vger.kernel.org with ESMTP id S265481AbUGDIqt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Jul 2004 04:46:49 -0400
Received: from empire.tau.ac.il (romm@localhost.localdomain [127.0.0.1])
	by empire.tau.ac.il (8.12.10/8.12.8) with ESMTP id i648kmY7020211
	for <linux-scsi@vger.kernel.org>; Sun, 4 Jul 2004 11:46:48 +0300
Received: (from romm@localhost)
	by empire.tau.ac.il (8.12.10/8.12.8/Submit) id i648kmj7020209
	for linux-scsi@vger.kernel.org; Sun, 4 Jul 2004 11:46:48 +0300
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have a standard RH 9.0 box:
Linux ocean.nasa.proj.ac.il 2.4.20-8 #1 Thu Mar 13 17:54:28 EST 2003
i686 i686 i386 GNU/Linux

to which we bought a Promise UltraTrak 15000, filled with 15 250Gb
Hitachi disks

which were partitioned into two RAID 5 volumes of 1.6 and 1.3Tbytes.

The UltraTrak was attached to the server using an Adaptec U320 card
which used aic79xx in a seemingly correct way.

Linux saw the volumes fine, the filesystems were created (JFS) and the
partitions were mounted.

But when I started copying data onto the new hardware I immediately
ran into SCSI problems - timeouts and IO errors on sectors in 33000000
area.

Is my problem related to Linux and then how do I fix it?
Is my problem related to Promise's hardware trying to do more than it
is capable of?

The SCSI cables are short and termination looks flawless.

Please help.

-- 
Roman M. Parparov - NASA EOSDIS project node at TAU technical manager.
Email: romm@empire.tau.ac.il		   http://www.nasa.proj.ac.il/
Phone/Fax: +972-(0)3-6405205 (work),         +972-(0)51-34-18-34 (home)
----------------------------------------------------------------------
The economy depends about as much on economists as the weather does on
weather forecasters.
                -- Jean-Paul Kauffmann
