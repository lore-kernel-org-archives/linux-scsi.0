From: jd <jpd_hp_linux_scsi@yahoo.com>
Subject: 1st  REVIEW : UNH iSCSI for 2.6-test5
Date: Wed, 24 Sep 2003 08:12:28 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030924151228.8206.qmail@web60208.mail.yahoo.com>
Reply-To: dead_emaill@nospam.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web60208.mail.yahoo.com ([216.109.118.103]:9583 "HELO
	web60208.mail.yahoo.com") by vger.kernel.org with SMTP
	id S261427AbTIXPM3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2003 11:12:29 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi,

Available for first Review & Comments.

The UNH iSCSI Project, a collaborative effort between the
UNH IOL and Hewlett Packard Company in Austin, Texas,
( hosted at http://sourceforge.net/projects/unh-iscsi )
to produce a full feature, generic iSCSI implementation ,
has ported the 2.4.18/20 version of the iSCSI initiator to
Linux 2.6.test5 Kernel for consideration of inclusion for
future distribution.

A patch file is available for review at:

http://www.parisc-linux.org/~jpd/

Files included in the patch :

 drivers/scsi/Makefile
 drivers/scsi/Kconfig
 drivers/scsi/unh_iscsi
 drivers/scsi/unh_iscsi/initiator     # HBA & Data mover
 drivers/scsi/unh_iscsi/common        # Login and shared files
 drivers/scsi/unh_iscsi/security       $ SRP and CHAP login

Please submit comments to :

linux-scsi@vger.kernel.org

Alternatively:

jpd_hp_linux_scsi@yahoo.com

This is an on going development efford in progress,
so recommendations and feedback are greatly appreciated.

Thank you for your time .

John Donnelly
HP Linux Network Development group.





__________________________________
Do you Yahoo!?
Yahoo! SiteBuilder - Free, easy-to-use web site design software
http://sitebuilder.yahoo.com
