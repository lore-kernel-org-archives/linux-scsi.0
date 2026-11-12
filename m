Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794489524;
	b=ZGCA3Wf5fDfP6ddSCUa5OjOJRZhqJ/WtxSvd9CVzh0eL60wtc4qVBe/lrmzKdR+vJE31
	 sjj4fAeGUPygqKsi3JPOb6vKEwmp8bS1Th++SxW7HYREGReI5LCDio5jUkvvN55aeNFrq
	 XGNVdekkw2CaIxCwBll4ExUD6VIKVJIPds13DBkw3bTKe98Rjvbqp61ZbM5h4kqNBp/pW
	 E9D9wn1XhVfT5QpAMZz0acp+LrviilQOSBQfDWC+jBHvyvbnPWXnO5AJKQw2COChDLo2z
	 44JyfrYZUKrOd9YgxkJ5Ph4bnupSwk9wp7fRdte/gZX5nzvt1QmzojTUSsz6cZiS9hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794489524;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=xDEmza0Qe9pJQ58rhzT7ekkhyxXls7BABB13DbC82WM=;
	b=wyzACkWXIfZZ1m4e/oQp4j7b6cmslE4HQvneJ2lQeB8JjVq+iNaiCiRvDMYv1FKFm28j
	 gLQag1m2v+/FZztzUnAXAvkgEBYTrnwOD1BtJ29dkK5ddahx8S4S5aCeDDHl13mqJ+r67
	 HR/WbnZKLbmUu4J+ibtbeDl8B70Od11pJGyl/xJr5Y2iJZqPe0EguBB+LxkTokEN4dtaV
	 MmTzKzTJ2iFzbYUIFPBEEj6oQ88U/bT93KeGrKPGM4eI7FsTsLpfN/8P6oWPCrumshtqm
	 18N//koagQ8md+71lTNJnP3Xn43K59xFrPZH2j/OdkuLPcIVj0r5iVbRLfdp9UXPpCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=LffXCecn;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=SWBDeRP8;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378D7606A333
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 13:18:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 378D7606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=LffXCecn;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=SWBDeRP8
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AC9E84t480590
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 13:18:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	xDEmza0Qe9pJQ58rhzT7ekkhyxXls7BABB13DbC82WM=; b=LffXCecnLuJWqkaX
	PCbiL/5J8Ih6Nxs/UP+CM7vECT9iwbAmKiFfeFPO12z5LGnjJajgdzsk2gtFebYp
	U0rdm6tLuNp5+jMuWyvM4wQYTMiy0pdN827kml8cRdOeY2M4HaymFJvYnogx9amI
	yUDzL5DHjUFd5Qvm/b3LyIQuNrfdBAOar8dQP0FfMRRyNlRDZRQfE2t/ysee8Pu7
	qnnT0TVJhKIItAMCA2/9Hgp5/GYXCUpUs3VXq5EdDQcd6OlUjzbkC1sGOafp6B5w
	Q1bB0vvI7qeP/N9vOvQYfC41VaHS8VgET40kuTx3DRmgDPAcxD+minMxKeXVMO6s
	n3aO7g==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hwan4rsw2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 13:18:43 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-36f26e6abe9so6208450eec.0
        for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 05:18:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794489522; x=1795094322; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xDEmza0Qe9pJQ58rhzT7ekkhyxXls7BABB13DbC82WM=;
        b=SWBDeRP8HGmaYKgTOP7Tl/ctYB7/Df/nWGfpcbuwDaChWRnZyRSRVXT2MUj9YFCSxd
         T9cdZcoVwVvGTWAIioje60FrWIJfcG0pob3TPf1Lcba4p/PSFnMiutLPe1Ui7ZgYo70v
         RbK9/MhofnTpQuA/ia0sd+FFvzR825xL58i38TcxDXnzNT3pvI9/pB9Gw0w0EGPwoWVW
         Eif7y0BaPcIqCe3jNnTVIA2jyiKKhmjy3HKhjdFHtc0mnWfhcxom1A13q41uAFIjGGaF
         wV/IrOMsMfrpYdu/IMEaPI7WBWSmF3uqcAL2We5wOFHnU9CpX3ybUVPTnwESH3/Xzu1s
         22zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794489522; x=1795094322;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xDEmza0Qe9pJQ58rhzT7ekkhyxXls7BABB13DbC82WM=;
        b=cjNnjN37uGW5DNOZthBIY6tVWtM/Kp7lVOaKRHYWlgFEZfnF6thjK/xWy9XSKj8zD5
         G2ek0T60fbbbT5OZjhmZ0GRMTMxSnaSbnhejEX9axFyf8H6H/OR6GRTV1bd1/RtnPFrk
         TMRvm4G3douwjAKln9c01jgSXbIIWjXbnoUhrFgst2XqEEf3Btl/wHPAv4g1l4Jg5RyN
         bBPPfg7LKNmeKkjnk9gLtIhLaRk5CrVXGR1Mpt8VBKBJn1bM0jkVP91DjnLt8mUfHJAC
         3OlxFUTfp1tVyqrk313ohQ9545r1VXNH67MamksOFgDgjCbvOKakGytg10CHX9Pry0Pq
         QqUA==
