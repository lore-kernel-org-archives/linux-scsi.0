Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15F41DFE00;
	Tue, 11 Mar 2025 01:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741655991; cv=none; b=Snib/bXKr3rO/QY5unFLLjQ9RJWpgzdNgSmm8th3cFUuo/wSPHpnzspWRYNvD0KZN8oxrfkcPJgQvO02bjm8sEvtVd8Fan5SCwHeB2goOnd7BNqv1A6wOsSQjGKQh9wbv0mMP6fogwaiwJ2ftx9c/oSgeLSlLZS8FQpouRZw/+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741655991; c=relaxed/simple;
	bh=hM2tVATT7TM/5XF8Mc4r0Kfgzmx+4k78n/0mAUPMSQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BHuhVVaD0klJmbNfUbHp+g+fSlbaP7/QpewDmewVkzDwjcUcttJ2rTJo4tz5omhEFkyxN4ighXVp7Pjr/9y+wF/PpP+viAcFopxGLb45Iz4GaWbXgCwyqJzAf4sL95HCle5rhB81s8npK3ZmUW5/guaGxP2U7b1QKD14ygagk58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Y8hjvSho; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y8hjvSho"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52ALg8YO017645;
	Tue, 11 Mar 2025 01:19:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=ibBFxc8fK0J6O2aEAiCmmlRMSljCZv35H4rVdjg3Xf0=; b=
	Y8hjvSho6WwL0ySJ8qHS2OYFMTcGNhGhGlxL/EJC+aSXTZ3iX+YxMq3Qv9CdPa+O
	4VZ1ZZ7w4aEuERluIF93J+8XrfUPeOT9HCvnYy8tzfuupwo0G+20wQib0psTWzBQ
	kuj6J2y6VlPVycb9OGxzbvNAGyMQKbzVm/MnL5YYnzaIsgLESXtMx8I1BrmWEtcP
	Zj+1Ub/hhLYOmQkWpe6P6fBZ8AkzkouE0ickXfnGBmo+eOUs6s+dNx69/jy4MhQ0
	FLFPBkEMCaw0NlLmC7amB2yULf3xdO6oXlX7d9kwprdAPwdNu1HahlXomp4T1K3X
	E1H55adVHD3lCUZnom0IdA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 458cp33vvf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Mar 2025 01:19:46 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52B0J0Fn015052;
	Tue, 11 Mar 2025 01:19:45 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 458cbencnb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Mar 2025 01:19:45 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 52B1JfrH014960;
	Tue, 11 Mar 2025 01:19:45 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 458cbencm8-6;
	Tue, 11 Mar 2025 01:19:45 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: sebaddel@cisco.com, Karan Tilak Kumar <kartilak@cisco.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, arulponn@cisco.com,
        djhawar@cisco.com, gcboffa@cisco.com, mkai2@cisco.com,
        satishkh@cisco.com, aeasi@cisco.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@linaro.org>
Subject: Re: [PATCH] scsi: fnic: Remove unnecessary debug print
Date: Mon, 10 Mar 2025 21:19:05 -0400
Message-ID: <174165505020.528513.11172822060032796757.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250225214909.4853-1-kartilak@cisco.com>
References: <20250225214909.4853-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-11_01,2025-03-07_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 suspectscore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503110007
X-Proofpoint-GUID: 71ZN9944kaaHH7RaBWNuDV8HU6aGcZ7T
X-Proofpoint-ORIG-GUID: 71ZN9944kaaHH7RaBWNuDV8HU6aGcZ7T

On Tue, 25 Feb 2025 13:49:09 -0800, Karan Tilak Kumar wrote:

> Remove unnecessary debug print from fdls_schedule_oxid_free_retry_work.
> As suggested by Dan, this information is already present in
> stack traces, and the kernel is not expected to fail small allocations.
> 
> 

Applied to 6.15/scsi-queue, thanks!

[1/1] scsi: fnic: Remove unnecessary debug print
      https://git.kernel.org/mkp/scsi/c/9b2d1ecf8797

-- 
Martin K. Petersen	Oracle Linux Engineering
