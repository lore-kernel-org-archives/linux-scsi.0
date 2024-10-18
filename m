Received: from rcdn-iport-5.cisco.com (rcdn-iport-5.cisco.com [173.37.86.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFFD6168488;
	Fri, 18 Oct 2024 16:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729268297; cv=none; b=LTJyGb855xHoTkBam3PTA/5vM/I5eebBIWhF2TxYdgAcg3P4ZGX5M61ZYsDDGc0HGFEhi2y9LKwgfeG/NPhv1JhImuC2TpuQ93yVO5G9pwsJSqATHKDXwwU+5mbZdHYrvObBh++Jr6HCMGgkcddIonuOWpDrg8OhXXj51zhS7Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729268297; c=relaxed/simple;
	bh=JToodBVd4+0HJwJ60LTSPrzvLcf+Sjp15T6CZwEznEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cUQWwckSmkCYlIH9IIn6utQVl+uCsK+tFxMuzjauvoKCurlERPzQwtBkCwTJO3Bm7XTeAlt746cDtEVCI3JUnliAgIshWbT+VcgTIxpWJaYMaKRwDK6c0XejIa+ruEuKxmmJS0qX9hB3bgSi6pYzGToo4ylbsiJzjqQqRPDnjHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=lMSeZlW2; arc=none smtp.client-ip=173.37.86.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="lMSeZlW2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=33658; q=dns/txt;
  s=iport; t=1729268294; x=1730477894;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=299/PzslVaVTOJGsCtuBC4JbNiwoZfiSa7ou7iFrKnM=;
  b=lMSeZlW2n4g6OK7Xg3VHd29Cq4oeOEspgX6uKe8QNcaSRqCA5rS1Berm
   dzwZ4uFuwXpYfznQzBErPd8EWC0/DYEYfee5P9CWIPPUrf8tmWT+W7eHT
   1HoBbbTLJ1z3YqLKtU/YYdpfHbSkoEfCjXfgnezs0VlLsgFuUNVzmjGYk
   I=;
X-CSE-ConnectionGUID: W2YJzZjyT0eCWSbhX1tUlA==
X-CSE-MsgGUID: nd262mdhTRS7ZAANTepWpQ==
X-IPAS-Result: =?us-ascii?q?A0BjAwAtiRJn/5D/Ja1SCB4BAQsSDIIEC4JLdllDGS+WQ?=
 =?us-ascii?q?5FLjEwUgREDVg8BAQEPOQsEAQGFBwKKIwImNAkOAQIEAQEBAQMCAwEBAQEBA?=
 =?us-ascii?q?QEBAQ0BAQUBAQECAQcFgQ4ThXsNhlsCAQMaAQwLAUYQUVYZgwEBgmQDEa9zg?=
 =?us-ascii?q?XkzgQHeM4FmBoFIjUZwhHcnFQaBSUSBFYE7gT5vgVKCNAQShmsEhko1h2MWh?=
 =?us-ascii?q?RwBCoNHggCDDXwlgTOICoFvhgOJTkiBIQNZIQIRAVUTDQoLCQWJNYEQghYpg?=
 =?us-ascii?q?WuBCIMIhSWBZwlhiEeBBy2BEYEfOoIDgTZKhTdHP4JPak43Ag0CN4IkgQCCU?=
 =?us-ascii?q?YVSNkADCxgNSBEsNRQbBj5uB6p3gVoBRoJOCAdZNQErFz93MBYBHgEKOpI7G?=
 =?us-ascii?q?wIJEhIhjy6CIIE0n0qEJIwWlSkaM4QFpkeYd4JWiyeWCDWEZoFnPIFZMxoIG?=
 =?us-ascii?q?xWDIhM/GQ+OLRaIbMI3JjICOQIHCwEBAwmMJgQDgRZgAQE?=
IronPort-Data: A9a23:9PaH0q6A61WRxxxAT8YSZAxRtB7GchMFZxGqfqrLsTDasY5as4F+v
 mEbXGvQaa7cNjOjctFzbNzipkoCv5DVx9RlSwpp/CljZn8b8sCt6fZ1gavT04J+CuWZESqLO
 u1HMoGowPgcFyKa+1H3dOC4/RGQ7InQLpLkEunIJyttcgFtTSYlmHpLlvUw6mJSqYDR7zil5
 5Wr+qUzBHf/g2QoazpNu/rewP9SlK2aVA0w7wRWic9j5Dcyp1FNZLoDKKe4KWfPQ4U8NoaSW
 +bZwbilyXjS9hErB8nNuu6TnpoiG+O60aCm0xK6aoD66vRwjnVaPpUTaJLwXXxqZwChxLid/
 jniWauYEm/FNoWU8AgUvoIx/ytWZcWq85efSZSzXFD6I0DuKxPRL/tS4E4eAtcp2PRFA3Byr
 fEzFwsHbiDam9+y6efuIgVsrpxLwMjDJogTvDRkiDreF/tjGc+FSKTR7tge1zA17ixMNa+BP
 IxCNnw1MUmGOkETUrsUIMpWcOOAhXDlbzxcoVG9rqss6G+Vxwt0uFToGICKJITQH5kNxS50o
 ErA8z6nWBQWNOCl8mW321uKuuLXojvCDdd6+LqQs6QCbEeo7mgQEDUXU0e2pb+yjUvWc9BSK
 UY8/isosLh09UauCNL6WnWQpXeeoh8aHcJdD+Ag8wyL4q3O6g2dCy4PSTspQNgnstImAD8nz
 FmEm/v3CjF19r6YU3SQ8vGTtzzaESwUK3ISIDQPVgot/dbuuscwgwjJQ9IlF7S65uAZAhnqy
 DyM6Sx7jLIJgItTiOOw/EvMhHSnoZ2hohMJ2zg7l1mNtmtRDLNJraTxgbQHxZ6s9Lqkc2Q=
IronPort-HdrOrdr: A9a23:aHUY6K4aUqJCeQKJmwPXwOfXdLJyesId70hD6qm+c3Bom6uj5q
 STdZsguyMc5Ax6ZJhko6HiBEDiewK4yXcW2+gs1N6ZNWGMhILrFvAB0WKI+VLd8kPFm9J15O
 NJb7V+BNrsDVJzkMr2pDWjH81I+qjhzEnRv4fjJ7MHd3ASV0mmhD0JbDqmLg==
X-Talos-CUID: 9a23:ONPG92MwBgR7y+5DZ3NW1lwmGNEZKnD280zaI3/hFVttYejA
X-Talos-MUID: 9a23:H7aPdQnA8pMecQK4NrbEdnpkOJ02uaGiCHw3qso0kuCiCSFoBC+k2WE=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.11,214,1725321600"; 
   d="scan'208";a="276022403"
Received: from rcdn-l-core-07.cisco.com ([173.37.255.144])
  by rcdn-iport-5.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 18 Oct 2024 16:18:12 +0000
Received: from fedora.cisco.com (unknown [10.24.40.136])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-07.cisco.com (Postfix) with ESMTPSA id EB3BD18000233;
	Fri, 18 Oct 2024 16:18:09 +0000 (GMT)
From: Karan Tilak Kumar <kartilak@cisco.com>
To: sebaddel@cisco.com
Cc: arulponn@cisco.com,
	djhawar@cisco.com,
	gcboffa@cisco.com,
	mkai2@cisco.com,
	satishkh@cisco.com,
	aeasi@cisco.com,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Karan Tilak Kumar <kartilak@cisco.com>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH v5 06/14] scsi: fnic: Add and integrate support for FDMI
Date: Fri, 18 Oct 2024 09:14:01 -0700
Message-ID: <20241018161409.4442-7-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241018161409.4442-1-kartilak@cisco.com>
References: <20241018161409.4442-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.24.40.136, [10.24.40.136]
X-Outbound-Node: rcdn-l-core-07.cisco.com

Add support for Fabric-Device Management Interface
(FDMI) by introducing PCI device IDs for Cisco
Hardware.
Introduce a module parameter to enable/disable
FDMI support.
Integrate support for FDMI.

Reported-by: kernel test robot <lkp@intel.com>
Closes:
https://lore.kernel.org/oe-kbuild-all/202406110734.p2v8dq9v-lkp
@intel.com/

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Co-developed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Signed-off-by: Gian Carlo Boffa <gcboffa@cisco.com>
Co-developed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Signed-off-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Co-developed-by: Arun Easi <aeasi@cisco.com>
Signed-off-by: Arun Easi <aeasi@cisco.com>
Co-developed-by: Karan Tilak Kumar <kartilak@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
Changes between v4 and v5:
    Incorporate review comments from Martin:
	Modify attribution appropriately.
	Remove spurious newline at the end of fdls_disc.c.
	Remove spurious newline at the end of fnic_main.c.

Changes between v2 and v3:
    Incorporate review comments from Hannes:
	Replace redundant definitions with standard definitions.

Changes between v1 and v2:
    Incorporate review comments from Hannes from other patches:
	Replace pr_info with dev_info.
	Replace htonll() with get_unaligned_be64().
	Replace definitions with standard definitions from fc_els.h.
	Use standard definitions from scsi_transport_fc.h for
	port speeds.
	Refactor definitions in struct fnic to avoid cache holes.
	Replace memcmp with not equal to operator.
    Fix warning from kernel test robot:
	Remove version.h
---
 drivers/scsi/fnic/Makefile                |   3 +-
 drivers/scsi/fnic/fdls_disc.c             | 468 ++++++++++++++++++++++
 drivers/scsi/fnic/fnic.h                  |  72 ++++
 drivers/scsi/fnic/fnic_main.c             |  25 ++
 drivers/scsi/fnic/fnic_pci_subsys_devid.c | 131 ++++++
 5 files changed, 698 insertions(+), 1 deletion(-)
 create mode 100644 drivers/scsi/fnic/fnic_pci_subsys_devid.c

diff --git a/drivers/scsi/fnic/Makefile b/drivers/scsi/fnic/Makefile
index 3bd6b1c8b643..af156c69da0c 100644
--- a/drivers/scsi/fnic/Makefile
+++ b/drivers/scsi/fnic/Makefile
@@ -16,4 +16,5 @@ fnic-y	:= \
 	vnic_intr.o \
 	vnic_rq.o \
 	vnic_wq_copy.o \
-	vnic_wq.o
+	vnic_wq.o \
+	fnic_pci_subsys_devid.o
diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
index a9a98ddc3a84..0b1d69ff19df 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -9,11 +9,23 @@
 #include "fdls_fc.h"
 #include "fnic_fdls.h"
 #include <scsi/fc/fc_fcp.h>
+#include <scsi/scsi_transport_fc.h>
 #include <linux/utsname.h>
 
 #define FC_FC4_TYPE_SCSI 0x08
+#define PORT_SPEED_BIT_8 8
+#define PORT_SPEED_BIT_9 9
+#define PORT_SPEED_BIT_14 14
+#define PORT_SPEED_BIT_15 15
 
 static void fdls_send_rpn_id(struct fnic_iport_s *iport);
+static void fdls_fdmi_register_hba(struct fnic_iport_s *iport);
+static void fdls_fdmi_register_pa(struct fnic_iport_s *iport);
+#define FDLS_FDMI_PLOGI_PENDING 0x1
+#define FDLS_FDMI_REG_HBA_PENDING 0x2
+#define FDLS_FDMI_RPA_PENDING 0x4
+#define FDLS_FDMI_ABORT_PENDING 0x8
+#define FDLS_FDMI_MAX_RETRY 3
 
 /* Frame initialization */
 /*
@@ -84,6 +96,70 @@ struct fc_std_els_prli fnic_std_prli_req = {
 	       .spp_params = cpu_to_be32(0xA2)}
 };
 
+/*
+ * Variables:
+ * sid, port_id, port_name
+ */
+struct fc_std_fdmi_rhba fnic_std_fdmi_rhba = {
+	.fchdr = {.fh_r_ctl = FC_RCTL_DD_UNSOL_CTL,
+			.fh_d_id = {0xFF, 0XFF, 0XFA},
+		  .fh_type = FC_TYPE_CT, .fh_f_ctl = {FNIC_ELS_REQ_FCTL, 0, 0},
+		  .fh_rx_id = 0xFFFF},
+	.fc_std_ct_hdr = {.ct_rev = FC_CT_REV, .ct_fs_type = FC_FST_MGMT,
+			  .ct_fs_subtype = FC_FDMI_SUBTYPE,
+			  .ct_cmd = cpu_to_be16(FC_FDMI_RHBA)},
+	.num_ports = FNIC_FDMI_NUM_PORTS,
+	.num_hba_attributes = FNIC_FDMI_NUM_HBA_ATTRS,
+	.type_nn = FNIC_FDMI_TYPE_NODE_NAME,
+	.length_nn = FNIC_FDMI_NN_LEN,
+	.type_manu = FNIC_FDMI_TYPE_MANUFACTURER,
+	.length_manu = FNIC_FDMI_MANU_LEN,
+	.manufacturer = FNIC_FDMI_MANUFACTURER,
+	.type_serial = FNIC_FDMI_TYPE_SERIAL_NUMBER,
+	.length_serial = FNIC_FDMI_SERIAL_LEN,
+	.type_model = FNIC_FDMI_TYPE_MODEL,
+	.length_model = FNIC_FDMI_MODEL_LEN,
+	.type_model_des = FNIC_FDMI_TYPE_MODEL_DES,
+	.length_model_des = FNIC_FDMI_MODEL_DES_LEN,
+	.model_description = FNIC_FDMI_MODEL_DESCRIPTION,
+	.type_hw_ver = FNIC_FDMI_TYPE_HARDWARE_VERSION,
+	.length_hw_ver = FNIC_FDMI_HW_VER_LEN,
+	.type_dr_ver = FNIC_FDMI_TYPE_DRIVER_VERSION,
+	.length_dr_ver = FNIC_FDMI_DR_VER_LEN,
+	.type_rom_ver = FNIC_FDMI_TYPE_ROM_VERSION,
+	.length_rom_ver = FNIC_FDMI_ROM_VER_LEN,
+	.type_fw_ver = FNIC_FDMI_TYPE_FIRMWARE_VERSION,
+	.length_fw_ver = FNIC_FDMI_FW_VER_LEN,
+};
+
+/*
+ * Variables
+ *sid, port_id, port_name
+ */
+struct fc_std_fdmi_rpa fnic_std_fdmi_rpa = {
+	.fchdr = {.fh_r_ctl = FC_RCTL_DD_UNSOL_CTL,
+			.fh_d_id = {0xFF, 0xFF, 0xFA},
+		  .fh_type = FC_TYPE_CT, .fh_f_ctl = {FNIC_ELS_REQ_FCTL, 0, 0},
+		  .fh_rx_id = 0xFFFF},
+	.fc_std_ct_hdr = {.ct_rev = FC_CT_REV, .ct_fs_type = FC_FST_MGMT,
+			  .ct_fs_subtype = FC_FDMI_SUBTYPE,
+			  .ct_cmd = cpu_to_be16(FC_FDMI_RPA)},
+	.num_port_attributes = FNIC_FDMI_NUM_PORT_ATTRS,
+	.type_fc4 = FNIC_FDMI_TYPE_FC4_TYPES,
+	.length_fc4 = FNIC_FDMI_FC4_LEN,
+	.type_supp_speed = FNIC_FDMI_TYPE_SUPPORTED_SPEEDS,
+	.length_supp_speed = FNIC_FDMI_SUPP_SPEED_LEN,
+	.type_cur_speed = FNIC_FDMI_TYPE_CURRENT_SPEED,
+	.length_cur_speed = FNIC_FDMI_CUR_SPEED_LEN,
+	.type_max_frame_size = FNIC_FDMI_TYPE_MAX_FRAME_SIZE,
+	.length_max_frame_size = FNIC_FDMI_MFS_LEN,
+	.max_frame_size = FNIC_FDMI_MFS,
+	.type_os_name = FNIC_FDMI_TYPE_OS_NAME,
+	.length_os_name = FNIC_FDMI_OS_NAME_LEN,
+	.type_host_name = FNIC_FDMI_TYPE_HOST_NAME,
+	.length_host_name = FNIC_FDMI_HN_LEN,
+};
+
 /*
  * Variables:
  * fh_s_id, port_id, port_name
@@ -224,6 +300,7 @@ static void fdls_target_restart_nexus(struct fnic_tport_s *tport);
 static void fdls_start_tport_timer(struct fnic_iport_s *iport,
 					struct fnic_tport_s *tport, int timeout);
 static void fdls_tport_timer_callback(struct timer_list *t);
+static void fdls_send_fdmi_plogi(struct fnic_iport_s *iport);
 static void fdls_start_fabric_timer(struct fnic_iport_s *iport,
 			int timeout);
 static void
@@ -337,6 +414,15 @@ uint16_t fdls_alloc_fabric_oxid(struct fnic_iport_s *iport,
 	 * separately.
 	 */
 	switch (exp_rsp_type) {
+	case FNIC_FDMI_PLOGI_RSP:
+		oxid_pool->active_oxid_fdmi_plogi = oxid;
+		break;
+	case FNIC_FDMI_REG_HBA_RSP:
+		oxid_pool->active_oxid_fdmi_rhba = oxid;
+		break;
+	case FNIC_FDMI_RPA_RSP:
+		oxid_pool->active_oxid_fdmi_rpa = oxid;
+		break;
 	default:
 		oxid_pool->active_oxid_fabric_req = oxid;
 	break;
@@ -372,6 +458,21 @@ static inline void fdls_schedule_fabric_oxid_free(struct fnic_iport_s
 			    iport->fabric_oxid_pool.active_oxid_fabric_req);
 }
 
+static inline void fdls_schedule_fdmi_oxid_free(struct fnic_iport_s *iport)
+{
+	if (iport->fabric.fdmi_pending & FDLS_FDMI_PLOGI_PENDING)
+		fdls_schedule_oxid_free(&iport->fdmi_oxid_pool.meta,
+					iport->fdmi_oxid_pool.active_oxid_fdmi_plogi);
+
+	if (iport->fabric.fdmi_pending & FDLS_FDMI_REG_HBA_PENDING)
+		fdls_schedule_oxid_free(&iport->fdmi_oxid_pool.meta,
+					iport->fdmi_oxid_pool.active_oxid_fdmi_rhba);
+
+	if (iport->fabric.fdmi_pending & FDLS_FDMI_RPA_PENDING)
+		fdls_schedule_oxid_free(&iport->fdmi_oxid_pool.meta,
+					iport->fdmi_oxid_pool.active_oxid_fdmi_rpa);
+}
+
 static inline void fdls_schedule_tgt_oxid_free(struct fnic_iport_s *iport,
 					       struct fnic_tgt_oxid_pool_s
 					       *oxid_pool, uint16_t oxid)
@@ -406,6 +507,14 @@ static int fdls_is_oxid_in_fabric_range(uint16_t oxid)
 			(oxid_unmasked <= FDLS_FABRIC_OXID_POOL_END));
 }
 
