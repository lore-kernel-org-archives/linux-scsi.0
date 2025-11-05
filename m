Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF571F5437;
	Wed,  5 Nov 2025 04:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762315368; cv=none; b=sC0iNKO14ByTdhnoXq+f9Q1WUZkCkSnB8/L1k0kUfBj1osZs1ZqQFzO2Oh1urEfDTH4pXt8q+xqrSDJ070K85yBzqnzAAnjnLgvZeNgn2NXYJ3nzrSvTyUhnu94ckaxqxiA5Oz/Z67Z2gkMoN0/JKWFeVpxCQiQD//y/0z5t6oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762315368; c=relaxed/simple;
	bh=jqf3fkA6oX0rwGlsrVbUrrG09tiatuuy3zH4FgSa0dE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=umyhUyd1qjnE4ArPNzP8sHcmRP8HBsGF7TUnug7MGyelyXiFuYgihyEnQdcjLtfd63zDfDVG7Fy4LXdbe1Cx8YDmXr57zLSVA9KOQe+zuxSfKoGy6lG0Zkzyi45pewFR4f1irUZLGBjuAg0L4dPcCy92CXICsvMTfrjkYRSrgFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eRNmz8V+; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eRNmz8V+"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A53GHPb022581;
	Wed, 5 Nov 2025 04:02:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=YsH5r/6vzUJZtwJSh4laP2CRaInCJhfRCw+nEMpXmAE=; b=
	eRNmz8V+0wX2p5FgaNbOxo00KhVqq1gHlRmxlqb3zqjm9QNZ4FD/U6Qesc2EaGBX
	XtLNinPDiyA4p4a+7oSTIjhespG4pAoA6DwDlAl5frJNSxLQjnkVj3pPLq+Fs9tR
	tuZWGKWt0rLNN2xoLrLgNj1XkXR0DpkFMYvJlO19oBKltbAQa8mWgqRkE6AC0mlT
	ZQehWWNOMN5aVmOyiemakDaWMSljpmbYr147zPAr7jNddUm7/QS2CENI7lcXosXv
	3T7M0lm6sdRU88oWuTvC8BJ7Y7MeuL5B3cDJ78a7KMGwyijUphEWNgrw2DLu0ilt
	T0fsKwkMheSX0utflxaxug==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a7xhdg201-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Nov 2025 04:02:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A524FLm024893;
	Wed, 5 Nov 2025 04:02:28 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a58ne15j1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Nov 2025 04:02:28 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5A542Pro005395;
	Wed, 5 Nov 2025 04:02:27 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4a58ne15gy-6;
	Wed, 05 Nov 2025 04:02:27 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, peter.wang@mediatek.com
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        robh@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        conor+dt@kernel.org, jejb@linux.ibm.com, lgirdwood@gmail.com,
        broonie@kernel.org, matthias.bgg@gmail.com,
        angelogioacchino.delregno@collabora.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, wenst@chromium.org,
        michael@walle.cc, conor.dooley@microchip.com, chu.stanley@gmail.com,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        naomi.chu@mediatek.com, ed.tsai@mediatek.com
Subject: Re: [PATCH v1] dt-bindings: ufs: mediatek,ufs: Update maintainer information in mediatek,ufs.yaml
Date: Tue,  4 Nov 2025 23:02:20 -0500
Message-ID: <176231440764.2306382.16356889887368434971.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251031122008.1517549-1-peter.wang@mediatek.com>
References: <20251031122008.1517549-1-peter.wang@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-05_02,2025-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=921 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511050024
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA1MDAxOSBTYWx0ZWRfX+uE1GIt984Gq
 4/GHMEsw9maJTT375X+rmpBf5mLpXxua/eTTSKpNLnEGcmns2VLHp2v9fHVEKAuCzVnrZEIhCAm
 9erOZPx6vRi8KgbnS5iMXT7ojITDj7WqJIhCMqjRDbhxvkl48Ketl+YjXTZBbJXi1NvKBWfROxS
 R9+x+365zLpzU0Kc9H3sN5IOs7RnKfkXkSPm8gphNh+OWhLvU8Xzi3R4WlKDRSTnpm6rXQzx/UN
 WBNqsTx46cDHbk9eLm/CevyLK+0U696VVxkQgeaFv0RP/zgIWVtLUV5dGpyNwtBNrkAA6tYoyIK
 5sl+8AiW5T7FuuQEdusv+qDnDi3IxTt7kEF+yilQJt4fhSJus6YP+qnGHDLYG8UxJTHd/qVC/kL
 6MqSTyfIHUsbn3KOwsKN3RhLYgVVuP4P3bp8Df7TMnj4uqM9uXs=
X-Authority-Analysis: v=2.4 cv=ZpDg6t7G c=1 sm=1 tr=0 ts=690acc54 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=mpaa-ttXAAAA:8 a=8d0GUG1h20LVvl_VnrYA:9 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:13657
X-Proofpoint-ORIG-GUID: HuzLGcL3yYhgijfTvd2LcY2rHs5jwfRD
X-Proofpoint-GUID: HuzLGcL3yYhgijfTvd2LcY2rHs5jwfRD

On Fri, 31 Oct 2025 20:19:12 +0800, peter.wang@mediatek.com wrote:

> Replace Stanley Chu with me and Chaotian in the maintainers field,
> since his email address is no longer active.
> 
> 

Applied to 6.19/scsi-queue, thanks!

[1/1] dt-bindings: ufs: mediatek,ufs: Update maintainer information in mediatek,ufs.yaml
      https://git.kernel.org/mkp/scsi/c/480ca7954664

-- 
Martin K. Petersen
