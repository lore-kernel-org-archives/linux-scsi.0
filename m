Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED8A5314B90;
	Sun,  4 Jan 2026 21:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767562994; cv=none; b=EmQ7uekmzkIbDZD9zmAVy8IGJl6s5CKhPjQYylNGPMt4ahT1r2jVjzYm1Rex0rOnND9aicGq9EQxr5NKXCph1mnRe8H7obUaPNj1hRUqTYOMDj9Wdhr5uxzZgpRp5Yz+WjO4iMearg4gs3wCujR71zitFBww2iKWw5B7bKID3b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767562994; c=relaxed/simple;
	bh=mlu6UnNt9UVureZ0gtVAZzjrk2RoPaGxml2yY+5wHN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iwk9C0K4MM8adn/bLoOKp1e6ICkETNsA1TMy4P76ZM8K283ahnZ+KCFuNtjI/MH7a62e7T35VWXPx3e+raX2d2i/pHdMIFonZHLmRxEmLQgsNzh3mnc9n6Hp8ShRmVvdpOsT3DezbWb4WNun3y9a1FChpF1AfzQCLTtX8qWU388=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=petTseuc; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="petTseuc"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 604LcLAo480698;
	Sun, 4 Jan 2026 21:42:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=0kGzEkBJOcp5Doc/C3iO3BihiF0PK9PF4rXcyUauY9E=; b=
	petTseucxev+pxbMvWCnF7q3dk6B+ckvSrHQAd0CbmWrWZrYccntl+0wH4aflAJV
	e72KYeDoxqdnjMPW4aZ3Zi8D3SrIkbhzICUnXTUxAUWznjoZSgxyye17Bfrwp1+W
	JA0ymem/BI48N+9yd2dh3AeaPpXdVkfruGi97KVQKxaMxBxPo759SlKr/FZ3lWqC
	eDmxlwNmqHl/RhxxPIlx4GXcgmr0uFcL4561VbP6XECUwCvSv8YFa3IBG3hRFjTQ
	3Jsb93eTk75/QbrGDV/md9pNzsSRZC+HpVEnQMlxxsC6eCk2RK435fx8W1kP3Jkd
	kt+PJLWX5JsFh/f78LCieg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bev2jgynx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 04 Jan 2026 21:42:53 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 604GVRhv030640;
	Sun, 4 Jan 2026 21:42:53 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjarf32-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 04 Jan 2026 21:42:53 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 604LgpIq034017;
	Sun, 4 Jan 2026 21:42:52 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4besjarf2n-3;
	Sun, 04 Jan 2026 21:42:52 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Julia Lawall <Julia.Lawall@inria.fr>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, yunbolyu@smu.edu.sg,
        kexinsun@smail.nju.edu.cn, ratnadiraw@smu.edu.sg, xutong.ma@inria.fr,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bfa: update outdated comment
Date: Sun,  4 Jan 2026 16:42:43 -0500
Message-ID: <176756271706.1812936.376740831263740736.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251231165027.142443-1-Julia.Lawall@inria.fr>
References: <20251231165027.142443-1-Julia.Lawall@inria.fr>
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
 definitions=2026-01-04_06,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601040199
X-Proofpoint-ORIG-GUID: UQGws7oNUiVJLHMHTTQf4JYTVUEWOHUm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA0MDIwMCBTYWx0ZWRfXw15ygf2woWQr
 64ttcOIIbQ76mFurgV8UVJpowpMxX3S6Z48nonPdhOyP6WnqU/58rvDUbH97hgBP/Jta8LKa3i9
 a9qSZH+veeeeMt15dZEStiDmWC6qC6rFGCOPE5qDM0TcvjXWD2+M6EZwmK69kspYhMVi47AhzPG
 GXx4U1xlk/KwleXCVxhxq5c5lag2Np3wYrUO11/V4hBOqwPE2xnkknbZr9nt3WSx39Tgm1bfn2z
 9cfqdvOBekEWGbBip1AeKlDrE+4IbIQIWzT9z0nC1Ct1/mpldKF8W0GHDVpExLm3K6e90jwZj0C
 wFCEjug9x3YooxEh3RJJPF78aVP2JkHplM7HQHM81DMe7MbclSTiyalcvpbHYA7HUnw8JM/tirE
 t5q5lD+IpwteeIWLgPhhigRmF/UuBsdh+XGOMMDziRnsoXW6gw4IIHNHHVhN2nmRylR3wct0uix
 07n9CpveMTxDDdpzyAAtIMoqeTRX3UAPS4vOuJIs=
X-Authority-Analysis: v=2.4 cv=A9hh/qWG c=1 sm=1 tr=0 ts=695adedd b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=X6Wkoi8ibonHgqKz5goA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:13654
X-Proofpoint-GUID: UQGws7oNUiVJLHMHTTQf4JYTVUEWOHUm

On Wed, 31 Dec 2025 17:50:27 +0100, Julia Lawall wrote:

> The function bfa_lps_is_brcd_fabric() was eliminated, being a one-line
> function, in commit f7f73812e950 ("[SCSI] bfa: clean up one line
> functions").  Replace the call in the comment by its inlined
> counterpart, referring to the parameter of the subsequent function.
> 
> 

Applied to 6.19/scsi-fixes, thanks!

[1/1] bfa: update outdated comment
      https://git.kernel.org/mkp/scsi/c/d0f6cfb49192

-- 
Martin K. Petersen
