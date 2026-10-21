Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.148.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792578227;
	b=2BEpy+14u+A/hpHA7CiQcgLuhYFJ70PhteOeoPOoX/POPaDNcK9BPZ4D/eoRWO1d9pLl
	 /BzKryJYFG1qqj4z4loYUvuoEOkKeXBR8Z7QbEjgYOBZcY13MCxD+R3WEX8g7FP26RY1K
	 YyI5VtbOvIMGLdXz0zc7PDGJ1LExY6Gbl9r3FCZGdwV22i/9qfpXWCocYppyw9VHx0vRy
	 E61ualhzeMRYd4kS9ldb800SSGp7FtTYu8ymD7k0MsMLjc7Dyr+B9xoDY1EUGPDS9aotN
	 1fKjbCkLkQhasQGKUNEIzlLdgRlosgyg+ppuakpSQjyVXJJ/pBtj+95h5xbQti3qWgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792578227;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version;
	bh=+mE3hGj5Tx8TxBYnykReuc927A8F7l2tbKHTsn71LLw=;
	b=NFHbYYzkXHMs2nskdNHnX93GPh+aEjLSIsUvwmN63enF4qB8Y2ZiaJ468jjb25mGnIxd
	 D/k4nq1tH6Yrd6uYd6dLQU1FUIe8g1bztEFgQNzQPzPPUw15gUq8ZV2lHAtNrJczkC+G4
	 qnzuMfwmpfY5wjpJfaVC10GmoGu7jnsvs5PhLmEMgqtdxlR4VAu3EU0CrEHXbevYAIQRw
	 sh3/xn1GPm6qncNbsQhQbKQ9jYIjYD8CkX4S60ly9y3/FIdVEIojfalvMiK4C+o7e5Yu+
	 IDqbq/yfq/HqmiHeRi39vepiKSe4qY/xKbwKzQvih4uOGfCmV44uQIHWuB/hqLbg76A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=marvell.com;
	spf=pass smtp.mailfrom=marvell.com;
	dkim=pass header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b="W6s/F3Um";
	arc=none smtp.remote-ip=67.231.148.174
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0974E606A319
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 10:23:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0974E606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=W6s/F3Um
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LA5ubs2174228;
	Wed, 21 Oct 2026 03:23:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=+
	mE3hGj5Tx8TxBYnykReuc927A8F7l2tbKHTsn71LLw=; b=W6s/F3UmxIBJZV6Zu
	GITdcfpMZpH+3taW82H2i+cukUYWkeAeuu3p/wYc3eVP+hcu2upg4ugrVEs6JT03
	mO8Og41mYEIlvwLNA7G10A8pDkVyADujMrVgbRfSG3ksRVD1MwvTMQP+9PU/G1Pg
	3udVDk/Vvg0sYmw5nChWJI6QnuPNq4On/JaP+DyYt9qAg2ASeqs8jxuQ8aQkkU7W
	hQxtIFZoY1XLKoo2tl/5HKrMDpWVHOJPk7+QwgFCSqHxQKuhDpJ2czjbeNgsQHxw
	sAUlQ1hEMqSr1YqSb2opS9n/fODUflqnXLARU8X5bydkdsIKEc8sCND2I/eNVVEG
	x1Q3Q==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4hemfbspmu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 Oct 2026 03:23:43 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 21 Oct 2026 03:23:42 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 21 Oct 2026 03:23:42 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id CCBB53F709E;
	Wed, 21 Oct 2026 03:23:40 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <emilne@redhat.com>, <jmeneghi@redhat.com>, <hare@suse.com>
Subject: [PATCH 02/14] scsi: qla2xxx: Update few AENs for 29xx handling
Date: Wed, 21 Oct 2026 15:52:58 +0530
Message-ID: <20261021102310.3854868-3-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20261021102310.3854868-1-njavali@marvell.com>
References: <20261021102310.3854868-1-njavali@marvell.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=AvJ7T+9P c=1 sm=1 tr=0 ts=6ad892af cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=M5GUcnROAAAA:8 a=9wQDHOz2xpCgzWt2mZsA:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: pI4DV7550UZCumi0j9HgOcRubtLvK3ET
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA0MSBTYWx0ZWRfXzdPUq0quouHT
 kZWIflhvUvkq5hlr3fJBJnhJ9AoO/9epEK7igkYZ9lsOBc1a57luQmxz6CXu7C0kf2cvKdiJN+7
 pn5jXyjStNUVgkrSc0oQdskTVN+LN84=
