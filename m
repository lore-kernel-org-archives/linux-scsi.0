Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793190340;
	b=uuIoa4WDkye1mz5cjod/1oSthaySZsAG3cR5DvejsTJ26DBiSDuyXQl+CclvKuGQGMYL
	 LW+iBt6SMZRzTLCrJTp7kv57CHn+yjNg+ozRjuRSkMCK5LQh4vyEl48RhFSxx3OUzLRRo
	 GuIgdVeO6PLjg9U82MhWHnZeVFjouTUE56apg1mVmwrKdGQ0thdOhxnd+kK/X/9fKvVuM
	 TJZ7a62v+mOTOynAI+ANIwNyvWhkzLBwiRvkaj/RhHMHBtvf1+17k5wm3lPcDk9Fmlp5X
	 ssdlPLAOLbL4mf8ghsz1eX+hXVulG3cUTGIZ6T+ue2vOln7mPEHQcJ5rjmO+R8q3hPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793190340;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=IE7TTEPp+mYjYOJnw2S5JdN9e/VGEB2SwjVCAm8BKAQ=;
	b=2TB2DGJw2kopzM0IUv2fhaVRsnbSM6goFVkr/hRCI2Mn+lcdOdbq/coNJFTD6Ruvt9vc
	 pEGMY5G6GaV24ORHnqdXkAj0l3n1VMSX7Tnxt44UwkIzGMm5oHC06VikZpKquWhx+Pi3A
	 SMS8LlHxKgbVOjKHIfWJWInaoz0keYBtWDRnQeJuAmSGm5GTk05XwwAAxpqJR/oP/XXm6
	 /dp2ZqQxC5aaM38SUoAB6dy6FEogLbsTJr0HE9LNTpI+ANipQzkyW7OqmidMt95s24SxU
	 2YXdS+EXddFOfW1jsaTftL0qx2lPAD52HzYGNLbgaHA3Tqn9f3po/M7Gq/0Fu/I+8lQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=iz2BlZf8;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=BDJwA7EA;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858AB606A321
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 12:25:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 858AB606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=iz2BlZf8;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=BDJwA7EA
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69SBe0YF4154661
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 12:25:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	IE7TTEPp+mYjYOJnw2S5JdN9e/VGEB2SwjVCAm8BKAQ=; b=iz2BlZf8W0+7zF8k
	YVFXLVXVXs+KbPcx0z96X3Maa38IR0tPPEcphuCMRQrxA10L5Bk34Qh93o+5c4jl
	mr23IQ64YsoKgth3gFJx+bSx8yinUqjz8luZA6HdsyUf0w8F9ZHeX7CSsOHCiFio
	M22diJ5ZGF7LY/bFN6Q0LI7CFFGKBKZEwGWUhf8AvAWiXgvlbmaFhsszv3CYY4Gc
	ThsqEllfEy4/sahrUG4DW2LqLyntN9F1c0xXf1pJuznNqpajbbhmVRnD2kgQdi3G
	Fwz2bCRFTQ/4dyqs61p4GZzzIFVdukKdCiAHfD5hLvu+o7JjsH0XSAfHRJ5qFI2c
	18ZUXw==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hkdsp0s3g-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 12:25:38 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3ae59682799so628787a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 05:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793190337; x=1793795137; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IE7TTEPp+mYjYOJnw2S5JdN9e/VGEB2SwjVCAm8BKAQ=;
        b=BDJwA7EABuLr45A/7E5+2bdIPe21PynxeB6ukXUCV46QGjE3iDBZZ4dwEuI0uEnk8E
         Qx2eyb/oAd152h+PZuQdxjWTymee+XPgv/43iwDgu7uXAKTbdE3w4tJUL65Z2ms/gK3F
         Mvh/tWQ/pCvQ8PLjjnnNZdi4WxoFTiUeHER+itsGu0qt48khmYHdYyH/AMKeMkBECFmi
         jDFYO0k8J2Ymy230zzUTDHMBe3qO+uN9PYgI/bdvqR+vwDo0xT6YHDSdwlG9uEHxokG7
         +Yjo11BWactCKpX5Hw+z9SVKvg21mB9dSYnYG2iJmmk0LdJmFvZuTImAM0aBGsi9UHLN
         YJfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793190337; x=1793795137;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IE7TTEPp+mYjYOJnw2S5JdN9e/VGEB2SwjVCAm8BKAQ=;
        b=iFa7zNGEhUIxffJYN/AYMZ6+5peFqFrNS09re+MQXLicfOsRhir8NrQxDlaB1NL5G2
         9dTkRi4sZSy8kK8UlYkrJk1LbvFJ6yjDTmJLyJfN6AGzwMh2ShMeyxc9+PBkRcp1i3M0
         t1+EVwwNmKI5PZRyO9G1EOIybkXLttvTZ1tX7yn29oBIo/NI0l9M33TZ/WP5OIuq/qOW
         RQ1hwW1KC6gSGYufXzR/Jnklfzx9BvF7nopt7fj/aue9UrZ61O2fvImn/KDo7gJjM+vV
         32WOjHojZJx6Q2Jrqxi4rsp4nVO+TacbVFtH1kWRpy6pT3RW/PYJAP0apIl21cCTSfOq
         sX/Q==
