Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7EC3209696;
	Fri, 10 Jan 2025 21:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736543868; cv=none; b=HwA7CIGYLNu0B4uxbBkYx2exzuWabd/Q7G7TzhGD8VxwTXdiv29Oi2k/Ay6BBINx3k1uc6dQGtGRIK6GUxispY/whw1ukGDyZ0kZGD1i6SV3rFgd00WPSWaQ/dCalZwiOWgzBe03OnCPvmyiS9R/w30fWJ+E6drIR+dMYjkiy8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736543868; c=relaxed/simple;
	bh=hVgxAbmrpHX9RCl6I03bWxnpKMe9AY3mfgSi8GmF9ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=renj9g07PUTRouJ9vvKdyc0Yk01RczW/nHcESlpo5wFrOId6V36FWM3MFOMcQx4BSzRyc11m6qxQGKvH1gxeXwdP5ddeIOU5eT2UQb+/oM2zbzHQy8ijP+F0WqkwbMaM5JkgsFIISROuhe93q2frMEEz0e9E9tTCvRxU6Lw9BYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QOcyFMH3; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QOcyFMH3"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50ALBuVe015623;
	Fri, 10 Jan 2025 21:17:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=Wss0bg733hraIYo2ukdT6lVAZyOSmwp9bRIr/slQB6U=; b=
	QOcyFMH3pPhbkXoH6NMGauYtymt5AnjwrCKSIG224aBSyVWpttxfH6zgPYRiIaq6
	M5GEOGyXV8EX2WI5F0ePWgNZ+CWqbN6LTBRogk+/2E4LxQL4cpOuqsvV9pN5bMeM
	fbgLEeTDsmjnfJRYgwCFvYBsy7KoMIq5vHI9Ng57JoR26tWmO2zAmaAg6X15kYQK
	4qu8IBm+csva7EKfFx1BNjQ3qGFtuXbOZ6tIzunVdzGPaSgzdva2ijSQYqXuZxVs
	gB/qQ0dyAst+0qjR3ENoiNFDTIQl1kZ3jr25wWoTEgkWtztpmtabZaqSISPf0yDw
	bwWPQnl408mr1k1zWwyIyA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 442my6261r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:17:44 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50AK2tYF026550;
	Fri, 10 Jan 2025 21:17:43 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43xued5raj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:17:43 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 50ALHQ2G034137;
	Fri, 10 Jan 2025 21:17:43 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 43xued5r3k-14;
	Fri, 10 Jan 2025 21:17:43 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH] scsi: driver-api documentation: change what is added to docbook
Date: Fri, 10 Jan 2025 16:16:56 -0500
Message-ID: <173654330200.638636.14150526779604259852.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241218000748.932850-1-rdunlap@infradead.org>
References: <20241218000748.932850-1-rdunlap@infradead.org>
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
 definitions=2025-01-10_09,2025-01-10_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=926 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501100164
X-Proofpoint-GUID: Mfc8qDiGZFAcaj2I73BtvFA000qX737o
X-Proofpoint-ORIG-GUID: Mfc8qDiGZFAcaj2I73BtvFA000qX737o

On Tue, 17 Dec 2024 16:07:48 -0800, Randy Dunlap wrote:

> For scsi_devinfo.c, use :export: so that exported symbols are put into
> the docbook. Drop :internal: -- they aren't needed in the docbook.
> 
> For scsi_proc.c, drop :internal:. This will cause all documented private
> (as is already done) and exported symbols to be added to the docbook.
> 
> For scsi_scan.c, switch from :internal: to :export: so that exported
> symbols are put into the generated docbook.
> 
> [...]

Applied to 6.14/scsi-queue, thanks!

[1/1] scsi: driver-api documentation: change what is added to docbook
      https://git.kernel.org/mkp/scsi/c/defb7541dac0

-- 
Martin K. Petersen	Oracle Linux Engineering
