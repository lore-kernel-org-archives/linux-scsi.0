From: James Smart <James.Smart@Emulex.Com>
Subject: [Patch 2/5] lpfc : Correct kdoc syntax errors in lpfc_attr.c
Date: Tue, 16 Dec 2008 11:01:41 -0500
Message-ID: <1229443301.4621.17.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:63298 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756997AbYLPQAN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Dec 2008 11:00:13 -0500
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id mBGG0Dj7026175
	for <linux-scsi@vger.kernel.org>; Tue, 16 Dec 2008 08:00:13 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org



 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_attr.c |  201 +++++++++++++++++++++++++++++-------------------------------
 1 file changed, 99 insertions(+), 102 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2008-12-16 09:36:40.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2008-12-16 10:49:09.000000000 -0500
@@ -51,7 +51,7 @@
 #define LPFC_LINK_SPEED_STRING "0, 1, 2, 4, 8"
 
 /**
- * lpfc_jedec_to_ascii: Hex to ascii convertor according to JEDEC rules.
+ * lpfc_jedec_to_ascii - Hex to ascii convertor according to JEDEC rules
  * @incr: integer to convert.
  * @hdw: ascii string holding converted integer plus a string terminator.
  *
@@ -82,7 +82,7 @@ lpfc_jedec_to_ascii(int incr, char hdw[]
 }
 
 /**
- * lpfc_drvr_version_show: Return the Emulex driver string with version number.
+ * lpfc_drvr_version_show - Return the Emulex driver string with version number
  * @dev: class unused variable.
  * @attr: device attribute, not used.
  * @buf: on return contains the module description text.
@@ -152,7 +152,7 @@ lpfc_bg_reftag_err_show(struct device *d
 }
 
 /**
- * lpfc_info_show: Return some pci info about the host in ascii.
+ * lpfc_info_show - Return some pci info about the host in ascii
  * @dev: class converted to a Scsi_host structure.
  * @attr: device attribute, not used.
  * @buf: on return contains the formatted text from lpfc_info().
@@ -169,7 +169,7 @@ lpfc_info_show(struct device *dev, struc
 }
 
 /**
- * lpfc_serialnum_show: Return the hba serial number in ascii.
+ * lpfc_serialnum_show - Return the hba serial number in ascii
  * @dev: class converted to a Scsi_host structure.
  * @attr: device attribute, not used.
  * @buf: on return contains the formatted text serial number.
@@ -188,7 +188,7 @@ lpfc_serialnum_show(struct device *dev, 
 }
 
 /**
- * lpfc_temp_sensor_show: Return the temperature sensor level.
+ * lpfc_temp_sensor_show - Return the temperature sensor level
  * @dev: class converted to a Scsi_host structure.
  * @attr: device attribute, not used.
  * @buf: on return contains the formatted support level.
@@ -210,7 +210,7 @@ lpfc_temp_sensor_show(struct device *dev
 }
 
 /**
- * lpfc_modeldesc_show: Return the model description of the hba.
+ * lpfc_modeldesc_show - Return the model description of the hba
  * @dev: class converted to a Scsi_host structure.
  * @attr: device attribute, not used.
  * @buf: on return contains the scsi vpd model description.
@@ -229,7 +229,7 @@ lpfc_modeldesc_show(struct device *dev, 
 }
 
 /**
- * lpfc_modelname_show: Return the model name of the hba.
+ * lpfc_modelname_show - Return the model name of the hba
  * @dev: class converted to a Scsi_host structure.
  * @attr: device attribute, not used.
  * @buf: on return contains the scsi vpd model name.
@@ -248,7 +248,7 @@ lpfc_modelname_show(struct device *dev, 
 }
 
 /**
- * lpfc_programtype_show: Return the program type of the hba.
+ * lpfc_programtype_show - Return the program type of the hba
  * @dev: class converted to a Scsi_host structure.
  * @attr: device attribute, not used.
  * @buf: on return contains the scsi vpd program type.
@@ -267,7 +267,7 @@ lpfc_programtype_show(struct device *dev
 }
 
 /**
- * lpfc_mlomgmt_show: Return the Menlo Maintenance sli flag.
+ * lpfc_mlomgmt_show - Return the Menlo Maintenance sli flag
  * @dev: class converted to a Scsi_host structure.
  * @attr: device attribute, not used.
  * @buf: on return contains the Menlo Maintenance sli flag.
@@ -286,7 +286,7 @@ lpfc_mlomgmt_show(struct device *dev, st
 }
 
 /**
- * lpfc_vportnum_show: Return the port number in ascii of the hba.
+ * lpfc_vportnum_show - Return the port number in ascii of the hba
  * @dev: class converted to a Scsi_host structure.
  * @attr: device attribute, not used.
  * @buf: on return contains scsi vpd program type.
@@ -305,7 +305,7 @@ lpfc_vportnum_show(struct device *dev, s
 }
 
 /**
- * lpfc_fwrev_show: Return the firmware rev running in the hba.
+ * lpfc_fwrev_show - Return the firmware rev running in the hba
  * @dev: class converted to a Scsi_host structure.
  * @attr: device attribute, not used.
  * @buf: on return contains the scsi vpd program type.
@@ -326,7 +326,7 @@ lpfc_fwrev_show(struct device *dev, stru
 }
 
 /**
- * lpfc_hdw_show: Return the jedec information about the hba.
+ * lpfc_hdw_show - Return the jedec information about the hba
  * @dev: class converted to a Scsi_host structure.
  * @attr: device attribute, not used.
  * @buf: on return contains the scsi vpd program type.
@@ -347,7 +347,7 @@ lpfc_hdw_show(struct device *dev, struct
 }
 
 /**
- * lpfc_option_rom_version_show: Return the adapter ROM FCode version.
+ * lpfc_option_rom_version_show - Return the adapter ROM FCode version
  * @dev: class converted to a Scsi_host structure.
  * @attr: device attribute, not used.
  * @buf: on return contains the ROM and FCode ascii strings.
@@ -366,7 +366,7 @@ lpfc_option_rom_version_show(struct devi
 }
 
 /**
- * lpfc_state_show: Return the link state of the port.
+ * lpfc_state_show - Return the link state of the port
  * @dev: class converted to a Scsi_host structure.
  * @attr: device attribute, not used.
  * @buf: on return contains text describing the state of the link.
@@ -451,7 +451,7 @@ lpfc_link_state_show(struct device *dev,
 }
 
 /**
- * lpfc_num_discovered_ports_show: Return sum of mapped and unmapped vports.
+ * lpfc_num_discovered_ports_show - Return sum of mapped and unmapped vports
  * @dev: class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
  * @buf: on return contains the sum of fc mapped and unmapped.
@@ -474,7 +474,7 @@ lpfc_num_discovered_ports_show(struct de
 }
 
 /**
- * lpfc_issue_lip: Misnomer, name carried over from long ago.
+ * lpfc_issue_lip - Misnomer, name carried over from long ago
  * @shost: Scsi_Host pointer.
  *
  * Description:
@@ -529,7 +529,7 @@ lpfc_issue_lip(struct Scsi_Host *shost)
 }
 
 /**
- * lpfc_do_offline: Issues a mailbox command to bring the link down.
+ * lpfc_do_offline - Issues a mailbox command to bring the link down
  * @phba: lpfc_hba pointer.
  * @type: LPFC_EVT_OFFLINE, LPFC_EVT_WARM_START, LPFC_EVT_KILL.
  *
@@ -537,7 +537,7 @@ lpfc_issue_lip(struct Scsi_Host *shost)
  * Assumes any error from lpfc_do_offline() will be negative.
  * Can wait up to 5 seconds for the port ring buffers count
  * to reach zero, prints a warning if it is not zero and continues.
- * lpfc_workq_post_event() returns a non-zero return coce if call fails.
+ * lpfc_workq_post_event() returns a non-zero return code if call fails.
  *
  * Returns:
  * -EIO error posting the event
@@ -591,7 +591,7 @@ lpfc_do_offline(struct lpfc_hba *phba, u
 }
 
 /**
- * lpfc_selective_reset: Offline then onlines the port.
+ * lpfc_selective_reset - Offline then onlines the port
  * @phba: lpfc_hba pointer.
  *
  * Description:
@@ -632,7 +632,7 @@ lpfc_selective_reset(struct lpfc_hba *ph
 }
 
 /**
- * lpfc_issue_reset: Selectively resets an adapter.
+ * lpfc_issue_reset - Selectively resets an adapter
  * @dev: class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
  * @buf: containing the string "selective".
@@ -672,7 +672,7 @@ lpfc_issue_reset(struct device *dev, str
 }
 
 /**
- * lpfc_nport_evt_cnt_show: Return the number of nport events.
+ * lpfc_nport_evt_cnt_show - Return the number of nport events
  * @dev: class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
  * @buf: on return contains the ascii number of nport events.
@@ -691,7 +691,7 @@ lpfc_nport_evt_cnt_show(struct device *d
 }
 
 /**
- * lpfc_board_mode_show: Return the state of the board.
+ * lpfc_board_mode_show - Return the state of the board
  * @dev: class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
  * @buf: on return contains the state of the adapter.
@@ -720,7 +720,7 @@ lpfc_board_mode_show(struct device *dev,
 }
 
 /**
- * lpfc_board_mode_store: Puts the hba in online, offline, warm or error state.
+ * lpfc_board_mode_store - Puts the hba in online, offline, warm or error state
  * @dev: class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
  * @buf: containing one of the strings "online", "offline", "warm" or "error".
@@ -766,14 +766,14 @@ lpfc_board_mode_store(struct device *dev
 }
 
 /**
- * lpfc_get_hba_info: Return various bits of informaton about the adapter.
+ * lpfc_get_hba_info - Return various bits of informaton about the adapter
  * @phba: pointer to the adapter structure.
- * @mxri max xri count.
- * @axri available xri count.
- * @mrpi max rpi count.
- * @arpi available rpi count.
- * @mvpi max vpi count.
- * @avpi available vpi count.
+ * @mxri: max xri count.
+ * @axri: available xri count.
+ * @mrpi: max rpi count.
+ * @arpi: available rpi count.
+ * @mvpi: max vpi count.
+ * @avpi: available vpi count.
  *
  * Description:
  * If an integer pointer for an count is not null then the value for the
@@ -846,7 +846,7 @@ lpfc_get_hba_info(struct lpfc_hba *phba,
 }
 
 /**
- * lpfc_max_rpi_show: Return maximum rpi.
+ * lpfc_max_rpi_show - Return maximum rpi
  * @dev: class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
  * @buf: on return contains the maximum rpi count in decimal or "Unknown".
@@ -874,7 +874,7 @@ lpfc_max_rpi_show(struct device *dev, st
 }
 
 /**
- * lpfc_used_rpi_show: Return maximum rpi minus available rpi.
+ * lpfc_used_rpi_show - Return maximum rpi minus available rpi
  * @dev: class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
  * @buf: containing the used rpi count in decimal or "Unknown".
@@ -902,7 +902,7 @@ lpfc_used_rpi_show(struct device *dev, s
 }
 
 /**
- * lpfc_max_xri_show: Return maximum xri.
+ * lpfc_max_xri_show - Return maximum xri
  * @dev: class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
  * @buf: on return contains the maximum xri count in decimal or "Unknown".
@@ -930,7 +930,7 @@ lpfc_max_xri_show(struct device *dev, st
 }
 
 /**
- * lpfc_used_xri_show: Return maximum xpi minus the available xpi.
+ * lpfc_used_xri_show - Return maximum xpi minus the available xpi
  * @dev: class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
  * @buf: on return contains the used xri count in decimal or "Unknown".
@@ -958,7 +958,7 @@ lpfc_used_xri_show(struct device *dev, s
 }
 
 /**
- * lpfc_max_vpi_show: Return maximum vpi.
+ * lpfc_max_vpi_show - Return maximum vpi
  * @dev: class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
  * @buf: on return contains the maximum vpi count in decimal or "Unknown".
@@ -986,7 +986,7 @@ lpfc_max_vpi_show(struct device *dev, st
 }
 
 /**
- * lpfc_used_vpi_show: Return maximum vpi minus the available vpi.
+ * lpfc_used_vpi_show - Return maximum vpi minus the available vpi
  * @dev: class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
  * @buf: on return contains the used vpi count in decimal or "Unknown".
@@ -1014,7 +1014,7 @@ lpfc_used_vpi_show(struct device *dev, s
 }
 
 /**
- * lpfc_npiv_info_show: Return text about NPIV support for the adapter.
+ * lpfc_npiv_info_show - Return text about NPIV support for the adapter
  * @dev: class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
  * @buf: text that must be interpreted to determine if npiv is supported.
@@ -1042,7 +1042,7 @@ lpfc_npiv_info_show(struct device *dev, 
 }
 
 /**
- * lpfc_poll_show: Return text about poll support for the adapter.
+ * lpfc_poll_show - Return text about poll support for the adapter
  * @dev: class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
  * @buf: on return contains the cfg_poll in hex.
@@ -1064,7 +1064,7 @@ lpfc_poll_show(struct device *dev, struc
 }
 
 /**
- * lpfc_poll_store: Set the value of cfg_poll for the adapter.
+ * lpfc_poll_store - Set the value of cfg_poll for the adapter
  * @dev: class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
  * @buf: one or more lpfc_polling_flags values.
@@ -1136,13 +1136,13 @@ lpfc_poll_store(struct device *dev, stru
 }
 
 /**
- * lpfc_param_show: Return a cfg attribute value in decimal.
+ * lpfc_param_show - Return a cfg attribute value in decimal
  *
  * Description:
  * Macro that given an attr e.g. hba_queue_depth expands
  * into a function with the name lpfc_hba_queue_depth_show.
  *
- * lpfc_##attr##_show: Return the decimal value of an adapters cfg_xxx field.
+ * lpfc_##attr##_show: Return the decimal value of an adapters cfg_xxx field
  * @dev: class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
  * @buf: on return contains the attribute value in decimal.
@@ -1164,13 +1164,13 @@ lpfc_##attr##_show(struct device *dev, s
 }
 
 /**
- * lpfc_param_hex_show: Return a cfg attribute value in hex.
+ * lpfc_param_hex_show - Return a cfg attribute value in hex
  *
  * Description:
  * Macro that given an attr e.g. hba_queue_depth expands
  * into a function with the name lpfc_hba_queue_depth_show
  *
- * lpfc_##attr##_show: Return the hex value of an adapters cfg_xxx field.
+ * lpfc_##attr##_show: Return the hex value of an adapters cfg_xxx field
  * @dev: class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
  * @buf: on return contains the attribute value in hexidecimal.
@@ -1192,14 +1192,14 @@ lpfc_##attr##_show(struct device *dev, s
 }
 
 /**
- * lpfc_param_init: Intializes a cfg attribute.
+ * lpfc_param_init - Intializes a cfg attribute
  *
  * Description:
  * Macro that given an attr e.g. hba_queue_depth expands
  * into a function with the name lpfc_hba_queue_depth_init. The macro also
  * takes a default argument, a minimum and maximum argument.
  *
- * lpfc_##attr##_init: Initializes an attribute.
+ * lpfc_##attr##_init: Initializes an attribute
  * @phba: pointer the the adapter structure.
  * @val: integer attribute value.
  *
@@ -1226,13 +1226,13 @@ lpfc_##attr##_init(struct lpfc_hba *phba
 }
 
 /**
- * lpfc_param_set: Set a cfg attribute value.
+ * lpfc_param_set - Set a cfg attribute value
  *
  * Description:
  * Macro that given an attr e.g. hba_queue_depth expands
  * into a function with the name lpfc_hba_queue_depth_set
  *
- * lpfc_##attr##_set: Sets an attribute value.
+ * lpfc_##attr##_set: Sets an attribute value
  * @phba: pointer the the adapter structure.
  * @val: integer attribute value.
  *
@@ -1260,13 +1260,13 @@ lpfc_##attr##_set(struct lpfc_hba *phba,
 }
 
 /**
- * lpfc_param_store: Set a vport attribute value.
+ * lpfc_param_store - Set a vport attribute value
  *
  * Description:
  * Macro that given an attr e.g. hba_queue_depth expands
  * into a function with the name lpfc_hba_queue_depth_store.
  *
- * lpfc_##attr##_store: Set an sttribute value.
+ * lpfc_##attr##_store: Set an sttribute value
  * @dev: class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
  * @buf: contains the attribute value in ascii.
@@ -1300,13 +1300,13 @@ lpfc_##attr##_store(struct device *dev, 
 }
 
 /**
- * lpfc_vport_param_show: Return decimal formatted cfg attribute value.
+ * lpfc_vport_param_show - Return decimal formatted cfg attribute value
  *
  * Description:
  * Macro that given an attr e.g. hba_queue_depth expands
  * into a function with the name lpfc_hba_queue_depth_show
  *
- * lpfc_##attr##_show: prints the attribute value in decimal.
+ * lpfc_##attr##_show: prints the attribute value in decimal
  * @dev: class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
  * @buf: on return contains the attribute value in decimal.
@@ -1326,14 +1326,14 @@ lpfc_##attr##_show(struct device *dev, s
 }
 
 /**
- * lpfc_vport_param_hex_show: Return hex formatted attribute value.
+ * lpfc_vport_param_hex_show - Return hex formatted attribute value
  *
  * Description:
  * Macro that given an attr e.g.
  * hba_queue_depth expands into a function with the name
  * lpfc_hba_queue_depth_show
  *
- * lpfc_##attr##_show: prints the attribute value in hexidecimal.
+ * lpfc_##attr##_show: prints the attribute value in hexidecimal
  * @dev: class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
  * @buf: on return contains the attribute value in hexidecimal.
@@ -1353,7 +1353,7 @@ lpfc_##attr##_show(struct device *dev, s
 }
 
 /**
- * lpfc_vport_param_init: Initialize a vport cfg attribute.
+ * lpfc_vport_param_init - Initialize a vport cfg attribute
  *
  * Description:
  * Macro that given an attr e.g. hba_queue_depth expands
@@ -1386,7 +1386,7 @@ lpfc_##attr##_init(struct lpfc_vport *vp
 }
 
 /**
- * lpfc_vport_param_set: Set a vport cfg attribute.
+ * lpfc_vport_param_set - Set a vport cfg attribute
  *
  * Description:
  * Macro that given an attr e.g. hba_queue_depth expands
@@ -1417,7 +1417,7 @@ lpfc_##attr##_set(struct lpfc_vport *vpo
 }
 
 /**
- * lpfc_vport_param_store: Set a vport attribute.
+ * lpfc_vport_param_store - Set a vport attribute
  *
  * Description:
  * Macro that given an attr e.g. hba_queue_depth
@@ -1576,7 +1576,7 @@ static DEVICE_ATTR(lpfc_temp_sensor, S_I
 static char *lpfc_soft_wwn_key = "C99G71SL8032A";
 
 /**
- * lpfc_soft_wwn_enable_store: Allows setting of the wwn if the key is valid.
+ * lpfc_soft_wwn_enable_store - Allows setting of the wwn if the key is valid
  * @dev: class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
  * @buf: containing the string lpfc_soft_wwn_key.
@@ -1623,7 +1623,7 @@ static DEVICE_ATTR(lpfc_soft_wwn_enable,
 		   lpfc_soft_wwn_enable_store);
 
 /**
- * lpfc_soft_wwpn_show: Return the cfg soft ww port name of the adapter.
+ * lpfc_soft_wwpn_show - Return the cfg soft ww port name of the adapter
  * @dev: class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
  * @buf: on return contains the wwpn in hexidecimal.
@@ -1643,7 +1643,7 @@ lpfc_soft_wwpn_show(struct device *dev, 
 }
 
 /**
- * lpfc_soft_wwpn_store: Set the ww port name of the adapter.
+ * lpfc_soft_wwpn_store - Set the ww port name of the adapter
  * @dev class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
  * @buf: contains the wwpn in hexidecimal.
@@ -1729,7 +1729,7 @@ static DEVICE_ATTR(lpfc_soft_wwpn, S_IRU
 		   lpfc_soft_wwpn_show, lpfc_soft_wwpn_store);
 
 /**
- * lpfc_soft_wwnn_show: Return the cfg soft ww node name for the adapter.
+ * lpfc_soft_wwnn_show - Return the cfg soft ww node name for the adapter
  * @dev: class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
  * @buf: on return contains the wwnn in hexidecimal.
@@ -1747,7 +1747,7 @@ lpfc_soft_wwnn_show(struct device *dev, 
 }
 
 /**
- * lpfc_soft_wwnn_store: sets the ww node name of the adapter.
+ * lpfc_soft_wwnn_store - sets the ww node name of the adapter
  * @cdev: class device that is converted into a Scsi_host.
  * @buf: contains the ww node name in hexidecimal.
  * @count: number of wwnn bytes in buf.
@@ -1845,7 +1845,7 @@ MODULE_PARM_DESC(lpfc_nodev_tmo,
 		 "for a device to come back");
 
 /**
- * lpfc_nodev_tmo_show: Return the hba dev loss timeout value.
+ * lpfc_nodev_tmo_show - Return the hba dev loss timeout value
  * @dev: class converted to a Scsi_host structure.
  * @attr: device attribute, not used.
  * @buf: on return contains the dev loss timeout in decimal.
@@ -1864,7 +1864,7 @@ lpfc_nodev_tmo_show(struct device *dev, 
 }
 
 /**
- * lpfc_nodev_tmo_init: Set the hba nodev timeout value.
+ * lpfc_nodev_tmo_init - Set the hba nodev timeout value
  * @vport: lpfc vport structure pointer.
  * @val: contains the nodev timeout value.
  *
@@ -1905,7 +1905,7 @@ lpfc_nodev_tmo_init(struct lpfc_vport *v
 }
 
 /**
- * lpfc_update_rport_devloss_tmo: Update dev loss tmo value.
+ * lpfc_update_rport_devloss_tmo - Update dev loss tmo value
  * @vport: lpfc vport structure pointer.
  *
  * Description:
@@ -1926,7 +1926,7 @@ lpfc_update_rport_devloss_tmo(struct lpf
 }
 
 /**
- * lpfc_nodev_tmo_set: Set the vport nodev tmo and devloss tmo values.
+ * lpfc_nodev_tmo_set - Set the vport nodev tmo and devloss tmo values
  * @vport: lpfc vport structure pointer.
  * @val: contains the tmo value.
  *
@@ -1982,7 +1982,7 @@ lpfc_vport_param_init(devloss_tmo, LPFC_
 lpfc_vport_param_show(devloss_tmo)
 
 /**
- * lpfc_devloss_tmo_set: Sets vport nodev tmo, devloss tmo values, changed bit.
+ * lpfc_devloss_tmo_set - Sets vport nodev tmo, devloss tmo values, changed bit
  * @vport: lpfc vport structure pointer.
  * @val: contains the tmo value.
  *
@@ -2094,7 +2094,7 @@ MODULE_PARM_DESC(lpfc_restrict_login,
 lpfc_vport_param_show(restrict_login);
 
 /**
- * lpfc_restrict_login_init: Set the vport restrict login flag.
+ * lpfc_restrict_login_init - Set the vport restrict login flag
  * @vport: lpfc vport structure pointer.
  * @val: contains the restrict login value.
  *
@@ -2128,7 +2128,7 @@ lpfc_restrict_login_init(struct lpfc_vpo
 }
 
 /**
- * lpfc_restrict_login_set: Set the vport restrict login flag.
+ * lpfc_restrict_login_set - Set the vport restrict login flag
  * @vport: lpfc vport structure pointer.
  * @val: contains the restrict login value.
  *
@@ -2201,7 +2201,7 @@ LPFC_VPORT_ATTR_R(scan_down, 1, 0, 1,
 */
 
 /**
- * lpfc_topology_set: Set the adapters topology field.
+ * lpfc_topology_set - Set the adapters topology field
  * @phba: lpfc_hba pointer.
  * @val: topology value.
  *
@@ -2246,8 +2246,7 @@ static DEVICE_ATTR(lpfc_topology, S_IRUG
 

 /**
- * lpfc_stat_data_ctrl_store: write call back for lpfc_stat_data_ctrl
- *  sysfs file.
+ * lpfc_stat_data_ctrl_store - write call back for lpfc_stat_data_ctrl sysfs file
  * @dev: Pointer to class device.
  * @buf: Data buffer.
  * @count: Size of the data buffer.
@@ -2411,8 +2410,7 @@ lpfc_stat_data_ctrl_store(struct device 
 

 /**
- * lpfc_stat_data_ctrl_show: Read callback function for
- *   lpfc_stat_data_ctrl sysfs file.
+ * lpfc_stat_data_ctrl_show - Read function for lpfc_stat_data_ctrl sysfs file
  * @dev: Pointer to class device object.
  * @buf: Data buffer.
  *
@@ -2476,7 +2474,7 @@ static DEVICE_ATTR(lpfc_stat_data_ctrl, 
 		   lpfc_stat_data_ctrl_show, lpfc_stat_data_ctrl_store);
 
 /*
- * lpfc_drvr_stat_data: sysfs attr to get driver statistical data.
+ * lpfc_drvr_stat_data - sysfs attr to get driver statistical data
  */
 
 /*
@@ -2489,8 +2487,7 @@ static DEVICE_ATTR(lpfc_stat_data_ctrl, 
 

 /**
- * sysfs_drvr_stat_data_read: Read callback function for lpfc_drvr_stat_data
- *  sysfs attribute.
+ * sysfs_drvr_stat_data_read - Read function for lpfc_drvr_stat_data attribute
  * @kobj: Pointer to the kernel object
  * @bin_attr: Attribute object
  * @buff: Buffer pointer
@@ -2585,7 +2582,7 @@ static struct bin_attribute sysfs_drvr_s
 */
 
 /**
- * lpfc_link_speed_set: Set the adapters link speed.
+ * lpfc_link_speed_set - Set the adapters link speed
  * @phba: lpfc_hba pointer.
  * @val: link speed value.
  *
@@ -2637,7 +2634,7 @@ MODULE_PARM_DESC(lpfc_link_speed, "Selec
 lpfc_param_show(link_speed)
 
 /**
- * lpfc_link_speed_init: Set the adapters link speed.
+ * lpfc_link_speed_init - Set the adapters link speed
  * @phba: lpfc_hba pointer.
  * @val: link speed value.
  *
@@ -2865,7 +2862,7 @@ MODULE_PARM_DESC(lpfc_prot_guard, "host 
 

 /*
- * lpfc_sg_seg_cnt: Initial Maximum DMA Segment Count
+ * lpfc_sg_seg_cnt - Initial Maximum DMA Segment Count
  * This value can be set to values between 64 and 256. The default value is
  * 64, but may be increased to allow for larger Max I/O sizes. The scsi layer
  * will be allowed to request I/Os of sizes up to (MAX_SEG_COUNT * SEG_SIZE).
@@ -2967,7 +2964,7 @@ struct device_attribute *lpfc_vport_attr
 };
 
 /**
- * sysfs_ctlreg_write: Write method for writing to ctlreg.
+ * sysfs_ctlreg_write - Write method for writing to ctlreg
  * @kobj: kernel kobject that contains the kernel class device.
  * @bin_attr: kernel attributes passed to us.
  * @buf: contains the data to be written to the adapter IOREG space.
@@ -3017,7 +3014,7 @@ sysfs_ctlreg_write(struct kobject *kobj,
 }
 
 /**
- * sysfs_ctlreg_read: Read method for reading from ctlreg.
+ * sysfs_ctlreg_read  Read method for reading from ctlreg
  * @kobj: kernel kobject that contains the kernel class device.
  * @bin_attr: kernel attributes passed to us.
  * @buf: if succesful contains the data from the adapter IOREG space.
@@ -3078,7 +3075,7 @@ static struct bin_attribute sysfs_ctlreg
 };
 
 /**
- * sysfs_mbox_idle: frees the sysfs mailbox.
+ * sysfs_mbox_idle - frees the sysfs mailbox
  * @phba: lpfc_hba pointer
  **/
 static void
