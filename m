Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72AD246BF;
	Tue, 22 Jul 2025 03:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753156065; cv=none; b=t6OYrqAI8xcB7bXzUnjsSDJICaQ2VuZGIOVLE0lxeX2Re3QJkkjYWlvfSR6Y6NKyZvy8aGnQo1Fm15Wz/7zAw82bmFd/UXcy9EFxo+3qRt94xmLr0Nnro4NvmdkPyBut0brf/1SyjES+aGiRNt6ljVf0AG/gxEt1Zm96uaZbopo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753156065; c=relaxed/simple;
	bh=0p0yfQ2H2n5PoakLPzlSYM+Q6Fjj9C31UGox0oSL52Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hzUmRdEuoHBiulmnChSGC2CNkE3FIYjcYba0uMDIsT/gR3R6MlYrLi+OvptkVQ4JhJ0ReZyqauWoCVgiHgnCxv9ZD/GlFJ/WTQqNSjUCV9bMjhJ0MJdqNZLioLMP1DmOgWxuOtJ7axxzTtgSw7DuYBtw/wQhBoe0RQLMF5+QzLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XHyRN+OO; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XHyRN+OO"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56M1BqUo019352;
	Tue, 22 Jul 2025 03:47:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vzEjL/rNIboXo0WYuyjNeNMnpUjYsdF2y4mpxRL8oFE=; b=
	XHyRN+OOBtP38h3Iu6mqP6VcpbT6UBHJcPHwUqG4MvXfBdx6HDVwxheQwbcfNwlH
	Gy64v+0lHUiv5vJtQFFHYZ9yW0npbkhYanp8XOUAotcMATbY5+moODmXGznhlXZN
	P1WXVvy6i0yj38Fw34HMlVs5MmVA4ml+Yg412J+EVrlArLW+UPXspS+i1NKWGwAy
	k/07l1Fmvr31LQTrFn/6k34scrl0X22x0rir+lwuiX5Ft6s2qDt2i3kqXBP8FYU7
	XqtkgRN+Z+z+qtkoAlZ1zvz7bdUpKMS/m2uCBhKN1fOV5dv61RGBGFawSRjMl6Tk
	zxkYbpEl8PREOr195yaiGg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4805hpc8sq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 03:47:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56M1JN57038305;
	Tue, 22 Jul 2025 03:47:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801t8te9d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 03:47:36 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 56M3lZj1031915;
	Tue, 22 Jul 2025 03:47:36 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4801t8te8u-2;
	Tue, 22 Jul 2025 03:47:36 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux SCSI <linux-scsi@vger.kernel.org>,
        Bagas Sanjaya <bagasdotme@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Rob Landley <rob@landley.net>, Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2] scsi: Format scsi_track_queue_full() return values as bullet list
Date: Mon, 21 Jul 2025 23:46:55 -0400
Message-ID: <175315388522.3946361.577268331521500450.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250702035822.18072-2-bagasdotme@gmail.com>
References: <20250702035822.18072-2-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-21_05,2025-07-21_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=764
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507220028
X-Proofpoint-ORIG-GUID: z9gqIS0pG55QIw8IK5p_S-ktqpkAs_19
X-Authority-Analysis: v=2.4 cv=YY+95xRf c=1 sm=1 tr=0 ts=687f09d9 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8 a=rdU_RhUVJ40YM6w5-0kA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12062
X-Proofpoint-GUID: z9gqIS0pG55QIw8IK5p_S-ktqpkAs_19
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIyMDAyOCBTYWx0ZWRfXxJcAQs0vFZKE
 sLWxHbaWPk7DMWCnnBG12zZa4t1cOQ2JxePQMX8W5ZMOKPc6ggcekeET910mOxwl7VuTakIEx5M
 aUbkPngRUFB7D3ICfTd0EeKLV1lOgfN//YUAo6hadCxSH9XheoU6Nb7VIi8ZebdAhihI5CFG6dQ
 v24bzV11kuXDQiBqOfDRXlGJ7P63WtrRMReP4V7fz3ewV6+iZLns5lQTL2i62Yyt4BZMb+LFItD
 Dn3PWi51K/n3ekHPgoraLvU+cd5Le0+8mPEAfQlsm+x3pV4/ELaO+dOmqHkehfebgss7lZajE5m
 Jzr+93GmTVjITbJGQCniXJybJjSjddub7I/DpUKwLB0sbiTJb+NV6pSwkTrd2HuhewNOapKeIE9
 s+0eRVriLR2MtyPpUnof8CPYTsR1gofrfMfJM1Pgwf6TIY2bPfL1yUok3nzZabfbXilpnFIs

On Wed, 02 Jul 2025 10:58:23 +0700, Bagas Sanjaya wrote:

> Sphinx reports indentation warning on scsi_track_queue_full() return
> values:
> 
> Documentation/driver-api/scsi:101: ./drivers/scsi/scsi.c:247: ERROR: Unexpected indentation. [docutils]
> 
> Fix the warning by making the return values listing a bullet list.
> 
> [...]

Applied to 6.17/scsi-queue, thanks!

[1/1] scsi: Format scsi_track_queue_full() return values as bullet list
      https://git.kernel.org/mkp/scsi/c/6070bd558aee

-- 
Martin K. Petersen	Oracle Linux Engineering
