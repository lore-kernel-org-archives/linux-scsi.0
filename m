Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003D4241139;
	Mon, 16 Mar 2026 01:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773625364; cv=none; b=NGv8+/SUE0jKR1VIv45A2y7qBAGwjSBDen0ZBvSJFMY5G0Mcqf1hIvakDQMuTN8g8zi7j+82MoZbkK7WVwZoR1k0N1gDsEhB4GAj9PughgpamZnSmSE8dK536fRD+2fYcM1F3svg45O2fJE/F8xEejPgev4q4hf2uK5XZDmg0KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773625364; c=relaxed/simple;
	bh=jQCgTOM7vFxAXUg6EcD3QhjS3L+hIMMQORQbVoclbco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U2rnHLadnpUI/UbHa14MyoZOG/zqdpa7tkXlvpMqNX7+5nxU59CNOEhcSaZXfr2bapEDEuaxh8LI74g6Ncq5pCUQ5Kps3YnJj2uZxPqaBB34bvuRRx3GvO+NzrY4zsOWn+ziUDc/J/llY14jEBMvXPD/hDBuxxlspxiuAYTXVX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mVV3z5us; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mVV3z5us"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62FMSMIm1159088;
	Mon, 16 Mar 2026 01:41:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=J4GzoEp3oYxVh2bYEWB3Ad4nlf5tQGBWD3RJ1VrL6GM=; b=
	mVV3z5uskUj1EMLOzu7HuoK1QmsUz5y4Aa8Y/gNxkCgn6+b/mPRUD26Z2JqxksHi
	tghC5Zf6n1CPVPykLikAVL2KHF5hVt+jzQBZhjR2VpwC6DwEQIyo2xZK0TiF1Kt4
	A54UXB4SWQT3d4W7L+opB8JNA3p4dJq6dMAxGAuoNO2Kj9hdqZvKUM+az2gth6H3
	cRmC6ihz1GgZ+oCVAFXINMU8jSmfrgE4NqIdmdC5bFN2qhgm7hG4Yb5YZJxly/gD
	p15ELCvWWtwdBexh7zH/o0ZlABpeo333YgXqMcJfmmayGdJ9iLdBnCrA/pqY7c2Z
	PHYlNgfZff89rXtkyxhedA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvx3b1bmk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Mar 2026 01:41:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62FL0THK002788;
	Mon, 16 Mar 2026 01:41:35 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4j86ne-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Mar 2026 01:41:35 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 62G1fXhV032070;
	Mon, 16 Mar 2026 01:41:35 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4cvx4j86mp-6;
	Mon, 16 Mar 2026 01:41:35 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Nicholas Bellinger <nab@linux-iscsi.org>, Asias He <asias@redhat.com>,
        Junrui Luo <moonafterrain@outlook.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yuhao Jiang <danisjiang@gmail.com>
Subject: Re: [PATCH] scsi: target: fix integer overflow in UNMAP bounds check
Date: Sun, 15 Mar 2026 21:41:25 -0400
Message-ID: <177362524502.2599440.11864523032122676827.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <SYBPR01MB7881593C61AD52C69FBDB0BDAF7CA@SYBPR01MB7881.ausprd01.prod.outlook.com>
References: <SYBPR01MB7881593C61AD52C69FBDB0BDAF7CA@SYBPR01MB7881.ausprd01.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-16_01,2026-03-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=832 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603160011
X-Proofpoint-GUID: AvbVOfmD_ZNmUcH-6npujz0m49MHsMXx
X-Proofpoint-ORIG-GUID: AvbVOfmD_ZNmUcH-6npujz0m49MHsMXx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE2MDAxMSBTYWx0ZWRfX1PD9aqp05zSE
 rrGEyTb9JWatoBtfZ+0+F6PJ2V6L6XgBKr++UY9bfAcVcYZXt34FPyI3a4NqPigdT9bbMg1MEOz
 Fg+0K8YGym9zi6AA+FJd7CX9F2plP6Bis3MWoNTAuOlfXHvOLlpj6WCV5xoVUFRZ4dQzQgzKHG7
 yxLqqC3R6Owl8aobSE2lJbzhORRTJCZroTrUQy/uwOqfPmeRrwldHNOgEfo3LV2rewgqaTcNeJt
 diEp2UKKir7GnHIJ8jOUIfjULWJBozoBOhfimHNqFdxhh2rhbhB40m2YhjcbnZlSZ9QtNyEA8dr
 LEMThfv3kNbZ6F3vmz9XO+YkX1FBF1UCACmGT7+LuJMCH4stpVperUJp7S5+AdS02Z+2IpDkuV+
 rDI6kgyzKlCOWyhipP7dAK4isJjQVVQSQDFDUBaP8C+MpUzkxcME0YMco05u+8hBY1jmowl6s0k
 ttw+9aJw+dfgOgelDOzoCgE/m9PbvWXKwgAhStQY=
X-Authority-Analysis: v=2.4 cv=IN4PywvG c=1 sm=1 tr=0 ts=69b75fd0 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=rQRmoZMhNmOSFzbBANsA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12271

On Wed, 04 Mar 2026 23:42:58 +0800, Junrui Luo wrote:

> sbc_execute_unmap() checks lba + range does not exceed the device
> capacity, but does not guard against lba + range wrapping around on
> 64-bit overflow.
> 
> Add an overflow check matching the pattern already used for WRITE_SAME
> in the same file.
> 
> [...]

Applied to 7.1/scsi-queue, thanks!

[1/1] scsi: target: fix integer overflow in UNMAP bounds check
      https://git.kernel.org/mkp/scsi/c/2bf2d65f7669

-- 
Martin K. Petersen