X-Forwarded-Encrypted: i=1; AL+hErHTS9iljqmUBwRKgqwAE0VcH7f+2uWTPOnI7yI4yevgHWwNIH9PORs8yPi3xLlxfshrOWaPK7aVC74U@vger.kernel.org
X-Gm-Message-State: APuU4Z919bQam9bNpcw/shHBpppZL5DmtkCrqu4LaGY0mpuEcICO7qcw
	QXN0uMmTpqBy5WZBP8x0ViPpJxUsy5NXd88XkeosAtY7O8Vv/keJs552sk3Q3N6U2ZiK0NuE/do
	LxpRhpS4q1kRtfRIVq6Wo0a001EiJA0oq8pSZa3KjcQLeN3WQZFpc4IzGCgCu2VoE
X-Gm-Gg: AYBFou3D3cBue4OKPbjDalWezJiGYsaepa8BCrYGnGRnZgHj4QzJYE8HIGAZm2121RA
	8ufMYHs68UZ0WGf+m6YFh9JxJrwjzZnD02Yz89609oCqMYz96xSlA/LCao9tTmomvWeq4yPpY8r
	3iWk7VtDGQ9mhbXmw7szjHCI/6udTWvrghAFrRqTY6iD++WUkjoPF5sRmuBmtG9cG0esGwAuJSn
	ubhROksgxnTt1YMr500ELqoW/13F1Jkc5tAZxT2LjE0/mlS8zrFrDUh/pn45ujWGzSZMy6Suwnc
	tBps1XwIo4SNjt5n+ewMsBUFa3CgK1anz6UUpItm77JIXQk5LVWYMFQgiUUJ9QGW1T56q8i0mAh
	SbyhqxbVc4OZLAkaVMcEtW3VMADkB6XXxCu2P7TSTe2uiYCZ6JYAD8oXNVX0g9hQuitLOMHIN9v
	nG9SO/15c=
X-Received: by 2002:a05:7301:2311:b0:376:19bd:2af9 with SMTP id 5a478bee46e88-376832816ebmr5975412eec.5.1794489522091;
        Thu, 12 Nov 2026 05:18:42 -0800 (PST)
X-Received: by 2002:a05:7301:2311:b0:376:19bd:2af9 with SMTP id 5a478bee46e88-376832816ebmr5975385eec.5.1794489521438;
        Thu, 12 Nov 2026 05:18:41 -0800 (PST)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-375212e7d24sm43798356eec.22.2026.11.12.05.18.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 05:18:41 -0800 (PST)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Date: Thu, 12 Nov 2026 18:48:17 +0530
Subject: [PATCH v2 1/2] mmc: sdhci-msm: Enable ICE before enabling crypto
 support
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
Message-Id: <20261112-qcom_ice_pm_enable-v2-1-177e454d6f22@oss.qualcomm.com>
References: <20261112-qcom_ice_pm_enable-v2-0-177e454d6f22@oss.qualcomm.com>
In-Reply-To: <20261112-qcom_ice_pm_enable-v2-0-177e454d6f22@oss.qualcomm.com>
To: Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulfh@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <mkp@kernel.org>,
        Eric Biggers <ebiggers@google.com>
