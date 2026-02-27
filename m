Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9277844BCA4;
	Fri, 27 Feb 2026 16:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772208546; cv=none; b=UmzQdzKUkdIiiMUjzn2vTgqd/Ob/HzQ8Jy4vCULLr+E2+M3b1PGOejfZ3MRrCGKXo0WHRasJCOgDHzipTnrnhCHk8jjFzmYw4P9z0rW3klDnkhKF7dOcUaJs6f19F0H648ZtKNBylqISlxf43VSCycMrZqcV/++QYHUy1Is8CNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772208546; c=relaxed/simple;
	bh=fo5cKDrlESNKGVRvBja+N0oEZ3SKTHQgkvdRBOAXSVA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hdZy/aCKbAtO8jlhv6+Phqpkoyo7oYhgx8b0bekEeEnyOZIBVYF1c+2UpXpDFWH/VgaMEW4VTDosTOJ7F3SoXAnpGYJ6Aogk9mGfxKGTUT9OU+Atlu96lRfEX5z+10/j2FSgd5p3BJt7Jt03UFN+a33a4uoqZT0ehcARTq9nUNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Y/gfsV1p; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Y/gfsV1p"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61REa6QD4010533;
	Fri, 27 Feb 2026 16:08:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=sSGdJ3pOZQP
	ubDXObwwGVEtV+Urb+RJu0cNiZ6+wYrE=; b=Y/gfsV1pD6CnaznIXR4XY1esL8u
	5fc+yfCa6VA+yBTlz0mQ9rUTmguVsodw7BB7RZfAH7qVfhI4LKw7DJJYZAT2LGdh
	nA7eP0eSyVeC/17osB7vrakxLtnqdZTekBM4frePycn0W/t0NKA37OyDyhFWhLQ6
	BcMXo8a08PUcn9mO/f+pyJzNVUAIZ9TOGg4//jhc2BhaNzKNd71wJcxncWYEirBj
	LmQ0Nq5Kzv+QWRbI9EyqDMZocXoq0lTyIUOdtvTp6n5PACI8Czu9KlKoZdRjhAMa
	bwZYt8gGEB15ABKM6/cfvgeNOk7tzcXMoEMpDHeQ9u4hWwFR7ih7psTFD8g==
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ck43ra719-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Feb 2026 16:08:56 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA05.qualcomm.com [127.0.0.1])
	by NALASPPMTA05.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTP id 61RG6rHO007485;
	Fri, 27 Feb 2026 16:08:55 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 4cjx30h5xj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Feb 2026 16:08:55 +0000
Received: from NALASPPMTA05.qualcomm.com (NALASPPMTA05.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 61RG8tnD011750;
	Fri, 27 Feb 2026 16:08:55 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 61RG8tVu011749
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Feb 2026 16:08:55 +0000
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id 67D285A0; Fri, 27 Feb 2026 08:08:55 -0800 (PST)
From: Can Guo <can.guo@oss.qualcomm.com>
To: avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 05/11] scsi: ufs: core: Add debugfs entries for TX Equalization params
Date: Fri, 27 Feb 2026 08:08:02 -0800
Message-Id: <20260227160809.2620598-6-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260227160809.2620598-1-can.guo@oss.qualcomm.com>
References: <20260227160809.2620598-1-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: rSUXm-A69WoZxklmUnMYwXocMDTBKgfZ
X-Proofpoint-GUID: rSUXm-A69WoZxklmUnMYwXocMDTBKgfZ
X-Authority-Analysis: v=2.4 cv=DOqCIiNb c=1 sm=1 tr=0 ts=69a1c198 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=eoimf2acIAo5FJnRuUoq:22 a=EUspDBNiAAAA:8 a=mp4iZCQd9jxi9ekHby0A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI3MDE0NCBTYWx0ZWRfX9lSmW8aovYkp
 lhvb2z3Urb+qrtXy62k0b1foms/33ae5YakDyn5KbD4LzqP27KPirOsIaFI6y18t4qJhw7orBYb
 9wXkMbqGmCB1eINreQfGqIa58JVUxUmS353MrXiMXSOHCjbFr1vaco9SYto0pI3g5tYuWPnBAdo
 HPFd4yT8UjTSrz2FnHV4Z/EmIymardrcyDUhyGaVlieTv5BJ1fLECevF+Lufn/KZMG+ZMkdt0Rx
 +vgusPOfxLVKdMQtOKQ+k93rEXIS2tKzIqWqXYEFt1lPGlKrh3IY9OLuRMsx9vjIjCw4cp9eVhl
 /IYaAoXqKpeaJn/7Oh01T9bmg8kKnrzqvtLQU5OzmGqjfve3SESTYLZ1erjCf5Jwh8FhO8qwJfB
 fNvFE4ETiOLMnoG2e90oWgc/mv6FJXOM69PUm1p1fF9ARaJKToFUAdfSJALIgroQ9AAMx0dAKMu
 a7cB8+pAdt1JK+/yJEQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-27_03,2026-02-27_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 malwarescore=0 adultscore=0 priorityscore=1501
 clxscore=1011 suspectscore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2602270144

