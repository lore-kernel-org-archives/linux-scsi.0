From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 132/144] scsi: scsi_dh: replace too broad "TP9" string with the exact models
Date: Wed,  1 Aug 2018 18:52:39 +0200
Message-ID: <20180801164958.515048187@linuxfoundation.org>
References: <20180801164949.023217860@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180801164949.023217860@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>, Hannes Reinecke <hare@suse.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, SCSI ML <linux-scsi@vger.kernel.org>, DM ML <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Sasha Levin <alexander.levin@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

4.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xose Vazquez Perez <xose.vazquez@gmail.com>

[ Upstream commit 37b37d2609cb0ac267280ef27350b962d16d272e ]

SGI/TP9100 is not an RDAC array:
    ^^^
https://git.opensvc.com/gitweb.cgi?p=multipath-tools/.git;a=blob;f=libmultipath/hwtable.c;h=88b4700beb1d8940008020fbe4c3cd97d62f4a56;hb=HEAD#l235

This partially reverts commit 35204772ea03 ("[SCSI] scsi_dh_rdac :
Consolidate rdac strings together")

[mkp: fixed up the new entries to align with rest of struct]

Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: SCSI ML <linux-scsi@vger.kernel.org>
Cc: DM ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi_dh.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/scsi/scsi_dh.c
+++ b/drivers/scsi/scsi_dh.c
@@ -58,7 +58,10 @@ static const struct scsi_dh_blist scsi_d
 	{"IBM", "3526",			"rdac", },
 	{"IBM", "3542",			"rdac", },
 	{"IBM", "3552",			"rdac", },
-	{"SGI", "TP9",			"rdac", },
+	{"SGI", "TP9300",		"rdac", },
+	{"SGI", "TP9400",		"rdac", },
+	{"SGI", "TP9500",		"rdac", },
+	{"SGI", "TP9700",		"rdac", },
 	{"SGI", "IS",			"rdac", },
 	{"STK", "OPENstorage",		"rdac", },
 	{"STK", "FLEXLINE 380",		"rdac", },
