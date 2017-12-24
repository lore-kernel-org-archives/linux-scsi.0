From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH] target: cleanup target_core_transport.c for kernel-doc
Date: Sat, 23 Dec 2017 21:20:31 -0800
Message-ID: <e896b763-692b-90bd-e212-8c6d5a8fdd2c@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

For exported functions that already have near-kernel-doc notation,
fix them to begin with "/**" and make a few corrections so that they
don't have any kernel-doc warnings.

Signed-off-by: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc:	"Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc:	linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc:	target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc:	Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc:	"James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc:	"Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/target/target_core_transport.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- linux-next-20171221.orig/drivers/target/target_core_transport.c
+++ linux-next-20171221/drivers/target/target_core_transport.c
@@ -1431,7 +1431,7 @@ transport_generic_map_mem_to_cmd(struct
 	return 0;
 }
 
-/*
+/**
  * target_submit_cmd_map_sgls - lookup unpacked lun and submit uninitialized
  * 			 se_cmd + use pre-allocated SGL memory.
  *
@@ -1441,7 +1441,7 @@ transport_generic_map_mem_to_cmd(struct
  * @sense: pointer to SCSI sense buffer
  * @unpacked_lun: unpacked LUN to reference for struct se_lun
  * @data_length: fabric expected data transfer length
- * @task_addr: SAM task attribute
+ * @task_attr: SAM task attribute
  * @data_dir: DMA data direction
  * @flags: flags for command submission from target_sc_flags_tables
  * @sgl: struct scatterlist memory for unidirectional mapping
@@ -1578,7 +1578,7 @@ int target_submit_cmd_map_sgls(struct se
 }
 EXPORT_SYMBOL(target_submit_cmd_map_sgls);
 
-/*
+/**
  * target_submit_cmd - lookup unpacked lun and submit uninitialized se_cmd
  *
  * @se_cmd: command descriptor to submit
@@ -1587,7 +1587,7 @@ EXPORT_SYMBOL(target_submit_cmd_map_sgls
  * @sense: pointer to SCSI sense buffer
  * @unpacked_lun: unpacked LUN to reference for struct se_lun
  * @data_length: fabric expected data transfer length
- * @task_addr: SAM task attribute
+ * @task_attr: SAM task attribute
  * @data_dir: DMA data direction
  * @flags: flags for command submission from target_sc_flags_tables
  *
@@ -2641,7 +2641,8 @@ int transport_generic_free_cmd(struct se
 }
 EXPORT_SYMBOL(transport_generic_free_cmd);
 
-/* target_get_sess_cmd - Add command to active ->sess_cmd_list
+/**
+ * target_get_sess_cmd - Add command to active ->sess_cmd_list
  * @se_cmd:	command descriptor to add
  * @ack_kref:	Signal that fabric will perform an ack target_put_sess_cmd()
  */
@@ -2835,7 +2836,8 @@ void target_show_cmd(const char *pfx, st
 }
 EXPORT_SYMBOL(target_show_cmd);
 
-/* target_sess_cmd_list_set_waiting - Flag all commands in
+/**
+ * target_sess_cmd_list_set_waiting - Flag all commands in
  *         sess_cmd_list to complete cmd_wait_comp.  Set
  *         sess_tearing_down so no more commands are queued.
  * @se_sess:	session to flag
@@ -2870,7 +2872,8 @@ void target_sess_cmd_list_set_waiting(st
 }
 EXPORT_SYMBOL(target_sess_cmd_list_set_waiting);
 
-/* target_wait_for_sess_cmds - Wait for outstanding descriptors
+/**
+ * target_wait_for_sess_cmds - Wait for outstanding descriptors
  * @se_sess:    session to wait for active I/O
  */
 void target_wait_for_sess_cmds(struct se_session *se_sess)


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