+static int fdls_is_oxid_in_fdmi_range(uint16_t oxid)
+{
+	uint16_t oxid_unmasked = FDLS_OXID_RSP_TYPE_UNMASKED(oxid);
+
+	return ((oxid_unmasked >= FDLS_FDMI_OXID_POOL_BASE) &&
+		(oxid_unmasked <= FDLS_FDMI_OXID_POOL_END));
+}
+
 void fdls_init_tgt_oxid_pool(struct fnic_iport_s *iport)
 {
 	memset(&iport->plogi_oxid_pool, 0, sizeof(iport->plogi_oxid_pool));
@@ -671,6 +780,42 @@ static void fdls_send_fabric_abts(struct fnic_iport_s *iport)
 	iport->fabric.timer_pending = 1;
 }
 
+static void fdls_send_fdmi_abts(struct fnic_iport_s *iport)
+{
+	uint8_t fcid[3];
+	struct fc_frame_header fabric_abort = fc_std_fabric_abts;
+	struct fc_frame_header *fabric_abts = &fabric_abort;
+	struct fnic_fabric_oxid_pool_s *oxid_pool = &iport->fdmi_oxid_pool;
+	int fdmi_tov;
+	uint16_t oxid;
+
+	hton24(fcid, 0XFFFFFA);
+
+	if (iport->fabric.fdmi_pending & FDLS_FDMI_PLOGI_PENDING) {
+		oxid = htons(oxid_pool->active_oxid_fdmi_plogi);
+		FNIC_STD_SET_OX_ID(fabric_abts, oxid);
+		fnic_send_fcoe_frame(iport, fabric_abts,
+				     sizeof(struct fc_frame_header));
+	} else {
+		if (iport->fabric.fdmi_pending & FDLS_FDMI_REG_HBA_PENDING) {
+			oxid = htons(oxid_pool->active_oxid_fdmi_rhba);
+			FNIC_STD_SET_OX_ID(fabric_abts, oxid);
+			fnic_send_fcoe_frame(iport, fabric_abts,
+					     sizeof(struct fc_frame_header));
+		}
+		if (iport->fabric.fdmi_pending & FDLS_FDMI_RPA_PENDING) {
+			oxid = htons(oxid_pool->active_oxid_fdmi_rpa);
+			FNIC_STD_SET_OX_ID(fabric_abts, oxid);
+			fnic_send_fcoe_frame(iport, fabric_abts,
+					     sizeof(struct fc_frame_header));
+		}
+	}
+
+	fdmi_tov = jiffies + msecs_to_jiffies(2 * iport->e_d_tov);
+	mod_timer(&iport->fabric.fdmi_timer, round_jiffies(fdmi_tov));
+	iport->fabric.fdmi_pending |= FDLS_FDMI_ABORT_PENDING;
+}
+
 static void fdls_send_fabric_flogi(struct fnic_iport_s *iport)
 {
 	struct fc_std_flogi flogi;
@@ -738,6 +883,47 @@ static void fdls_send_fabric_plogi(struct fnic_iport_s *iport)
 	fdls_start_fabric_timer(iport, 2 * iport->e_d_tov);
 }
 
