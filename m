Received: from rcdn-iport-4.cisco.com (rcdn-iport-4.cisco.com [173.37.86.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6952246782;
	Fri,  5 Jun 2026 23:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780703533; cv=none; b=T+SRMRV2lmq61uQdoICOFMeRn4GzMuH17oFrlIjNRjweBkC/0WptK3JISnwQiN7//tUffxBSzrRzcyqRLbK1Nr68uTLYVGY6UBON/60Nfh7fbOKQYJkeqciWRdD3kjGNP47KMDogQNKncZWBVvBAKqpA+KZQGfgNIwNHYysWmHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780703533; c=relaxed/simple;
	bh=GNJvgYBzaq6PWY8qp+RDanULZw9FPheow2n5RLvlgMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c1rxRzi7y4MSUr2z9/hKbgMMcTHnK2/2flM5JBkwS1Mhtz0LEupjDgJJ/t91fEN4qFlLY8/03IgrYoFIE5E/OS4HXgnCfhl/pxlulKCqhnmCFvXiMXbNUJzajOAgeYDTTQhqKLu+sIfANy+B6DcvDxm+Di+dl2VD7dJSnP6Mv2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=MQzcrkY9; arc=none smtp.client-ip=173.37.86.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="MQzcrkY9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=4608; q=dns/txt;
  s=iport01; t=1780703532; x=1781913132;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nhXujpexkh+hTP9O/RkE/cMjuV7B+PfguKB8fW/hgDw=;
  b=MQzcrkY998pKpnkPc3r/wZthKtT4VsBBiQXrk2mq1kAUGPfHrWY0TKCS
   rnj9ioeDQ3+tid8fSlxyzjix3IOGNK5I3Y1demME2x3gUKhI6qxq4Wwd4
   hLzrJVqGvYJyNKH6sfmuvRS+lmywNXaubcaA6Lw3t4R3Tp42DawgR1MSy
   e3l3a86MEB4+RsqtRJIU9t4BLPj0pMDancXyFn2KpnPlPBlnIiA3BWfy8
   bwvzid41IXvvl6/uuYfBj7bskQz9jqXBtoCzxLVx2mHWuptVE9qHkL6UM
   bm7CW+hUzElP8J7iI0KzSNiiEl54RMcxsA8q0EdDNDrOPdE3rSIRi+O2V
   A==;
X-CSE-ConnectionGUID: YlJ5kbLTQ6yxb0xAwL8K7w==
X-CSE-MsgGUID: QLQIeTKxQKOpLLx2mb7jQQ==
X-IPAS-Result: =?us-ascii?q?A0BCAgCrXyNq/5P/Ja1aHgEBCxIMggULgleBUkMZMJQqg?=
 =?us-ascii?q?iGeHoF+DwEBAQ9RBAEBhQYCjTMCJjQJDgECBAMCAwEBAQEBAQEBAQEBCwEBB?=
 =?us-ascii?q?QEBAQIBBwWBDhOGXIZbAgEDJwsBRhBRVhmDAoJ0A7N7gXkzgQHeQoFmAQsUA?=
 =?us-ascii?q?YE4jV10hHsnFQaBSUSBFYNogQUBTIk1BIMuhl+JfUiBHgNZLAFVEw0KCwcFg?=
 =?us-ascii?q?WYDNRIqFW4yHYEjPheBCxsHBYFKgUlqgQSFEiMfAzmBF4F8gShnaRUxOhcDC?=
 =?us-ascii?q?xgNSBEsFCMUGwQ+bgeMLhcPgjeBD4I/HgGTJ5JIgTWfWYQmoVsaM6prmQakC?=
 =?us-ascii?q?IU4gWg8gVkzGggbFYMiUxkPji0LC8hJJzI9AgcCBw4DC5NlAQE?=
IronPort-Data: A9a23:8G1bJ6Mz/BTQo4nvrR1UlsFynXyQoLVcMsEvi/4bfWQNrUokhDQEm
 GAWXWqAOq7fZmbwLtF1b4m/900CupHTn9NrTHM5pCpnJ55oRWUpJjg4wmPYZX76whjrFRo/h
 ykmQoCeaphyFTmE+kvF3oHJ9RFUzbuPSqf3FNnKMyVwQR4MYCo6gHqPocZh6mJTqYb/WV/lV
 e/a+ZWFZgf7g2Msawr41orawP9RlKWq0N8nlgRWicBj5Df2i3QTBZQDEqC9R1OQapVUBOOzW
 9HYx7i/+G7Dlz91Yj9yuu+mGqGiaue60Tmm0hK6aYD76vRxjnBaPpIACRYpQRw/ZwNlMDxG4
 I4lWZSYEW/FN0BX8QgXe0Ew/ypWZcWq9FJbSJSymZT78qHIT5fj68RqLhw1N6kkw7hmEWsW5
 dUHDGAuMQ/W0opawJrjIgVtrt4oIM+uOMYUvWttiGiBS/0nWpvEBa7N4Le03h9p2ZsIRqmYP
 ZdEL2MzM3wsYDUXUrsTIJE3hvupgnD8WzZZs1mS46Ew5gA/ySQtgeCwb4qOIILiqcN9p2Khh
 2/63HTAITYCEPiPkz+PrXCVv7qa9c/8cMdIfFGizdZqiUee7m8eEhsbUR28u/bRokyzWdh3L
 00S5zporKI3skesS7HVWhSivH+C+AYRR9dKCOA8wAaXw6HQ7kCSAW1sZjdNYd8hrMgrbSYn2
 l+Ag5XiAjkHmL+QRHSQ+beVhSm/NSgcMSkJYipsZREI/dT5u6kpgx7PR8olG6mw5vXxFSz2y
 DmMhDMjnLhVhskOv42//Fbak3evq4LPQwod+AraRCSm4xl/aYrjYJangXDf7PBdPMOCRUKAl
 GYLltLY7+0UC5yJ0iuXT40w8KqB/f2JNnjYxFVoBZRkrmzr8H+4docW6zZ7TKt0Dvs5lfbSS
 Be7kWtsCFV7ZRNGsYcfj1qNNvkX
IronPort-HdrOrdr: A9a23:YL526699Rr/f+Rcd+EBuk+ASI+orL9Y04lQ7vn2ZhyY4TiX+rb
 HLoB1173HJYVoqMk3I3OrwW5VoIkmskKKdg7NxAV7KZmCP01dAbrsSj7cKqAeOJ8SRzINg/J
 YlW7RiCdH2EFhxhdv37U2FCdo6qeP3l5xA/d2/815dCSd3dqpn8wB1TiyfEkFwWU16IKBRLu
 v72iKCzADQAUj+qa+AdwA4Y9Q=
X-Talos-CUID: =?us-ascii?q?9a23=3Ai3eDuWjueOPAEq02Xhgy9Kd7JDJuQ3n/kXTaB3O?=
 =?us-ascii?q?BV3d5QuWFYEC0qIA7jJ87?=
X-Talos-MUID: =?us-ascii?q?9a23=3AYPMPNww4t8jREoF/nkS6SH5NtvqaqJ2KMWEArbY?=
 =?us-ascii?q?WguqjLQhUK22Yhmu1e7Zyfw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.24,189,1774310400"; 
   d="scan'208";a="490578326"
Received: from rcdn-l-core-10.cisco.com ([173.37.255.147])
  by rcdn-iport-4.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 05 Jun 2026 23:51:03 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.102.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-10.cisco.com (Postfix) with ESMTPSA id 9E10818000A75;
	Fri,  5 Jun 2026 23:51:01 +0000 (GMT)
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
	jmeneghi@redhat.com,
	revers@redhat.com,
	adakopou@redhat.com,
	lduncan@suse.com,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH v3 10/13] scsi: fnic: Abort timed-out NVMe LS requests
Date: Fri,  5 Jun 2026 16:45:35 -0700
Message-ID: <20260605234538.7950-11-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20260605234538.7950-1-kartilak@cisco.com>
References: <20260605234538.7950-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-Client-TLS: ANONYMOUS;unknown [10.188.102.68];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 10.188.102.68, [10.188.102.68]
X-Outbound-Node: rcdn-l-core-10.cisco.com

Add an FDLS helper that sends ABTS frames for outstanding NVMe LS
requests.

Use the active LS request OXID when building the ABTS frame, send it
through the FCoE transmit path, and call it from LS timeout and abort
handling.

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
Co-developed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/fnic/fdls_disc.c | 38 +++++++++++++++++++++++++++++++++++
 drivers/scsi/fnic/fnic_fdls.h |  2 ++
 drivers/scsi/fnic/fnic_nvme.c | 16 +++++++++++++++
 3 files changed, 56 insertions(+)

diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
index 5b4087f1247a..a164e9d2816b 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -654,6 +654,44 @@ fdls_send_logo_resp(struct fnic_iport_s *iport,
 	fnic_send_fcoe_frame(iport, frame, frame_size);
 }
 
+int fdls_send_ls_req_abts(struct fnic_iport_s *iport,
+		struct fnic_tport_s *tport, unsigned int oxid)
+{
+	uint8_t *frame;
+	uint8_t s_id[3];
+	uint8_t d_id[3];
+	struct fnic *fnic = iport->fnic;
+	struct fc_frame_header *pls_req_abts;
+	uint16_t frame_size = FNIC_ETH_FCOE_HDRS_OFFSET +
+			sizeof(struct fc_frame_header);
+
+	frame = fdls_alloc_frame(iport);
+	if (frame == NULL) {
+		FNIC_FCS_DBG(KERN_ERR, fnic,
+				"Failed to allocate frame to send ls req ABTS");
+		return -ENOMEM;
+	}
+
+	pls_req_abts = (struct fc_frame_header *) (frame +
+			FNIC_ETH_FCOE_HDRS_OFFSET);
+	fdls_init_fabric_abts_frame(frame, iport);
+
+	hton24(s_id, iport->fcid);
+	hton24(d_id, tport->fcid);
+	FNIC_STD_SET_S_ID(*pls_req_abts, s_id);
+	FNIC_STD_SET_D_ID(*pls_req_abts, d_id);
+
+	FNIC_STD_SET_OX_ID(*pls_req_abts, oxid);
+
+	FNIC_FCS_DBG(KERN_INFO, fnic,
+		"iport 0x%x: tport: 0x%x FDLS sending ls req abts with oxid: 0x%x",
+		iport->fcid, tport->fcid, oxid);
+
+	fnic_send_fcoe_frame(iport, frame, frame_size);
+	return 0;
+}
+
+
 void
 fdls_send_tport_abts(struct fnic_iport_s *iport,
 					 struct fnic_tport_s *tport)
diff --git a/drivers/scsi/fnic/fnic_fdls.h b/drivers/scsi/fnic/fnic_fdls.h
index 0a68d0fb11b1..ce4b3aae77e3 100644
--- a/drivers/scsi/fnic/fnic_fdls.h
+++ b/drivers/scsi/fnic/fnic_fdls.h
@@ -407,6 +407,8 @@ uint16_t fdls_alloc_oxid(struct fnic_iport_s *iport, int oxid_frame_type,
 	uint16_t *active_oxid);
 void fdls_free_oxid(struct fnic_iport_s *iport,
 	uint16_t oxid, uint16_t *active_oxid);
+int fdls_send_ls_req_abts(struct fnic_iport_s *iport,
+		struct fnic_tport_s *tport, unsigned int oxid);
 void fdls_tgt_logout(struct fnic_iport_s *iport,
 		     struct fnic_tport_s *tport);
 void fnic_del_fabric_timer_sync(struct fnic *fnic);
diff --git a/drivers/scsi/fnic/fnic_nvme.c b/drivers/scsi/fnic/fnic_nvme.c
index afbf6c1abf4a..7274ee53596a 100644
--- a/drivers/scsi/fnic/fnic_nvme.c
+++ b/drivers/scsi/fnic/fnic_nvme.c
@@ -1231,6 +1231,7 @@ void nvfnic_ls_req_timeout(struct timer_list *t)
 	struct fnic_iport_s *iport = &fnic->iport;
 	struct fnic_tport_s *tport = (struct fnic_tport_s *) nvfnic_ls_req->tport;
 	uint16_t oxid = nvfnic_ls_req->oxid;
+	int timeout;
 
 	FNIC_NVME_DBG(KERN_INFO, fnic,
 		      "tport: 0x%x lsreq: 0x%x state: %d timeout\n",
@@ -1264,6 +1265,19 @@ void nvfnic_ls_req_timeout(struct timer_list *t)
 		FNIC_NVME_DBG(KERN_ERR, fnic,
 			      "tport: 0x%x lsreq: 0x%x sending abort\n",
 			      tport->fcid, nvfnic_ls_req->oxid);
+		nvfnic_ls_req->state = FNIC_LS_REQ_CMD_ABTS_PENDING;
+		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
+
+		if (fdls_send_ls_req_abts(iport, tport, nvfnic_ls_req->oxid) == 0) {
+			timeout = FNIC_LS_REQ_TMO_MSECS(ls_req->timeout);
+			mod_timer(&nvfnic_ls_req->ls_req_timer,
+				  round_jiffies(jiffies + msecs_to_jiffies(timeout)));
+			return;
+		}
+		FNIC_NVME_DBG(KERN_ERR, fnic,
+			      "tport: 0x%x lsreq: 0x%x cannot send abort\n",
+			      tport->fcid, oxid);
+		spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
 	}
 
 	if (ls_req->private == NULL) {
@@ -1560,6 +1574,8 @@ void nvfnic_ls_req_abort(struct nvme_fc_local_port *lport,
 	mod_timer(&nvfnic_ls_req->ls_req_timer,
 		  round_jiffies(jiffies + msecs_to_jiffies(timeout)));
 	spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
+
+	fdls_send_ls_req_abts(iport, tport, nvfnic_ls_req->oxid);
 }
 
 bool nvfnic_queue_abort_io_req(struct fnic *fnic, int tag,
-- 
2.47.1

