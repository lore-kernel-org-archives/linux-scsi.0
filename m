Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE92B1E0DE8;
	Tue, 11 Mar 2025 01:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741655992; cv=none; b=EeDxVvJXQvQtgkZYNslQ+y9QIjKJhsnjHqEJuid07ZEhQdFEIQg3HDlK1x8PvSnHuSo+vEvPXQi2IEYLni5n99XJR3i5LE2qMQlR5ib8JBx4Lm7RwYgWcsVRLMbfs3sTHR7xmyluTcXWXB24NwZ+vdv010Osx7fFAQrP7e7ckJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741655992; c=relaxed/simple;
	bh=cRysWTu/ZgnC0ySgI+aRJu91jCLYtgyYkA8YrYHMMQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qEAaSSmJV+Pqlls66SgHyTJs3ft3V+sw93Nbv5VffKNjyA31U6su3zXV+bBu1W4tecNzb9/wfwRYbb+Bapmw5xm6e7YHbsyG8GISz5VhYXYlf1ktIZfU4C4FNvNQL7bpRSmL9ToRBbi9nDN5my3ZK0aupkzl25Jiw07fK3aK1fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=U18SOVj7; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="U18SOVj7"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52ALgTxX009907;
	Tue, 11 Mar 2025 01:19:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=BPOX8QjtM4ikjrrtiAcfOMpTH31E248pB9JcFq7Mgjg=; b=
	U18SOVj7WWMpPW8gHhJ5SuiqBC7Rmwx2267yT6oH0dkY0SetXv7KoE2dGdMt+oiu
	l8Cypm+2UcdY3LZpXQrTrEehmvp4I727Lbb2nUHJikgMRAnKrInQl1DRmULnEd5Q
	70MQXZ9/vcbFLWmBSwGVfy4a8RY53ERmbWaz2R6x2kHXlJWo31AOpM9aYWHtt9Iv
	AKcNkgUIS6/NZmhAngKCWmid6eWJzNMJhuMSJ5qP7SnfgMNcZ1+xNJeHKdRnXNWR
	4nVY7lotnhuTwI7bkD43zegKbEEg7KoWv1FH/IrtI2FyFNysD9GIef120xBeWB8i
	e3XQF2JTm+N/snJn8qlAfw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 458dgt3u5w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Mar 2025 01:19:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52ANtQkq017073;
	Tue, 11 Mar 2025 01:19:47 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 458cbencns-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Mar 2025 01:19:47 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 52B1JfrN014960;
	Tue, 11 Mar 2025 01:19:46 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 458cbencm8-9;
	Tue, 11 Mar 2025 01:19:46 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-hardening@vger.kernel.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: target: Replace deprecated strncpy() with strscpy()
Date: Mon, 10 Mar 2025 21:19:08 -0400
Message-ID: <174165505011.528513.5802380818483016300.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250302225641.245127-2-thorsten.blum@linux.dev>
References: <20250302225641.245127-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-11_01,2025-03-07_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 spamscore=0
 mlxlogscore=820 malwarescore=0 suspectscore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503110007
X-Proofpoint-GUID: Spes4Umjs7KcsA6g-EEMvnBpsvrUUmi3
X-Proofpoint-ORIG-GUID: Spes4Umjs7KcsA6g-EEMvnBpsvrUUmi3

On Sun, 02 Mar 2025 23:56:41 +0100, Thorsten Blum wrote:

> strncpy() is deprecated for NUL-terminated destination buffers; use
> strscpy() instead. The destination buffer db_root is only used with "%s"
> format strings and must therefore be NUL-terminated, but not NUL-padded.
> 
> Use scnprintf() because snprintf() could return a value >= DB_ROOT_LEN
> and lead to an out-of-bounds access. This doesn't happen because count
> is explicitly checked against DB_ROOT_LEN before. However, scnprintf()
> always returns the number of characters actually written to the string
> buffer, which is always within the bounds of db_root_stage, and should
> be preferred over snprintf().
> 
> [...]

Applied to 6.15/scsi-queue, thanks!

[1/1] scsi: target: Replace deprecated strncpy() with strscpy()
      https://git.kernel.org/mkp/scsi/c/dfb7df1ddb29

-- 
Martin K. Petersen	Oracle Linux Engineering