+static void fdls_send_fdmi_plogi(struct fnic_iport_s *iport)
+{
+	struct fc_std_flogi plogi;
+	struct fc_frame_header *fchdr = &plogi.fchdr;
+	uint8_t fcid[3];
+	struct fnic *fnic = iport->fnic;
+	u64 fdmi_tov;
+	uint16_t oxid;
+
+	memcpy(&plogi, &fnic_std_plogi_req, sizeof(plogi));
+
+	oxid = fdls_alloc_fabric_oxid(iport, &iport->fdmi_oxid_pool,
+				      FNIC_FDMI_PLOGI_RSP);
+	if (oxid == 0xFFFF) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			     "Failed to allocate OXID to send fdmi plogi %p",
+			     iport);
+		return;
+	}
+
+	hton24(fcid, iport->fcid);
+
+	FNIC_STD_SET_S_ID(fchdr, fcid);
+	hton24(fcid, 0XFFFFFA);
+	FNIC_STD_SET_D_ID(fchdr, fcid);
+	FNIC_STD_SET_OX_ID(fchdr, htons(oxid));
+	FNIC_LOGI_SET_NPORT_NAME(&plogi.els, iport->wwpn);
+	FNIC_LOGI_SET_NODE_NAME(&plogi.els, iport->wwnn);
+	FNIC_LOGI_SET_RDF_SIZE(&plogi.els, iport->max_payload_size);
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		     "fcid: 0x%x: FDLS send FDMI PLOGI with oxid:%x",
+		     iport->fcid, oxid);
+
+	fnic_send_fcoe_frame(iport, &plogi, sizeof(struct fc_std_flogi));
+
+	fdmi_tov = jiffies + msecs_to_jiffies(2 * iport->e_d_tov);
+	mod_timer(&iport->fabric.fdmi_timer, round_jiffies(fdmi_tov));
+	iport->fabric.fdmi_pending = FDLS_FDMI_PLOGI_PENDING;
+}
+
 static void fdls_send_rpn_id(struct fnic_iport_s *iport)
 {
 	struct fc_std_rpn_id rpn_id;
@@ -1375,6 +1561,126 @@ struct fnic_tport_s *fnic_find_tport_by_wwpn(struct fnic_iport_s *iport,
 	return NULL;
 }
 
+static void fdls_fdmi_register_hba(struct fnic_iport_s *iport)
+{
+	struct fc_std_fdmi_rhba fdmi_rhba;
+	uint8_t fcid[3];
+	uint16_t len;
+	int err;
+	struct fnic *fnic = iport->fnic;
+	struct vnic_devcmd_fw_info *fw_info = NULL;
+	uint16_t oxid;
+
+	memcpy(&fdmi_rhba, &fnic_std_fdmi_rhba,
+	       sizeof(struct fc_std_fdmi_rhba));
+
+	hton24(fcid, iport->fcid);
+	FNIC_STD_SET_S_ID((&fdmi_rhba.fchdr), fcid);
+
+	oxid = fdls_alloc_fabric_oxid(iport, &iport->fdmi_oxid_pool,
+				      FNIC_FDMI_REG_HBA_RSP);
+	if (oxid == 0xFFFF) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			     "Failed to allocate OXID to send fdmi reg hba %p",
+			     iport);
+		return;
+	}
+	FNIC_STD_SET_OX_ID(&fdmi_rhba.fchdr, htons(oxid));
+
+	fdmi_rhba.hba_identifier = get_unaligned_be64(&iport->wwpn);
+	fdmi_rhba.port_name = get_unaligned_be64(&iport->wwpn);
+	fdmi_rhba.node_name = get_unaligned_be64(&iport->wwnn);
+
+	err = vnic_dev_fw_info(fnic->vdev, &fw_info);
+	if (!err) {
+		snprintf(fdmi_rhba.serial_num, sizeof(fdmi_rhba.serial_num) - 1,
+				 "%s", fw_info->hw_serial_number);
+		snprintf(fdmi_rhba.hardware_ver,
+				 sizeof(fdmi_rhba.hardware_ver) - 1, "%s",
+				 fw_info->hw_version);
+		strscpy(fdmi_rhba.firmware_ver, fw_info->fw_version,
+				sizeof(fdmi_rhba.firmware_ver) - 1);
+
+		len = ARRAY_SIZE(fdmi_rhba.model);
+		if (fnic->subsys_desc_len >= len)
+			fnic->subsys_desc_len = len - 1;
+		memcpy(&fdmi_rhba.model, fnic->subsys_desc,
+		       fnic->subsys_desc_len);
+		fdmi_rhba.model[fnic->subsys_desc_len] = 0x00;
+	}
+
+	snprintf(fdmi_rhba.driver_ver, sizeof(fdmi_rhba.driver_ver) - 1, "%s",
+			 DRV_VERSION);
+	snprintf(fdmi_rhba.rom_ver, sizeof(fdmi_rhba.rom_ver) - 1, "%s", "N/A");
+
+	fnic_send_fcoe_frame(iport, &fdmi_rhba,
+			     sizeof(struct fc_std_fdmi_rhba));
+	iport->fabric.fdmi_pending |= FDLS_FDMI_REG_HBA_PENDING;
+}
+
+static void fdls_fdmi_register_pa(struct fnic_iport_s *iport)
+{
+	struct fc_std_fdmi_rpa fdmi_rpa;
+
+	uint8_t fcid[3];
+	struct fnic *fnic = iport->fnic;
+	u32 port_speed_bm;
+	u32 port_speed = vnic_dev_port_speed(fnic->vdev);
+	uint16_t oxid;
+
+	memcpy(&fdmi_rpa, &fnic_std_fdmi_rpa, sizeof(struct fc_std_fdmi_rpa));
+	hton24(fcid, iport->fcid);
+	FNIC_STD_SET_S_ID((&fdmi_rpa.fchdr), fcid);
+
+	oxid = fdls_alloc_fabric_oxid(iport, &iport->fdmi_oxid_pool,
+				      FNIC_FDMI_RPA_RSP);
+	if (oxid == 0xFFFF) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			     "Failed to allocate OXID to send fdmi rpa %p",
+			     iport);
+		return;
+	}
+	FNIC_STD_SET_OX_ID(&fdmi_rpa.fchdr, htons(oxid));
+
+	fdmi_rpa.port_name = get_unaligned_be64(&iport->wwpn);
+
+	/* MDS does not support GIGE speed.
+	 * Bit shift standard definitions from scsi_transport_fc.h to
+	 * match FC spec.
+	 */
+	switch (port_speed) {
+	case DCEM_PORTSPEED_10G:
+	case DCEM_PORTSPEED_20G:
+		/* There is no bit for 20G */
+		port_speed_bm = FC_PORTSPEED_10GBIT << PORT_SPEED_BIT_14;
+		break;
+	case DCEM_PORTSPEED_25G:
+		port_speed_bm = FC_PORTSPEED_25GBIT << PORT_SPEED_BIT_8;
+		break;
+	case DCEM_PORTSPEED_40G:
+	case DCEM_PORTSPEED_4x10G:
+		port_speed_bm = FC_PORTSPEED_40GBIT << PORT_SPEED_BIT_9;
+		break;
+	case DCEM_PORTSPEED_100G:
+		port_speed_bm = FC_PORTSPEED_100GBIT << PORT_SPEED_BIT_8;
+		break;
+	default:
+		port_speed_bm = FC_PORTSPEED_1GBIT << PORT_SPEED_BIT_15;
+		break;
+	}
+	fdmi_rpa.supported_speed = htonl(port_speed_bm);
+	fdmi_rpa.current_speed = htonl(port_speed_bm);
+	fdmi_rpa.fc4_type[2] = 1;
+	snprintf(fdmi_rpa.os_name, sizeof(fdmi_rpa.os_name) - 1, "host%d",
+		 fnic->lport->host->host_no);
+	sprintf(fc_host_system_hostname(fnic->lport->host), "%s", utsname()->nodename);
+	snprintf(fdmi_rpa.host_name, sizeof(fdmi_rpa.host_name) - 1, "%s",
+		 fc_host_system_hostname(fnic->lport->host));
+
+	fnic_send_fcoe_frame(iport, &fdmi_rpa, sizeof(struct fc_std_fdmi_rpa));
+	iport->fabric.fdmi_pending |= FDLS_FDMI_RPA_PENDING;
+}
+
 void fdls_fabric_timer_callback(struct timer_list *t)
 {
 	struct fnic_fdls_fabric_s *fabric = from_timer(fabric, t, retry_timer);
@@ -1548,6 +1854,43 @@ void fdls_fabric_timer_callback(struct timer_list *t)
 	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 }
 
