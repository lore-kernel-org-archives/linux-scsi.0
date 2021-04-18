Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F09FC433B4
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Apr 2021 20:33:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3889560E0B
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Apr 2021 20:33:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232539AbhDRUde (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 18 Apr 2021 16:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbhDRUde (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Apr 2021 16:33:34 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A3DC06174A;
        Sun, 18 Apr 2021 13:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:MIME-Version
        :Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=86+26EDq1IIqDwjAOGC1HpF5NsHqdehnLA1dXUrci+c=; b=hszlyaDImj5TrhpuTXPdzWjh4Y
        XaNh3+0WR3hnb9L3zzjtKWFW7lOEmEHNhY3ea8Uycfig8r1KWutoX3uFJ8qpGmBevjuN+eohAlhsd
        TdU7e5Cq62ufcsu+sgdh+0FbnI4+7Pf2pUWvp/lwKrLvw7UBDuGbPR8m8tSH0JgLNf2P+/gwKwm99
        bz75i7IgQ0/DWT3fw0H9koAMLsp6G+3NRzpIowcZtAfJBgXAYY7EIA5aMlF8IJQ8qwG90y5mzLXgK
        SAXQREP9krGkWoaSHmKxuPNSAmEFSUAuAoOu4opx6Opo2FvKHhi3objBFLk4eKfdRZKxn3O9I8Z/3
        Jdo4fq5Q==;
Received: from [2601:1c0:6280:3f0::df68] (helo=smtpauth.infradead.org)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lYE6J-008YC1-CD; Sun, 18 Apr 2021 20:33:03 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: fusion: documentation cleanup
Date:   Sun, 18 Apr 2021 13:32:59 -0700
Message-Id: <20210418203259.835-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix kernel-doc warnings, spellos, and typos.

../drivers/message/fusion/mptsas.c:432: warning: Function parameter or member 'sas_address' not described in 'mptsas_find_portinfo_by_sas_address'
../drivers/message/fusion/mptsas.c:432: warning: Excess function parameter 'handle' description in 'mptsas_find_portinfo_by_sas_address'
../drivers/message/fusion/mptsas.c:581: warning: Function parameter or member 'slot' not described in 'mptsas_add_device_component'
../drivers/message/fusion/mptsas.c:581: warning: Function parameter or member 'enclosure_logical_id' not described in 'mptsas_add_device_component'
../drivers/message/fusion/mptsas.c:678: warning: Function parameter or member 'starget' not described in 'mptsas_add_device_component_starget_ir'
../drivers/message/fusion/mptsas.c:678: warning: Excess function parameter 'channel' description in 'mptsas_add_device_component_starget_ir'
../drivers/message/fusion/mptsas.c:678: warning: Excess function parameter 'id' description in 'mptsas_add_device_component_starget_ir'
../drivers/message/fusion/mptsas.c:990: warning: Function parameter or member 'ioc' not described in 'mptsas_find_vtarget'
../drivers/message/fusion/mptsas.c:990: warning: Function parameter or member 'channel' not described in 'mptsas_find_vtarget'
../drivers/message/fusion/mptsas.c:990: warning: Function parameter or member 'id' not described in 'mptsas_find_vtarget'
../drivers/message/fusion/mptsas.c:990: warning: expecting prototype for csmisas_find_vtarget(). Prototype was for mptsas_find_vtarget() instead
../drivers/message/fusion/mptsas.c:1064: warning: Function parameter or member 'ioc' not described in 'mptsas_target_reset'
../drivers/message/fusion/mptsas.c:1064: warning: Function parameter or member 'channel' not described in 'mptsas_target_reset'
../drivers/message/fusion/mptsas.c:1064: warning: Function parameter or member 'id' not described in 'mptsas_target_reset'
../drivers/message/fusion/mptsas.c:1135: warning: Function parameter or member 'ioc' not described in 'mptsas_target_reset_queue'
../drivers/message/fusion/mptsas.c:1135: warning: Function parameter or member 'sas_event_data' not described in 'mptsas_target_reset_queue'
../drivers/message/fusion/mptsas.c:1217: warning: Function parameter or member 'mf' not described in 'mptsas_taskmgmt_complete'
../drivers/message/fusion/mptsas.c:1217: warning: Function parameter or member 'mr' not described in 'mptsas_taskmgmt_complete'
../drivers/message/fusion/mptsas.c:1311: warning: Function parameter or member 'ioc' not described in 'mptsas_ioc_reset'
../drivers/message/fusion/mptsas.c:1311: warning: Function parameter or member 'reset_phase' not described in 'mptsas_ioc_reset'
../drivers/message/fusion/mptsas.c:1311: warning: expecting prototype for mptscsih_ioc_reset(). Prototype was for mptsas_ioc_reset() instead
../drivers/message/fusion/mptsas.c:1951: warning: expecting prototype for mptsas_mptsas_eh_timed_out(). Prototype was for mptsas_eh_timed_out() instead
../drivers/message/fusion/mptsas.c:3623: warning: Function parameter or member 'fw_event' not described in 'mptsas_send_expander_event'
../drivers/message/fusion/mptsas.c:3623: warning: Excess function parameter 'ioc' description in 'mptsas_send_expander_event'
../drivers/message/fusion/mptsas.c:3623: warning: Excess function parameter 'expander_data' description in 'mptsas_send_expander_event'
../drivers/message/fusion/mptsas.c:4010: warning: Excess function parameter 'sas_address' description in 'mptsas_scan_sas_topology'
../drivers/message/fusion/mptsas.c:4783: warning: Function parameter or member 'issue_reset' not described in 'mptsas_issue_tm'
../drivers/message/fusion/mptsas.c:4856: warning: Function parameter or member 'fw_event' not described in 'mptsas_broadcast_primitive_work'
../drivers/message/fusion/mptsas.c:4856: warning: Excess function parameter 'work' description in 'mptsas_broadcast_primitive_work'

mptsas.c:984: warning: missing initial short description on line:
 * csmisas_find_vtarget
mptsas.c:993: warning: expecting prototype for csmisas_find_vtarget(). Prototype
 was for mptsas_find_vtarget() instead
mptsas.c:1053: warning: missing initial short description on line:
 * mptsas_target_reset
mptsas.c:1057: warning: contents before sections
mptsas.c:1125: warning: missing initial short description on line:
 * mptsas_target_reset_queue
mptsas.c:1131: warning: contents before sections
mptsas.c:1308: warning: missing initial short description on line:
 * mptsas_ioc_reset

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: MPT-FusionLinux.pdl@broadcom.com
Cc: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
---
 drivers/message/fusion/mptsas.c |  119 +++++++++++++++---------------
 1 file changed, 63 insertions(+), 56 deletions(-)

--- linux-next-20210416.orig/drivers/message/fusion/mptsas.c
+++ linux-next-20210416/drivers/message/fusion/mptsas.c
@@ -86,7 +86,7 @@ MODULE_PARM_DESC(mpt_pt_clear,
 		" Clear persistency table: enable=1  "
 		"(default=MPTSCSIH_PT_CLEAR=0)");
 
-/* scsi-mid layer global parmeter is max_report_luns, which is 511 */
+/* scsi-mid layer global parameter is max_report_luns, which is 511 */
 #define MPTSAS_MAX_LUN (16895)
 static int max_lun = MPTSAS_MAX_LUN;
 module_param(max_lun, int, 0);
@@ -420,12 +420,14 @@ mptsas_find_portinfo_by_handle(MPT_ADAPT
 }
 
 /**
- *	mptsas_find_portinfo_by_sas_address -
+ *	mptsas_find_portinfo_by_sas_address - find and return portinfo for
+ *		this sas_address
  *	@ioc: Pointer to MPT_ADAPTER structure
- *	@handle:
+ *	@sas_address: expander sas address
  *
- *	This function should be called with the sas_topology_mutex already held
+ *	This function should be called with the sas_topology_mutex already held.
  *
+ * 	Return: %NULL if not found.
  **/
 static struct mptsas_portinfo *
 mptsas_find_portinfo_by_sas_address(MPT_ADAPTER *ioc, u64 sas_address)
@@ -567,12 +569,14 @@ starget)
 }
 
 /**
- *	mptsas_add_device_component -
+ *	mptsas_add_device_component - adds a new device component to our lists
  *	@ioc: Pointer to MPT_ADAPTER structure
- *	@channel: fw mapped id's
- *	@id:
- *	@sas_address:
- *	@device_info:
+ *	@channel: channel number
+ *	@id: Logical Target ID for reset (if appropriate)
+ *	@sas_address: expander sas address
+ *	@device_info: specific bits (flags) for devices
+ *	@slot: enclosure slot ID
+ *	@enclosure_logical_id: enclosure WWN
  *
  **/
 static void
