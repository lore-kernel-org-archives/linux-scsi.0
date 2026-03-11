Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F42FEEBB;
	Wed, 11 Mar 2026 02:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773194786; cv=none; b=vC72MkvJ10B3fxyCEmDCiezVbyDo9Prqj8vVUVTENsRwsbt0qupJvtOo6pkzm9mZPigAQixV4n7XzjtBgcGtMJCF0+cmTGrBHwBLbga6wKo6NGKRAyyO9sNpY69j9w/vArH2MkOdE8Bg+vZL5CY5YaXIukaLx0IS3nzbIcMHAMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773194786; c=relaxed/simple;
	bh=f5NrB2+MF6IuhSvfYv97sWQzS7nsD4D29btDqD/A8Os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r5SOX0QwsrkPiuSghjc9+l4ncN3S9CgWVh2OezSMF/Msp71ZJ6nQMyTGgOcuUk8/WaxdP3gNYjiaTndWMHlIvdQmab0UXtEryMNDcADPMp7zUcKRVRyo6LcGPMvW+0HE2Cjw+vjjIOGtZFiUEkLNbMT7bG7VNEUB3tPHGKEY6+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=a6ARQcHR; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="a6ARQcHR"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62AIRx5F094083;
	Wed, 11 Mar 2026 02:06:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=mBNGxd11BrB6aNmJsxEPjL+0ba1mfye31QrYaoh/2DA=; b=
	a6ARQcHRG/vMB84EfpCAr/256VN9RCvWHvK7HGUlge0/kTUixiJV/qN8Sj9ChOTh
	nfZhOxGDpI2l1nbFju5YEjWTts3k/NBuahbCFe3xGLm1D524ne5kCaqqYjgkCqpD
	Y4e+sqPOjuDu7OsdUvb4j2FUVAIMwpuY8k+njg0I5asREYG8SwFjvlZiaPWp6S/B
	MeOkpFSOmKAh1Iu9vkiNKQA5LINS4cHGi5zvumb3qxYWfyiV3qDGZnNF5rJ11rNE
	eIzwESuxtnNnq4to2CBkkrMBFJ9J+fCLTe0wk689xhzRqSxjKZVPbLFNK4cr6dG4
	eAnMeNzNV6zuV+fhFEMbVA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4csmdkm42x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Mar 2026 02:06:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62B1wQIa020419;
	Wed, 11 Mar 2026 02:06:23 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4crafewwk1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Mar 2026 02:06:23 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 62B26M5L002770;
	Wed, 11 Mar 2026 02:06:23 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4crafewwj6-3;
	Wed, 11 Mar 2026 02:06:23 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/4] scsi: target: Add support for completing commands from backend context
Date: Tue, 10 Mar 2026 22:06:14 -0400
Message-ID: <177289787702.2131580.18065820173103333438.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260222232946.7637-2-michael.christie@oracle.com>
References: <20260222232946.7637-2-michael.christie@oracle.com>
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
 definitions=2026-03-10_05,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=956 adultscore=0 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603110016
X-Authority-Analysis: v=2.4 cv=MuBfKmae c=1 sm=1 tr=0 ts=69b0ce20 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=guXa3lI3ESm7tMO7ugcA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12272
X-Proofpoint-ORIG-GUID: 6ryXP5Tv0wSRclzIpErBmiDqpHcbI-uy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzExMDAxNiBTYWx0ZWRfX3ST9wNswga8O
 2gz0bEfLddq5+ZfM7G9TeZ66Ype2/AkGVCbTe6rC+GljxipYXmO+nlvyVnIfpcf7ncNWkVDNMdR
 HpFIuFawVLEk1m7du/fix/S5ARVL60qdzwlKAERmoCekNHOw3uftSuzNrzNFP5R/VxsKdDDApI1
 MRjSQxpajUFuOjslu53Dji/eYtxqTr/+z/f5J4AweZWsO9Z0dXF7yUdPhMfTaWbx7YOXt0DLOxe
 AcSbZDC+E81D3ZzmtqpH7p+DwUb5OyukakQJmBymX7kBIrscVK3cyc3N7yGvQ4TesHItDyuNl/7
 4AkaMQbyjjDTMvz12oju8650f1YbkFApPDohfQjaqdfQOy7UMj9IXEVLWWldi86DyotoTQog3We
 2ZxfrGVpxA7kIy0sV0FWGxH/iK4RVRuNvrC8cQcKIcMbNTa7rXL8LeCj/53YKQLWFBV9rTqXyZ0
 0IHfLULCbrwSusMOERQBHDks6rFACDsmGqpXnMFw=
X-Proofpoint-GUID: 6ryXP5Tv0wSRclzIpErBmiDqpHcbI-uy

On Sun, 22 Feb 2026 17:27:01 -0600, Mike Christie wrote:

> To complete a command several drivers just drop their reference and
> add it to list to be processed by a driver specific thread. So there's
> no need to go from backend context to the LIO thread then to the
> driver's thread. When avoiding the LIO thread, IOPS can increase from
> 20-30% for workloads like:
> 
> fio --filename=/dev/sdb  --direct=1 --rw=randrw --bs=8K \
> --ioengine=libaio --iodepth=128  --numjobs=$jobs
> 
> [...]

Applied to 7.1/scsi-queue, thanks!

[1/4] scsi: target: Add support for completing commands from backend context
      https://git.kernel.org/mkp/scsi/c/06933066d88a
[2/4] scsi: target: Use driver completion preference by default
      https://git.kernel.org/mkp/scsi/c/89663fb2e538
[3/4] scsi: target: Allow userspace to set the completion type
      https://git.kernel.org/mkp/scsi/c/e1502d990c8e
[4/4] vhost-scsi: Report direction completion support
      https://git.kernel.org/mkp/scsi/c/a4d72d2dd0cb

-- 
Martin K. Petersen
