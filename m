Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.156.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792750586;
	b=uyNRc7AY+KOuq7pIdDZhw48aTscv2qL68DmhWui1u0xspDl1sJL2jsVJa66FPMi+XkTM
	 ARBlPxqElAVD65f6UI4jBObY3fwO9Qic8pgNpwhiIED98uHcdhJOh6IT32eXsJcHVR2f8
	 rQ1FmC1x/DGUhm+zlwmc9Mo9V64kNmUHaUIhNPqMcP99K24BcLBkPlK8D0ufwBy1rZUsf
	 r0tkZtz8oEulXqFQT5lpny7Bzlar/aUcZw28wzCkAox2jgAEul0p14XRFOs648RRQ8meY
	 8lKNHXfnsvAcXni+snHifMNJ4j4c0yrgimeZi1P+wYEDiJ4kH5flnG4Pgf4/AYsWkGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792750586;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version;
	bh=zgRH3rlMCdmu9Gd3Usij2nqa9yMM3IRluppIu7hvJro=;
	b=2ncTqTXw0Soeke4Fc4jCrjMMl1dsvekcDOboRzJOR/edc5a622vXCqm6iqsnr7Q8g3RM
	 A9uFAslrgObxz1VcPh6NTJK9Vs0phtTm8ZWNPIlhrnbNNaNQRKVhj0ntI8NllQIzKqdSj
	 rz4lEXKalsSihMIeQLhUcOiJZKW4g8Q0jMvLhrUCyRNzfhv8TgwyYdUpp+NCn7MkQPLk9
	 zpDdGLN0vkfbufbBANbTuYhSivWiRcW84x0qdLYgt063jr/ZlH2lUV1viS8Ql91w0EnXF
	 N9ZmrskpeINvh1AHtxqpWaK1UEUxmBETwNE+bmq+0HpMU5P7uQ0yPbxWbijOv/L33Ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=marvell.com;
	spf=pass smtp.mailfrom=marvell.com;
	dkim=pass header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=eybrM+ua;
	arc=none smtp.remote-ip=67.231.156.173
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792F4606A31E
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 10:16:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 792F4606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=eybrM+ua
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69NADe9a3273915;
	Fri, 23 Oct 2026 03:16:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=z
	gRH3rlMCdmu9Gd3Usij2nqa9yMM3IRluppIu7hvJro=; b=eybrM+ua3lavI9l5u
	RZqLkzQFcjd9Bm2ZcrgUrjrK+rSEtSIveuiwThfpxmsX2Coe+WvG7mkP1y0j3Py2
	ybTRSV497xBMcXuwiXPiIYAZa3W80uSnW604g8G/VBmkA3+FGTrV98hg7A78fwbQ
	4tBSiCe7cP4Db8/CdTt6B+DqV6+soPte8aJGGrDIVVayexLcVQUB4aLeKZXMFfZ7
	fYluLr6NekWGH5Ef3eioSWQ65VmYLG9bB3sJTixs8023DFTErtIVBBv3a3hLaK7X
	HJPqm2K23Cs/vU9iO++RuvjtkgKlWYcsScfSTGZ4Gqw/1YmZ5YMWuiXjvHXOWBe8
	eARng==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4hf94b9942-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 Oct 2026 03:16:22 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 23 Oct 2026 03:16:22 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 23 Oct 2026 03:16:22 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id D65453F7069;
	Fri, 23 Oct 2026 03:16:19 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <emilne@redhat.com>, <jmeneghi@redhat.com>, <hare@suse.com>
Subject: [PATCH v2 04/13] scsi: qla2xxx: Wait for session deletion before full-login LIP
Date: Fri, 23 Oct 2026 15:45:51 +0530
Message-ID: <20261023101600.1431179-5-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20261023101600.1431179-1-njavali@marvell.com>
References: <20261023101600.1431179-1-njavali@marvell.com>
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
X-Proofpoint-GUID: Wb_MlmUJU-I09y8n9UCFy1vjKzCcQjUt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAzOSBTYWx0ZWRfX4yNQyY/D8Sao
 9GLeRspjUEK+ZgcTGf5cpyNxTjsDC1yLcVIVqWrR+hmRSBDy3MDQiMPRlawSEfh1eEG3IpMDz7Z
 gV3Ob1PuBqVOf2PdgyTCpcJFr1UZ0sdGndd3EgQW3QloGpuUVVgNsVh7T4DSmzHS3iQAjMEkJxC
 2PkWuMoYriTvvosmPM3GTPS6Jy7D1iRvUvRmwjz43RLYwog6e3NSfRWKkq/kQDE7JKpNVdtjHh0
 Vj2e59H3O/ycLsXCckJIgLtM3hKF72XrXDlICj4Sd1i+qd/3CdheNrXSOh6LzOevru8Z9OmBwwM
 7TkdSzw7OIjFwWZDIW6dbb/QPS5GRS4VPIJcqXA/djd/qcWerq0zQiC+dcYigGsm/Ef46WNrxck
 2zIFZzcZmTxfViq/kLR8oP2MFEFOZnGFlypyMK9PSGuYNQUk+hN4zhAWaGRPjHTJkG0Gwso0ZMK
 HchM/Bc+gRgrxwUcf/w==
X-Proofpoint-ORIG-GUID: Wb_MlmUJU-I09y8n9UCFy1vjKzCcQjUt
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAzOSBTYWx0ZWRfX98sDZPMdNm87
 Jz/bwlcjrmP55BoG2RckqquddfTJFC9HENuawq/fNZIEilGlyMsH6+aujwTuhuGVsIei3Fv1pDo
 wINMsnYSOpUO/PpvPg/RiWcQrtrMI2g=
X-Authority-Analysis: v=2.4 cv=OrDaWC/t c=1 sm=1 tr=0 ts=6adb33f6 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=MtCq7Vfy4UkbfJX3u6UA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_03,2026-10-21_02,2025-10-01_01

From: Manish Rangankar <mrangankar@marvell.com>

In qla2x00_loop_reset(), the LIP_FULL_LOGIN path called
qla2x00_mark_all_devices_lost() and immediately fired the firmware
full-login mailbox. In N2N topology, when the local port has the
larger WWPN, an fcport can still be in DELETE_PEND and not yet pruned
from the list when the FW LIP completes and RIDA processing kicks in,
leaving the driver to act on a stale fcport instance.

Replace mark_all_devices_lost() with qla2x00_wait_for_sess_deletion(),
which marks the fcports lost, waits for fcport_count to drain, and
flushes the host workqueue. That guarantees fcport workers have run to
completion and the stale entries are gone before FW is asked to
re-LIP, eliminating the race during BUS reset.

Cc: stable@vger.kernel.org
Fixes: 3c75ad1d87c7 ("scsi: qla2xxx: Remove defer flag to indicate immeadiate port loss")
Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index c0efdbff5da7..0e5e672e81ee 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1752,7 +1752,7 @@ qla2x00_loop_reset(scsi_qla_host_t *vha)
 	if (ha->flags.enable_lip_full_login && !IS_CNA_CAPABLE(ha)) {
 		atomic_set(&vha->loop_state, LOOP_DOWN);
 		atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
-		qla2x00_mark_all_devices_lost(vha);
+		qla2x00_wait_for_sess_deletion(vha);
 		ret = qla2x00_full_login_lip(vha);
 		if (ret != QLA_SUCCESS) {
 			ql_dbg(ql_dbg_taskm, vha, 0x802d,
-- 
2.52.0

