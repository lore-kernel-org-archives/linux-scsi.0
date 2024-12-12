Received: from rcdn-iport-8.cisco.com (rcdn-iport-8.cisco.com [173.37.86.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA2814A82;
	Thu, 12 Dec 2024 02:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733969297; cv=none; b=VYMmT6X9wCIv9Utm4tDY/p7BxB/Ea7xSqTlJWsT6yoZPHj5yXOhbTPDbfbt8VdXpysLaSLKnllnpREjf3/Ll0C4SZHHsXZlVKcoB7VniZq1RxpN7QnH+fIy93Ap9v7tgmg+tvr0NUY/eblfSSDZ6hotmo4m12U+OIhRTWpHk5XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733969297; c=relaxed/simple;
	bh=9+bhPHjpEeonXkneMIrc3d1hYTBXAdn2WDgF6BjhGB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dpk73H1Vq6og8WSXMsFL4SF9kiEyl19LyzvCm/pu21Qb4HRTTO1dWyrQmaZFClCqlc89q5hpFLbXSWJra/7ZKXmo8uG4rKIpkblxjbaL/XQgg4Xrt5z4tNpCtaK9fAxc7L5SfSfgN/2gF3yv1/xZ79NR593QqHBYWKW7kro41ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=Aa476Lwk; arc=none smtp.client-ip=173.37.86.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="Aa476Lwk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=30546; q=dns/txt;
  s=iport; t=1733969295; x=1735178895;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qauWY+qdYJoCo3Yt9uprDgRPNIDrxqGXBw47HsKPPS0=;
  b=Aa476Lwk4zhHbVvkFmbyTeOPXTUnlCM4iWs2A4dGHjv1DOflEvkP26pN
   xHPadE/dHRgFdDbKslYDNNdlv+dgQ4noDDLvjxB55zFS8VJyq3EQPgQN4
   WewQg5ZnZdZoaSTuK+qOYzQOtoSGZewHWsK7csAghn1xIEWIwtdrOryHR
   I=;
X-CSE-ConnectionGUID: OfG5mgo9RyKi2/rLibiMZw==
X-CSE-MsgGUID: xhoVukOJQaqXLD25hM7F5Q==
X-IPAS-Result: =?us-ascii?q?A0B9AwBqRFpn/5T/Ja1aHgEBCxIMgggLgkt2WUMZL5ZDk?=
 =?us-ascii?q?U2MToElA1YPAQEBDzkLBAEBhQcCimsCJjQJDgECBAEBAQEDAgMBAQEBAQEBA?=
 =?us-ascii?q?QEBAQsBAQUBAQECAQcFgQ4ThXsNhlsCAQMaDQsBRhBRVhmDAQGCZAMRrwWBe?=
 =?us-ascii?q?TOBAd4zgWcGgUiNSnCEdycVBoFJRIEVgTuBPm+BUok1BIkcgW+FVYMpgnwdL?=
 =?us-ascii?q?0aBaIMyiGtIgSEDWSERAVUTDQoLBwWBdQM5DAsxFYNgRj2CSWlJNwINAjaCJ?=
 =?us-ascii?q?HyCTYUZhGljLwMDAwODOYYkghmBX0ADCxgNSBEsNxQbBj5uB5tKAUaDUgEHB?=
 =?us-ascii?q?1k2ExgXP3YBMBYBHgEKOpJAGwIJAZADgiCBNJ9OhCSMF5UtGjOEBKZNmHuCV?=
 =?us-ascii?q?4srlVkZGTeEZoFnPIFZMxoIGxWDIhM/GQ+OLRaIbLsbJTICOgIHCwEBAwmPU?=
 =?us-ascii?q?gQDgRZgAQE?=
IronPort-Data: A9a23:hIveB6Kjxh1zUjNLFE+R95QlxSXFcZb7ZxGr2PjKsXjdYENS02BUz
 moZWW7SM/6IYGKgedgjb4rj8UtTuJ/WmNY2G1Md+CA2RRqmiyZq6fd1j6vUF3nPRiEWZBs/t
 63yUvGZcoZsCCea/kr1WlTYhSEU/bmSQbbhA/LzNCl0RAt1IA8skhsLd9QR2uaEuvDnRVrX0
 T/Oi5eHYgP8gWctaj98B5+r8XuDgtyj4Fv0gXRmDRx7lAe2v2UYCpsZOZawIxPQKqFIHvS3T
 vr017qw+GXU5X8FUrtJRZ6iLyXm6paLVeS/oiI+t5qK23CulQRuukoPD8fwXG8M49m/c3+d/
 /0W3XC4YV9B0qQhA43xWTEAe811FfUuFLMqvRFTvOTLp3AqfUcAzN1JAm5rOIIfq9xmImAUs
 uY8KToMSyKc0rfeLLKTEoGAh+w5J8XteYdasXZ6wHSAVLAtQIvIROPB4towMDUY358VW62BI
 ZBENHw2MESojx5nYj/7DLo9lf20h332cBVTqUmeouw85G27IAlZiuizbYeJJo3bLSlTtlaYo
 Vzb/EPbOxgDBPizk2eF1y2C29aayEsXX6pXTtVU7MVChF6L7m0VFBASE1C8pJGRiEO8UfpbK
 koJ6mwvp610/0uuJvH4VgekoXjCphMAVsBLHusS7xuEwa7ZpQ2eAwAsSj9Hdcxjt8IsQzEu/
 kGGksmvBjF1trCRD3WH+d+8qTK0JDhQNmQZZAcaQgYfpdruuoc+ilTIVNkLLUKupsf+FTe1x
 3WBqzIzwuxKy8UKzK68u1vAhlpAu6T0c+L83S2PNkrN0++zTNfNi1CAgbQD0ct9EQ==
IronPort-HdrOrdr: A9a23:halMJqNegqDV88BcTu6jsMiBIKoaSvp037Dk7SxMoHtuA6ilfq
 +V8sjzuSWftN9VYgBCpTniAtjkfZq/z/9ICOAqVN/IYOClghrLEGgI1+TfKlPbdhHWx6p0yb
 pgf69iCNf5EFR2yfrh7BLQKadG/DD+ysCVbSO09QYVcemsAJsQiTtENg==
X-Talos-CUID: 9a23:MTGfBWAq4r8kzSL6Ew5p2xMRFcd0SGz+zS2XOWu5A2dMeqLAHA==
X-Talos-MUID: =?us-ascii?q?9a23=3AJaC1pw3tctVZN2AM3ZfZSKi53zUj86SpNl0Otrc?=
 =?us-ascii?q?/stC0EQAqZje40xrqe9py?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.12,227,1728950400"; 
   d="scan'208";a="286554499"
Received: from rcdn-l-core-11.cisco.com ([173.37.255.148])
  by rcdn-iport-8.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 12 Dec 2024 02:08:14 +0000
Received: from fedora.cisco.com (unknown [10.24.83.168])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-11.cisco.com (Postfix) with ESMTPSA id 691E11800025D;
	Thu, 12 Dec 2024 02:08:12 +0000 (GMT)
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
Subject: [PATCH v7 07/15] scsi: fnic: Add and integrate support for FDMI
Date: Wed, 11 Dec 2024 18:03:04 -0800
Message-ID: <20241212020312.4786-8-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241212020312.4786-1-kartilak@cisco.com>
References: <20241212020312.4786-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.24.83.168, [10.24.83.168]
X-Outbound-Node: rcdn-l-core-11.cisco.com

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
Changes between v5 and v6:
    Incorporate review comments from Martin:
        Remove GCC 13.3 warnings.
    Incorporate review comments from Hannes:
	Split patch into PCI changes and FDMI changes.
	Allocate OXID from a pool.
	Modify frame initialization.

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
 drivers/scsi/fnic/fdls_disc.c | 658 ++++++++++++++++++++++++++++++++++
 drivers/scsi/fnic/fnic.h      |   1 +
 drivers/scsi/fnic/fnic_main.c |  19 +-
 3 files changed, 676 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
index e08cf343bad7..35f117d23f90 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -18,6 +18,52 @@
 #define PORT_SPEED_BIT_14 14
 #define PORT_SPEED_BIT_15 15
 
+/* FNIC FDMI Register HBA Macros */
+#define FNIC_FDMI_NUM_PORTS 1
+#define FNIC_FDMI_NUM_HBA_ATTRS 9
+#define FNIC_FDMI_TYPE_NODE_NAME	0X1
+#define FNIC_FDMI_TYPE_MANUFACTURER	0X2
+#define FNIC_FDMI_MANUFACTURER		"Cisco Systems"
+#define FNIC_FDMI_TYPE_SERIAL_NUMBER	0X3
+#define FNIC_FDMI_TYPE_MODEL		0X4
+#define FNIC_FDMI_TYPE_MODEL_DES	0X5
+#define FNIC_FDMI_MODEL_DESCRIPTION	"Cisco Virtual Interface Card"
+#define FNIC_FDMI_TYPE_HARDWARE_VERSION	0X6
+#define FNIC_FDMI_TYPE_DRIVER_VERSION	0X7
+#define FNIC_FDMI_TYPE_ROM_VERSION	0X8
+#define FNIC_FDMI_TYPE_FIRMWARE_VERSION	0X9
+#define FNIC_FDMI_NN_LEN 8
+#define FNIC_FDMI_MANU_LEN 20
+#define FNIC_FDMI_SERIAL_LEN 16
+#define FNIC_FDMI_MODEL_LEN 12
+#define FNIC_FDMI_MODEL_DES_LEN 56
+#define FNIC_FDMI_HW_VER_LEN 16
+#define FNIC_FDMI_DR_VER_LEN 28
+#define FNIC_FDMI_ROM_VER_LEN 8
+#define FNIC_FDMI_FW_VER_LEN 16
+
+/* FNIC FDMI Register PA Macros */
+#define FNIC_FDMI_TYPE_FC4_TYPES	0X1
+#define FNIC_FDMI_TYPE_SUPPORTED_SPEEDS 0X2
+#define FNIC_FDMI_TYPE_CURRENT_SPEED	0X3
+#define FNIC_FDMI_TYPE_MAX_FRAME_SIZE	0X4
+#define FNIC_FDMI_TYPE_OS_NAME		0X5
+#define FNIC_FDMI_TYPE_HOST_NAME	0X6
+#define FNIC_FDMI_NUM_PORT_ATTRS 6
+#define FNIC_FDMI_FC4_LEN 32
+#define FNIC_FDMI_SUPP_SPEED_LEN 4
+#define FNIC_FDMI_CUR_SPEED_LEN 4
+#define FNIC_FDMI_MFS_LEN 4
+#define FNIC_FDMI_MFS 0x800
+#define FNIC_FDMI_OS_NAME_LEN 16
+#define FNIC_FDMI_HN_LEN 24
+
+#define FDLS_FDMI_PLOGI_PENDING 0x1
+#define FDLS_FDMI_REG_HBA_PENDING 0x2
+#define FDLS_FDMI_RPA_PENDING 0x4
+#define FDLS_FDMI_ABORT_PENDING 0x8
+#define FDLS_FDMI_MAX_RETRY 3
+
 #define RETRIES_EXHAUSTED(iport)      \
 	(iport->fabric.retry_counter == FABRIC_LOGO_MAX_RETRY)
 
@@ -26,6 +72,8 @@
 #define SCHEDULE_OXID_FREE_RETRY_TIME (300)
 
 /* Private Functions */
+static void fdls_fdmi_register_hba(struct fnic_iport_s *iport);
+static void fdls_fdmi_register_pa(struct fnic_iport_s *iport);
 static void fdls_send_rpn_id(struct fnic_iport_s *iport);
 static void fdls_process_flogi_rsp(struct fnic_iport_s *iport,
 				   struct fc_frame_header *fchdr,
@@ -39,6 +87,7 @@ static void fdls_target_restart_nexus(struct fnic_tport_s *tport);
 static void fdls_start_tport_timer(struct fnic_iport_s *iport,
 					struct fnic_tport_s *tport, int timeout);
 static void fdls_tport_timer_callback(struct timer_list *t);
+static void fdls_send_fdmi_plogi(struct fnic_iport_s *iport);
 static void fdls_start_fabric_timer(struct fnic_iport_s *iport,
 			int timeout);
 static void fdls_init_plogi_frame(uint8_t *frame, struct fnic_iport_s *iport);
@@ -721,6 +770,52 @@ static void fdls_send_fabric_abts(struct fnic_iport_s *iport)
 	iport->fabric.timer_pending = 1;
 }
 
+static void fdls_send_fdmi_abts(struct fnic_iport_s *iport)
+{
+	uint8_t *frame;
+	uint8_t d_id[3];
+	struct fnic *fnic = iport->fnic;
+	struct fc_frame_header *pfabric_abts;
+	unsigned long fdmi_tov;
+	uint16_t oxid;
+	uint16_t frame_size = FNIC_ETH_FCOE_HDRS_OFFSET +
+			sizeof(struct fc_frame_header);
+
+	frame = fdls_alloc_frame(iport);
+	if (frame == NULL) {
+		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+				"Failed to allocate frame to send FDMI ABTS");
+		return;
+	}
+
+	pfabric_abts = (struct fc_frame_header *) (frame + FNIC_ETH_FCOE_HDRS_OFFSET);
+	fdls_init_fabric_abts_frame(frame, iport);
+
+	hton24(d_id, FC_FID_MGMT_SERV);
+	FNIC_STD_SET_D_ID(*pfabric_abts, d_id);
+
+	if (iport->fabric.fdmi_pending & FDLS_FDMI_PLOGI_PENDING) {
+		oxid = iport->active_oxid_fdmi_plogi;
+		FNIC_STD_SET_OX_ID(*pfabric_abts, oxid);
+		fnic_send_fcoe_frame(iport, frame, frame_size);
+	} else {
+		if (iport->fabric.fdmi_pending & FDLS_FDMI_REG_HBA_PENDING) {
+			oxid = iport->active_oxid_fdmi_rhba;
+			FNIC_STD_SET_OX_ID(*pfabric_abts, oxid);
+			fnic_send_fcoe_frame(iport, frame, frame_size);
+		}
+		if (iport->fabric.fdmi_pending & FDLS_FDMI_RPA_PENDING) {
+			oxid = iport->active_oxid_fdmi_rpa;
+			FNIC_STD_SET_OX_ID(*pfabric_abts, oxid);
+			fnic_send_fcoe_frame(iport, frame, frame_size);
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
 	uint8_t *frame;
@@ -823,6 +918,54 @@ static void fdls_send_fabric_plogi(struct fnic_iport_s *iport)
 	fdls_start_fabric_timer(iport, 2 * iport->e_d_tov);
 }
 
+static void fdls_send_fdmi_plogi(struct fnic_iport_s *iport)
+{
+	uint8_t *frame;
+	struct fc_std_flogi *pplogi;
+	struct fnic *fnic = iport->fnic;
+	uint16_t oxid;
+	uint16_t frame_size = FNIC_ETH_FCOE_HDRS_OFFSET +
+			sizeof(struct fc_std_flogi);
+	uint8_t d_id[3];
+	u64 fdmi_tov;
+
+	frame = fdls_alloc_frame(iport);
+	if (frame == NULL) {
+		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		     "Failed to allocate frame to send FDMI PLOGI");
+		goto err_out;
+	}
+
+	pplogi = (struct fc_std_flogi *) (frame + FNIC_ETH_FCOE_HDRS_OFFSET);
+	fdls_init_plogi_frame(frame, iport);
+
+	oxid = fdls_alloc_oxid(iport, FNIC_FRAME_TYPE_FDMI_PLOGI,
+		&iport->active_oxid_fdmi_plogi);
+
+	if (oxid == FNIC_UNASSIGNED_OXID) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			     "0x%x: Failed to allocate OXID to send FDMI PLOGI",
+			     iport->fcid);
+		mempool_free(frame, fnic->frame_pool);
+		goto err_out;
+	}
+	FNIC_STD_SET_OX_ID(pplogi->fchdr, oxid);
+
+	hton24(d_id, FC_FID_MGMT_SERV);
+	FNIC_STD_SET_D_ID(pplogi->fchdr, d_id);
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		     "0x%x: FDLS send FDMI PLOGI with oxid: 0x%x",
+		     iport->fcid, oxid);
+
+	fnic_send_fcoe_frame(iport, frame, frame_size);
+
+err_out:
+	fdmi_tov = jiffies + msecs_to_jiffies(2 * iport->e_d_tov);
+	mod_timer(&iport->fabric.fdmi_timer, round_jiffies(fdmi_tov));
+	iport->fabric.fdmi_pending = FDLS_FDMI_PLOGI_PENDING;
+}
+
 static void fdls_send_rpn_id(struct fnic_iport_s *iport)
 {
 	uint8_t *frame;
@@ -1644,6 +1787,300 @@ struct fnic_tport_s *fnic_find_tport_by_wwpn(struct fnic_iport_s *iport,
 	return NULL;
 }
 
+static void
+fnic_fdmi_attr_set(void *attr_start, u16 type, u16 len,
+		void *data, u32 *off)
+{
+	u16 size = len + FC_FDMI_ATTR_ENTRY_HEADER_LEN;
+	struct fc_fdmi_attr_entry *fdmi_attr = (struct fc_fdmi_attr_entry *)
+		((u8 *)attr_start + *off);
+
+	put_unaligned_be16(type, &fdmi_attr->type);
+	put_unaligned_be16(size, &fdmi_attr->len);
+	memcpy(fdmi_attr->value, data, len);
+	*off += size;
+}
+
+static void fdls_fdmi_register_hba(struct fnic_iport_s *iport)
+{
+	uint8_t *frame;
+	struct fc_std_fdmi_rhba *prhba;
+	struct fc_fdmi_attr_entry *fdmi_attr;
+	uint8_t fcid[3];
+	int err;
+	struct fnic *fnic = iport->fnic;
+	struct vnic_devcmd_fw_info *fw_info = NULL;
+	uint16_t oxid;
+	u32 attr_off_bytes, len;
+	u8 data[64];
+	uint16_t frame_size = FNIC_ETH_FCOE_HDRS_OFFSET;
+
+	frame = fdls_alloc_frame(iport);
+	if (frame == NULL) {
+		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		     "Failed to allocate frame to send FDMI RHBA");
+		return;
+	}
+
+	prhba = (struct fc_std_fdmi_rhba *) (frame + FNIC_ETH_FCOE_HDRS_OFFSET);
+	*prhba = (struct fc_std_fdmi_rhba) {
+		.fchdr = {
+			.fh_r_ctl = FC_RCTL_DD_UNSOL_CTL,
+			.fh_d_id = {0xFF, 0XFF, 0XFA},
+			.fh_type = FC_TYPE_CT,
+			.fh_f_ctl = {FNIC_ELS_REQ_FCTL, 0, 0},
+			.fh_rx_id = cpu_to_be16(FNIC_UNASSIGNED_RXID)
+		},
+		.fc_std_ct_hdr = {
+			.ct_rev = FC_CT_REV, .ct_fs_type = FC_FST_MGMT,
+			.ct_fs_subtype = FC_FDMI_SUBTYPE,
+			.ct_cmd = cpu_to_be16(FC_FDMI_RHBA)
+		},
+	};
+
+	hton24(fcid, iport->fcid);
+	FNIC_STD_SET_S_ID(prhba->fchdr, fcid);
+
+	oxid = fdls_alloc_oxid(iport, FNIC_FRAME_TYPE_FDMI_RHBA,
+		&iport->active_oxid_fdmi_rhba);
+
+	if (oxid == FNIC_UNASSIGNED_OXID) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			     "0x%x: Failed to allocate OXID to send FDMI RHBA",
+		     iport->fcid);
+		mempool_free(frame, fnic->frame_pool);
+		return;
+	}
+	FNIC_STD_SET_OX_ID(prhba->fchdr, oxid);
+
+	put_unaligned_be64(iport->wwpn, &prhba->rhba.hbaid.id);
+	put_unaligned_be32(FNIC_FDMI_NUM_PORTS, &prhba->rhba.port.numport);
+	put_unaligned_be64(iport->wwpn, &prhba->rhba.port.port[0].portname);
+	put_unaligned_be32(FNIC_FDMI_NUM_HBA_ATTRS,
+			&prhba->rhba.hba_attrs.numattrs);
+
+	fdmi_attr = prhba->rhba.hba_attrs.attr;
+	attr_off_bytes = 0;
+
+	put_unaligned_be64(iport->wwnn, data);
+	fnic_fdmi_attr_set(fdmi_attr, FNIC_FDMI_TYPE_NODE_NAME,
+		FNIC_FDMI_NN_LEN, data, &attr_off_bytes);
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			"NN set, off=%d", attr_off_bytes);
+
+	strscpy_pad(data, FNIC_FDMI_MANUFACTURER, FNIC_FDMI_MANU_LEN);
+	fnic_fdmi_attr_set(fdmi_attr, FNIC_FDMI_TYPE_MANUFACTURER,
+		FNIC_FDMI_MANU_LEN, data, &attr_off_bytes);
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			"MFG set <%s>, off=%d", data, attr_off_bytes);
+
+	err = vnic_dev_fw_info(fnic->vdev, &fw_info);
+	if (!err) {
+		strscpy_pad(data, fw_info->hw_serial_number,
+				FNIC_FDMI_SERIAL_LEN);
+		fnic_fdmi_attr_set(fdmi_attr, FNIC_FDMI_TYPE_SERIAL_NUMBER,
+			FNIC_FDMI_SERIAL_LEN, data, &attr_off_bytes);
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				"SERIAL set <%s>, off=%d", data, attr_off_bytes);
+
+	}
+
+	if (fnic->subsys_desc_len >= FNIC_FDMI_MODEL_LEN)
+		fnic->subsys_desc_len = FNIC_FDMI_MODEL_LEN - 1;
+	strscpy_pad(data, fnic->subsys_desc, FNIC_FDMI_MODEL_LEN);
+	data[FNIC_FDMI_MODEL_LEN - 1] = 0;
+	fnic_fdmi_attr_set(fdmi_attr, FNIC_FDMI_TYPE_MODEL, FNIC_FDMI_MODEL_LEN,
+		data, &attr_off_bytes);
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			"MODEL set <%s>, off=%d", data, attr_off_bytes);
+
+	strscpy_pad(data, FNIC_FDMI_MODEL_DESCRIPTION, FNIC_FDMI_MODEL_DES_LEN);
+	fnic_fdmi_attr_set(fdmi_attr, FNIC_FDMI_TYPE_MODEL_DES,
+		FNIC_FDMI_MODEL_DES_LEN, data, &attr_off_bytes);
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			"MODEL_DESC set <%s>, off=%d", data, attr_off_bytes);
+
+	if (!err) {
+		strscpy_pad(data, fw_info->hw_version, FNIC_FDMI_HW_VER_LEN);
+		fnic_fdmi_attr_set(fdmi_attr, FNIC_FDMI_TYPE_HARDWARE_VERSION,
+			FNIC_FDMI_HW_VER_LEN, data, &attr_off_bytes);
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				"HW_VER set <%s>, off=%d", data, attr_off_bytes);
+
+	}
+
+	strscpy_pad(data, DRV_VERSION, FNIC_FDMI_DR_VER_LEN);
+	fnic_fdmi_attr_set(fdmi_attr, FNIC_FDMI_TYPE_DRIVER_VERSION,
+		FNIC_FDMI_DR_VER_LEN, data, &attr_off_bytes);
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			"DRV_VER set <%s>, off=%d", data, attr_off_bytes);
+
+	strscpy_pad(data, "N/A", FNIC_FDMI_ROM_VER_LEN);
+	fnic_fdmi_attr_set(fdmi_attr, FNIC_FDMI_TYPE_ROM_VERSION,
+		FNIC_FDMI_ROM_VER_LEN, data, &attr_off_bytes);
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			"ROM_VER set <%s>, off=%d", data, attr_off_bytes);
+
+	if (!err) {
+		strscpy_pad(data, fw_info->fw_version, FNIC_FDMI_FW_VER_LEN);
+		fnic_fdmi_attr_set(fdmi_attr, FNIC_FDMI_TYPE_FIRMWARE_VERSION,
+			FNIC_FDMI_FW_VER_LEN, data, &attr_off_bytes);
+
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				"FW_VER set <%s>, off=%d", data, attr_off_bytes);
+	}
+
+	len = sizeof(struct fc_std_fdmi_rhba) + attr_off_bytes;
+	frame_size += len;
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		 "0x%x: FDLS send FDMI RHBA with oxid: 0x%x fs: %d", iport->fcid,
+		 oxid, frame_size);
+
+	fnic_send_fcoe_frame(iport, frame, frame_size);
+	iport->fabric.fdmi_pending |= FDLS_FDMI_REG_HBA_PENDING;
+}
+
+static void fdls_fdmi_register_pa(struct fnic_iport_s *iport)
+{
+	uint8_t *frame;
+	struct fc_std_fdmi_rpa *prpa;
+	struct fc_fdmi_attr_entry *fdmi_attr;
+	uint8_t fcid[3];
+	struct fnic *fnic = iport->fnic;
+	u32 port_speed_bm;
+	u32 port_speed = vnic_dev_port_speed(fnic->vdev);
+	uint16_t oxid;
+	u32 attr_off_bytes, len;
+	u8 tmp_data[16], data[64];
+	uint16_t frame_size = FNIC_ETH_FCOE_HDRS_OFFSET;
+
+	frame = fdls_alloc_frame(iport);
+	if (frame == NULL) {
+		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		     "Failed to allocate frame to send FDMI RPA");
+		return;
+	}
+
+	prpa = (struct fc_std_fdmi_rpa *) (frame + FNIC_ETH_FCOE_HDRS_OFFSET);
+	*prpa = (struct fc_std_fdmi_rpa) {
+		.fchdr = {
+			.fh_r_ctl = FC_RCTL_DD_UNSOL_CTL,
+			.fh_d_id = {0xFF, 0xFF, 0xFA},
+			.fh_type = FC_TYPE_CT,
+			.fh_f_ctl = {FNIC_ELS_REQ_FCTL, 0, 0},
+			.fh_rx_id = cpu_to_be16(FNIC_UNASSIGNED_RXID)
+		},
+		.fc_std_ct_hdr = {
+			.ct_rev = FC_CT_REV, .ct_fs_type = FC_FST_MGMT,
+			.ct_fs_subtype = FC_FDMI_SUBTYPE,
+			.ct_cmd = cpu_to_be16(FC_FDMI_RPA)
+		},
+	};
+
+	hton24(fcid, iport->fcid);
+	FNIC_STD_SET_S_ID(prpa->fchdr, fcid);
+
+	oxid = fdls_alloc_oxid(iport, FNIC_FRAME_TYPE_FDMI_RPA,
+		&iport->active_oxid_fdmi_rpa);
+
+	if (oxid == FNIC_UNASSIGNED_OXID) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			     "0x%x: Failed to allocate OXID to send FDMI RPA",
+			     iport->fcid);
+		mempool_free(frame, fnic->frame_pool);
+		return;
+	}
+	FNIC_STD_SET_OX_ID(prpa->fchdr, oxid);
+
+	put_unaligned_be64(iport->wwpn, &prpa->rpa.port.portname);
+	put_unaligned_be32(FNIC_FDMI_NUM_PORT_ATTRS,
+				&prpa->rpa.hba_attrs.numattrs);
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
+	attr_off_bytes = 0;
+
+	fdmi_attr = prpa->rpa.hba_attrs.attr;
+
+	put_unaligned_be64(iport->wwnn, data);
+
+	memset(data, 0, FNIC_FDMI_FC4_LEN);
+	data[2] = 1;
+	fnic_fdmi_attr_set(fdmi_attr, FNIC_FDMI_TYPE_FC4_TYPES,
+		FNIC_FDMI_FC4_LEN, data, &attr_off_bytes);
+
+	put_unaligned_be32(port_speed_bm, data);
+	fnic_fdmi_attr_set(fdmi_attr, FNIC_FDMI_TYPE_SUPPORTED_SPEEDS,
+		FNIC_FDMI_SUPP_SPEED_LEN, data, &attr_off_bytes);
+
+	put_unaligned_be32(port_speed_bm, data);
+	fnic_fdmi_attr_set(fdmi_attr, FNIC_FDMI_TYPE_CURRENT_SPEED,
+		FNIC_FDMI_CUR_SPEED_LEN, data, &attr_off_bytes);
+
+	put_unaligned_be32(FNIC_FDMI_MFS, data);
+	fnic_fdmi_attr_set(fdmi_attr, FNIC_FDMI_TYPE_MAX_FRAME_SIZE,
+		FNIC_FDMI_MFS_LEN, data, &attr_off_bytes);
+
+	snprintf(tmp_data, FNIC_FDMI_OS_NAME_LEN - 1, "host%d",
+		 fnic->lport->host->host_no);
+	strscpy_pad(data, tmp_data, FNIC_FDMI_OS_NAME_LEN);
+	data[FNIC_FDMI_OS_NAME_LEN - 1] = 0;
+	fnic_fdmi_attr_set(fdmi_attr, FNIC_FDMI_TYPE_OS_NAME,
+		FNIC_FDMI_OS_NAME_LEN, data, &attr_off_bytes);
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			"OS name set <%s>, off=%d", data, attr_off_bytes);
+
+	sprintf(fc_host_system_hostname(fnic->lport->host), "%s", utsname()->nodename);
+	strscpy_pad(data, fc_host_system_hostname(fnic->lport->host),
+					FNIC_FDMI_HN_LEN);
+	data[FNIC_FDMI_HN_LEN - 1] = 0;
+	fnic_fdmi_attr_set(fdmi_attr, FNIC_FDMI_TYPE_HOST_NAME,
+		FNIC_FDMI_HN_LEN, data, &attr_off_bytes);
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			"Host name set <%s>, off=%d", data, attr_off_bytes);
+
+	len = sizeof(struct fc_std_fdmi_rpa) + attr_off_bytes;
+	frame_size += len;
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		 "0x%x: FDLS send FDMI RPA with oxid: 0x%x fs: %d", iport->fcid,
+		 oxid, frame_size);
+
+	fnic_send_fcoe_frame(iport, frame, frame_size);
+	iport->fabric.fdmi_pending |= FDLS_FDMI_RPA_PENDING;
+}
+
 void fdls_fabric_timer_callback(struct timer_list *t)
 {
 	struct fnic_fdls_fabric_s *fabric = from_timer(fabric, t, retry_timer);
@@ -1817,6 +2254,64 @@ void fdls_fabric_timer_callback(struct timer_list *t)
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
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		"fdmi timer callback : 0x%x\n", iport->fabric.fdmi_pending);
+
+	if (!iport->fabric.fdmi_pending) {
+		/* timer expired after fdmi responses received. */
+		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+		return;
+	}
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		"fdmi timer callback : 0x%x\n", iport->fabric.fdmi_pending);
+
+	/* if not abort pending, send an abort */
+	if (!(iport->fabric.fdmi_pending & FDLS_FDMI_ABORT_PENDING)) {
+		fdls_send_fdmi_abts(iport);
+		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+		return;
+	}
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		"fdmi timer callback : 0x%x\n", iport->fabric.fdmi_pending);
+
+	/* ABTS pending for an active fdmi request that is pending.
+	 * That means FDMI ABTS timed out
+	 * Schedule to free the OXID after 2*r_a_tov and proceed
+	 */
+	if (iport->fabric.fdmi_pending & FDLS_FDMI_PLOGI_PENDING) {
+		fdls_schedule_oxid_free(iport, &iport->active_oxid_fdmi_plogi);
+	} else {
+		if (iport->fabric.fdmi_pending & FDLS_FDMI_REG_HBA_PENDING)
+			fdls_schedule_oxid_free(iport, &iport->active_oxid_fdmi_rhba);
+		if (iport->fabric.fdmi_pending & FDLS_FDMI_RPA_PENDING)
+			fdls_schedule_oxid_free(iport, &iport->active_oxid_fdmi_rpa);
+	}
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		"fdmi timer callback : 0x%x\n", iport->fabric.fdmi_pending);
+
+	iport->fabric.fdmi_pending = 0;
+	/* If max retries not exhaused, start over from fdmi plogi */
+	if (iport->fabric.fdmi_retry < FDLS_FDMI_MAX_RETRY) {
+		iport->fabric.fdmi_retry++;
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "retry fdmi timer %d", iport->fabric.fdmi_retry);
+		fdls_send_fdmi_plogi(iport);
+	}
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		"fdmi timer callback : 0x%x\n", iport->fabric.fdmi_pending);
+	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+}
+
 static void fdls_send_delete_tport_msg(struct fnic_tport_s *tport)
 {
 	struct fnic_iport_s *iport = (struct fnic_iport_s *) tport->iport;
@@ -1956,6 +2451,15 @@ static void fnic_fdls_start_plogi(struct fnic_iport_s *iport)
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
 fdls_process_tgt_adisc_rsp(struct fnic_iport_s *iport,
@@ -3090,6 +3594,144 @@ fdls_process_fabric_plogi_rsp(struct fnic_iport_s *iport,
 	}
 }
 
+static void fdls_process_fdmi_plogi_rsp(struct fnic_iport_s *iport,
+					struct fc_frame_header *fchdr)
+{
+	struct fc_std_flogi *plogi_rsp = (struct fc_std_flogi *)fchdr;
+	struct fc_std_els_rjt_rsp *els_rjt = (struct fc_std_els_rjt_rsp *)fchdr;
+	struct fnic_fdls_fabric_s *fdls = &iport->fabric;
+	struct fnic *fnic = iport->fnic;
+	u64 fdmi_tov;
+	uint16_t oxid = FNIC_STD_GET_OX_ID(fchdr);
+
+	if (iport->active_oxid_fdmi_plogi != oxid) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			"Incorrect OXID in response. state: %d, oxid recvd: 0x%x, active oxid: 0x%x\n",
+			fdls_get_state(fdls), oxid, iport->active_oxid_fdmi_plogi);
+		return;
+	}
+
+	iport->fabric.fdmi_pending &= ~FDLS_FDMI_PLOGI_PENDING;
+	fdls_free_oxid(iport, oxid, &iport->active_oxid_fdmi_plogi);
+
+	if (ntoh24(fchdr->fh_s_id) == FC_FID_MGMT_SERV) {
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
+				     els_rjt->rej.er_reason);
+
+			if (((els_rjt->rej.er_reason == ELS_RJT_BUSY)
+			     || (els_rjt->rej.er_reason == ELS_RJT_UNAB))
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
+static void fdls_process_fdmi_reg_ack(struct fnic_iport_s *iport,
+				      struct fc_frame_header *fchdr,
+				      int rsp_type)
+{
+	struct fnic *fnic = iport->fnic;
+	uint16_t oxid;
+
+	if (!iport->fabric.fdmi_pending) {
+		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+			     "Received FDMI ack while not waiting: 0x%x\n",
+			     FNIC_STD_GET_OX_ID(fchdr));
+		return;
+	}
+
+	oxid =  FNIC_STD_GET_OX_ID(fchdr);
+
+	if ((iport->active_oxid_fdmi_rhba != oxid) &&
+		(iport->active_oxid_fdmi_rpa != oxid))  {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			"Incorrect OXID in response. oxid recvd: 0x%x, active oxids(rhba,rpa): 0x%x, 0x%x\n",
+			oxid, iport->active_oxid_fdmi_rhba, iport->active_oxid_fdmi_rpa);
+		return;
+	}
+	if (FNIC_FRAME_TYPE(oxid) == FNIC_FRAME_TYPE_FDMI_RHBA) {
+		iport->fabric.fdmi_pending &= ~FDLS_FDMI_REG_HBA_PENDING;
+		fdls_free_oxid(iport, oxid, &iport->active_oxid_fdmi_rhba);
+	} else {
+		iport->fabric.fdmi_pending &= ~FDLS_FDMI_RPA_PENDING;
+		fdls_free_oxid(iport, oxid, &iport->active_oxid_fdmi_rpa);
+	}
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
+	uint16_t oxid;
+
+	s_id = ntoh24(FNIC_STD_GET_S_ID(fchdr));
+
+	if (!(s_id != FC_FID_MGMT_SERV)) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			     "Received abts rsp with invalid SID: 0x%x. Dropping frame",
+			     s_id);
+		return;
+	}
+
+	oxid =  FNIC_STD_GET_OX_ID(fchdr);
+
+	switch (FNIC_FRAME_TYPE(oxid)) {
+	case FNIC_FRAME_TYPE_FDMI_PLOGI:
+		fdls_free_oxid(iport, oxid, &iport->active_oxid_fdmi_plogi);
+		break;
+	case FNIC_FRAME_TYPE_FDMI_RHBA:
+		fdls_free_oxid(iport, oxid, &iport->active_oxid_fdmi_rhba);
+		break;
+	case FNIC_FRAME_TYPE_FDMI_RPA:
+		fdls_free_oxid(iport, oxid, &iport->active_oxid_fdmi_rpa);
+		break;
+	default:
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			"Received abts rsp with invalid oxid: 0x%x. Dropping frame",
+			oxid);
+		break;
+	}
+
+	del_timer_sync(&iport->fabric.fdmi_timer);
+	iport->fabric.fdmi_pending &= ~FDLS_FDMI_ABORT_PENDING;
+
+	fdls_send_fdmi_plogi(iport);
+}
+
 static void
 fdls_process_fabric_abts_rsp(struct fnic_iport_s *iport,
 			     struct fc_frame_header *fchdr)
