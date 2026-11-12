Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794523186;
	b=IvCQTfeaxeghhXTWF2fJcxtACAXvmJlQXBqFy0iJP46m034MLgp2X1WiogilrB9YnXXV
	 KktZkX9/c8NLZYfV1mStlzzRlo8NAcWM9Klaw9XnkFg1SJooN6CW05bDTEODDgbvrJtaQ
	 zVMZ0vfdinPDHAbnpAyCGHWVajngoov7wYvuIDoetycWk+mmq+JsIlAYsh/FQebMYh2n1
	 e0XWLLbsTKhzcKnkuYflebXpMxIjAlh2yxQZIXpgWRfLOcBwEyiksZtqFDwy2s1uI7zSi
	 K+1Bruwe2Cg3baAPP3QTsrJlfPS/688foUvVb39zwER8XBb9ceMBNIqsTQDIIPOM/kA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794523186;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=L2FQwINb04s7mJ3OBtOg2oqHSpYWCSQGkL/MPOtCiMo=;
	b=PA3FYTNxhgF+ptkyc1FwzfAv2n/XJzTiPXhUosYxPMpEDZkY4+I8cZ/oHt2kImAeDd+p
	 7bQ6OLKNFwjqVz8gFLF8XZl8Hd3cvIsMHzUWtmNUevCPhOAzNBApewER2FwaXfN6KUydu
	 1/yoKHdbmyMZ7/0Bh2q5H7DKnY1Lpjr0qwPLUWkSXwkonJOHRViq248Cjre+0HzVapJK4
	 FQF+GUIxNfvZKM3rKgnbW6vdWEu2PHGBUqT6FGM5wmAvG5lMhClvX9dGv/4HBcobOwsaY
	 BhqA0Wnf421WovKVviH0Z1F2CfBWvXqdrSU94J5kGWWE2AAdy6XIEl99REqeIwoGT7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Q3xZNhkB;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=dwzFUtuJ;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E905E606A32A
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 22:39:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E905E606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Q3xZNhkB;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=dwzFUtuJ
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ACJZWFA2266578
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 22:39:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	L2FQwINb04s7mJ3OBtOg2oqHSpYWCSQGkL/MPOtCiMo=; b=Q3xZNhkBWFe1lWE4
	AeuH8BITv502qgQA/TRAo211X9vwsHk+KQQlAR14tBWzdyvAQPKufqKCH90hoe/S
	b/wTZ01ZFma0DSVxlG7EFUhW2NCf6x2I+IL8c1N4leJhK9YWc6opA2O53L/+nDtD
	zX5XHeB1lhiF7COt3FtfX4JJZO1EudxCiIQDj0aBz/TcJUxmqXkPS/G3Aavvy5vO
	/u552aoPrquOBEAIYJ6a4rKMDpvq67mYgVxTPuJOOkj5mn5+VK23ULSU6njl/ZZH
	0GSuQj6pjXgjDBjMWdXnHo2rrkA56S2hkvCjhCANCACcX4l3Gl7mIpCLT2PofdFu
	C0m9tQ==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hw7nc3jnb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 22:39:45 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-36d1353fdcdso1446681eec.0
        for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 14:39:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794523185; x=1795127985; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=L2FQwINb04s7mJ3OBtOg2oqHSpYWCSQGkL/MPOtCiMo=;
        b=dwzFUtuJ7ekdHlCB0W6m4FY+Tv/N3J/oXG1qgwuVTWz72d7htWNEnPF/UU0HqI/KNt
         enO0kjufy1EFhnVarx1pOl46rHvcJJkiMlLyAWF33O2oEWoHZddiXIcfIO0fizVBzPkZ
         HOAHB076y8it1Td+OsGscVrarLk4l8yyMMDPuLgR3SE3u+ov0qmvLElgrixDBjQMZjiU
         EE05vYEVeFFB89vEuRxcZo3Yh9Xo9QgC8eeLEb8NS+UPOW5fmosNOsWhEsNmuE/+/rJE
         G+jVJ2lvqkTq70CkpdJazFS6X7PpmViHMDj0wkSKV/kBr/tQNPDeS2C6SdlN8sW/Df+n
         uydQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794523185; x=1795127985;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L2FQwINb04s7mJ3OBtOg2oqHSpYWCSQGkL/MPOtCiMo=;
        b=JlWSqQX8dznpz/b6VCB6dyrVYsALsCWstvWrtCdGoMww6+HCSC5jlyr0uJYzob1Bnk
         mr5w5N4OJ0Ugw2c32G+jxmmLSIUAGpV0c1BB0wDd638XZ4R1fbUFM0T8mXFXQ5x+hR5j
         S64+CTh4i6cwVc/s8CC1iHMn3coFJVS/6FUXN/o5Y3k/VhcmyVm2w8waNMevxdvP37hv
         PRh9Zrn+2zrpDA2XUjoJysEZ/Li/VPFEdwExCEc4ZNwETbpheKaEeHcn19Skk3vQptmM
         ui0dKcGCE2SNoprip6q0G+kkPTaQ+MSYwSuxV4m904tkpNbFItwo9CW5bFjXTTx1G4XJ
         4lsg==
