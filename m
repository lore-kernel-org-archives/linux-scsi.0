Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA6E1CEACB;
	Sun,  1 Mar 2026 02:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772331136; cv=none; b=G6fq3PR5GolRvJoA/FJrzrN7rhxwlu6gTiEQjh5jPWSg5mN2z39STvi3b3FkghCVHuog5ST/aV3plkbnhfA5wWeH2MF4yG68963sUX1jkjSzUwtS8OUHeXN9ZZFxUqHd67d0Oxv/Fururz4x5dtiXZPm0GeHnpVmaoL1IDyxRSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772331136; c=relaxed/simple;
	bh=lxYc73aonE9SdBtAaEVg8hkcAIJc0/IP2W5COTnTNZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RSip5CAQz28XpgsQVlBbxCbLjdu/LB+3uORfFy44Dn/yDGESHOtF+xQr72N7hG7DrM+45lLpk9jEpQHTyxGieGe75a6ZpChbwS2oTTB9GIN1ZiQPRPstpGjzkhNSbvCvMNUoEGRIOZ1xvw8e5u2gd7uFLxUmLZiM3Y+3jfSuodI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BgLQovOb; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BgLQovOb"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6211rv5Z2959056;
	Sun, 1 Mar 2026 02:12:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=OueFgH16wNFp08pfIQZWhtxLRsIcJoum+oFhKIczr7Y=; b=
	BgLQovObyMRNcMXNGqHak/Ndv6OF2EGBoNNWo0TRnxV0UKi/qyEUXJu29V52+YCD
	eEUUhP+QhVpTQdcCCqC7nSBiMeWVQGqBQffsN4tc3RQ/OGcFImtFAz4shiIBzo5u
	Oe9+Rw95hwIjly+Npu67hHWnbHIGPGzr5Msr76qP6dMdnAZTcPFUd4Az4L7Srht3
	aAaFgkJA5Oe2KJe/U2IVt43t5vU0ce5gHY60Csh9gamm27ZwW+5jhkYGgEXzEC0I
	XJ4E8dZIN5lvODh6WbKD/TuP+8PY2289LRAs2XT+bGpo5vHKFLdL9/HzIjJvtIFt
	/ts3AWKrnhmIyUHKks/N/g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cksh8rnr0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 01 Mar 2026 02:12:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 621001Sd034818;
	Sun, 1 Mar 2026 02:12:03 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptbpnr1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 01 Mar 2026 02:12:03 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 6212C329009031;
	Sun, 1 Mar 2026 02:12:03 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4ckptbpnqs-1;
	Sun, 01 Mar 2026 02:12:03 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: d.bogdanov@yadro.com, bvanassche@acm.org, viro@zeniv.linux.org.uk,
        Prithvi Tambewagh <activprithvi@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev,
        skhan@linuxfoundation.org, david.hunter.linux@gmail.com,
        khalid@kernel.org,
        syzbot+f6e8174215573a84b797@syzkaller.appspotmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v4] scsi: target: fix recursive locking in __configfs_open_file()
Date: Sat, 28 Feb 2026 21:11:56 -0500
Message-ID: <177233109550.1886347.7587466794424670539.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260216062002.61937-1-activprithvi@gmail.com>
References: <20260216062002.61937-1-activprithvi@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-28_07,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxscore=0 phishscore=0 mlxlogscore=991 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2603010017
X-Proofpoint-ORIG-GUID: _37AuvKSc9CCrlBW3Q0HX5JOMPjaB9gD
X-Authority-Analysis: v=2.4 cv=D8VK6/Rj c=1 sm=1 tr=0 ts=69a3a074 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=VJyBxvkRRnMTyqRnq1MA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12261
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAxMDAxNyBTYWx0ZWRfX6HdC04BG1eVm
 sFCEWP223EGQR2PN/gX/kIMlt/vBvuVOzjbLc5vpBFG8xTB6SkHaCAP4qCfER+4BHI+3VG+XaOE
 0ipyGHuRZPyR6wzbuy+m3lbBIIpX6VoJlwgEaTnYHv541iIOHV70KpgjkOnzqxV8iyTHddtfvtg
 f0KhdssIfXE1KqIQy+de4zQ6FimCp5i+6DndlLSs3N6Cf66Q766vzBD3gejRxc9IRe3IaLK0fnh
 gD3yzqylaMYnbuIoQ5gxZzm1UjfuMbtV5w3IphiT3L3+gSDV017HqTBsGvIVst/Buv7wTjFlIyY
 NYm1lKditaVbqXR1w2HK98Y6ScDDU6rbAtbfoJmdNxTLDBDSuZzxqB1Ueu5Ndt4lq+1X+lNLGdm
 4QiFNgUXD+W5pbEqT8CCK7/5IENTHrb268bqI3Y47uo8ybT2FqnV1DOA2T9Q1mskEJ0rZxErRun
 C6Ky5yZVTAYwNrCCm15sW8m3TRi6KsfSukcg00oQ=
X-Proofpoint-GUID: _37AuvKSc9CCrlBW3Q0HX5JOMPjaB9gD

On Mon, 16 Feb 2026 11:50:02 +0530, Prithvi Tambewagh wrote:

> In flush_write_buffer, &p->frag_sem is acquired and then the loaded store
> function is called, which, here, is target_core_item_dbroot_store().
> This function called filp_open(), following which these functions were
> called (in reverse order), according to the call trace:
> 
> down_read
> __configfs_open_file
> do_dentry_open
> vfs_open
> do_open
> path_openat
> do_filp_open
> file_open_name
> filp_open
> target_core_item_dbroot_store
> flush_write_buffer
> configfs_write_iter
> 
> [...]

Applied to 7.0/scsi-fixes, thanks!

[1/1] scsi: target: fix recursive locking in __configfs_open_file()
      https://git.kernel.org/mkp/scsi/c/14d4ac19d189

-- 
Martin K. Petersen
