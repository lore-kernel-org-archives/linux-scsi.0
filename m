Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C95823DD;
	Sat, 24 Jan 2026 03:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769226893; cv=none; b=m8HRBNQ0W2VPuPA1U7XJ8hKPK0VlTlSu7rLKz2XMHvmlyMfTprWsPs3qogKA4h7l1W/vMfE1I41kj8aejEa2EeYS1DLDDISC3oejxhOADqvHs3GGJCnXCpjcuR7yGN8InJ97cXfwsebUQGnquuAgw87FSvPIAzlVTAlRDWkH5kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769226893; c=relaxed/simple;
	bh=iRv1kyLVp/KZ2mFQ28jx1LuduWTw6iGllcDup/Ohgqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ugHE1XwYyxAr3M3XXzWv9OHG+u/m9/GWNyC+NxFvnD0NojMLhv2ywbMXmDY4XIPs+HaRSsjPQvqhPpNn96UV24xUQkRXGvL6KayPAL4mjFhezF3BG1djmNdfxXTxkhZktNPVyQz24uL5o5+gimD1sfjSuyTkq8AtpScDfXd53sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kseXH3vW; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kseXH3vW"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60O3e27c265051;
	Sat, 24 Jan 2026 03:53:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=1TlSpcHSNhJQvhA9uVtAs1bmubgDQAqajlYLkd4U1Jc=; b=
	kseXH3vWu6cU4YoDHMgKw3tadtPb03d6oJpvIogyECZdBDt5ZZ+AxDTs54p4Ri6m
	ob/zDZcj1Jh63XLi7MvgaIXH2aNnpSHnft01KA53PzhDzRewf6HhyR+rtf+EdTTO
	uTbWgKCa4L4b1GFWLUgiN/hWfUMkvHzlMDyw6lpM5URz0JVRIRPEGwxqO0QaLabz
	3L+UMUiuCCMnlOsYhbdsE6VQB5jO92Fnu1NeJzPyHhgAlJngGjy8GkXucIjvmdb2
	1AUi38r0GjdIU0n+RGBV6nWoCAoAsj1Sbt++zMTmCyk7ZoaGfakKjKzR5bTnKgPg
	c2WQv7hy/WyqDAMOF2/CdQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvny6r0e7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Jan 2026 03:53:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60O1Y1cu019741;
	Sat, 24 Jan 2026 03:53:33 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhbak38-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Jan 2026 03:53:33 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 60O3rVid002545;
	Sat, 24 Jan 2026 03:53:32 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4bvmhbak2d-4;
	Sat, 24 Jan 2026 03:53:32 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: bootc@bootc.net, Kery Qi <qikeyu2017@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, nab@linux-iscsi.org,
        stefanr@s5r6.in-berlin.de, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: sbp-target: fix integer type overflow in sbp_make_tpg()
Date: Fri, 23 Jan 2026 22:53:27 -0500
Message-ID: <176922663892.2974474.16494984426834537522.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260121114515.1829-2-qikeyu2017@gmail.com>
References: <20260121114515.1829-2-qikeyu2017@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-24_01,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601240028
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI0MDAyNyBTYWx0ZWRfXxf7eIeYe2uqf
 Wg69eiochGxLvrCB8lWh7FNdL3/Qe7zncw54HFg0BgCuJrQSJ07oG2WsjDMEgp8OksKI6oCeeS8
 CuDzEjYFCjAt19jv+JbasiaPJzkyccvLckJUI/RzLV5AZY/RTtvFqzymr/ZplYPgwCHhvnySDpy
 vbH+W3+vP5SfqIGoVHP4o6NAqqLuIQSqbBSKtxBq3XG9u+vMhnVjpFYp1ZLfM5cFuldX0B0M9jH
 Gz1CUPWvSLI1iMo9TxdBKhHufQ15sX103hSEVVX+zFv9X/1MVKTAbXDF3kE3yICE1FlivQeq1el
 vnFUTZ36w/m5Vw6Auj6jWMD71Ajk4zVSY7IX9sAWzbCAYNLr+7+z0o//GmXCwoXv3XxxhRjMprE
 aDMlWGhz3bqMjGWVsMCmJ1/+c0KhMMGegMQ1jqWg2YhnR1Sxe84gyT9/cm97uKQBtjKKbmAl+l4
 F2n9Fj4EFOuiCdb8Tn4lL2Z21u8hbgDhhmPCSz5Y=
X-Authority-Analysis: v=2.4 cv=C+XkCAP+ c=1 sm=1 tr=0 ts=6974423e b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=aJTtfO7giZNyRcO53LoA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12103
X-Proofpoint-GUID: TgLyYpiPhFGBIp3B0n-Rr9x0D7Vj85mK
X-Proofpoint-ORIG-GUID: TgLyYpiPhFGBIp3B0n-Rr9x0D7Vj85mK

On Wed, 21 Jan 2026 19:45:15 +0800, Kery Qi wrote:

> The code in sbp_make_tpg() limits "tpgt" to UINT_MAX but the data type
> of "tpg->tport_tpgt" is u16. This causes a type truncation issue.
> 
> When a user creates a TPG via configfs mkdir, for example:
> 
>     mkdir /sys/kernel/config/target/sbp/<wwn>/tpgt_70000
> 
> [...]

Applied to 6.19/scsi-fixes, thanks!

[1/1] firewire: sbp-target: fix integer type overflow in sbp_make_tpg()
      https://git.kernel.org/mkp/scsi/c/b2d6b1d44300

-- 
Martin K. Petersen
