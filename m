From: <gregkh@linuxfoundation.org>
Subject: Patch "scsi: dh: add new rdac devices" has been added to the 4.15-stable tree
Date: Fri, 16 Mar 2018 15:16:48 +0100
Message-ID: <15212098088957@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: xose.vazquez@gmail.com, alexander.levin@microsoft.com, christophe.varoqui@opensvc.com, dm-devel@redhat.com, gregkh@linuxfoundation.org, hare@suse.de, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, ng-eseries-upstream-maintainers@netapp.com
Cc: stable@vger.kernel.org, stable-commits@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    scsi: dh: add new rdac devices

to the 4.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     scsi-dh-add-new-rdac-devices.patch
and it can be found in the queue-4.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


>From foo@baz Fri Mar 16 15:11:08 CET 2018
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Date: Fri, 17 Nov 2017 22:05:13 +0100
Subject: scsi: dh: add new rdac devices

From: Xose Vazquez Perez <xose.vazquez@gmail.com>


[ Upstream commit 4b3aec2bbbce1c35f50e7475a9fd78d24b9ea4ea ]

Add IBM 3542 and 3552, arrays: FAStT200 and FAStT500.

Add full STK OPENstorage family, arrays: 9176, D173, D178, D210, D220,
D240 and D280.

Add STK BladeCtlr family, arrays: B210, B220, B240 and B280.

These changes were done in multipath-tools time ago.

Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
Cc: SCSI ML <linux-scsi@vger.kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi_dh.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/scsi/scsi_dh.c
+++ b/drivers/scsi/scsi_dh.c
@@ -56,10 +56,13 @@ static const struct scsi_dh_blist scsi_d
 	{"IBM", "1815",			"rdac", },
 	{"IBM", "1818",			"rdac", },
 	{"IBM", "3526",			"rdac", },
+	{"IBM", "3542",			"rdac", },
+	{"IBM", "3552",			"rdac", },
 	{"SGI", "TP9",			"rdac", },
 	{"SGI", "IS",			"rdac", },
-	{"STK", "OPENstorage D280",	"rdac", },
+	{"STK", "OPENstorage",		"rdac", },
 	{"STK", "FLEXLINE 380",		"rdac", },
+	{"STK", "BladeCtlr",		"rdac", },
 	{"SUN", "CSM",			"rdac", },
 	{"SUN", "LCSM100",		"rdac", },
 	{"SUN", "STK6580_6780",		"rdac", },


Patches currently in stable-queue which might be from xose.vazquez@gmail.com are

queue-4.15/scsi-devinfo-apply-to-hp-xp-the-same-flags-as-hitachi-vsp.patch
queue-4.15/scsi-dh-add-new-rdac-devices.patch
