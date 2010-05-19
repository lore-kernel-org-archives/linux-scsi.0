From: <Yanqing_Liu@Dell.com>
Subject: [PATCH v4] dm: Add Dell MD36xxi controller into RDAC
	device list
Date: Wed, 19 May 2010 12:31:36 -0500
Message-ID: <F757EE5C3631ED4DBDFD7709119219FE03BBD8CF4C@AUSX7MCPS302.AMER.DELL.COM>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org
Cc: Charles_Rose@Dell.com
List-Id: linux-scsi@vger.kernel.org

Hi all,

This patch is to add next generation of Dell iSCSI PowerVault controller MD36xxi into RDAC device list.

Thanks,
Yanqing

Signed off by: Yanqing Liu <Yanqing_Liu@Dell.com>
---
Index: linux-2.6.34/drivers/scsi/device_handler/scsi_dh_rdac.c
========================================================================
--- linux-2.6.34.orig/drivers/scsi/device_handler/scsi_dh_rdac.c	2010-05-19 09:03:34.000000000 -0400
+++ linux-2.6.34/drivers/scsi/device_handler/scsi_dh_rdac.c	2010-05-19 09:01:06.000000000 -0400
@@ -768,6 +768,7 @@
 	{"DELL", "MD3000i"},
 	{"DELL", "MD32xx"},
 	{"DELL", "MD32xxi"},
+	{"DELL", "MD36xxi"},
 	{"LSI", "INF-01-00"},
 	{"ENGENIO", "INF-01-00"},
 	{"STK", "FLEXLINE 380"},
