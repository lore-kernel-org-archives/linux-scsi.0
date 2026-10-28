Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793190348;
	b=uIyE61Pv9gK5yqzh9Qhp/k7tbWYm3LYu7plq0upqUhAZXGqixeroGlTFRgYRDzcqKfZT
	 rMrANCFMut/3w8r00wk/XTjJ4FRL9dB8etobeOf4/D0ZjVWrmvnPqlx1NORJwuVBWkdrz
	 ugFtQ6JU0uNYCBKUIHnYPUdUEWSZ4gLe9vbsK+I+SJ146fu8jYrt0UqQmcWf9cbbGHn6/
	 kvAsaqxhE0VRLykIpy5xnu9Hrbmy5wAmAyilTvMRFTxJ8Uptz1fa/ebnwgy0DoL/GIobs
	 R7dCWFXS1ytt68fcK2kmtuLpukObya0CJX6qY4kMZ0YNsGRNQtjHmxyNSYSRAk/IO1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793190348;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=XhGgIoX9GQVSucSqNoFuZLYd22G+9ogxeRdAKrej2dA=;
	b=urBGTrfQU+h2vqg21Q8OSCvHv6P01AvzoiwLwDCak+LuSBi79gse+TlIKXi07A3fHDvR
	 nuoDk2xeeDSoGXMoWjAxuEy5qxT4+odWYxBjhTdf5ciwF62M5gWGzduaEn9DG5H2aguTy
	 2drGJVO1X9rpLEjRFhA67iYIhNh4Hk628NPtBlEgybsueWRCb4uKgiF+UVhWfmaHrwy+o
	 G2owqUrTG2OGb3On78tI/lfbbwdLTNCJLxxmG3FFlmbK986LvWOt9oJW/0gJOHxqqa6fN
	 jlFslUKhTMvtVpa8izwjdHtRVye+Ow2LA6sF2SN5PWjKmQFOOD0xxdQDHi1uKVRphrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=JaYhMvPb;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=ATZgWan4;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC451606A324
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 12:25:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AC451606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=JaYhMvPb;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=ATZgWan4
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69SBe9rJ994831
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 12:25:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	XhGgIoX9GQVSucSqNoFuZLYd22G+9ogxeRdAKrej2dA=; b=JaYhMvPb/aS4mild
	JgXIZhPe59bZLnHlK0T6pnkwsrpevxGg9ZarBpiMF/BwPddNY2Me1PsYubdYbuVi
	UNC11LH709H84be8Gzm9hP9XYnUofZcWC5aaKlTrmnq2V+LysTw7ORGxuGUicujE
	BY4rKDlF5LTdoLi+6mezacLoiMWJ8TBiMMaUBIp/7ezFM1x5txSpnOdo/RbXXRh8
	TKt88695qLS0o4WCloTHgz+wyogfhK5YEs+XiRI2Tnc4Gfv8hUfNhsmxxBnNclMd
	Rzso7KKCmj6KTfBm4f4dbK9r7LoTUc1L0ZhkrF0m2IQa8r+HPii9x4hKrhJDWDlz
	vSKgZg==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hk82tt0w9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 12:25:46 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cc1ca15334cso1056791a12.1
        for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 05:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793190346; x=1793795146; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XhGgIoX9GQVSucSqNoFuZLYd22G+9ogxeRdAKrej2dA=;
        b=ATZgWan4YUH5AYFSA+tCuq3FicjGkMBA4xEU1EkFDiDiiYh28Db8BMa1xMPqA14boM
         I1jUegKo9d8Xyn5jpEnUgSBSFwop7idNDtXmHYcYas8Nax0ECkfhPC2dqOpwXNVF2t7c
         iRR/6m2K7HxHKk1rQ+rjD05Y5LzZZz3COmWQ0nBLlzW/VqfvKR/mbC3nZnCML8VD23px
         ZiKuJW47x/Or7XjO3o05thuQikJcrp5RElFrvbReKWiJgeg/tFZL7OWMa/goU2GGwcwU
         ukzMESrG9uVnfpn45NSAm/iPDtWo31QkxI9lLEbF9W41oIYN/NKWVeoCzn3C8Wdl78R9
         AtTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793190346; x=1793795146;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XhGgIoX9GQVSucSqNoFuZLYd22G+9ogxeRdAKrej2dA=;
        b=JlBEdv1wveyLxWNTzDaWTehXhpasJuNsXgYBoh/PO3J5s1pKXHW6W9ZMzmPyqqyey6
         bR28qCWA/TddFlxv5c0ZF6E9QuYbtCjlg3dcleImlVY8W0EWwXzbFHxRnKSubC4A47/a
         x1ukVJoXc4P271bkXhVLw2mTXRcqRAv9LrDwZratlhontqrVMfiWrcZr9SYzvhs+JxbF
         tPicc/BXHq8+6sAOgoeHH6+X9J3QrHcYYc7mPnb1ILDmPkFiPPtO5hEaIGyPRksRzBkI
         xCEXFOq/tCc17HEtYX3TzYzgvHw2L1CdAjSLBmW1X6tNtOEYHKO4GeRVKgrDqoy8cmEN
         Hq0g==
