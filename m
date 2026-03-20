Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91AB51F4CA9;
	Fri, 20 Mar 2026 02:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773974186; cv=none; b=sk4zfc6YtDQIQlMLrcTjprjIHiRs3n1H1zer4m7pIj3fze14fE/N10/TnV2fCcTmpgRYWeMWswVkhG8vXMP+Gegym217qQODYHDH59Ese0GvEdfA96zUshzY7rlFtXQGNYunqbISrSLharGnfzx0zBQeBsd8ly3fkfpH4nXlumQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773974186; c=relaxed/simple;
	bh=6xNB/W/uy0vG+PWLqsUc2q0dn1x7FRGbXBlg+5V8Yf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hxI5E5FNL9FKlPJEEBi7D0FS1Ad365m2NWgsKIzDQsme2dHBcUpdTnRYHNHjzgbB8ST4/jjdZzoIPb58MbIkP+QMTwqx/VWgYOa58ANUHna/EBI6Tc8us5b5H9zwLArdXk27fONZU2OHbyb3MQM8DdEWCfU+44c4h7+48NX1WAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=L02ad7E4; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L02ad7E4"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62JFr5OQ1070329;
	Fri, 20 Mar 2026 02:36:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=IN+ncruTS4vTplmL98eoZzqX55OaHLt6cpkuIKZnd2s=; b=
	L02ad7E48kT1gAh/jALiqLDCJaO2vVX67uET3ZBznTulXj301Ue0dKAgzupEQNIo
	3dGcIME2+viuSqZN7UqBKnprbiF89Ot6hHDUYCcruYSu+u4Nifyeluwrd+HNCeRu
	iyhTUmSKVUm9MsZyIySQKsurnVUstTj8UdEwN8wHq+gSN306+o/U4hssAL6r/UX3
	AkC+wt178GYFLwUP72Qqj9OZoOSa3lP8eGzUNd4cfX0/POH0IB4GMQfBLmjuryMP
	AStzwmK3ltQqzlV5Jvm4Kb1yw28vcYnERbMokUdgjo1x2tShURo7tDAR4yxvnhO1
	JbY/AMJU8eWSFnjtqoEQbw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvx8x911s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Mar 2026 02:36:16 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62K22bqU003617;
	Fri, 20 Mar 2026 02:36:15 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4dp7cj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Mar 2026 02:36:15 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 62K2aDRN020555;
	Fri, 20 Mar 2026 02:36:15 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4cvx4dp7bq-3;
	Fri, 20 Mar 2026 02:36:15 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: tyreld@linux.ibm.com, Tyllis Xu <livelycarpet87@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        James.Bottomley@HansenPartnership.com, brking@linux.vnet.ibm.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, danisjiang@gmail.com, ychen@northwestern.edu,
        Tyllis Xu <LivelyCarpet87@gmail.com>
Subject: Re: [PATCH] scsi: ibmvfc: fix OOB access in ibmvfc_discover_targets_done()
Date: Thu, 19 Mar 2026 22:36:02 -0400
Message-ID: <177397393951.2929898.9319678770156477793.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260314170151.548614-1-LivelyCarpet87@gmail.com>
References: <20260314170151.548614-1-LivelyCarpet87@gmail.com>
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
 definitions=2026-03-19_04,2026-03-19_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=935
 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2603200019
X-Proofpoint-GUID: oN_3w0l10hznnycDREGghoOziAiAdiFY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIwMDAxOSBTYWx0ZWRfX5pxQGFNNHGnF
 AOSf3aHM+pEKFSK0jJJVrru9JqoJ4IwWsW+2V5eXtVGh/ZmjTcPm7xycIbA8K9Y0bUZG/8/wB0f
 PfvBSBMs9AiHhSuMKqJSyN6XwyYg9l9ri9CMk/eW/oS33W/7JvZSRsQ5xKziHkfautTWVsAYXAw
 b4duYgtZU+cFjsHoWG6en/kPU2B47cjS3ihN9o6tejR8fbUMtc2OOk8irCQxpOHAnwkZuo/m/ti
 DZANC5PhvtmMKotg2DYHksr4LePYD5M4M7VFmLX0KqG8jCXL41Om4kSY0PBMjX+/R1EaNavT42G
 RImI8HBQaWJwPEOwqrIO7w9IGMgoIrschjAcMcvLFljuFA2EpsFtYQoXotj4JytSFLwU144xbTc
 BypX15E1XpQphJ13jO/+CI37UzuB7rK9PjjXt7YilVKNjH91sL9SBeSn23QIxrtWvG71HKkyBRP
 BbgHkRIcbymW8/MEj1w==
X-Authority-Analysis: v=2.4 cv=dJmrWeZb c=1 sm=1 tr=0 ts=69bcb2a0 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=VwQbUJbxAAAA:8
 a=aTZ9hoJJPXQvoIW4OmYA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
X-Proofpoint-ORIG-GUID: oN_3w0l10hznnycDREGghoOziAiAdiFY

On Sat, 14 Mar 2026 12:01:50 -0500, Tyllis Xu wrote:

> A malicious or compromised VIO server can return a num_written value in
> the discover targets MAD response that exceeds max_targets. This value
> is stored directly in vhost->num_targets without validation, and is then
> used as the loop bound in ibmvfc_alloc_targets() to index into disc_buf[],
> which is only allocated for max_targets entries. Indices at or beyond
> max_targets access kernel memory outside the DMA-coherent allocation.
> The out-of-bounds data is subsequently embedded in Implicit Logout and
> PLOGI MADs that are sent back to the VIO server, leaking kernel memory.
> 
> [...]

Applied to 7.0/scsi-fixes, thanks!

[1/1] scsi: ibmvfc: fix OOB access in ibmvfc_discover_targets_done()
      https://git.kernel.org/mkp/scsi/c/61d099ac4a7a

-- 
Martin K. Petersen
