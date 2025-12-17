Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4906972634;
	Wed, 17 Dec 2025 03:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765942828; cv=none; b=RT5Zd1gddmH7aWt6XYpmF4lfYaYmirHbLrZxEL/MmDbFsuOYuQ7/MS5eVeS0JzdVvU717LmidFUHNPOSn+8PDhD1KqdC/D1rXQ43nq3PoqNy15EDm7nwajCTFBbb0HGdY7PwBOx2WYm5i/sI1UjpXXAPWhhUU1eHlPi1NCC/0MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765942828; c=relaxed/simple;
	bh=71r/FurQ3F8BoPlQPTo4XR51vncUa8a5wL6EMIoy7yI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=emeo0Tf/gtET/CAx+f5TlzQP+5kDgAo5WZUCriCO9u4KEj9q5ksNGS0pPnRl2KuPoi7AOq/VZYBsSQpP8rdaiQBjohgGq+wmIa0UxG8RpWAuShwBT26tA1MusAGoyTc+H6DlzA1njxFzCKUuqIYEcPA+bQmrx2VlmDebq6iaOg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KKoH1JAI; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KKoH1JAI"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BH0uPrw1620433;
	Wed, 17 Dec 2025 03:40:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=JefgsMDvIgjDVp5l7Q6RRnRpOpslcYHcAFwbInCYynQ=; b=
	KKoH1JAIHGZjj+/svV5RbKfMYdNY8UqKf9U2sGTfmIuo9fBLS1CtX491BxfviyR/
	B72Eg+5gTFsQxZ4LI2AsrLybshnoX7nr5Sc/5FcdTo/uUL1W3WO9TazIMbxkIyio
	59U+ibPAanQWqLdnUr9Vi342WzFmpSpUSLi8VKbt1v72wpj5q/n432UBZZQmAcNm
	QCZ1wHi0I/JqFkRJdFPnajaRh8t1QzFk54MjEK1HyFNk5SttF5Ap8Zo6EqJ9CNLf
	LQ1cv1T+z7Bw2fe1Jl9I123j6t2vvR70xgE5uAYcLysAcTD+rhcDijeoc06+tvwH
	8Jt7AwJHhMdXoiqKiRZEwA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b0y28d7at-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 03:40:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BH2Igep025257;
	Wed, 17 Dec 2025 03:40:21 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkb9ae7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 03:40:21 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5BH3eLwX023311;
	Wed, 17 Dec 2025 03:40:21 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4b0xkb9adw-1;
	Wed, 17 Dec 2025 03:40:21 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        sathya.prakash@broadcom.com, ranjan.kumar@broadcom.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] mpi3mr: Read missing IOCFacts flag for reply queue full overflow
Date: Tue, 16 Dec 2025 22:40:14 -0500
Message-ID: <176594264282.1094313.6410433967402959190.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251211002929.22071-1-chandrakanth.patil@broadcom.com>
References: <20251211002929.22071-1-chandrakanth.patil@broadcom.com>
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
 definitions=2025-12-16_03,2025-12-16_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512170027
X-Proofpoint-GUID: ZxOCGoa3TiG6Xbq5hvBOlgCrzWaUCnnA
X-Proofpoint-ORIG-GUID: ZxOCGoa3TiG6Xbq5hvBOlgCrzWaUCnnA
X-Authority-Analysis: v=2.4 cv=fOQ0HJae c=1 sm=1 tr=0 ts=69422626 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=mxwuzmj4nLXzRVQ8sVoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE3MDAyNyBTYWx0ZWRfX2dVhcHc/OdN4
 dRRbulX8D1HmxZ4j9Ii0SLmUS3fkhhwsbsJFROs63aQZofBFySEOFuvlRDZwLSvn2zRYuoeEK1C
 hKjw0e2St8QuogEWHDH5JE+hLPU2Q/j97y9g05o2a1DfjrgTlut8sub5f4f3vspB4wy1wz1JmIh
 jC7iuz1FBZM0T/PzykBpPfCVSSFRQBIogfZhYG8LI462EdVI4HPMUaIrGQfEu50DtQ29DXpymC4
 CfujNcoclMapGKmrLD0kDAfGanI3/gJ88Dblqo/XiMMzynhKPt7XAXIoNeoKQTfl0Qz/RtynXd7
 6ZZ1wp/iuE6irKLQaBB9bAGGiQe/Eq9Ehn7IpU/2I/1iryWhw846gU2mGWCjz6UB/1c8uzfCYhh
 5rEAkT4os9ZRcypUz0IcMGZStGmdiQ==

On Thu, 11 Dec 2025 05:59:29 +0530, Chandrakanth Patil wrote:

> The driver was not reading the MAX_REQ_PER_REPLY_QUEUE_LIMIT
> IOCFacts flag, so the reply-queue-full handling was never enabled
> even on firmware that supports it. Reading this flag enables the
> feature and prevents reply queue overflow
> 
> 

Applied to 6.19/scsi-fixes, thanks!

[1/1] mpi3mr: Read missing IOCFacts flag for reply queue full overflow
      https://git.kernel.org/mkp/scsi/c/d37316319498

-- 
Martin K. Petersen
