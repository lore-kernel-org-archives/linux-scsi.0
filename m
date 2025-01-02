Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92EF7462;
	Thu,  2 Jan 2025 22:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735858045; cv=none; b=bSQVSBgyFsFOcjlGRNpFYYNZFz6vF8DOAJdbDMhjPuiQdYg9iP2/Z5W4vCM7gL888KMr+cwjS1JlhI18rU6/7CMxgtLn5NvjGwUAvins8kuppl1dQ8nWttIvW5enf0mIsjMb9EL46Za/SJA9wGDxrgwQbBjtyJvvdMgo/miIl18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735858045; c=relaxed/simple;
	bh=a5cuXFWgOBibvSD19RxJOlInorVzOA535uOe4bGhvUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pU392Fd4iy8j9ROg3jds0qBYmEDZYpJJ2d4yJX5Gt5BtR55lGsi97cEqYENdQjLQH3uXdeUjcZ/Ns1fbXSzbtYscfkDOGX2IEEWaXIEqx0/zS0qlipkN/LT+mpZYAtOlI1d69wrObp02JtXGVlBNnJQ/nzaQd5W/DVIK7Ctkfqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=H6tCOzNG; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="H6tCOzNG"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 502KgK1K020619;
	Thu, 2 Jan 2025 22:47:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=mM4h/FnL+1EY+5mSZ44EyI2QE9s7+m/WyM51/L/loGQ=; b=
	H6tCOzNG2eOG+7rNfukXC9piHhYsCnwkTI7sm05CcaGVP3AcEogbR4jKQBvjzgOC
	zoT58igVoUvxM4snW9KXpoZRn2jKvH7W4jHQFP14RBd8OJ16IvN4FGVKjVga/NSu
	8ZF9ONzieHhcojd2e4FvFywePGdFXfq5XMrl1DkEPgylssuHZ04wbXd1cWCLUVCq
	NB9WipzkRaHWbhlhQ5fyMSBC9X/uVWkEUemOkUitBiZwCeQnG9iNR+FfkoYT+JgT
	gO7hksXXUjR3jHI5xs8tE8ZQGmdQ8KIDoi5fhtHLxv0aDsqh+9LWbgAn2+s182Fc
	LcRlbFWOdgAyzTqkYsthQQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43t978q98j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 22:47:16 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 502KIgLJ009392;
	Thu, 2 Jan 2025 22:47:16 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43t7s93nxp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 22:47:16 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 502MlAtj004461;
	Thu, 2 Jan 2025 22:47:15 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 43t7s93nuq-4;
	Thu, 02 Jan 2025 22:47:15 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH] scsi: Docs: remove init_this_scsi_driver()
Date: Thu,  2 Jan 2025 17:46:40 -0500
Message-ID: <173583977776.171606.14398737494596427227.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241205031307.130441-1-rdunlap@infradead.org>
References: <20241205031307.130441-1-rdunlap@infradead.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-02_03,2025-01-02_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 phishscore=0 mlxlogscore=971 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501020199
X-Proofpoint-ORIG-GUID: lQrbIe61DjFOouBC8kPkh9kqosr54tlX
X-Proofpoint-GUID: lQrbIe61DjFOouBC8kPkh9kqosr54tlX

On Wed, 04 Dec 2024 19:13:07 -0800, Randy Dunlap wrote:

> Finish removing mention of init_this_scsi_driver() that was removed
> ages ago.
> 
> 

Applied to 6.14/scsi-queue, thanks!

[1/1] scsi: Docs: remove init_this_scsi_driver()
      https://git.kernel.org/mkp/scsi/c/8d14bfb53952

-- 
Martin K. Petersen	Oracle Linux Engineering