+void fdls_fdmi_timer_callback(struct timer_list *t)
+{
+	struct fnic_fdls_fabric_s *fabric = from_timer(fabric, t, fdmi_timer);
+	struct fnic_iport_s *iport =
+		container_of(fabric, struct fnic_iport_s, fabric);
+	struct fnic *fnic = iport->fnic;
+	unsigned long flags;
+
+	spin_lock_irqsave(&fnic->fnic_lock, flags);
+
+	if (!iport->fabric.fdmi_pending) {
+		/* timer expired after fdmi responses received. */
+		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+		return;
+	}
+
+	/* if not abort pending, send an abort */
+	if (!(iport->fabric.fdmi_pending & FDLS_FDMI_ABORT_PENDING)) {
+		fdls_send_fdmi_abts(iport);
+		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+		return;
+	}
+
+	/* Abort timed out */
+	fdls_schedule_fdmi_oxid_free(iport);
+
+	iport->fabric.fdmi_pending = 0;
+	/* If max retries not exhaused, start over from fdmi plogi */
+	if (iport->fabric.fdmi_retry < FDLS_FDMI_MAX_RETRY) {
+		iport->fabric.fdmi_retry++;
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "retry fdmi timer %d", iport->fabric.fdmi_retry);
+		fdls_send_fdmi_plogi(iport);
+	}
+	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+}
+
 static void fdls_send_delete_tport_msg(struct fnic_tport_s *tport)
 {
 	struct fnic_iport_s *iport = (struct fnic_iport_s *) tport->iport;
@@ -1697,6 +2040,15 @@ static void fnic_fdls_start_plogi(struct fnic_iport_s *iport)
 	fdls_send_fabric_plogi(iport);
 	fdls_set_state((&iport->fabric), FDLS_STATE_FABRIC_PLOGI);
 	iport->fabric.flags &= ~FNIC_FDLS_FABRIC_ABORT_ISSUED;
+
+	if ((fnic_fdmi_support == 1) && (!(iport->flags & FNIC_FDMI_ACTIVE))) {
+		/* we can do FDMI at the same time */
+		iport->fabric.fdmi_retry = 0;
+		timer_setup(&iport->fabric.fdmi_timer, fdls_fdmi_timer_callback,
+					0);
+		fdls_send_fdmi_plogi(iport);
+		iport->flags |= FNIC_FDMI_ACTIVE;
+	}
 }
 
 static void