X-Proofpoint-GUID: pI4DV7550UZCumi0j9HgOcRubtLvK3ET
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA0MSBTYWx0ZWRfX5jN7jWXBC+Gf
 Pvtl2mqGRwbUiceYH2q0jyVItgvMbcQ43gAvG2tQ7bd/V2jocSqmFPA8VuDvyEKnr7DxjCk+IbJ
 QGT+dEqvKsX5jUKfzpTv+ZIM2hUlv1lHqRisDtu4cslqB6hh9FdkMgABj3NJHoeKdz87g3fAAMO
 1+SX8SU89GuICESXyJbvyym7SeYoz0cnIIJvSwn5ruaEFc+f47UUd3KOxobuc+9zs9m8flCQhK3
 +ZkA41EfsHnZnENyU+/rx1oqTRq8loynERwBrzr4lqxx1a+Oe44HGpThPusbg9yLzGNvPn9QIVF
 NIcDmCTeCenHV1VYCB3kc3KpecLs+tO79NcGiviALFnPcM890KvDLYrFOVbJXq59UGMtDT//s80
 z04NKqCv7gvRvb+qpFisCmGjEA2/dKt4C2agTDPRqIfKgqCIFqQKhHdqf2MCYHeX0arEcvx/xIf
 hdHpT1bFhyGfoG+vXJw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-21_03,2026-10-19_02,2025-10-01_01

Handle QLA29XX adapters like the 27xx/28xx generation across several
async event paths in qla2x00_async_event():

- MBA_SYSTEM_ERR: capture and log the extended mailbox4-7 words, and
  trigger the MPI firmware dump when mailbox7 BIT_8 is set.
- MBA_LOOP_UP: report FEC-enabled status on link up.
- MBA_IDC_AEN: process the 8200 heartbeat/IDC AEN via
  qla27xx_handle_8200_aen().
- MBA_DPORT_DIAGNOSTICS: decode and log the D-Port diagnostics result.
- MBA_TEMPERATURE_ALERT: report laser information.

29xx is FWI2-capable and uses the device_reg_24xx mailbox layout, and
qla29xx_isp_ops already wires fw_dump/mpi_fw_dump to the 27xx helpers,
so the same handling applies.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_isr.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 63b70d4abbf0..7bae26d4404c 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1443,7 +1443,7 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 		vha->hw_err_cnt++;
 
 		if (IS_QLA81XX(ha) || IS_QLA83XX(ha) ||
-		    IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+		    IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
 			u16 m[4];
 
 			m[0] = rd_reg_word(&reg24->mailbox4);
@@ -1459,7 +1459,7 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 			    "ISP System Error - mbx1=%xh mbx2=%xh mbx3=%xh.\n ",
 			    mb[1], mb[2], mb[3]);
 
-		if ((IS_QLA27XX(ha) || IS_QLA28XX(ha)) &&
+		if ((IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha)) &&
 		    rd_reg_word(&reg24->mailbox7) & BIT_8)
 			ha->isp_ops->mpi_fw_dump(vha, 1);
 		ha->isp_ops->fw_dump(vha);
@@ -1554,7 +1554,8 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 		    "LOOP UP detected (%s Gbps).\n",
 		    qla2x00_get_link_speed_str(ha, ha->link_data_rate));
 
-		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) ||
+		    IS_QLA29XX(ha)) {
 			if (mb[2] & BIT_0)
 				ql_log(ql_log_info, vha, 0x11a0,
 				    "FEC=enabled (link up).\n");
@@ -1998,7 +1999,7 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 		break;
 
 	case MBA_IDC_AEN:
-		if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+		if (IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
 			vha->hw_err_cnt++;
 			qla27xx_handle_8200_aen(vha, mb);
 		} else if (IS_QLA83XX(ha)) {
@@ -2022,7 +2023,8 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 		    "D-Port Diagnostics: %04x %04x %04x %04x\n",
 		    mb[0], mb[1], mb[2], mb[3]);
 		memcpy(vha->dport_data, mb, sizeof(vha->dport_data));
-		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) ||
+		    IS_QLA29XX(ha)) {
 			static char *results[] = {
 			    "start", "done(pass)", "done(error)", "undefined" };
 			static char *types[] = {
@@ -2050,7 +2052,7 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 		break;
 
 	case MBA_TEMPERATURE_ALERT:
-		if (IS_QLA27XX(ha) || IS_QLA28XX(ha))
+		if (IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha))
 			display_Laser_info(vha, mb[1], mb[2], mb[3]);
 		ql_dbg(ql_dbg_async, vha, 0x505e,
 		    "TEMPERATURE ALERT: %04x %04x %04x\n", mb[1], mb[2], mb[3]);
-- 
2.52.0

