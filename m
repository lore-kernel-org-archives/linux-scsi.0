Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE116371862;
	Thu,  9 Apr 2026 02:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775702625; cv=none; b=t0hHEE30W3S2gNEUo6ecmhnHpKJmz4t30gVdlHZEyB2ysPMmnjaywrY0UMkdm5BqGFaojhY79XCc3CUGGq7coh0OrEmoqPb4rhQ5H9TF2YmaIGlo4Ye5SUaZ7MQikVgHYvxJ6/3mfHyBJ8XExFjCzNwVB71O5RGxWHb6kp9PbSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775702625; c=relaxed/simple;
	bh=gwHlWxqUqRhiHdsPi1ewGGZh3aiek/CfRP+LMjCucBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dDDXjKMMyndd9YW9+0kcaGaWnV9pWFgsI//OXeihqvx+4wyArpGd18j5FAUqjnkz+mr5UsXBeqZ3i496RRIcJQ4RSslZ7zJuWChJ56OuwpBUJBD7Koc+QyRxpG/oO0reZynfIVqahvU4QD08nJZp5I19EuiWnhCqaf1AH/Wzjn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=C+LRtp0K; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="C+LRtp0K"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 638NtU5A794594;
	Thu, 9 Apr 2026 02:43:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=hPVd4LdW2ez+/MTA0mMYJq9Ku7jwLSLQyZRhnDgZI0o=; b=
	C+LRtp0K1+0f/y5z6M7RU+QVRVbIGVQ+Oez1alwx4Whh7US2mrcFMptHrje/fpud
	ueNSvsR2gcthcWvE2N5GkPLrW2PptXDD2nwDj/IvGW50OxQUcfGj4R5qcWLqpN93
	WNUmBW59pv3iAbwdvcaXgC0sSMXYnRSYqTzjFnKNArm7Y8bpAguyOuU+AINcUrTU
	tZG85alOt6rrNFKB5XBC4bnNaAtrCvS0K2JUfr3EsC+3ktyB85938FKbY5h9g5rc
	gZ9LXorZELWH9/rvgXEOX2BglXGYZzkKPeieZxGS1QhgZruug7pN+zImv4/46w1C
	rGhg3pqvpJ/RVNrdvWHGIw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dcmqavvdn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 02:43:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 639208mo003670;
	Thu, 9 Apr 2026 02:43:31 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dcn5xhrc3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 02:43:31 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 6392hSUx031599;
	Thu, 9 Apr 2026 02:43:31 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4dcn5xhr6t-6;
	Thu, 09 Apr 2026 02:43:31 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com, bvanassche@acm.org,
        avri.altman@wdc.com, alim.akhtar@samsung.com,
        vamshi gajjela <vamshigajjela@google.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        peter.wang@mediatek.com, quic_nguyenb@quicinc.com,
        adrian.hunter@intel.com, beanhuo@micron.com,
        arthur.simchaev@sandisk.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: ufs: core: Handle MCQ IAG events
Date: Wed,  8 Apr 2026 22:43:02 -0400
Message-ID: <177569866579.3870441.15063063928739056941.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260310190308.2474956-1-vamshigajjela@google.com>
References: <20260310190308.2474956-1-vamshigajjela@google.com>
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
 definitions=2026-04-08_07,2026-04-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=848 phishscore=0 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2604010000
 definitions=main-2604090023
X-Proofpoint-ORIG-GUID: u7Li7HhwLtZREZdUMcmCaoQRM9xyk_kx
X-Proofpoint-GUID: u7Li7HhwLtZREZdUMcmCaoQRM9xyk_kx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDAyMyBTYWx0ZWRfXyTWLfmMAKvFo
 9jwD3zRZjw/YLZpqH+OUU4G8Czg2KpQ6vAqRsWwqzdlePr4O1P7dWyjbEMc21rYMnZTzg08H0Lz
 4/BE+r0cDFOdlAQbxJW/5FSn+VzRTSb8w9U3ImtwYOcO39944Ws+CiL5+ZulwrRTE+13nS7Mphq
 AH2RyIGsKUzqVxfUuOWz7fj+aCS6oj6BBRFaDNydx5GzGIWFWni3iAsdr42F6t7tzqdLdexcImV
 TV/tl7uxFFEJrqWcsZ6wXD/wgv6G/TnTKxZtkyl/8AyjTKxfiy+5OsyABFt2ZPB0E0K3IIEF9Qs
 2DWFWVfxOlNOIoAzo8zsRHjz4mPM4S8veRa6N0iTTM9rvP9qkKmHQzlhxCKAR53P14MXQO81+jc
 SrK4j0qNnvv4yebOZSFxFSoNAQT8x9n9MnJl5rElb32pQcrNIIEpdM9Q3hHWRjf66MUVQIimWmj
 gQP+D8+br/mWPNjiUeyE1IjspK04c9wycz7Gmxbc=
X-Authority-Analysis: v=2.4 cv=NZXWEWD4 c=1 sm=1 tr=0 ts=69d71255 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=OcZjmCMSnOiq0RGOKIsA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12291

On Wed, 11 Mar 2026 00:33:08 +0530, vamshi gajjela wrote:

> Add support for handling aggregation-based interrupts when operating
> in MCQ mode.
> 
> In legacy interrupt mode, an IE.IAGES is triggered when the counter
> or timer threshold is reached. To manage this, the handler now resets
> the aggregation counter and timer by writing to the MCQIACRy.CTR
> register.
> 
> [...]

Applied to 7.1/scsi-queue, thanks!

[1/1] scsi: ufs: core: Handle MCQ IAG events
      https://git.kernel.org/mkp/scsi/c/98eff361647e

-- 
Martin K. Petersen
