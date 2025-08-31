Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CAAE1F03D9;
	Sun, 31 Aug 2025 02:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756606319; cv=none; b=hMXe8ASO42e+m4wdi2keIYqDFKuKoMecBMAWd8Ol7+BcFKK+qwvwjZ2A3zzW/7N8rQ2mTeGM2TiX09ZHLO6bjVfHLf8ywhtY3YPN2NqH8eQo0EopWDr+oVOiZbf55O1Ao5rURKyUKVn0tVWMIjBUYqKMO2T0Lrnbp6UJR5ckdao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756606319; c=relaxed/simple;
	bh=t+K1tqbRrmA6tSz4mhK3Qm1oaO3eVmNyNZS5NfOY0uE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S5D/aqqNK5Ss0rRdZeoQgJNCBusrFbUEgU0ZrwCKTAvxaDQSw0CC7d1gmLSd472ZzBxfH1+Qyl2AO5r4cmNRCwSVCujmvUqGqP1EiGUb7ZfDc95DbaQoqGI4CLF0X+S2QMZiqbws3ISaaH+fTH7j1VtidERZUO//pxwb8+Qtfcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=S9wk2RzJ; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="S9wk2RzJ"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57V11dZ4014044;
	Sun, 31 Aug 2025 02:11:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=bWfBoLSO/BGmnnhjp4SzbSWAL/yaL13fTaNCsbIQFxc=; b=
	S9wk2RzJVgFQJEsEViI4rv98U6shbf0Z+sUI5tYptYJ+00Piayrs26A/wZPMj1Ed
	VW0FoLfSS1JigyDSUvhIMMxU+SlzrFQHkW1AD5h/BjjH3UTnKSr9LEK10xAVSzib
	RiJxlESPxdbZHVJy8pGr34FoG3IRIGED7FWj9yX6R0iT6/AYXS11+3IAQ+pd5p11
	3sQsCYjM4ALJsOLmM5wHc9bIo/O84lKyL4aNOlftz4MCVXjfsXA8jICjtowU26+d
	UYvLW1/Jw4OCsQFcBv5EW/CyueV3/JxQlm7xVyz+3GaCN4kPiZtUDUOy+o3GoDBl
	ekU0UJPxCR4NMdVav74coA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48v8p4g3qc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 31 Aug 2025 02:11:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57V1WJLl028718;
	Sun, 31 Aug 2025 02:11:46 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqr72m5b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 31 Aug 2025 02:11:46 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 57V2BjAu019355;
	Sun, 31 Aug 2025 02:11:46 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqr72m4v-4;
	Sun, 31 Aug 2025 02:11:46 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com, liuqiangneo@163.com
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qiang Liu <liuqiang@kylinos.cn>
Subject: Re: [PATCH] scsi: aic94xx: remove self-assigned redundant code
Date: Sat, 30 Aug 2025 22:11:43 -0400
Message-ID: <175660145353.2188324.11138266229721694330.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250819023006.15216-1-liuqiangneo@163.com>
References: <20250819023006.15216-1-liuqiangneo@163.com>
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
 definitions=2025-08-31_01,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=664 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508310022
X-Proofpoint-ORIG-GUID: qY0k9w9uTc5UNDEFabBvUYDUngMzA3pp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDIyMiBTYWx0ZWRfX7KaJ7BUUv84u
 vO407VOowdV1VoRVpPx/zYOPz1/X1TmI9KLt5Qvg+80M5dZPdJq1/QAnaRj34azBKDpLz4aLkVO
 UjWZsMTM6ZlR1Ee6Zd6otNb1MtfqzCLlDmU5XMBf6gaYTEBLSJDaUc/pfbkRf7kAkT5basrSXMx
 A03+gMlQ7sxpCoAHxB36qmO0JhYHinicsUTuRiT5PKJtEKSzlhVJWHET3Avivn8SlhpMtJsk0wi
 /yJDsFteUVc7aduYEdeo0cSArLHeHW9ORuoIkF8F6S93OQUtkpCxC5r2UL7RF7NJ6FegFl2vmbD
 v+yFMeI6HSahNYOh7IL8FgMMOuSgkTifXlvNL0jTdgdPT7ce3FMf0bKmN99W+89eHmuy8IbA99s
 2V1a8gbwNTA/5TKfw+8j0zOuxEDb1Q==
X-Authority-Analysis: v=2.4 cv=doHbC0g4 c=1 sm=1 tr=0 ts=68b3af64 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=Byx-y9mGAAAA:8
 a=cFgQZym8HoIPNOZtx30A:9 a=QEXdDO2ut3YA:10 a=VTmGLo8Mz9AA:10 cc=ntf
 awl=host:13602
X-Proofpoint-GUID: qY0k9w9uTc5UNDEFabBvUYDUngMzA3pp

On Tue, 19 Aug 2025 10:30:06 +0800, liuqiangneo@163.com wrote:

> Assigning ssp_task.retry_count to itself has no effect
> 
> 

Applied to 6.18/scsi-queue, thanks!

[1/1] scsi: aic94xx: remove self-assigned redundant code
      https://git.kernel.org/mkp/scsi/c/00f4699872d0

-- 
Martin K. Petersen
