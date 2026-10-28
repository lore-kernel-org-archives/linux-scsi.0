Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793190322;
	b=dzMehOHH0N8/TPMBqMqiCfoIOspA2n3lDjRWFcMUtUMdVryx1EzoM0LEGzhR0DhVu1s1
	 uRIvowT7olZKbhKr/LD64lq3sEyoiVGC7R/OQK/ggzB0hiCzMWbvEHAI6w7fvsUzOyXCx
	 nMOIcfTyRgA8L1lsWHwwoojfrYfFnNUBRaZ6ycqCzfaI1/GufTV2ah4CjqHunlZpk3tFs
	 oZp6JeshKE9DJLc9gE67vBNZ4tbUfQcicPnGJb8XrgAyz/xu/Pjce0ftr7nzIEjRw7x+W
	 Tm4uyNFvXu/zmPBBdyLUCnQoPENMoDnLs5c56w8QYV/cpBurv+H68D7nyWV9ZNGr4lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793190322;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:
	 Subject:Date:Message-Id:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Proofpoint-Spam-Details-Enc:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=HTl72mT/ml/6tKFbd/9Kva4wSmn2Rn68y6y82DJiCf0=;
	b=ti2N8hQdiqWNa6CQdYXZflPE2AIKVo9d2tZ+JJKDsgt7Uzm9945GIKHTjBuYtUOjJ//u
	 2QebZsiNz1UOqCqLwYJI56hP4uevfHgHjLuB4Qzc7HVROf7ZMoDVCjv2GBC7jCEMJqCrP
	 bHXI3qTR3FkWtwY8hAOtgY/Z2319pKcG6WUmD7pmeMvBZKdlXc+IiZ5TjIq3jChBJ28fu
	 odRtSYFeFK5xfmOECAG5AMv40uiJMrHhEjI2lMZDQorNDSnrUq3HPd6bBsaEx4gsjrvGm
	 v/r80Tdyjvy/7AcxqYRpIsYjkNzJwNzrVU/HgGg7wffsurWwwoOVmPhexxK4F+IBl4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=ZLvDdhb+;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=DswUYYFP;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2566606A321
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 12:25:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F2566606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=ZLvDdhb+;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=DswUYYFP
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69SBds1c1011759
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 12:25:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=HTl72mT/ml/6tKFbd/9Kva
	4wSmn2Rn68y6y82DJiCf0=; b=ZLvDdhb+2EbyBfA2suPh3lPEMX3N6i5s7yOfhA
	hSuntSTd39+uOUit9pm7jL5B9dXd1NKCoqTCaeQDtZr0qrMxABuL2rFChbYp26lN
	b5PU3jQRnfubK49j1oTZe4Vjsh9Hzv6oebzLFoJkRKcGdbhz5kLgP6vu6n5U9J4h
	8sDdIw8WE/eH9i1FiQGMN6A3UJwwXJ7Wh03WtOmrWQfvGiF7RhyDMaqYcw8ohl+4
	uam/IOtroyylZDdXFXKTMZ65ekPpEuPOHFqwzW/2n3l4lGWYskUYXY064NJPIIQU
	yhbYpRrrC0qepm7IEj9tTrjPi3uOO+zYdxaoRUDM2Uv0AyGw==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hkfehgcjf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 12:25:20 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3acc98e3b3cso801140a91.3
        for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 05:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793190319; x=1793795119; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=HTl72mT/ml/6tKFbd/9Kva4wSmn2Rn68y6y82DJiCf0=;
        b=DswUYYFP9/+sznkSE3JeK/uM5PIDgD+FIV+TD38zKT410jd2vVv/7Vm+rFYxoDejkH
         8p1PCwaPosOlCS3AdtYTUFNtLTdtiOWM50+dxBRzl2CGV1CHp1aFcCwmf5piUADnBBTL
         pFu1vDBCwZzmlx3xFIJfAeMNsCxV5hicISzBQ66AvThMwBJTyHo9YIhsjS9+UgkUjKIb
         Xk5hMd2s3EGcfN9lCe7IdcykjEDdd2ZerfglAYWyzC9t6AA88fAdkHAVs7Inlh5oCrb0
         9PjNFriz2KZ6k29Avb2lkpSs1WHz/JDV13R6AMxZMFDfiZ8KhzS3aNyWbQNTl/UuKBDX
         URoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793190319; x=1793795119;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=HTl72mT/ml/6tKFbd/9Kva4wSmn2Rn68y6y82DJiCf0=;
        b=0ry5TleQccRm4I8+2mmpn2T5k6trxdVuC9bBSyvX9koEvXuGz5dgb1IFGMlJLX/0Py
         R8lU41/Ju5KljxN49CokaaHSD17B1WrlxQGz7qTxFLlDtVgLqLLWkHEep7bptsXi167q
         1DadD7o25sB7OEghFZgMHiaquLfjW/X4hh0SG2Dpdb3Sq8YdMCze5/K7Limg3fT7a3Yi
         y7R+eLpiuXrEn6HYngJoU9Ehpm3Qxhrb6Z/Yg1HM9M4ScTNpjZfGksIWyX9yZ/Pzxe/K
         UbvCxW8I9KHW6q0+nTGeJB/b1hY4F47xxLfYWtnbDhFASI71+2rS65uZK2MTVSPHv338
         NeFg==
