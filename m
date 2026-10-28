Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793190330;
	b=VHPMA1A2rQdqqAsa6cEe9PXyuT9wXDg5OQkTh8LN4+TBkpsXGsWwkWqlEgRfb26rnV2Y
	 idzMmVcY5BoaNcBlxM9VTPo7tPIr1S3m5pUPqCzezGmseLpbJvaC4BKPjN6chuiw8h3uN
	 CCUQ94n8DbyAHjD997TZamExxWcHNw1ASEbEXwQYgVHPqIThAlg1BCyj6/JlYc1v2WdEx
	 e2aflv31h4MWbGZClb7KHIlqGd7Tc3hkf2K4OGV0Vu4eN2+7Zg3hHpZdwsYiteq3MeLzD
	 PsnOxElifS1XyTx0gR1D1Yw6w7FykSanZ2IBb3a0dlrI+fVyd/HiBiYJNGNnUjj5O2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793190330;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=u+aOGSLnsirSIlKBqojLhK2+vD6OvbhOz3Q4h4cNqXw=;
	b=twjKt7DESakquJGZzFWixV8TUmkYqFuK4PPLwFUg8EtAgHE968m9cvEIkC9EBDLQsgB8
	 RroFhlYxJUOhRdObl3HAcIBpnZ+hzyYBO8D2/G8SAQyBl0wQ5MIvkd9WJQ5S/rpx9/OcZ
	 H9XnD3OpIFQgJzyPW4+6A6RTZ1pvGvJtWIsHZn98OY2kvZNHUm6cn8pk9x/R+2Cy4asVA
	 mx1GeUtsOHUcBrwpAYONIJS7SWOP/slv+YuhWKGOdzSAXGWEoRMj2o0zkubqKnCSt7hd7
	 cIfD7GqTl9Q635YxFVBtTStBuw6awGOPW2Yz/5h2eijq1CghlVelwdSBfp+wzgIjA0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b="mJp16ic/";
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=YnUWiIXU;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139EB606A32F
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 12:25:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 139EB606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=mJp16ic/;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=YnUWiIXU
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69SBeAOB1606934
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 12:25:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	u+aOGSLnsirSIlKBqojLhK2+vD6OvbhOz3Q4h4cNqXw=; b=mJp16ic/e1pBzQMY
	EJchT49oyLZ3HE1a9y5bUMvYqG0bnZFnZm/j54LfatL9ApxPST2kSKWkRAVZbxh1
	oNK03fStBFnskik5Zog+X6FGKgCnG8QAgBPFrL0zcbu6YjM9W5WUARHlMf61wI7v
	CQWdgdYH6aK/b7fqQeqenkgJI7mUZ3+mtR47PWlXXgge1KBter98uD9rhB8eu1DD
	D4NTCsslqxRwuWmMfiREYiP5gS6C/EuXuz+ixRX7LcKm3jLGM7u9oPdW60854I5b
	QjD6epgVJmzsplxNgRULEsbtO/42/is3d/BaoE7aIAIU9oxOUrBayDlTfMOy7P4+
	Nz2YZg==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hk7g7j4mk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 12:25:28 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3ad53f538d2so836847a91.3
        for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 05:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793190328; x=1793795128; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u+aOGSLnsirSIlKBqojLhK2+vD6OvbhOz3Q4h4cNqXw=;
        b=YnUWiIXU+pVswZQZ1U7iFi2TYrMugnXV5JHZX6JxuGNdGusfoM+pC+9bd2BCyQmqcr
         YsVfMW2/e/tPorVUonbWKY+dcD4f9sWr2Omn1q+NfOSymE5/AaX0lz1Zx5EbyF/ztVHn
         Gh1sYh4i3JL6FYsRQhi7n4rugH7lYW6iXNDI3mXPOEaWrzfshS3VMKMXeM3v6u/RZvkd
         GDmvUYnO0D9F/Ianup98gCCcx5mBRsC43Q6arZc+DzHT1Stn7dABzFeOJ4DadsDxkFN+
         OaZroqVyVpKjvOF1nQvgYskmcyAzCEjATkoaKP6k97gT5hR2qnRki97tw6jhgfGAJufS
         M2pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793190328; x=1793795128;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=u+aOGSLnsirSIlKBqojLhK2+vD6OvbhOz3Q4h4cNqXw=;
        b=JEvjuwjj56VvVq9n1OtNQ/gJhg8NxeRZjGpUbg5qOpoyFdHxicDzlbRL6XHSP+5BO7
         IgrCMTvts8LAZSBtS24/nvjYmGNVAcli10Kkfo+iwiKz496V2yAtOI+qVWbr2oeS+jBh
         Qkyq7AqvMSCtxK8cmOUQJeCMDyk1HCtfw49BzgMOR0o1cbvcxiOWhfjuX9ov13/vvCQd
         Pn8W3Q+pfp6NuxO0AI8v/bL/cWe7qZ+WSShV11N1OIeziY5pimIL31XhEB6fIxrf5RUc
         zKmkS+XUEHH/fCAgTVXfhmLpZP7wW5vIMPJC9+S/hB2hREFhgrYISujfUzEiCCB8+KkW
         cq5w==