X-Forwarded-Encrypted: i=1; AL+hErGPcZ45fjavrc0dUbzglLRXeCdzqs43P8MBQzUuQlrNNRH+KMHaGI2v70uqfa1y903m4b8Wu54W2cmV@vger.kernel.org
X-Gm-Message-State: APuU4Z/iB5SgcXWXnWgkU25dFW3yynUWTyeweJmcehJRafikezgG+RJG
	wgbzFqPyiXvPuo1f/4UNYzeTf/xIs8WybP5QGu/ukYSvEkgX1LIlj+0Ipvo0XsO6A5GJknlg82+
	Z+dw/NPSuB23f5AV+ZnMDJ2J7HrNCCZgrrSUEpfT1dvX7Z4AyoD/Hc/UEiSpyAJMy
X-Gm-Gg: AYBFou0Yusah8Jnp+sbUq1KAhcXvV2wlGnL5f6+4Q7DGWGkKQs1ZFzSt1Bdo+BaIiX4
	JU2Zcfn5tnpIP8Gbs6DwwiahTZIlkWW6JIXlkc9lGk+QP5fwYPg/6shhGzzgpBcG6cNVFXqrXve
	GeLUUE3fyeXtGalJ692Gr0vCzxlBPW2Q28YipTh+HQwRLi6IHUUhLpWqGvmJe+YxWncOQ2l3u2E
	pShpjndyK8NANONLsVhmaVVxMcrmctg/O6xm/kki3Hebx1+4HudUhGuihZld/eWZmsc5FwfR9fQ
	Fp1emAbAFHYLnZ9NQ/9ZFsPMVt+CRDQZMBvbnDaoYZWaMLkkTAsOzQCm7H+i2tVVgYVSwDFggvI
	bc+JijWN54HCO6k1rgGh87SjkIIljXVk878avWuSQxSCO5m/LgIpuZkMUiv+DzL9q3Ldu2RobLi
	DqTtONYKqqtg==
X-Received: by 2002:a05:7022:f503:b0:166:b307:5855 with SMTP id a92af1059eb24-1b502fe3953mr895747c88.0.1794523184442;
        Thu, 12 Nov 2026 14:39:44 -0800 (PST)
X-Received: by 2002:a05:7022:f503:b0:166:b307:5855 with SMTP id a92af1059eb24-1b502fe3953mr895736c88.0.1794523183996;
        Thu, 12 Nov 2026 14:39:43 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031468b7sm2333496c88.5.2026.11.12.14.39.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 14:39:43 -0800 (PST)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Fri, 13 Nov 2026 04:08:31 +0530
Subject: [PATCH v13 5/6] arm64: dts: qcom: monaco: Add OPP-table for ICE
 UFS and ICE SDHC nodes
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
Message-Id: <20261113-enable-ice-clock-scaling-v13-5-258dc817bd63@oss.qualcomm.com>
References: <20261113-enable-ice-clock-scaling-v13-0-258dc817bd63@oss.qualcomm.com>
In-Reply-To: <20261113-enable-ice-clock-scaling-v13-0-258dc817bd63@oss.qualcomm.com>
To: Abel Vesa <abelvesa@kernel.org>, Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <mkp@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulfh@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>,
        Abel Vesa <abel.vesa@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Proofpoint-ORIG-GUID: 8s2qHZwo_FNQZuSlQs6I9R-AYkXpSYz1
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDA5MCBTYWx0ZWRfX85kv/Bju7Laq
 /pY534QiCGhtD3TcCT686Lq03lYqCGLAMbFZxVaqUKuNPQ8AXA9bJHsqNQ7AFyCp8lMruD3Cr9h
 faMwCJ6ACLMY/Q6GaZ/Nao732slTPB8=