X-Forwarded-Encrypted: i=1; AKwUvBw/lnsA9iqQLsAeGCd6w+fOqpp3dmF4N4S284oTpE+UlDNaM2G8YuuMtJIlY7dqLYVCnQY8lqSHUbJV@vger.kernel.org
X-Gm-Message-State: AFq9FYKlBxS2RHYSru1JUbA/cie5TVD9VkfC6E3I7PiCvhMxlJW/OmR1
	ztsgrU2XvM0YCC0NB0/I2v59EgkF+5cO62C/PBYa8FxTM54hhepzJTrKhGb74vdTkog+NdtdB3L
	iL7QtMl6PmN+lWGwfDyjugI/A6OjTx+dTwApaUOXaVAEADN1/OnZxD76wSBEw5Yty
X-Gm-Gg: AYBFou3AVSpWMQAPaM5hDa3ndOEKRSBET52bnFu25oKmQSZMonWc5pYL/XBgchKQhHO
	H5BN1DHPXT1PFI937Y3icnjUb7hjglUw90esM6Srz871cqOjpsnVvKvEmYvzsa+euWxL8igBz40
	tzZbbYQMndFyIaTUXaGNvWmTXgBybNV5bmsaK9XIZOh/vFoyjTwXuUUwV0moZZQ/1JbYVOdTzRL
	I6FZcbly3sHDA9t+oiNHTQEN9fq2JQ0gZmamD3cHwVOWw09fAouDraKwv8xmO0lt0GGuUDDQK7a
	hkogTY3f42YS79AwH2TXXN+3s3LtIojicatk+iGL+2zi/zGNvywUezKVpBpnSMoVBAcGUPYwDgL
	iV9G/W2TSh68mHttubfAbBSDuzhxhg9BQBg6jUL4BICp0CecEEq99vG324RmIPtlobiRG/6Roqo
	4=
X-Received: by 2002:a17:90b:1f8b:b0:3ac:80dc:f40c with SMTP id 98e67ed59e1d1-3ae57f9afe3mr1579928a91.14.1793190337334;
        Wed, 28 Oct 2026 05:25:37 -0700 (PDT)
X-Received: by 2002:a17:90b:1f8b:b0:3ac:80dc:f40c with SMTP id 98e67ed59e1d1-3ae57f9afe3mr1579906a91.14.1793190336827;
        Wed, 28 Oct 2026 05:25:36 -0700 (PDT)
