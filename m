From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] scsi: doc. fixes to scsi_common.c
Date: Sun, 10 Dec 2017 10:11:33 -0800
Message-ID: <95ed8abc-c9a7-4301-415b-cc6d327945ba@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:57062 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752068AbdLJSLk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Dec 2017 13:11:40 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>, Bart Van Assche <bart.vanassche@wdc.com>

From: Randy Dunlap <rdunlap@infradead.org>

Clean up some comment typos and fix some errors in documentation.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Bart Van Assche <bart.vanassche@wdc.com>
---
 drivers/scsi/scsi_common.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- lnx-415-rc2.orig/drivers/scsi/scsi_common.c
+++ lnx-415-rc2/drivers/scsi/scsi_common.c
@@ -12,7 +12,7 @@
 
 /* NB: These are exposed through /proc/scsi/scsi and form part of the ABI.
  * You may not alter any existing entry (although adding new ones is
- * encouraged once assigned by ANSI/INCITS T10
+ * encouraged once assigned by ANSI/INCITS T10).
  */
 static const char *const scsi_device_types[] = {
 	"Direct-Access    ",
@@ -39,7 +39,7 @@ static const char *const scsi_device_typ
 };
 
 /**
- * scsi_device_type - Return 17 char string indicating device type.
+ * scsi_device_type - Return 17-char string indicating device type.
  * @type: type number to look up
  */
 const char *scsi_device_type(unsigned type)
@@ -59,7 +59,7 @@ EXPORT_SYMBOL(scsi_device_type);
  * @scsilun:	struct scsi_lun to be converted.
  *
  * Description:
- *     Convert @scsilun from a struct scsi_lun to a four byte host byte-ordered
+ *     Convert @scsilun from a struct scsi_lun to a four-byte host byte-ordered
  *     integer, and return the result. The caller must check for
  *     truncation before using this function.
  *
@@ -98,7 +98,7 @@ EXPORT_SYMBOL(scsilun_to_int);
  *     back into the lun value.
  *
  * Notes:
- *     Given an integer : 0x0b03d204,  this function returns a
+ *     Given an integer : 0x0b03d204, this function returns a
  *     struct scsi_lun of: d2 04 0b 03 00 00 00 00
  *
  */
@@ -221,7 +221,7 @@ EXPORT_SYMBOL(scsi_sense_desc_find);
 
 /**
  * scsi_build_sense_buffer - build sense data in a buffer
- * @desc:	Sense format (non zero == descriptor format,
+ * @desc:	Sense format (non-zero == descriptor format,
  *              0 == fixed format)
  * @buf:	Where to build sense data
  * @key:	Sense key
@@ -255,7 +255,7 @@ EXPORT_SYMBOL(scsi_build_sense_buffer);
  * @info:	64-bit information value to be set
  *
  * Return value:
- *	0 on success or EINVAL for invalid sense buffer length
+ *	0 on success or -EINVAL for invalid sense buffer length
  **/
 int scsi_set_sense_information(u8 *buf, int buf_len, u64 info)
 {
@@ -305,7 +305,7 @@ EXPORT_SYMBOL(scsi_set_sense_information
  * @cd:		command/data bit
  *
  * Return value:
- *	0 on success or EINVAL for invalid sense buffer length
+ *	0 on success or -EINVAL for invalid sense buffer length
  */
 int scsi_set_sense_field_pointer(u8 *buf, int buf_len, u16 fp, u8 bp, bool cd)
 {