@@ -4094,6 +4736,12 @@ fnic_fdls_validate_and_get_frame_type(struct fnic_iport_s *iport,
 
 	case FNIC_FRAME_TYPE_FABRIC_LOGO:
 		return FNIC_FABRIC_LOGO_RSP;
+	case FNIC_FRAME_TYPE_FDMI_PLOGI:
+		return FNIC_FDMI_PLOGI_RSP;
+	case FNIC_FRAME_TYPE_FDMI_RHBA:
+		return FNIC_FDMI_REG_HBA_RSP;
+	case FNIC_FRAME_TYPE_FDMI_RPA:
+		return FNIC_FDMI_RPA_RSP;
 	case FNIC_FRAME_TYPE_TGT_PLOGI:
 		return FNIC_TPORT_PLOGI_RSP;
 	case FNIC_FRAME_TYPE_TGT_PRLI:
@@ -4148,6 +4796,9 @@ void fnic_fdls_recv_frame(struct fnic_iport_s *iport, void *rx_frame,
 	case FNIC_FABRIC_PLOGI_RSP:
 		fdls_process_fabric_plogi_rsp(iport, fchdr);
 		break;
+	case FNIC_FDMI_PLOGI_RSP:
+		fdls_process_fdmi_plogi_rsp(iport, fchdr);
+		break;
 	case FNIC_FABRIC_RPN_RSP:
 		fdls_process_rpn_id_rsp(iport, fchdr);
 		break;
@@ -4187,6 +4838,9 @@ void fnic_fdls_recv_frame(struct fnic_iport_s *iport, void *rx_frame,
 	case FNIC_FABRIC_BLS_ABTS_RSP:
 			fdls_process_fabric_abts_rsp(iport, fchdr);
 		break;
+	case FNIC_FDMI_BLS_ABTS_RSP:
+		fdls_process_fdmi_abts_rsp(iport, fchdr);
+		break;
 	case FNIC_BLS_ABTS_REQ:
 		fdls_process_abts_req(iport, fchdr);
 		break;
@@ -4212,6 +4866,10 @@ void fnic_fdls_recv_frame(struct fnic_iport_s *iport, void *rx_frame,
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
index c2978c5c6e8f..c4f4b2fe192a 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -205,6 +205,7 @@ static inline u64 fnic_flags_and_state(struct scsi_cmnd *cmd)
 #define fnic_clear_state_flags(fnicp, st_flags)  \
 	__fnic_set_state_flags(fnicp, st_flags, 1)
 
+extern unsigned int fnic_fdmi_support;
 extern unsigned int fnic_log_level;
 extern unsigned int io_completions;
 extern struct workqueue_struct *fnic_event_queue;
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index c1c10731906f..c75716856417 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -64,6 +64,9 @@ unsigned int fnic_log_level;
 module_param(fnic_log_level, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(fnic_log_level, "bit mask of fnic logging levels");
 
+unsigned int fnic_fdmi_support = 1;
+module_param(fnic_fdmi_support, int, 0644);
+MODULE_PARM_DESC(fnic_fdmi_support, "FDMI support");
 
 unsigned int io_completions = FNIC_DFLT_IO_COMPLETIONS;
 module_param(io_completions, int, S_IRUGO|S_IWUSR);
@@ -612,6 +615,7 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	unsigned long flags;
 	int hwq;
 	char *desc, *subsys_desc;
+	int len;
 
 	/*
 	 * Allocate SCSI Host and set up association between host,
@@ -646,9 +650,17 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	fnic_stats_debugfs_init(fnic);
 
 	/* Find model name from PCIe subsys ID */
-	if (fnic_get_desc_by_devid(pdev, &desc, &subsys_desc) == 0)
+	if (fnic_get_desc_by_devid(pdev, &desc, &subsys_desc) == 0) {
 		dev_info(&fnic->pdev->dev, "Model: %s\n", subsys_desc);
-	else {
+
+		/* Update FDMI model */
+		fnic->subsys_desc_len = strlen(subsys_desc);
+		len = ARRAY_SIZE(fnic->subsys_desc);
+		if (fnic->subsys_desc_len > len)
+			fnic->subsys_desc_len = len;
+		memcpy(fnic->subsys_desc, subsys_desc, fnic->subsys_desc_len);
+		dev_info(&fnic->pdev->dev, "FDMI Model: %s\n", fnic->subsys_desc);
+	} else {
 		fnic->subsys_desc_len = 0;
 		dev_info(&fnic->pdev->dev, "Model: %s subsys_id: 0x%04x\n", "Unknown",
 				pdev->subsystem_device);
@@ -1051,6 +1063,9 @@ static void fnic_remove(struct pci_dev *pdev)
 		fnic_fcoe_evlist_free(fnic);
 	}
 
+	if ((fnic_fdmi_support == 1) && (fnic->iport.fabric.fdmi_pending > 0))
+		del_timer_sync(&fnic->iport.fabric.fdmi_timer);
+
 	/*
 	 * Log off the fabric. This stops all remote ports, dns port,
 	 * logs off the fabric. This flushes all rport, disc, lport work
-- 
2.47.0