X-Forwarded-Encrypted: i=1; AKwUvBxlOCfxfdmQL/EroDweGwjCU4P5bNY+zTibgcjFLH+WcSSbCQaQGi6ruT1TKJTBOAy477riJiePxjZe@vger.kernel.org
X-Gm-Message-State: AFq9FYJ/kEZgKfMTGc7J7JrTvwZ68FrZtqirebLcELG0zwpY4HRM0Wwc
	TEkAFKylD7n2OZ8dWumYI93H4zlGeIwap96QToe7JGUeePGyT7ep7p835u1MS1UUVRy7OZaIzDj
	I/mQoZEpMf43sdzb1mkWzIYhTfWDPpO8mQuLWGBVUKe9O2+DZVPwIDGEALQlH0vTN
X-Gm-Gg: AYBFou314p88Y4dfvA6HVQcenqcPr02pIycEdRQznJBMlGMy5MMzQVvwoyY0bt1v/xa
	vGWE2IRPeUcGCgqWnN+gewKHi8rVtsHATXT9JODsxgshzN+zS9bqQi9NXci7x4Kv870NgosPdCf
	WvMF4ktrRMANi4VsbM26T11k+DoiLHef0fB2fpvrExsnG7J0V3aNR8F6ILpqbNUx+lcSB0rjC2B
	8QcThEUXqTA7jMrb7zqwFT9FVN3CYTCz3RomFaQDq4NoEaTi3Pc0d6WfkWfYYnQ+cC86ipj8pA7
	fcT9WAEwp1tZ3K8cXblNMIbATBqx68WgI+ybjGe0Rtkf/Nx+E6ELgjWcyOFJEZBFmh4VOo7K6Ex
	xAEKixtQoJ8RHSQwi2zMnXsO6IWk3zOHxBbaa9/lcUto/hskKu1s0DdnPUslhrguOzwg5Cb3krf
	Y=
X-Received: by 2002:a17:90b:37cb:b0:3ac:a11a:7c91 with SMTP id 98e67ed59e1d1-3ae581bbd4bmr1613570a91.44.1793190319526;
        Wed, 28 Oct 2026 05:25:19 -0700 (PDT)
X-Received: by 2002:a17:90b:37cb:b0:3ac:a11a:7c91 with SMTP id 98e67ed59e1d1-3ae581bbd4bmr1613537a91.44.1793190319031;
        Wed, 28 Oct 2026 05:25:19 -0700 (PDT)
Received: from [10.213.101.15] ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae5a9f287fsm2995819a91.16.2026.10.28.05.25.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 05:25:17 -0700 (PDT)
From: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
Subject: [PATCH v5 0/3] Add UFS support for Glymur Qualcomm SoC
Date: Wed, 28 Oct 2026 17:54:45 +0530
Message-Id: <20261028-glymur_ufs_qcb_enablement-v5-0-09cda5e3bab3@oss.qualcomm.com>
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
X-B4-Tracking: v=1; b=H4sIAI3p4WoC/43N3YrCMBAF4FeRXBvJpEna7NW+xyIlyU400J9t0
 hZF+u4bXVi90OLNwDkw37mQhDFgIh+bC4k4hxT6Lge53RB3NN0BafjOmXDGFdMA9NCc2ynWk0/
 14GyNnbENttiNFCQXRuhScmZJ/v+J6MPpZn/t/3LEYcoT4708hjT28Xzbn+HavjM1A2XUau8kc
 kStzWef0m6YTOP6tt3lQ674zB/Bag3kGQSlQPsSC2XUC7D4B4Gxcg0sMlgJ54WvFAiQL0DxCOo
 1UGRQG+WwKkBLWz4Bl2X5BcBeA8DRAQAA
X-Change-ID: 20260911-glymur_ufs_qcb_enablement-1524a497520b
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793190309; l=2128;
 i=pradeep.pragallapati@oss.qualcomm.com; s=20260911;
 h=from:subject:message-id; bh=vIZlvxpaiYQv4i83bg/wFItskHzVhvQXocNrx5A6sUY=;
 b=hqXq+VJFu3erEx31I9fC6Su2K5r0NzcswcBlqetAN8povATEZEwxWDEjuxm4BVSvjKWA8NdYb
 YvdoPL8Odz9CZKfkEanlZYTZMz8Ns68rvSkKBfGu6Ns8NxqwqqJOVAu
