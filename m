Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDCB71311AC;
	Wed, 28 May 2025 02:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748398857; cv=none; b=fBq8qWpwPPwPgzMO5e4E3kN5uiAKQKxTIn/9YZgWlLulOGKNF+PVuOakCMMaAofOKC3yyvgHWjNcP0Vf6CF3ifgMxy7ILLbR2ocCpE9ndyn2lG0m2LJJjBWW/JDjDy3Y7qSOU9Mton1uvTQRcBe8Hs1wHL5xOYUQ8cKC6f7Qcdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748398857; c=relaxed/simple;
	bh=rnq56KFx0Is8OSJSjNOR/r9/YSClInV/6O0vDXiC+WY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kaVIXKsbaMs/Kv8PRx8We8mCtab1+PgBAdwjlwx0gWKYXQkDqYtX8LB31LJIH6KYH4fzA9hHNiqODtsyh+WIs7lsUa7BAQcW7WsEXjo4+iwwpcOZHaxufRESGa86R+vECp+Fvz255Wr82Cv80GWO5uYk59cgqZxpPEvMdrs9xtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WeGg8VQz; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WeGg8VQz"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54S1g2Ok001517;
	Wed, 28 May 2025 02:20:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/dc9IIY7AVSR0AGd3xf1+XUQNqysZ2Wl+Y0EF/43L9A=; b=
	WeGg8VQzCPMi1hnQJ1p6smOvlO4Nid0oDz918tMMDCaJHyuwrkK7uxp58bZCOkVX
	wLhqmJgdVTSrKv9cpawDedoiSFoJE+KRaqqAncpbkXM+sOTcJX/xV2mp+Vaw6VRX
	GfYp5+RHzgVr6pTsLMDQWlO3RL7FE6q5mk2L5WPpynuCMsfm4h1O2rvz05QPbd/l
	avunZBkuosjgwhs4f4mX0PYN3HWNXUkIF28XpOQLjD51NrnA/oJVJElh4B/6pVIC
	eoJgA6/gRjyOU/2NB2p6O92fHxOZyJnqX6X+hzavWhLISnfGWlQ9yBn0kKjI+/eU
	lR0CqDn0smmiJ4UONkBg8g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46v46tvvy0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 May 2025 02:20:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54S0bdgM021113;
	Wed, 28 May 2025 02:20:53 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46u4jgb21v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 May 2025 02:20:53 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 54S2Kq12017834;
	Wed, 28 May 2025 02:20:52 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 46u4jgb21n-2;
	Wed, 28 May 2025 02:20:52 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH 1/2] scsi: target: core: Constify enabled() in struct target_opcode_descriptor
Date: Tue, 27 May 2025 22:20:16 -0400
Message-ID: <174839736820.456135.9487503065269953423.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <4290cf1dbe100c1b1edf2ede5e5aef19b04ee7f2.1747592774.git.christophe.jaillet@wanadoo.fr>
References: <4290cf1dbe100c1b1edf2ede5e5aef19b04ee7f2.1747592774.git.christophe.jaillet@wanadoo.fr>
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
 definitions=2025-05-28_01,2025-05-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=956 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2505280019
X-Proofpoint-GUID: BOIgbEkeXDbOR_0Bn7ndMZi1kNKxA3_b
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTI4MDAxOSBTYWx0ZWRfXxyiL+/QAff1y mL/fwPTdWW3aK3zG8ij8DCG28Fon456awAtPaxqiQKq8SA/ojTcVHXVwSlZ3nZMmwIrMBoK7+Hg RqDMvE6d14bdmoViVZoKzSMuM1zP6t6QqjgBOtYXobyb71Q0/k3RREh1L2EpaYyD/JZVap5vSEM
 PRsulRLjGKcOu8iFleLAh24tJHdc1zER47tb3iyd/tDFUrWuAM7vIaaMxZGk+Q5VFFc1akJpLb/ d+VJeNyc6dkjbMZUCF6O2mbJe1u7xdC/rE34P2WwDH0/k2KdZRaSgP2Amx6eIcfGhHhXHoZuZep tdja4TKrwLF1fx/mXthnYOxC7ub2Ey21rSJHcEaHE8aYoHPWIw4wtMrMcknhObNpBgKqtzRvhYk
 U7I4GQV4AeHBZC5OOESM7n4p0YAEwNZwTxIH8ZePNjPau1FeGIeNmVgn9Fqrrte0ARXVDcK8
X-Authority-Analysis: v=2.4 cv=VskjA/2n c=1 sm=1 tr=0 ts=68367306 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=6jzpHGfAOgaobE847SkA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:13207
X-Proofpoint-ORIG-GUID: BOIgbEkeXDbOR_0Bn7ndMZi1kNKxA3_b

On Sun, 18 May 2025 20:26:42 +0200, Christophe JAILLET wrote:

> Constify the first argument of the enabled() function in struct
> target_opcode_descriptor.
> 
> This is the first step in order to constify struct
> target_opcode_descriptor.
> 
> 
> [...]

Applied to 6.16/scsi-queue, thanks!

[1/2] scsi: target: core: Constify enabled() in struct target_opcode_descriptor
      https://git.kernel.org/mkp/scsi/c/7f0047cb9d42
[2/2] scsi: target: core: Constify struct target_opcode_descriptor
      https://git.kernel.org/mkp/scsi/c/fd2963e729ed

-- 
Martin K. Petersen	Oracle Linux Engineering