X-Forwarded-Encrypted: i=1; AKwUvByYwLW1PdBnN3gTK4wgP/CyokHBXr71oIfSNa6IUkw9RD9ZxPD3mCSm7c8cAiEeNM/Xfl45FKHnjVZQ@vger.kernel.org
X-Gm-Message-State: AFq9FYLee1svgkrIx9ozPbe03t9R4tyvtL9j0bgXebMctIybr+m+BbiG
	mbHOVrs61t83BL24JBD6+lZf7eN1vY7+jRUoabAi9hZQknCcFnaUntojNUHiU6S9XCqxV19ccmv
	Zqc5I1VwUymR8FTwSWx1X5JDMdRc/yyS4dc/SQ0txxuJe3bCUd+Ek0f1G/t9vUSs/
X-Gm-Gg: AYBFou3ua+WzNIMyZ6IPKe8u+9l18jeE8iZ+FK4VQM1l2XqidvjObGhF1oMC7PmVZMh
	hw2PtvUp1gS45NxYUTxCD9aLsSjp5qbH0Ys1KSdOXw5fJu1fEDocW1ok00Cfy9r0edNMhJ6woac
	L9iiL8+gr0mJ7aEZaTXUj/+pJoiqdWsIAF1G54NCRRjuuqfBcWnQ7Agc3MxTv5xzNxm/edrqA9R
	WfiZCVON9AxVIPo+WnTi6hWkUIvBKAPW4BBGXheIOIdA5RozeHuNGVXpcqqrxDdE2uxe3FNCQDk
	aftWiFLOdW0sPGazDxNE1XLxefbS84N7L57LRWYFYsl1L0qM5oYscB+pIu6NEKf9ATncgqezlFM
	iGYLWhS7JXESWbQgqgbaXbZnhuq0ncsqHfoLMV6Bvh0x+mwm2w7vui1Uas2VHmAOqyzMa5i++P0
	g=
X-Received: by 2002:a17:90b:4a4f:b0:3ac:97e3:7389 with SMTP id 98e67ed59e1d1-3ae58299f75mr1599651a91.44.1793190345680;
        Wed, 28 Oct 2026 05:25:45 -0700 (PDT)
X-Received: by 2002:a17:90b:4a4f:b0:3ac:97e3:7389 with SMTP id 98e67ed59e1d1-3ae58299f75mr1599632a91.44.1793190345192;
        Wed, 28 Oct 2026 05:25:45 -0700 (PDT)
Received: from [10.213.101.15] ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae5a9f287fsm2995819a91.16.2026.10.28.05.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 05:25:44 -0700 (PDT)
From: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
Date: Wed, 28 Oct 2026 17:54:48 +0530
Subject: [PATCH v5 3/3] phy: qcom-qmp-ufs: Add Glymur support
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261028-glymur_ufs_qcb_enablement-v5-3-09cda5e3bab3@oss.qualcomm.com>
References: <20261028-glymur_ufs_qcb_enablement-v5-0-09cda5e3bab3@oss.qualcomm.com>
In-Reply-To: <20261028-glymur_ufs_qcb_enablement-v5-0-09cda5e3bab3@oss.qualcomm.com>
To: Vinod Koul <vkoul@kernel.org>, Neil Armstrong <neil.armstrong@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@sandisk.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        gopikrishna.garmidi@oss.qualcomm.com, jagadeesh.kona@oss.qualcomm.com,
        Abel Vesa <abel.vesa@oss.qualcomm.com>,
        Abel Vesa <abelvesa@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        sibi.sankar@oss.qualcomm.com, Taniya Das <taniya.das@oss.qualcomm.com>,
        Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793190309; l=6525;
 i=pradeep.pragallapati@oss.qualcomm.com; s=20260911;
 h=from:subject:message-id; bh=ldQBD2uXwAXJJrMOGsoZuUpZ04qOGizm0CRQ7vkr1Q4=;
 b=grcpIXosquMaObKOLseW67QNTmPag9XMw522vEBv29iCi5jNoeKXyOo687lcEd3X7FEwqAaOH
 Pb4NjwRI/M9DBYBOjwzuINYr32HrQFSJGfH++nmBQwTp2AWlVA3YigP
