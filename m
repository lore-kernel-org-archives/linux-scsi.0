From: damien.lemoal@wdc.com
Subject: [PATCH 1/9] sd: Remove white space before EOL
Date: Fri, 21 Apr 2017 18:16:41 +0900
Message-ID: <20170421091649.25287-2-damien.lemoal@wdc.com>
References: <20170421091649.25287-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:31247 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1037290AbdDUJRU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Apr 2017 05:17:20 -0400
In-Reply-To: <20170421091649.25287-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Damien Le Moal <damien.lemoal@wdc.com>

From: Damien Le Moal <damien.lemoal@wdc.com>

No functional change is introduced by this patch.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd.c | 60 +++++++++++++++++++++++++++----------------------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 00b168b..db362da 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -7,20 +7,20 @@
  *              Subsequent revisions: Eric Youngdale
  *	Modification history:
  *       - Drew Eckhardt <drew@colorado.edu> original
- *       - Eric Youngdale <eric@andante.org> add scatter-gather, multiple 
+ *       - Eric Youngdale <eric@andante.org> add scatter-gather, multiple
  *         outstanding request, and other enhancements.
  *         Support loadable low-level scsi drivers.
- *       - Jirka Hanika <geo@ff.cuni.cz> support more scsi disks using 
+ *       - Jirka Hanika <geo@ff.cuni.cz> support more scsi disks using
  *         eight major numbers.
  *       - Richard Gooch <rgooch@atnf.csiro.au> support devfs.
- *	 - Torben Mathiasen <tmm@image.dk> Resource allocation fixes in 
+ *	 - Torben Mathiasen <tmm@image.dk> Resource allocation fixes in
  *	   sd_init and cleanups.
  *	 - Alex Davis <letmein@erols.com> Fix problem where partition info
- *	   not being read in sd_open. Fix problem where removable media 
+ *	   not being read in sd_open. Fix problem where removable media
  *	   could be ejected after sd_open.
  *	 - Douglas Gilbert <dgilbert@interlog.com> cleanup for lk 2.5.x
- *	 - Badari Pulavarty <pbadari@us.ibm.com>, Matthew Wilcox 
- *	   <willy@debian.org>, Kurt Garloff <garloff@suse.de>: 
+ *	 - Badari Pulavarty <pbadari@us.ibm.com>, Matthew Wilcox
+ *	   <willy@debian.org>, Kurt Garloff <garloff@suse.de>:
  *	   Support 32k/1M disks.
  *
  *	Logging policy (needs CONFIG_SCSI_LOGGING defined):
@@ -29,7 +29,7 @@
  *	 - entering sd_ioctl: SCSI_LOG_IOCTL level 1
  *	 - entering other commands: SCSI_LOG_HLQUEUE level 3
  *	Note: when the logging level is set by the user, it must be greater
- *	than the level indicated above to trigger output.	
+ *	than the level indicated above to trigger output.
  */
 
 #include <linux/module.h>
@@ -548,16 +548,16 @@ static struct kobject *sd_default_probe(dev_t devt, int *partno, void *data)
 
 /*
  * Device no to disk mapping:
- * 
+ *
  *       major         disc2     disc  p1
  *   |............|.............|....|....| <- dev_t
  *    31        20 19          8 7  4 3  0
- * 
+ *
  * Inside a major, we have 16k disks, however mapped non-
  * contiguously. The first 16 disks are for major0, the next
- * ones with major1, ... Disk 256 is for major0 again, disk 272 
- * for major1, ... 
- * As we stay compatible with our numbering scheme, we can reuse 
+ * ones with major1, ... Disk 256 is for major0 again, disk 272
+ * for major1, ...
+ * As we stay compatible with our numbering scheme, we can reuse
  * the well-know SCSI majors 8, 65--71, 136--143.
  */
 static int sd_major(int major_idx)
