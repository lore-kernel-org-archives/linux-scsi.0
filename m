Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D6B5223;
	Tue, 22 Jul 2025 03:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753156081; cv=none; b=M0e0WFsA3nty77zBjvh4hvhDfzL78N8oaR+2gWy3TUQu8zaPSSYo9rIViZdSIsLhD2Vcovey3ZnSXO0UUFiJUy/NHgMgi9SJj0VO62ms3sBjl6vTsV1QJJmp5cTYz4QK1UiIwQMaHThUdM5TGS/sk5i5oGSE40GMwkxFqtQHOGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753156081; c=relaxed/simple;
	bh=gQFsTz9p6akgBad2u3koCkG0Ki7dMqALMGCjJIbmhrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fwbEIPcm4mrVj5lgnG+CZ4R+jhqR+g59JvV7KTHLlIAYh2Pc+LpeVShmIXCS27lAN7LA4x7jwZWpOnl8ny0RAUsbn21BSYSFZUUoH1uU/A2UNDedu2J20ac8SNVFEV5nYlsMCAEAISSAv3UPnJUWvC0TufnGtRkjqkZWYpFqb4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mbIoHmQh; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mbIoHmQh"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56M1BtYp018886;
	Tue, 22 Jul 2025 03:47:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=mhwFevJ8wCIuN2/MKjYQuMAXk9L7k7QGGb1ltPjkRmA=; b=
	mbIoHmQhllrTEJRRaZsg+BxKO6NhiGXbLEQkkQxRuIFKUNBvchHKRb7qVjJIf0aH
	nngejMC0uJp8kJPsMYgJbWrjHrjzrTxAVcsiC/h2GRJB6lxYN28qQlmyBviJmzwq
	wKbxI2JMLn1jrIy4KHGMO9CgncpeNVmQcLwxKNYbXEkcpB/d12Uj1JZOU+tzWpLH
	5rluNxb6i9Due9Y8uua2FMCmi+bl/1V6fqonARbk2SnD8el46DMUcuuOalNY+znO
	kvFj4ZHOcOQFs8g5WhjYfZ6UtWPyg7DrfKbMe/HmLL+iG3RQpoMCQ9pQX9PkNgrO
	VMFgOLySWgpvZIqwZHiqHw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 480576m5vq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 03:47:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56M17ReC038404;
	Tue, 22 Jul 2025 03:47:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801t8te97-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 03:47:36 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 56M3lZix031915;
	Tue, 22 Jul 2025 03:47:35 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4801t8te8u-1;
	Tue, 22 Jul 2025 03:47:35 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Alim Akhtar <alim.akhtar@samsung.com>,
        Peter Griffin <peter.griffin@linaro.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Seungwon Jeon <essuuj@gmail.com>, Avri Altman <avri.altman@wdc.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        =?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Tudor Ambarus <tudor.ambarus@linaro.org>,
        Will McVicker <willmcvicker@google.com>, kernel-team@android.com,
        linux-scsi@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: exynos: fix programming of HCI_UTRL_NEXUS_TYPE
Date: Mon, 21 Jul 2025 23:46:54 -0400
Message-ID: <175315388530.3946361.1712627502152861268.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250707-ufs-exynos-shift-v1-1-1418e161ae40@linaro.org>
References: <20250707-ufs-exynos-shift-v1-1-1418e161ae40@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-21_05,2025-07-21_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507220028
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIyMDAyOCBTYWx0ZWRfXyLtUcpfI4Bsd
 Wq3e1GV2GFAeL7YUi5nFS2j67zzAW1mKMZFGoluhIM7SxNT9E/6aZhNOlnd/crH9eE3SWKpfC0A
 2H3CSKXT7qBCw6rYl5NQ4vTswTW6eNCqY4pgZb0HAgxjiP/GW6G7dT4rQxsqnfctEXhpiCiLBCX
 6o00vEG2vEagbibdbHWcWU30FlFaWZEJFsmSJiNoA7bocKkKrJ5LZjeLBf42gdILv9BZEdPx3i9
 DTzQOuDp6psaEVrfjtAwsq3noWdXvngH7MnPxX9i2v6VEKO1t6nl2CUR9mdXbX3ABwjUb2AhLfy
 rEBXRpKqwNF1MZ/YADCao/Q2ieztVuJmUKoglb60R7cx748/hjQvvL8/gJAlxpPVCA1ulXbCyIV
 hNQqIr6QBdygis543zd2tM6LAJY9dABawtHNlxeFWXWFXLfOhEx0YqZhp0dFxyWEQsx28z5b
X-Authority-Analysis: v=2.4 cv=doDbC0g4 c=1 sm=1 tr=0 ts=687f09d9 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8 a=NBqH-hezJh6qG-O4bPsA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10 cc=ntf awl=host:12062
X-Proofpoint-GUID: oZgBROvOr0m2tP7ifFP0KXsH_bC0PZUn
X-Proofpoint-ORIG-GUID: oZgBROvOr0m2tP7ifFP0KXsH_bC0PZUn

On Mon, 07 Jul 2025 18:05:27 +0100, André Draszik wrote:

> On Google gs101, the number of UTP transfer request slots (nutrs) is
> 32, and in this case the driver ends up programming the UTRL_NEXUS_TYPE
> incorrectly as 0.
> 
> This is because the left hand side of the shift is 1, which is of type
> int, i.e. 31 bits wide. Shifting by more than that width results in
> undefined behaviour.
> 
> [...]

Applied to 6.17/scsi-queue, thanks!

[1/1] scsi: ufs: exynos: fix programming of HCI_UTRL_NEXUS_TYPE
      https://git.kernel.org/mkp/scsi/c/01aad16c2257

-- 
Martin K. Petersen	Oracle Linux Engineering
