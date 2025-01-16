Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947E01D90A5;
	Thu, 16 Jan 2025 09:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737018824; cv=none; b=l4JMjKDsC0hz91qd+bjo4CuKNf3YQb5eA/vRmL0uAOnPduvhsgqbmKHjttVygP9ZqtU+uKb1j481FZ/3mmfX0mjqCQk0yEIIES828E4lj9K8BJbQ5tp1S9bJiwqpvyaSYdkJoIg/9z7mg7R4fPyB0wkOnqBU1dgtQDkSOsRL1XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737018824; c=relaxed/simple;
	bh=am3pycCG0HB1VymIG+RPCE/lTRaFqY+iJt6+1oXCuVU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eXxQfcKlNgyRBXxNZhiPP07LHAXigk11VEVo8eJQpoGLAnioJGQmzPtYEc/65fF8EeCFEQF8Xgghz2jYQDGYFy7lCv27sV908+X2AbNQfviCoXUR0+aasq5tDtdcEasfDCn4ucTvLY+tETwjg7TIHdTMKgRodQ4UAXJnGTxZaSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=Y4bk0b5c; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="Y4bk0b5c"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50G87bxn001414;
	Thu, 16 Jan 2025 09:13:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=4aXd8QsTxM5
	2VfkVONXOxiq2R/hDKDJ2l4jJc/5ldJ0=; b=Y4bk0b5cXa0EFd3zlWaOsZF+qvg
	VZK0USAogBxf88tkOhEL8svAkDKrKrEKiUYtn3I2p7G/A5CFXqQDZWVaNkupH6c1
	n802X7UrW2rVgX7lXqiFI+iQcMOVR0UM1GUvTMfvQay7Y/A5T5ATtld7I4ytrlEX
	Vo3hn/ugxUtDDRGMEO3ducLqbbzF4ZTGWuf3Ul9YuKW+DHbJN+t6K8Q4ARzZrfui
	8/jZkfT5GJEFAgJcm+ed4VASl8/zT0HFMUzrycyu3UqADc2QFBaXrpgZRr4uTNi5
	j2eREZf4AdRuOFG0sbW1unStVIlLEcjH3igSTfoUPhkj3oGRRNH7Y3huTOQ==
Received: from aptaippmta01.qualcomm.com (tpe-colo-wan-fw-bordernet.qualcomm.com [103.229.16.4])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 446xay85rj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 09:13:13 +0000 (GMT)
Received: from pps.filterd (APTAIPPMTA01.qualcomm.com [127.0.0.1])
	by APTAIPPMTA01.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTP id 50G9DBTZ022864;
	Thu, 16 Jan 2025 09:13:11 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by APTAIPPMTA01.qualcomm.com (PPS) with ESMTPS id 44426qw52e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 09:13:11 +0000
Received: from APTAIPPMTA01.qualcomm.com (APTAIPPMTA01.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 50G9DAUr022858;
	Thu, 16 Jan 2025 09:13:10 GMT
Received: from cbsp-sh-gv.ap.qualcomm.com (CBSP-SH-gv.ap.qualcomm.com [10.231.249.68])
	by APTAIPPMTA01.qualcomm.com (PPS) with ESMTPS id 50G9DA5W022857
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 09:13:10 +0000
Received: by cbsp-sh-gv.ap.qualcomm.com (Postfix, from userid 393357)
	id 3118B40BF9; Thu, 16 Jan 2025 17:13:09 +0800 (CST)
From: Ziqi Chen <quic_ziqichen@quicinc.com>
To: quic_cang@quicinc.com, bvanassche@acm.org, mani@kernel.org,
        beanhuo@micron.com, avri.altman@wdc.com, junwoo80.lee@samsung.com,
        martin.petersen@oracle.com, quic_ziqichen@quicinc.com,
        quic_nguyenb@quicinc.com, quic_nitirawa@quicinc.com,
        quic_rampraka@quicinc.com
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Andrew Halaney <ahalaney@redhat.com>,
        Maramaina Naresh <quic_mnaresh@quicinc.com>,
        Eric Biggers <ebiggers@google.com>, Minwoo Im <minwoo.im@samsung.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 7/8] scsi: ufs: core: Toggle Write Booster during clock scaling base on gear speed
