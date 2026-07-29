Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE8E39A057;
	Wed, 29 Jul 2026 02:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785293802; cv=none; b=eAKkJmq4D8xsVXN5R9bGjgyBvXFfhSyTJX8uePqZpyxxfJVHG7OGK6nlEgF41L2zqgEAbn64Vtb2mfr8PlSlfQgvLwEVIA0dbfav+dgz2V19VS3VmiTFif2kjhxHw8MFtGLj59ABuzjFlTxHPFJm5O1/q+awWQZMZmfVRAqLXV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785293802; c=relaxed/simple;
	bh=2N5q7inHEn+ygKJh4HxqK2adRTzjFBBh/vEB8RQ7a2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KGG6Y4jHIr+1HWDItZu/QwGXP5tIxE1DzdEotCC/B534Fq3s8YtCBEVlxLjtVYXZF8rmx/6esDXdfTKz764b+jlFJzua/jPCgLRtzmEsVBOl52uI3QQTYzT0gXrSNZofYgHiMXdlvot6dJEGmEO0/ygwLHlChIDYFyuqLQmgxfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kn4TFKTo; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kn4TFKTo"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T1Xj7R1812319;
	Wed, 29 Jul 2026 02:56:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ygEfQRRVUt76T0D3G7Nr2W3mT6HHQeFBQz6u/qIHH5w=; b=
	kn4TFKTovPterqtM5X7sJ8nPtp9z1Z4nYQDRIwHUDsdnREc1nya7BLp8HMzB+vK1
	yEL3j6nJun7j6H7qDu6mbJ46dQ/XXYBUNEpEL5QUHKk4uq6y/Bu4NNQKN89JizcX
	vB6qZYrjZhhyA1LHs1O6JfM/wwqxkMQ2dvYwXco0o7tknXegEkBwf2ebp/oDjOyV
	i7NDeuFDoTEf/4p8tSHrocZFJm5j/ay/eCOVWjtR2RydYOR+TUJX7iI31P+8OhPs
	vEguqMMWkByA6Wkt9krnf0if6oQ/6nX71LUFDoA0hjY0eydr9mAMNcs61mOfNnFm
	RgAsrlSLJ6DSFjr2uQVH/Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr5xw7hp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:56:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66T2oXf1034509;
	Wed, 29 Jul 2026 02:56:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6ddks2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:56:27 +0000 (GMT)
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 66T2uMAG006812;
	Wed, 29 Jul 2026 02:56:27 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4fnh6ddkq0-12;
	Wed, 29 Jul 2026 02:56:27 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: john.g.garry@oracle.com, yanaijie@huawei.com,
        James.Bottomley@HansenPartnership.com,
        Xingui Yang <yangxingui@huawei.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, liuyonglong@huawei.com, kangfenglong@huawei.com
Subject: Re: [PATCH v3] scsi: libsas: fix HA resume deadlock and hisi_sas disk-wake race
Date: Tue, 28 Jul 2026 22:56:19 -0400
Message-ID: <178529373838.132455.93701207869309344.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260716081145.3950172-1-yangxingui@huawei.com>
References: <20260716081145.3950172-1-yangxingui@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_01,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607290021
X-Proofpoint-ORIG-GUID: qS_YRgzdtZlSB0sOZvZh5iILrvXqno_r
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDAyMSBTYWx0ZWRfX0k/6HJSWr+8u
 Xnt2iK5vTs8j3zjAqplUoIzq/OB99gnvc3bGsN/R+SWSS23dHBodO0vDPnUbG30PktQQaE6uCGv
 xeelqYBHmO8Qy5HeKcs8dsmh7HOy2XlnM723cgkjXbGAwIrnjhlDWT5pxT68xtQwfuHNZ6WkRfm
 r6Dd/RWN7AZyR6D3h+2Gt3SYK1AI/e2hTESOw9nW2G6aLO5h1920myHLh4jF4DR3jMDV8eD6BZH
 CUlycXBuSwP+z1V03aXvjPjKdg3vbZ92xIbdHjrQx7dApsmYfeXPew9DKdXTHulPw6dST8m5V0Y
 47ns5Vqi0hjaNlkVwJm+cnej9Z3DdS0aGQhZLxczOd8mCzrzsx1/I8XWB3BeDW/KOSjuLDiX9EA
 vQh2hQmHQzkbyx+++l/f0OcydJ5oetuTfaj8xoXGPxeu3Cw6E8pn67vBuAkn/xDB6lNgEpQZlLV
 n+9dvSiCGDjFttm7USBfqxdKzeLjmm97qsBE+2a8=
X-Proofpoint-GUID: qS_YRgzdtZlSB0sOZvZh5iILrvXqno_r
X-Authority-Analysis: v=2.4 cv=A6Jc+aWG c=1 sm=1 tr=0 ts=6a696bdc b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=VwQbUJbxAAAA:8
 a=9SqfmnzyfS04kXzPQ6EA:9 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
 a=zZCYzV9kfG8A:10 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf
 awl=host:13517
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDAyMSBTYWx0ZWRfXyBOuBte55Wuk
 GqYg0L91MG8OeFy3hihgpUIgbDfBBeGwZDU0k8De7BpkZqTWMXjvLZkiACg8H6YkmQWy0DhRfXK
 1SSA/fVGHNw1ua11w1WWx3aSeO2+P+2g+ErJ0njVeRYGgVurtT38

On Thu, 16 Jul 2026 16:11:45 +0800, Xingui Yang wrote:

> Commit fbefe22811c3140 ("scsi: libsas: Don't always drain event workqueue
> for HA resume") introduced sas_resume_ha_no_sync() to avoid a deadlock:
> the PHYE_RESUME_TIMEOUT handler, running on the HA event workqueue, calls
> sas_deform_port() -> sas_destruct_devices(), which removes SCSI devices and
> waits for the host to become runtime-active. But the host cannot resume
> until sas_resume_ha() -> sas_drain_work() returns, and the drain is blocked
> on that very handler.
> 
> [...]

Applied to 7.2/scsi-fixes, thanks!

[1/1] scsi: libsas: fix HA resume deadlock and hisi_sas disk-wake race
      https://git.kernel.org/mkp/scsi/c/3dbbbf656b85

-- 
Martin K. Petersen
