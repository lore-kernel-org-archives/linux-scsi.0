Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D3F2DECA0;
	Wed,  4 Feb 2026 03:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770177190; cv=none; b=gMp3yBW30d+MTYraS5IQ6wcFjzBv8zxKIwQW6QFGPpacgFB2XoiEbs//o/HS7DEx4Ac0Q0UhFZM+rQNs/RgUahxjvxlRngKWdwGANqntVFU7tRoINhWwXwI4wMAPVRp8qlVTUUshmhFkKDUfnfZIUvaFPOqLg5TIFl6pVxuvK9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770177190; c=relaxed/simple;
	bh=LegNMFoypy23b4i4rDbr542BpzdVn00oA5t3tXLLpCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QM6UbsBIEgA9r0su2cTwf2W1uymx02orOrg0n4EqF4JQ26wy4RQmjXXFX+N/NZfBEe84YBHdB2RpmTn3OqiW90E2h9skmGPPjVt7Yx+Ro3Mb98XtwaXkAi1nwkCbkRXWC9CLKe7loUz1uaLj1A9kaYHA4YmW9Giups8skxVuQ+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jJ/XGzaF; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jJ/XGzaF"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 613IuMow468059;
	Wed, 4 Feb 2026 03:52:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Y9W+5NWZ6GIRyFxLTZSvdosboKQ0xT4fuaDZ0C4rFaI=; b=
	jJ/XGzaFUEStrnWDXCIeiYAXic9039qrLKfL/cPKupGSRP2DWjiOWc7GJoUJ6tkH
	X5sC12PWYU64MWCWJ0I5aZw0SMLnkCbNo3myYj/GhWT8kRdf9uUpS2/heNsaLtNP
	lmaR3LIxrip9aEJF0aNw8ShGZxjw9z0E4bGPavD8gw4wE7VdDaPUnpV7bdG+DsZ3
	jXvdr9uAVBH5HXtL6gktAAKHBwHQmX2MxSKssxyL6YIPsL7O5dTnen7+mKJrum76
	r+N6Y0g+ARUgYoyTuR4nrrsuN5287wf+2cXa1N1STZe6KTwdmL6T2q2AdjY462m4
	g2TkxXu1yp7IYYxjPzu6mw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c3jm4s50e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Feb 2026 03:52:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6142A9Xq018750;
	Wed, 4 Feb 2026 03:52:48 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c186nd32q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Feb 2026 03:52:48 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 6143qllp024698;
	Wed, 4 Feb 2026 03:52:47 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4c186nd32a-2;
	Wed, 04 Feb 2026 03:52:47 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Marco Crivellari <marco.crivellari@suse.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Michal Hocko <mhocko@suse.com>, Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/3] Add WQ_PERCPU to alloc_workqueue() users
Date: Tue,  3 Feb 2026 22:52:41 -0500
Message-ID: <177000116198.3467927.13394907147902446660.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260113145711.242316-1-marco.crivellari@suse.com>
References: <20260113145711.242316-1-marco.crivellari@suse.com>
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
 definitions=2026-02-03_07,2026-02-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxlogscore=896 adultscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602040023
X-Authority-Analysis: v=2.4 cv=OuJCCi/t c=1 sm=1 tr=0 ts=6982c290 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=V6UdTrCVnvP9DkvkYaUA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12103
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA0MDAyNCBTYWx0ZWRfX9MFztE2yeypH
 MPyb+TIO59PdwZs9lojoWyKIkzW1/DeCDeTmDAgyDv/JgRF7aZNgoF6cvRO3qDQXTLLy2Ew/2HT
 Tgins9jWJ14LSqwRcwVbahYVZqpvt3oF5dcBYNh5Nmgyl+bXra02oe0UxDPe2/0RE7scR/iWPtv
 jwP52IduolPGtTEPRL2t/ZrwJjl/3AUf8CxnTOtM20Cl/7IW9JPSS0WJ2TmY94kXDNf0oewT6WH
 IGsHS8FbPzJ7P1GbSYgjEweILp0PJrTTvBCkpIYA/eTskL7vzY4p6q8xyhPoO0hr6vVXIpSHmYo
 p69FRKwUrT4JUsUqnEoz1sg6Eqm7J1YECagYjT4VRj7OAET7x5mLY2rnErw4azVmtcQOcN7p+v9
 tjd6OKqYLCGQnEMLSrkrHGjbLBxze5ZCQLUHEU6P/QEoTQ1M2cWjHkbgJFr/wh6busnk3U7cxJn
 hcogZXEWT3/xjuUiS3jza3vBgGTfyYptFfzQQsGo=
X-Proofpoint-GUID: J4-GFOrklRHE0aayZUl9BVXMXD4oKBit
X-Proofpoint-ORIG-GUID: J4-GFOrklRHE0aayZUl9BVXMXD4oKBit

On Tue, 13 Jan 2026 15:57:08 +0100, Marco Crivellari wrote:

> This series continues the effort to refactor the Workqueue API.
> No behavior changes are introduced by this series.
> 
> === Recent changes to the WQ API ===
> 
> The following, address the recent changes in the Workqueue API:
> 
> [...]

Applied to 6.20/scsi-queue, thanks!

[1/3] scsi: qla4xxx: add WQ_PERCPU to alloc_workqueue users
      https://git.kernel.org/mkp/scsi/c/267345b6d1dc
[2/3] scsi: qla2xxx: add WQ_PERCPU to alloc_workqueue users
      https://git.kernel.org/mkp/scsi/c/e4c7c844fae0
[3/3] scsi: qla2xxx: target: add WQ_PERCPU to alloc_workqueue users
      https://git.kernel.org/mkp/scsi/c/e6b42979ea61

-- 
Martin K. Petersen