X-Developer-Key: i=pradeep.pragallapati@oss.qualcomm.com; a=ed25519;
 pk=uyRUsge8nQMwf3iW/e/o0U8z9nWLCMm1MGKxEftztic=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI4MDA0OSBTYWx0ZWRfX05RnkN9/s4wF
 SO02bdXPl6skj7TMAmqSSF25NFe3hNbmiR7xmLygd6LFUYP6ke0gU6SYRSHbo7xm9C/Yb+4b6Yz
 6VkBuR/7Qg4eb+hIgFelQRvm/XcjwyjtGM2IZnQMmfzvVGVx40MwRqBjY/3q33zggkLpmKEJa8J
 A+0tKbHBx3TeU7iD6NqN3mnFrFSZbPTW7kOf7zUC53of576CqQWMb9yWEqJMOOasbUUyyTdw8Kn
 ZxAsbv2QrciZATjgMTKjXtFr88wvZwbjVpTELBE6QTL2dqaMVRoP6RmpY+J09shz+6l6ycMFFfj
 gkJBYPSnSXEKtepL1Q63zy4HvrWK1RT12tD2bq4uGN4rilQweOg5Vym2o2LREN3Tm+87kGEipTZ
 WVyuu66ELBdavgbkrnllefF4CV+fyqasbS+VIeQezfj5CSOpgCuUjuoMQqq8jlLZnX+O5hNA9yU
 eSsn/TLCmTNs5NXztjw==
X-Authority-Analysis: v=2.4 cv=A/T5rKWG c=1 sm=1 tr=0 ts=6ae1e9b0 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=MjkSdyLvD0LHWdEy_1oA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-ORIG-GUID: 6G2RlizlId7z7tNfqWuzsnVvi8Z0as_t
X-Proofpoint-GUID: 6G2RlizlId7z7tNfqWuzsnVvi8Z0as_t
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI4MDA0OSBTYWx0ZWRfXzv4M1rT1P1h0
 A4PCaidR0aJ54BT7aWlkoDyvGAfqu0Ir0SPb1OmHqQO1tH/P/wV2Ht8+GLvGKzcLoQuCqULn7dK
 MLxeMNkTLgcQPwpnm7H2iZV08zDtutc=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-28_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 impostorscore=0 suspectscore=0 lowpriorityscore=0
 priorityscore=1501 malwarescore=0 clxscore=1015 adultscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610280049

This series adds the device tree support for the UFS PHY and UFS 
Host Controller, along with the required PHY driver updates to
enable UFS support on the Glymur Qualcomm platform.

Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
---
Changes in v5:
- Rebased on top of latest linux-next(tag: next-20261027).
- Modified OPP 201.5MHz from SVS L1 to SVS corner [Konrad].
- Retained all RB-by and AB-by tags as is.
- Link to v4: https://lore.kernel.org/r/20261009-glymur_ufs_qcb_enablement-v4-0-9a6ce83195b7@oss.qualcomm.com

Changes in v4:
- Documented the lack of UFS PHY GDSC support [Dmitry, sashiko-bot]
- Updated the commit message for the qcom-qmp-ufs phy changes [Dmitry]
- Retained all RB-by and AB-by tags as is.
- Link to v3: https://lore.kernel.org/r/20261007-glymur_ufs_qcb_enablement-v3-0-84cf4f861415@oss.qualcomm.com

Changes in v3:
- Rebased on top of latest linux-next(tag: next-20261006).
- Retained all RB-by and AB-by tags as is.
- Link to v2: https://lore.kernel.org/r/20260918-glymur_ufs_qcb_enablement-v2-0-16619f7e36a6@oss.qualcomm.com

Changes in v2:
- Added 201.5MHz OPP svs l1 entry [Konrad]
- Addressed minor cosmetic edits [Konrad]
- Sorted references label alphabetically [Konrad]
- Add RB-by for SoC dtsi & board dts [Abel]
- Add RB-by for phy driver changes [Abel]
- Add AB-by for phy driver changes [Konrad]
- Link to v1: https://lore.kernel.org/r/20260911-glymur_ufs_qcb_enablement-v1-0-b9fc5e2ee99a@oss.qualcomm.com

---
Pradeep P V K (3):
      arm64: dts: qcom: glymur: Add UFS nodes
      arm64: dts: qcom: glymur-qcb: Enable UFS
      phy: qcom-qmp-ufs: Add Glymur support

 arch/arm64/boot/dts/qcom/glymur-qcb.dts |  18 +++++
 arch/arm64/boot/dts/qcom/glymur.dtsi    | 125 +++++++++++++++++++++++++++++++-
 drivers/phy/qualcomm/phy-qcom-qmp-ufs.c |  99 +++++++++++++++++++++++++
 3 files changed, 239 insertions(+), 3 deletions(-)
---
base-commit: 151a134a4e6ec66f69db8750c66006f5207f7a9d
change-id: 20260911-glymur_ufs_qcb_enablement-1524a497520b

Best regards,
-- 
Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>

