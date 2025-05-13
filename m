Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF5217A2FC;
	Tue, 13 May 2025 02:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747104544; cv=none; b=b5XN3QlqscbphGaP2QCYpalIKkoiSdGpBkMtpOYz2a3WJqAfzf8ju+qnIrbuMr+MXgCZ5YiGcNT6b3heVT/cW3YUUx3UuACDOx9EIQBSUSegpHCDQ6u8vczFubyQMK+bWUtMu3bIdxafDlVhzeHKRMsh9hGJ7yyDmqeVFdfEDYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747104544; c=relaxed/simple;
	bh=bwq4zSqvt3J11L00/FMtrHMG6dAXZ+FqAzr2T88D7WQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HqEibH6MPg3Rp21nHCBvKFTvy5pFaiEjamYakEk3lh4p+62CqjLbyEh3eAyXL7/maGZLVHR8vceV+L0mGj6ptsoMIwOiXtXWJMlV7YbHZoqC4tf2JLLABnixMahDgLlEgme+VRVr1KCV2+dIxTuwO6UjigzoBq/4vmuZiz+o1hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZDQVS0Di; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZDQVS0Di"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54D1CUOL029020;
	Tue, 13 May 2025 02:48:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=eTsGCUG+iT3yVZ6P+XF9h8THXsozjCHl66pGtUUnGw0=; b=
	ZDQVS0DiJu1k0D7NJEeiNKukGtFzR7YJAfEBaOG/5JRwi0IldYmnDMNtM3QU/oxR
	XZfxJ41qi9dnuwfz1+WES2jwAKJJRVNE5uyFLaui0pI2/PYOu5whaKouvj/TNH9V
	ABC89iwliIbFnhjoYg2Uz6KRfFhadXGRi0E37GmiNdMyXFXrr4Q3Ou6pfHxmpKJP
	iA5xk7Gci0I/G5GPKZljsaXmX/i4m8fqB3dqjW03s7/PA+UeG7zeO5r7xDoI+aAl
	UeeeXxn00loVAsPPBiaIfaxlfM4ZNqTeWKu0b+K2/KgJ/t9gu3QPOeon9/tSvB74
	qD7bQYbpHhCVd6usgTfbZA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46j1jnku85-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 May 2025 02:48:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54CNx4pQ015470;
	Tue, 13 May 2025 02:48:57 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46hw8841g4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 May 2025 02:48:56 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 54D2muX4003994;
	Tue, 13 May 2025 02:48:56 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 46hw8841cw-1;
	Tue, 13 May 2025 02:48:56 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Yi Zhang <yi.zhang@redhat.com>, Dan Carpenter <dan.carpenter@linaro.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        storagedev@microchip.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: smartpqi: Delete a stray tab in pqi_is_parity_write_stream()
Date: Mon, 12 May 2025 22:48:10 -0400
Message-ID: <174710241023.4089939.4684203628798529640.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <aBHarJ601XTGsyOX@stanley.mountain>
References: <aBHarJ601XTGsyOX@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-12_07,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=844 adultscore=0
 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2504070000 definitions=main-2505130025
X-Proofpoint-GUID: we2rlMkjJS2XRuwj5R9k3yBTIKiEdFEB
X-Authority-Analysis: v=2.4 cv=PeH/hjhd c=1 sm=1 tr=0 ts=6822b31a cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=aIsAj1sCKrDU7jUvE8EA:9 a=QEXdDO2ut3YA:10 a=UzISIztuOb4A:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTEzMDAyNCBTYWx0ZWRfX/j/tE9rPIo9f 3Cntkj9ex1LF+qchRdcBelnnK42skb6MmkNMz5el73WtKplmXjWEMQxWhwQbet1//YprLw/eHmH YvCyyLW/wflDHpToGp2Fbi20f2+WWRA8rCd8WdbY7c5xaQOiBD1g0hNQboks+MDHnjj8lQvnoV9
 kwYyxBKk5xeKQEQ0IZ2ke/sS5Xg8YYueNXdMSbCnKb/suQxeEDq3+vjuU3+XXTW8tNzyBah9aUi E8WS8PHoYWK7cdn/VjKLyCI+up1trSOzsomnTaIGszQSfgZMo6bmcDd3/gOsDJjWtw9CLDOKZbm cWSMcZRP6TEYdObIBbUy3gT5+4zkTYoiXPwnOPXchr1n2GlP1gP8rRbfJaHIfwuZY689F1qTbtF
 DBLs+YEC9vEfx3klGhCyPrIg9pmY7olmok0JyNInfJ58l5rObigRulA5qXl9j0JqUC2u0j7l
X-Proofpoint-ORIG-GUID: we2rlMkjJS2XRuwj5R9k3yBTIKiEdFEB

On Wed, 30 Apr 2025 11:09:16 +0300, Dan Carpenter wrote:

> We accidentally intended this line an extra tab.  Delete the tab.
> 
> 

Applied to 6.16/scsi-queue, thanks!

[1/1] scsi: smartpqi: Delete a stray tab in pqi_is_parity_write_stream()
      https://git.kernel.org/mkp/scsi/c/0e937fd51e8a

-- 
Martin K. Petersen	Oracle Linux Engineering
