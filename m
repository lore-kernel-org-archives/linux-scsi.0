Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799B312E55;
	Tue, 16 Jul 2024 02:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721097018; cv=none; b=qROaEas2VVXynCbzfdyLycB2xLmZMQeQAV+BEQ3XngMWgWJ5uLQ9iS7KIrQROV4rj2Y60dGySj+rDg4aC8woWzWgk1cjaX3KiQFP9fawlzRkHQp62r5ZE50YdVdi2Xs3i61nmbmO9wk+/NqIW6Dgf4DJ3dBjnQp//EAEXofTftM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721097018; c=relaxed/simple;
	bh=Anh3g5XsKU2JcZm26ganVqXl0vvT1bS/Ftyrv8mu18o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GB7ii4cyQal/LphsMZCTlE571V5H5dpJtpDlCM8iaFFKgM6nliwWakJ08NtXQ+QlONl0vYyS3WJwvUGrZ7fiewehF5+V0tmgLa/D849mi+YP6dJ5JNQbIVSSViqaFaPLZmyfnwL0QIt2H9GM0HlPs+KAVJcnR46fcNNPKhgDfdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aZiCnake; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aZiCnake"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46FLIgSQ002958;
	Tue, 16 Jul 2024 02:30:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=a16ojMF+yw/Bk1HXiH8nNAJpbm692nxXRPjcZ4SBWlQ=; b=
	aZiCnakelbzUCHxCu5B4X5ZsadxQt4ImqDznW2raLxLEAgPs9Ly5heJsF8V+kXnj
	9QDNtZ/lbbcvgFX25Hgr+tb8sFvWYWXyV7/H6OO3NAyRVe0pjwVq/lNWoARNGYlC
	PDFCxf49prblj6r5OZV6d+vKMlaYkcr2hHDWDT9s78D1FKiN644yY5FYY5vIr1YI
	y8n/ngZU2CCwDI8Vb6owQsg+NyYaEWYfr7fWmYa8VHyb8kF4e+wIqC4xigMGabP4
	pCAojk7ru+07QxekE9ICYT9sjsRvyWxOhnSYfF9lbJ5VRTgxzEz/DpC1jzxIYWOk
	yDg61HkntvwItC4sRR+A0w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40bh6svnf0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jul 2024 02:30:05 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46G1jG4g002696;
	Tue, 16 Jul 2024 02:30:05 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40bg1exxdb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jul 2024 02:30:05 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 46G2U3A9027682;
	Tue, 16 Jul 2024 02:30:04 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 40bg1exxah-3;
	Tue, 16 Jul 2024 02:30:04 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: njavali@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        James.Bottomley@HansenPartnership.com, skashyap@marvell.com,
        himanshu.madhani@oracle.com, dwagner@suse.de,
        Chen Ni <nichen@iscas.ac.cn>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: qla2xxx: Convert comma to semicolon
Date: Mon, 15 Jul 2024 22:29:22 -0400
Message-ID: <172109323563.941202.2035783546516054964.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240711005724.2358446-1-nichen@iscas.ac.cn>
References: <20240711005724.2358446-1-nichen@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-15_19,2024-07-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=756 malwarescore=0 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2407160018
X-Proofpoint-GUID: Cnmj3KRaeiUrSmC2_iWUN2t5_CUVN3G4
X-Proofpoint-ORIG-GUID: Cnmj3KRaeiUrSmC2_iWUN2t5_CUVN3G4

On Thu, 11 Jul 2024 08:57:24 +0800, Chen Ni wrote:

> Replace a comma between expression statements by a semicolon.
> 
> 

Applied to 6.11/scsi-queue, thanks!

[1/1] scsi: qla2xxx: Convert comma to semicolon
      https://git.kernel.org/mkp/scsi/c/6ca9fede7c73

-- 
Martin K. Petersen	Oracle Linux Engineering
