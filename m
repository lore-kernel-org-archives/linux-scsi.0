Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794523192;
	b=FqXAqRNOVnpiR3xx7kf4N5lBywzx6cr3oEj0A9mZLq9lRj7JS//F195i2nEdJ7jp/RIc
	 lHBuBnFajQPLJC9uzmGGx1LUTI2jEIhqgaLDlWuFV8sbh+wHx6pnd7sWVzEpsSjHbk1IH
	 N3jPDT3pwVvNlQIyF4k7hqTFBw8lPqlFw/eI1477E4gfsxGCaIcunBdimUKM5+/X+ol21
	 xABI1EOJXB6VbZngHWSwT/PAxKXDGdkw8DS8IEkIa4dGT4T/Qi8hBbFgXrYwC8c5GmTmk
	 qBGd3W2/h3rVRS/CphqPfpSXMrQ71vCy6FlpYb9jhMDtRfU6aboUqh0d/vLw5onJ/5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794523192;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=d0jw8JKgv0n0ezdqZ8dsYLNGQSrLdfYWJ7gZlA49lV0=;
	b=xYIsO64MFrED/WGpctteEKisgEfB6e6igal1UB9irP7E0QVBKtSyzpRlnI3+Nkj6utv1
	 43K+dfI5DI0LipTUKei/qC3hkZSITaB0hDXCNQaFmh6+ktwbIrcD2gkFaz0lFTBphC1pE
	 oanNFmkdHkO4dmEhvOTt6fzTtdviE7nrAm7xazu/s2prg3QIkYxTDflIMbu2+Cr3N48B9
	 UzuCFXvhPq1+uOkiNQTbzmlJoHDJ/9lQJkeKc2d9gmT0EcHJCJfiVDZfN4h7XBdhvd/tC
	 x4N37AvKF9wLnCMvalt8Tah8/VEs/1f1S1bU0WD1ulYYt8Ko+qbuY4gzH7YE3vzcJLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=V63K56ZY;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=fj+43oaQ;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7188C606A8AB
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 22:39:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7188C606A8AB
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=V63K56ZY;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=fj+43oaQ
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ACJZluW1183497
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 22:39:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	d0jw8JKgv0n0ezdqZ8dsYLNGQSrLdfYWJ7gZlA49lV0=; b=V63K56ZYhmMmzVzi
	Abvhos0ZhgGq878N66gbiQpvGPsraM5OnL7XP2Qof7LnhO78uTu1exsRapupGRDp
	hMh+Pm/TmhoVmH75rLbqRM+1QJ7PgEs4TWHDY8YslJUW27q4NZNPfes2ZyMQFcWm
	eQdIHslArBMU08yLQUmBmodWUZ30+ah4iOYQp2F90dSK1e/zPAbgX5p8DNBcT1mW
	daqj9GY2wl4o7r0LxHzvNXHNFdHahSPt+wtmp9o3gve3KFMi/gZzLJ+k2lKU7mzv
	lRN+J79LnAsL7YpkNnGDuSps4S6VeNBZ+jV1OgzDabUoqPteaYQBT3zqnFMHS8Rm
	Zzpzgw==
