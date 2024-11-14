Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A141E25F7;
	Thu, 14 Nov 2024 02:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731552657; cv=none; b=cSnmvMBN4HE2uEFm11SY3cNgz+Sdhz2HS1Ii5eYMtFop0UDNCVCYAYFJwRv2ewPhS+SY4wJG+Rnw/JvIh4eKNum1RWSm84zc1MOlQNBenevvfPlmVs+7Cr/uuyav+K6HekGN55a6C1oaaeq3Xt8ZYsFe4VUHH2NOHoiab3HddcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731552657; c=relaxed/simple;
	bh=Vh8Bf9YrFjqQ2EJ4nv367Eaqr5Zss4CfAl+D/9oVBew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GToO5WVWjXb81+435oA6YNGCJUzMyj4gk1XwL2mKyQSyofAjGJ60ztkh781qja8l+DMwSqYjxLVzRXUbxESwGhdSPdexPMj+jh1YY1vmEssx/+2foTMfaluDFxtRjiVBLz/px2CnZjiUQqge5yEfzrQYxzdVYFWn8N6R4SoyBBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=If0r09zr; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="If0r09zr"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AE1h1wd008864;
	Thu, 14 Nov 2024 02:50:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=eiM0WcstWeeIcEkfTz7lPuaR5930wv3hByW/Yv0r5IE=; b=
	If0r09zrTcwY7wjMb8l4hHKRtzeAALP9U+LOxX0s6kN9PygGREVuKDMinDGBNxk+
	hJowrsrrsklvHKUz8x6bgPyveP14Q4fqimRysp9gYjTkWxcKg5Qok4XbZ54pJwM7
	WAT1/7BbJWwEgO6JdiKO/5cHfBr3V3z22uPAC1WGiNrKuIqMI3rvo4jE6OYwSUx5
	p+/bDlu/1PvyyOtFpRD7UDmXhvFFBW5mI4+HvibdbjVdLT4vplj13XzlTNHPEoup
	smwXU5OVokn5D9EkhyEAesyGs9fgulkGriPW7gbLnQz0wYpbofh0sXOTHeY9128q
	hcmbCm9WnhnhnECv162Rdw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0nwr8gu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Nov 2024 02:50:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AE1FvCB022800;
	Thu, 14 Nov 2024 02:50:51 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42vuw0p1yw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Nov 2024 02:50:51 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4AE2ojYq003527;
	Thu, 14 Nov 2024 02:50:50 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 42vuw0p1vg-5;
	Thu, 14 Nov 2024 02:50:50 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Igor Pylypiv <ipylypiv@google.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: pm8001: Increase request sg length to support 4MiB requests
Date: Wed, 13 Nov 2024 21:49:58 -0500
Message-ID: <173155154786.970810.18106220714427816741.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241025185009.3278297-1-ipylypiv@google.com>
References: <20241025185009.3278297-1-ipylypiv@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-14_01,2024-11-13_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=970 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411140021
X-Proofpoint-GUID: SNBn4LmUabSXJ8NYgZFiN6Cv27NrDf91
X-Proofpoint-ORIG-GUID: SNBn4LmUabSXJ8NYgZFiN6Cv27NrDf91

On Fri, 25 Oct 2024 18:50:09 +0000, Igor Pylypiv wrote:

> Increasing the per-request size maximum to 4MiB (8192 sectors x 512 bytes)
> runs into the per-device DMA scatter gather list limit (max_segments) for
> users of the io vector system calls (e.g. readv and writev).
> 
> This change increases the max scatter gather list length to 1024 to enable
> kernel to send 4MiB (1024 * 4KiB page size) requests.
> 
> [...]

Applied to 6.13/scsi-queue, thanks!

[1/1] scsi: pm8001: Increase request sg length to support 4MiB requests
      https://git.kernel.org/mkp/scsi/c/53b550de4635

-- 
Martin K. Petersen	Oracle Linux Engineering
