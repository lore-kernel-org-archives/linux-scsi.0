Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E091DB54C;
	Thu, 16 Jan 2025 09:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737018800; cv=none; b=Eo8qN9Z/e6IcAkFX7czTfeDi6aPlj7B+4nYZP2YqyMvgU6UC8Q98Nm2jz3ATPFU+8FSeCvyOhDn4nOJG4wXBugbqEA6+QOmIBQViIy/1Na93btlTx9ibaKswJkKi+PB7HWQ4Tnew4lZSMJcWccvZnQ6iFfn/DNlVJLN/Iab7h18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737018800; c=relaxed/simple;
	bh=6mdWUrrVahAt/4fJaGIy7eiVqiIHbpAylmNmOk241kk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=H2fXo6fLsPb2nYszfPhiAv/iJ4zG0ZzJal+o+6a4D/68NC9EltkpCmkLSc/U4hovA/A90AwLwKpL7i0jsFswkB4w5UnPxuMjbr1rc498NTu7BPc8rGABK4zf4HywFKxg+B4qbXLrAXcYOz+KCKIJFpU5UD3W4nFItRg2jObnZ2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=p7a+lltw; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="p7a+lltw"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50G62Z6j015125;
	Thu, 16 Jan 2025 09:12:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=Cb2OUInCQ6N
	UjMEozfJkNPHrCqzxlA21t77oiJVeWeE=; b=p7a+lltwMtz4RN+tsKR9q6HMeyc
	NrzcqsVTbqRbInYkZc6/n2wklOBaTrpRVBDGOyoXw/9gMBZfEMy4OAwwW0LOS4el
	AI9K52rDm/p+u5NjxL1EkVI0Vi2ukSrqsJ47sBPPHxM5LK3OInRWvTs4IcQkXKMV
	KOJZ00yaOzzUhzfzew/bNODbwKQomJOPuvPaPvLPf5kFXah0yhQRIQnSgteqCCO5
	63AG/uP+WZMoMZtcrKDt/3lxq92KB+6PgaGzTP8TbIH+w/MALJrnwqhYEbCcgRqE
	P2QSqGjbz15uvWyDTnIRB6ZsbQYHQqWv4pdkh883fU7v04vPgklfuFarQiw==
Received: from aptaippmta02.qualcomm.com (tpe-colo-wan-fw-bordernet.qualcomm.com [103.229.16.4])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 446vge8f4w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 09:12:54 +0000 (GMT)
Received: from pps.filterd (APTAIPPMTA02.qualcomm.com [127.0.0.1])
	by APTAIPPMTA02.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTP id 50G9CTli032044;
	Thu, 16 Jan 2025 09:12:52 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by APTAIPPMTA02.qualcomm.com (PPS) with ESMTPS id 4442bf51s6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 09:12:52 +0000
Received: from APTAIPPMTA02.qualcomm.com (APTAIPPMTA02.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 50G9Cpdg032519;
	Thu, 16 Jan 2025 09:12:51 GMT
Received: from cbsp-sh-gv.ap.qualcomm.com (CBSP-SH-gv.ap.qualcomm.com [10.231.249.68])
	by APTAIPPMTA02.qualcomm.com (PPS) with ESMTPS id 50G9CpU2032516
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 09:12:51 +0000
Received: by cbsp-sh-gv.ap.qualcomm.com (Postfix, from userid 393357)
	id 753ED40BF9; Thu, 16 Jan 2025 17:12:50 +0800 (CST)
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
        Eric Biggers <ebiggers@google.com>, Minwoo Im <minwoo.im@samsung.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 3/8] scsi: ufs: core: Add a vops to map clock frequency to gear speed
Date: Thu, 16 Jan 2025 17:11:44 +0800
Message-Id: <20250116091150.1167739-4-quic_ziqichen@quicinc.com>
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
X-Proofpoint-ORIG-GUID: cBP1s5bIZzqw-Otazp8KruOwhWTOVyqA
X-Proofpoint-GUID: cBP1s5bIZzqw-Otazp8KruOwhWTOVyqA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-16_03,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 phishscore=0 mlxscore=0 impostorscore=0 suspectscore=0
 clxscore=1011 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501160067

From: Can Guo <quic_cang@quicinc.com>

Add a vops to map UFS host controller clock frequencies to the maximum
supported UFS high speed gear speeds. During clock scaling, we can map the
target clock frequency, demanded by devfreq, to the maximum supported gear
speed, so that devfreq can scale the gear to the highest gear speed
supported at the target clock frequency, instead of just scaling up/down
the gear between the min and max gear speeds.

Co-developed-by: Ziqi Chen <quic_ziqichen@quicinc.com>
Signed-off-by: Ziqi Chen <quic_ziqichen@quicinc.com>
Signed-off-by: Can Guo <quic_cang@quicinc.com>
---
 drivers/ufs/core/ufshcd-priv.h | 10 ++++++++++
 include/ufs/ufshcd.h           |  3 +++
 2 files changed, 13 insertions(+)

diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index 0549b65f71ed..a8f05fc6e830 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -277,6 +277,16 @@ static inline int ufshcd_mcq_vops_config_esi(struct ufs_hba *hba)
 	return -EOPNOTSUPP;
 }
 
+static inline int ufshcd_vops_freq_to_gear_speed(struct ufs_hba *hba,
+						 unsigned long freq,
+						 u32 *gear)
+{
+	if (hba->vops && hba->vops->freq_to_gear_speed)
+		return hba->vops->freq_to_gear_speed(hba, freq, gear);
+
+	return -EOPNOTSUPP;
+}
+
 extern const struct ufs_pm_lvl_states ufs_pm_lvl_states[];
 
 /**
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index a4dac897a169..8c7c497d63d3 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -336,6 +336,7 @@ struct ufs_pwr_mode_info {
  * @get_outstanding_cqs: called to get outstanding completion queues
  * @config_esi: called to config Event Specific Interrupt
  * @config_scsi_dev: called to configure SCSI device parameters
+ * @freq_to_gear_speed: called to map clock frequency to the max supported gear speed
  */
 struct ufs_hba_variant_ops {
 	const char *name;
@@ -387,6 +388,8 @@ struct ufs_hba_variant_ops {
 				       unsigned long *ocqs);
 	int	(*config_esi)(struct ufs_hba *hba);
 	void	(*config_scsi_dev)(struct scsi_device *sdev);
+	int (*freq_to_gear_speed)(struct ufs_hba *hba, unsigned long freq,
+					u32 *gear);
 };
 
 /* clock gating state  */
-- 
2.34.1