Received: from mail-dl1-f69.google.com (mail-dl1-f69.google.com [74.125.82.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hw6yukp3e-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 22:39:51 +0000 (GMT)
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-1b3ae17c536so212066c88.0
        for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 14:39:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794523191; x=1795127991; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d0jw8JKgv0n0ezdqZ8dsYLNGQSrLdfYWJ7gZlA49lV0=;
        b=fj+43oaQb7W17VghbCtiaJXL6dS3HCupr2yoW0NgM4Vyos/XAZ8QLRD0+BQzivJC1Q
         MT+M1Pk40l1v29lvp6bEoPQc+NLmjchyODP/g75H90zAw+1/IoEht1eveBWhcuXJiNXx
         NixaxkG5edH5wjNmFEsyPp3T9AzbvU5HnLkYlpEaFFfHjwxQWPqzr/5mCvMPrudGNzwT
         Rdwr3QFhXz0uei539IIpqGybtzXauQLIyLuGEEadZRrbtl4gcWBV0TY7U8COKWjC05kl
         PLMxEo0V1n1abVUmLyr4dPqIgsXmwe2ya1wG9pgeMifPxfgZgzO3LpRRWL2fPJYL84uY
         RZJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794523191; x=1795127991;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d0jw8JKgv0n0ezdqZ8dsYLNGQSrLdfYWJ7gZlA49lV0=;
        b=wHzSb5jLGu4cmUj7MreNvkyquoQn5ay1tNPeZ20oNjKAHF7wHwbAYFNXvAE6ytnIJI
         JSZarAN8aGvNVSfEI0T1r1Aztr2GRBZ9fZ1dHLmofL+KlnAH1Ususeak6QI/N2nmP/ky
         sBcd2hSsr5p3ZlDnZJ7tmtwoXsPV7M57x63vGrPXZaRIZJA4/JpYHUM6AnZJ1fp8pKvn
         8Po4vRTDNzjk5FJLoHVGWsibKTU6FYPT97SNebbTvUbnMY3LP2j6GWi9rW64YRzok/wE
         pO4EE6FEvydb7XKFDFMfAsioNwNVPJvD9z/eLQNAkhbC9XA5t8BPdBRPY5VKhlA7UXsj
         oHCg==
X-Forwarded-Encrypted: i=1; AL+hErFQZSV83S5mnmF9ZdnXjnb1E45JuTSPghepnlEcNXF2R+gigjCSmygo4rR+crGvpK6km4396pojFlin@vger.kernel.org
X-Gm-Message-State: APuU4Z+m022CwnGda4dMgAtQeWxUJilA6plafXMHck20AQVRKZ1dopUT
	Fq9Yy6IALGyr9cooi0FdpvjX/QjjZKgP1JVz5b+NiRRXCf+KtFkMxkII0SFBiC0RAXhQMK2b8AE
	3LMmftWPYtihPGjxixaur+4qIF1l/oRExS28luN6oqEockLmONGye+K2Ua3m7FT5C
X-Gm-Gg: AYBFou25a1cIMtVBwgsFFDf120eqeZTf3RQ0BIUxZAhriPVOcjXjJpvbWSn0scomLVh
	NdPT3sccWT+o5+Gwl5cFmcmdMhInZEMinoHmLElr1Nwsry45QIQckjEycEhwo2bTgFRaEcQMwV1
	5bhOMa6k+9riVKubguYwga+oDKTrRTXiJ4IeBi6TSCAv8Tn0ceF7dmdZsmkwQRldqHxWn7duHND
	Dy4HDOO+y6V5oZqLM6PeYJzAVjTJbwSMeIfJdI/T/6FrO2sOXjvBHj1KihCEnlP/Fag3fTHoLCj
	7JeCM9WamwKMSgKr7F4zsTTVg4XCM6bhWll8Syw4aZo6tJNpW/fO+AK9xErjHdXi87S3QHSRtIw
	QZgFhBxjvZK08y3EYk3OYyDbNyiweeczKS0obvBgjg4SWY/JB230cA4tmX6GaH1QJLtUvyJBpSY
	b8NoFuVqdPPg==
X-Received: by 2002:a05:701b:2050:10b0:18d:5ef2:1644 with SMTP id a92af1059eb24-1b5031247b2mr877019c88.30.1794523191061;
        Thu, 12 Nov 2026 14:39:51 -0800 (PST)
X-Received: by 2002:a05:701b:2050:10b0:18d:5ef2:1644 with SMTP id a92af1059eb24-1b5031247b2mr876999c88.30.1794523190428;
        Thu, 12 Nov 2026 14:39:50 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031468b7sm2333496c88.5.2026.11.12.14.39.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 14:39:50 -0800 (PST)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Fri, 13 Nov 2026 04:08:32 +0530
Subject: [PATCH v13 6/6] arm64: dts: qcom: lemans: Add OPP-table for ICE
 UFS device node
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
Message-Id: <20261113-enable-ice-clock-scaling-v13-6-258dc817bd63@oss.qualcomm.com>
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
X-Proofpoint-GUID: voKSPzI2JztkJJCwqILNMYzlTY7fpUDJ
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDA5MCBTYWx0ZWRfX0TxXSumHPK6q
 BqPnDILSP7hRM2PsUeveDkH3RAq0IJR+yPRJKezJLTf9T2YxMFDLDXKbamuiSko4NONiHqLr7E9
 KCHWwoLDS2gU7JK1f4q5rYoxLBcDQPs=
X-Proofpoint-ORIG-GUID: voKSPzI2JztkJJCwqILNMYzlTY7fpUDJ
X-Authority-Analysis: v=2.4 cv=d49gWhjE c=1 sm=1 tr=0 ts=6af64037 cx=c_pps
 a=kVLUcbK0zfr7ocalXnG1qA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=ASeq7m8wwX9lxpDCPrQA:9 a=QEXdDO2ut3YA:10
 a=vr4QvYf-bLy2KjpDp97w:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDA5MCBTYWx0ZWRfXz5JrS3eHw5eJ
 ppLFBbcb5XumFDSIPywKIfWgK6VOWRHalmoAlN6mSBWDmiZ0vdl922qQtM1Fik4bOtMxbqWm4PZ
 AJM59E2K0lxLTyfJvaSij0ynz0Jnj2peu98xS91SCz2Y/rPpp662H53N0fGA9AHlKhRMKhFvVwa
 G7jvXEM+cGNpArOXiKdDw4u0ph+23p4+EXY4yUUxybQ8yBF6P2/jzKCbdR6BwpSBFph7MFTn/vt
 cS2duveDaTepP/b65KnfbwDG4QZIxCpASInMFlxu0JwIxidr/4UHQHQj7Fhu8lIPSUfQxxbQwbB
 bPmRkqUMw5c4uKeJk+YF4CHt9GoXhxgrmy9BXjwzuPfa4kPYnVSWF5oq85bjZ/3Jyo82SEImTQH
 TvE3w1WZe3Jd3MNfRdqyrXaZk95egwz341oy2ko5wWK0umWU8J/t7lVfNnIcx6ZRYai6faIYvX+
 6Xt6I7rKwNeVJzw8KKA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_03,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 spamscore=0 malwarescore=0 clxscore=1015 suspectscore=0
 adultscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611120090

Qualcomm Inline Crypto Engine (ICE) platform driver now supports
an optional OPP-table.

Add OPP-table for ICE UFS device nodes for LeMans platform.

Reviewed-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/lemans-embedded.dtsi | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/lemans-embedded.dtsi b/arch/arm64/boot/dts/qcom/lemans-embedded.dtsi
index 0be39bb9de1e1cdbb7d67a992172861a5a10a05a..a80fd8f96427488c20205c5ad798413aeb53964b 100644
--- a/arch/arm64/boot/dts/qcom/lemans-embedded.dtsi
+++ b/arch/arm64/boot/dts/qcom/lemans-embedded.dtsi
@@ -1840,6 +1840,32 @@ ice: crypto@1d88000 {
 		clock-names = "core",
 			      "iface";
 		power-domains = <&gcc UFS_PHY_GDSC>;
+
+		operating-points-v2 = <&ice_opp_table>;
+
+		ice_opp_table: opp-table {
+			compatible = "operating-points-v2";
+
+			opp-75000000 {
+				opp-hz = /bits/ 64 <75000000>;
+				required-opps = <&rpmhpd_opp_svs_l1>;
+			};
+
+			opp-150000000 {
+				opp-hz = /bits/ 64 <150000000>;
+				required-opps = <&rpmhpd_opp_svs_l1>;
+			};
+
+			opp-300000000 {
+				opp-hz = /bits/ 64 <300000000>;
+				required-opps = <&rpmhpd_opp_nom>;
+			};
+
+			opp-600000000 {
+				opp-hz = /bits/ 64 <600000000>;
+				required-opps = <&rpmhpd_opp_nom>;
+			};
+		};
 	};
 
 	lpass_ag_noc: interconnect@3c40000 {

-- 
2.34.1

