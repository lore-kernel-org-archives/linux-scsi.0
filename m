From: Douglas Gilbert <dougg@torque.net>
Subject: sg3_utils and sg_utils 1.00 release
Date: Sun, 28 Jul 2002 22:23:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D44A736.226525AE@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from torque.net (dial1.torque.net [204.138.244.11])
	by gear.torque.net (8.9.3/8.9.3) with ESMTP id WAA32594
	for <linux-scsi@vger.kernel.org>; Sun, 28 Jul 2002 22:24:55 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have released new version of sg3_utils (for lk 2.4
and lk 2.5) and sg_utils (for lk 2.2 with some support
for lk 2.0). This is now reflected on www.torque.net/sg 
(in a table toward the bottom of the main page) and at 
freshmeat.net .

The 1.00 indication isn't hugely significant, I just
ran out of numbers before it ;-)
Changelogs:
	http://www.torque.net/sg/p/sg3_utils.CHANGELOG
	http://www.torque.net/sg/p/sg_utils.CHANGELOG

Most recent work has been on sg_logs (only in the sg3_utils
package). This command displays LOG SENSE pages which on
recent disks have a reasonable amount of "S.M.A.R.T" type
information (e.g. temperature, number of spin ups, error
counter pages). Currently sg_logs makes more information
available than smartsuite [ http://sourceforge.net/projects/smartsuite ]
which is stronger on ATA disks than SCSI ones.

Doug Gilbert
