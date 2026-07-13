Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D56E33F368;
	Mon, 13 Jul 2026 02:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783910043; cv=none; b=b+nN8pF/SyT3WAx9gQ2vzFwQZJTVCe1sgIGV8iQkU0gC7exSyIEf0TvDm8PRNWxzGZ/OjgxlajWWiy2x04p+OlQ8/K+RcANO6EXTpYqfoCF4LLrsJNHfVwObfzwZI+gcTL23Y+Rb9sRCwf142gOBr61iNdopvZkZiv3woPklY7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783910043; c=relaxed/simple;
	bh=jwt2tryPTeJ9Hi3DSPFgB7yIT5PPdYH6XseGcDinOaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hAtUZDdw6F4zfc6v2tyjcya6YROtiZO39LYOS7iqoIgPbIa9Rn/Qcr+qZf1m8NKdO9HVA7h/GDj1HWDj1ZAg4q3hMNdz1AhADZHu/zV3JCFEqoPF3RUSXzPUngaS03eL/eBqKf6uaPPetUgHOME8cFkMPws7nmy5HVmcEu5a5a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=c3BNASgJ; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="c3BNASgJ"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66D0Bn8x165806;
	Mon, 13 Jul 2026 02:33:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=qbv21PqstAcJbZkBnSBApkCoOs9joiHIT78ZoAOddoY=; b=
	c3BNASgJ/+q9E/udTRtTod6NsuteUnovsLpsaBaiazGl0fZudtgaEXO/42nnTYfM
	aelN1+0iNLEwSYiFEfDuRUV2MkDKgECdZFPXY/wbrv4KKY7w50eu0gMDF4TgdB2e
	SvG2k2xlxk/0WGfBQYFqUwnS3ikiYhrtmF8jlekuGZd/khnsEtR2O80jEjhfXh3U
	Zk5zVoULwNrex0DfWntJxN9SbBVchQdFdKrh46gxeVpHS+4bqSA8uWut64RlnfwK
	6u/Fav4mB5B5BRt23xTVe+roUhoiMiSletXodhczneXPp0QS6YD+c5DDS35odhAH
	9XZHFRBT5Oj/PshgUkKiRQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fbepn1cr3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Jul 2026 02:33:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66D2XV8W029220;
	Mon, 13 Jul 2026 02:33:37 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fbc9fssv4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Jul 2026 02:33:36 +0000 (GMT)
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 66D2O0cv010878;
	Mon, 13 Jul 2026 02:33:36 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4fbc9fssh6-7;
	Mon, 13 Jul 2026 02:33:36 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Ram Vegesna <ram.vegesna@broadcom.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        WenTao Liang <vulab@iscas.ac.cn>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>,
        Daniel Wagner <dwagner@suse.de>, Kees Cook <kees@kernel.org>,
        James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] scsi: elx: efct: fix refcount leak in efct_hw_io_abort()
Date: Sun, 12 Jul 2026 22:32:38 -0400
Message-ID: <178390967077.3399387.1650905221698217241.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260611053037.63756-1-vulab@iscas.ac.cn>
References: <20260611053037.63756-1-vulab@iscas.ac.cn>
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
 definitions=2026-07-12_08,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 spamscore=0 suspectscore=0 bulkscore=0 lowpriorityscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=712 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607130023
X-Proofpoint-GUID: pvgZCk64IZ3kbVMtlh1dSGW8aNRLyyxJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEzMDAyMyBTYWx0ZWRfX+Pox8jsLHujc
 3Nxp+TZce+cNswCD9WtXhJUIFXlVlLVwpwwVVNdJ/dJIw3u/7dvqR21DvdnbJwn6/C0uBzZuFeH
 uRaaZiVgEjNmSlNksdq3x9jnOAyABIUmaYIyRUKMgdGpyZH4NnDaCw4Kir3Tkil5TFMVY+gPWEi
 EkTztdtV4keJn2g7hVPXGDKfN60Fj+DzbNfIJoSDGGocuhKcKM2snXCN+ljkZxRaEsAzs5pRLZH
 wcQSirBW/xtSASbSjSbAqcFNxZa9PJZe3ENKlhWGrBAUb8y4tEYZKmWBM+9NAzd53ZyjoLo09Tv
 +brF/NAKxZ+TbFfy1U3QR+bUck+r5WCFbYdKnCjyrVPbvyoSk+WVArGgN1SP1mkMtXtnKaYpjHe
 KoImGKbIbSnJJa9TVPMSBFqkGCsyqwq4FOwF8yeqonpJHvJtR/BLiek5lkzO2IV0V39P3K8glsy
 0gq5tTBRYtpb3pswceGlKKTQJymkAposYBlj2hzQ=
X-Authority-Analysis: v=2.4 cv=bJom5v+Z c=1 sm=1 tr=0 ts=6a544e82 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8
 a=ylW9feQpB8xVrbssfo4A:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12221
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEzMDAyMyBTYWx0ZWRfXwK3Ge9aavjFl
 CPq9DP+Bn5JPDInV7/jXRu5YbfnyjgWdpOInuafxgc5v2C0/O4gAr1f5DtC6uufydJD6/CM8Wbu
 Pvun+3MBJkIJGUwiv1X4GB5ydaMiE2jGcaBMtGy4G+xbaT2cJLf7
X-Proofpoint-ORIG-GUID: pvgZCk64IZ3kbVMtlh1dSGW8aNRLyyxJ

On Thu, 11 Jun 2026 13:30:37 +0800, WenTao Liang wrote:

> When efct_hw_reqtag_alloc() fails in efct_hw_io_abort(), the error
> path returns -ENOSPC without releasing the reference obtained via
> kref_get_unless_zero() earlier in the function. All other error
> paths correctly drop the reference. This causes a permanent
> reference leak on the io_to_abort object.
> 
> Additionally, the abort_in_progress flag is left set to true on
> this path, which means future abort attempts for the same I/O will
> immediately return -EINPROGRESS even though the abort was never
> submitted, effectively blocking recovery.
> 
> [...]

Applied to 7.2/scsi-fixes, thanks!

[1/1] scsi: elx: efct: fix refcount leak in efct_hw_io_abort()
      https://git.kernel.org/mkp/scsi/c/2c007acf7b31

-- 
Martin K. Petersen
