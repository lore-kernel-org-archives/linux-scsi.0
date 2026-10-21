Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.156.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792578241;
	b=fewySUz4MEhCQTudN+k5JRIdx/FCiLzraUsAoHrNQFNB+UWntaD1BVbj1hsnSy++bYH9
	 O5ghpRf5OM+f4oE0HYOLfbgPVe0SuQ3Iw5WzbKVi6WFv/M+sF/5b1tKHOg+qIgfBUrRXT
	 hDnaW8lQ3gohXzqYKp9defPmIe+WvVQDKEImNaQw2qc1DcpuxZLOZvHQkdZupgDQPk1wv
	 I6VfojSwj1kc3DVC9nTaoNbxlMJ5Jkd1+Iq1hzT5ruux/lUPmiYyWXgEY0RaWxq03cBL1
	 cFtwjAse3YaA6TOiy1jpNmQxMbedC513W7ewJhmAflY/m5EjqV2OBT56rIUHJph+4ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792578241;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version;
	bh=rzBpyuyt5fSKT92SZgR2q6L9ygBy+ekAHAz3KF9N+18=;
	b=dENuyu/AyySSwwkHbnaVmZ3R9FlzMkPCKL5Ad8HzMmO/yjFvgaYrBkCUrxfnNKfZ/LL4
	 rVUIeJ6E3RkWSJRp6TFcw56YveBovvVx8yfJaatO77uC20jA/WTAZoSP2V+8vOcpbSfyO
	 S6p0GjBRVeV1jK+Mfdc0T/xm3OOI52QciEIjo8p0+hUWh2Bvk+FjiWPfzvO0e/u3ajKY2
	 MyNloBJCIFuELedUooSNaayYBK7rbwHUq52fLAgKrLnGu+jhkDAiJSLbI+CKsnM3Lc8Ks
	 w/IZ1SW1errOZA1mIzz6FCPDQu1F7oFgCS3DyKi2cK50A0g7jsiyB+v4mdQLIHtSHPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=marvell.com;
	spf=pass smtp.mailfrom=marvell.com;
	dkim=pass header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=XW2wTcpe;
	arc=none smtp.remote-ip=67.231.156.173
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD7F606A335
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 10:24:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3CD7F606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=XW2wTcpe
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LA5dmj1763734;
	Wed, 21 Oct 2026 03:23:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=r
	zBpyuyt5fSKT92SZgR2q6L9ygBy+ekAHAz3KF9N+18=; b=XW2wTcpeWf81Ag/gl
	p8FPOgyfb20Z6IshuTpraV6DQuGBd2X5M/5Na7VrsuF3+kDR7yctnaZ5s/ww5U+b
	FrlxG4gPq59yeFL5PJgABb3R61kR2lvJ2jUm0uEpIovrepboPu6Lo9FXOqIM9NCZ
	6iJiOFrFEw2vc/bpVf3Xwj9p0lh+QftosYhgI60cbknSXHZh0GgjbuI/o9H6srg8
	X5ycg2oBDUYjqWlwPIJuYHbnfLzDj1P2Nd+7Ah/BIVnq8MXMYAGhzT/bZpgYo4s1
	PqL4KpnwmXPQmYLMuTHGYrM/MgbOkkFTQZQkJYIMyUJitBydE+vumikzXPOES8RY
	bz87A==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4hepyxh2kd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 Oct 2026 03:23:58 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 21 Oct 2026 03:23:57 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 21 Oct 2026 03:23:57 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 881043F709E;
	Wed, 21 Oct 2026 03:23:55 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <emilne@redhat.com>, <jmeneghi@redhat.com>, <hare@suse.com>
