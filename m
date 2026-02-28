Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A15B363089;
	Sat, 28 Feb 2026 22:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772317350; cv=none; b=RkmoxUGPrwRRUIxC5NR608bycdMjoyFXGKmlJqSlWfsDiS23cGSx6tFzWQzP4LOciaNt8GSLt3vDnLkcHC+Ok+V6pZL4W6TttJA8495cJtrN6mBuq9bBPyDezXejXjMETuhk2Kpf5Ac9TwvOMqK44vPcTi1YrH1oTXZOcUBuwRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772317350; c=relaxed/simple;
	bh=YVPkE/NeCyhbYL0DiIp7U+8LdjWl9ZnsqWu08ZGDlg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KnRpU6Ot0KQyHYIm9aYctXm0kb75wSafNnNfTGaC8wPMlY05YMo1E3nLnKSqUvmrdgtNXhujsC5XgJ3EhkONBdF2IeGHZm9iUJFuE+E78VW/jE0XuX3Iz2b19V66kGnPRz2Uhnk2jfdyNkk6eyEbK5NTYZVT6wgYbaY+lqTo3GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Kho2rTBw; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Kho2rTBw"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61SKd8qr2456665;
	Sat, 28 Feb 2026 22:22:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=rcuZYhgDbmvntPnJSE0MEigsu1v7wThgSt5wpUTx35w=; b=
	Kho2rTBwgXQVOHujI7JCc7CskRh449+uxupMuOYVLWiob+i8hSKcNr/1Alz8e8nr
	hpen9LysNzMWXKfd5n/QIFLWyXB7TbQkZI5YI2wMihwE3tRkczCMZZJQtRDIkNQz
	DI6vFC8/Hmto8PE4mjGmnqqnuDHAfhojtV4q7cf5vIga7WPDICPUopWbV48TwK9H
	UbYnsq0t6jOhBBR5+yZSQaijBIQYN1bQzktihumpsRQy+/SUwl2waj+rgsZNlwnO
	zJoi9e3RgPWT2vJsNqXMPv586xU9YlBkYWirKPsa9vceVOE5ypElvwp/gwU63459
	7qZcZpMQfSVbAPSrOyGrZw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cksh8rjse-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 28 Feb 2026 22:22:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61SL0kFD037736;
	Sat, 28 Feb 2026 22:22:18 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpt7bheg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 28 Feb 2026 22:22:18 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 61SMHlvd018394;
	Sat, 28 Feb 2026 22:22:18 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4ckpt7bhc9-6;
	Sat, 28 Feb 2026 22:22:18 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Khalid Aziz <khalid@gonehiking.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Thorsten Blum <thorsten.blum@linux.dev>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] platform/surface: Replace deprecated strcpy + strcat in blogic_rdconfig
Date: Sat, 28 Feb 2026 17:22:06 -0500
Message-ID: <177231727960.1778274.16035222472937487567.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260224144828.585577-1-thorsten.blum@linux.dev>
References: <20260224144828.585577-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-28_07,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 spamscore=0 malwarescore=0 bulkscore=0 mlxlogscore=907 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602280208
X-Proofpoint-ORIG-GUID: orTXQMsaDuFP4SOONMO2a1BwtxvMN6YJ
X-Authority-Analysis: v=2.4 cv=D8VK6/Rj c=1 sm=1 tr=0 ts=69a36a9b cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=YR8jykVuY81jn_sEDjkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI4MDIwOSBTYWx0ZWRfX3yQApEYNcub5
 46tdRzAsq6juh17vMyNqVZSAjgerl/hCTLi06t+nCndpMe7ibe55rb4vG34X9LzaA/nTB1eLqGC
 npzodfx54xDktvwg/FlTpGXPDILX9zv0QHGRB1XVaD3FTslZZZXBZjth+VlIGiwAQsc/lRNZFVk
 8F/ao1iVDEuMKb8FN17m3KwhtzDxMcmvII4m36kgNIDD25WG+eN+cLShD6rduDwW2Zc5r7OuheI
 gOiePkWY1s7HUi4LSDBe7FwbUvDQ2W8FeKcNjoR3wzNHchJWTwrm3/SqSLd/aX+hSpQAVVhAZxn
 meGQXDQmKQIzEiKfXmNpfcBAHYyAF1+b6Gzrv80qqHSXB9Q43YpYupNxMc1Khe4/7pGRwdVZ/oh
 mRAhKsBdVLy9dz00An5Pw/gYnYX4C6nri2qW5nyZN2/lArLg1gTv3oV9bA43BGf0d0uamZxJJX1
 f0uPYwQU18GJdh1Xrjw==
X-Proofpoint-GUID: orTXQMsaDuFP4SOONMO2a1BwtxvMN6YJ

On Tue, 24 Feb 2026 15:48:27 +0100, Thorsten Blum wrote:

> strcpy() is deprecated [1] and using strcat() is discouraged. Replace
> them with scnprintf().  No functional changes.
> 
> 

Applied to 7.1/scsi-queue, thanks!

[1/1] platform/surface: Replace deprecated strcpy + strcat in blogic_rdconfig
      https://git.kernel.org/mkp/scsi/c/931c105de11c

-- 
Martin K. Petersen
