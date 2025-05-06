Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D202D441E;
	Tue,  6 May 2025 04:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746505563; cv=none; b=KfxxNqSmArItyc71yZyqDkiGEzW2MGI8kQQX/t9HXvMHLlQF9v/ZH+eAyrQLN3NoVIJczahwbSIrsh1tkJfSBb1a0Tf0o+MRcWlGFRVxsWJq3FFCZcJFvSovQaURTOskCEcmyRvCeOG3O1jT5FeGyF2HKs5nbybdMDwJ6aUrCJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746505563; c=relaxed/simple;
	bh=lkRcp2rXmnVanP67lEk/ZrvP3kf66bjMzPrq9ZNyPik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ibOb9QyXNZcXi6qXc85VDtL5pJHiXZSrDzVXM+vLSeRFJKnxVY5rJKrw7+Lt3QI1tWm7eOn92qyzUyuv9JiiYAxs9uqEa+3tq/43iqK58A7U7qwfTcG1hJzvJPAWdiVPYIp8K02O3S0fnufO/Ja/CLC3/U/eU4sBIOf7VjiJMf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jnjOQJAM; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jnjOQJAM"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5463H9el000306;
	Tue, 6 May 2025 04:25:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ft7vMDx7TJ5xjH1AWkbO1m6u1HA46QDwXXOA06kSM8Y=; b=
	jnjOQJAMnDaShkxwYpGcP063L9zMdo0t1569X63qI2W0d7x1m2/rdJtfWopapNFR
	CFMymgtf6ZScOrgGs9uqI2h/hynm3X5afR0zi9gPlcE/SvO25rujMGXOM2eiAn21
	qSLDggi+6I23iW9Gw3SDdl1K8MNIHr6Oy/g0DhsZR7ZauY2g11jRR7660CiaOqAM
	QOpvcst47dbiDvsIvqFAJ3uObKV2Nl77u0+HbLIz8XHi2gnQAAg+lEsD0nm1CvxE
	CeQpwdCsOqvkh+CZEpSxnCeOhSegOlKsTb6oYe99YPr3YF8Mz3/ckFOlEPgNBzgo
	FdlIYnZmp1al7vaBJdxTUw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46facp01v4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 May 2025 04:25:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5462wsdu036085;
	Tue, 6 May 2025 04:25:56 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46d9k8gpnt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 May 2025 04:25:56 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5464Pr4A012838;
	Tue, 6 May 2025 04:25:55 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 46d9k8gpmt-3;
	Tue, 06 May 2025 04:25:55 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Nilesh Javali <njavali@marvell.com>, Kees Cook <kees@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: Remove duplicate struct crb_addr_pair
Date: Tue,  6 May 2025 00:25:21 -0400
Message-ID: <174649624839.3806817.14961647654388408228.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250426061951.work.272-kees@kernel.org>
References: <20250426061951.work.272-kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-06_02,2025-05-05_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2504070000 definitions=main-2505060039
X-Proofpoint-GUID: nCCZVXbf1r4mGgofNB9kVKD3lDCWbiO2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA2MDAzOSBTYWx0ZWRfX3W7tQ+uiQf6h 6BO0J4XVWca9HtYPh9/fA+msz05Be07sNj8EiyoXJYBWIoCPmfGEgAK0e7yqhJ9p//WDQ32m4mj qDROEQuaKf8/SU7VmhGAS+gMfiH3NIv9zQ0QGqPZ3t4JMYV+PPdKQWjF2dsfD1Id9Z0YimPCHVA
 tQh11pjeXZHo1S7kt2QpTNYJWXEonE55b0EhNpNqxT5gfr3ZSJN/7CasyrA1I7cAPJFM0o7UtbA PV05dolk73Sq7siWOldnZXCladckCD6zvB6Y82RlVlQ6h2zTV9fcH8pHTOeZYn2TPwHElRTTCSX dVH/biLNbEPi8bbCPlBN+Df4RxIorXEQWx06nT5eLeD8KsiMfAtNyvpMKydDCcV1x2DOWHXg8W/
 74EGYPGKHoLAtmT9UrBJi971zvlP3UdZjRn7atJw2DDS+mWkK4FYgVrNBY3F0QvVXI9GiArV
X-Authority-Analysis: v=2.4 cv=VMbdn8PX c=1 sm=1 tr=0 ts=68198f55 b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=gieQ7GMfMR2A4jGg8wMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: nCCZVXbf1r4mGgofNB9kVKD3lDCWbiO2

On Fri, 25 Apr 2025 23:19:52 -0700, Kees Cook wrote:

> In preparation for making the kmalloc family of allocators type aware,
> we need to make sure that the returned type from the allocation matches
> the type of the variable being assigned. (Before, the allocator would
> always return "void *", which can be implicitly cast to any pointer type.)
> 
> The assigned type is "struct crb_addr_pair *" and the returned type will
> be a _different_ "struct crb_addr_pair *", causing a warning. This really
> stumped me for a bit. :) Drop the redundant declaration.
> 
> [...]

Applied to 6.16/scsi-queue, thanks!

[1/1] scsi: qla2xxx: Remove duplicate struct crb_addr_pair
      https://git.kernel.org/mkp/scsi/c/386e014202f8

-- 
Martin K. Petersen	Oracle Linux Engineering