Subject: [PATCH 08/14] scsi: qla2xxx: Add validation check for base vport index during delete
Date: Wed, 21 Oct 2026 15:53:04 +0530
Message-ID: <20261021102310.3854868-9-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: lb7JaytATn7uqSKGz0D2SWIjV6FHG1ye
X-Proofpoint-GUID: lb7JaytATn7uqSKGz0D2SWIjV6FHG1ye
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA0MSBTYWx0ZWRfXwOAUpduSvo8c
 b9gqkutc03g6I5b2kZ2QdbjdaRBQVbv3hr1dSXFzih81GYdXk97eZY25PVZ4VNJ0pnzCnL0t5md
 jDN+JY/rxojop2kEU4c4YY4YAwTvyX8=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA0MSBTYWx0ZWRfXzl+Rhot2Gapp
 3A3ssd2ktmoiPvyAAomtjIZo8RmqQ73dE+kBgQxOx6L18B6Mm71LsW6eeIDYPnZwlWcvMahJzmG
 R2SQUnxUwuArAgTuXxlEG0Sbpb6zsXDO6aVGa8Xhxc5DUteiVNBmEhsY7QWZv8IWAvPzfvE6mUl
 cnTm9ZOd8wOYAa30HKBKgvopupQwuq+bhHQdQS8MCciAFJBGqfSVOeY8fQlFHmRB3BQ4fFPo5D4
 6w4GcffEwcDovU+xPpc0HODIoOt/OgJLqkNB40Ec4W37gD5k0zOiZcMbuXuPnri/K3TKgLJ2ltJ
 EAhM56pPzkW43oaFpmfykNd7rYKDB11L9+b51o7EIGxlgkhJae+8of7+jhhZrJQ/sF7jBmvnbHn
 becJYeJU4iTut9cSo2yNEPGEpsVgJH7C8ZQznWlQzi+fTXGjyds0vnbtRY5s/INgcBh3QI8ugoa
 NnzwAubUSyRIUjjukVw==
X-Authority-Analysis: v=2.4 cv=Jq9kP84C c=1 sm=1 tr=0 ts=6ad892be cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=sNYpLvrkyEg6eucKXqMA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-21_03,2026-10-19_02,2025-10-01_01

From: Manish Rangankar <mrangankar@marvell.com>

Add a guard in qla24xx_vport_delete() to prevent deleting a vport with an
invalid or zero vp_idx. If vp_idx is zero (the base vport), log a fatal
message and return early instead of proceeding with deletion logic. This
avoids unexpected behavior during vport teardown and ensures proper error
handling.

    [ 4268.547235] Call Trace:
    [ 4268.547238]  <TASK>
    [ 4268.547242]  ? srso_alias_return_thunk+0x5/0xfbef5
    [ 4268.547256]  ? show_trace_log_lvl+0x26e/0x2df
    [ 4268.547270]  ? show_trace_log_lvl+0x26e/0x2df
    [ 4268.547279]  ? qla2x00_do_dpc_all_vps+0xc2/0xf0 [qla2xxx]
    [ 4268.547305]  ? __die_body.cold+0x8/0xd
    [ 4268.547310]  ? die_addr+0x39/0x60
    [ 4268.547322]  ? exc_general_protection+0x1ec/0x420
    [ 4268.547336]  ? asm_exc_general_protection+0x22/0x30
    [ 4268.547347]  ? qla2x00_do_dpc_all_vps+0xc2/0xf0 [qla2xxx]
    [ 4268.547369]  ? qla2x00_do_dpc+0x264/0x760 [qla2xxx]
    [ 4268.547391]  ? qla2xxx_pci_error_detected+0x190/0x190 [qla2xxx]
    [ 4268.547411]  ? kthread+0xe0/0x100
    [ 4268.547420]  ? __pfx_kthread+0x10/0x10
    [ 4268.547427]  ? ret_from_fork+0x2c/0x50
    [ 4268.547442]  </TASK>

Fixes: feafb7b1714c ("[SCSI] qla2xxx: Fix vport delete issues")
Cc: stable@vger.kernel.org
Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_attr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index a4ca22024ede..e6fc47c3f87f 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -3276,6 +3276,12 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
 	struct qla_hw_data *ha = vha->hw;
 	uint16_t id = vha->vp_idx;
 
+	if (!vha->vp_idx) {
+		ql_log(ql_log_fatal, vha, 0x700f,
+		       "failed to delete Vport idx [%d]\n", vha->vp_idx);
+		return 0;
+	}
+
 	set_bit(VPORT_DELETE, &vha->dpc_flags);
 
 	while (test_bit(LOOP_RESYNC_ACTIVE, &vha->dpc_flags))
-- 
2.52.0