@@ -3095,7 +3092,7 @@ sysfs_mbox_idle(struct lpfc_hba *phba)
 }
 
 /**
- * sysfs_mbox_write: Write method for writing information via mbox.
+ * sysfs_mbox_write - Write method for writing information via mbox
  * @kobj: kernel kobject that contains the kernel class device.
  * @bin_attr: kernel attributes passed to us.
  * @buf: contains the data to be written to sysfs mbox.
@@ -3170,7 +3167,7 @@ sysfs_mbox_write(struct kobject *kobj, s
 }
 
 /**
- * sysfs_mbox_read: Read method for reading information via mbox.
+ * sysfs_mbox_read - Read method for reading information via mbox
  * @kobj: kernel kobject that contains the kernel class device.
  * @bin_attr: kernel attributes passed to us.
  * @buf: contains the data to be read from sysfs mbox.
@@ -3374,7 +3371,7 @@ static struct bin_attribute sysfs_mbox_a
 };
 
 /**
- * lpfc_alloc_sysfs_attr: Creates the ctlreg and mbox entries.
+ * lpfc_alloc_sysfs_attr - Creates the ctlreg and mbox entries
  * @vport: address of lpfc vport structure.
  *
  * Return codes:
@@ -3415,7 +3412,7 @@ out:
 }
 
 /**
- * lpfc_free_sysfs_attr: Removes the ctlreg and mbox entries.
+ * lpfc_free_sysfs_attr - Removes the ctlreg and mbox entries
  * @vport: address of lpfc vport structure.
  **/
 void
