From: Charlie Brady <charlieb-dm-devel@budge.apana.org.au>
Subject: [PATCH] scsi_dh_rdac: Add support for Sun StorageTek
	2510 and 2530
Date: Tue, 25 Aug 2009 15:40:07 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0908251534340.21130@e-smith.charlieb.ott.istop.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-scsi@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org


Both these storage arrays can use RDAC when configured with 'linux' as the 
initiator.

http://www.sun.com/storage/disk_systems/workgroup/2510/
http://www.sun.com/storage/disk_systems/workgroup/2530/

Signed-off-by: Charlie Brady <charlieb@budge.apana.org.au>

--- linux-2.6/drivers/scsi/device_handler/scsi_dh_rdac.c	2009-08-25 14:56:42.000000000 -0400
+++ linux-2.6/drivers/scsi/device_handler/scsi_dh_rdac.c.sun	2009-08-25 15:22:56.000000000 -0400
@@ -628,6 +628,8 @@
  	{"SGI", "IS"},
  	{"STK", "OPENstorage D280"},
  	{"SUN", "CSM200_R"},
+	{"SUN", "LCSM100_I"},
+	{"SUN", "LCSM100_S"},
  	{"SUN", "LCSM100_F"},
  	{"DELL", "MD3000"},
  	{"DELL", "MD3000i"},