X-Forwarded-Encrypted: i=1; AKwUvBwo3V326h1y3yqp+M6vdbI5Zfmh2rky3qMAspU5BtnAyFudefHSTJamq2bEcNqgVI03/mpL5+W6hCW+@vger.kernel.org
X-Gm-Message-State: AFq9FYLoz2DlvSOoHG+DCwYAECdfbY0rUrjegK3YF/RnLmximmB+IvrJ
	ejhIpIG+giHZ9Urqe0bVef6ZQnNmQBAfnorn/53XI42J8U/7YXEwOPoJp1xPSeSH50H1BwQrKjs
	DY8NXpdYBU704LF0fdVMdZrdgsHYOL2XZgVftjf3AcuVxUCXe0w4D0s1B4ly/mQOJ
X-Gm-Gg: AYBFou2ccPhStnLE6vBLId3MEU7maYHbwXu3ZbeKwk2ijM8TgAcvDxfhObAqJyHMt1o
	LgKayuZKGpkZ/O5IzW7sunaeKVK80qKZadr1azyGav61KlmAkePhmM1iPfcTDJ5ZGLrekxv3ZYk
	xQBVheRMjp2BN0Xubf5aVIHbJnelQ9otWOoqPhzOuPbbq0GJPGIac46Tma+PScqTdp/z/4HGi8v
	7PD0LF8sj7E8HjIe04T4xA0Qq5vxgiKwdQx0IsW2pP/hFX3vUhmnijLSdlD/9uzdbWi8GvZ2UZv
	HLJ+8DAc6YG0l4O5+8uVE6QDl0h1Oq/Ivh/RwkvMLFLO+FXsqxOtD2DcthWsjDLfv9bPZAhfmBP
	nTLRAk4VrOWnu8GzowM353gM49v2HDEkbFF4UCNnU+4x5OavjU25IYMLzJ9Lw88WRhtZtQ5VyRB
	U=
X-Received: by 2002:a17:90b:2641:b0:3ac:80dc:f41d with SMTP id 98e67ed59e1d1-3ae581d3cabmr1553036a91.32.1793190327809;
        Wed, 28 Oct 2026 05:25:27 -0700 (PDT)
X-Received: by 2002:a17:90b:2641:b0:3ac:80dc:f41d with SMTP id 98e67ed59e1d1-3ae581d3cabmr1553006a91.32.1793190327249;
        Wed, 28 Oct 2026 05:25:27 -0700 (PDT)
Received: from [10.213.101.15] ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae5a9f287fsm2995819a91.16.2026.10.28.05.25.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 05:25:26 -0700 (PDT)
From: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
Date: Wed, 28 Oct 2026 17:54:46 +0530
Subject: [PATCH v5 1/3] arm64: dts: qcom: glymur: Add UFS nodes
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
Message-Id: <20261028-glymur_ufs_qcb_enablement-v5-1-09cda5e3bab3@oss.qualcomm.com>
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
        Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793190309; l=4404;
 i=pradeep.pragallapati@oss.qualcomm.com; s=20260911;
 h=from:subject:message-id; bh=lx4QDJQ8xne6p4Wg5DQ9+pgRxdE/BlGcSZZOdqlsUKw=;
 b=4wGgxUttx81ECAd5ykhYaNl9cWeYwlP/VcUOsW2Y4ot7QldEIOBNiNMhuoICy/OxfYK/7NXE4
 sRNu65/MvvbAhwRu1RwX+hQA2ymrLWqxz6r5960aIlzn9NxpJwUbpW2
