Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A82C1A01D3;
	Thu, 19 Sep 2024 15:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726761233; cv=none; b=duVryy/C+rDbFGnVmMzJpbmGJNn7QY0aA5UEuFvYQT/7xTEFE2YkbXdtLkkHZbAxI1iYYLh1yBpZ/zXQukTM6T0OTLd1vMbqY3Ul6G1N5KAdw7Kx2cNeMaYQBrRRQekEPs3VxTmsYTo88NXiXW+Axu/CdX1HNWGwv1GuNkfJhOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726761233; c=relaxed/simple;
	bh=jo3TFiFx/N2EmFz3jVz1F96Ld15njDQ8XfMM+Kh48u8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a3FbD0a11AUINZEUNkd4icfUtdqBGfqoO3JjYbRcTfrXGGcVvCCFZkl/PXKi8FmG5M5urexJKsSTC4hPGcEgwnjj/bZKzm9JXO1LlOrB70qJUfcKI29lUjYJDfVWMsS+03FdF2p6CJCNqT4XObSWZNGt5miDn+XgdHPlke/1Dgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NiuueSWG; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NiuueSWG"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48JEii8S008059;
	Thu, 19 Sep 2024 15:53:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=KnwA194irds/NaTFt+o3UsRBy9GX22a8ZbYMTsgsjWs=; b=
	NiuueSWG+5JFx7+VQ12kLbOYkCNC+wlipkWtsyRWo99aLh0WwVPJ5RxO1MLRUH3v
	Xo4EZHmhMoLRrBdjICdfKdIYoPkvxK7MoX3QFoRn8tSUmCAiugwYCeuDowvwnLej
	F79yUr00EghY1nfjQsLHi3P62Pfs4h40V28tV/w94/O6RhhvfxWEoIP21uv1rdx9
	YsixQ8ryyhShj9JkautCVcuVdUbiUMh8cQJNqppia5NqmsLhnFzuGmU9iibayxjB
	xc/R8q5+dtsBGgacUb0RZk3nmHQOqhqZV3ZE7+ouhqFRZG6vL1yWELNAUg5tqemB
	OdT11qgA6RQj1Q20O2r7Ug==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41n3sd4mfk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 15:53:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48JFhL4D010398;
	Thu, 19 Sep 2024 15:53:46 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41nyb9xj9u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 15:53:46 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 48JFri8h031813;
	Thu, 19 Sep 2024 15:53:46 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 41nyb9xj7h-3;
	Thu, 19 Sep 2024 15:53:46 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: scsi_debug: Remove a useless memset()
Date: Thu, 19 Sep 2024 11:52:49 -0400
Message-ID: <172676112049.1503679.10469211610378676302.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <6296722174e39a51cac74b7fc68b0d75bd0db2a3.1725690433.git.christophe.jaillet@wanadoo.fr>
References: <6296722174e39a51cac74b7fc68b0d75bd0db2a3.1725690433.git.christophe.jaillet@wanadoo.fr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-19_12,2024-09-19_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=759 bulkscore=0
 adultscore=0 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409190105
X-Proofpoint-ORIG-GUID: oWFASKyR7U2tLziMf4Rd-iUCfsl12il3
X-Proofpoint-GUID: oWFASKyR7U2tLziMf4Rd-iUCfsl12il3

On Sat, 07 Sep 2024 08:27:22 +0200, Christophe JAILLET wrote:

> 'arr' is kzalloc()'ed, so there is no need to call memset(.., 0, ...) on
> it. It is already cleared.
> 
> This is a follow up of commit b952eb270df3 ("scsi: scsi_debug: Allocate the
> MODE SENSE response from the heap").
> 
> 
> [...]

Applied to 6.12/scsi-queue, thanks!

[1/1] scsi: scsi_debug: Remove a useless memset()
      https://git.kernel.org/mkp/scsi/c/bba20b894e3c

-- 
Martin K. Petersen	Oracle Linux Engineering