@@ -2784,6 +3136,109 @@ fdls_process_fabric_plogi_rsp(struct fnic_iport_s *iport,
 	}
 }
 
+static void fdls_process_fdmi_plogi_rsp(struct fnic_iport_s *iport,
+					struct fc_frame_header *fchdr)
+{
+	struct fc_std_flogi *plogi_rsp = (struct fc_std_flogi *)fchdr;
+	struct fc_std_els_rsp *els_rjt = (struct fc_std_els_rsp *)fchdr;
+	struct fnic *fnic = iport->fnic;
+	u64 fdmi_tov;
+
+	iport->fabric.fdmi_pending &= ~FDLS_FDMI_PLOGI_PENDING;
+	fdls_free_fabric_oxid(iport, &iport->fabric_oxid_pool,
+			      ntohs(FNIC_STD_GET_OX_ID(fchdr)));
+
+	if (ntoh24(fchdr->fh_s_id) == 0XFFFFFA) {
+		del_timer_sync(&iport->fabric.fdmi_timer);
+		iport->fabric.fdmi_pending = 0;
+		switch (plogi_rsp->els.fl_cmd) {
+		case ELS_LS_ACC:
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "FDLS process fdmi PLOGI response status: ELS_LS_ACC\n");
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "Sending fdmi registration for port 0x%x\n",
+				 iport->fcid);
+
+			fdls_fdmi_register_hba(iport);
+			fdls_fdmi_register_pa(iport);
+			fdmi_tov = jiffies + msecs_to_jiffies(5000);
+			mod_timer(&iport->fabric.fdmi_timer,
+				  round_jiffies(fdmi_tov));
+			break;
+		case ELS_LS_RJT:
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "Fabric FDMI PLOGI returned ELS_LS_RJT reason: 0x%x",
+				     els_rjt->u.rej.er_reason);
+
+			if (((els_rjt->u.rej.er_reason == ELS_RJT_BUSY)
+			     || (els_rjt->u.rej.er_reason == ELS_RJT_UNAB))
+				&& (iport->fabric.fdmi_retry < 7)) {
+				iport->fabric.fdmi_retry++;
+				fdls_send_fdmi_plogi(iport);
+			}
+			break;
+		default:
+			break;
+		}
+	}
+}
+
+static void fdls_process_fdmi_reg_ack(struct fnic_iport_s *iport,
+				      struct fc_frame_header *fchdr,
+				      int rsp_type)
+{
+	struct fnic *fnic = iport->fnic;
+
+	if (!iport->fabric.fdmi_pending) {
+		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+			     "Received FDMI ack while not waiting:%x\n",
+			     ntohs(FNIC_STD_GET_OX_ID(fchdr)));
+		return;
+	}
+
+	if (rsp_type == FNIC_FDMI_REG_HBA_RSP)
+		iport->fabric.fdmi_pending &= ~FDLS_FDMI_REG_HBA_PENDING;
+	else
+		iport->fabric.fdmi_pending &= ~FDLS_FDMI_RPA_PENDING;
+
+	fdls_free_fabric_oxid(iport, &iport->fdmi_oxid_pool,
+			      ntohs(FNIC_STD_GET_OX_ID(fchdr)));
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		"iport fcid: 0x%x: Received FDMI registration ack\n",
+		 iport->fcid);
+
+	if (!iport->fabric.fdmi_pending) {
+		del_timer_sync(&iport->fabric.fdmi_timer);
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "iport fcid: 0x%x: Canceling FDMI timer\n",
+					 iport->fcid);
+	}
+}
+
+static void fdls_process_fdmi_abts_rsp(struct fnic_iport_s *iport,
+				       struct fc_frame_header *fchdr)
+{
+	uint32_t s_id;
+	struct fnic *fnic = iport->fnic;
+
+	s_id = ntoh24(FNIC_STD_GET_S_ID(fchdr));
+
+	if (!(s_id != 0xFFFFFA)) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			     "Received abts rsp with invalid SID: 0x%x. Dropping frame",
+			     s_id);
+		return;
+	}
+
+	del_timer_sync(&iport->fabric.fdmi_timer);
+	iport->fabric.fdmi_pending &= ~FDLS_FDMI_ABORT_PENDING;
+
+	fdls_free_fabric_oxid(iport, &iport->fdmi_oxid_pool,
+			      ntohs(FNIC_STD_GET_OX_ID(fchdr)));
+	fdls_send_fdmi_plogi(iport);
+}
+
 static void
 fdls_process_fabric_abts_rsp(struct fnic_iport_s *iport,
 			     struct fc_frame_header *fchdr)