X-Developer-Key: i=pradeep.pragallapati@oss.qualcomm.com; a=ed25519;
 pk=uyRUsge8nQMwf3iW/e/o0U8z9nWLCMm1MGKxEftztic=
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI4MDA0OSBTYWx0ZWRfXxVtSFaBQ5fYP
 ILFZGpPC5V7ty3tRuco6m+IhUH9wD/HpL5Ru3BfQ7LNv1n/h5ri5geH+qOFAQI0zgs0DsjbWgbG
 OPXV5/z/D3cFqFY5kU9R4X7YDfYsg98=
X-Authority-Analysis: v=2.4 cv=SoIFe/O0 c=1 sm=1 tr=0 ts=6ae1e9b8 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=7sHo3vQ6stv6frjssEUA:9 a=JqOrBNmfTE-P4NNt:21
 a=QEXdDO2ut3YA:10 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-GUID: 1QgENYEOTtE8OxKmUSV6acODL2o30RxI
X-Proofpoint-ORIG-GUID: 1QgENYEOTtE8OxKmUSV6acODL2o30RxI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI4MDA0OSBTYWx0ZWRfX9khEbxNCRszU
 qmvLoJ3C3slUBoYwQLxFvXJ1pOJmCsRFLb8yOwzzxzI2rPvVDrW6Y0hakETxDd7bDz1ZEa/gVtm
 UOM3OkBCPLcPFKUO2kyzp9/T7j6x5Nx/OPgrEgoCAirDju4AApl9R7mw/W9zkWMeoODac9wmLKk
 9eWyMzz5vFLLwxIo1gXSw7xc/Yq5yolroWtYuI9WkkOnQzmssjsCxFLVp76rZwZvsOyczvWnXFx
 9E9DktfPhzYh9aQ8cU/euLbLFsCiTnf/CIth6O2lLSXLcyhpFiesxuUIGJ+Q8PcfgMosNdK/DDA
 DBfA70GZHOjyZAhtmZopVjRbgrElomaHy9mpsRoh8S8vHylx5Gy5SrCEDXbFEvhzOt/z66qfPFv
 tDrt9uQjhA1cOTFTjAW5ZE8IsARLjpDjv7WsPN283kQWBOMqQk4nvSnT+GIiexe7P694mXa83RZ
 v3kvUlgNo1yL1ed4hmA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-28_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 spamscore=0 phishscore=0
 impostorscore=0 adultscore=0 priorityscore=1501 clxscore=1015 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610280049

Add UFS PHY and UFS host controller nodes for Glymur SoC.

Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/glymur.dtsi | 125 ++++++++++++++++++++++++++++++++++-
 1 file changed, 122 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/glymur.dtsi b/arch/arm64/boot/dts/qcom/glymur.dtsi
