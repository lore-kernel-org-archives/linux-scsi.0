Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9CE22F760;
	Tue, 29 Apr 2025 02:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745892571; cv=none; b=He/QfrpGHvpTJ8wkgZpXd595jQLtxlPYlzAEf7mGwKUBPCxSURPyR4nW1oXYDmJZJsJU6tjhs9mGRmphoIU1TEUwhnwWSbp8/wYPhBfDPoYykPvfKcklYjyJ64m1ovKvPD4U6rb9mc8wk4Ep8r31tztwRUP7bmTjLjolpf/jgBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745892571; c=relaxed/simple;
	bh=+ohQ14rv7MFDMOo5EP4fnDKIB0JftjbjJLO3cVJE95g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GyVAU7ex7aXM79Y0S6AIR+4vQpFdC+dyxp1+cNPdnkLerjLkFno70ht7YFCWT84gUTUHYK4XBDBZrZaRQ/F+NyvqCyzZIehTzWvt+YppqRNs2t7onBZVP6CrVPP/eQRlpg9dEe0QXmqI9fdFjchbB/vem6lnici5UOZXwhBK0EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Hc15awo6; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Hc15awo6"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53T1fuM4017503;
	Tue, 29 Apr 2025 02:09:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=MePvvhRdgLjliZdQXzcotEpNkI6VWlzha3mI8CvhKxM=; b=
	Hc15awo6dZmDuybXVB9aNV6/QBQili2n6cGN+hshjnVT/GQFj7JzzRyy1ixNMs9a
	Lg28lN/l7uYFb+A8okvz/Vh+JxJYcktULwS8S78vp/imd4eWD8bU3Im34AodoUpa
	e5Vi+y+WptbVyouOcVIQ/twkL8t++W5i+zTcYwSMl0z3EUWgfVnIEHYXACpEgmVB
	uGc8mYt/bx7PZsrGeUvHE4UuLfGjuZlYLENXO1WuP3C1uUPlXoVB61+dxJ67VLVE
	b8EjoY0R9VdBC9HePjiAqzc+/d7tB/KjevUit9nG15YbHir91aklWMbh7y+cV7Br
	6UNAIXOngcjicXYH8gIawA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46an4781e9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Apr 2025 02:09:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53T0Bc74001325;
	Tue, 29 Apr 2025 02:09:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 468nx97244-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Apr 2025 02:09:25 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 53T29OCS020520;
	Tue, 29 Apr 2025 02:09:24 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 468nx9723t-2;
	Tue, 29 Apr 2025 02:09:24 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com,
        James.Bottomley@HansenPartnership.com, linux@treblig.org
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] scsi: qedi deadcoding
Date: Mon, 28 Apr 2025 22:08:52 -0400
Message-ID: <174588857931.3470741.1341489403703684452.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250416002235.299347-1-linux@treblig.org>
References: <20250416002235.299347-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-04-29_01,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 mlxlogscore=757 adultscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2504070000
 definitions=main-2504290015
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDI5MDAxNCBTYWx0ZWRfX+HQxx1jMQURj N8Xiwj6FpqfO5H7XiP6g60DnL5CnbYRObeMbDGryNhK96b71MhRWBy/Guda1GA1svZPlyOOXT86 Tnv4vC5W2tlBmUV9L05feqCKmnJKdLLaZUBS2gvlSyDNpZPTs2p9HxNUC/pvpxZA7gGz8zlHJE/
 SUKhZazTsFfzPImj1gxj6IQYJ2sgyZusBiKhRnaZ51ZyoWGV2Lt133lL76bD7niFvMa4gFsX6Rq 0eDT7iG3YavQ/+JZ62p8G7Bi4mMdbKPsbcunvlP/hq9tbrAuGp81fDMEcdHtTOjlPKCkBm9hPft bBOEJuw1aNScc8OMcRKeZMXe/2X7UhdIZURPc2sUnZ+0P478W6gX2I3AD5ysnz5ntK4ft4dFmUz 2B8KngMU
X-Proofpoint-GUID: 4GOQ6Frh_aNOROaFDgLS8lgeN68fQjGB
X-Authority-Analysis: v=2.4 cv=OsVPyz/t c=1 sm=1 tr=0 ts=681034d6 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=VwQbUJbxAAAA:8 a=3WJfbomfAAAA:8 a=A70Co3poeibdnodSdTIA:9 a=QEXdDO2ut3YA:10
 a=1cNuO-ABBywtgFSQhe9S:22 cc=ntf awl=host:13129
X-Proofpoint-ORIG-GUID: 4GOQ6Frh_aNOROaFDgLS8lgeN68fQjGB

On Wed, 16 Apr 2025 01:22:33 +0100, linux@treblig.org wrote:

>   A couple of deadcode patches for the qdi driver.
> 
> Build tested only.
> 
> Dave
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
> 
> [...]

Applied to 6.16/scsi-queue, thanks!

[1/2] scsi: qedi: Remove unused sysfs functions
      https://git.kernel.org/mkp/scsi/c/918eb0682157
[2/2] scsi: qedi: Remove unused qedi_get_proto_itt
      https://git.kernel.org/mkp/scsi/c/0d16b70cdbfc

-- 
Martin K. Petersen	Oracle Linux Engineering
