Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16CF81F4CA9;
	Fri, 20 Mar 2026 02:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773974191; cv=none; b=p2GlKi8QvcM485UrG69Ezcss1X8CWDvDPc3IltGfItU+ZUA2Xy/ObpG7y5ZFqzz84vRy6P75tKNAIDzdW8rf26sn6HGueTUmt/DOKbrpuE8al+F5ynn/j9GnoZZhNlhsXPciMv51Tsy5umP2B4+VAEHlaoTsTBl2soHzQKi3/XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773974191; c=relaxed/simple;
	bh=8GH5a5GvIB0ha+ql0BNW09cd0QvJ2VXV1nFX2hHWy+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rrq+yTuh/zzpcgg7NzHbY22zqpdBC3j5YDEzQukUfPgzI/lTFauBqBAsaN5dVxmwlIXtju3w6gH/gHowirnabrnNhtI3nowFhNIYOgcX8HGiarinVhdmuvM9Gw7YwsjnnRWCUl4j4vUl8hfF95nptCEoChr5NnmQNQ6RE3BExMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=W7ikQhb4; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="W7ikQhb4"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62JHh5iv2707496;
	Fri, 20 Mar 2026 02:36:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=LJTaczirZYdgh/TXCdP6iKepQE8DKJGmEsSSf9P5JQs=; b=
	W7ikQhb4yJij7oQpF7ssBWmEVK5ssoDiMo1gUxB3YsHbKmsrjPHT23f1L//Nga8e
	m0l70zbGtx64pc2Ho9L99/TYgzdxRqSXGRt4lJNTCJPJI8y57Mp2zmbDRSfAVO/c
	jpMu6hzTEgST1xLGyY2RUXQqB+Ttvxc81xENewlOluq6Sa+XfZ7OKm1Ga/vUKep8
	aE6drG/P0phufsj/hnCtt9HPeyZjzRkLeXCx5bci40vNymOZIoVNhb0s0XBfnCxm
	DaMgayhwlKfVpZO4AgqbarwgbGtorgyES9Dz0cJjvnr6+d1RsVq+MxNCDeUHMftW
	6kdhuu8NpshgMBU08Xp/ig==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvxf48u7n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Mar 2026 02:36:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62JMjSLs003369;
	Fri, 20 Mar 2026 02:36:16 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4dp7d5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Mar 2026 02:36:16 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 62K2aDRP020555;
	Fri, 20 Mar 2026 02:36:16 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4cvx4dp7bq-4;
	Fri, 20 Mar 2026 02:36:16 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com, ranjan.kumar@broadcom.com,
        Yihang Li <liyihang9@huawei.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        liuyonglong@huawei.com, linuxarm@huawei.com
Subject: Re: [PATCH v2] scsi: scsi_transport_sas: Fix the maximum channel scanning issue
Date: Thu, 19 Mar 2026 22:36:03 -0400
Message-ID: <177397393959.2929898.16094711782711924004.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317063147.2182562-1-liyihang9@huawei.com>
References: <20260317063147.2182562-1-liyihang9@huawei.com>
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
 definitions=2026-03-19_04,2026-03-19_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2603200019
X-Authority-Analysis: v=2.4 cv=ftrRpV4f c=1 sm=1 tr=0 ts=69bcb2a1 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=mZIjh7zGpij64chpgtUA:9 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
X-Proofpoint-GUID: W9PKaDR056XCpkQURrxVfAWe0JaFPF96
X-Proofpoint-ORIG-GUID: W9PKaDR056XCpkQURrxVfAWe0JaFPF96
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIwMDAxOSBTYWx0ZWRfXxcIr6VNasnjP
 +8gNoCfygYpAw4lR8w4aqJ3pF4kfcdprwi2mU/s7uoxXqeh01qXNUHGg32N8Fnh5jQaR9EOg5Si
 GBjCSJQ/sY42xvFqObJBnC6ZKxLUdeBadTFJ8FIIeby0tgKMHRlbA4MWh3uO421Mt0FyCle/9+r
 U8yury6CS1C1cUn0J3sRgW9lCKsatQOkjqyI+1D0HRv99CTTJEBLavYTvaB83NWaz9y6/pPwH4l
 dmWDzRF4aos38XTW8YgSnNeotIapKJKL3NBRAr1BXrJ9b3HAyJA3poBo3+IfXqAGrsvNF7vcMp2
 qC2l3IGSnppScOB4CCmFtW5Y3M386oD5AZCkMttSO/Aj0yc/AyFtO1atXrK4sYapTWzlAK2fjKN
 jsBQEqoI+4IN5faWeQ85WUbnWgRsjtO/aJCZiMUANgyHlmxOeRhmqpXgvjMmk0A3S7Dj1Cz7rrf
 /f8jqprDZDAZmIquUtQ==

On Tue, 17 Mar 2026 14:31:47 +0800, Yihang Li wrote:

> After the commit 37c4e72b0651 ("scsi: Fix sas_user_scan() to handle
> wildcard and multi-channel scans"), if the device supports multiple
> channels (0 to shost->max_channel), user_scan() invokes updated
> sas_user_scan() to perform the scan behavior for a specific transfer.
> However, when the user specifies shost->max_channel, it will return
> -EINVAL, which is not expected.
> 
> [...]

Applied to 7.0/scsi-fixes, thanks!

[1/1] scsi: scsi_transport_sas: Fix the maximum channel scanning issue
      https://git.kernel.org/mkp/scsi/c/d71afa9deb4d

-- 
Martin K. Petersen