@@ -634,10 +638,10 @@ mptsas_add_device_component(MPT_ADAPTER
 }
 
 /**
- *	mptsas_add_device_component_by_fw -
+ *	mptsas_add_device_component_by_fw - adds a new device component by FW ID
  *	@ioc: Pointer to MPT_ADAPTER structure
- *	@channel:  fw mapped id's
- *	@id:
+ *	@channel: channel number
+ *	@id: Logical Target ID
  *
  **/
 static void
@@ -668,8 +672,7 @@ mptsas_add_device_component_by_fw(MPT_AD
 /**
  *	mptsas_add_device_component_starget_ir - Handle Integrated RAID, adding each individual device to list
  *	@ioc: Pointer to MPT_ADAPTER structure
- *	@channel: fw mapped id's
- *	@id:
+ *	@starget: SCSI target for this SCSI device
  *
  **/
 static void
@@ -771,9 +774,9 @@ mptsas_add_device_component_starget_ir(M
 }
 
 /**
- *	mptsas_add_device_component_starget -
+ *	mptsas_add_device_component_starget - adds a SCSI target device component
  *	@ioc: Pointer to MPT_ADAPTER structure
- *	@starget:
+ *	@starget: SCSI target for this SCSI device
  *
  **/
 static void
@@ -806,7 +809,7 @@ mptsas_add_device_component_starget(MPT_
  *	mptsas_del_device_component_by_os - Once a device has been removed, we mark the entry in the list as being cached
  *	@ioc: Pointer to MPT_ADAPTER structure
  *	@channel: os mapped id's
- *	@id:
+ *	@id: Logical Target ID
  *
  **/
 static void
@@ -978,11 +981,12 @@ mptsas_setup_wide_ports(MPT_ADAPTER *ioc
 }
 
 /**
- * csmisas_find_vtarget
+ * mptsas_find_vtarget - find a virtual target device (FC LUN device or
+ * 				SCSI target device)
  *
- * @ioc
- * @volume_id
- * @volume_bus
+ * @ioc: Pointer to MPT_ADAPTER structure
+ * @channel: channel number
+ * @id: Logical Target ID
  *
  **/
 static VirtTarget *
@@ -1047,15 +1051,14 @@ mptsas_queue_rescan(MPT_ADAPTER *ioc)
 
 
 /**
- * mptsas_target_reset
- *
- * Issues TARGET_RESET to end device using handshaking method
+ * mptsas_target_reset - Issues TARGET_RESET to end device using
+ * 			 handshaking method
  *
- * @ioc
- * @channel
- * @id
+ * @ioc: Pointer to MPT_ADAPTER structure
+ * @channel: channel number
+ * @id: Logical Target ID for reset
  *
- * Returns (1) success
+ * Return: (1) success
  *         (0) failure
  *
  **/
@@ -1119,15 +1122,15 @@ mptsas_block_io_starget(struct scsi_targ
 }
 
 /**
- * mptsas_target_reset_queue
+ * mptsas_target_reset_queue - queue a target reset
  *
- * Receive request for TARGET_RESET after receiving an firmware
+ * @ioc: Pointer to MPT_ADAPTER structure
+ * @sas_event_data: SAS Device Status Change Event data
+ *
+ * Receive request for TARGET_RESET after receiving a firmware
  * event NOT_RESPONDING_EVENT, then put command in link list
  * and queue if task_queue already in use.
  *
- * @ioc
- * @sas_event_data
- *
  **/
 static void
 mptsas_target_reset_queue(MPT_ADAPTER *ioc,
@@ -1207,9 +1210,11 @@ mptsas_schedule_target_reset(void *iocp)
 /**
  *	mptsas_taskmgmt_complete - complete SAS task management function
  *	@ioc: Pointer to MPT_ADAPTER structure
+ *	@mf: MPT message frame
+ *	@mr: SCSI Task Management Reply structure ptr (may be %NULL)
  *
  *	Completion for TARGET_RESET after NOT_RESPONDING_EVENT, enable work
- *	queue to finish off removing device from upper layers. then send next
+ *	queue to finish off removing device from upper layers, then send next
  *	TARGET_RESET in the queue.
  **/
 static int
@@ -1300,10 +1305,10 @@ mptsas_taskmgmt_complete(MPT_ADAPTER *io
 }
 
 /**
- * mptscsih_ioc_reset
+ * mptsas_ioc_reset - issue an IOC reset for this reset phase
  *
- * @ioc
- * @reset_phase
+ * @ioc: Pointer to MPT_ADAPTER structure
+ * @reset_phase: id of phase of reset
  *
  **/
 static int
@@ -1350,7 +1355,7 @@ mptsas_ioc_reset(MPT_ADAPTER *ioc, int r
 
 
 /**
- * enum device_state -
+ * enum device_state - TUR device state
  * @DEVICE_RETRY: need to retry the TUR
  * @DEVICE_ERROR: TUR return error, don't add device
  * @DEVICE_READY: device can be added
@@ -1941,7 +1946,7 @@ mptsas_qcmd(struct Scsi_Host *shost, str
 }
 
 /**
- *	mptsas_mptsas_eh_timed_out - resets the scsi_cmnd timeout
+ *	mptsas_eh_timed_out - resets the scsi_cmnd timeout
  *		if the device under question is currently in the
  *		device removal delay.
  *	@sc: scsi command that the midlayer is about to time out
@@ -2839,14 +2844,15 @@ struct rep_manu_reply{
 };
 
 /**
-  * mptsas_exp_repmanufacture_info -
+  * mptsas_exp_repmanufacture_info - sets expander manufacturer info
   * @ioc: per adapter object
   * @sas_address: expander sas address
   * @edev: the sas_expander_device object
   *
-  * Fills in the sas_expander_device object when SMP port is created.
+  * For an edge expander or a fanout expander:
+  * fills in the sas_expander_device object when SMP port is created.
   *
-  * Returns 0 for success, non-zero for failure.
+  * Return: 0 for success, non-zero for failure.
   */
 static int
 mptsas_exp_repmanufacture_info(MPT_ADAPTER *ioc,
@@ -3284,7 +3290,7 @@ static int mptsas_probe_one_phy(struct d
 					rphy_to_expander_device(rphy));
 	}
 
-	/* If the device exists,verify it wasn't previously flagged
+	/* If the device exists, verify it wasn't previously flagged
 	as a missing device.  If so, clear it */
 	vtarget = mptsas_find_vtarget(ioc,
 	    phy_info->attached.channel,
@@ -3611,8 +3617,7 @@ static void mptsas_expander_delete(MPT_A
 
 /**
  * mptsas_send_expander_event - expanders events
- * @ioc: Pointer to MPT_ADAPTER structure
- * @expander_data: event data
+ * @fw_event: event data
  *
  *
  * This function handles adding, removing, and refreshing
@@ -3657,9 +3662,9 @@ mptsas_send_expander_event(struct fw_eve
 
 
 /**
- * mptsas_expander_add -
+ * mptsas_expander_add - adds a newly discovered expander
  * @ioc: Pointer to MPT_ADAPTER structure
- * @handle:
+ * @handle: device handle
  *
  */
 static struct mptsas_portinfo *
@@ -4000,9 +4005,9 @@ mptsas_probe_devices(MPT_ADAPTER *ioc)
 }
 
 /**
- *	mptsas_scan_sas_topology -
+ *	mptsas_scan_sas_topology - scans new SAS topology
+ *	  (part of probe or rescan)
  *	@ioc: Pointer to MPT_ADAPTER structure
- *	@sas_address:
  *
  **/
 static void
@@ -4150,11 +4155,12 @@ mptsas_find_phyinfo_by_sas_address(MPT_A
 }
 
 /**
- *	mptsas_find_phyinfo_by_phys_disk_num -
+ *	mptsas_find_phyinfo_by_phys_disk_num - find phyinfo for the
+ *	  specified @phys_disk_num
  *	@ioc: Pointer to MPT_ADAPTER structure
- *	@phys_disk_num:
- *	@channel:
- *	@id:
+ *	@phys_disk_num: (hot plug) physical disk number (for RAID support)
+ *	@channel: channel number
+ *	@id: Logical Target ID
  *
  **/
 static struct mptsas_phyinfo *
@@ -4773,8 +4779,9 @@ mptsas_send_raid_event(struct fw_event_w
  *	@lun: Logical unit for reset (if appropriate)
  *	@task_context: Context for the task to be aborted
  *	@timeout: timeout for task management control
+ *	@issue_reset: set to 1 on return if reset is needed, else 0
  *
- *	return 0 on success and -1 on failure:
+ *	Return: 0 on success or -1 on failure.
  *
  */
 static int
@@ -4847,9 +4854,9 @@ mptsas_issue_tm(MPT_ADAPTER *ioc, u8 typ
 
 /**
  *	mptsas_broadcast_primitive_work - Handle broadcast primitives
- *	@work: work queue payload containing info describing the event
+ *	@fw_event: work queue payload containing info describing the event
  *
- *	this will be handled in workqueue context.
+ *	This will be handled in workqueue context.
  */
 static void
 mptsas_broadcast_primitive_work(struct fw_event_work *fw_event)
