From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv3 4/5] scsi: whitespace fixes in scsi_devinfo.c
Date: Fri, 11 Aug 2017 16:23:20 +0200
Message-ID: <1502461401-94630-5-git-send-email-hare@suse.de>
References: <1502461401-94630-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34106 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753267AbdHKOXZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 11 Aug 2017 10:23:25 -0400
In-Reply-To: <1502461401-94630-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Alan Stern <stern@rowland.harvard.edu>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_devinfo.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 28fea83..776c701 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -304,8 +304,8 @@ static void scsi_strcpy_devinfo(char *name, char *to, size_t to_length,
 			 */
 			to[from_length] = '\0';
 		} else {
-			/* 
-			 * space pad the string if it is short. 
+			/*
+			 * space pad the string if it is short.
 			 */
 			strncpy(&to[from_length], spaces,
 				to_length - from_length);
@@ -325,10 +325,10 @@ static void scsi_strcpy_devinfo(char *name, char *to, size_t to_length,
  * @flags:	if strflags NULL, use this flag value
  *
  * Description:
- * 	Create and add one dev_info entry for @vendor, @model, @strflags or
- * 	@flag. If @compatible, add to the tail of the list, do not space
- * 	pad, and set devinfo->compatible. The scsi_static_device_list entries
- * 	are added with @compatible 1 and @clfags NULL.
+ *	Create and add one dev_info entry for @vendor, @model, @strflags or
+ *	@flag. If @compatible, add to the tail of the list, do not space
+ *	pad, and set devinfo->compatible. The scsi_static_device_list entries
+ *	are added with @compatible 1 and @clfags NULL.
  *
  * Returns: 0 OK, -error on failure.
  **/
@@ -350,11 +350,11 @@ static int scsi_dev_info_list_add(int compatible, char *vendor, char *model,
  * @key:	specify list to use
  *
  * Description:
- * 	Create and add one dev_info entry for @vendor, @model,
- * 	@strflags or @flag in list specified by @key. If @compatible,
- * 	add to the tail of the list, do not space pad, and set
- * 	devinfo->compatible. The scsi_static_device_list entries are
- * 	added with @compatible 1 and @clfags NULL.
+ *	Create and add one dev_info entry for @vendor, @model,
+ *	@strflags or @flag in list specified by @key. If @compatible,
+ *	add to the tail of the list, do not space pad, and set
+ *	devinfo->compatible. The scsi_static_device_list entries are
+ *	added with @compatible 1 and @clfags NULL.
  *
  * Returns: 0 OK, -error on failure.
  **/
@@ -405,7 +405,7 @@ int scsi_dev_info_list_add_keyed(int compatible, char *vendor, char *model,
  *
  * Description:
  *	Finds the first dev_info entry matching @vendor, @model
- * 	in list specified by @key.
+ *	in list specified by @key.
  *
  * Returns: pointer to matching entry, or ERR_PTR on failure.
  **/
@@ -508,10 +508,10 @@ int scsi_dev_info_list_del_keyed(char *vendor, char *model, int key)
  * @dev_list:	string of device flags to add
  *
  * Description:
- * 	Parse dev_list, and add entries to the scsi_dev_info_list.
- * 	dev_list is of the form "vendor:product:flag,vendor:product:flag".
- * 	dev_list is modified via strsep. Can be called for command line
- * 	addition, for proc or mabye a sysfs interface.
+ *	Parse dev_list, and add entries to the scsi_dev_info_list.
+ *	dev_list is of the form "vendor:product:flag,vendor:product:flag".
+ *	dev_list is modified via strsep. Can be called for command line
+ *	addition, for proc or mabye a sysfs interface.
  *
  * Returns: 0 if OK, -error on failure.
  **/
@@ -701,7 +701,7 @@ static int proc_scsi_devinfo_open(struct inode *inode, struct file *file)
 	return seq_open(file, &scsi_devinfo_seq_ops);
 }
 
-/* 
+/*
  * proc_scsi_dev_info_write - allow additions to scsi_dev_info_list via /proc.
  *
  * Description: Adds a black/white list entry for vendor and model with an
@@ -840,8 +840,8 @@ int scsi_dev_info_remove_list(int key)
  * scsi_init_devinfo - set up the dynamic device list.
  *
  * Description:
- * 	Add command line entries from scsi_dev_flags, then add
- * 	scsi_static_device_list entries to the scsi device info list.
+ *	Add command line entries from scsi_dev_flags, then add
+ *	scsi_static_device_list entries to the scsi device info list.
  */
 int __init scsi_init_devinfo(void)
 {
-- 
1.8.5.6