@@ -3780,6 +4235,9 @@ fnic_fdls_validate_and_get_frame_type(struct fnic_iport_s *iport,
 	break;
 
 	case FNIC_FABRIC_LOGO_RSP:
+	case FNIC_FDMI_PLOGI_RSP:
+	case FNIC_FDMI_REG_HBA_RSP:
+	case FNIC_FDMI_RPA_RSP:
 	break;
 	default:
 		/* Drop the Rx frame and log/stats it */
@@ -3822,6 +4280,9 @@ void fnic_fdls_recv_frame(struct fnic_iport_s *iport, void *rx_frame,
 	case FNIC_FABRIC_PLOGI_RSP:
 		fdls_process_fabric_plogi_rsp(iport, fchdr);
 		break;
+	case FNIC_FDMI_PLOGI_RSP:
+		fdls_process_fdmi_plogi_rsp(iport, fchdr);
+		break;
 	case FNIC_FABRIC_RPN_RSP:
 		fdls_process_rpn_id_rsp(iport, fchdr);
 		break;
@@ -3861,6 +4322,9 @@ void fnic_fdls_recv_frame(struct fnic_iport_s *iport, void *rx_frame,
 		if (fdls_is_oxid_in_fabric_range(oxid) &&
 			(iport->fabric.flags & FNIC_FDLS_FABRIC_ABORT_ISSUED)) {
 			fdls_process_fabric_abts_rsp(iport, fchdr);
+		} else if (fdls_is_oxid_in_fdmi_range(oxid) &&
+			   iport->fabric.fdmi_pending) {
+			fdls_process_fdmi_abts_rsp(iport, fchdr);
 		} else {
 			fdls_process_tgt_abts_rsp(iport, fchdr);
 		}
@@ -3890,6 +4354,10 @@ void fnic_fdls_recv_frame(struct fnic_iport_s *iport, void *rx_frame,
 	case FNIC_ELS_RLS:
 		fdls_process_rls_req(iport, fchdr);
 		break;
+	case FNIC_FDMI_REG_HBA_RSP:
+	case FNIC_FDMI_RPA_RSP:
+		fdls_process_fdmi_reg_ack(iport, fchdr, frame_type);
+		break;
 	default:
 		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
 			 "s_id: 0x%x d_did: 0x%x", s_id, d_id);
diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 92cd17efa40f..5d8315b24085 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -82,6 +82,72 @@
 /* Retry supported by rport (returned by PRLI service parameters) */
 #define FNIC_FC_RP_FLAGS_RETRY            0x1
 
+/* Cisco vendor id */
+#define PCI_VENDOR_ID_CISCO						0x1137
+#define PCI_DEVICE_ID_CISCO_VIC_FC				0x0045	/* fc vnic */
+
+/* sereno pcie switch */
+#define PCI_DEVICE_ID_CISCO_SERENO             0x004e
+#define PCI_DEVICE_ID_CISCO_CRUZ               0x007a	/* Cruz */
+#define PCI_DEVICE_ID_CISCO_BODEGA             0x0131	/* Bodega */
+#define PCI_DEVICE_ID_CISCO_BEVERLY            0x025f	/* Beverly */
+
+/* Sereno */
+#define PCI_SUBDEVICE_ID_CISCO_VASONA			0x004f	/* vasona mezz */
+#define PCI_SUBDEVICE_ID_CISCO_COTATI			0x0084	/* cotati mlom */
+#define PCI_SUBDEVICE_ID_CISCO_LEXINGTON		0x0085	/* lexington pcie */
+#define PCI_SUBDEVICE_ID_CISCO_ICEHOUSE			0x00cd	/* Icehouse */
+#define PCI_SUBDEVICE_ID_CISCO_KIRKWOODLAKE		0x00ce	/* KirkwoodLake pcie */
+#define PCI_SUBDEVICE_ID_CISCO_SUSANVILLE		0x012e	/* Susanville MLOM */
+#define PCI_SUBDEVICE_ID_CISCO_TORRANCE			0x0139	/* Torrance MLOM */
+
+/* Cruz */
+#define PCI_SUBDEVICE_ID_CISCO_CALISTOGA		0x012c	/* Calistoga MLOM */
+#define PCI_SUBDEVICE_ID_CISCO_MOUNTAINVIEW		0x0137	/* Cruz Mezz */
+/* Cruz MountTian SIOC */
+#define PCI_SUBDEVICE_ID_CISCO_MOUNTTIAN		0x014b
+#define PCI_SUBDEVICE_ID_CISCO_CLEARLAKE		0x014d	/* ClearLake pcie */
+/* Cruz MountTian2 SIOC */
+#define PCI_SUBDEVICE_ID_CISCO_MOUNTTIAN2		0x0157
+#define PCI_SUBDEVICE_ID_CISCO_CLAREMONT		0x015d	/* Claremont MLOM */
+
+/* Bodega */
+/* VIC 1457 PCIe mLOM */
+#define PCI_SUBDEVICE_ID_CISCO_BRADBURY         0x0218
+#define PCI_SUBDEVICE_ID_CISCO_BRENTWOOD        0x0217	/* VIC 1455 PCIe */
+/* VIC 1487 PCIe mLOM */
+#define PCI_SUBDEVICE_ID_CISCO_BURLINGAME       0x021a
+#define PCI_SUBDEVICE_ID_CISCO_BAYSIDE          0x0219	/* VIC 1485 PCIe */
+/* VIC 1440 Mezz mLOM */
+#define PCI_SUBDEVICE_ID_CISCO_BAKERSFIELD      0x0215
+#define PCI_SUBDEVICE_ID_CISCO_BOONVILLE        0x0216	/* VIC 1480 Mezz */
+#define PCI_SUBDEVICE_ID_CISCO_BENICIA          0x024a	/* VIC 1495 */
+#define PCI_SUBDEVICE_ID_CISCO_BEAUMONT         0x024b	/* VIC 1497 */
+#define PCI_SUBDEVICE_ID_CISCO_BRISBANE         0x02af	/* VIC 1467 */
+#define PCI_SUBDEVICE_ID_CISCO_BENTON           0x02b0	/* VIC 1477 */
+#define PCI_SUBDEVICE_ID_CISCO_TWIN_RIVER       0x02cf	/* VIC 14425 */
+#define PCI_SUBDEVICE_ID_CISCO_TWIN_PEAK        0x02d0	/* VIC 14825 */
+
+/* Beverly */
+#define PCI_SUBDEVICE_ID_CISCO_BERN             0x02de	/* VIC 15420 */
+#define PCI_SUBDEVICE_ID_CISCO_STOCKHOLM        0x02dd	/* VIC 15428 */
+#define PCI_SUBDEVICE_ID_CISCO_KRAKOW           0x02dc	/* VIC 15411 */
+#define PCI_SUBDEVICE_ID_CISCO_LUCERNE          0x02db	/* VIC 15231 */
+#define PCI_SUBDEVICE_ID_CISCO_TURKU            0x02e8	/* VIC 15238 */
+#define PCI_SUBDEVICE_ID_CISCO_TURKU_PLUS       0x02f3	/* VIC 15237 */
+#define PCI_SUBDEVICE_ID_CISCO_ZURICH           0x02df	/* VIC 15230 */
+#define PCI_SUBDEVICE_ID_CISCO_RIGA             0x02e0	/* VIC 15427 */
+#define PCI_SUBDEVICE_ID_CISCO_GENEVA           0x02e1	/* VIC 15422 */
+#define PCI_SUBDEVICE_ID_CISCO_HELSINKI         0x02e4	/* VIC 15235 */
+#define PCI_SUBDEVICE_ID_CISCO_GOTHENBURG       0x02f2	/* VIC 15425 */
+
+struct fnic_pcie_device {
+	u32 device;
+	u8 *desc;
+	u32 subsystem_device;
+	u8 *subsys_desc;
+};
+
 /*
  * fnic private data per SCSI command.
  * These fields are locked by the hashed io_req_lock.
@@ -134,6 +200,7 @@ static inline u64 fnic_flags_and_state(struct scsi_cmnd *cmd)
 #define fnic_clear_state_flags(fnicp, st_flags)  \
 	__fnic_set_state_flags(fnicp, st_flags, 1)
 
+extern unsigned int fnic_fdmi_support;
 extern unsigned int fnic_log_level;
 extern unsigned int io_completions;
 extern struct workqueue_struct *fnic_event_queue;
@@ -336,6 +403,9 @@ struct fnic {
 	struct work_struct tport_work;
 	struct list_head tport_event_list;
 
+	char subsys_desc[14];
+	int subsys_desc_len;
+
 	/*** FIP related data members  -- start ***/
 	void (*set_vlan)(struct fnic *, u16 vlan);
 	struct work_struct      fip_frame_work;
@@ -433,5 +503,7 @@ fnic_chk_state_flags_locked(struct fnic *fnic, unsigned long st_flags)
 void __fnic_set_state_flags(struct fnic *, unsigned long, unsigned long);
 void fnic_dump_fchost_stats(struct Scsi_Host *, struct fc_host_statistics *);
 void fnic_free_txq(struct list_head *head);
+int fnic_get_desc_by_devid(struct pci_dev *pdev, char **desc,
+						   char **subsys_desc);
 
 #endif /* _FNIC_H_ */
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 16c9f87c932b..c8d2fcf5d948 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -62,6 +62,9 @@ unsigned int fnic_log_level;
 module_param(fnic_log_level, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(fnic_log_level, "bit mask of fnic logging levels");
 
+unsigned int fnic_fdmi_support = 1;
+module_param(fnic_fdmi_support, int, 0644);
+MODULE_PARM_DESC(fnic_fdmi_support, "FDMI support");
 
 unsigned int io_completions = FNIC_DFLT_IO_COMPLETIONS;
 module_param(io_completions, int, S_IRUGO|S_IWUSR);
@@ -607,6 +610,8 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	int i;
 	unsigned long flags;
 	int hwq;
+	char *desc, *subsys_desc;
+	int len;
 
 	/*
 	 * Allocate SCSI Host and set up association between host,
@@ -640,6 +645,23 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	fnic->fnic_num = fnic_id;
 	fnic_stats_debugfs_init(fnic);
 
+	/* Find model name from PCIe subsys ID */
+	if (fnic_get_desc_by_devid(pdev, &desc, &subsys_desc) == 0) {
+		dev_info(&fnic->pdev->dev, "Model: %s\n", subsys_desc);
+
+		/* Update FDMI model */
+		fnic->subsys_desc_len = strlen(subsys_desc);
+		len = ARRAY_SIZE(fnic->subsys_desc);
+		if (fnic->subsys_desc_len > len)
+			fnic->subsys_desc_len = len;
+		memcpy(fnic->subsys_desc, subsys_desc, fnic->subsys_desc_len);
+		dev_info(&fnic->pdev->dev, "FDMI Model: %s\n", fnic->subsys_desc);
+	} else {
+		fnic->subsys_desc_len = 0;
+		dev_info(&fnic->pdev->dev, "Model: %s subsys_id: 0x%04x\n", "Unknown",
+				pdev->subsystem_device);
+	}
+
 	err = pci_enable_device(pdev);
 	if (err) {
 		dev_err(&fnic->pdev->dev, "Cannot enable PCI device, aborting.\n");
@@ -1014,6 +1036,9 @@ static void fnic_remove(struct pci_dev *pdev)
 		fnic_fcoe_evlist_free(fnic);
 	}
 
+	if ((fnic_fdmi_support == 1) && (fnic->iport.fabric.fdmi_pending > 0))
+		del_timer_sync(&fnic->iport.fabric.fdmi_timer);
+
 	/*
 	 * Log off the fabric. This stops all remote ports, dns port,
 	 * logs off the fabric. This flushes all rport, disc, lport work
diff --git a/drivers/scsi/fnic/fnic_pci_subsys_devid.c b/drivers/scsi/fnic/fnic_pci_subsys_devid.c
new file mode 100644
index 000000000000..36a2c1268422
--- /dev/null
+++ b/drivers/scsi/fnic/fnic_pci_subsys_devid.c
@@ -0,0 +1,131 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright 2008 Cisco Systems, Inc.  All rights reserved.
+ * Copyright 2007 Nuova Systems, Inc.  All rights reserved.
+ */
+
+#include <linux/module.h>
+#include <linux/mempool.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/pci.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/spinlock.h>
+#include <linux/workqueue.h>
+#include <linux/kthread.h>
+#include <linux/if_ether.h>
+#include "fnic.h"
+
+static struct fnic_pcie_device fnic_pcie_device_table[] = {
+	{PCI_DEVICE_ID_CISCO_SERENO, "Sereno", PCI_SUBDEVICE_ID_CISCO_VASONA,
+	 "VIC 1280"},
+	{PCI_DEVICE_ID_CISCO_SERENO, "Sereno", PCI_SUBDEVICE_ID_CISCO_COTATI,
+	 "VIC 1240"},
+	{PCI_DEVICE_ID_CISCO_SERENO, "Sereno",
+	 PCI_SUBDEVICE_ID_CISCO_LEXINGTON, "VIC 1225"},
+	{PCI_DEVICE_ID_CISCO_SERENO, "Sereno", PCI_SUBDEVICE_ID_CISCO_ICEHOUSE,
+	 "VIC 1285"},
+	{PCI_DEVICE_ID_CISCO_SERENO, "Sereno",
+	 PCI_SUBDEVICE_ID_CISCO_KIRKWOODLAKE, "VIC 1225T"},
+	{PCI_DEVICE_ID_CISCO_SERENO, "Sereno",
+	 PCI_SUBDEVICE_ID_CISCO_SUSANVILLE, "VIC 1227"},
+	{PCI_DEVICE_ID_CISCO_SERENO, "Sereno", PCI_SUBDEVICE_ID_CISCO_TORRANCE,
+	 "VIC 1227T"},
+
+	{PCI_DEVICE_ID_CISCO_CRUZ, "Cruz", PCI_SUBDEVICE_ID_CISCO_CALISTOGA,
+	 "VIC 1340"},
+	{PCI_DEVICE_ID_CISCO_CRUZ, "Cruz", PCI_SUBDEVICE_ID_CISCO_MOUNTAINVIEW,
+	 "VIC 1380"},
+	{PCI_DEVICE_ID_CISCO_CRUZ, "Cruz", PCI_SUBDEVICE_ID_CISCO_MOUNTTIAN,
+	 "C3260-SIOC"},
+	{PCI_DEVICE_ID_CISCO_CRUZ, "Cruz", PCI_SUBDEVICE_ID_CISCO_CLEARLAKE,
+	 "VIC 1385"},
+	{PCI_DEVICE_ID_CISCO_CRUZ, "Cruz", PCI_SUBDEVICE_ID_CISCO_MOUNTTIAN2,
+	 "C3260-SIOC"},
+	{PCI_DEVICE_ID_CISCO_CRUZ, "Cruz", PCI_SUBDEVICE_ID_CISCO_CLAREMONT,
+	 "VIC 1387"},
+
+	{PCI_DEVICE_ID_CISCO_BODEGA, "Bodega", PCI_SUBDEVICE_ID_CISCO_BRADBURY,
+	 "VIC 1457"},
+	{PCI_DEVICE_ID_CISCO_BODEGA, "Bodega",
+	 PCI_SUBDEVICE_ID_CISCO_BRENTWOOD, "VIC 1455"},
+	{PCI_DEVICE_ID_CISCO_BODEGA, "Bodega",
+	 PCI_SUBDEVICE_ID_CISCO_BURLINGAME, "VIC 1487"},
+	{PCI_DEVICE_ID_CISCO_BODEGA, "Bodega", PCI_SUBDEVICE_ID_CISCO_BAYSIDE,
+	 "VIC 1485"},
+	{PCI_DEVICE_ID_CISCO_BODEGA, "Bodega",
+	 PCI_SUBDEVICE_ID_CISCO_BAKERSFIELD, "VIC 1440"},
+	{PCI_DEVICE_ID_CISCO_BODEGA, "Bodega",
+	 PCI_SUBDEVICE_ID_CISCO_BOONVILLE, "VIC 1480"},
+	{PCI_DEVICE_ID_CISCO_BODEGA, "Bodega", PCI_SUBDEVICE_ID_CISCO_BENICIA,
+	 "VIC 1495"},
+	{PCI_DEVICE_ID_CISCO_BODEGA, "Bodega", PCI_SUBDEVICE_ID_CISCO_BEAUMONT,
+	 "VIC 1497"},
+	{PCI_DEVICE_ID_CISCO_BODEGA, "Bodega", PCI_SUBDEVICE_ID_CISCO_BRISBANE,
+	 "VIC 1467"},
+	{PCI_DEVICE_ID_CISCO_BODEGA, "Bodega", PCI_SUBDEVICE_ID_CISCO_BENTON,
+	 "VIC 1477"},
+	{PCI_DEVICE_ID_CISCO_BODEGA, "Bodega",
+	 PCI_SUBDEVICE_ID_CISCO_TWIN_RIVER, "VIC 14425"},
+	{PCI_DEVICE_ID_CISCO_BODEGA, "Bodega",
+	 PCI_SUBDEVICE_ID_CISCO_TWIN_PEAK, "VIC 14825"},
+
+	{PCI_DEVICE_ID_CISCO_BEVERLY, "Beverly", PCI_SUBDEVICE_ID_CISCO_BERN,
+	 "VIC 15420"},
+	{PCI_DEVICE_ID_CISCO_BEVERLY, "Beverly",
+	 PCI_SUBDEVICE_ID_CISCO_STOCKHOLM, "VIC 15428"},
+	{PCI_DEVICE_ID_CISCO_BEVERLY, "Beverly", PCI_SUBDEVICE_ID_CISCO_KRAKOW,
+	 "VIC 15411"},
+	{PCI_DEVICE_ID_CISCO_BEVERLY, "Beverly",
+	 PCI_SUBDEVICE_ID_CISCO_LUCERNE, "VIC 15231"},
+	{PCI_DEVICE_ID_CISCO_BEVERLY, "Beverly", PCI_SUBDEVICE_ID_CISCO_TURKU,
+	 "VIC 15238"},
+	{PCI_DEVICE_ID_CISCO_BEVERLY, "Beverly", PCI_SUBDEVICE_ID_CISCO_GENEVA,
+	 "VIC 15422"},
+	{PCI_DEVICE_ID_CISCO_BEVERLY, "Beverly",
+	 PCI_SUBDEVICE_ID_CISCO_HELSINKI, "VIC 15235"},
+	{PCI_DEVICE_ID_CISCO_BEVERLY, "Beverly",
+	 PCI_SUBDEVICE_ID_CISCO_GOTHENBURG, "VIC 15425"},
+	{PCI_DEVICE_ID_CISCO_BEVERLY, "Beverly",
+	 PCI_SUBDEVICE_ID_CISCO_TURKU_PLUS, "VIC 15237"},
+	{PCI_DEVICE_ID_CISCO_BEVERLY, "Beverly", PCI_SUBDEVICE_ID_CISCO_ZURICH,
+	 "VIC 15230"},
+	{PCI_DEVICE_ID_CISCO_BEVERLY, "Beverly", PCI_SUBDEVICE_ID_CISCO_RIGA,
+	 "VIC 15427"},
+
+	{0,}
+};
+
+int fnic_get_desc_by_devid(struct pci_dev *pdev, char **desc,
+						   char **subsys_desc)
+{
+	unsigned short device = PCI_DEVICE_ID_CISCO_VIC_FC;
+	int max = ARRAY_SIZE(fnic_pcie_device_table);
+	struct fnic_pcie_device *t = fnic_pcie_device_table;
+	int index = 0;
+
+	if (pdev->device != device)
+		return 1;
+
+	while (t->device != 0) {
+		if (memcmp
+			((char *) &pdev->subsystem_device,
+			 (char *) &t->subsystem_device, sizeof(short)) == 0)
+			break;
+		t++;
+		index++;
+	}
+
+	if (index >= max - 1) {
+		*desc = NULL;
+		*subsys_desc = NULL;
+		return 1;
+	}
+
+	*desc = fnic_pcie_device_table[index].desc;
+	*subsys_desc = fnic_pcie_device_table[index].subsys_desc;
+	return 0;
+}
-- 
2.31.1

