From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH] scsi/qla2xxx: label endian-ness for many fields
Date: Fri, 9 Dec 2016 22:45:00 +0200
Message-ID: <20161209224216-mutt-send-email-mst@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: qla2xxx-upstream@qlogic.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Himanshu.Madhani@cavium.com, Bart.VanAssche@sandisk.com
List-Id: linux-scsi@vger.kernel.org

This adds endian-ness labels for lots of qla structs.
Doing this cuts down number of sparse warnings from ~1700 to ~1400.
Will help find and resolve some of real issues down the road.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

---

Compile-tested only.

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 73b12e4..a4d3071 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1159,28 +1159,28 @@ typedef struct {
 	 */
 	uint8_t  firmware_options[2];
 
-	uint16_t frame_payload_size;
-	uint16_t max_iocb_allocation;
-	uint16_t execution_throttle;
+	__le16 frame_payload_size;
+	__le16 max_iocb_allocation;
+	__le16 execution_throttle;
 	uint8_t  retry_count;
 	uint8_t	 retry_delay;			/* unused */
 	uint8_t	 port_name[WWN_SIZE];		/* Big endian. */
-	uint16_t hard_address;
+	__le16 hard_address;
 	uint8_t	 inquiry_data;
 	uint8_t	 login_timeout;
 	uint8_t	 node_name[WWN_SIZE];		/* Big endian. */
 
-	uint16_t request_q_outpointer;
-	uint16_t response_q_inpointer;
-	uint16_t request_q_length;
-	uint16_t response_q_length;
-	uint32_t request_q_address[2];
-	uint32_t response_q_address[2];
+	__le16 request_q_outpointer;
+	__le16 response_q_inpointer;
+	__le16 request_q_length;
+	__le16 response_q_length;
+	__le32 request_q_address[2];
+	__le32 response_q_address[2];
 
-	uint16_t lun_enables;
+	__le16 lun_enables;
 	uint8_t  command_resource_count;
 	uint8_t  immediate_notify_resource_count;
-	uint16_t timeout;
+	__le16 timeout;
 	uint8_t  reserved_2[2];
 
 	/*
@@ -1238,48 +1238,48 @@ typedef struct {
 #define GLSO_USE_DID	BIT_3
 
 struct link_statistics {
-	uint32_t link_fail_cnt;
-	uint32_t loss_sync_cnt;
-	uint32_t loss_sig_cnt;
-	uint32_t prim_seq_err_cnt;
-	uint32_t inval_xmit_word_cnt;
-	uint32_t inval_crc_cnt;
-	uint32_t lip_cnt;
-	uint32_t link_up_cnt;
-	uint32_t link_down_loop_init_tmo;
-	uint32_t link_down_los;
-	uint32_t link_down_loss_rcv_clk;
-	uint32_t reserved0[5];
-	uint32_t port_cfg_chg;
-	uint32_t reserved1[11];
-	uint32_t rsp_q_full;
-	uint32_t atio_q_full;
-	uint32_t drop_ae;
-	uint32_t els_proto_err;
-	uint32_t reserved2;
-	uint32_t tx_frames;
-	uint32_t rx_frames;
-	uint32_t discarded_frames;
-	uint32_t dropped_frames;
-	uint32_t reserved3;
-	uint32_t nos_rcvd;
-	uint32_t reserved4[4];
-	uint32_t tx_prjt;
-	uint32_t rcv_exfail;
-	uint32_t rcv_abts;
-	uint32_t seq_frm_miss;
-	uint32_t corr_err;
-	uint32_t mb_rqst;
-	uint32_t nport_full;
-	uint32_t eofa;
-	uint32_t reserved5;
-	uint32_t fpm_recv_word_cnt_lo;
-	uint32_t fpm_recv_word_cnt_hi;
-	uint32_t fpm_disc_word_cnt_lo;
-	uint32_t fpm_disc_word_cnt_hi;
-	uint32_t fpm_xmit_word_cnt_lo;
-	uint32_t fpm_xmit_word_cnt_hi;
-	uint32_t reserved6[70];
+	__le32 link_fail_cnt;
+	__le32 loss_sync_cnt;
+	__le32 loss_sig_cnt;
+	__le32 prim_seq_err_cnt;
+	__le32 inval_xmit_word_cnt;
+	__le32 inval_crc_cnt;
+	__le32 lip_cnt;
+	__le32 link_up_cnt;
+	__le32 link_down_loop_init_tmo;
+	__le32 link_down_los;
+	__le32 link_down_loss_rcv_clk;
+	__le32 reserved0[5];
+	__le32 port_cfg_chg;
+	__le32 reserved1[11];
+	__le32 rsp_q_full;
+	__le32 atio_q_full;
+	__le32 drop_ae;
+	__le32 els_proto_err;
+	__le32 reserved2;
+	__le32 tx_frames;
+	__le32 rx_frames;
+	__le32 discarded_frames;
+	__le32 dropped_frames;
+	__le32 reserved3;
+	__le32 nos_rcvd;
+	__le32 reserved4[4];
+	__le32 tx_prjt;
+	__le32 rcv_exfail;
+	__le32 rcv_abts;
+	__le32 seq_frm_miss;
+	__le32 corr_err;
+	__le32 mb_rqst;
+	__le32 nport_full;
+	__le32 eofa;
+	__le32 reserved5;
+	__le32 fpm_recv_word_cnt_lo;
+	__le32 fpm_recv_word_cnt_hi;
+	__le32 fpm_disc_word_cnt_lo;
+	__le32 fpm_disc_word_cnt_hi;
+	__le32 fpm_xmit_word_cnt_lo;
+	__le32 fpm_xmit_word_cnt_hi;
+	__le32 reserved6[70];
 };
 
 /*
@@ -1330,13 +1330,13 @@ typedef struct {
 	 */
 	uint8_t	 firmware_options[2];
 
-	uint16_t frame_payload_size;
-	uint16_t max_iocb_allocation;
-	uint16_t execution_throttle;
+	__le16 frame_payload_size;
+	__le16 max_iocb_allocation;
+	__le16 execution_throttle;
 	uint8_t	 retry_count;
 	uint8_t	 retry_delay;			/* unused */
 	uint8_t	 port_name[WWN_SIZE];		/* Big endian. */
-	uint16_t hard_address;
+	__le16 hard_address;
 	uint8_t	 inquiry_data;
 	uint8_t	 login_timeout;
 	uint8_t	 node_name[WWN_SIZE];		/* Big endian. */
@@ -1456,7 +1456,7 @@ typedef struct {
 	uint8_t reset_delay;
 	uint8_t port_down_retry_count;
 	uint8_t boot_id_number;
-	uint16_t max_luns_per_target;
+	__le16 max_luns_per_target;
 	uint8_t fcode_boot_port_name[WWN_SIZE];
 	uint8_t alternate_port_name[WWN_SIZE];
 	uint8_t alternate_node_name[WWN_SIZE];
@@ -1478,19 +1478,19 @@ typedef struct {
 	uint8_t adapter_id[16];
 
 	uint8_t alt1_boot_node_name[WWN_SIZE];
-	uint16_t alt1_boot_lun_number;
+	__le16 alt1_boot_lun_number;
 	uint8_t alt2_boot_node_name[WWN_SIZE];
-	uint16_t alt2_boot_lun_number;
+	__le16 alt2_boot_lun_number;
 	uint8_t alt3_boot_node_name[WWN_SIZE];
-	uint16_t alt3_boot_lun_number;
+	__le16 alt3_boot_lun_number;
 	uint8_t alt4_boot_node_name[WWN_SIZE];
-	uint16_t alt4_boot_lun_number;
+	__le16 alt4_boot_lun_number;
 	uint8_t alt5_boot_node_name[WWN_SIZE];
-	uint16_t alt5_boot_lun_number;
+	__le16 alt5_boot_lun_number;
 	uint8_t alt6_boot_node_name[WWN_SIZE];
-	uint16_t alt6_boot_lun_number;
+	__le16 alt6_boot_lun_number;
 	uint8_t alt7_boot_node_name[WWN_SIZE];
-	uint16_t alt7_boot_lun_number;
+	__le16 alt7_boot_lun_number;
 
 	uint8_t reserved_3[2];
 
@@ -1526,10 +1526,10 @@ typedef struct {
 	uint8_t reserved_4[16];
 
 	/* Subsystem vendor ID for ISP2200 */
-	uint16_t subsystem_vendor_id_2200;
+	__le16 subsystem_vendor_id_2200;
 
 	/* Subsystem device ID for ISP2200 */
-	uint16_t subsystem_device_id_2200;
+	__le16 subsystem_device_id_2200;
 
 	uint8_t	 reserved_5;
 	uint8_t	 checksum;
@@ -1561,7 +1561,7 @@ struct atio {
 };
 
 typedef union {
-	uint16_t extended;
+	__le16 extended;
 	struct {
 		uint8_t reserved;
 		uint8_t standard;
@@ -1585,26 +1585,26 @@ typedef struct {
 	uint8_t entry_count;		/* Entry count. */
 	uint8_t sys_define;		/* System defined. */
 	uint8_t entry_status;		/* Entry Status. */
-	uint32_t handle;		/* System handle. */
+	__le32 handle;		/* System handle. */
 	target_id_t target;		/* SCSI ID */
-	uint16_t lun;			/* SCSI LUN */
-	uint16_t control_flags;		/* Control flags. */
+	__le16 lun;			/* SCSI LUN */
+	__le16 control_flags;		/* Control flags. */
 #define CF_WRITE	BIT_6
 #define CF_READ		BIT_5
 #define CF_SIMPLE_TAG	BIT_3
 #define CF_ORDERED_TAG	BIT_2
 #define CF_HEAD_TAG	BIT_1
-	uint16_t reserved_1;
-	uint16_t timeout;		/* Command timeout. */
-	uint16_t dseg_count;		/* Data segment count. */
+	__le16 reserved_1;
+	__le16 timeout;		/* Command timeout. */
+	__le16 dseg_count;		/* Data segment count. */
 	uint8_t scsi_cdb[MAX_CMDSZ]; 	/* SCSI command words. */
-	uint32_t byte_count;		/* Total byte count. */
-	uint32_t dseg_0_address;	/* Data segment 0 address. */
-	uint32_t dseg_0_length;		/* Data segment 0 length. */
-	uint32_t dseg_1_address;	/* Data segment 1 address. */
-	uint32_t dseg_1_length;		/* Data segment 1 length. */
-	uint32_t dseg_2_address;	/* Data segment 2 address. */
-	uint32_t dseg_2_length;		/* Data segment 2 length. */
+	__le32 byte_count;		/* Total byte count. */
+	__le32 dseg_0_address;	/* Data segment 0 address. */
+	__le32 dseg_0_length;		/* Data segment 0 length. */
+	__le32 dseg_1_address;	/* Data segment 1 address. */
+	__le32 dseg_1_length;		/* Data segment 1 length. */
+	__le32 dseg_2_address;	/* Data segment 2 address. */
+	__le32 dseg_2_length;		/* Data segment 2 length. */
 } cmd_entry_t;
 
 /*
@@ -1616,19 +1616,19 @@ typedef struct {
 	uint8_t entry_count;		/* Entry count. */
 	uint8_t sys_define;		/* System defined. */
 	uint8_t entry_status;		/* Entry Status. */
-	uint32_t handle;		/* System handle. */
+	__le32 handle;		/* System handle. */
 	target_id_t target;		/* SCSI ID */
-	uint16_t lun;			/* SCSI LUN */
-	uint16_t control_flags;		/* Control flags. */
-	uint16_t reserved_1;
-	uint16_t timeout;		/* Command timeout. */
-	uint16_t dseg_count;		/* Data segment count. */
+	__le16 lun;			/* SCSI LUN */
+	__le16 control_flags;		/* Control flags. */
+	__le16 reserved_1;
+	__le16 timeout;		/* Command timeout. */
+	__le16 dseg_count;		/* Data segment count. */
 	uint8_t scsi_cdb[MAX_CMDSZ];	/* SCSI command words. */
-	uint32_t byte_count;		/* Total byte count. */
-	uint32_t dseg_0_address[2];	/* Data segment 0 address. */
-	uint32_t dseg_0_length;		/* Data segment 0 length. */
-	uint32_t dseg_1_address[2];	/* Data segment 1 address. */
-	uint32_t dseg_1_length;		/* Data segment 1 length. */
+	__le32 byte_count;		/* Total byte count. */
+	__le32 dseg_0_address[2];	/* Data segment 0 address. */
+	__le32 dseg_0_length;		/* Data segment 0 length. */
+	__le32 dseg_1_address[2];	/* Data segment 1 address. */
+	__le32 dseg_1_length;		/* Data segment 1 length. */
 } cmd_a64_entry_t, request_t;
 
 /*
@@ -1640,21 +1640,21 @@ typedef struct {
 	uint8_t entry_count;		/* Entry count. */
 	uint8_t sys_define;		/* System defined. */
 	uint8_t entry_status;		/* Entry Status. */
-	uint32_t reserved;
-	uint32_t dseg_0_address;	/* Data segment 0 address. */
-	uint32_t dseg_0_length;		/* Data segment 0 length. */
-	uint32_t dseg_1_address;	/* Data segment 1 address. */
-	uint32_t dseg_1_length;		/* Data segment 1 length. */
-	uint32_t dseg_2_address;	/* Data segment 2 address. */
-	uint32_t dseg_2_length;		/* Data segment 2 length. */
-	uint32_t dseg_3_address;	/* Data segment 3 address. */
-	uint32_t dseg_3_length;		/* Data segment 3 length. */
-	uint32_t dseg_4_address;	/* Data segment 4 address. */
-	uint32_t dseg_4_length;		/* Data segment 4 length. */
-	uint32_t dseg_5_address;	/* Data segment 5 address. */
-	uint32_t dseg_5_length;		/* Data segment 5 length. */
-	uint32_t dseg_6_address;	/* Data segment 6 address. */
-	uint32_t dseg_6_length;		/* Data segment 6 length. */
+	__le32 reserved;
+	__le32 dseg_0_address;	/* Data segment 0 address. */
+	__le32 dseg_0_length;		/* Data segment 0 length. */
+	__le32 dseg_1_address;	/* Data segment 1 address. */
+	__le32 dseg_1_length;		/* Data segment 1 length. */
+	__le32 dseg_2_address;	/* Data segment 2 address. */
+	__le32 dseg_2_length;		/* Data segment 2 length. */
+	__le32 dseg_3_address;	/* Data segment 3 address. */
+	__le32 dseg_3_length;		/* Data segment 3 length. */
+	__le32 dseg_4_address;	/* Data segment 4 address. */
+	__le32 dseg_4_length;		/* Data segment 4 length. */
+	__le32 dseg_5_address;	/* Data segment 5 address. */
+	__le32 dseg_5_length;		/* Data segment 5 length. */
+	__le32 dseg_6_address;	/* Data segment 6 address. */
+	__le32 dseg_6_length;		/* Data segment 6 length. */
 } cont_entry_t;
 
 /*
@@ -1666,16 +1666,16 @@ typedef struct {
 	uint8_t entry_count;		/* Entry count. */
 	uint8_t sys_define;		/* System defined. */
 	uint8_t entry_status;		/* Entry Status. */
-	uint32_t dseg_0_address[2];	/* Data segment 0 address. */
-	uint32_t dseg_0_length;		/* Data segment 0 length. */
-	uint32_t dseg_1_address[2];	/* Data segment 1 address. */
-	uint32_t dseg_1_length;		/* Data segment 1 length. */
-	uint32_t dseg_2_address	[2];	/* Data segment 2 address. */
-	uint32_t dseg_2_length;		/* Data segment 2 length. */
-	uint32_t dseg_3_address[2];	/* Data segment 3 address. */
-	uint32_t dseg_3_length;		/* Data segment 3 length. */
-	uint32_t dseg_4_address[2];	/* Data segment 4 address. */
-	uint32_t dseg_4_length;		/* Data segment 4 length. */
+	__le32 dseg_0_address[2];	/* Data segment 0 address. */
+	__le32 dseg_0_length;		/* Data segment 0 length. */
+	__le32 dseg_1_address[2];	/* Data segment 1 address. */
+	__le32 dseg_1_length;		/* Data segment 1 length. */
+	__le32 dseg_2_address	[2];	/* Data segment 2 address. */
+	__le32 dseg_2_length;		/* Data segment 2 length. */
+	__le32 dseg_3_address[2];	/* Data segment 3 address. */
+	__le32 dseg_3_length;		/* Data segment 3 length. */
+	__le32 dseg_4_address[2];	/* Data segment 4 address. */
+	__le32 dseg_4_length;		/* Data segment 4 length. */
 } cont_a64_entry_t;
 
 #define PO_MODE_DIF_INSERT	0
@@ -1701,7 +1701,7 @@ typedef struct {
  * ISP queue - 64-Bit addressing, continuation crc entry structure definition.
  */
 struct crc_context {
-	uint32_t handle;		/* System handle. */
+	__le32 handle;		/* System handle. */
 	__le32 ref_tag;
 	__le16 app_tag;
 	uint8_t ref_tag_mask[4];	/* Validation/Replacement Mask*/
@@ -1709,31 +1709,31 @@ struct crc_context {
 	__le16 guard_seed;		/* Initial Guard Seed */
 	__le16 prot_opts;		/* Requested Data Protection Mode */
 	__le16 blk_size;		/* Data size in bytes */
-	uint16_t runt_blk_guard;	/* Guard value for runt block (tape
+	__le16 runt_blk_guard;	/* Guard value for runt block (tape
 					 * only) */
 	__le32 byte_count;		/* Total byte count/ total data
 					 * transfer count */
 	union {
 		struct {
-			uint32_t	reserved_1;
-			uint16_t	reserved_2;
-			uint16_t	reserved_3;
-			uint32_t	reserved_4;
-			uint32_t	data_address[2];
-			uint32_t	data_length;
-			uint32_t	reserved_5[2];
-			uint32_t	reserved_6;
+			__le32	reserved_1;
+			__le16	reserved_2;
+			__le16	reserved_3;
+			__le32	reserved_4;
+			__le32	data_address[2];
+			__le32	data_length;
+			__le32	reserved_5[2];
+			__le32	reserved_6;
 		} nobundling;
 		struct {
 			__le32	dif_byte_count;	/* Total DIF byte
 							 * count */
-			uint16_t	reserved_1;
+			__le16	reserved_1;
 			__le16	dseg_count;	/* Data segment count */
-			uint32_t	reserved_2;
-			uint32_t	data_address[2];
-			uint32_t	data_length;
-			uint32_t	dif_address[2];
-			uint32_t	dif_length;	/* Data segment 0
+			__le32	reserved_2;
+			__le32	data_address[2];
+			__le32	data_length;
+			__le32	dif_address[2];
+			__le32	dif_length;	/* Data segment 0
 							 * length */
 		} bundling;
 	} u;
@@ -1758,14 +1758,14 @@ typedef struct {
 	uint8_t entry_count;		/* Entry count. */
 	uint8_t sys_define;		/* System defined. */
 	uint8_t entry_status;		/* Entry Status. */
-	uint32_t handle;		/* System handle. */
-	uint16_t scsi_status;		/* SCSI status. */
-	uint16_t comp_status;		/* Completion status. */
-	uint16_t state_flags;		/* State flags. */
-	uint16_t status_flags;		/* Status flags. */
-	uint16_t rsp_info_len;		/* Response Info Length. */
-	uint16_t req_sense_length;	/* Request sense data length. */
-	uint32_t residual_length;	/* Residual transfer length. */
+	__le32 handle;		/* System handle. */
+	__le16 scsi_status;		/* SCSI status. */
+	__le16 comp_status;		/* Completion status. */
+	__le16 state_flags;		/* State flags. */
+	__le16 status_flags;		/* Status flags. */
+	__le16 rsp_info_len;		/* Response Info Length. */
+	__le16 req_sense_length;	/* Request sense data length. */
+	__le32 residual_length;	/* Residual transfer length. */
 	uint8_t rsp_info[8];		/* FCP response information. */
 	uint8_t req_sense_data[32];	/* Request sense data. */
 } sts_entry_t;
@@ -1861,7 +1861,7 @@ typedef struct {
 	uint8_t entry_count;		/* Entry count. */
 	uint8_t handle_count;		/* Handle count. */
 	uint8_t entry_status;		/* Entry Status. */
-	uint32_t handle[15];		/* System handles. */
+	__le32 handle[15];		/* System handles. */
 } sts21_entry_t;
 
 /*
@@ -1874,7 +1874,7 @@ typedef struct {
 	uint8_t entry_count;		/* Entry count. */
 	uint8_t handle_count;		/* Handle count. */
 	uint8_t entry_status;		/* Entry Status. */
-	uint16_t handle[30];		/* System handles. */
+	__le16 handle[30];		/* System handles. */
 } sts22_entry_t;
 
 /*
@@ -1886,7 +1886,7 @@ typedef struct {
 	uint8_t entry_count;		/* Entry count. */
 	uint8_t handle_count;		/* Handle count. */
 	uint8_t entry_status;		/* Entry Status. */
-	uint32_t sys_define_2;		/* System defined. */
+	__le32 sys_define_2;		/* System defined. */
 	target_id_t target;		/* SCSI ID */
 	uint8_t modifier;		/* Modifier (7-0). */
 #define MK_SYNC_ID_LUN	0		/* Synchronize ID/LUN */
@@ -1896,8 +1896,8 @@ typedef struct {
 					/* clear port changed, */
 					/* use sequence number. */
 	uint8_t reserved_1;
-	uint16_t sequence_number;	/* Sequence number of event */
-	uint16_t lun;			/* SCSI LUN */
+	__le16 sequence_number;	/* Sequence number of event */
+	__le16 lun;			/* SCSI LUN */
 	uint8_t reserved_2[48];
 } mrk_entry_t;
 
@@ -1910,25 +1910,25 @@ typedef struct {
 	uint8_t entry_count;		/* Entry count. */
 	uint8_t handle_count;		/* Handle count. */
 	uint8_t entry_status;		/* Entry Status. */
-	uint32_t handle1;		/* System handle. */
+	__le32 handle1;		/* System handle. */
 	target_id_t loop_id;
-	uint16_t status;
-	uint16_t control_flags;		/* Control flags. */
-	uint16_t reserved2;
-	uint16_t timeout;
-	uint16_t cmd_dsd_count;
-	uint16_t total_dsd_count;
+	__le16 status;
+	__le16 control_flags;		/* Control flags. */
+	__le16 reserved2;
+	__le16 timeout;
+	__le16 cmd_dsd_count;
+	__le16 total_dsd_count;
 	uint8_t type;
 	uint8_t r_ctl;
-	uint16_t rx_id;
-	uint16_t reserved3;
-	uint32_t handle2;
-	uint32_t rsp_bytecount;
-	uint32_t req_bytecount;
-	uint32_t dseg_req_address[2];	/* Data segment 0 address. */
-	uint32_t dseg_req_length;	/* Data segment 0 length. */
-	uint32_t dseg_rsp_address[2];	/* Data segment 1 address. */
-	uint32_t dseg_rsp_length;	/* Data segment 1 length. */
+	__le16 rx_id;
+	__le16 reserved3;
+	__le32 handle2;
+	__le32 rsp_bytecount;
+	__le32 req_bytecount;
+	__le32 dseg_req_address[2];	/* Data segment 0 address. */
+	__le32 dseg_req_length;	/* Data segment 0 length. */
+	__le32 dseg_rsp_address[2];	/* Data segment 1 address. */
+	__le32 dseg_rsp_length;	/* Data segment 1 length. */
 } ms_iocb_entry_t;
 
 
@@ -1951,24 +1951,24 @@ struct mbx_entry {
 
 	uint8_t entry_status;
 
-	uint32_t handle;
+	__le32 handle;
 	target_id_t loop_id;
 
-	uint16_t status;
-	uint16_t state_flags;
-	uint16_t status_flags;
-
-	uint32_t sys_define2[2];
-
-	uint16_t mb0;
-	uint16_t mb1;
-	uint16_t mb2;
-	uint16_t mb3;
-	uint16_t mb6;
-	uint16_t mb7;
-	uint16_t mb9;
-	uint16_t mb10;
-	uint32_t reserved_2[2];
+	__le16 status;
+	__le16 state_flags;
+	__le16 status_flags;
+
+	__le32 sys_define2[2];
+
+	__le16 mb0;
+	__le16 mb1;
+	__le16 mb2;
+	__le16 mb3;
+	__le16 mb6;
+	__le16 mb7;
+	__le16 mb9;
+	__le16 mb10;
+	__le32 reserved_2[2];
 	uint8_t node_name[WWN_SIZE];
 	uint8_t port_name[WWN_SIZE];
 };
@@ -2204,8 +2204,8 @@ static const char * const port_state_str[] = {
 #define FDMI_HBA_TYPE_VENDOR_IDENTIFIER		0xe0
 
 struct ct_fdmi_hba_attr {
-	uint16_t type;
-	uint16_t len;
+	__be16 type;
+	__be16 len;
 	union {
 		uint8_t node_name[WWN_SIZE];
 		uint8_t manufacturer[64];
@@ -2217,18 +2217,18 @@ struct ct_fdmi_hba_attr {
 		uint8_t orom_version[16];
 		uint8_t fw_version[32];
 		uint8_t os_version[128];
-		uint32_t max_ct_len;
+		__be32 max_ct_len;
 	} a;
 };
 
 struct ct_fdmi_hba_attributes {
-	uint32_t count;
+	__be32 count;
 	struct ct_fdmi_hba_attr entry[FDMI_HBA_ATTR_COUNT];
 };
 
 struct ct_fdmiv2_hba_attr {
-	uint16_t type;
-	uint16_t len;
+	__be16 type;
+	__be16 len;
 	union {
 		uint8_t node_name[WWN_SIZE];
 		uint8_t manufacturer[64];
@@ -2240,10 +2240,10 @@ struct ct_fdmiv2_hba_attr {
 		uint8_t orom_version[16];
 		uint8_t fw_version[32];
 		uint8_t os_version[128];
-		uint32_t max_ct_len;
+		__be32 max_ct_len;
 		uint8_t sym_name[256];
-		uint32_t vendor_id;
-		uint32_t num_ports;
+		__be32 vendor_id;
+		__be32 num_ports;
 		uint8_t fabric_name[WWN_SIZE];
 		uint8_t bios_name[32];
 		uint8_t vendor_indentifer[8];
@@ -2251,7 +2251,7 @@ struct ct_fdmiv2_hba_attr {
 };
 
 struct ct_fdmiv2_hba_attributes {
-	uint32_t count;
+	__be32 count;
 	struct ct_fdmiv2_hba_attr entry[FDMIV2_HBA_ATTR_COUNT];
 };
 
@@ -2291,25 +2291,25 @@ struct ct_fdmiv2_hba_attributes {
 #define FC_CLASS_2_3	0x0C
 
 struct ct_fdmiv2_port_attr {
-	uint16_t type;
-	uint16_t len;
+	__be16 type;
+	__be16 len;
 	union {
 		uint8_t fc4_types[32];
-		uint32_t sup_speed;
-		uint32_t cur_speed;
-		uint32_t max_frame_size;
+		__be32 sup_speed;
+		__be32 cur_speed;
+		__be32 max_frame_size;
 		uint8_t os_dev_name[32];
 		uint8_t host_name[256];
 		uint8_t node_name[WWN_SIZE];
 		uint8_t port_name[WWN_SIZE];
 		uint8_t port_sym_name[128];
-		uint32_t port_type;
-		uint32_t port_supported_cos;
+		__be32 port_type;
+		__be32 port_supported_cos;
 		uint8_t fabric_name[WWN_SIZE];
 		uint8_t port_fc4_type[32];
-		uint32_t port_state;
-		uint32_t num_ports;
-		uint32_t port_id;
+		__be32 port_state;
+		__be32 num_ports;
+		__be32 port_id;
 	} a;
 };
 
@@ -2317,25 +2317,25 @@ struct ct_fdmiv2_port_attr {
  * Port Attribute Block.
  */
 struct ct_fdmiv2_port_attributes {
-	uint32_t count;
+	__be32 count;
 	struct ct_fdmiv2_port_attr entry[FDMIV2_PORT_ATTR_COUNT];
 };
 
 struct ct_fdmi_port_attr {
-	uint16_t type;
-	uint16_t len;
+	__be16 type;
+	__be16 len;
 	union {
 		uint8_t fc4_types[32];
-		uint32_t sup_speed;
-		uint32_t cur_speed;
-		uint32_t max_frame_size;
+		__be32 sup_speed;
+		__be32 cur_speed;
+		__be32 max_frame_size;
 		uint8_t os_dev_name[32];
 		uint8_t host_name[256];
 	} a;
 };
 
 struct ct_fdmi_port_attributes {
-	uint32_t count;
+	__be32 count;
 	struct ct_fdmi_port_attr entry[FDMI_PORT_ATTR_COUNT];
 };
 
@@ -2375,8 +2375,8 @@ struct ct_cmd_hdr {
 /* CT command request */
 struct ct_sns_req {
 	struct ct_cmd_hdr header;
-	uint16_t command;
-	uint16_t max_rsp_size;
+	__be16 command;
+	__be16 max_rsp_size;
 	uint8_t fragment_id;
 	uint8_t reserved[3];
 
@@ -2403,7 +2403,7 @@ struct ct_sns_req {
 		struct {
 			uint8_t reserved;
 			uint8_t port_id[3];
-			uint16_t reserved2;
+			__be16 reserved2;
 			uint8_t fc4_feature;
 			uint8_t fc4_type;
 		} rff_id;
@@ -2426,14 +2426,14 @@ struct ct_sns_req {
 
 		struct {
 			uint8_t hba_identifier[8];
-			uint32_t entry_count;
+			__be32 entry_count;
 			uint8_t port_name[8];
 			struct ct_fdmi_hba_attributes attrs;
 		} rhba;
 
 		struct {
 			uint8_t hba_identifier[8];
-			uint32_t entry_count;
+			__be32 entry_count;
 			uint8_t port_name[8];
 			struct ct_fdmiv2_hba_attributes attrs;
 		} rhba2;
@@ -2483,8 +2483,8 @@ struct ct_sns_req {
 /* CT command response header */
 struct ct_rsp_hdr {
 	struct ct_cmd_hdr header;
-	uint16_t response;
-	uint16_t residual;
+	__be16 response;
+	__be16 residual;
 	uint8_t fragment_id;
 	uint8_t reason_code;
 	uint8_t explanation_code;
@@ -2538,7 +2538,7 @@ struct ct_sns_rsp {
 		} gft_id;
 
 		struct {
-			uint32_t entry_count;
+			__be32 entry_count;
 			uint8_t port_name[8];
 			struct ct_fdmi_hba_attributes attrs;
 		} ghat;
@@ -2548,8 +2548,8 @@ struct ct_sns_rsp {
 		} gfpn_id;
 
 		struct {
-			uint16_t speeds;
-			uint16_t speed;
+			__be16 speeds;
+			__be16 speed;
 		} gpsc;
 
 #define GFF_FCP_SCSI_OFFSET	7
@@ -2600,14 +2600,14 @@ struct ct_sns_pkt {
 struct sns_cmd_pkt {
 	union {
 		struct {
-			uint16_t buffer_length;
-			uint16_t reserved_1;
-			uint32_t buffer_address[2];
-			uint16_t subcommand_length;
-			uint16_t reserved_2;
-			uint16_t subcommand;
-			uint16_t size;
-			uint32_t reserved_3;
+			__le16 buffer_length;
+			__le16 reserved_1;
+			__le32 buffer_address[2];
+			__le16 subcommand_length;
+			__le16 reserved_2;
+			__le16 subcommand;
+			__le16 size;
+			__le32 reserved_3;
 			uint8_t param[36];
 		} cmd;
 
@@ -2632,7 +2632,7 @@ struct gid_list_info {
 	uint8_t	area;
 	uint8_t	domain;
 	uint8_t	loop_id_2100;	/* ISP2100/ISP2200 -- 4 bytes. */
-	uint16_t loop_id;	/* ISP23XX         -- 6 bytes. */
+	__le16 loop_id;	/* ISP23XX         -- 6 bytes. */
 	uint16_t reserved_1;	/* ISP24XX         -- 8 bytes. */
 };
 
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 8a2368b..8e49019 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -29,7 +29,7 @@
 
 #define	PORT_DATABASE_24XX_SIZE		64
 struct port_database_24xx {
-	uint16_t flags;
+	__le16 flags;
 #define PDF_TASK_RETRY_ID	BIT_14
 #define PDF_FC_TAPE		BIT_7
 #define PDF_ACK0_CAPABLE	BIT_6
@@ -54,12 +54,12 @@ struct port_database_24xx {
 	uint8_t port_id[3];
 	uint8_t sequence_id;
 
-	uint16_t port_timer;
+	__le16 port_timer;
 
-	uint16_t nport_handle;			/* N_PORT handle. */
+	__le16 nport_handle;			/* N_PORT handle. */
 
-	uint16_t receive_data_size;
-	uint16_t reserved_2;
+	__le16 receive_data_size;
+	__le16 reserved_2;
 
 	uint8_t prli_svc_param_word_0[2];	/* Big endian */
 						/* Bits 15-0 of word 0 */
@@ -73,40 +73,40 @@ struct port_database_24xx {
 };
 
 struct vp_database_24xx {
-	uint16_t vp_status;
+	__le16 vp_status;
 	uint8_t  options;
 	uint8_t  id;
 	uint8_t  port_name[WWN_SIZE];
 	uint8_t  node_name[WWN_SIZE];
-	uint16_t port_id_low;
-	uint16_t port_id_high;
+	__le16 port_id_low;
+	__le16 port_id_high;
 };
 
 struct nvram_24xx {
 	/* NVRAM header. */
 	uint8_t id[4];
-	uint16_t nvram_version;
-	uint16_t reserved_0;
+	__le16 nvram_version;
+	__le16 reserved_0;
 
 	/* Firmware Initialization Control Block. */
-	uint16_t version;
-	uint16_t reserved_1;
+	__le16 version;
+	__le16 reserved_1;
 	__le16 frame_payload_size;
-	uint16_t execution_throttle;
-	uint16_t exchange_count;
-	uint16_t hard_address;
+	__le16 execution_throttle;
+	__le16 exchange_count;
+	__le16 hard_address;
 
 	uint8_t port_name[WWN_SIZE];
 	uint8_t node_name[WWN_SIZE];
 
-	uint16_t login_retry_count;
-	uint16_t link_down_on_nos;
-	uint16_t interrupt_delay_timer;
-	uint16_t login_timeout;
+	__le16 login_retry_count;
+	__le16 link_down_on_nos;
+	__le16 interrupt_delay_timer;
+	__le16 login_timeout;
 
-	uint32_t firmware_options_1;
-	uint32_t firmware_options_2;
-	uint32_t firmware_options_3;
+	__le32 firmware_options_1;
+	__le32 firmware_options_2;
+	__le32 firmware_options_3;
 
 	/* Offset 56. */
 
@@ -129,24 +129,24 @@ struct nvram_24xx {
 	 * BIT 11-13 = Output Emphasis 4G
 	 * BIT 14-15 = Reserved
 	 */
-	uint16_t seriallink_options[4];
+	__le16 seriallink_options[4];
 
-	uint16_t reserved_2[16];
+	__le16 reserved_2[16];
 
 	/* Offset 96. */
-	uint16_t reserved_3[16];
+	__le16 reserved_3[16];
 
 	/* PCIe table entries. */
-	uint16_t reserved_4[16];
+	__le16 reserved_4[16];
 
 	/* Offset 160. */
-	uint16_t reserved_5[16];
+	__le16 reserved_5[16];
 
 	/* Offset 192. */
-	uint16_t reserved_6[16];
+	__le16 reserved_6[16];
 
 	/* Offset 224. */
-	uint16_t reserved_7[16];
+	__le16 reserved_7[16];
 
 	/*
 	 * BIT 0  = Enable spinup delay
@@ -169,26 +169,26 @@ struct nvram_24xx {
 	 *
 	 * BIT 16-31 =
 	 */
-	uint32_t host_p;
+	__le32 host_p;
 
 	uint8_t alternate_port_name[WWN_SIZE];
 	uint8_t alternate_node_name[WWN_SIZE];
 
 	uint8_t boot_port_name[WWN_SIZE];
-	uint16_t boot_lun_number;
-	uint16_t reserved_8;
+	__le16 boot_lun_number;
+	__le16 reserved_8;
 
 	uint8_t alt1_boot_port_name[WWN_SIZE];
-	uint16_t alt1_boot_lun_number;
-	uint16_t reserved_9;
+	__le16 alt1_boot_lun_number;
+	__le16 reserved_9;
 
 	uint8_t alt2_boot_port_name[WWN_SIZE];
-	uint16_t alt2_boot_lun_number;
-	uint16_t reserved_10;
+	__le16 alt2_boot_lun_number;
+	__le16 reserved_10;
 
 	uint8_t alt3_boot_port_name[WWN_SIZE];
-	uint16_t alt3_boot_lun_number;
-	uint16_t reserved_11;
+	__le16 alt3_boot_lun_number;
+	__le16 reserved_11;
 
 	/*
 	 * BIT 0 = Selective Login
@@ -200,25 +200,25 @@ struct nvram_24xx {
 	 * BIT 6 = Reserved
 	 * BIT 7-31 =
 	 */
-	uint32_t efi_parameters;
+	__le32 efi_parameters;
 
 	uint8_t reset_delay;
 	uint8_t reserved_12;
-	uint16_t reserved_13;
+	__le16 reserved_13;
 
-	uint16_t boot_id_number;
-	uint16_t reserved_14;
+	__le16 boot_id_number;
+	__le16 reserved_14;
 
-	uint16_t max_luns_per_target;
-	uint16_t reserved_15;
+	__le16 max_luns_per_target;
+	__le16 reserved_15;
 
-	uint16_t port_down_retry_count;
-	uint16_t link_down_timeout;
+	__le16 port_down_retry_count;
+	__le16 link_down_timeout;
 
 	/* FCode parameters. */
-	uint16_t fcode_parameter;
+	__le16 fcode_parameter;
 
-	uint16_t reserved_16[3];
+	__le16 reserved_16[3];
 
 	/* Offset 352. */
 	uint8_t prev_drv_ver_major;
@@ -226,41 +226,41 @@ struct nvram_24xx {
 	uint8_t prev_drv_ver_minor;
 	uint8_t prev_drv_ver_subminor;
 
-	uint16_t prev_bios_ver_major;
-	uint16_t prev_bios_ver_minor;
+	__le16 prev_bios_ver_major;
+	__le16 prev_bios_ver_minor;
 
-	uint16_t prev_efi_ver_major;
-	uint16_t prev_efi_ver_minor;
+	__le16 prev_efi_ver_major;
+	__le16 prev_efi_ver_minor;
 
-	uint16_t prev_fw_ver_major;
+	__le16 prev_fw_ver_major;
 	uint8_t prev_fw_ver_minor;
 	uint8_t prev_fw_ver_subminor;
 
-	uint16_t reserved_17[8];
+	__le16 reserved_17[8];
 
 	/* Offset 384. */
-	uint16_t reserved_18[16];
+	__le16 reserved_18[16];
 
 	/* Offset 416. */
-	uint16_t reserved_19[16];
+	__le16 reserved_19[16];
 
 	/* Offset 448. */
-	uint16_t reserved_20[16];
+	__le16 reserved_20[16];
 
 	/* Offset 480. */
 	uint8_t model_name[16];
 
-	uint16_t reserved_21[2];
+	__le16 reserved_21[2];
 
 	/* Offset 500. */
 	/* HW Parameter Block. */
-	uint16_t pcie_table_sig;
-	uint16_t pcie_table_offset;
+	__le16 pcie_table_sig;
+	__le16 pcie_table_offset;
 
-	uint16_t subsystem_vendor_id;
-	uint16_t subsystem_device_id;
+	__le16 subsystem_vendor_id;
+	__le16 subsystem_device_id;
 
-	uint32_t checksum;
+	__le32 checksum;
 };
 
 /*
@@ -269,46 +269,46 @@ struct nvram_24xx {
  */
 #define	ICB_VERSION 1
 struct init_cb_24xx {
-	uint16_t version;
-	uint16_t reserved_1;
+	__le16 version;
+	__le16 reserved_1;
 
-	uint16_t frame_payload_size;
-	uint16_t execution_throttle;
-	uint16_t exchange_count;
+	__le16 frame_payload_size;
+	__le16 execution_throttle;
+	__le16 exchange_count;
 
-	uint16_t hard_address;
+	__le16 hard_address;
 
 	uint8_t port_name[WWN_SIZE];		/* Big endian. */
 	uint8_t node_name[WWN_SIZE];		/* Big endian. */
 
-	uint16_t response_q_inpointer;
-	uint16_t request_q_outpointer;
+	__le16 response_q_inpointer;
+	__le16 request_q_outpointer;
 
-	uint16_t login_retry_count;
+	__le16 login_retry_count;
 
-	uint16_t prio_request_q_outpointer;
+	__le16 prio_request_q_outpointer;
 
-	uint16_t response_q_length;
-	uint16_t request_q_length;
+	__le16 response_q_length;
+	__le16 request_q_length;
 
-	uint16_t link_down_on_nos;		/* Milliseconds. */
+	__le16 link_down_on_nos;		/* Milliseconds. */
 
-	uint16_t prio_request_q_length;
+	__le16 prio_request_q_length;
 
-	uint32_t request_q_address[2];
-	uint32_t response_q_address[2];
-	uint32_t prio_request_q_address[2];
+	__le32 request_q_address[2];
+	__le32 response_q_address[2];
+	__le32 prio_request_q_address[2];
 
-	uint16_t msix;
-	uint16_t msix_atio;
+	__le16 msix;
+	__le16 msix_atio;
 	uint8_t reserved_2[4];
 
-	uint16_t atio_q_inpointer;
-	uint16_t atio_q_length;
-	uint32_t atio_q_address[2];
+	__le16 atio_q_inpointer;
+	__le16 atio_q_length;
+	__le32 atio_q_address[2];
 
-	uint16_t interrupt_delay_timer;		/* 100us increments. */
-	uint16_t login_timeout;
+	__le16 interrupt_delay_timer;		/* 100us increments. */
+	__le16 login_timeout;
 
 	/*
 	 * BIT 0  = Enable Hard Loop Id
@@ -329,7 +329,7 @@ struct init_cb_24xx {
 	 * BIT 14 = Node Name Option
 	 * BIT 15-31 = Reserved
 	 */
-	uint32_t firmware_options_1;
+	__le32 firmware_options_1;
 
 	/*
 	 * BIT 0  = Operation Mode bit 0
@@ -350,7 +350,7 @@ struct init_cb_24xx {
 	 * BIT 14 = Enable Target PRLI Control
 	 * BIT 15-31 = Reserved
 	 */
-	uint32_t firmware_options_2;
+	__le32 firmware_options_2;
 
 	/*
 	 * BIT 0  = Reserved
@@ -376,9 +376,9 @@ struct init_cb_24xx {
 	 * BIT 30 = Enable request queue 0 out index shadowing
 	 * BIT 31 = Reserved
 	 */
-	uint32_t firmware_options_3;
-	uint16_t qos;
-	uint16_t rid;
+	__le32 firmware_options_3;
+	__le16 qos;
+	__le16 rid;
 	uint8_t  reserved_3[20];
 };
 
@@ -392,35 +392,35 @@ struct cmd_bidir {
 	uint8_t sys_define;		/* System defined */
 	uint8_t entry_status;		/* Entry status. */
 
-	uint32_t handle;		/* System handle. */
+	__le32 handle;		/* System handle. */
 
-	uint16_t nport_handle;		/* N_PORT hanlde. */
+	__le16 nport_handle;		/* N_PORT hanlde. */
 
-	uint16_t timeout;		/* Commnad timeout. */
+	__le16 timeout;		/* Commnad timeout. */
 
-	uint16_t wr_dseg_count;		/* Write Data segment count. */
-	uint16_t rd_dseg_count;		/* Read Data segment count. */
+	__le16 wr_dseg_count;		/* Write Data segment count. */
+	__le16 rd_dseg_count;		/* Read Data segment count. */
 
 	struct scsi_lun lun;		/* FCP LUN (BE). */
 
-	uint16_t control_flags;		/* Control flags. */
+	__le16 control_flags;		/* Control flags. */
 #define BD_WRAP_BACK			BIT_3
 #define BD_READ_DATA			BIT_1
 #define BD_WRITE_DATA			BIT_0
 
-	uint16_t fcp_cmnd_dseg_len;		/* Data segment length. */
-	uint32_t fcp_cmnd_dseg_address[2];	/* Data segment address. */
+	__le16 fcp_cmnd_dseg_len;		/* Data segment length. */
+	__le32 fcp_cmnd_dseg_address[2];	/* Data segment address. */
 
-	uint16_t reserved[2];			/* Reserved */
+	__le16 reserved[2];			/* Reserved */
 
-	uint32_t rd_byte_count;			/* Total Byte count Read. */
-	uint32_t wr_byte_count;			/* Total Byte count write. */
+	__le32 rd_byte_count;			/* Total Byte count Read. */
+	__le32 wr_byte_count;			/* Total Byte count write. */
 
 	uint8_t port_id[3];			/* PortID of destination port.*/
 	uint8_t vp_index;
 
-	uint32_t fcp_data_dseg_address[2];	/* Data segment address. */
-	uint16_t fcp_data_dseg_len;		/* Data segment length. */
+	__le32 fcp_data_dseg_address[2];	/* Data segment address. */
+	__le16 fcp_data_dseg_len;		/* Data segment length. */
 };
 
 #define COMMAND_TYPE_6	0x48		/* Command Type 6 entry */
@@ -430,35 +430,35 @@ struct cmd_type_6 {
 	uint8_t sys_define;		/* System defined. */
 	uint8_t entry_status;		/* Entry Status. */
 
-	uint32_t handle;		/* System handle. */
+	__le32 handle;		/* System handle. */
 
-	uint16_t nport_handle;		/* N_PORT handle. */
-	uint16_t timeout;		/* Command timeout. */
+	__le16 nport_handle;		/* N_PORT handle. */
+	__le16 timeout;		/* Command timeout. */
 
-	uint16_t dseg_count;		/* Data segment count. */
+	__le16 dseg_count;		/* Data segment count. */
 
-	uint16_t fcp_rsp_dsd_len;	/* FCP_RSP DSD length. */
+	__le16 fcp_rsp_dsd_len;	/* FCP_RSP DSD length. */
 
 	struct scsi_lun lun;		/* FCP LUN (BE). */
 
-	uint16_t control_flags;		/* Control flags. */
+	__le16 control_flags;		/* Control flags. */
 #define CF_DIF_SEG_DESCR_ENABLE		BIT_3
 #define CF_DATA_SEG_DESCR_ENABLE	BIT_2
 #define CF_READ_DATA			BIT_1
 #define CF_WRITE_DATA			BIT_0
 
-	uint16_t fcp_cmnd_dseg_len;		/* Data segment length. */
-	uint32_t fcp_cmnd_dseg_address[2];	/* Data segment address. */
+	__le16 fcp_cmnd_dseg_len;		/* Data segment length. */
+	__le32 fcp_cmnd_dseg_address[2];	/* Data segment address. */
 
-	uint32_t fcp_rsp_dseg_address[2];	/* Data segment address. */
+	__le32 fcp_rsp_dseg_address[2];	/* Data segment address. */
 
-	uint32_t byte_count;		/* Total byte count. */
+	__le32 byte_count;		/* Total byte count. */
 
 	uint8_t port_id[3];		/* PortID of destination port. */
 	uint8_t vp_index;
 
-	uint32_t fcp_data_dseg_address[2];	/* Data segment address. */
-	uint32_t fcp_data_dseg_len;		/* Data segment length. */
+	__le32 fcp_data_dseg_address[2];	/* Data segment address. */
+	__le32 fcp_data_dseg_len;		/* Data segment length. */
 };
 
 #define COMMAND_TYPE_7	0x18		/* Command Type 7 entry */
@@ -468,18 +468,18 @@ struct cmd_type_7 {
 	uint8_t sys_define;		/* System defined. */
 	uint8_t entry_status;		/* Entry Status. */
 
-	uint32_t handle;		/* System handle. */
+	__le32 handle;		/* System handle. */
 
-	uint16_t nport_handle;		/* N_PORT handle. */
-	uint16_t timeout;		/* Command timeout. */
+	__le16 nport_handle;		/* N_PORT handle. */
+	__le16 timeout;		/* Command timeout. */
 #define FW_MAX_TIMEOUT		0x1999
 
-	uint16_t dseg_count;		/* Data segment count. */
-	uint16_t reserved_1;
+	__le16 dseg_count;		/* Data segment count. */
+	__le16 reserved_1;
 
 	struct scsi_lun lun;		/* FCP LUN (BE). */
 
-	uint16_t task_mgmt_flags;	/* Task management flags. */
+	__le16 task_mgmt_flags;	/* Task management flags. */
 #define TMF_CLEAR_ACA		BIT_14
 #define TMF_TARGET_RESET	BIT_13
 #define TMF_LUN_RESET		BIT_12
@@ -499,13 +499,13 @@ struct cmd_type_7 {
 	uint8_t crn;
 
 	uint8_t fcp_cdb[MAX_CMDSZ]; 	/* SCSI command words. */
-	uint32_t byte_count;		/* Total byte count. */
+	__le32 byte_count;		/* Total byte count. */
 
 	uint8_t port_id[3];		/* PortID of destination port. */
 	uint8_t vp_index;
 
-	uint32_t dseg_0_address[2];	/* Data segment 0 address. */
-	uint32_t dseg_0_len;		/* Data segment 0 length. */
+	__le32 dseg_0_address[2];	/* Data segment 0 address. */
+	__le32 dseg_0_len;		/* Data segment 0 length. */
 };
 
 #define COMMAND_TYPE_CRC_2	0x6A	/* Command Type CRC_2 (Type 6)
@@ -516,32 +516,32 @@ struct cmd_type_crc_2 {
 	uint8_t sys_define;		/* System defined. */
 	uint8_t entry_status;		/* Entry Status. */
 
-	uint32_t handle;		/* System handle. */
+	__le32 handle;		/* System handle. */
 
-	uint16_t nport_handle;		/* N_PORT handle. */
-	uint16_t timeout;		/* Command timeout. */
+	__le16 nport_handle;		/* N_PORT handle. */
+	__le16 timeout;		/* Command timeout. */
 
-	uint16_t dseg_count;		/* Data segment count. */
+	__le16 dseg_count;		/* Data segment count. */
 
-	uint16_t fcp_rsp_dseg_len;	/* FCP_RSP DSD length. */
+	__le16 fcp_rsp_dseg_len;	/* FCP_RSP DSD length. */
 
 	struct scsi_lun lun;		/* FCP LUN (BE). */
 
-	uint16_t control_flags;		/* Control flags. */
+	__le16 control_flags;		/* Control flags. */
 
-	uint16_t fcp_cmnd_dseg_len;		/* Data segment length. */
-	uint32_t fcp_cmnd_dseg_address[2];	/* Data segment address. */
+	__le16 fcp_cmnd_dseg_len;		/* Data segment length. */
+	__le32 fcp_cmnd_dseg_address[2];	/* Data segment address. */
 
-	uint32_t fcp_rsp_dseg_address[2];	/* Data segment address. */
+	__le32 fcp_rsp_dseg_address[2];	/* Data segment address. */
 
-	uint32_t byte_count;		/* Total byte count. */
+	__le32 byte_count;		/* Total byte count. */
 
 	uint8_t port_id[3];		/* PortID of destination port. */
 	uint8_t vp_index;
 
-	uint32_t crc_context_address[2];	/* Data segment address. */
-	uint16_t crc_context_len;		/* Data segment length. */
-	uint16_t reserved_1;			/* MUST be set to 0. */
+	__le32 crc_context_address[2];	/* Data segment address. */
+	__le16 crc_context_len;		/* Data segment length. */
+	__le16 reserved_1;			/* MUST be set to 0. */
 };
 
 
@@ -555,26 +555,26 @@ struct sts_entry_24xx {
 	uint8_t sys_define;		/* System defined. */
 	uint8_t entry_status;		/* Entry Status. */
 
-	uint32_t handle;		/* System handle. */
+	__le32 handle;		/* System handle. */
 
-	uint16_t comp_status;		/* Completion status. */
-	uint16_t ox_id;			/* OX_ID used by the firmware. */
+	__le16 comp_status;		/* Completion status. */
+	__le16 ox_id;			/* OX_ID used by the firmware. */
 
-	uint32_t residual_len;		/* FW calc residual transfer length. */
+	__le32 residual_len;		/* FW calc residual transfer length. */
 
-	uint16_t reserved_1;
-	uint16_t state_flags;		/* State flags. */
+	__le16 reserved_1;
+	__le16 state_flags;		/* State flags. */
 #define SF_TRANSFERRED_DATA	BIT_11
 #define SF_FCP_RSP_DMA		BIT_0
 
-	uint16_t retry_delay;
-	uint16_t scsi_status;		/* SCSI status. */
+	__le16 retry_delay;
+	__le16 scsi_status;		/* SCSI status. */
 #define SS_CONFIRMATION_REQ		BIT_12
 
-	uint32_t rsp_residual_count;	/* FCP RSP residual count. */
+	__le32 rsp_residual_count;	/* FCP RSP residual count. */
 
-	uint32_t sense_len;		/* FCP SENSE length. */
-	uint32_t rsp_data_len;		/* FCP response data length. */
+	__le32 sense_len;		/* FCP SENSE length. */
+	__le32 rsp_data_len;		/* FCP response data length. */
 	uint8_t data[28];		/* FCP response/sense information. */
 	/*
 	 * If DIF Error is set in comp_status, these additional fields are
@@ -610,9 +610,9 @@ struct mrk_entry_24xx {
 	uint8_t handle_count;		/* Handle count. */
 	uint8_t entry_status;		/* Entry Status. */
 
-	uint32_t handle;		/* System handle. */
+	__le32 handle;		/* System handle. */
 
-	uint16_t nport_handle;		/* N_PORT handle. */
+	__le16 nport_handle;		/* N_PORT handle. */
 
 	uint8_t modifier;		/* Modifier (7-0). */
 #define MK_SYNC_ID_LUN	0		/* Synchronize ID/LUN */
@@ -623,7 +623,7 @@ struct mrk_entry_24xx {
 	uint8_t reserved_2;
 	uint8_t vp_index;
 
-	uint16_t reserved_3;
+	__le16 reserved_3;
 
 	uint8_t lun[8];			/* FCP LUN (BE). */
 	uint8_t reserved_4[40];
@@ -639,31 +639,31 @@ struct ct_entry_24xx {
 	uint8_t sys_define;		/* System Defined. */
 	uint8_t entry_status;		/* Entry Status. */
 
-	uint32_t handle;		/* System handle. */
+	__le32 handle;		/* System handle. */
 
-	uint16_t comp_status;		/* Completion status. */
+	__le16 comp_status;		/* Completion status. */
 
-	uint16_t nport_handle;		/* N_PORT handle. */
+	__le16 nport_handle;		/* N_PORT handle. */
 
-	uint16_t cmd_dsd_count;
+	__le16 cmd_dsd_count;
 
 	uint8_t vp_index;
 	uint8_t reserved_1;
 
-	uint16_t timeout;		/* Command timeout. */
-	uint16_t reserved_2;
+	__le16 timeout;		/* Command timeout. */
+	__le16 reserved_2;
 
-	uint16_t rsp_dsd_count;
+	__le16 rsp_dsd_count;
 
 	uint8_t reserved_3[10];
 
-	uint32_t rsp_byte_count;
-	uint32_t cmd_byte_count;
+	__le32 rsp_byte_count;
+	__le32 cmd_byte_count;
 
-	uint32_t dseg_0_address[2];	/* Data segment 0 address. */
-	uint32_t dseg_0_len;		/* Data segment 0 length. */
-	uint32_t dseg_1_address[2];	/* Data segment 1 address. */
-	uint32_t dseg_1_len;		/* Data segment 1 length. */
+	__le32 dseg_0_address[2];	/* Data segment 0 address. */
+	__le32 dseg_0_len;		/* Data segment 0 length. */
+	__le32 dseg_1_address[2];	/* Data segment 1 address. */
+	__le32 dseg_1_len;		/* Data segment 1 length. */
 };
 
 /*
@@ -676,21 +676,21 @@ struct els_entry_24xx {
 	uint8_t sys_define;		/* System Defined. */
 	uint8_t entry_status;		/* Entry Status. */
 
-	uint32_t handle;		/* System handle. */
+	__le32 handle;		/* System handle. */
 
-	uint16_t reserved_1;
+	__le16 reserved_1;
 
-	uint16_t nport_handle;		/* N_PORT handle. */
+	__le16 nport_handle;		/* N_PORT handle. */
 
-	uint16_t tx_dsd_count;
+	__le16 tx_dsd_count;
 
 	uint8_t vp_index;
 	uint8_t sof_type;
 #define EST_SOFI3		(1 << 4)
 #define EST_SOFI2		(3 << 4)
 
-	uint32_t rx_xchg_address;	/* Receive exchange address. */
-	uint16_t rx_dsd_count;
+	__le32 rx_xchg_address;	/* Receive exchange address. */
+	__le16 rx_dsd_count;
 
 	uint8_t opcode;
 	uint8_t reserved_2;
@@ -698,9 +698,9 @@ struct els_entry_24xx {
 	uint8_t port_id[3];
 	uint8_t reserved_3;
 
-	uint16_t reserved_4;
+	__le16 reserved_4;
 
-	uint16_t control_flags;		/* Control flags. */
+	__le16 control_flags;		/* Control flags. */
 #define ECF_PAYLOAD_DESCR_MASK	(BIT_15|BIT_14|BIT_13)
 #define EPD_ELS_COMMAND		(0 << 13)
 #define EPD_ELS_ACC		(1 << 13)
@@ -709,13 +709,13 @@ struct els_entry_24xx {
 #define ECF_CLR_PASSTHRU_PEND	BIT_12
 #define ECF_INCL_FRAME_HDR	BIT_11
 
-	uint32_t rx_byte_count;
-	uint32_t tx_byte_count;
+	__le32 rx_byte_count;
+	__le32 tx_byte_count;
 
-	uint32_t tx_address[2];		/* Data segment 0 address. */
-	uint32_t tx_len;		/* Data segment 0 length. */
-	uint32_t rx_address[2];		/* Data segment 1 address. */
-	uint32_t rx_len;		/* Data segment 1 length. */
+	__le32 tx_address[2];		/* Data segment 0 address. */
+	__le32 tx_len;		/* Data segment 0 length. */
+	__le32 rx_address[2];		/* Data segment 1 address. */
+	__le32 rx_len;		/* Data segment 1 length. */
 };
 
 struct els_sts_entry_24xx {
@@ -724,19 +724,19 @@ struct els_sts_entry_24xx {
 	uint8_t sys_define;		/* System Defined. */
 	uint8_t entry_status;		/* Entry Status. */
 
-	uint32_t handle;		/* System handle. */
+	__le32 handle;		/* System handle. */
 
-	uint16_t comp_status;
+	__le16 comp_status;
 
-	uint16_t nport_handle;		/* N_PORT handle. */
+	__le16 nport_handle;		/* N_PORT handle. */
 
-	uint16_t reserved_1;
+	__le16 reserved_1;
 
 	uint8_t vp_index;
 	uint8_t sof_type;
 
-	uint32_t rx_xchg_address;	/* Receive exchange address. */
-	uint16_t reserved_2;
+	__le32 rx_xchg_address;	/* Receive exchange address. */
+	__le16 reserved_2;
 
 	uint8_t opcode;
 	uint8_t reserved_3;
@@ -744,12 +744,12 @@ struct els_sts_entry_24xx {
 	uint8_t port_id[3];
 	uint8_t reserved_4;
 
-	uint16_t reserved_5;
+	__le16 reserved_5;
 
-	uint16_t control_flags;		/* Control flags. */
-	uint32_t total_byte_count;
-	uint32_t error_subcode_1;
-	uint32_t error_subcode_2;
+	__le16 control_flags;		/* Control flags. */
+	__le32 total_byte_count;
+	__le32 error_subcode_1;
+	__le32 error_subcode_2;
 };
 /*
  * ISP queue - Mailbox Command entry structure definition.
@@ -761,9 +761,9 @@ struct mbx_entry_24xx {
 	uint8_t handle_count;		/* Handle count. */
 	uint8_t entry_status;		/* Entry Status. */
 
-	uint32_t handle;		/* System handle. */
+	__le32 handle;		/* System handle. */
 
-	uint16_t mbx[28];
+	__le16 mbx[28];
 };
 
 
@@ -774,14 +774,14 @@ struct logio_entry_24xx {
 	uint8_t sys_define;		/* System defined. */
 	uint8_t entry_status;		/* Entry Status. */
 
-	uint32_t handle;		/* System handle. */
+	__le32 handle;		/* System handle. */
 
-	uint16_t comp_status;		/* Completion status. */
+	__le16 comp_status;		/* Completion status. */
 #define CS_LOGIO_ERROR		0x31	/* Login/Logout IOCB error. */
 
-	uint16_t nport_handle;		/* N_PORT handle. */
+	__le16 nport_handle;		/* N_PORT handle. */
 
-	uint16_t control_flags;		/* Control flags. */
+	__le16 control_flags;		/* Control flags. */
 					/* Modifiers. */
 #define LCF_INCLUDE_SNS		BIT_10	/* Include SNS (FFFFFC) during LOGO. */
 #define LCF_FCP2_OVERRIDE	BIT_9	/* Set/Reset word 3 of PRLI. */
@@ -809,7 +809,7 @@ struct logio_entry_24xx {
 
 	uint8_t rsp_size;		/* Response size in 32bit words. */
 
-	uint32_t io_parameter[11];	/* General I/O parameters. */
+	__le32 io_parameter[11];	/* General I/O parameters. */
 #define LSC_SCODE_NOLINK	0x01
 #define LSC_SCODE_NOIOCB	0x02
 #define LSC_SCODE_NOXCB		0x03
@@ -835,19 +835,19 @@ struct tsk_mgmt_entry {
 	uint8_t handle_count;		/* Handle count. */
 	uint8_t entry_status;		/* Entry Status. */
 
-	uint32_t handle;		/* System handle. */
+	__le32 handle;		/* System handle. */
 
-	uint16_t nport_handle;		/* N_PORT handle. */
+	__le16 nport_handle;		/* N_PORT handle. */
 
-	uint16_t reserved_1;
+	__le16 reserved_1;
 
-	uint16_t delay;			/* Activity delay in seconds. */
+	__le16 delay;			/* Activity delay in seconds. */
 
-	uint16_t timeout;		/* Command timeout. */
+	__le16 timeout;		/* Command timeout. */
 
 	struct scsi_lun lun;		/* FCP LUN (BE). */
 
-	uint32_t control_flags;		/* Control Flags. */
+	__le32 control_flags;		/* Control Flags. */
 #define TCF_NOTMCMD_TO_TARGET	BIT_31
 #define TCF_LUN_RESET		BIT_4
 #define TCF_ABORT_TASK_SET	BIT_3
@@ -870,17 +870,17 @@ struct abort_entry_24xx {
 	uint8_t handle_count;		/* Handle count. */
 	uint8_t entry_status;		/* Entry Status. */
 
-	uint32_t handle;		/* System handle. */
+	__le32 handle;		/* System handle. */
 
-	uint16_t nport_handle;		/* N_PORT handle. */
+	__le16 nport_handle;		/* N_PORT handle. */
 					/* or Completion status. */
 
-	uint16_t options;		/* Options. */
+	__le16 options;		/* Options. */
 #define AOF_NO_ABTS		BIT_0	/* Do not send any ABTS. */
 
-	uint32_t handle_to_abort;	/* System handle to abort. */
+	__le32 handle_to_abort;	/* System handle to abort. */
 
-	uint16_t req_que_no;
+	__le16 req_que_no;
 	uint8_t reserved_1[30];
 
 	uint8_t port_id[3];		/* PortID of destination port. */
@@ -893,7 +893,7 @@ struct abort_entry_24xx {
  * ISP I/O Register Set structure definitions.
  */
 struct device_reg_24xx {
-	uint32_t flash_addr;		/* Flash/NVRAM BIOS address. */
+	__le32 flash_addr;		/* Flash/NVRAM BIOS address. */
 #define FARX_DATA_FLAG	BIT_31
 #define FARX_ACCESS_FLASH_CONF	0x7FFD0000
 #define FARX_ACCESS_FLASH_DATA	0x7FF00000
@@ -944,9 +944,9 @@ struct device_reg_24xx {
 #define HW_EVENT_NVRAM_CHKSUM_ERR	0xF023
 #define HW_EVENT_FLASH_FW_ERR	0xF024
 
-	uint32_t flash_data;		/* Flash/NVRAM BIOS data. */
+	__le32 flash_data;		/* Flash/NVRAM BIOS data. */
 
-	uint32_t ctrl_status;		/* Control/Status. */
+	__le32 ctrl_status;		/* Control/Status. */
 #define CSRX_FLASH_ACCESS_ERROR	BIT_18	/* Flash/NVRAM Access Error. */
 #define CSRX_DMA_ACTIVE		BIT_17	/* DMA Active status. */
 #define CSRX_DMA_SHUTDOWN	BIT_16	/* DMA Shutdown control status. */
@@ -972,35 +972,35 @@ struct device_reg_24xx {
 #define CSRX_FLASH_ENABLE	BIT_1	/* Flash BIOS Read/Write enable. */
 #define CSRX_ISP_SOFT_RESET	BIT_0	/* ISP soft reset. */
 
-	uint32_t ictrl;			/* Interrupt control. */
+	__le32 ictrl;			/* Interrupt control. */
 #define ICRX_EN_RISC_INT	BIT_3	/* Enable RISC interrupts on PCI. */
 
-	uint32_t istatus;		/* Interrupt status. */
+	__le32 istatus;		/* Interrupt status. */
 #define ISRX_RISC_INT		BIT_3	/* RISC interrupt. */
 
-	uint32_t unused_1[2];		/* Gap. */
+	__le32 unused_1[2];		/* Gap. */
 
 					/* Request Queue. */
-	uint32_t req_q_in;		/*  In-Pointer. */
-	uint32_t req_q_out;		/*  Out-Pointer. */
+	__le32 req_q_in;		/*  In-Pointer. */
+	__le32 req_q_out;		/*  Out-Pointer. */
 					/* Response Queue. */
-	uint32_t rsp_q_in;		/*  In-Pointer. */
-	uint32_t rsp_q_out;		/*  Out-Pointer. */
+	__le32 rsp_q_in;		/*  In-Pointer. */
+	__le32 rsp_q_out;		/*  Out-Pointer. */
 					/* Priority Request Queue. */
-	uint32_t preq_q_in;		/*  In-Pointer. */
-	uint32_t preq_q_out;		/*  Out-Pointer. */
+	__le32 preq_q_in;		/*  In-Pointer. */
+	__le32 preq_q_out;		/*  Out-Pointer. */
 
-	uint32_t unused_2[2];		/* Gap. */
+	__le32 unused_2[2];		/* Gap. */
 
 					/* ATIO Queue. */
-	uint32_t atio_q_in;		/*  In-Pointer. */
-	uint32_t atio_q_out;		/*  Out-Pointer. */
+	__le32 atio_q_in;		/*  In-Pointer. */
+	__le32 atio_q_out;		/*  Out-Pointer. */
 
-	uint32_t host_status;
+	__le32 host_status;
 #define HSRX_RISC_INT		BIT_15	/* RISC to Host interrupt. */
 #define HSRX_RISC_PAUSED	BIT_8	/* RISC Paused. */
 
-	uint32_t hccr;			/* Host command & control register. */
+	__le32 hccr;			/* Host command & control register. */
 					/* HCCR statuses. */
 #define HCCRX_HOST_INT		BIT_6	/* Host to RISC interrupt bit. */
 #define HCCRX_RISC_RESET	BIT_5	/* RISC Reset mode bit. */
@@ -1022,7 +1022,7 @@ struct device_reg_24xx {
 					/* Clear RISC to PCI interrupt. */
 #define HCCRX_CLR_RISC_INT	0xA0000000
 
-	uint32_t gpiod;			/* GPIO Data register. */
+	__le32 gpiod;			/* GPIO Data register. */
 
 					/* LED update mask. */
 #define GPDX_LED_UPDATE_MASK	(BIT_20|BIT_19|BIT_18)
@@ -1041,7 +1041,7 @@ struct device_reg_24xx {
 					/* Data in/out. */
 #define GPDX_DATA_INOUT		(BIT_1|BIT_0)
 
-	uint32_t gpioe;			/* GPIO Enable register. */
+	__le32 gpioe;			/* GPIO Enable register. */
 					/* Enable update mask. */
 #define GPEX_ENABLE_UPDATE_MASK	(BIT_17|BIT_16)
 					/* Enable update mask. */
@@ -1049,52 +1049,52 @@ struct device_reg_24xx {
 					/* Enable. */
 #define GPEX_ENABLE		(BIT_1|BIT_0)
 
-	uint32_t iobase_addr;		/* I/O Bus Base Address register. */
-
-	uint32_t unused_3[10];		/* Gap. */
-
-	uint16_t mailbox0;
-	uint16_t mailbox1;
-	uint16_t mailbox2;
-	uint16_t mailbox3;
-	uint16_t mailbox4;
-	uint16_t mailbox5;
-	uint16_t mailbox6;
-	uint16_t mailbox7;
-	uint16_t mailbox8;
-	uint16_t mailbox9;
-	uint16_t mailbox10;
-	uint16_t mailbox11;
-	uint16_t mailbox12;
-	uint16_t mailbox13;
-	uint16_t mailbox14;
-	uint16_t mailbox15;
-	uint16_t mailbox16;
-	uint16_t mailbox17;
-	uint16_t mailbox18;
-	uint16_t mailbox19;
-	uint16_t mailbox20;
-	uint16_t mailbox21;
-	uint16_t mailbox22;
-	uint16_t mailbox23;
-	uint16_t mailbox24;
-	uint16_t mailbox25;
-	uint16_t mailbox26;
-	uint16_t mailbox27;
-	uint16_t mailbox28;
-	uint16_t mailbox29;
-	uint16_t mailbox30;
-	uint16_t mailbox31;
-
-	uint32_t iobase_window;
-	uint32_t iobase_c4;
-	uint32_t iobase_c8;
-	uint32_t unused_4_1[6];		/* Gap. */
-	uint32_t iobase_q;
-	uint32_t unused_5[2];		/* Gap. */
-	uint32_t iobase_select;
-	uint32_t unused_6[2];		/* Gap. */
-	uint32_t iobase_sdata;
+	__le32 iobase_addr;		/* I/O Bus Base Address register. */
+
+	__le32 unused_3[10];		/* Gap. */
+
+	__le16 mailbox0;
+	__le16 mailbox1;
+	__le16 mailbox2;
+	__le16 mailbox3;
+	__le16 mailbox4;
+	__le16 mailbox5;
+	__le16 mailbox6;
+	__le16 mailbox7;
+	__le16 mailbox8;
+	__le16 mailbox9;
+	__le16 mailbox10;
+	__le16 mailbox11;
+	__le16 mailbox12;
+	__le16 mailbox13;
+	__le16 mailbox14;
+	__le16 mailbox15;
+	__le16 mailbox16;
+	__le16 mailbox17;
+	__le16 mailbox18;
+	__le16 mailbox19;
+	__le16 mailbox20;
+	__le16 mailbox21;
+	__le16 mailbox22;
+	__le16 mailbox23;
+	__le16 mailbox24;
+	__le16 mailbox25;
+	__le16 mailbox26;
+	__le16 mailbox27;
+	__le16 mailbox28;
+	__le16 mailbox29;
+	__le16 mailbox30;
+	__le16 mailbox31;
+
+	__le32 iobase_window;
+	__le32 iobase_c4;
+	__le32 iobase_c8;
+	__le32 unused_4_1[6];		/* Gap. */
+	__le32 iobase_q;
+	__le32 unused_5[2];		/* Gap. */
+	__le32 iobase_select;
+	__le32 unused_6[2];		/* Gap. */
+	__le32 iobase_sdata;
 };
 /* RISC-RISC semaphore register PCI offet */
 #define RISC_REGISTER_BASE_OFFSET	0x7010
@@ -1138,7 +1138,7 @@ struct device_reg_24xx {
 #define MAX_MULTI_ID_FABRIC	256	/* ... */
 
 struct mid_conf_entry_24xx {
-	uint16_t reserved_1;
+	__le16 reserved_1;
 
 	/*
 	 * BIT 0  = Enable Hard Loop Id
@@ -1160,15 +1160,15 @@ struct mid_conf_entry_24xx {
 struct mid_init_cb_24xx {
 	struct init_cb_24xx init_cb;
 
-	uint16_t count;
-	uint16_t options;
+	__le16 count;
+	__le16 options;
 
 	struct mid_conf_entry_24xx entries[MAX_MULTI_ID_FABRIC];
 };
 
 
 struct mid_db_entry_24xx {
-	uint16_t status;
+	__le16 status;
 #define MDBS_NON_PARTIC		BIT_3
 #define MDBS_ID_ACQUIRED	BIT_1
 #define MDBS_ENABLED		BIT_0
@@ -1193,29 +1193,29 @@ struct vp_ctrl_entry_24xx {
 	uint8_t sys_define;		/* System defined. */
 	uint8_t entry_status;		/* Entry Status. */
 
-	uint32_t handle;		/* System handle. */
+	__le32 handle;		/* System handle. */
 
-	uint16_t vp_idx_failed;
+	__le16 vp_idx_failed;
 
-	uint16_t comp_status;		/* Completion status. */
+	__le16 comp_status;		/* Completion status. */
 #define CS_VCE_IOCB_ERROR       0x01    /* Error processing IOCB */
 #define CS_VCE_ACQ_ID_ERROR	0x02	/* Error while acquireing ID. */
 #define CS_VCE_BUSY		0x05	/* Firmware not ready to accept cmd. */
 
-	uint16_t command;
+	__le16 command;
 #define VCE_COMMAND_ENABLE_VPS	0x00	/* Enable VPs. */
 #define VCE_COMMAND_DISABLE_VPS	0x08	/* Disable VPs. */
 #define VCE_COMMAND_DISABLE_VPS_REINIT	0x09 /* Disable VPs and reinit link. */
 #define VCE_COMMAND_DISABLE_VPS_LOGO	0x0a /* Disable VPs and LOGO ports. */
 #define VCE_COMMAND_DISABLE_VPS_LOGO_ALL        0x0b /* Disable VPs and LOGO ports. */
 
-	uint16_t vp_count;
+	__le16 vp_count;
 
 	uint8_t vp_idx_map[16];
-	uint16_t flags;
-	uint16_t id;
-	uint16_t reserved_4;
-	uint16_t hopct;
+	__le16 flags;
+	__le16 id;
+	__le16 reserved_4;
+	__le16 hopct;
 	uint8_t reserved_5[24];
 };
 
@@ -1229,14 +1229,14 @@ struct vp_config_entry_24xx {
 	uint8_t handle_count;
 	uint8_t entry_status;		/* Entry Status. */
 
-	uint32_t handle;		/* System handle. */
+	__le32 handle;		/* System handle. */
 
-	uint16_t flags;
+	__le16 flags;
 #define CS_VF_BIND_VPORTS_TO_VF         BIT_0
 #define CS_VF_SET_QOS_OF_VPORTS         BIT_1
 #define CS_VF_SET_HOPS_OF_VPORTS        BIT_2
 
-	uint16_t comp_status;		/* Completion status. */
+	__le16 comp_status;		/* Completion status. */
 #define CS_VCT_STS_ERROR	0x01	/* Specified VPs were not disabled. */
 #define CS_VCT_CNT_ERROR	0x02	/* Invalid VP count. */
 #define CS_VCT_ERROR		0x03	/* Unknown error. */
@@ -1254,18 +1254,18 @@ struct vp_config_entry_24xx {
 
 	uint8_t options_idx1;
 	uint8_t hard_address_idx1;
-	uint16_t reserved_vp1;
+	__le16 reserved_vp1;
 	uint8_t port_name_idx1[WWN_SIZE];
 	uint8_t node_name_idx1[WWN_SIZE];
 
 	uint8_t options_idx2;
 	uint8_t hard_address_idx2;
-	uint16_t reserved_vp2;
+	__le16 reserved_vp2;
 	uint8_t port_name_idx2[WWN_SIZE];
 	uint8_t node_name_idx2[WWN_SIZE];
-	uint16_t id;
-	uint16_t reserved_4;
-	uint16_t hopct;
+	__le16 id;
+	__le16 reserved_4;
+	__le16 hopct;
 	uint8_t reserved_5[2];
 };
 
@@ -1276,11 +1276,11 @@ struct vp_rpt_id_entry_24xx {
 	uint8_t sys_define;		/* System defined. */
 	uint8_t entry_status;		/* Entry Status. */
 
-	uint32_t handle;		/* System handle. */
+	__le32 handle;		/* System handle. */
 
-	uint16_t vp_count;		/* Format 0 -- | VP setup | VP acq |. */
+	__le16 vp_count;		/* Format 0 -- | VP setup | VP acq |. */
 					/* Format 1 -- | VP count |. */
-	uint16_t vp_idx;		/* Format 0 -- Reserved. */
+	__le16 vp_idx;		/* Format 0 -- Reserved. */
 					/* Format 1 -- VP status and index. */
 
 	uint8_t port_id[3];
@@ -1289,7 +1289,7 @@ struct vp_rpt_id_entry_24xx {
 	uint8_t vp_idx_map[16];
 
 	uint8_t reserved_4[24];
-	uint16_t bbcr;
+	__le16 bbcr;
 	uint8_t reserved_5[6];
 };
 
@@ -1300,22 +1300,22 @@ struct vf_evfp_entry_24xx {
         uint8_t sys_define;             /* System defined. */
         uint8_t entry_status;           /* Entry Status. */
 
-        uint32_t handle;                /* System handle. */
-        uint16_t comp_status;           /* Completion status. */
-        uint16_t timeout;               /* timeout */
-        uint16_t adim_tagging_mode;
-
-        uint16_t vfport_id;
-        uint32_t exch_addr;
-
-        uint16_t nport_handle;          /* N_PORT handle. */
-        uint16_t control_flags;
-        uint32_t io_parameter_0;
-        uint32_t io_parameter_1;
-        uint32_t tx_address[2];         /* Data segment 0 address. */
-        uint32_t tx_len;                /* Data segment 0 length. */
-        uint32_t rx_address[2];         /* Data segment 1 address. */
-        uint32_t rx_len;                /* Data segment 1 length. */
+        __le32 handle;                /* System handle. */
+        __le16 comp_status;           /* Completion status. */
+        __le16 timeout;               /* timeout */
+        __le16 adim_tagging_mode;
+
+        __le16 vfport_id;
+        __le32 exch_addr;
+
+        __le16 nport_handle;          /* N_PORT handle. */
+        __le16 control_flags;
+        __le32 io_parameter_0;
+        __le32 io_parameter_1;
+        __le32 tx_address[2];         /* Data segment 0 address. */
+        __le32 tx_len;                /* Data segment 0 length. */
+        __le32 rx_address[2];         /* Data segment 1 address. */
+        __le32 rx_len;                /* Data segment 1 length. */
 };
 
 /* END MID Support ***********************************************************/
@@ -1324,13 +1324,13 @@ struct vf_evfp_entry_24xx {
 
 struct qla_fdt_layout {
 	uint8_t sig[4];
-	uint16_t version;
-	uint16_t len;
-	uint16_t checksum;
+	__le16 version;
+	__le16 len;
+	__le16 checksum;
 	uint8_t unused1[2];
 	uint8_t model[16];
-	uint16_t man_id;
-	uint16_t id;
+	__le16 man_id;
+	__le16 id;
 	uint8_t flags;
 	uint8_t erase_cmd;
 	uint8_t alt_erase_cmd;
@@ -1339,15 +1339,15 @@ struct qla_fdt_layout {
 	uint8_t wrt_sts_reg_cmd;
 	uint8_t unprotect_sec_cmd;
 	uint8_t read_man_id_cmd;
-	uint32_t block_size;
-	uint32_t alt_block_size;
-	uint32_t flash_size;
-	uint32_t wrt_enable_data;
+	__le32 block_size;
+	__le32 alt_block_size;
+	__le32 flash_size;
+	__le32 wrt_enable_data;
 	uint8_t read_id_addr_len;
 	uint8_t wrt_disable_bits;
 	uint8_t read_dev_id_len;
 	uint8_t chip_erase_cmd;
-	uint16_t read_timeout;
+	__le16 read_timeout;
 	uint8_t protect_sec_cmd;
 	uint8_t unused2[65];
 };
@@ -1356,18 +1356,18 @@ struct qla_fdt_layout {
 
 struct qla_flt_location {
 	uint8_t sig[4];
-	uint16_t start_lo;
-	uint16_t start_hi;
+	__le16 start_lo;
+	__le16 start_hi;
 	uint8_t version;
 	uint8_t unused[5];
-	uint16_t checksum;
+	__le16 checksum;
 };
 
 struct qla_flt_header {
-	uint16_t version;
-	uint16_t length;
-	uint16_t checksum;
-	uint16_t unused;
+	__le16 version;
+	__le16 length;
+	__le16 checksum;
+	__le16 unused;
 };
 
 #define FLT_REG_FW		0x01
@@ -1406,28 +1406,28 @@ struct qla_flt_header {
 #define FLT_REG_VPD_SEC_27XX_3	0xDA
 
 struct qla_flt_region {
-	uint32_t code;
-	uint32_t size;
-	uint32_t start;
-	uint32_t end;
+	__le32 code;
+	__le32 size;
+	__le32 start;
+	__le32 end;
 };
 
 /* Flash NPIV Configuration Table ********************************************/
 
 struct qla_npiv_header {
 	uint8_t sig[2];
-	uint16_t version;
-	uint16_t entries;
-	uint16_t unused[4];
-	uint16_t checksum;
+	__le16 version;
+	__le16 entries;
+	__le16 unused[4];
+	__le16 checksum;
 };
 
 struct qla_npiv_entry {
-	uint16_t flags;
-	uint16_t vf_id;
+	__le16 flags;
+	__le16 vf_id;
 	uint8_t q_qos;
 	uint8_t f_qos;
-	uint16_t unused1;
+	__le16 unused1;
 	uint8_t port_name[WWN_SIZE];
 	uint8_t node_name[WWN_SIZE];
 };
@@ -1455,9 +1455,9 @@ struct verify_chip_entry_84xx {
 	uint8_t sys_defined;
 	uint8_t entry_status;
 
-	uint32_t handle;
+	__le32 handle;
 
-	uint16_t options;
+	__le16 options;
 #define VCO_DONT_UPDATE_FW	BIT_0
 #define VCO_FORCE_UPDATE	BIT_1
 #define VCO_DONT_RESET_UPDATE	BIT_2
@@ -1465,21 +1465,21 @@ struct verify_chip_entry_84xx {
 #define VCO_END_OF_DATA		BIT_14
 #define VCO_ENABLE_DSD		BIT_15
 
-	uint16_t reserved_1;
+	__le16 reserved_1;
 
-	uint16_t data_seg_cnt;
-	uint16_t reserved_2[3];
+	__le16 data_seg_cnt;
+	__le16 reserved_2[3];
 
-	uint32_t fw_ver;
-	uint32_t exchange_address;
+	__le32 fw_ver;
+	__le32 exchange_address;
 
-	uint32_t reserved_3[3];
-	uint32_t fw_size;
-	uint32_t fw_seq_size;
-	uint32_t relative_offset;
+	__le32 reserved_3[3];
+	__le32 fw_size;
+	__le32 fw_seq_size;
+	__le32 relative_offset;
 
-	uint32_t dseg_address[2];
-	uint32_t dseg_length;
+	__le32 dseg_address[2];
+	__le32 dseg_length;
 };
 
 struct verify_chip_rsp_84xx {
@@ -1488,24 +1488,24 @@ struct verify_chip_rsp_84xx {
 	uint8_t sys_defined;
 	uint8_t entry_status;
 
-	uint32_t handle;
+	__le32 handle;
 
-	uint16_t comp_status;
+	__le16 comp_status;
 #define CS_VCS_CHIP_FAILURE	0x3
 #define CS_VCS_BAD_EXCHANGE	0x8
 #define CS_VCS_SEQ_COMPLETEi	0x40
 
-	uint16_t failure_code;
+	__le16 failure_code;
 #define VFC_CHECKSUM_ERROR	0x1
 #define VFC_INVALID_LEN		0x2
 #define VFC_ALREADY_IN_PROGRESS	0x8
 
-	uint16_t reserved_1[4];
+	__le16 reserved_1[4];
 
-	uint32_t fw_ver;
-	uint32_t exchange_address;
+	__le32 fw_ver;
+	__le32 exchange_address;
 
-	uint32_t reserved_2[6];
+	__le32 reserved_2[6];
 };
 
 #define ACCESS_CHIP_IOCB_TYPE	0x2B
@@ -1515,29 +1515,29 @@ struct access_chip_84xx {
 	uint8_t sys_defined;
 	uint8_t entry_status;
 
-	uint32_t handle;
+	__le32 handle;
 
-	uint16_t options;
+	__le16 options;
 #define ACO_DUMP_MEMORY		0x0
 #define ACO_LOAD_MEMORY		0x1
 #define ACO_CHANGE_CONFIG_PARAM	0x2
 #define ACO_REQUEST_INFO	0x3
 
-	uint16_t reserved1;
+	__le16 reserved1;
 
-	uint16_t dseg_count;
-	uint16_t reserved2[3];
+	__le16 dseg_count;
+	__le16 reserved2[3];
 
-	uint32_t parameter1;
-	uint32_t parameter2;
-	uint32_t parameter3;
+	__le32 parameter1;
+	__le32 parameter2;
+	__le32 parameter3;
 
-	uint32_t reserved3[3];
-	uint32_t total_byte_cnt;
-	uint32_t reserved4;
+	__le32 reserved3[3];
+	__le32 total_byte_cnt;
+	__le32 reserved4;
 
-	uint32_t dseg_address[2];
-	uint32_t dseg_length;
+	__le32 dseg_address[2];
+	__le32 dseg_length;
 };
 
 struct access_chip_rsp_84xx {
@@ -1546,13 +1546,13 @@ struct access_chip_rsp_84xx {
 	uint8_t sys_defined;
 	uint8_t entry_status;
 
-	uint32_t handle;
+	__le32 handle;
 
-	uint16_t comp_status;
-	uint16_t failure_code;
-	uint32_t residual_count;
+	__le16 comp_status;
+	__le16 failure_code;
+	__le32 residual_count;
 
-	uint32_t reserved[12];
+	__le32 reserved[12];
 };
 
 /* 81XX Support **************************************************************/
@@ -1595,50 +1595,50 @@ struct access_chip_rsp_84xx {
 struct nvram_81xx {
 	/* NVRAM header. */
 	uint8_t id[4];
-	uint16_t nvram_version;
-	uint16_t reserved_0;
+	__le16 nvram_version;
+	__le16 reserved_0;
 
 	/* Firmware Initialization Control Block. */
-	uint16_t version;
-	uint16_t reserved_1;
-	uint16_t frame_payload_size;
-	uint16_t execution_throttle;
-	uint16_t exchange_count;
-	uint16_t reserved_2;
+	__le16 version;
+	__le16 reserved_1;
+	__le16 frame_payload_size;
+	__le16 execution_throttle;
+	__le16 exchange_count;
+	__le16 reserved_2;
 
 	uint8_t port_name[WWN_SIZE];
 	uint8_t node_name[WWN_SIZE];
 
-	uint16_t login_retry_count;
-	uint16_t reserved_3;
-	uint16_t interrupt_delay_timer;
-	uint16_t login_timeout;
+	__le16 login_retry_count;
+	__le16 reserved_3;
+	__le16 interrupt_delay_timer;
+	__le16 login_timeout;
 
-	uint32_t firmware_options_1;
-	uint32_t firmware_options_2;
-	uint32_t firmware_options_3;
+	__le32 firmware_options_1;
+	__le32 firmware_options_2;
+	__le32 firmware_options_3;
 
-	uint16_t reserved_4[4];
+	__le16 reserved_4[4];
 
 	/* Offset 64. */
 	uint8_t enode_mac[6];
-	uint16_t reserved_5[5];
+	__le16 reserved_5[5];
 
 	/* Offset 80. */
-	uint16_t reserved_6[24];
+	__le16 reserved_6[24];
 
 	/* Offset 128. */
-	uint16_t ex_version;
+	__le16 ex_version;
 	uint8_t prio_fcf_matching_flags;
 	uint8_t reserved_6_1[3];
-	uint16_t pri_fcf_vlan_id;
+	__le16 pri_fcf_vlan_id;
 	uint8_t pri_fcf_fabric_name[8];
-	uint16_t reserved_6_2[7];
+	__le16 reserved_6_2[7];
 	uint8_t spma_mac_addr[6];
-	uint16_t reserved_6_3[14];
+	__le16 reserved_6_3[14];
 
 	/* Offset 192. */
-	uint16_t reserved_7[32];
+	__le16 reserved_7[32];
 
 	/*
 	 * BIT 0  = Enable spinup delay
@@ -1671,26 +1671,26 @@ struct nvram_81xx {
 	 * BIT 25 = Temp WWPN
 	 * BIT 26-31 =
 	 */
-	uint32_t host_p;
+	__le32 host_p;
 
 	uint8_t alternate_port_name[WWN_SIZE];
 	uint8_t alternate_node_name[WWN_SIZE];
 
 	uint8_t boot_port_name[WWN_SIZE];
-	uint16_t boot_lun_number;
-	uint16_t reserved_8;
+	__le16 boot_lun_number;
+	__le16 reserved_8;
 
 	uint8_t alt1_boot_port_name[WWN_SIZE];
-	uint16_t alt1_boot_lun_number;
-	uint16_t reserved_9;
+	__le16 alt1_boot_lun_number;
+	__le16 reserved_9;
 
 	uint8_t alt2_boot_port_name[WWN_SIZE];
-	uint16_t alt2_boot_lun_number;
-	uint16_t reserved_10;
+	__le16 alt2_boot_lun_number;
+	__le16 reserved_10;
 
 	uint8_t alt3_boot_port_name[WWN_SIZE];
-	uint16_t alt3_boot_lun_number;
-	uint16_t reserved_11;
+	__le16 alt3_boot_lun_number;
+	__le16 reserved_11;
 
 	/*
 	 * BIT 0 = Selective Login
@@ -1702,35 +1702,35 @@ struct nvram_81xx {
 	 * BIT 6 = Reserved
 	 * BIT 7-31 =
 	 */
-	uint32_t efi_parameters;
+	__le32 efi_parameters;
 
 	uint8_t reset_delay;
 	uint8_t reserved_12;
-	uint16_t reserved_13;
+	__le16 reserved_13;
 
-	uint16_t boot_id_number;
-	uint16_t reserved_14;
+	__le16 boot_id_number;
+	__le16 reserved_14;
 
-	uint16_t max_luns_per_target;
-	uint16_t reserved_15;
+	__le16 max_luns_per_target;
+	__le16 reserved_15;
 
-	uint16_t port_down_retry_count;
-	uint16_t link_down_timeout;
+	__le16 port_down_retry_count;
+	__le16 link_down_timeout;
 
 	/* FCode parameters. */
-	uint16_t fcode_parameter;
+	__le16 fcode_parameter;
 
-	uint16_t reserved_16[3];
+	__le16 reserved_16[3];
 
 	/* Offset 352. */
 	uint8_t reserved_17[4];
-	uint16_t reserved_18[5];
+	__le16 reserved_18[5];
 	uint8_t reserved_19[2];
-	uint16_t reserved_20[8];
+	__le16 reserved_20[8];
 
 	/* Offset 384. */
 	uint8_t reserved_21[16];
-	uint16_t reserved_22[3];
+	__le16 reserved_22[3];
 
 	/*
 	 * BIT 0 = Extended BB credits for LR
@@ -1742,23 +1742,23 @@ struct nvram_81xx {
 	uint8_t enhanced_features;
 
 	uint8_t reserved_23;
-	uint16_t reserved_24[4];
+	__le16 reserved_24[4];
 
 	/* Offset 416. */
-	uint16_t reserved_25[32];
+	__le16 reserved_25[32];
 
 	/* Offset 480. */
 	uint8_t model_name[16];
 
 	/* Offset 496. */
-	uint16_t feature_mask_l;
-	uint16_t feature_mask_h;
-	uint16_t reserved_26[2];
+	__le16 feature_mask_l;
+	__le16 feature_mask_h;
+	__le16 reserved_26[2];
 
-	uint16_t subsystem_vendor_id;
-	uint16_t subsystem_device_id;
+	__le16 subsystem_vendor_id;
+	__le16 subsystem_device_id;
 
-	uint32_t checksum;
+	__le32 checksum;
 };
 
 /*
@@ -1767,44 +1767,44 @@ struct nvram_81xx {
  */
 #define	ICB_VERSION 1
 struct init_cb_81xx {
-	uint16_t version;
-	uint16_t reserved_1;
+	__le16 version;
+	__le16 reserved_1;
 
-	uint16_t frame_payload_size;
-	uint16_t execution_throttle;
-	uint16_t exchange_count;
+	__le16 frame_payload_size;
+	__le16 execution_throttle;
+	__le16 exchange_count;
 
-	uint16_t reserved_2;
+	__le16 reserved_2;
 
 	uint8_t port_name[WWN_SIZE];		/* Big endian. */
 	uint8_t node_name[WWN_SIZE];		/* Big endian. */
 
-	uint16_t response_q_inpointer;
-	uint16_t request_q_outpointer;
+	__le16 response_q_inpointer;
+	__le16 request_q_outpointer;
 
-	uint16_t login_retry_count;
+	__le16 login_retry_count;
 
-	uint16_t prio_request_q_outpointer;
+	__le16 prio_request_q_outpointer;
 
-	uint16_t response_q_length;
-	uint16_t request_q_length;
+	__le16 response_q_length;
+	__le16 request_q_length;
 
-	uint16_t reserved_3;
+	__le16 reserved_3;
 
-	uint16_t prio_request_q_length;
+	__le16 prio_request_q_length;
 
-	uint32_t request_q_address[2];
-	uint32_t response_q_address[2];
-	uint32_t prio_request_q_address[2];
+	__le32 request_q_address[2];
+	__le32 response_q_address[2];
+	__le32 prio_request_q_address[2];
 
 	uint8_t reserved_4[8];
 
-	uint16_t atio_q_inpointer;
-	uint16_t atio_q_length;
-	uint32_t atio_q_address[2];
+	__le16 atio_q_inpointer;
+	__le16 atio_q_length;
+	__le32 atio_q_address[2];
 
-	uint16_t interrupt_delay_timer;		/* 100us increments. */
-	uint16_t login_timeout;
+	__le16 interrupt_delay_timer;		/* 100us increments. */
+	__le16 login_timeout;
 
 	/*
 	 * BIT 0-3 = Reserved
@@ -1817,7 +1817,7 @@ struct init_cb_81xx {
 	 * BIT 14 = Node Name Option
 	 * BIT 15-31 = Reserved
 	 */
-	uint32_t firmware_options_1;
+	__le32 firmware_options_1;
 
 	/*
 	 * BIT 0  = Operation Mode bit 0
@@ -1835,7 +1835,7 @@ struct init_cb_81xx {
 	 * BIT 14 = Enable Target PRLI Control
 	 * BIT 15-31 = Reserved
 	 */
-	uint32_t firmware_options_2;
+	__le32 firmware_options_2;
 
 	/*
 	 * BIT 0-3 = Reserved
@@ -1856,7 +1856,7 @@ struct init_cb_81xx {
 	 * BIT 28 = SPMA selection bit 1
 	 * BIT 30-31 = Reserved
 	 */
-	uint32_t firmware_options_3;
+	__le32 firmware_options_3;
 
 	uint8_t  reserved_5[8];
 
@@ -1868,21 +1868,21 @@ struct init_cb_81xx {
 struct mid_init_cb_81xx {
 	struct init_cb_81xx init_cb;
 
-	uint16_t count;
-	uint16_t options;
+	__le16 count;
+	__le16 options;
 
 	struct mid_conf_entry_24xx entries[MAX_MULTI_ID_FABRIC];
 };
 
 struct ex_init_cb_81xx {
-	uint16_t ex_version;
+	__le16 ex_version;
 	uint8_t prio_fcf_matching_flags;
 	uint8_t reserved_1[3];
-	uint16_t pri_fcf_vlan_id;
+	__le16 pri_fcf_vlan_id;
 	uint8_t pri_fcf_fabric_name[8];
-	uint16_t reserved_2[7];
+	__le16 reserved_2[7];
 	uint8_t spma_mac_addr[6];
-	uint16_t reserved_3[14];
+	__le16 reserved_3[14];
 };
 
 #define FARX_ACCESS_FLASH_CONF_81XX	0x7FFD0000
@@ -1896,7 +1896,7 @@ struct ex_init_cb_81xx {
 #define QLFC_FCP_PRIO_SET_CONFIG        0x3
 
 struct qla_fcp_prio_entry {
-	uint16_t flags;         /* Describes parameter(s) in FCP        */
+	__le16 flags;         /* Describes parameter(s) in FCP        */
 	/* priority entry that are valid        */
 #define FCP_PRIO_ENTRY_VALID            0x1
 #define FCP_PRIO_ENTRY_TAG_VALID        0x2
@@ -1908,13 +1908,13 @@ struct qla_fcp_prio_entry {
 #define FCP_PRIO_ENTRY_DWWN_VALID       0x80
 	uint8_t  tag;           /* Priority value                   */
 	uint8_t  reserved;      /* Reserved for future use          */
-	uint32_t src_pid;       /* Src port id. high order byte     */
+	__le32 src_pid;       /* Src port id. high order byte     */
 				/* unused; -1 (wild card)           */
-	uint32_t dst_pid;       /* Src port id. high order byte     */
+	__le32 dst_pid;       /* Src port id. high order byte     */
 	/* unused; -1 (wild card)           */
-	uint16_t lun_beg;       /* 1st lun num of lun range.        */
+	__le16 lun_beg;       /* 1st lun num of lun range.        */
 				/* -1 (wild card)                   */
-	uint16_t lun_end;       /* 2nd lun num of lun range.        */
+	__le16 lun_end;       /* 2nd lun num of lun range.        */
 				/* -1 (wild card)                   */
 	uint8_t  src_wwpn[8];   /* Source WWPN: -1 (wild card)      */
 	uint8_t  dst_wwpn[8];   /* Destination WWPN: -1 (wild card) */
@@ -1922,11 +1922,11 @@ struct qla_fcp_prio_entry {
 
 struct qla_fcp_prio_cfg {
 	uint8_t  signature[4];  /* "HQOS" signature of config data  */
-	uint16_t version;       /* 1: Initial version               */
-	uint16_t length;        /* config data size in num bytes    */
-	uint16_t checksum;      /* config data bytes checksum       */
-	uint16_t num_entries;   /* Number of entries                */
-	uint16_t size_of_entry; /* Size of each entry in num bytes  */
+	__le16 version;       /* 1: Initial version               */
+	__le16 length;        /* config data size in num bytes    */
+	__le16 checksum;      /* config data bytes checksum       */
+	__le16 num_entries;   /* Number of entries                */
+	__le16 size_of_entry; /* Size of each entry in num bytes  */
 	uint8_t  attributes;    /* enable/disable, persistence      */
 #define FCP_PRIO_ATTR_DISABLE   0x0
 #define FCP_PRIO_ATTR_ENABLE    0x1
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index f26c5f6..8e45699 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -134,65 +134,65 @@ struct imm_ntfy_from_isp {
 	uint8_t	 entry_status;		    /* Entry Status. */
 	union {
 		struct {
-			uint32_t sys_define_2; /* System defined. */
+			__le32 sys_define_2; /* System defined. */
 			target_id_t target;
-			uint16_t lun;
+			__le16 lun;
 			uint8_t  target_id;
 			uint8_t  reserved_1;
-			uint16_t status_modifier;
-			uint16_t status;
-			uint16_t task_flags;
-			uint16_t seq_id;
-			uint16_t srr_rx_id;
-			uint32_t srr_rel_offs;
-			uint16_t srr_ui;
+			__le16 status_modifier;
+			__le16 status;
+			__le16 task_flags;
+			__le16 seq_id;
+			__le16 srr_rx_id;
+			__le32 srr_rel_offs;
+			__le16 srr_ui;
 #define SRR_IU_DATA_IN	0x1
 #define SRR_IU_DATA_OUT	0x5
 #define SRR_IU_STATUS	0x7
-			uint16_t srr_ox_id;
+			__le16 srr_ox_id;
 			uint8_t reserved_2[28];
 		} isp2x;
 		struct {
-			uint32_t reserved;
-			uint16_t nport_handle;
-			uint16_t reserved_2;
-			uint16_t flags;
+			__le32 reserved;
+			__le16 nport_handle;
+			__le16 reserved_2;
+			__le16 flags;
 #define NOTIFY24XX_FLAGS_GLOBAL_TPRLO   BIT_1
 #define NOTIFY24XX_FLAGS_PUREX_IOCB     BIT_0
-			uint16_t srr_rx_id;
-			uint16_t status;
+			__le16 srr_rx_id;
+			__le16 status;
 			uint8_t  status_subcode;
 			uint8_t  fw_handle;
-			uint32_t exchange_address;
-			uint32_t srr_rel_offs;
-			uint16_t srr_ui;
-			uint16_t srr_ox_id;
+			__le32 exchange_address;
+			__le32 srr_rel_offs;
+			__le16 srr_ui;
+			__le16 srr_ox_id;
 			union {
 				struct {
 					uint8_t node_name[8];
 				} plogi; /* PLOGI/ADISC/PDISC */
 				struct {
 					/* PRLI word 3 bit 0-15 */
-					uint16_t wd3_lo;
+					__le16 wd3_lo;
 					uint8_t resv0[6];
 				} prli;
 				struct {
 					uint8_t port_id[3];
 					uint8_t resv1;
-					uint16_t nport_handle;
-					uint16_t resv2;
+					__le16 nport_handle;
+					__le16 resv2;
 				} req_els;
 			} u;
 			uint8_t port_name[8];
 			uint8_t resv3[3];
 			uint8_t  vp_index;
-			uint32_t reserved_5;
+			__le32 reserved_5;
 			uint8_t  port_id[3];
 			uint8_t  reserved_6;
 		} isp24;
 	} u;
-	uint16_t reserved_7;
-	uint16_t ox_id;
+	__le16 reserved_7;
+	__le16 ox_id;
 } __packed;
 #endif
 
@@ -209,37 +209,37 @@ struct nack_to_isp {
 	uint8_t	 entry_status;		    /* Entry Status. */
 	union {
 		struct {
-			uint32_t sys_define_2; /* System defined. */
+			__le32 sys_define_2; /* System defined. */
 			target_id_t target;
 			uint8_t	 target_id;
 			uint8_t	 reserved_1;
-			uint16_t flags;
-			uint16_t resp_code;
-			uint16_t status;
-			uint16_t task_flags;
-			uint16_t seq_id;
-			uint16_t srr_rx_id;
-			uint32_t srr_rel_offs;
-			uint16_t srr_ui;
-			uint16_t srr_flags;
-			uint16_t srr_reject_code;
+			__le16 flags;
+			__le16 resp_code;
+			__le16 status;
+			__le16 task_flags;
+			__le16 seq_id;
+			__le16 srr_rx_id;
+			__le32 srr_rel_offs;
+			__le16 srr_ui;
+			__le16 srr_flags;
+			__le16 srr_reject_code;
 			uint8_t  srr_reject_vendor_uniq;
 			uint8_t  srr_reject_code_expl;
 			uint8_t  reserved_2[24];
 		} isp2x;
 		struct {
-			uint32_t handle;
-			uint16_t nport_handle;
-			uint16_t reserved_1;
-			uint16_t flags;
-			uint16_t srr_rx_id;
-			uint16_t status;
+			__le32 handle;
+			__le16 nport_handle;
+			__le16 reserved_1;
+			__le16 flags;
+			__le16 srr_rx_id;
+			__le16 status;
 			uint8_t  status_subcode;
 			uint8_t  fw_handle;
-			uint32_t exchange_address;
-			uint32_t srr_rel_offs;
-			uint16_t srr_ui;
-			uint16_t srr_flags;
+			__le32 exchange_address;
+			__le32 srr_rel_offs;
+			__le16 srr_ui;
+			__le16 srr_flags;
 			uint8_t  reserved_4[19];
 			uint8_t  vp_index;
 			uint8_t  srr_reject_vendor_uniq;
@@ -249,7 +249,7 @@ struct nack_to_isp {
 		} isp24;
 	} u;
 	uint8_t  reserved[2];
-	uint16_t ox_id;
+	__le16 ox_id;
 } __packed;
 #define NOTIFY_ACK_FLAGS_TERMINATE	BIT_3
 #define NOTIFY_ACK_SRR_FLAGS_ACCEPT	0
@@ -278,24 +278,24 @@ struct ctio_to_2xxx {
 	uint8_t	 entry_count;		/* Entry count. */
 	uint8_t	 sys_define;		/* System defined. */
 	uint8_t	 entry_status;		/* Entry Status. */
-	uint32_t handle;		/* System defined handle */
+	__le32 handle;		/* System defined handle */
 	target_id_t target;
-	uint16_t rx_id;
-	uint16_t flags;
-	uint16_t status;
-	uint16_t timeout;		/* 0 = 30 seconds, 0xFFFF = disable */
-	uint16_t dseg_count;		/* Data segment count. */
-	uint32_t relative_offset;
-	uint32_t residual;
-	uint16_t reserved_1[3];
-	uint16_t scsi_status;
-	uint32_t transfer_length;
-	uint32_t dseg_0_address;	/* Data segment 0 address. */
-	uint32_t dseg_0_length;		/* Data segment 0 length. */
-	uint32_t dseg_1_address;	/* Data segment 1 address. */
-	uint32_t dseg_1_length;		/* Data segment 1 length. */
-	uint32_t dseg_2_address;	/* Data segment 2 address. */
-	uint32_t dseg_2_length;		/* Data segment 2 length. */
+	__le16 rx_id;
+	__le16 flags;
+	__le16 status;
+	__le16 timeout;		/* 0 = 30 seconds, 0xFFFF = disable */
+	__le16 dseg_count;		/* Data segment count. */
+	__le32 relative_offset;
+	__le32 residual;
+	__le16 reserved_1[3];
+	__le16 scsi_status;
+	__le32 transfer_length;
+	__le32 dseg_0_address;	/* Data segment 0 address. */
+	__le32 dseg_0_length;		/* Data segment 0 length. */
+	__le32 dseg_1_address;	/* Data segment 1 address. */
+	__le32 dseg_1_length;		/* Data segment 1 length. */
+	__le32 dseg_2_address;	/* Data segment 2 address. */
+	__le32 dseg_2_length;		/* Data segment 2 length. */
 } __packed;
 #define ATIO_PATH_INVALID       0x07
 #define ATIO_CANT_PROV_CAP      0x16
@@ -395,31 +395,31 @@ struct atio7_fcp_cmnd {
 struct atio_from_isp {
 	union {
 		struct {
-			uint16_t entry_hdr;
+			__le16 entry_hdr;
 			uint8_t  sys_define;   /* System defined. */
 			uint8_t  entry_status; /* Entry Status.   */
-			uint32_t sys_define_2; /* System defined. */
+			__le32 sys_define_2; /* System defined. */
 			target_id_t target;
-			uint16_t rx_id;
-			uint16_t flags;
-			uint16_t status;
+			__le16 rx_id;
+			__le16 flags;
+			__le16 status;
 			uint8_t  command_ref;
 			uint8_t  task_codes;
 			uint8_t  task_flags;
 			uint8_t  execution_codes;
 			uint8_t  cdb[MAX_CMDSZ];
-			uint32_t data_length;
-			uint16_t lun;
+			__le32 data_length;
+			__le16 lun;
 			uint8_t  initiator_port_name[WWN_SIZE]; /* on qla23xx */
-			uint16_t reserved_32[6];
-			uint16_t ox_id;
+			__le16 reserved_32[6];
+			__le16 ox_id;
 		} isp2x;
 		struct {
-			uint16_t entry_hdr;
+			__le16 entry_hdr;
 			uint8_t  fcp_cmnd_len_low;
 			uint8_t  fcp_cmnd_len_high:4;
 			uint8_t  attr:4;
-			uint32_t exchange_addr;
+			__le32 exchange_addr;
 #define ATIO_EXCHANGE_ADDRESS_UNKNOWN	0xFFFFFFFF
 			struct fcp_hdr fcp_hdr;
 			struct atio7_fcp_cmnd fcp_cmnd;
@@ -428,7 +428,7 @@ struct atio_from_isp {
 			uint8_t  entry_type;	/* Entry type. */
 			uint8_t  entry_count;	/* Entry count. */
 			uint8_t  data[58];
-			uint32_t signature;
+			__le32 signature;
 #define ATIO_PROCESSED 0xDEADDEAD		/* Signature */
 		} raw;
 	} u;
@@ -446,40 +446,40 @@ struct ctio7_to_24xx {
 	uint8_t	 entry_count;		    /* Entry count. */
 	uint8_t	 sys_define;		    /* System defined. */
 	uint8_t	 entry_status;		    /* Entry Status. */
-	uint32_t handle;		    /* System defined handle */
-	uint16_t nport_handle;
+	__le32 handle;		    /* System defined handle */
+	__le16 nport_handle;
 #define CTIO7_NHANDLE_UNRECOGNIZED	0xFFFF
-	uint16_t timeout;
-	uint16_t dseg_count;		    /* Data segment count. */
+	__le16 timeout;
+	__le16 dseg_count;		    /* Data segment count. */
 	uint8_t  vp_index;
 	uint8_t  add_flags;
 	uint8_t  initiator_id[3];
 	uint8_t  reserved;
-	uint32_t exchange_addr;
+	__le32 exchange_addr;
 	union {
 		struct {
-			uint16_t reserved1;
+			__le16 reserved1;
 			__le16 flags;
-			uint32_t residual;
+			__le32 residual;
 			__le16 ox_id;
-			uint16_t scsi_status;
-			uint32_t relative_offset;
-			uint32_t reserved2;
-			uint32_t transfer_length;
-			uint32_t reserved3;
+			__le16 scsi_status;
+			__le32 relative_offset;
+			__le32 reserved2;
+			__le32 transfer_length;
+			__le32 reserved3;
 			/* Data segment 0 address. */
-			uint32_t dseg_0_address[2];
+			__le32 dseg_0_address[2];
 			/* Data segment 0 length. */
-			uint32_t dseg_0_length;
+			__le32 dseg_0_length;
 		} status0;
 		struct {
-			uint16_t sense_length;
-			uint16_t flags;
-			uint32_t residual;
+			__le16 sense_length;
+			__le16 flags;
+			__le32 residual;
 			__le16 ox_id;
-			uint16_t scsi_status;
-			uint16_t response_len;
-			uint16_t reserved;
+			__le16 scsi_status;
+			__le16 response_len;
+			__le16 reserved;
 			uint8_t sense_data[24];
 		} status1;
 	} u;
