Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679FC1D5ADE;
	Thu, 13 Nov 2025 02:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763002186; cv=none; b=JBV9DoMYToUaxZUj0XYcMis4mBbK3iIvGLOsruY/n6T2FgzW9M6OQpoBQdoixwjgGqRat1b5kC1GYP9e4iun+FVKDg3VCXAuiB/zydrmq+D+wL9kNKbXF6ZmWmwwapAccVV6EAM2FQneQfgYonNotXR5Aw1uVNs/g1BaMH6am+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763002186; c=relaxed/simple;
	bh=/c+avxruh8h/OrnvBEwq83/XuSDUHqcB5A6CPqmqSWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XRVuZYe7MVUN+kxonO9j1/Sw06BVDOfXnseK4Da4q9ouYXCcSxJb29C8OpQHBe1WHIolBR17smZ5R8K19LtkXfIjSsIKJZS4XpOI/64bH/CDhLOaROS3Bt56GGRR85p+RMv9hbnVqRteDXZB2ISLsayE4fhuX6jQ67a5T/TgcwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=To9xIUMj; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="To9xIUMj"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AD1hqIk024490;
	Thu, 13 Nov 2025 02:47:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=1hbXIsieHg1sfwARxTpyr3g/zskwHyICMbxlp5TLLpQ=; b=
	To9xIUMjKR89UGNKt6UKFAms4ojKGetVeEXEyH+d8E+NupeQLRfhIceJuR0T+igL
	A1kZO/aHVF2dnonPxZGkWs5aF3s1zHab0SqwBR6IabZKBjJNX9m7/9alOw7qOxIZ
	/PQcyQDkT24XKInIuoa3hiiT+S2HPXamsHx/wmQGMAgZMuWp3nkcimKC0QaASxug
	7BElmKO5+pexIH9X8hBRfUraOZpTOFutjgxO4QanQ0fafKc7/ehYuf2LgxkdVubI
	N/xV7Kj3mtZ8JU60EDO5m3BUH9Hf6P2HPAUrdJSbhBhF6DpsiGoNgStW7C6OfohD
	P0Ia6ZaX6RNygelnt+Qo+A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4acxpngvww-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 02:47:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AD0603j029091;
	Thu, 13 Nov 2025 02:47:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vafjy8c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 02:47:32 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5AD2lWkK011620;
	Thu, 13 Nov 2025 02:47:32 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4a9vafjy87-1;
	Thu, 13 Nov 2025 02:47:31 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-kernel@vger.kernel.org,
        Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Guixin Liu <kanie@linux.alibaba.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Sheng Yang <sheng@yasker.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] scsi: target: tcm_loop: fix segfault in tcm_loop_tpg_address_show()
Date: Wed, 12 Nov 2025 21:47:27 -0500
Message-ID: <176283044352.2802267.12286632671055690228.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <1762370746-6304-1-git-send-email-hamzamahfooz@linux.microsoft.com>
References: <1762370746-6304-1-git-send-email-hamzamahfooz@linux.microsoft.com>
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
 definitions=2025-11-12_06,2025-11-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=617 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511130017
X-Authority-Analysis: v=2.4 cv=Criys34D c=1 sm=1 tr=0 ts=691546c5 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=-InAOOrJVH8xrQRU4hgA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:13634
X-Proofpoint-GUID: pHjVsohMbl6VjerWT9a_Nl812TfkbCES
X-Proofpoint-ORIG-GUID: pHjVsohMbl6VjerWT9a_Nl812TfkbCES
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDE0MSBTYWx0ZWRfX5VYRh26xB23e
 gQi/hVMJs9UAXs+owWW3n4umqvAMT8plhEeHxsfWbwQ3QWx5V89V8OdF77gZyEnXuTbMaD7b02K
 q9vUvU+KpbVUXck3AcakZsk4Qipg13rqhhNLEP1UJntWqzzuaZU/oA49bKSY9XCrMfKwAahB26y
 qsyCQ5Sx9QfeP5YUDAFk1ZIi1rkD6en+0gF7l8TVQfodHZSUB3HbtcL1KofLmBMfks3S6okgjVo
 7H2t/VtWYkTCGgpG5b9fWiSymfgt7eaS5Us0IIpWIhxAJR9V7zIx3KQN+8qCRpfvHlimCKuDGBb
 WPQkncaasZHoLGLN56iv6Vn+ajfeIap2gz09DzoNuzW8kuOHNBWnQRYpYveR45RGTIHvj1bf2wS
 kR57pxOrRSS1qzl/qkhcfedlkuyK+s9Ry5YA9OphlGgpRJDcyH4=

On Wed, 05 Nov 2025 11:25:46 -0800, Hamza Mahfooz wrote:

> If the allocation of tl_hba->sh fails in tcm_loop_driver_probe() and we
> attempt to dereference it in tcm_loop_tpg_address_show() we will get a
> segfault, see below for an example. So, check tl_hba->sh before
> dereferencing it.
> 
>   Unable to allocate struct scsi_host
>   BUG: kernel NULL pointer dereference, address: 0000000000000194
>   #PF: supervisor read access in kernel mode
>   #PF: error_code(0x0000) - not-present page
>   PGD 0 P4D 0
>   Oops: 0000 [#1] PREEMPT SMP NOPTI
>   CPU: 1 PID: 8356 Comm: tokio-runtime-w Not tainted 6.6.104.2-4.azl3 #1
>   Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS Hyper-V UEFI Release v4.1 09/28/2024
>   RIP: 0010:tcm_loop_tpg_address_show+0x2e/0x50 [tcm_loop]
> ...
>   Call Trace:
>    <TASK>
>    configfs_read_iter+0x12d/0x1d0 [configfs]
>    vfs_read+0x1b5/0x300
>    ksys_read+0x6f/0xf0
> ...
> 
> [...]

Applied to 6.18/scsi-fixes, thanks!

[1/1] scsi: target: tcm_loop: fix segfault in tcm_loop_tpg_address_show()
      https://git.kernel.org/mkp/scsi/c/e6965188f84a

-- 
Martin K. Petersen
