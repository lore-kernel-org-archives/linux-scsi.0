Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01E5314B83;
	Sun,  4 Jan 2026 21:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767563000; cv=none; b=EQ2XPBE0fyF3kp79vqPD8tu5wRK8vVWx65yIvA2+vik8eVrz6OzcBF5coSiDpD5O4WVHTUQDakCVmeBlNAD5JjHRqnfBJgFjseqfmSzwi5cLjNZ9nJushk+p+fdCaX/8oCAIDuMk4WCpmYbSBiox8YLME3nbeG82ekxwDY4D9tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767563000; c=relaxed/simple;
	bh=boA5OMAEjhl8pFf00i2VhzAPb6mM8UZcbloPgwtq4gI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R2yiqRi/XHNTM5WBbfFNCn4RTRa1cbwST+2Fd4aCo/YqxhWiix2sPC4BV2zPdkPqDlqfVmBN+7r9Eo+Xkw/ZNo2Q82SdjmJClSO6aesiY5AUqUCsWf/hIhmqOAFNIvCJuylmp/cgymap7fczxHUkY9RUrczBZVTqwHu/UXJ0Cfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DpmvsBmV; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DpmvsBmV"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 604LW4Lk4188559;
	Sun, 4 Jan 2026 21:42:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=yKBRbmL2uoAxLnFtcn1Z31cpk9jSwiqmeefgGAzxEWs=; b=
	DpmvsBmVGSYhFzeFUFubGJkwDNWSu53YZalLS7TvkyCalMWdyO4ZWuj37I7Ly/Wp
	AL+GNZsEa+hbKOorBTBgrW+za+pn7c11Q++lHtL/ThqwZKw4V4eBoBXd7Di83jhC
	ptM8XflipZuM1g06UzHyMCaf25IySI27USNtNNf+q23iP552fUS3lOXMyWiT4QbD
	JTtjPkochlkSMsjNJM3A6Ipaja1vm6zO5FQXRXDNaU9RB0LPDARdPREnEAsGm6nW
	EZ5VUNNkkk7lgo3YUpOiW8r/br4+Gd9aufNIF0VbnHiBm6DoQX5iFCku6cnfThVJ
	/QffD3WBOB0UQxJdrha0TQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bev6ngxwm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 04 Jan 2026 21:42:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 604GVRhw030640;
	Sun, 4 Jan 2026 21:42:54 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjarf3e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 04 Jan 2026 21:42:54 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 604LgpJ0034017;
	Sun, 4 Jan 2026 21:42:53 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4besjarf2n-7;
	Sun, 04 Jan 2026 21:42:53 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Zhaoming Luo <zhml@posteo.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] dt-bindings: ufs: Fix several grammar errors
Date: Sun,  4 Jan 2026 16:42:47 -0500
Message-ID: <176756271681.1812936.13149182307929477826.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251217-fix-minor-grammar-err-v3-1-9be220cdd56a@posteo.com>
References: <20251217-fix-minor-grammar-err-v3-1-9be220cdd56a@posteo.com>
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
 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=741
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601040199
X-Proofpoint-ORIG-GUID: kff58srjdYGhsGpB-jQ9YJMzsLOxcP61
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA0MDIwMCBTYWx0ZWRfX7PysqfdtLKOc
 vG5/raAnS3d/nCp+JDFqbxuLVScIVDoTeUXqs6p28wbPIVBtPSxj5hNCaql6lVShEitSL8jJf58
 XrPUb+O0WHak9511LoMwF337lb0s8DdcRC7Xv4NMxzD+e/Fx0LvREiHiYjns2nBBfFONJGdIsHI
 b1GPDDs7rwISuR6Y3KaeQSYZ1ENN5h+UkbzkGCmZFJJ4/hG+NWrx33bG0FPnr7eQI6LGb3K5z1w
 k97aqe2ZvIjqRkQa/77oxjsTOkZM/FQxoqIjmdkFI1ieLWTnhG+cNhwAeBvVyp997xOunVVLgXa
 xOl7/2l7sc6ePBhc6UI2DXm3hy4E1+jSy9FltnACfi0S5AcmPX9ptM1ixt5hRPkLRCJ3kfhvSxb
 QjwF9VR6GBIvZXZBJRkR7cWj9OghTqN8h2ZrcsgHgQ0EHC0+kbbXpfGukpQp4V7ZbDZIjQlHG67
 k4vctrkjiUsyj/PIHhaI67rehh21lgU4Ei6yp0kA=
X-Proofpoint-GUID: kff58srjdYGhsGpB-jQ9YJMzsLOxcP61
X-Authority-Analysis: v=2.4 cv=QtFTHFyd c=1 sm=1 tr=0 ts=695adedf b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=igFk8M4bcQljQk-mh6cA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:13654

On Wed, 17 Dec 2025 22:03:38 +0800, Zhaoming Luo wrote:

> Fix several grammar errors.
> 
> 

Applied to 6.19/scsi-fixes, thanks!

[1/1] dt-bindings: ufs: Fix several grammar errors
      https://git.kernel.org/mkp/scsi/c/be4b7e584a0c

-- 
Martin K. Petersen
