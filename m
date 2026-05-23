Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D052E2665;
	Sat, 23 May 2026 03:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779506134; cv=none; b=REHGW+OsTlAQxgbdpYY+uH6f/nRdqShMen+9kNdZe5cCtlN0Ju2dgOD1BRNRmb+7sqgh+neTPZf+FGBvx3oXdSBLA6heBF/Vgs1+WsjexJs1Zj6CAkI5+D1ZBNYzNqJzhfJWD/EuuMOkh+dPEkODNJElbONZ12sInJC8n+ho8wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779506134; c=relaxed/simple;
	bh=q9P8OlYef9OwmP6Ll2jnIPgdbdY5LwAm1B5Z5HqmwHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L+qwVYE/QHoJs9+KNq6OxeodVTIQLm/I480PUDA9dZ/yXVw9/2OMe4qVDQGkNOgACzdNVVGaUrkxQTtwmf3Mh+Xo/cKOVxE4gWHqPc/3jjRbQcD9BzMPZKTmB/jYLTZh/zHDJ6q+niyWRNAm/U3KJ6/M2Mfded5NrGLXFbLtyKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=I2gQpg2S; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="I2gQpg2S"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64N39nup3040029;
	Sat, 23 May 2026 03:15:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=+wOTczOvw6Lkx5vVK4r9+CXsWC8ZU/5pomdEhl+n7+E=; b=
	I2gQpg2SxTXZVB131m+63sx5tcuCJzjWzlpIqdxEDR9RfsE/CbdMgLr2y70sf7bq
	s0gT2sTOhZ3M5E0N2u7uXz7rLobAiJmxLFxxT7qCq4DmC0SRD3kqGUCdjg5lhqN2
	1P0VXJ9ZnFGHLXzLR4+DlAKoOR+gGTLbhG7dK9jRcCIHwUKQl0890BZQt26rGuA6
	e4Ilgh+qPFeaEusl1vmrEziUjP1NMY/DBqh05cdAxzlXK71thmMkCLw+mewTRLWC
	UMh3aOsfEPjhYRHSYBt3NW0iMDGYmGSW6vgYSJ70KbPczwxpnfcVHEgozkhUNEb5
	J9VQUcR+ZLA8W6CS7MXvnQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4eb314r63h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 03:15:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64N3F6hx032318;
	Sat, 23 May 2026 03:15:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4eb2p6hsk7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 03:15:25 +0000 (GMT)
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 64N3F9eM032824;
	Sat, 23 May 2026 03:15:25 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4eb2p6hs6k-15;
	Sat, 23 May 2026 03:15:25 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Md Shofiqul Islam <shofiqtest@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, bvanassche@acm.org,
        James.Bottomley@HansenPartnership.com
Subject: Re: [PATCH v2] scsi: scsi_scan: Fix typo in comment
Date: Fri, 22 May 2026 23:14:29 -0400
Message-ID: <177913641766.1181900.7908316947223848455.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260506094504.2235-1-shofiqtest@gmail.com>
References: <20260506094504.2235-1-shofiqtest@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-23_01,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 mlxlogscore=855 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2605230029
X-Proofpoint-ORIG-GUID: 84UGm-MArPh7KK7Mu0iT2IvT8dcuygMg
X-Authority-Analysis: v=2.4 cv=V9BNF+ni c=1 sm=1 tr=0 ts=6a111bce cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=PgBU6Vl2tVd-eOGE1OcA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIzMDAyOSBTYWx0ZWRfXxSYSxeKWbFGb
 yydB+o5wDBm5d6Gn14+PzsOkYAtFVSFhX8KNAQV5OU7AuaR58+TdGRa7bVRsSgaFScUiFjfk1FS
 JgbSX04yZ8v1UcnyNNyTP8pb7fGSXum6VRLh3Wd0/dovywGshd35X4pfW6Ss4b0hh0YAlgisXmS
 2VR+0EHfYqyMIzXagGOFsbtcgFge/KUkPSBqIxHS91qJldgDGjSeNd5K6z7Z3HRKSMxBFBUUzYI
 BF7Lkxy6wFfq7Dc4xxDaGtzGbyVmoGJLsp/SI+8sZuK5O2/fgR/VLe/Ur8KQWIN0eA9/h41vmev
 Do/Akmu7iPv32s6qaImm4GluL2CSq+2WEj4paESekXsj1KPus/VbgTsa/5z0CeybnLNTr1tKeTD
 4KmGixiOHaeU5vpqCrNMbIHu93uiQuC5ntL7qJy3J5vIrSMBVK07RSWds5bXe8ScolsF3al/JZn
 e5WNlfxKKSeV84WKbew==
X-Proofpoint-GUID: 84UGm-MArPh7KK7Mu0iT2IvT8dcuygMg

On Wed, 06 May 2026 12:45:04 +0300, Md Shofiqul Islam wrote:

> Fix spelling mistake in comment:
>  - initialze -> initialize
> 
> 

Applied to 7.2/scsi-queue, thanks!

[1/1] scsi: scsi_scan: Fix typo in comment
      https://git.kernel.org/mkp/scsi/c/036218473a84

-- 
Martin K. Petersen