Date: Thu, 16 Jan 2025 17:11:48 +0800
Message-Id: <20250116091150.1167739-8-quic_ziqichen@quicinc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250116091150.1167739-1-quic_ziqichen@quicinc.com>
References: <20250116091150.1167739-1-quic_ziqichen@quicinc.com>
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
X-Proofpoint-GUID: hyS6x_8RAYyi8kJNWmZJJF9X5L30bKgO
X-Proofpoint-ORIG-GUID: hyS6x_8RAYyi8kJNWmZJJF9X5L30bKgO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-16_03,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 bulkscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 spamscore=0
 mlxscore=0 suspectscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501160067

From: Can Guo <quic_cang@quicinc.com>

During clock scaling, Write Booster is toggled on or off based on
whether the clock is scaled up or down. However, with OPP V2 powered
multi-level gear scaling, the gear can be scaled amongst multiple gear
speeds, e.g., it may scale down from G5 to G4, or from G4 to G2. To provide
flexibilities, add a new field for clock scaling such that during clock
scaling Write Booster can be enabled or disabled based on gear speeds but
not based on scaling up or down.

Co-developed-by: Ziqi Chen <quic_ziqichen@quicinc.com>
Signed-off-by: Ziqi Chen <quic_ziqichen@quicinc.com>
Signed-off-by: Can Guo <quic_cang@quicinc.com>
---
 drivers/ufs/core/ufshcd.c | 17 ++++++++++++-----
 include/ufs/ufshcd.h      |  3 +++
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 721bf9d1a356..31ebf267135b 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1395,13 +1395,17 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba, u64 timeout_us)
 	return ret;
 }
 
-static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, int err, bool scale_up)
+static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, int err)
 {
 	up_write(&hba->clk_scaling_lock);
 
-	/* Enable Write Booster if we have scaled up else disable it */
-	if (ufshcd_enable_wb_if_scaling_up(hba) && !err)
-		ufshcd_wb_toggle(hba, scale_up);
+	/* Enable Write Booster if current gear requires it else disable it */
+	if (ufshcd_enable_wb_if_scaling_up(hba) && !err) {
+		bool wb_en;
+
+		wb_en = hba->pwr_info.gear_rx >= hba->clk_scaling.wb_gear ? true : false;
+		ufshcd_wb_toggle(hba, wb_en);
+	}
 
 	mutex_unlock(&hba->wb_mutex);
 
@@ -1456,7 +1460,7 @@ static int ufshcd_devfreq_scale(struct ufs_hba *hba, unsigned long freq,
 	}
 
 out_unprepare:
-	ufshcd_clock_scaling_unprepare(hba, ret, scale_up);
+	ufshcd_clock_scaling_unprepare(hba, ret);
 	return ret;
 }
 
@@ -1816,6 +1820,9 @@ static void ufshcd_init_clk_scaling(struct ufs_hba *hba)
 	if (!hba->clk_scaling.min_gear)
 		hba->clk_scaling.min_gear = UFS_HS_G1;
 
+	if (!hba->clk_scaling.wb_gear)
+		hba->clk_scaling.wb_gear = UFS_HS_G3;
+
 	INIT_WORK(&hba->clk_scaling.suspend_work,
 		  ufshcd_clk_scaling_suspend_work);
 	INIT_WORK(&hba->clk_scaling.resume_work,
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 8c7c497d63d3..8e6c2eb68011 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -448,6 +448,8 @@ struct ufs_clk_gating {
  * @resume_work: worker to resume devfreq
  * @target_freq: frequency requested by devfreq framework
  * @min_gear: lowest HS gear to scale down to
+ * @wb_gear: enable Write Booster when HS gear scales above or equal to it, else
+ *		disable Write Booster
  * @is_enabled: tracks if scaling is currently enabled or not, controlled by
  *		clkscale_enable sysfs node
  * @is_allowed: tracks if scaling is currently allowed or not, used to block
@@ -468,6 +470,7 @@ struct ufs_clk_scaling {
 	struct work_struct resume_work;
 	unsigned long target_freq;
 	u32 min_gear;
+	u32 wb_gear;
 	bool is_enabled;
 	bool is_allowed;
 	bool is_initialized;
-- 
2.34.1

