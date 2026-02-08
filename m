Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66AEC30E82D;
	Sun,  8 Feb 2026 02:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770516135; cv=none; b=Mc2+UpkElCJOMV7xJdJqgu3PMuHpADxV7LBHYM/1E5r9uzbsFlQfk6XHfDZbyahrM+20FIlDRaCcGXLuDXMAotJ17yGqC1DoscLSXwQbV57n7Tj4czVrAS34qZMbtPi7s/pDNRIV1T1iF/u6QzyZyDst1krUrm7sdxHmtf+Ikag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770516135; c=relaxed/simple;
	bh=4Lrx1EtQFQifq1diasU4u2zA3TbWSHFLtNsKCF8mbk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aOhSeXXfHp3VMF641zJR5lZFTg8dlvue2sDyZHdeU4uExSqXE2Qmk7iO2hzOxToQvsOL54zOlOa+P8F8I4U4ZJqPMrHHUOiXWtziX2I8iFN+/BJ+kHVXWyp94lztPr2NE/U19giRLfurrgeHVYqv7LrOVegGJ3U2gwHRtoPsQ14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LxdSF/WB; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LxdSF/WB"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 618201bX2356226;
	Sun, 8 Feb 2026 02:02:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=57iwP16dFKb7q9jWmMyZKem0IMWNehQjqkTVygfhWdM=; b=
	LxdSF/WBwqBBtB3Zm+N0u7NwLcGl7SBGkCqo60PAU3QRXQxOmRUCyZlvwGG8zbTw
	xM7RJc+3ypXVVvTHvFf4h06lfpGXPAcOaOGX3Fyf8aDz6rLJQVmsEbdf16VFHfJX
	2FLFA15MwuI4o7in1kSjox0Hsh3JjUUj9SIC4Bhg/nM2UEU71kQ5v5dWYmvoYvo+
	L0gZsKxQCakYXz9ku3pw5Y9vSmUt6yIIw9VE2ImEgliRnP3aFvhYTutnvAcXfvn2
	AqDgVyGBip80fafFlPr/60zMOMquPEiet/IehVGCn9HvUkK+6LPOoGM2856HCP/Z
	N6Zx4QkyepmgUWAVaNNgig==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c5xh8rhmb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 08 Feb 2026 02:02:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 617JNKG5006400;
	Sun, 8 Feb 2026 02:01:58 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c5uubuk5d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 08 Feb 2026 02:01:58 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 61821sxX016745;
	Sun, 8 Feb 2026 02:01:58 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4c5uubuk3y-7;
	Sun, 08 Feb 2026 02:01:58 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Peter Wang <peter.wang@mediatek.com>,
        Chaotian Jing <chaotian.jing@mediatek.com>,
        Keita Morisaki <keita.morisaki@tier4.jp>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Stanley Jhu <chu.stanley@gmail.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: mediatek: Fix page faults in ufs_mtk_clk_scale trace event
Date: Sat,  7 Feb 2026 21:01:48 -0500
Message-ID: <177051564499.3805738.14840607971686063797.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260202024526.122515-1-keita.morisaki@tier4.jp>
References: <20260202024526.122515-1-keita.morisaki@tier4.jp>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-08_01,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 mlxlogscore=971 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602080015
X-Authority-Analysis: v=2.4 cv=YbOwJgRf c=1 sm=1 tr=0 ts=6987ee98 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=oJja_GqfWbNoQn7F-NsA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12103
X-Proofpoint-ORIG-GUID: gkp4bpy5HEp7zU6fLQyTzOi1hHSXMLgG
X-Proofpoint-GUID: gkp4bpy5HEp7zU6fLQyTzOi1hHSXMLgG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA4MDAxNSBTYWx0ZWRfX994PBvR0ddI7
 eyes3mOVbqlTanTnQZ1gXRCzxEFU0e2ZoJclJDUxy+vMmZ5yyHGHYOupEX5lpaW1HX4YNZ9nId3
 OhWpL9NejK2m3yoQnLBMEIHl4+C7cRvsoN4zd0nuJXs3c+33CqBNl0dX2AimsMugx5HLSoJiTHo
 o4D46cMmxXTuPBl2jMJpgRITKAXWQdZIy+5CVOAcQNtVHiCk/1rgVjd7XqtYgDO9bO4rEHgC/MP
 XM48D1T1KUIBtTNffRg1sahq7tzunwJWeDytJvpPtrPfNy/W/AIRIywETJvxUc/L2Drs+CEzM5V
 hOaK9RC20H1m2/pauUra516wnEDf5uaVZwiNWVwatxqLY0WhwvzFxWS3b4a27ZOB/5QwqB3KecW
 FkmBAmEELD2FT2wG0yiQtNMmbzygXLI/AALjjh/1tegKCrIVl0uFgy9bhVZs3kss0rgUG54An1U
 yNex0lKUGDdxTOnR1H1iJEkgYC4P/O1Upb9KzQxg=

On Mon, 02 Feb 2026 11:45:26 +0900, Keita Morisaki wrote:

> The ufs_mtk_clk_scale trace event currently stores the address of the
> name string directly via __field(const char *, name). This pointer may
> become invalid after the module is unloaded, causing page faults when
> the trace buffer is subsequently accessed.
> 
> This can occur because the MediaTek UFS driver can be configured as a
> loadable module (tristate in Kconfig), meaning the name string passed
> to the trace event may reside in module memory that becomes invalid
> after module unload.
> 
> [...]

Applied to 6.20/scsi-queue, thanks!

[1/1] scsi: ufs: mediatek: Fix page faults in ufs_mtk_clk_scale trace event
      https://git.kernel.org/mkp/scsi/c/9672ed3de7d7

-- 
Martin K. Petersen