Cc: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>, linux-mmc@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, stable@vger.kernel.org
X-Mailer: b4 0.15.2
X-Proofpoint-GUID: 076iepPOb_tokXMWHRZabKoeAmn18mv9
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDA1MiBTYWx0ZWRfX3/NRVBDCcLZ1
 E9r2PPOFXRkaMjYkSelE2AQqp8TW24G7a8iL0LrRbfQDqQvizsHmxIsSzGUh5aOS87DQAzaWUlE
 FyRQ9kEyhAfs9G1Ul9eMX5dL9uxp/WQ=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDA1MiBTYWx0ZWRfX0m3yJmGZOjIM
 BZCc1OlEH3yj9EKs76D1B5utT0EwN7kCUAJvqFnFCmdHIGB99n/x4IJzPbdybQWEJGlIm+ZaS2P
 PsICPM0abEJvm0AecGWcYpabgM3+erkNVSCumRHmte5e/RGUNUa39WBs7CEotAyeu+J9DDp7IFD
 gPy31JP5iQ/DFuHN5EZbQmwAOyUUtMfIP0/lE/bDvjJKP2gSqU65C/QH1tP9X6xGUTGrw3/TJ98
 t5S1Pg9+pepjd0/ewVKhHlYTbPTR13ys3sBMRGOaTQ3SGQAJ8BF2iYH59XGu5aDLpEu8BZKKf9b
 O12DNtG55yM7fWaygtyxTsxhf0I3vGub+BEPM7AQNZLZpLmQP0fucjqshbmmpBe1haj2Vk+YB9s
 rOb3SsaFuk0uhwcSl0vpA3OvaA8f4FInXX+qcw9K5E4HLyaUlwpzfj/5/A+EJ6QAm8hBzDOciRY
 YyfFdzcDq3FGiK8+UXQ==
X-Proofpoint-ORIG-GUID: 076iepPOb_tokXMWHRZabKoeAmn18mv9
X-Authority-Analysis: v=2.4 cv=Gd+CDgXL c=1 sm=1 tr=0 ts=6af5bcb3 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=jhS48lKipzocA6WHYXAA:9 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_01,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 malwarescore=0 phishscore=0 suspectscore=0 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611120052

sdhci-msm currently exposes MMC crypto profile and sets MMC_CAP2_CRYPTO
before enabling ICE. This leaves a window where blk-crypto can issue
keyslot programming calls before sdhci-msm has explicitly enabled ICE.

Enable ICE during the sdhci-msm crypto early init path which ensures ICE
is ready before blk-crypto can issue key programming calls.

Remove ICE enable call from CQE path, since ICE is now enabled
during SDHCI crypto initialization only.

Fixes: c7eed31e235c ("mmc: sdhci-msm: Switch to the new ICE API")
Cc: stable@vger.kernel.org
Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
---
 drivers/mmc/host/sdhci-msm.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
index 32b1bcba47d6..b3e0356a03ff 100644
--- a/drivers/mmc/host/sdhci-msm.c
+++ b/drivers/mmc/host/sdhci-msm.c
@@ -1928,6 +1928,12 @@ static int sdhci_msm_ice_init(struct sdhci_msm_host *msm_host,
 
 	msm_host->ice = ice;
 
+	err = qcom_ice_enable(msm_host->ice);
+	if (err) {
+		dev_err(dev, "%s: failed to enable ICE: %d\n", __func__, err);
+		return err;
+	}
+
 	/* Initialize the blk_crypto_profile */
 
 	caps.reg_val = cpu_to_le32(cqhci_readl(cq_host, CQHCI_CCAP));
@@ -1963,12 +1969,6 @@ static int sdhci_msm_ice_init(struct sdhci_msm_host *msm_host,
 	return 0;
 }
 
-static void sdhci_msm_ice_enable(struct sdhci_msm_host *msm_host)
-{
-	if (msm_host->mmc->caps2 & MMC_CAP2_CRYPTO)
-		qcom_ice_enable(msm_host->ice);
-}
-
 static int sdhci_msm_ice_resume(struct sdhci_msm_host *msm_host)
 {
 	if (msm_host->mmc->caps2 & MMC_CAP2_CRYPTO)
@@ -2141,10 +2141,6 @@ static inline int sdhci_msm_ice_init(struct sdhci_msm_host *msm_host,
 	return 0;
 }
 
-static inline void sdhci_msm_ice_enable(struct sdhci_msm_host *msm_host)
-{
-}
-
 static inline int
 sdhci_msm_ice_resume(struct sdhci_msm_host *msm_host)
 {
@@ -2182,12 +2178,7 @@ static u32 sdhci_msm_cqe_irq(struct sdhci_host *host, u32 intmask)
 
 static void sdhci_msm_cqe_enable(struct mmc_host *mmc)
 {
-	struct sdhci_host *host = mmc_priv(mmc);
-	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
-	struct sdhci_msm_host *msm_host = sdhci_pltfm_priv(pltfm_host);
-
 	sdhci_cqe_enable(mmc);
-	sdhci_msm_ice_enable(msm_host);
 }
 
 static void sdhci_msm_cqe_disable(struct mmc_host *mmc, bool recovery)

-- 
2.34.1