X-Developer-Key: i=pradeep.pragallapati@oss.qualcomm.com; a=ed25519;
 pk=uyRUsge8nQMwf3iW/e/o0U8z9nWLCMm1MGKxEftztic=
X-Proofpoint-GUID: LYRYZhMUYHI4lYHrQ4fjZAo68KXAioIi
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI4MDA0OSBTYWx0ZWRfX10ZKo5jFBZ0n
 iREa5Dc0FfSYsrOJufoB5O28o5/xQA5Ft0AK8tkccYqCxBuGEsTOIYZvHZ0nJAroCkD4WvsIsR0
 5XEERWvMnrZIRcdp+4TLpJ0lpZLbCd0=
X-Authority-Analysis: v=2.4 cv=Tr1zFzXh c=1 sm=1 tr=0 ts=6ae1e9ca cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=EEZK_nQxm5Uv2-YDnh4A:9 a=QEXdDO2ut3YA:10
 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-ORIG-GUID: LYRYZhMUYHI4lYHrQ4fjZAo68KXAioIi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI4MDA0OSBTYWx0ZWRfX1S1S3sLGN55I
 BHrB95nN8mBd7sjRnz8wBp9Kd+mWNtgehrKe8hsBIR+TwRAYrcpwIT2Dv7oaIaLgxn3RAirrcLz
 uidMgEKujPF+uSkXiDfzrpasEfC0VmatP2lZ+3Lz/cWo0ulySeKS7RBlmcyFCmHbruvJlEG3Mxi
 DI2pbnqbznrA3DI2vXfR0z3hA7Ib17F5gmu2K3AxEnXtOV9uwh7tKK2bneHzq42NX0Uk3YNac+A
 fiBq0Hh1KXMcmI8FOG4/QejDtKv/TU5GTQnntPT4i2M65T4nRxlChP19e6e83J2x6zHg3ikmzKF
 MeYAtJcx13+bCS2ZXJOtmU7BRw6+grtFjlAbE9nTqqc6nNwue3dnt1GI4syFWa6+9+t9p+Mi8gs
 r4+ytSUKszTWsh2zdWW1R1E/I8WjSP5yeMW0pRgK/wdGDRCjqPm45uP7BUntsOEv584oPsQoewX
 RrlYNosHBqOTUVIPjQw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-28_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 spamscore=0 clxscore=1015 phishscore=0
 impostorscore=0 malwarescore=0 adultscore=0 suspectscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610280049

Add the init sequence tables and config for the UFS QMP phy found in
the Glymur SoC.

Similar to SM8750, the QSERDES RX and TX register offsets for
glymur SoC follow the v7 register layout, while the remaining
(PCS, MPHY base) register offsets follow v6 layout. Update the
register layouts accordingly.

Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Acked-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
---
 drivers/phy/qualcomm/phy-qcom-qmp-ufs.c | 99 +++++++++++++++++++++++++++++++++
 1 file changed, 99 insertions(+)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
index d15db9ab9a90..f441b26bb8a6 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
@@ -93,6 +93,59 @@ static const unsigned int ufsphy_v7_regs_layout[QPHY_LAYOUT_SIZE] = {
 	[QPHY_PCS_POWER_DOWN_CONTROL]	= QPHY_V7_PCS_UFS_POWER_DOWN_CONTROL,
 };
 
