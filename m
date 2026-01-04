Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620F131576C;
	Sun,  4 Jan 2026 21:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767563002; cv=none; b=NSzt5PeZx67AvVr0C7gRTIGTnQdd+UhSWfSlKfZLHNEbVyxq44b1ArloE1Plv7aPvaEsou5Jrt1yjcezZXgkYacQdw+A8YxRD6qcZiDhaX9FuS9DGZOMp1DroTHrWhEvXsfOEWr6wX+3WOnd4eo176koibEBsMgm21PDrshmnEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767563002; c=relaxed/simple;
	bh=5nwDZCqy9xYSczdcwB52fBkbo7b/qm81fUdW7ukwii0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lB6z+SU7E0jTLyqckS2ey4tGt50aTQr9XiDW03sNJsfu99mQOHTiFod4hu7Vwml05cNIyLObWn8zElBtsKSDdaaE/zRKZ6FRmPkWDCqsEZSN+E/ZONrc9LxjDXjGEt5RXSK57G3yF4/zzrvtN3bcJdyuv4gsXbbJe1KW5AkrH1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bHiSqk8x; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bHiSqk8x"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 604LNYNI3921604;
	Sun, 4 Jan 2026 21:42:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=YIdFpEp2Vde0ap821nLXuNlSDBLQ7zDKABbszq+St3M=; b=
	bHiSqk8xd5QFepag4BBpg9leGxXssIHPYWE0vFpKfRCH6zixeSnI5OU2QxgUwqxe
	lpL0zzK9dVKN+x3SkT9apYr99ylC395jRO6TAfeOS/b+5Ck/qezQeYd/slPPOcz+
	mZeXo/rDuYq3JFNZiLrRlorwTKNg8qr0B+zUXKdSQmAkSUOy+Bn5Jkt0EVwmcmeK
	PsbwK63B93AH7fHqBg5bLnRTzN38+bAFJFRydeuvWhGXsWlFqPwcdR7lpOw0vpX9
	GD2DuyYL8ONTbdHetl9B4nJgj4PCYuCXC65b2g1hNBM/2QnkydMNc8eKy5v/BFpO
	eJpad8XKz1Y9QuBIIU8aug==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bev1t8x6u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 04 Jan 2026 21:42:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 604GVClS030712;
	Sun, 4 Jan 2026 21:42:53 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjarf39-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 04 Jan 2026 21:42:53 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 604LgpIu034017;
	Sun, 4 Jan 2026 21:42:53 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4besjarf2n-5;
	Sun, 04 Jan 2026 21:42:53 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Po-Wen Kao <powenkao@google.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, hch@infradead.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/1] scsi: core: Fix error handler encryption support
Date: Sun,  4 Jan 2026 16:42:45 -0500
Message-ID: <176756271694.1812936.10998192391944432317.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251218031726.2642834-1-powenkao@google.com>
References: <20251218031726.2642834-1-powenkao@google.com>
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
 definitions=2026-01-04_06,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=924
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601040199
X-Proofpoint-ORIG-GUID: UzFRqcWSBGWf9Yp10899Y6ykpJDbkUlI
X-Authority-Analysis: v=2.4 cv=CKknnBrD c=1 sm=1 tr=0 ts=695adede b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=YLxs0PHK7w1d_subBWcA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 cc=ntf awl=host:13654
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA0MDIwMCBTYWx0ZWRfX0b8U25sLS+Z/
 6/6ziePbdh1G9mWOzeqPJXyEojKsN5nFNcIm9BBeN1vBeHp1R6x03+AxtHAVlZeDITI5r0WWKXO
 +z/nEfcqK0tKufMlvuEoIEgaBYG7msWlc4kxcseCnDC9k7KgMJmXAfKOotwd5gw/cf5abv5hrhn
 DJZhPW99lKiujo6GWYxyNO7qqfJpBvREMBdPo5QUzdf4MCgVlZJr+Ey+O9DZJkFjeK5qjbpr80k
 hXBB5htO4zsl8dZXYXFR2BwRjBtbwGYNfIKu2fMNxT+RWoDJG+wWDR/TIMR3Av1GZ5ZkdHRhSow
 UOuDFD2lQbU5dQ0Tc0kesBvrnLHl4CV50mJdH8yRxVEaw5N2pBzuKpOnNTrmAgGZkMnKXbcuTCy
 F/iWDa49iggi0B80fEZPngiApwNf93klF+BLZHrW+LOT+vNJZOhp/m0zl7JJ5rf4vQD1Gut7ulo
 0/k/mY0nxDqb/1P0+BK6mNu24Ko6hkFixIFvUZNs=
X-Proofpoint-GUID: UzFRqcWSBGWf9Yp10899Y6ykpJDbkUlI

On Thu, 18 Dec 2025 03:17:23 +0000, Po-Wen Kao wrote:

> Some low-level drivers (LLD) access block layer crypto fields, such as
> rq->crypt_keyslot and rq->crypt_ctx within `struct request`, to
> configure hardware for inline encryption.
> However, SCSI Error Handling (EH) commands (e.g., TEST UNIT READY,
> START STOP UNIT) should not involve any encryption setup.
> 
> To prevent drivers from erroneously applying crypto settings during EH,
> this patch saves the original values of rq->crypt_keyslot and
> rq->crypt_ctx before an EH command is prepared via scsi_eh_prep_cmnd().
> These fields in the `struct request` are then set to NULL.
> The original values are restored in scsi_eh_restore_cmnd() after the EH
> command completes.
> 
> [...]

Applied to 6.19/scsi-fixes, thanks!

[1/1] scsi: core: Fix error handler encryption support
      https://git.kernel.org/mkp/scsi/c/9a49157deeb2

-- 
Martin K. Petersen
