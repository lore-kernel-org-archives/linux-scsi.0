Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86A14C6F0B;
	Thu,  6 Aug 2026 19:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786043194; cv=none; b=HDXUjPTZZ5+IKJV7W7qgCH9hqv9SEEOlGTy94RwKljdY5rGq8RgFbHDpjJI+Q7RyHkLPaOp0QbC75anFcg6fXiaF/JXBu0uL1lHIZ9LaKEobR2vmTDEZJ1q/Sk5IcBCTatXkAg4wcUuFzWsix3AaYfI7Of/Kqv1ZYnvoi9kNVvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786043194; c=relaxed/simple;
	bh=79bJM5j4W5JUrFNU3A0CtT+/k7M4P3AxrV1oBEwyFKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AIWKMuc5UnwKHzllGGlu1Pymmy3sPETxVa6fgMEqBVfxwIFGKf5csLR6NX7knehMPU4mSg8pwBplbyAOBxFSbcI57frjEbDsxBFhHUzSgqq3the2EENDNo4QW2ez+fc5Ku4TPwRsz4c1nJ+gYIhTqm72b/qHEiPWc8gOk7ViYBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bBHs75xt; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bBHs75xt"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 676FubKG3081893;
	Thu, 6 Aug 2026 19:06:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=8egc59vTux2qFwP6pPDLVocCRj0+tTCiOPVpdEeqiwg=; b=
	bBHs75xtCDnIyf+owFV7I5JApuEJ8uYs4kG9Cqc4xO1UaGi9F2zTKYi+BwmgLEcn
	U6/uDD+xDkQbDFJtv2p4lJr/KZvBI+aHKeuSqct6GF7bGLS6UIAzofARishA9Adg
	8jq7M3H5g9gzGVvziAOGrBGjX2XlEf9tAQeGGf33enp7B/jv25UDP5mNSOytfA1H
	fwy5vMi6X5G+tziL/QyLDp6vmEf8SA0jUZS1nhat6x4Wh5jU3wMDeZacEMi2EkDT
	mI5/73YGGge72zZrKqSWfbDrfYMNVT0S93kuTbVl1KlySA62enae7CqT2+UlPook
	WMG+lBqr2yUL0lirXyNDUg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fs7cyesmx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Aug 2026 19:06:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 676J0eim024844;
	Thu, 6 Aug 2026 19:06:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fs78w56ex-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Aug 2026 19:06:25 +0000 (GMT)
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 676J6Lgd011247;
	Thu, 6 Aug 2026 19:06:25 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4fs78w56b9-5;
	Thu, 06 Aug 2026 19:06:25 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: sebaddel@cisco.com, Karan Tilak Kumar <kartilak@cisco.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, arulponn@cisco.com,
        djhawar@cisco.com, gcboffa@cisco.com, mkai2@cisco.com,
        satishkh@cisco.com, aeasi@cisco.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        jmeneghi@redhat.com, revers@redhat.com, adakopou@redhat.com,
        lduncan@suse.com
Subject: Re: [PATCH v6 00/13] Introduce functionality for NVMe initiator
Date: Thu,  6 Aug 2026 15:06:10 -0400
Message-ID: <178589207073.336697.8539200579764145897.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260724174811.5118-1-kartilak@cisco.com>
References: <20260724174811.5118-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-06_02,2026-08-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 spamscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0 mlxscore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608060149
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDE0OSBTYWx0ZWRfXzs5uuo1a9A6C
 ld7ADUWUaXDexysYCP8021H2Dszmd3G0sPPb/G2sJwxBr7AfZ7oJ6ow5ktJBgfkrs+Zqbjys6G2
 VXutvj7t6WjpNvQPKJ85yEvXERLxNjUSAVMVbHOE9nff2T4Pi53A
