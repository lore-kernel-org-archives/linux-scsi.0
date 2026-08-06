Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C774A4C77BB;
	Thu,  6 Aug 2026 19:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786043195; cv=none; b=nekSdaLJ2tMH4cC2IZ1o6y8U+t3uniiYDgNflkfZupEbzHc+cS8J2TOptUk/3dFakBP7r9JZBl+Fv+czAI/eJlMO2uzZ3716jyiQAhdDvJ71yG9a6wrqOw8no+2/AleYg8IjZK+S9/5gNqwsZZDktzr2suHHG6Y2xwgTw0blRE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786043195; c=relaxed/simple;
	bh=5uQPHkKu1hUxSDzJ4dxkRx7hybjPA0AMOXDh0EJdURw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H+U8OZRdmLmyh+6zEnT4UNBkz/njivWCjIU77cLcLS9tWMkzTUVyl0qTmOdiXi2rWNcGKIrKpcdIZoatteM5Bu5oJkh/zdG0wZuGcAIacvCOMnImvRd7nBx3Vz0OatboFhyf/BGqmGRZ2pe9xnPvHUi6I+aICa8T3rLDEqQ6OWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=X29wKsvf; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="X29wKsvf"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 676FtnP33084395;
	Thu, 6 Aug 2026 19:06:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=OAhPtqIUca9jv1VzreGU+Sddn4dU6Vj6SrnzL0hmv2A=; b=
	X29wKsvfaOYGXgLa4ahd/AXrdJlSr7BHEJ8fhEmjLurh5WZQ+q5j4XRTZp/Ejm5c
	tHZtlrasgLkfst7S1rB8wIwHxFQsdP2LE8Wj4ZLuejvUy0sgHftvEJ5CJzpRN+Zy
	KHfpBfNJRNjoNe6pChCGf4rbKK/vU/ETrD+WuKSyqOsjjnPcuHNmhNnQdmaBYT9S
	/UcpWJqyFiRr66yky4RLdkdDzk9sZhZO0miR1Kzj3wtqhfXuzgYF3A0Np/sAOrmT
	6WcbbXhTFbBHeOYPA3x283JjIvqxMggjz0ayhDwX9RIQCOgH6uTsentiIroUSRMB
	MVYxMa5iR4GmwjM4pH632Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fs7k3pm0c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Aug 2026 19:06:22 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 676J0dXu024803;
	Thu, 6 Aug 2026 19:06:21 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fs78w56bs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Aug 2026 19:06:21 +0000 (GMT)
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 676J6LgU011247;
	Thu, 6 Aug 2026 19:06:21 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4fs78w56b9-1;
	Thu, 06 Aug 2026 19:06:21 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Oliver Neukum <oliver@neukum.org>, Ali Akcaagac <aliakc@web.de>,
        Jamie Lenehan <lenehan@twibble.org>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, Colin Ian King <colin.i.king@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] scsi: dc395x: remove unused variable fact
Date: Thu,  6 Aug 2026 15:06:06 -0400
Message-ID: <178589207035.336697.9629222985596300063.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260714073510.43289-1-colin.i.king@gmail.com>
References: <20260714073510.43289-1-colin.i.king@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-06_02,2026-08-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 spamscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0 mlxscore=0
 phishscore=0 mlxlogscore=674 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608060149
X-Proofpoint-GUID: dsDosyQsfHYuC98RxjvEZIFrbZgrulQd
X-Proofpoint-ORIG-GUID: dsDosyQsfHYuC98RxjvEZIFrbZgrulQd
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDE0OSBTYWx0ZWRfXyebLgBS9pPKF
 dHs2Hv3qQn+Yk+V1EWKfCZ9N8NAtiBxQwacmAkthrv69wEzCn72BSAyucmJMir1bZgfKZSSwikb
 BvU5KB/2BKki7STWvcO1Gneo9p5N9AJKkx8hTPoYk8G25BT5svtU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDE0OSBTYWx0ZWRfX9ZtPJRacei8b
 4biEYLWiEUJzIX/Vr48XvDPhSsIPaVpsKhx6vW/pfS/vH/KKL2kS1gXas9aelwBHQpGECg6jQhH
 0gKUxcmUqmlyjIOJwttst8nj5eN7JlVJp4GjvzfbU1HmvjvwOpaJ3PGQjRkXEoi7OdVrbvj/SQk
 fRH4O+Rd2Xkf5iwoU59jQQkHi7GhY8WruXY3heiTnj5VPE1MYGaCn63cgN8mAu3i21eJh/u6DoA
 j2fsOSJruuOPnhLGHLqtWXb9v/BSWsMpyax6CKrwoDNSAk38FXDZjyNNe4ouoGjVrYjV95++6Is
 8IldxI6KEsHmmLetEaWwhaGhlReR/T0PeofR0oYxbQc5qdMg7m7M7FfE7AJb0KyFuCGHHezjgvE
 dUsiLHwS1GUwtRMkePLgkmjFoFCL5aRpSPTZvxCRXYvacjSQ7NjDp8cmle3dQ2jYRtfd7q04c38
 n9zs34Vrt9PByGkyr9DdEccTwX6vHJBjlg1pcmd4=
X-Authority-Analysis: v=2.4 cv=Iqcutr/g c=1 sm=1 tr=0 ts=6a74db2e b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=4Xb3fT6jNY-gIQ3-D40A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13510

On Tue, 14 Jul 2026 08:35:10 +0100, Colin Ian King wrote:

> The variable fact was used for debug but this was removed
> in commit 62b434b0db2c ("scsi: dc395x: Remove DEBUG conditional
> compilation"). The variable is now redundant and can be removed.
> 
> Cleans up clang scan build warning:
> drivers/scsi/dc395x.c: In function ‘msgin_set_sync’:
> drivers/scsi/dc395x.c:2185:13: warning: variable ‘fact’ set but not used [-Wunused-but-set-variable]
>  2185 |         int fact;
> 
> [...]

Applied to 7.3/scsi-queue, thanks!

[1/1] scsi: dc395x: remove unused variable fact
      https://git.kernel.org/mkp/scsi/c/9b61402740eb

-- 
Martin K. Petersen
