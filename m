Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15443BFE44;
	Tue, 16 Jun 2026 02:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781576786; cv=none; b=q7j8zdQrY2GEbrcT4f0X2PnMNs0KXEohrUDsdy1PiR4WqBKbjWLGBndOYmFr+rwR1WewoUl9upBGbVnExRou/Hl7AEvC8vlfcXUcYpm5BH4o6JnQ+5jw4wZVcL16YpncH8AQLRPLqI3JR3lopGAcUhFRZ1qqOfQVcG9X1B/Fm18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781576786; c=relaxed/simple;
	bh=XyC7ovGb0BFzZdjXfS6YHZiJv4oJfuUIvhs58Oxqh8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qtPkpSkGpLoq9gy5YTJjMAS06PZs8ofCcFD29eWz+mI29OYhuVMZ2KNZq6RzhzcYCevEMX9i5VOB7FaGiEWCfBWmYGmeJR6bPeuoHF028WaSM1diI0Nwu5HwD4bQQiLeJWECeSKnkhpdcU3xGMaPFHXkK1wHWfduPDkvDoxR6zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=e6225Yx9; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="e6225Yx9"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65G2ARio2761448;
	Tue, 16 Jun 2026 02:26:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=iue5KSIXFSRAq6120tS5hnFnQKx0kOYnpXN/DGuRoBE=; b=
	e6225Yx9ny026lLLU1LNo6BnUz+6jtFhTNwTBLkDfVNMgV/FIFRF9a9nBkVOiF8V
	AfjW9TIiBPbRNy10FSYWP2CktqgWHUwtFqhLtm84luCFWWipnMusn0NC+s0LCW+i
	kyhG81bReLNVYuRxDJ74s6UO1wT3J9lM3yvCCib4Xe17pwls2Q2GOsZ+QY9lERlC
	9F6cyyCzd1uN4Sy2GuTD7nmsBpFaw5nvBIEsI6Pdlt8oDNK7H7FUVQfZ7jgTXajt
	drVtMJ7qdQtP+K34UzjzQAP1nsX6g0F5mh0RS/haH3f3VXi7exneYXzNoPXWBT4w
	5KL18HBphOmzKteL8MuAbA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4es1qj3md9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jun 2026 02:26:18 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65G2Nale016585;
	Tue, 16 Jun 2026 02:26:17 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4erwnpnymm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jun 2026 02:26:17 +0000 (GMT)
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 65G2QE2N023822;
	Tue, 16 Jun 2026 02:26:17 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4erwnpnyjt-7;
	Tue, 16 Jun 2026 02:26:17 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Justin Tee <justin.tee@broadcom.com>,
        William Theesfeld <william@theesfeld.net>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Paul Ely <paul.ely@broadcom.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: lpfc: fix spelling mistakes in comments
Date: Mon, 15 Jun 2026 22:26:11 -0400
Message-ID: <178157184624.1899010.13964131799113403631.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260602111912.23864-1-william@theesfeld.net>
References: <20260601202001.651088-1-william@theesfeld.net> <20260602111912.23864-1-william@theesfeld.net>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-16_01,2026-06-15_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 mlxscore=0 suspectscore=0 spamscore=0
 mlxlogscore=851 malwarescore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606040000 definitions=main-2606160021
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE2MDAyMSBTYWx0ZWRfX4e0EdbmSilCc
 sm6wa0yZto2y8I+s91PXryOnHRdxuxgHWOlIefE1q4ilniVhrjvRdt9a4sDM9PPk2y8hA22fmOo
 Sw+yKaDnLgz+TU3QOxAeGkK3iBcxr1HAsmsBXfk1+AyDZbIj73qz2l/X+3tdxCtPKDX9RaiZoQs
 z3hJS689mqzBjb3dIYJ35rE2FO5Q5gVZeLDD1p+XLcbFfDqyI1H0GK4DJpmyvMZ99UeCslNSYDl
 htfjUp51U/diF2JXMoVURWxqBpguFvhV1eOtaifjyHVWRqFtF3Z4J1xdAzsHeSt9X3gNcKAAtO+
 NK2n9sXfSo+2qU+tzTrXTnSWYMPoMrT+a9kCp+u44Jp6ocqhSttfbblOELIm2SVBFi+0OehWEtC
 T0NoMQ6IybbdtrbIVF4nxYvshuOzX++s6D8drOj/U3urgAx3cS6dSJZq6VvRpH7EaRfTzBqP8Jr
 +OiCMO/S87K9EcZ0qvqzsZHvMLYHkjQGywmp8AME=
X-Authority-Analysis: v=2.4 cv=KJlqylFo c=1 sm=1 tr=0 ts=6a30b44b b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=xpMT4_NjQj3vsoUINpwA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13723
X-Proofpoint-ORIG-GUID: cYNuAYX8F5xJhc4NlVAnCtOBGdOs0J3k
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE2MDAyMSBTYWx0ZWRfX8bYJPXX2Z7Rw
 QOTbaTPS4H0p+N+txd3Dfvb8Fde5DXEU/4CgYGD+TOjPdVEhRdigOLZgWL3wpOm1C6y552iU4k9
 yi2mt16h9MtHuRd5T0Qe9q8P9jebGuyXBQ2BpErieS3Tp9XLG8RZ
X-Proofpoint-GUID: cYNuAYX8F5xJhc4NlVAnCtOBGdOs0J3k

On Tue, 02 Jun 2026 07:19:12 -0400, William Theesfeld wrote:

> Comment-only changes across the lpfc driver, found by running
> scripts/checkpatch.pl with the kernel's scripts/spelling.txt list
> against drivers/scsi/lpfc/.  No functional impact.
> 
> v1 covered a single site in lpfc_bsg.c.  v2 expands to all
> checkpatch-detected comment misspellings across the driver, per
> review feedback from Justin Tee on the v1 thread.  Identifiers that
> happen to match common-typo entries (e.g. LSEXP_CANT_GIVE_DATA,
> LPFC_FC_LA_TOP_UNKOWN) are intentionally left untouched, as renaming
> them would change the driver's internal API.
> 
> [...]

Applied to 7.2/scsi-queue, thanks!

[1/1] scsi: lpfc: fix spelling mistakes in comments
      https://git.kernel.org/mkp/scsi/c/fc6f9719e68d

-- 
Martin K. Petersen
