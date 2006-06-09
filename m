From: akpm@osdl.org
Subject: [patch 06/31] drivers/scsi/qla2xxx/: make some functions static
Date: Thu, 08 Jun 2006 22:23:32 -0700
Message-ID: <200606090523.k595NW9F032243@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:10719 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932241AbWFIF0r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jun 2006 01:26:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, bunk@stusta.de


From: Adrian Bunk <bunk@stusta.de>

This patch makes some needlessly global functions static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/qla2xxx/qla_os.c  |   12 ++++++------
 drivers/scsi/qla2xxx/qla_sup.c |    8 ++++----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff -puN drivers/scsi/qla2xxx/qla_os.c~drivers-scsi-qla2xxx-make-some-functions-static drivers/scsi/qla2xxx/qla_os.c
--- devel/drivers/scsi/qla2xxx/qla_os.c~drivers-scsi-qla2xxx-make-some-functions-static	2006-06-01 20:41:50.000000000 -0700
+++ devel-akpm/drivers/scsi/qla2xxx/qla_os.c	2006-06-01 20:41:50.000000000 -0700
@@ -261,7 +261,7 @@ qla24xx_pci_info_str(struct scsi_qla_hos
 	return str;
 }
 
-char *
+static char *
 qla2x00_fw_version_str(struct scsi_qla_host *ha, char *str)
 {
 	char un_str[10];
@@ -299,7 +299,7 @@ qla2x00_fw_version_str(struct scsi_qla_h
 	return (str);
 }
 
-char *
+static char *
 qla24xx_fw_version_str(struct scsi_qla_host *ha, char *str)
 {
 	sprintf(str, "%d.%02d.%02d ", ha->fw_major_version,
@@ -591,7 +591,7 @@ qla2x00_wait_for_loop_ready(scsi_qla_hos
 * Note:
 *    Only return FAILED if command not returned by firmware.
 **************************************************************************/
-int
+static int
 qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 {
 	scsi_qla_host_t *ha = to_qla_host(cmd->device->host);
@@ -726,7 +726,7 @@ qla2x00_eh_wait_for_pending_target_comma
 *    SUCCESS/FAILURE (defined as macro in scsi.h).
 *
 **************************************************************************/
-int
+static int
 qla2xxx_eh_device_reset(struct scsi_cmnd *cmd)
 {
 	scsi_qla_host_t *ha = to_qla_host(cmd->device->host);
@@ -857,7 +857,7 @@ qla2x00_eh_wait_for_pending_commands(scs
 *    SUCCESS/FAILURE (defined as macro in scsi.h).
 *
 **************************************************************************/
-int
+static int
 qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
 {
 	scsi_qla_host_t *ha = to_qla_host(cmd->device->host);
@@ -918,7 +918,7 @@ eh_bus_reset_done:
 *
 * Note:
 **************************************************************************/
-int
+static int
 qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
 {
 	scsi_qla_host_t *ha = to_qla_host(cmd->device->host);
diff -puN drivers/scsi/qla2xxx/qla_sup.c~drivers-scsi-qla2xxx-make-some-functions-static drivers/scsi/qla2xxx/qla_sup.c
--- devel/drivers/scsi/qla2xxx/qla_sup.c~drivers-scsi-qla2xxx-make-some-functions-static	2006-06-01 20:41:50.000000000 -0700
+++ devel-akpm/drivers/scsi/qla2xxx/qla_sup.c	2006-06-01 20:41:50.000000000 -0700
@@ -449,7 +449,7 @@ nvram_data_to_access_addr(uint32_t naddr
 	return FARX_ACCESS_NVRAM_DATA | naddr;
 }
 
-uint32_t
+static uint32_t
 qla24xx_read_flash_dword(scsi_qla_host_t *ha, uint32_t addr)
 {
 	int rval;
@@ -490,7 +490,7 @@ qla24xx_read_flash_data(scsi_qla_host_t 
 	return dwptr;
 }
 
-int
+static int
 qla24xx_write_flash_dword(scsi_qla_host_t *ha, uint32_t addr, uint32_t data)
 {
 	int rval;
@@ -512,7 +512,7 @@ qla24xx_write_flash_dword(scsi_qla_host_
 	return rval;
 }
 
-void
+static void
 qla24xx_get_flash_manufacturer(scsi_qla_host_t *ha, uint8_t *man_id,
     uint8_t *flash_id)
 {
@@ -537,7 +537,7 @@ qla24xx_get_flash_manufacturer(scsi_qla_
 	}
 }
 
-int
+static int
 qla24xx_write_flash_data(scsi_qla_host_t *ha, uint32_t *dwptr, uint32_t faddr,
     uint32_t dwords)
 {
_