Received: from [10.213.101.15] ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae5a9f287fsm2995819a91.16.2026.10.28.05.25.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 05:25:35 -0700 (PDT)
From: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
Date: Wed, 28 Oct 2026 17:54:47 +0530
Subject: [PATCH v5 2/3] arm64: dts: qcom: glymur-qcb: Enable UFS
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
Message-Id: <20261028-glymur_ufs_qcb_enablement-v5-2-09cda5e3bab3@oss.qualcomm.com>
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
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793190309; l=1034;
 i=pradeep.pragallapati@oss.qualcomm.com; s=20260911;
 h=from:subject:message-id; bh=qZOq97SsVPti3oQZnFWkZh3c728gDdolT+V4/jasJQk=;
 b=32awDFy7e9HmWnP/20AX4LOq2FVNW52SoyFahYvtOVEkfvhPnZE7dbpNNlkhNLILqGfEZDoro
 gALGuqVM6y/C6OqU8Q6Ccqgwz3pNh/45gLJSlrhnP7l7B6Tg8Jb/iPS
X-Developer-Key: i=pradeep.pragallapati@oss.qualcomm.com; a=ed25519;
 pk=uyRUsge8nQMwf3iW/e/o0U8z9nWLCMm1MGKxEftztic=
X-Proofpoint-GUID: 3RTUni4sMQb_koiwkfakShx85LR0RwdY
X-Proofpoint-ORIG-GUID: 3RTUni4sMQb_koiwkfakShx85LR0RwdY
X-Authority-Analysis: v=2.4 cv=Cssq4X4D c=1 sm=1 tr=0 ts=6ae1e9c2 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=cMKPt8sKVRzp0kMMbBYA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI4MDA0OSBTYWx0ZWRfX1CPaRTATf3Mc
 XmxGsDPVHHEbmjpi9Y32J1CwPnxYzwlMiHdk5slZkyTGmQsKstUWEdvceK6IC94/BZnXk+I4bAt
 O9txpMvWisNn+/aUrj9SdZCNJivjwIi+TxXJsq5TkHTHN9iFkppyjwRSY9z3pQtiOPGDi3RZCy8
 t7DIjbQ/MCS1I71uDaV2TM9RsPTCB/8Z8qKordZSKZYi/SlRLMgLSZk6dphqQBPkwdRw+rLrb1G
 fqKENzpeuY/nd+4JFoUVz/ft2YroNsifr2TOlgAjqs/CWgPe5BDf4PIUtOxYtOVoXir3eNVqH4K
 iz9ybt4vvOOBFNZUYeIZ+mOainJWLZy8FsFWfS1pc3deOFZGyvJYmncuGnOkVlf8YMPuD1s24i3
 zZC3ajixPLYsxzfELIyjvPFqwRyfQg7lbnTIL/FYZtYJtF9mA4A5Izd37VzkP7tMwzpMWzIY+fy
 U8MDoRO+X1vBluEsWsQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI4MDA0OSBTYWx0ZWRfX4NstvPZC/z/x
 ASJsXNUDgSx/g0Tl1O9QcQSmeUhNuSc2KNH4Dg/1GqIJDVRmnWMJiqnh+wLKc+udhvwrUkr4n99
 RISRUiYGHnLqXHfcdqPpAxEXeInrBz0=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-28_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 malwarescore=0 bulkscore=0 phishscore=0 clxscore=1015
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610280049

Enable UFS for glymur-qcb board.

Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/glymur-qcb.dts | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/glymur-qcb.dts b/arch/arm64/boot/dts/qcom/glymur-qcb.dts
index 17d8ff3aed23..f17181bfeadb 100644
--- a/arch/arm64/boot/dts/qcom/glymur-qcb.dts
+++ b/arch/arm64/boot/dts/qcom/glymur-qcb.dts
@@ -697,3 +697,21 @@ bluetooth {
 		vddrfa1p8-supply = <&vreg_pmu_rfa_1p8>;
 	};
 };
+
+&ufs_mem_hc {
+	reset-gpios = <&tlmm 250 GPIO_ACTIVE_LOW>;
+
+	vcc-supply = <&vreg_l17b_e0_2p4>;
+	vcc-max-microamp = <1200000>;
+	vccq-supply = <&vreg_l12b_e0_1p14>;
+	vccq-max-microamp = <1200000>;
+
+	status = "okay";
+};
+
+&ufs_mem_phy {
+	vdda-phy-supply = <&vreg_l1c_e1_0p82>;
+	vdda-pll-supply = <&vreg_l4f_e1_1p08>;
+
+	status = "okay";
+};

-- 
2.34.1