X-Proofpoint-GUID: 8s2qHZwo_FNQZuSlQs6I9R-AYkXpSYz1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDA5MCBTYWx0ZWRfXwnOpMMeQIyhB
 4pfsW7wTf3wdkMOMPJfaaye8zJuQ7+/Rm2WRlI8M2UOiYaMisfW5g0quWf9Mjgi0Jm7Wxd+ZDM0
 WggOebvm+/aq6fR+PjptUniW0odh2XGnteqIJB2+GSNEbjYj2HZsI9jLFDPHFZLPFpKkkWa2ZYC
 K8iVa+fsOPFYWHEMBK2pqjmhossK9QRJ+6sYXqRL11cADuuIy55Jh3rHWXT4vawXEuxdR6/sNEZ
 8V5bxOqyqsVNemHnvFzbt4Ebyx7bEYK33AP1l016MvH0VnaMqftHzFio57/IjUjoyiFCvZFhSoH
 LXFQplsCz5BbSYeTs7gff1dbhBCzeYbIv0jNGLDghHF3f69m3bjfqviQKBRlrhZbDKKVAuiGzrU
 N5GiImeJIwwaTu4MrXp78ObrJliZVZK/uuDyrDEi1tv9LHRHleIhFzbZBpadVYNevH5a2WTrvvy
 vqcsa3W+004TAWKejEg==
X-Authority-Analysis: v=2.4 cv=A8b5rKWG c=1 sm=1 tr=0 ts=6af64031 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=IFdraIdqUsMg42QbtkkA:9 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_03,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 malwarescore=0 spamscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 suspectscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611120090

Qualcomm Inline Crypto Engine (ICE) platform driver now, supports
an optional OPP-table.

Add OPP-table for ICE UFS and ICE SDHC device nodes for Monaco
platform.

Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/monaco.dtsi | 37 ++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/monaco.dtsi b/arch/arm64/boot/dts/qcom/monaco.dtsi
index 3541313a79bf47fe27499f6dc370cb778d780a08..d7e2038854b0bdcc91d65d5712290c690e772258 100644
--- a/arch/arm64/boot/dts/qcom/monaco.dtsi
+++ b/arch/arm64/boot/dts/qcom/monaco.dtsi
@@ -2725,6 +2725,27 @@ ice: crypto@1d88000 {
 			clock-names = "core",
 				      "iface";
 			power-domains = <&gcc GCC_UFS_PHY_GDSC>;
+
+			operating-points-v2 = <&ice_opp_table>;
+
+			ice_opp_table: opp-table {
+				compatible = "operating-points-v2";
+
+				opp-75000000 {
+					opp-hz = /bits/ 64 <75000000>;
+					required-opps = <&rpmhpd_opp_svs_l1>;
+				};
+
+				opp-201600000 {
+					opp-hz = /bits/ 64 <201600000>;
+					required-opps = <&rpmhpd_opp_svs_l1>;
+				};
+
+				opp-403200000 {
+					opp-hz = /bits/ 64 <403200000>;
+					required-opps = <&rpmhpd_opp_nom>;
+				};
+			};
 		};
 
 		crypto: crypto@1dfa000 {
@@ -4890,6 +4911,22 @@ sdhc_ice: crypto@87c8000 {
 			clock-names = "core",
 				      "iface";
 			power-domains = <&rpmhpd RPMHPD_CX>;
+
+			operating-points-v2 = <&sdhc_ice_opp_table>;
+
+			sdhc_ice_opp_table: opp-table {
+				compatible = "operating-points-v2";
+
+				opp-150000000 {
+					opp-hz = /bits/ 64 <150000000>;
+					required-opps = <&rpmhpd_opp_svs_l1>;
+				};
+
+				opp-300000000 {
+					opp-hz = /bits/ 64 <300000000>;
+					required-opps = <&rpmhpd_opp_nom>;
+				};
+			};
 		};
 
 		usb_1_hsphy: phy@8904000 {

-- 
2.34.1