@@ -950,7 +950,7 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
 
 	if (sdp->changed) {
 		/*
-		 * quietly refuse to do anything to a changed disc until 
+		 * quietly refuse to do anything to a changed disc until
 		 * the changed bit has been reset
 		 */
 		/* printk("SCSI disk has been changed or is not present. Prohibiting further I/O.\n"); */
@@ -1193,7 +1193,7 @@ static void sd_uninit_command(struct scsi_cmnd *SCpnt)
  *	@inode: only i_rdev member may be used
  *	@filp: only f_mode and f_flags may be used
  *
- *	Returns 0 if successful. Returns a negated errno value in case 
+ *	Returns 0 if successful. Returns a negated errno value in case
  *	of error.
  *
  *	Note: This can be called from a user context (e.g. fsck(1) )
@@ -1261,7 +1261,7 @@ static int sd_open(struct block_device *bdev, fmode_t mode)
 
 error_out:
 	scsi_disk_put(sdkp);
-	return retval;	
+	return retval;
 }
 
 /**
@@ -1270,7 +1270,7 @@ static int sd_open(struct block_device *bdev, fmode_t mode)
  *	@inode: only i_rdev member may be used
  *	@filp: only f_mode and f_flags may be used
  *
- *	Returns 0. 
+ *	Returns 0.
  *
  *	Note: may block (uninterruptible) if error recovery is underway
  *	on this disk.
@@ -1344,7 +1344,7 @@ static int sd_ioctl(struct block_device *bdev, fmode_t mode,
 	struct scsi_device *sdp = sdkp->device;
 	void __user *p = (void __user *)arg;
 	int error;
-    
+
 	SCSI_LOG_IOCTL(1, sd_printk(KERN_INFO, sdkp, "sd_ioctl: disk=%s, "
 				    "cmd=0x%x\n", disk->disk_name, cmd));
 
@@ -1555,9 +1555,9 @@ static void sd_rescan(struct device *dev)
 
 
 #ifdef CONFIG_COMPAT
-/* 
- * This gets directly called from VFS. When the ioctl 
- * is not recognized we go back to the other translation paths. 
+/*
+ * This gets directly called from VFS. When the ioctl
+ * is not recognized we go back to the other translation paths.
  */
 static int sd_compat_ioctl(struct block_device *bdev, fmode_t mode,
 			   unsigned int cmd, unsigned long arg)
@@ -1569,12 +1569,12 @@ static int sd_compat_ioctl(struct block_device *bdev, fmode_t mode,
 			(mode & FMODE_NDELAY) != 0);
 	if (error)
 		return error;
-	       
-	/* 
+
+	/*
 	 * Let the static ioctl translation table take care of it.
 	 */
 	if (!sdev->host->hostt->compat_ioctl)
-		return -ENOIOCTLCMD; 
+		return -ENOIOCTLCMD;
 	return sdev->host->hostt->compat_ioctl(sdev, cmd, (void __user *)arg);
 }
 #endif
@@ -1953,7 +1953,7 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			if (the_result)
 				sense_valid = scsi_sense_valid(&sshdr);
 			retries++;
-		} while (retries < 3 && 
+		} while (retries < 3 &&
 			 (!scsi_status_is_good(the_result) ||
 			  ((driver_byte(the_result) & DRIVER_SENSE) &&
 			  sense_valid && sshdr.sense_key == UNIT_ATTENTION)));
@@ -2026,7 +2026,7 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			}
 			break;
 		}
-				
+
 	} while (spintime && time_before_eq(jiffies, spintime_expire));
 
 	if (spintime) {
@@ -3106,13 +3106,13 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
  *	for each scsi device (not just disks) present.
  *	@dev: pointer to device object
  *
- *	Returns 0 if successful (or not interested in this scsi device 
+ *	Returns 0 if successful (or not interested in this scsi device
  *	(e.g. scanner)); 1 when there is an error.
  *
  *	Note: this function is invoked from the scsi mid-level.
- *	This function sets up the mapping between a given 
- *	<host,channel,id,lun> (found in sdp) and new device name 
- *	(e.g. /dev/sda). More precisely it is the block device major 
+ *	This function sets up the mapping between a given
+ *	<host,channel,id,lun> (found in sdp) and new device name
+ *	(e.g. /dev/sda). More precisely it is the block device major
  *	and minor number that is chosen here.
  *
  *	Assume sd_probe is not re-entrant (for time being)
@@ -3267,7 +3267,7 @@ static void scsi_disk_release(struct device *dev)
 {
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
 	struct gendisk *disk = sdkp->disk;
-	
+
 	spin_lock(&sd_index_lock);
 	ida_remove(&sd_index_ida, sdkp->index);
 	spin_unlock(&sd_index_lock);
-- 
2.9.3