index 65a398c0a992..049fb2226466 100644
--- a/arch/arm64/boot/dts/qcom/glymur.dtsi
+++ b/arch/arm64/boot/dts/qcom/glymur.dtsi
@@ -811,9 +811,9 @@ gcc: clock-controller@100000 {
 				 <0>,				/* QUSB4 1 PHY RX 1 */
 				 <0>,				/* QUSB4 2 PHY RX 0 */
 				 <0>,				/* QUSB4 2 PHY RX 1 */
-				 <0>,				/* UFS PHY RX Symbol 0 */
-				 <0>,				/* UFS PHY RX Symbol 1 */
-				 <0>,				/* UFS PHY TX Symbol 0 */
+				 <&ufs_mem_phy 0>,
+				 <&ufs_mem_phy 1>,
+				 <&ufs_mem_phy 2>,
 				 <&usb_0_qmpphy QMP_USB43DP_USB3_PIPE_CLK>,
 				 <&usb_1_qmpphy QMP_USB43DP_USB3_PIPE_CLK>,
 				 <&usb_2_qmpphy QMP_USB43DP_USB3_PIPE_CLK>,
@@ -4102,6 +4102,125 @@ rng: rng@10c3000 {
 			reg = <0x0 0x010c3000 0x0 0x1000>;
 		};
 
+		ufs_mem_phy: phy@1d80000 {
+			compatible = "qcom,glymur-qmp-ufs-phy";
+			reg = <0x0 0x01d80000 0x0 0x2000>;
+
+			clocks = <&rpmhcc RPMH_CXO_CLK>,
+				 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>,
+				 /* UFS and PCIE4 share the same clkref */
+				 <&tcsr TCSR_PCIE_4_CLKREF_EN>;
+
+			clock-names = "ref",
+				      "ref_aux",
+				      "qref";
+
+			resets = <&ufs_mem_hc 0>;
+			reset-names = "ufsphy";
+
+			#clock-cells = <1>;
+			#phy-cells = <0>;
+
+			status = "disabled";
+		};
+
+		ufs_mem_hc: ufshc@1d84000 {
+			compatible = "qcom,glymur-ufshc",
+				     "qcom,ufshc",
+				     "jedec,ufs-2.0";
+			reg = <0x0 0x01d84000 0x0 0x3000>,
+			      <0x0 0x01da0000 0x0 0x15000>;
+			reg-names = "std",
+				    "mcq";
+
+			interrupts = <GIC_SPI 265 IRQ_TYPE_LEVEL_HIGH>;
+
+			clocks = <&gcc GCC_UFS_PHY_AXI_CLK>,
+				 <&gcc GCC_AGGRE_UFS_PHY_AXI_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>,
+				 <&gcc GCC_UFS_PHY_UNIPRO_CORE_CLK>,
+				 <&rpmhcc RPMH_LN_BB_CLK3>,
+				 <&gcc GCC_UFS_PHY_TX_SYMBOL_0_CLK>,
+				 <&gcc GCC_UFS_PHY_RX_SYMBOL_0_CLK>,
+				 <&gcc GCC_UFS_PHY_RX_SYMBOL_1_CLK>;
+			clock-names = "core_clk",
+				      "bus_aggr_clk",
+				      "iface_clk",
+				      "core_clk_unipro",
+				      "ref_clk",
+				      "tx_lane0_sync_clk",
+				      "rx_lane0_sync_clk",
+				      "rx_lane1_sync_clk";
+
+			operating-points-v2 = <&ufs_opp_table>;
+
+			resets = <&gcc GCC_UFS_PHY_BCR>;
+			reset-names = "rst";
+
+			interconnects = <&aggre2_noc MASTER_UFS_MEM QCOM_ICC_TAG_ALWAYS
+					 &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
+					<&hsc_noc MASTER_APPSS_PROC QCOM_ICC_TAG_ACTIVE_ONLY
+					 &config_noc SLAVE_UFS_MEM_CFG QCOM_ICC_TAG_ACTIVE_ONLY>;
+			interconnect-names = "ufs-ddr",
+					     "cpu-ufs";
+
+			power-domains = <&gcc GCC_UFS_PHY_GDSC>;
+			required-opps = <&rpmhpd_opp_nom>;
+
+			iommus = <&apps_smmu 0x460 0>;
+			dma-coherent;
+
+			msi-parent = <&gic_its 0x460>;
+			lanes-per-direction = <2>;
+
+			phys = <&ufs_mem_phy>;
+			phy-names = "ufsphy";
+
+			#reset-cells = <1>;
+
+			status = "disabled";
+
+			ufs_opp_table: opp-table {
+				compatible = "operating-points-v2";
+
+				opp-100000000 {
+					opp-hz = /bits/ 64 <100000000>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <100000000>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>;
+					required-opps = <&rpmhpd_opp_low_svs>;
+				};
+
+				opp-201500000 {
+					opp-hz = /bits/ 64 <201500000>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <201500000>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>;
+					required-opps = <&rpmhpd_opp_svs>;
+				};
+
+				opp-403000000 {
+					opp-hz = /bits/ 64 <403000000>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <403000000>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>;
+					required-opps = <&rpmhpd_opp_nom>;
+				};
+			};
+		};
+
 		cryptobam: dma-controller@1dc4000 {
 			compatible = "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
 			reg = <0x0 0x01dc4000 0x0 0x28000>;

-- 
2.34.1

