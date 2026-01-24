Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462B97260F;
	Sat, 24 Jan 2026 03:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769226646; cv=none; b=AWFs7vRmyiPNZO4V90XxuXOlg86Y1HpHAs2h6vVW0oDvIQEPSP3sH6/5gwOsHT1U70kOGHUcGK5X3orWtBhoCPJ+MxcWco8XCFmqp5pZ6uHrbpbso4wX9pBqvc9qUBHrryDDMpYNEWtCowE472O2fMX0Xrta4KDBtnq4+BleiPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769226646; c=relaxed/simple;
	bh=UKV5pQ+WWOe00K4nJsjEgZ4qeujUaVlM4B8agFg7fcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QKEdpOHS1vt8OMkcw4GrPmgYIFIMo3TzAk6fGfWHGObU3LDw3oF72mNapyDqqlK3bXDKX+57sgfZ6BWVB0m7XZFcR6sWtsrw5rOdtUR088Ou1qr0qBQncWfwtZlbVyJrGLABrBrqQcKHL6Y/04iuPPQEbFIyj4x0A5AjtJlCsLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Tu8BW31s; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Tu8BW31s"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60O3NN14476494;
	Sat, 24 Jan 2026 03:50:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=RnKYwmF6i+rHZr+BY3hLagVUqg34uJpLZi4fqObvuM0=; b=
	Tu8BW31sNGkM38OMWZxaUo0JncOv9pcISVi2uAuAllkrj9hV0pbM3gP1X/lCLA02
	8tEd82YKIVu8/0qOZQOuFElm0h+BhYFwzkzKqQvlXe4PK5WLCf3KZptvY6h2RrFb
	Xa95EK/IhHtwhsTUkvzC1tF5bzrGuc5LZM1oe9GZnKx4IIDcWjGysVRZBnd2Fsqe
	+v9XjccRwOTf++lfzsMySNVYdLPPnnEGi3j0y+37qNyjAlFM+omn+MSYrQb7Ty52
	7AcrQTfGzt/OeFOBm7vT5AbXs8OPeCYipQ0hVslbRxJnt8cFEscZt6UY9pDXS/MY
	aUSLxanJVi0afR5hfNH4gQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvmgbr1tr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Jan 2026 03:50:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60O1YA05019835;
	Sat, 24 Jan 2026 03:50:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhbah6b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Jan 2026 03:50:24 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 60O3oNSp037773;
	Sat, 24 Jan 2026 03:50:24 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4bvmhbah5x-3;
	Sat, 24 Jan 2026 03:50:24 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Peter Griffin <peter.griffin@linaro.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, andre.draszik@linaro.org,
        willmcvicker@google.com, tudor.ambarus@linaro.org, jyescas@google.com,
        bvanassche@acm.org
Subject: Re: [PATCH v3] scsi: ufs: exynos: call phy_notify_state() from hibern8 callbacks
Date: Fri, 23 Jan 2026 22:50:19 -0500
Message-ID: <176922262101.2870193.14804934834575560482.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260109-ufs-exynos-phy_notify_pmstate-v3-1-7eb692e271af@linaro.org>
References: <20260109-ufs-exynos-phy_notify_pmstate-v3-1-7eb692e271af@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-24_01,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601240027
X-Proofpoint-ORIG-GUID: hFwdphNVDjyou4hOz4CtSBr02467BzhY
X-Proofpoint-GUID: hFwdphNVDjyou4hOz4CtSBr02467BzhY
X-Authority-Analysis: v=2.4 cv=AqfjHe9P c=1 sm=1 tr=0 ts=69744181 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=vusFXfun81BZlb0r6IwA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12103
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI0MDAyNyBTYWx0ZWRfX0GGPXLF70t+n
 4TL2J8UVVtSDLpFV6+CbbSxmgYDIrZ0kT9SqfShi7bOxJ3QhHfBsabcGLL7iCjSp/VqRzNp4jkx
 n0ZSudPBjpMFsQrNLRfWcIueyCccfAsUdwVF1pJrWwFSz9L89OuEHAt/SS68oqN6AEUWKkC1DsJ
 oiAAnG/WoXLWmHvwo4E7E6L+JyOyeI2guhU7zjO+ap8fQxMzGGMBClWEqLtp2RYFdbWRUw3rftL
 K0GXiIGG43DeGMMBZHl6lkqGWJvoIijdFjRt1Uef/rbaBKnS1NSC/563W1EdwiCxcLhsK+7cTbB
 Q3g97ACAt8GmZsR9wPySooNhKofyedUGZe7loRuvEHhfyroy/gBF2yE3tNTeBUGyEiOsmJAoDuJ
 lMNIKcfZP7FfLdjRg4hddGyvo2RUr9htMBLEqC+A1QNOPhHR8GN4as8r48VmWQIDhiO/hc/QUQ6
 nV2857AhSGKeHCVjOsP9aBRx/xM8wA/dkVun/9P0=

On Fri, 09 Jan 2026 11:40:14 +0000, Peter Griffin wrote:

> Notify the ufs phy of the hibern8 link state so that it can program the
> appropriate values.
> 
> 

Applied to 6.20/scsi-queue, thanks!

[1/1] scsi: ufs: exynos: call phy_notify_state() from hibern8 callbacks
      https://git.kernel.org/mkp/scsi/c/07959ef517b8

-- 
Martin K. Petersen
