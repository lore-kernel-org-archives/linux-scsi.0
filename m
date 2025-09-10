Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE39F238C08;
	Wed, 10 Sep 2025 03:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757473491; cv=none; b=IAkyqUWRbioCvf2yiPty/RN+S/B+Bm0liy6kvHHsfv70ChjNMYTH0Y0vG7gMlfCnZ+qwGa0aeSxhmMX5pY3Dhd9C09raElWLEI2AQWCCrlT8JB6xUHIhcopa1ZgRC0Fc1oCu2m6CJS3hVjCUNLcgwc0/L/QS+Gwots7xSKNI4u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757473491; c=relaxed/simple;
	bh=1RWtBZfniRYhi6GItegTJS8IjI/lkuaZRrasVZYa844=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PUM7MOG/aNanRI4Re5om9fElsqWRTc10AQgvFJPdZ5USwRf95/IUGge44skSuPvOjGsFay5ueU2hk3UuIOmqoAEE/0xoP0/TfoXsXvquaAcWxdnOZ5HY/yLGbFMMqQtxXbhGfGn5ZKQeAAtH1PGTujYQzQppwZwAtKtFfwkKYfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WKRuCEGw; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WKRuCEGw"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 589L0k7I024171;
	Wed, 10 Sep 2025 03:04:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=00X5uJhZwRCZDbQHyLsVyyJZjcJxfOkXt7BpphFLRws=; b=
	WKRuCEGwqpCgkU6W4CQ2OmZnx0bajKAOtBjEnaRGKXsJxBzkev37Y/klnsx+wIaM
	uIhtmpyAgfN4VTpvLzejCJUD/+UfU6UmsXWl5AZik8VyhIBqJVfc4jlzRqZkpM2c
	+w6eRNpJPbyJp946SQVqzeLQaFLTGzrLg4akEIiu+fo0nTN365A7NGlSBeQzk6kV
	2/3/6o/FsO4c1aoTVJ1iJ9imWKnTJM9v/VrMSX4tOM7zq/GDTuEYyLJ6M9acdjLW
	ToEzmNDbyrJejzE3gF9iH1Ic/IkzV5TxOVG0iqABWBrt6aFp7X9288O6Yu5XJByh
	wL2hwozVyz1pDA4d/O8pjg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4922jgu5aj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 03:04:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58A01XHT031542;
	Wed, 10 Sep 2025 03:04:47 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bdadcwa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 03:04:47 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 58A34g5e011326;
	Wed, 10 Sep 2025 03:04:46 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 490bdadcur-6;
	Wed, 10 Sep 2025 03:04:46 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com, Xichao Zhao <zhao.xichao@vivo.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: csiostor: Fix some spelling errors
Date: Tue,  9 Sep 2025 23:04:38 -0400
Message-ID: <175746865976.2804493.695778098703955774.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250827121611.497547-1-zhao.xichao@vivo.com>
References: <20250827121611.497547-1-zhao.xichao@vivo.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_03,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=807 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509100024
X-Proofpoint-ORIG-GUID: 5talNjQfafGGy86V0ig3Sroshp2-UsPD
X-Authority-Analysis: v=2.4 cv=PLMP+eqC c=1 sm=1 tr=0 ts=68c0ead0 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=7kqrXFrDgR_pPvtGJbcA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 5talNjQfafGGy86V0ig3Sroshp2-UsPD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE2MiBTYWx0ZWRfXxqGjhyCyuvJg
 Qh3F9rXwhhPLAVAUvo9SOORJtyju6L4Ta4zaJL9nNipGIXCjBTgQVdBd2/VD+ysbP26RpjvEtJx
 NB/02BfARZbv3BoSiwbd8iFWd6Vkx2n954JDTunURBpBtlb4vNDtFcjYzdOseWTM3L7xnNeLksR
 BRFPbrdv/bQUtR3/4EuxlGaU2cylHXlE03GngKYL4hdgMLHImAKHwkW+m710kwz2j2guAaKFmil
 GX1o3fqz8H8S5BQaWugtsjBz2KyH7RY2EqX7Q77+fclsfsDZnoQmtyqtYtbhAVSDEyWBbZwbGHn
 FQndUUmbCVM7OroObVahOPESKCk3Uw076+PkqozT6H1EpHGcatxHnvs00mVPm5bkEfjOvCQY1rx
 x4yiXQyb

On Wed, 27 Aug 2025 20:16:11 +0800, Xichao Zhao wrote:

> Fix spelling errors in some comments.
> 
> 

Applied to 6.18/scsi-queue, thanks!

[1/1] scsi: csiostor: Fix some spelling errors
      https://git.kernel.org/mkp/scsi/c/80093afdcc48

-- 
Martin K. Petersen
