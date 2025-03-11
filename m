Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC8D1E0E0C;
	Tue, 11 Mar 2025 01:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741655992; cv=none; b=XzcnYlljv6CgbLC/1x0Bdpj6bet5YnQ1TK2mJBsqptv+gR7sOKgXgF3gr8xjE+fTuOpw4r9XHz1EFyIVFJ8H37CGeBAR+JppWA4W535P3CQc7r9f4k9+isfaM7sTlJUL6/vOfUBet80uzK6WYq289ghclPSRVm6ptCg1args0JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741655992; c=relaxed/simple;
	bh=aCK2nQDN+edReumwWrIzdC0XtveCwKi3spfmTynOlXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TwI3CQG8/H1Iwuc6oBNIm7owHqIknUZ7SXr8SPCM36h1Sc4bSRA+7Eqcfvc+lZn3CWJhlKhWYSAxfuUE85D/GbcYPTaCcP5x7GBWNO0AeT73wi9Zh4zTNCwYcM+TeeBiHe2TH0abIlkP8viJd+uJ+WofRNU9WuPUGZEiJmg76Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nmSpbTLx; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nmSpbTLx"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52ALfsYx014719;
	Tue, 11 Mar 2025 01:19:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=8/RuX3GwU88Td658DflKrFkdi94VCyG7/q6o+rS03Vo=; b=
	nmSpbTLxnRxd+EafKN6/L/AxiRQ2yWRRwEFrCSsP2Yr03G4O1qdq0AbJMRhU0+80
	/19D628J3mAAoVGJ5TxfZ7UgLqjlQV0WPmDZEAza35x0zSXpmQwyncLc9EBvrWDU
	ubZcK+GQZASi33aIlsElbHpCfn68gAyTOnuwH3YIsBVFZgnzfZ6GW5bgRf1QF0UO
	eWPt5trusLZdVTqZ6j3YMP9bk/kjtSIOOPedWzfaWOxagOpdxUo/l9dw+nDUZEfX
	Gjx2b4yjrAtW3ErqMwTBOMP3+HJfbSJ7jCQ7pwvBRbdLLBiG6TM9th/TwjqtFjAb
	KR1DrJ0plAUZU/QKgXvThw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 458cacbvd7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Mar 2025 01:19:43 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52B0UFCK014999;
	Tue, 11 Mar 2025 01:19:42 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 458cbencmj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Mar 2025 01:19:42 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 52B1Jfr8014960;
	Tue, 11 Mar 2025 01:19:42 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 458cbencm8-2;
	Tue, 11 Mar 2025 01:19:42 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        Heiko Stuebner <heiko@sntech.de>, linux-scsi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Colin Ian King <colin.i.king@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] scsi: ufs: rockchip: Fix spelling mistake "susped" -> "suspend"
Date: Mon, 10 Mar 2025 21:19:01 -0400
Message-ID: <174165504936.528513.7895453741464348013.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250225101142.161474-1-colin.i.king@gmail.com>
References: <20250225101142.161474-1-colin.i.king@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-11_01,2025-03-07_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 spamscore=0
 mlxlogscore=892 malwarescore=0 suspectscore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503110007
X-Proofpoint-ORIG-GUID: ZUjgEaKxxcf7JcaIfoORJdytE4gc3wBU
X-Proofpoint-GUID: ZUjgEaKxxcf7JcaIfoORJdytE4gc3wBU

On Tue, 25 Feb 2025 10:11:42 +0000, Colin Ian King wrote:

> There is a spelling mistake in a dev_err message. Fix it.
> 
> 

Applied to 6.15/scsi-queue, thanks!

[1/1] scsi: ufs: rockchip: Fix spelling mistake "susped" -> "suspend"
      https://git.kernel.org/mkp/scsi/c/24e81b821724

-- 
Martin K. Petersen	Oracle Linux Engineering