X-Proofpoint-ORIG-GUID: 5wCxTKYixnNLnjBB-Yss6hIUo_WVaJxL
X-Proofpoint-GUID: 5wCxTKYixnNLnjBB-Yss6hIUo_WVaJxL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDE0OSBTYWx0ZWRfX7B52T+pyU6hh
 LgR9Lm50u8HlHpR4QH36Uq2Nkhp+KQe2fHIvjAwKxsa0pfYVcpukhlJM7UiG7pb0VD89xShuHep
 f8jhB3fZWzc957vm0pYhEkdj18CKEJ1WrLqLBXZw7nmKs143O8IpUHk7vWcyvlOPx0bVOrBRJqZ
 r84hPPLAkEGeQOI3CpwoWI+Lye+krVF7fK9JHktpphdGxqNrrb9h+Uk888wWt+DAHIyFpYKmhbQ
 ZxlGw27n9URUPbaKFeI964pJxwo/ANG2VTU2G2JG6DJvr0o5o3PBkNRxlJA04dyuHbM3g+ZfUkQ
 U3xEiK8YStplsAnQDyn8eNxnB91kKbsSY+lqQSlnzbyUpwt+/7uZ4ofmi60o0OBiJOLWtIgXHMM
 i7YCAHRDjQk68iq60jG32SJhXtAgGiWnrwEyUiuYuN7oXzv9hXirIhb72q6H/MqdLqhz/QCCdGE
 zy3AuL2YOTpem1EI/88a4272SPf6Fv8ZY22n5fGo=
X-Authority-Analysis: v=2.4 cv=TsPWQjXh c=1 sm=1 tr=0 ts=6a74db33 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=VwQbUJbxAAAA:8
 a=Y13Oa3_m4wEJ6IyMQB8A:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13510

On Fri, 24 Jul 2026 10:47:58 -0700, Karan Tilak Kumar wrote:

> This series adds functionality for NVMe initiator to the fnic driver.
> 
> The changes enable the fnic driver to act as an NVMe initiator over
> Fibre Channel (FC-NVMe), allowing the host to discover and communicate
> with NVMe targets using the existing fnic infrastructure. The patches
> prepare the driver for full FC-NVMe initiator operation while
> maintaining existing SCSI/FC functionality.
> 
> [...]

Applied to 7.3/scsi-queue, thanks!

[01/13] scsi: fnic: Make debug logging protocol independent
        https://git.kernel.org/mkp/scsi/c/b93c38a9f2ce
[02/13] scsi: fnic: Use fnic_num for non-SCSI identifiers
        https://git.kernel.org/mkp/scsi/c/6128fec94173
[03/13] scsi: fnic: Decode firmware role configuration
        https://git.kernel.org/mkp/scsi/c/12bd1b29128e
[04/13] scsi: fnic: Advertise NVMe initiator service parameters
        https://git.kernel.org/mkp/scsi/c/20b991c30229
[05/13] scsi: fnic: Add FDLS role handling for NVMe initiators
        https://git.kernel.org/mkp/scsi/c/188dfadf025a
[06/13] scsi: fnic: Add the NVMe/FC transport path
        https://git.kernel.org/mkp/scsi/c/5efdd5cf9281
[07/13] scsi: fnic: Route completions and resets by initiator role
        https://git.kernel.org/mkp/scsi/c/b3f4bc0a7aec
[08/13] scsi: fnic: Handle NVMe LS frames in FDLS
        https://git.kernel.org/mkp/scsi/c/021db11aba3b
[09/13] scsi: fnic: Send NVMe LS requests through FDLS
        https://git.kernel.org/mkp/scsi/c/39bf075599bd
[10/13] scsi: fnic: Abort timed-out NVMe LS requests
        https://git.kernel.org/mkp/scsi/c/f06ee33d72f5
[11/13] scsi: fnic: Track NVMe transport statistics
        https://git.kernel.org/mkp/scsi/c/d25a557d344f
[12/13] scsi: fnic: Expose NVMe transport state in debugfs
        https://git.kernel.org/mkp/scsi/c/8ef412ce8bb3
[13/13] scsi: fnic: Bump up version number
        https://git.kernel.org/mkp/scsi/c/2265541d221d

-- 
Martin K. Petersen
