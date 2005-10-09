From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH 3/3] libata: scsi error handling, encore
Date: Sun, 09 Oct 2005 22:26:03 +1000
Message-ID: <43490C5B.1030903@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010605080400030702080705"
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, htejun@gmail.com, russb@emc.com
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------010605080400030702080705
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This patch is against Jeff's libata-dev git repository,
upstream branch.

Changelog:
  - remove static inlines for ata_bad_scsiop() and
    ata_bad_cdb() which are no longer used

Signed-off-by: Douglas Gilbert <dougg@torque.net>

Doug Gilbert


--------------010605080400030702080705
Content-Type: text/x-patch;
 name="libata_err3.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libata_err3.diff"

--- linux/drivers/scsi/libata.h	2005-10-09 15:46:14.000000000 +1000
+++ linux/drivers/scsi/libata.h3	2005-10-09 18:24:06.000000000 +1000
@@ -86,14 +86,4 @@
                         unsigned int (*actor) (struct ata_scsi_args *args,
                                            u8 *rbuf, unsigned int buflen));
 
-static inline void ata_bad_scsiop(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
-{
-	ata_scsi_badcmd(cmd, done, 0x20, 0x00);
-}
-
-static inline void ata_bad_cdb(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
-{
-	ata_scsi_badcmd(cmd, done, 0x24, 0x00);
-}
-
 #endif /* __LIBATA_H__ */


--------------010605080400030702080705--
