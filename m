Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED7624501B;
	Mon, 16 Mar 2026 01:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773625298; cv=none; b=B0S5SrgcS56sVEUZQXhmFD5ebp/UXkKGtWQ++sfSvz07dHcf9HjfD9j5/579kUbS2TfgBaAS8p4d6fVK8jRKKt/JiaTko8fDmwFemLzsG6MAqLTPgGLZrkox2fYDnPa3DJz9z9zkZ+IR87btdG7yOmQd53grMtaVzucOxXHpgEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773625298; c=relaxed/simple;
	bh=KVaIgPNWF1yRKByBut9+299iMDHvRVn/J+RxwjtBVBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fU9mBIUpop4L3wgGjA3diKBt4lzPN1zpQ6LIggUEJapWIp+u3xEI7sO2fVreaS0nXt1/JbTne/0s2AtKSQPja/kl/Da1LvVd0gwcmKn9vjXUJ+5T4QmGjVEJ+ptYXoQnMfJ14VYmD64Mmt8RE90fPPiOzCESY+ngUqB7Ay7vuBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ILv3p8zz; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ILv3p8zz"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62G0CHRd2956065;
	Mon, 16 Mar 2026 01:41:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=jDu8FArXKrfRgyhc3xBRmu/JO9Ej3FV5ijyLwdx+/uM=; b=
	ILv3p8zzSd1O0r0CDXMkQOYfcnROX2lTUraFx/1oxq4rH14IioLdAPVho/K3EDO7
	0CNvWO5Wi09Sr7+aqyHQJ9y2mkdj69mnKd7R6PHLF1UY2mkDqALuZEKFNCgWRzD3
	g8RNyiqr+Vh6OXp9d1dj1cHh1ejxyGXjty43/H6+/DWVO8WU4Ra61Vd/XCaMBvOe
	ii+/Wg5lgSCEY3tbyWrCWJ9tK8jUhfZaCaLZ9lGKpxX2Elt0pVanKl1aWVG2Y0iw
	mnDgGzpU5fyW7Xo8Zr9cxsTrNAP4bIcC4AnTHWnlKOlomuwl9hNFwfX+4hfeOWfb
	T2/7nvogPDiDtwAfmOd+Xg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvyqbsb4p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Mar 2026 01:41:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62FLUtO3002985;
	Mon, 16 Mar 2026 01:41:35 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4j86nb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Mar 2026 01:41:35 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 62G1fXhT032070;
	Mon, 16 Mar 2026 01:41:34 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4cvx4j86mp-5;
	Mon, 16 Mar 2026 01:41:34 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: d.bogdanov@yadro.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] scsi: target: Fix complete_type use
Date: Sun, 15 Mar 2026 21:41:24 -0400
Message-ID: <177362524492.2599440.1175058630850401022.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260307220630.131008-1-michael.christie@oracle.com>
References: <20260307220630.131008-1-michael.christie@oracle.com>
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
 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603160011
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE2MDAxMSBTYWx0ZWRfX0q7TcLbF52BI
 tOX45Yoq1lO2qtaeruAUFG2W5spwsifdCoQEKdwk7V5h2OJLkExe7tFT4/HPxuLt2bE9PrU2e9Y
 88ZdN7PRjAodEsP9nDrMOMBf1tCaX07uEDSXnlJJ6zFiXIMypG8HD6IiTxzEIEv02Ig7SgQhv7b
 nopU0R/k3wYjdY82s12swpJPZk/B4VG43NMP/taGYxLPrHESn462hcABCr52AQYDAVIp4ZKGEXD
 q7YaVyYbNFznCTTB2ruhRsrtBm7tCpKHTspncsJ59xLzoYjvcgMnfjTBCjT4YmTPnGWg5J2hEMw
 9iUe4Uo1fyo7rppi+MgG1nOULmYug3Z4R8dLYjru0E1p3RXz4xXngmXfxvsN7MOVxkLP4ZcB2mT
 jYgePwzwyAuCoMPmzNsphm7+Nva49ciHTVUNZz9VJg8AunowiAny5EEGrc31zHQrZcFjjtu2Ufa
 vYkoKncWGzoFbfVe6RK8mZ3WRFlqSvAbfs9LRhOU=
X-Authority-Analysis: v=2.4 cv=J8WnLQnS c=1 sm=1 tr=0 ts=69b75fcf b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=2A7y_mFFBLK6Gyrz720A:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12271
X-Proofpoint-GUID: eAXvrZ2LfYEeDwqKd5Jx7zRBqiTEAWn9
X-Proofpoint-ORIG-GUID: eAXvrZ2LfYEeDwqKd5Jx7zRBqiTEAWn9

On Sat, 07 Mar 2026 16:06:30 -0600, Mike Christie wrote:

> There were two copy and paste type of errors where I swapped
> complete with submit names. This patch uses the correct variables
> and definitions.
> 
> This problem was found by Dmitry Bogdanov and this patch builds
> on top of his patch to fix a second instance that was found.
> 
> [...]

Applied to 7.1/scsi-queue, thanks!

[1/1] scsi: target: Fix complete_type use
      https://git.kernel.org/mkp/scsi/c/3e70441fb508

-- 
Martin K. Petersen