Add debugfs support for UFS TX Equalization feature to enable runtime
inspection of TX Equalization parameters. This provides visibility into
both host and device TX Equalization settings as well as TX Equalization
Training records for debugging and optimization purposes.

Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
---
 drivers/ufs/core/ufs-debugfs.c | 206 +++++++++++++++++++++++++++++++++
 include/ufs/ufshcd.h           |   2 +
 2 files changed, 208 insertions(+)

diff --git a/drivers/ufs/core/ufs-debugfs.c b/drivers/ufs/core/ufs-debugfs.c
index e3baed6c70bd..53deb8b2d1ea 100644
--- a/drivers/ufs/core/ufs-debugfs.c
+++ b/drivers/ufs/core/ufs-debugfs.c
@@ -209,6 +209,203 @@ static const struct ufs_debugfs_attr ufs_attrs[] = {
 	{ }
 };
 
+static int tx_eq_gear_get(void *data, u64 *val)
+{
+	struct ufs_hba *hba = data;
+
+	*val = (u64)hba->debugfs_tx_eq_gear;
+	return 0;
+}
+
+static int tx_eq_gear_set(void *data, u64 val)
+{
+	struct ufs_hba *hba = data;
+
+	if (val < UFS_HS_G1 || val >= UFS_HS_GEAR_MAX)
+		return -EINVAL;
+
+	hba->debugfs_tx_eq_gear = (u32)val;
+	return 0;
+}
+
+DEFINE_DEBUGFS_ATTRIBUTE(tx_eq_gear_fops, tx_eq_gear_get, tx_eq_gear_set, "%#llx\n");
+
+static int ufs_tx_eq_params_show(struct seq_file *s, void *data)
+{
+	struct ufs_debugfs_attr *attr = s->private;
+	struct ufs_hba *hba = hba_from_file(s->file);
+	struct ufshcd_tx_eq_settings *settings;
+	struct ufshcd_tx_eq_params *params;
+	u32 gear = hba->debugfs_tx_eq_gear;
+	u32 rate = hba->pwr_info.hs_rate;
+	u32 num_lanes;
+	int lane;
+
+	if (!ufshcd_is_tx_eq_supported(hba))
+		return -EOPNOTSUPP;
+
+	if (gear < UFS_HS_G1 || gear >= UFS_HS_GEAR_MAX) {
+		seq_printf(s, "Invalid gear selected: %u\n", gear);
+		return 0;
+	}
+
+	params = &hba->tx_eq_params[gear - 1];
+	if (!params->is_valid) {
+		seq_printf(s, "TX EQ params are invalid for HS-G%u, Rate-%s\n",
+			   gear, UFS_HS_RATE_STRING(rate));
+		return 0;
+	}
+
+	if (strcmp(attr->name, "host_tx_eq_params") == 0) {
+		settings = params->host;
+		num_lanes = params->tx_lanes;
+		seq_printf(s, "Host TX EQ PreShoot Cap: 0x%02x, DeEmphasis Cap: 0x%02x\n",
+			   hba->host_preshoot_cap, hba->host_deemphasis_cap);
+	} else if (strcmp(attr->name, "device_tx_eq_params") == 0) {
+		settings = params->device;
+		num_lanes = params->rx_lanes;
+		seq_printf(s, "Device TX EQ PreShoot Cap: 0x%02x, DeEmphasis Cap: 0x%02x\n",
+			   hba->device_preshoot_cap, hba->device_deemphasis_cap);
+	} else {
+		return -ENOENT;
+	}
+
+	seq_printf(s, "TX EQ setting for HS-G%u, Rate-%s:\n", gear,
+		   UFS_HS_RATE_STRING(rate));
+	for (lane = 0; lane < num_lanes; lane++)
+		seq_printf(s, "TX Lane %d - PreShoot: %d, DeEmphasis: %d, Pre-Coding %senabled\n",
+			   lane, settings[lane].preshoot,
+			   settings[lane].deemphasis,
+			   settings[lane].precode_en ? "" : "not ");
+
+	return 0;
+}
+
+static int ufs_tx_eq_params_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ufs_tx_eq_params_show, inode->i_private);
+}
+
+static const struct file_operations ufs_tx_eq_params_fops = {
+	.owner		= THIS_MODULE,
+	.open		= ufs_tx_eq_params_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int ufs_tx_eqtr_record_show(struct seq_file *s, void *data)
+{
+	struct ufs_debugfs_attr *attr = s->private;
+	struct ufs_hba *hba = hba_from_file(s->file);
+	struct ufshcd_tx_eq_params *params;
+	unsigned long preshoot_bitmap, deemphasis_bitmap;
+	unsigned int preshoot, deemphasis;
+	u32 (*record)[TX_HS_NUM_PRESHOOT][TX_HS_NUM_DEEMPHASIS];
+	u32 gear = hba->debugfs_tx_eq_gear;
+	u32 rate = hba->pwr_info.hs_rate;
+	u32 num_lanes;
+	int lane;
+	char name[32];
+
+	if (!ufshcd_is_tx_eq_supported(hba))
+		return -EOPNOTSUPP;
+
+	if (gear < UFS_HS_G1 || gear >= UFS_HS_GEAR_MAX) {
+		seq_printf(s, "Invalid gear selected: %u\n", gear);
+		return 0;
+	}
+
+	params = &hba->tx_eq_params[gear - 1];
+	if (!params->is_valid) {
+		seq_printf(s, "TX EQ params are invalid for HS-G%u, Rate-%s\n",
+			   gear, UFS_HS_RATE_STRING(rate));
+		return 0;
+	}
+
+	if (!params->num_eqtr_records) {
+		seq_printf(s, "No TX EQTR records found for HS-G%u, Rate-%s.\n",
+			   gear, UFS_HS_RATE_STRING(rate));
+		return 0;
+	}
+
+	if (strcmp(attr->name, "host_tx_eqtr_record") == 0) {
+		record = params->host_eqtr_record;
+		preshoot_bitmap = (hba->host_preshoot_cap << 0x1) | 0x1;
+		deemphasis_bitmap = (hba->host_deemphasis_cap << 0x1) | 0x1;
+		num_lanes = params->tx_lanes;
+		snprintf(name, 32, "%s", "Host");
+	} else if (strcmp(attr->name, "device_tx_eqtr_record") == 0) {
+		record = params->device_eqtr_record;
+		preshoot_bitmap = (hba->device_preshoot_cap << 0x1) | 0x1;
+		deemphasis_bitmap = (hba->device_deemphasis_cap << 0x1) | 0x1;
+		num_lanes = params->rx_lanes;
+		snprintf(name, 32, "%s", "Device");
+	} else {
+		return -ENOENT;
+	}
+
+	seq_printf(s, "%s TX EQTR record summary -\n", name);
+	seq_printf(s, "Target Power Mode: HS-G%u, Rate-%s\n", gear,
+		   UFS_HS_RATE_STRING(rate));
+	seq_printf(s, "Number of records: %d\n", params->num_eqtr_records);
+	seq_printf(s, "Last record timestamp: %llu us\n",
+		   ktime_to_us(params->last_eqtr_ts));
+
+	for (lane = 0; lane < num_lanes; lane++) {
+		seq_printf(s, "\nTX Lane %d: %s\n", lane, "PreShoot\\DeEmphasis");
+		seq_puts(s, "\\");
+		/* Print DeEmphasis header as X-axis. */
+		for (deemphasis = 0; deemphasis < TX_HS_NUM_DEEMPHASIS; deemphasis++)
+			seq_printf(s, "%8d%s", deemphasis, " ");
+		seq_puts(s, "\n");
+		/* Print matrix rows with PreShoot as Y-axis. */
+		for (preshoot = 0; preshoot < TX_HS_NUM_PRESHOOT; preshoot++) {
+			seq_printf(s, "%d", preshoot);
+			for (deemphasis = 0; deemphasis < TX_HS_NUM_DEEMPHASIS; deemphasis++) {
+				if (test_bit(preshoot, &preshoot_bitmap) &&
+				    test_bit(deemphasis, &deemphasis_bitmap)) {
+					u32 fom = record[lane][preshoot][deemphasis];
+					u32 fom_val = fom & RX_FOM_VALUE_MASK;
+					bool precode_en = !!(fom & RX_FOM_PRECODING_EN_MASK);
+
+					if (fom == 0xFFFFFFFF)
+						seq_printf(s, "%8s%s", "-", " ");
+					else
+						seq_printf(s, "%8u%s", fom_val,
+							   precode_en ? "*" : " ");
+				} else {
+					seq_printf(s, "%8s%s", "x", " ");
+				}
+			}
+			seq_puts(s, "\n");
+		}
+	}
+
+	return 0;
+}
+
+static int ufs_tx_eqtr_record_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ufs_tx_eqtr_record_show, inode->i_private);
+}
+
+static const struct file_operations ufs_tx_eqtr_record_fops = {
+	.owner		= THIS_MODULE,
+	.open		= ufs_tx_eqtr_record_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static const struct ufs_debugfs_attr ufs_tx_eq_attrs[] = {
+	{ "host_tx_eq_params", 0400, &ufs_tx_eq_params_fops },
+	{ "device_tx_eq_params", 0400, &ufs_tx_eq_params_fops },
+	{ "host_tx_eqtr_record", 0400, &ufs_tx_eqtr_record_fops },
+	{ "device_tx_eqtr_record", 0400, &ufs_tx_eqtr_record_fops },
+	{ }
+};
+
 void ufs_debugfs_hba_init(struct ufs_hba *hba)
 {
 	const struct ufs_debugfs_attr *attr;
@@ -230,6 +427,15 @@ void ufs_debugfs_hba_init(struct ufs_hba *hba)
 			    hba, &ee_usr_mask_fops);
 	debugfs_create_u32("exception_event_rate_limit_ms", 0600, hba->debugfs_root,
 			   &hba->debugfs_ee_rate_limit_ms);
+
+	if (!(hba->caps & UFSHCD_CAP_TX_EQUALIZATION))
+		return;
+	hba->debugfs_tx_eq_gear = UFS_HS_GEAR_MAX - 1;
+	debugfs_create_file("tx_eq_gear_sel", 0600, hba->debugfs_root, hba,
+			    &tx_eq_gear_fops);
+	for (attr = ufs_tx_eq_attrs; attr->name; attr++)
+		debugfs_create_file(attr->name, attr->mode, root, (void *)attr,
+				    attr->fops);
 }
 
 void ufs_debugfs_hba_exit(struct ufs_hba *hba)
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 696db71d68bc..56455b137f10 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1038,6 +1038,7 @@ enum ufshcd_mcq_opr {
  * @host_deemphasis_cap: host TX DeEmphasis capability
  * @device_preshoot_cap: device TX PreShoot capability
  * @device_deemphasis_cap: device TX DeEmphasis capability
+ * @debugfs_tx_eq_gear: used to select Gear for TX Equalization debugfs entries
  * @tx_eq_params: TX Equalization settings
  */
 struct ufs_hba {
@@ -1217,6 +1218,7 @@ struct ufs_hba {
 	u32 host_deemphasis_cap;
 	u32 device_preshoot_cap;
 	u32 device_deemphasis_cap;
+	u32 debugfs_tx_eq_gear;
 	struct ufshcd_tx_eq_params tx_eq_params[UFS_HS_GEAR_MAX - 1];
 };
 
-- 
2.34.1

