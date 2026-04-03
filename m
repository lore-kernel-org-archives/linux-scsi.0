Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132D5346FA6;
	Fri,  3 Apr 2026 02:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775181961; cv=none; b=P5FsvnhmqqKpZ2KUEOrnKRiDQPHdESTpbLVXzrSstLPwGoZU7JSJQINNY5mmOkvqriz+JvRhSuRo3vLLZli80KDz3ZcgoK4I7v892abvpVdtBHDQWbldgYDKLR2kL8gwq5nwv5NtRZTMRCeR7P5JmC/TK2bksEVywbaHZj45Rlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775181961; c=relaxed/simple;
	bh=9F9CL14XplunbG+uwC9xkURop5aie54VPxb72VOuDB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ESUWJrIEJu7/T0SWb79RwGXKIzQNUsZLjeeU1zkyANi6aiDupYj6BYBAyqulngciPOPm5Dxgriv22I9r4+4YI/c2NNmr37DisFwyfPuvepLjp57a/OjbV2g486LZRW2SUSiEXD9rOJbV/iEbafztqziC/ZdVhK3Gg8oyGULPegk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cUHi8fPH; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cUHi8fPH"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 632FBvfg1498959;
	Fri, 3 Apr 2026 02:05:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=bYp20qYC7IVSPePS94EJ0vBByekij1jzxqySGecFI1M=; b=
	cUHi8fPHMcqy9CE+h3bflAmPF3SisvYOJfMMqfWmrcju0W+8HqwEl6NjGDM6IZWf
	o8VAS0f6I5jzfcuX80bd/yFz+tOp1MBbVSLRxFTFH4aAggkUP6Ljep3U95Ly/q+m
	F+VQRnBAT9yYJlOPVS/Tn4yUfwKnpILdgTpmYGkeU8+oU3GtDR410yfXea2GVm9y
	R9zI5HEQdkmgub4jTCoInIjGQU/FokIjLZyu3xWAqq+IP4iZ6Xyt0eBQF8sgX+rV
	UD1Dg0UJ7WXnYB413KW58aA/qyvm5e/itszCpW56iMEDrKIxTNsz8YP24QFZqdzZ
	4HD70J9CbvSEJkZxKpaXzw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d65jwhfn7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Apr 2026 02:05:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 63313Vna029102;
	Fri, 3 Apr 2026 02:05:47 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4d65eddp66-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Apr 2026 02:05:47 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 63325cql017364;
	Fri, 3 Apr 2026 02:05:47 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4d65eddp33-8;
	Fri, 03 Apr 2026 02:05:47 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: justin.tee@broadcom.com, paul.ely@broadcom.com,
        James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kexin Sun <kexinsun@smail.nju.edu.cn>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, julia.lawall@inria.fr,
        xutong.ma@inria.fr, yunbolyu@smu.edu.sg, ratnadiraw@smu.edu.sg
Subject: Re: [PATCH] scsi: lpfc: update outdated comment for renamed lpfc_freenode()
Date: Thu,  2 Apr 2026 22:05:31 -0400
Message-ID: <177517593446.3522679.8109386363019087009.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260321105909.7804-1-kexinsun@smail.nju.edu.cn>
References: <20260321105909.7804-1-kexinsun@smail.nju.edu.cn>
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
 definitions=2026-04-02_04,2026-04-02_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 malwarescore=0 mlxlogscore=695 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2604030017
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAzMDAxNyBTYWx0ZWRfX/ZG5VRXKntof
 6Zit+OAydjeMWgqgb6NODhVVsrbcKexlOf88feTtSB0aC1+dB8pt843/Wnnzzz9/ReJmwxOLcKD
 sbGfm20M8GMfvoHNtShtyPcXyAkH1SiGIhubpTdeO8RI9bARRXaRSePOieTsMas+TnNqPF0aOTM
 mRxCecixsW4Ybvn9V8qwKgMgZOey+sjgM3HzL+dKZSVKsqkE2FhnKi8BOQt83zg4lSnZ7l9rnhq
 bHVL1GygyfFUdIwMtEnRmkL23BQymuyy3lHPg+HD+Sv+PXgHxxxoLVAsT4XRQBdvwcIAoPd3fyq
 jVJ7Ee0G/r6soz0EjK99WqI6xybTYqjRIPvN+n9Ezie32eNcaR40ve4tL9JfIHgSw5pXTdLLU2x
 3vs2av41kaEOTGbWvfbuR+6S8vcxgsmB6Pns0Y/Ni4r/FCNLlczQaLzrRdCdqxtaQaWeurNEy7u
 mYA2hh5ReVMp3SjVTBQ==
X-Authority-Analysis: v=2.4 cv=CJEnnBrD c=1 sm=1 tr=0 ts=69cf207c b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=VwQbUJbxAAAA:8
 a=3ndt8biA1O8p-7j_xgMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: kKeDJ06I9Eih5p4LL2wNNlBh0bdF0Wzu
X-Proofpoint-GUID: kKeDJ06I9Eih5p4LL2wNNlBh0bdF0Wzu

On Sat, 21 Mar 2026 18:59:09 +0800, Kexin Sun wrote:

> The function lpfc_freenode() was renamed to
> lpfc_cleanup_node() by commit 685f0bf7afe0 ("[SCSI] lpfc
> 8.1.12 : Collapse discovery lists to a single node list"),
> and commit a70e63eee1c1 ("scsi: lpfc: Fix NPIV Fabric Node
> reference counting") later removed the lpfc_unreg_rpi() call
> from lpfc_cleanup_node().  Remove the now-inaccurate
> "called from lpfc_freenode()" sentence and reflow the
> remaining comment text for lpfc_unreg_rpi().
> 
> [...]

Applied to 7.1/scsi-queue, thanks!

[1/1] scsi: lpfc: update outdated comment for renamed lpfc_freenode()
      https://git.kernel.org/mkp/scsi/c/3d1a36afa49d

-- 
Martin K. Petersen