+static const struct qmp_phy_init_tbl glymur_ufsphy_rx[] = {
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_UCDR_FO_GAIN_RATE2, 0x0c),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_UCDR_FO_GAIN_RATE4, 0x0c),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_UCDR_SO_GAIN_RATE4, 0x04),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_EQ_OFFSET_ADAPTOR_CNTRL1, 0x14),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_UCDR_PI_CONTROLS, 0x07),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_OFFSET_ADAPTOR_CNTRL3, 0x0e),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_UCDR_FASTLOCK_COUNT_HIGH_RATE4, 0x02),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_UCDR_FASTLOCK_FO_GAIN_RATE4, 0x1c),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_UCDR_FASTLOCK_SO_GAIN_RATE4, 0x06),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_VGA_CAL_MAN_VAL, 0xce),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_EQU_ADAPTOR_CNTRL4, 0x0f),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE_0_1_B0, 0xce),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE_0_1_B1, 0xce),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE_0_1_B2, 0x18),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE_0_1_B3, 0x1a),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE_0_1_B4, 0x0f),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE_0_1_B6, 0x60),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE_0_1_B7, 0x62),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE2_B3, 0x9a),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE2_B6, 0xe2),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE2_B7, 0x06),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE3_B0, 0x1b),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE3_B1, 0x1b),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE3_B2, 0x98),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE3_B3, 0x9b),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE3_B4, 0x2a),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE3_B5, 0x12),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE3_B7, 0x06),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE3_B8, 0x01),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SA_B0, 0x93),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SA_B1, 0x93),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SA_B2, 0x60),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SA_B3, 0x99),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SA_B4, 0x5f),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SA_B5, 0x92),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SA_B6, 0xe3),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SA_B7, 0x06),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SB_B0, 0x24),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SB_B1, 0x24),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SB_B2, 0xe0),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SB_B3, 0x99),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SB_B4, 0x5f),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SB_B5, 0x92),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SB_B6, 0xfb),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SB_B7, 0x06),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_UCDR_SO_SATURATION, 0x1f),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_UCDR_PI_CTRL1, 0x94),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_TERM_BW_CTRL0, 0xfa),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_DLL0_FTUNE_CTRL, 0x30),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_SIGDET_CAL_TRIM, 0x77),
+};
+
 static const struct qmp_phy_init_tbl milos_ufsphy_serdes[] = {
 	QMP_PHY_INIT_CFG(QSERDES_V6_COM_SYSCLK_EN_SEL, 0xd9),
 	QMP_PHY_INIT_CFG(QSERDES_V6_COM_CMN_CONFIG_1, 0x16),
@@ -1212,6 +1265,11 @@ struct qmp_ufs {
 };
 
 /* Regulator bulk data with load values for specific configurations */
+static const struct regulator_bulk_data glymur_ufsphy_vreg_l[] = {
+	{ .supply = "vdda-phy", .init_load_uA = 217130 },
+	{ .supply = "vdda-pll", .init_load_uA = 18340 },
+};
+
 static const struct regulator_bulk_data milos_ufsphy_vreg_l[] = {
 	{ .supply = "vdda-phy", .init_load_uA = 140120 },
 	{ .supply = "vdda-pll", .init_load_uA = 18340 },
@@ -1324,6 +1382,44 @@ static const struct qmp_ufs_offsets qmp_ufs_offsets_v7 = {
 	.rx2		= 0x3000,
 };
 
+static const struct qmp_phy_cfg glymur_ufsphy_cfg = {
+	.lanes			= 2,
+
+	.offsets		= &qmp_ufs_offsets_v6,
+	.max_supported_gear	= UFS_HS_G5,
+
+	.tbls = {
+		.serdes		= sm8750_ufsphy_serdes,
+		.serdes_num	= ARRAY_SIZE(sm8750_ufsphy_serdes),
+		.tx		= sm8750_ufsphy_tx,
+		.tx_num		= ARRAY_SIZE(sm8750_ufsphy_tx),
+		.rx		= glymur_ufsphy_rx,
+		.rx_num		= ARRAY_SIZE(glymur_ufsphy_rx),
+		.pcs		= sm8750_ufsphy_pcs,
+		.pcs_num	= ARRAY_SIZE(sm8750_ufsphy_pcs),
+	},
+
+	.tbls_hs_b = {
+		.pcs		= sm8750_ufsphy_hs_b_pcs,
+		.pcs_num	= ARRAY_SIZE(sm8750_ufsphy_hs_b_pcs),
+	},
+
+	.tbls_hs_overlay[0] = {
+		.pcs		= sm8750_ufsphy_g4_pcs,
+		.pcs_num	= ARRAY_SIZE(sm8750_ufsphy_g4_pcs),
+		.max_gear	= UFS_HS_G4,
+	},
+	.tbls_hs_overlay[1] = {
+		.pcs		= sm8650_ufsphy_g5_pcs,
+		.pcs_num	= ARRAY_SIZE(sm8650_ufsphy_g5_pcs),
+		.max_gear	= UFS_HS_G5,
+	},
+
+	.vreg_list		= glymur_ufsphy_vreg_l,
+	.num_vregs		= ARRAY_SIZE(glymur_ufsphy_vreg_l),
+	.regs			= ufsphy_v6_regs_layout,
+};
+
 static const struct qmp_phy_cfg milos_ufsphy_cfg = {
 	.lanes			= 2,
 
@@ -2371,6 +2467,9 @@ static int qmp_ufs_probe(struct platform_device *pdev)
 
 static const struct of_device_id qmp_ufs_of_match_table[] = {
 	{
+		.compatible = "qcom,glymur-qmp-ufs-phy",
+		.data = &glymur_ufsphy_cfg,
+	}, {
 		.compatible = "qcom,hawi-qmp-ufs-phy",
 		.data = &hawi_ufsphy_cfg,
 	}, {

-- 
2.34.1

