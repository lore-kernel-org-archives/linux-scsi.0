Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF18289E13;
	Tue, 14 Apr 2026 02:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776133200; cv=none; b=LMC6AHkDjqJznJwJym8aWxyjsm7Pv8TDgnEF4B+394Hi1Cvdiwhaqi48PtQ9T48cepcXoDd4Cv6bI6UeSF5EhH9ULJCT8olQzE5l61pnz/nKz2exFdouB8otxDISk89OFQlv4s/3RqlUppqOEu6YtllcZeMpptNXV6mAbyNnQdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776133200; c=relaxed/simple;
	bh=4zVwvw5dIOn/6FQhvCfqIo6hbkQjo8tRH9l5pA3LTMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WAxR7jDqlJx+g0TxYyLEgdqfvlM7uSBJ9HKbbX0nDnC3KEUVPHryy3oN/+rHFe6y1N72r++ScqtdALSnr6d2j8EJ6lequ6MyGBBNkcsSyPobTPEll1dtLCM6oLEMUFSsUAKu+1/dif3FOhC8GxYphkOuIPCg9oJDiDfuZeNCFOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RwR9nyfW; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RwR9nyfW"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63DLDmD0625815;
	Tue, 14 Apr 2026 02:19:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=qPANg4VAq2uxcsC+V51NhI8k3ujNM3sQ+WhPpoj/mlo=; b=
	RwR9nyfWzeb03YRus4hyg9Tl8HhbnTYjmSJ/PwkFG9Wp0rm2isG/0plOyY0SenEY
	BhW6ZHAhlh5hukjvrIOfphfgfGU7GWPPk3/p9lJUEBskSSd9dHKaV3eqITMtuFxM
	UTHl4zybyOz1PdNVUnDmNosVeZP7CUskTP70SrLBvBlPREggdBX6MsbVOsdM5a26
	rzbxT+72x8UxfkObQBFmw4k9blHAtdqb160hLlKGShi0Rrmc2A0/yWWe3V2xv18y
	FK7eYwW2xW997q9KbzeCwb2hzgbbug0h0DkDvsiVATLXH0Z5f1qe629QtF7ca1Og
	sJQtFTamaKW/P+4nD+JW5g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dh87h0afe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 02:19:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63E2EJV4023474;
	Tue, 14 Apr 2026 02:19:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dh7nj0nwf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 02:19:36 +0000 (GMT)
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 63E2JTjp036955;
	Tue, 14 Apr 2026 02:19:36 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4dh7nj0nr0-8;
	Tue, 14 Apr 2026 02:19:35 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Yang Xiuwei <yangxiuwei@kylinos.cn>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.g.garry@oracle.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3] scsi: sd: fix missing put_disk() when device_add(&disk_dev) fails
Date: Mon, 13 Apr 2026 22:19:22 -0400
Message-ID: <177595422523.3963380.13267671634340493024.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330014952.152776-1-yangxiuwei@kylinos.cn>
References: <20260330014952.152776-1-yangxiuwei@kylinos.cn>
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
 definitions=2026-04-13_03,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxscore=0 mlxlogscore=949 spamscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604070000 definitions=main-2604140019
X-Authority-Analysis: v=2.4 cv=eJUjSnp1 c=1 sm=1 tr=0 ts=69dda439 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=qFx6tlQJQYRrDC7lP_QA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDAyMCBTYWx0ZWRfX9S/BD71od5gO
 5V31Hy/52ey4zC+d1cKDrM4JeVHN/FdhNIiCS9UeONkKSX9qHiqA6i4d714HWJI8KMqJQfGMaLX
 Pq71pB2ky651ghQ3z8LOo0V+RAqYCl59AC/w8A3ODRCIoJI/gMgV7gwSkcE160ZAReau9B3xz8m
 dw5C+yJeEYfMlgEvP8wX7t9VrMGBZshR+j1ssgnVqE7hEoIbQ37ql7H23C92hTlGqUnowntq/s0
 qQC78t/hmanCP430uJmb2D89CzVGQXeI9jjqrCUqpFMoj0AxjkgE3EMOKXyu8uuOTODaLY7luU0
 WA7ZSy8v14Z2UXQjaMi2xdsfSvnViaVZ2OYlcaKmSmc6kWlrY35NxGFlYdjNqgkyYjjsqB6eCcU
 Q5QVbD8zAGIsTc6bhH1xGXookjgmUYmEoRVjqxsp6f2jmFVy0E/XIdfnVZp4Y7MwG7kSWkE/Npc
 OPFB/FPYIoM8vzyhHEA==
X-Proofpoint-ORIG-GUID: 6DRiznumNcymOTOrQo9HlH1ZkJi90jGs
X-Proofpoint-GUID: 6DRiznumNcymOTOrQo9HlH1ZkJi90jGs

On Mon, 30 Mar 2026 09:49:52 +0800, Yang Xiuwei wrote:

> If device_add(&sdkp->disk_dev) fails, put_device() runs
> scsi_disk_release(), which frees the scsi_disk but leaves the gendisk
> referenced. The device_add_disk() error path in sd_probe() calls
> put_disk(gd); call put_disk(gd) here to mirror that cleanup.
> 
> 

Applied to 7.1/scsi-queue, thanks!

[1/1] scsi: sd: fix missing put_disk() when device_add(&disk_dev) fails
      https://git.kernel.org/mkp/scsi/c/1e111c4b3a72

-- 
Martin K. Petersen