@@ -3437,7 +3434,7 @@ lpfc_free_sysfs_attr(struct lpfc_vport *
  */
 
 /**
- * lpfc_get_host_port_id: Copy the vport DID into the scsi host port id.
+ * lpfc_get_host_port_id - Copy the vport DID into the scsi host port id
  * @shost: kernel scsi host pointer.
  **/
 static void
@@ -3450,7 +3447,7 @@ lpfc_get_host_port_id(struct Scsi_Host *
 }
 
 /**
- * lpfc_get_host_port_type: Set the value of the scsi host port type.
+ * lpfc_get_host_port_type - Set the value of the scsi host port type
  * @shost: kernel scsi host pointer.
  **/
 static void
@@ -3482,7 +3479,7 @@ lpfc_get_host_port_type(struct Scsi_Host
 }
 
 /**
- * lpfc_get_host_port_state: Set the value of the scsi host port state.
+ * lpfc_get_host_port_state - Set the value of the scsi host port state
  * @shost: kernel scsi host pointer.
  **/
 static void
@@ -3520,7 +3517,7 @@ lpfc_get_host_port_state(struct Scsi_Hos
 }
 
 /**
- * lpfc_get_host_speed: Set the value of the scsi host speed.
+ * lpfc_get_host_speed - Set the value of the scsi host speed
  * @shost: kernel scsi host pointer.
  **/
 static void
@@ -3556,7 +3553,7 @@ lpfc_get_host_speed(struct Scsi_Host *sh
 }
 
 /**
- * lpfc_get_host_fabric_name: Set the value of the scsi host fabric name.
+ * lpfc_get_host_fabric_name - Set the value of the scsi host fabric name
  * @shost: kernel scsi host pointer.
  **/
 static void
@@ -3582,7 +3579,7 @@ lpfc_get_host_fabric_name (struct Scsi_H
 }
 
 /**
- * lpfc_get_stats: Return statistical information about the adapter.
+ * lpfc_get_stats - Return statistical information about the adapter
  * @shost: kernel scsi host pointer.
  *
  * Notes:
@@ -3707,7 +3704,7 @@ lpfc_get_stats(struct Scsi_Host *shost)
 }
 
 /**
- * lpfc_reset_stats: Copy the adapter link stats information.
+ * lpfc_reset_stats - Copy the adapter link stats information
  * @shost: kernel scsi host pointer.
  **/
 static void
@@ -3788,7 +3785,7 @@ lpfc_reset_stats(struct Scsi_Host *shost
  */
 
 /**
- * lpfc_get_node_by_target: Return the nodelist for a target.
+ * lpfc_get_node_by_target - Return the nodelist for a target
  * @starget: kernel scsi target pointer.
  *
  * Returns:
@@ -3817,7 +3814,7 @@ lpfc_get_node_by_target(struct scsi_targ
 }
 
 /**
- * lpfc_get_starget_port_id: Set the target port id to the ndlp DID or -1.
+ * lpfc_get_starget_port_id - Set the target port id to the ndlp DID or -1
  * @starget: kernel scsi target pointer.
  **/
 static void
@@ -3829,7 +3826,7 @@ lpfc_get_starget_port_id(struct scsi_tar
 }
 
 /**
- * lpfc_get_starget_node_name: Set the target node name.
+ * lpfc_get_starget_node_name - Set the target node name
  * @starget: kernel scsi target pointer.
  *
  * Description: Set the target node name to the ndlp node name wwn or zero.
@@ -3844,7 +3841,7 @@ lpfc_get_starget_node_name(struct scsi_t
 }
 
 /**
- * lpfc_get_starget_port_name: Set the target port name.
+ * lpfc_get_starget_port_name - Set the target port name
  * @starget: kernel scsi target pointer.
  *
  * Description:  set the target port name to the ndlp port name wwn or zero.
@@ -3859,7 +3856,7 @@ lpfc_get_starget_port_name(struct scsi_t
 }
 
 /**
- * lpfc_set_rport_loss_tmo: Set the rport dev loss tmo.
+ * lpfc_set_rport_loss_tmo - Set the rport dev loss tmo
  * @rport: fc rport address.
  * @timeout: new value for dev loss tmo.
  *
@@ -3877,7 +3874,7 @@ lpfc_set_rport_loss_tmo(struct fc_rport 
 }
 
 /**
- * lpfc_rport_show_function: Return rport target information.
+ * lpfc_rport_show_function - Return rport target information
  *
  * Description:
  * Macro that uses field to generate a function with the name lpfc_show_rport_
@@ -3905,7 +3902,7 @@ lpfc_show_rport_##field (struct device *
 static FC_RPORT_ATTR(field, S_IRUGO, lpfc_show_rport_##field, NULL)
 
 /**
- * lpfc_set_vport_symbolic_name: Set the vport's symbolic name.
+ * lpfc_set_vport_symbolic_name - Set the vport's symbolic name
  * @fc_vport: The fc_vport who's symbolic name has been changed.
  *
  * Description:
@@ -4048,7 +4045,7 @@ struct fc_function_template lpfc_vport_t
 };
 
 /**
- * lpfc_get_cfgparam: Used during probe_one to init the adapter structure.
+ * lpfc_get_cfgparam - Used during probe_one to init the adapter structure
  * @phba: lpfc_hba pointer.
  **/
 void
@@ -4097,7 +4094,7 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_get_vport_cfgparam: Used during port create, init the vport structure.
+ * lpfc_get_vport_cfgparam - Used during port create, init the vport structure
  * @vport: lpfc_vport pointer.
  **/
 void


