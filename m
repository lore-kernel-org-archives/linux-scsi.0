Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510541A9FBA;
	Sun, 31 Aug 2025 02:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756606292; cv=none; b=qwTLe43nKVjrYzoLG3ndn/EyKlwr1Ygtz8ejiHW5e1bVIEMBE4YAyqzXgz9NgT3dN8z5Gc83pWaZ3/uFkym4LiGJT20VNHcjW1cdgvKfAmc5V9ObFYPhpe8AnKz7zh/So6F5tnA1ld3K4kwZp6DTxA9xHm3STo4hkfAaBTA7ark=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756606292; c=relaxed/simple;
	bh=lT1D+6RVackKmQK/ynbm7n03Zn+rICgr0ouGgLi8sLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H4lDfwa/OvX/hX9g6b0Qh+O4JeqVKZSo2UeZKfo6z+xxXt6FAQ9CVwNUG2CHRD7CUJd/01xXegvzbUa6sVwCRgyUiFLJg/CX2X5kgZuvc3vd4A31I5LJw2deq+0xZse5KC7F73gLnuYp0bgt8sDjOkVjNbelf0di/qx1eF1XY7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KfE9PX9V; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KfE9PX9V"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57V1dwuJ004381;
	Sun, 31 Aug 2025 02:11:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=jenNYWLSDLUXcYzIwznB9VjpXxumLSXZxZIS2PYHnJ8=; b=
	KfE9PX9VIVRXqSiWq/ou10mBr0BBkwKHWcCDAA4NczhTpQ6QvSgaHnuzxw7iZjCc
	ApsA+eYEUEwsV7ppSDe3PL941X9C0C0rwaLPxhrbep/lwC8Hth3Gl0/5GX0BPqlO
	mBDBKWHNnd7TMwUWqdVop1qM6v0KWtHLrvB1q+WzTrr2hAyV1uWC5MhrSUW5ImSI
	HAUaj4407XIaoeeLA/sdYuCF4iwTXdWc8S2wou4IP/4bZZrgcWsjmd07ZECbdheB
	Ut4soG3n2eh8oJHPWE7PAwaTnoWXR0jXfsNzC+Fu0dJ53EGl5NhtPKOdyCDuV2pu
	CxR7aXiWNoJ/P77j2ewoUQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48usm9gmnh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 31 Aug 2025 02:11:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57UMNDqb026849;
	Sun, 31 Aug 2025 02:11:21 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48v01kaagy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 31 Aug 2025 02:11:20 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 57V2BKgp033747;
	Sun, 31 Aug 2025 02:11:20 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 48v01kaagp-1;
	Sun, 31 Aug 2025 02:11:20 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: james.smart@broadcom.com, dick.kennedy@broadcom.com,
        James.Bottomley@HansenPartnership.com, justintee8345@gmail.com,
        John Evans <evans1210144@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] scsi: lpfc: Fix buffer free/clear order in deferred receive path
Date: Sat, 30 Aug 2025 22:11:13 -0400
Message-ID: <175660626140.2289384.9790485479491589467.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250828044008.743-1-evans1210144@gmail.com>
References: <20250828044008.743-1-evans1210144@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-31_01,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxlogscore=716 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508310022
X-Proofpoint-GUID: kksu-CDHoeIJydm-9tgaWO-9mLPc2Y7v
X-Authority-Analysis: v=2.4 cv=I7xlRMgg c=1 sm=1 tr=0 ts=68b3af4a cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=XQke2KudmeUMm3TyhKgA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzMSBTYWx0ZWRfXxQFGkin0Z7x+
 5EWKgU2aEyLBj4SegSBVUr4u2FpNHYEzKwdzOixpKdb+LZMvTnzZxwNPmTYuPRlVLWkcF52IYT+
 xizfDnIIaWNKlys9D2ixhbx7RXiTj+I/FjbGsDfOWDaO6KW8XXZm/o28nqCQfLzBGrnhHNMSvfK
 OJ0dTSmDPtwmfY6QfgXDoWygqtfpTi8yCmvxHc2vVfuxl4ltHtTAuEczOwSzjotGxck0/hIcsxd
 Ypn03MTGuPNh8ehuwxyW25/vjkeQ8uJjv9NV57wVDoGVMb9nln8APucJ2MK1P3R+T2oTWbIYPOi
 WyhU77doTZdDlO9Ur6WqjZBSYwtOV2WqYtoD/QIUV+Ogy4hAcRXUwtYoOeFImxF6lKmMSh5+qRz
 2/Z6eX3X
X-Proofpoint-ORIG-GUID: kksu-CDHoeIJydm-9tgaWO-9mLPc2Y7v

On Thu, 28 Aug 2025 12:40:08 +0800, John Evans wrote:

> Fix a use-after-free window by correcting the buffer release sequence in
> the deferred receive path. The code freed the RQ buffer first and only
> then cleared the context pointer under the lock. Concurrent paths
> (e.g., ABTS and the repost path) also inspect and release the same
> pointer under the lock, so the old order could lead to double-free/UAF.
> 
> Note that the repost path already uses the correct pattern: detach the
> pointer under the lock, then free it after dropping the lock. The deferred
> path should do the same.
> 
> [...]

Applied to 6.17/scsi-fixes, thanks!

[1/1] scsi: lpfc: Fix buffer free/clear order in deferred receive path
      https://git.kernel.org/mkp/scsi/c/9dba9a45c348

-- 
Martin K. Petersen
