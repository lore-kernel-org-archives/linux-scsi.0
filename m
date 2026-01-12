Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2B27262A;
	Mon, 12 Jan 2026 03:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768187740; cv=none; b=oVmIZ3OrDb5ZY8FJ54ndfs/IaFHLZY/Zso8e0Qr1mzXrIC04/e0QeTT+zGP/a4zGte1pD5AvvYuUPeRq+bQ9BtM2yhoc1wH8b7OUxYush2U/9RfJTNkIVHnkJG8chRrsFK8VEkbmIhnSgB4ZUriolmBpKZan/vgzLhfp/QUeUXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768187740; c=relaxed/simple;
	bh=ZCgUlGppXeh46Q8wx6BZPgvgq6lWFY0VLNlnn9AxC30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jqZ9sp2kN308FXBZLyuGCKJ9U53shuCAZRNG17g5Q2kFZb/AZweOm22nlJYb431tVrsXBz6Gq51iWi55v1DsmvuhwrUZ1T7ce3Z/vKD6jpR9QlGybTUfQB0oVhjdYT/JixZ0HAS/DnjEPl6AFmBOGdeu7T6O0o/C6QTR0hlWd0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YKDiiNOJ; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YKDiiNOJ"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60C1xs1V342145;
	Mon, 12 Jan 2026 03:15:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=4aRxeZeo/LkEspFz7vRccbDTfPiAQuwhXxAXIBLPuvM=; b=
	YKDiiNOJc7fJptTt/VH64Cr5rBwUQNIi1tma9ZTrnwsrfeoSQ6kXCVOPKcEDl76g
	KU6aQmyKRZ9KCkcUyi8+J77hu84zlYwjDL6kQkNTGZfkOs+G0Hs5Qh9SpyqiXmjF
	Q1oYMAT+/nUrshdU7/94w8quCPVCq4brdZq75wNQ4qqPyQBO8lir+8ZhMLBnayqr
	3HXqe9J+yPuxOYZXQmczsgyMi8zsM08iAvZZQ5FiYn0sCT3OYX55GjUgCnS+//3M
	ZcxMg34f+sdDg57B6PNi9mOr4ueXZQ4/ld2u69yOj7N2zR6SChbJi9W0PycnOnI4
	Zl6BPt6RG4Z3QBNlqz9ISQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkntb115a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Jan 2026 03:15:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60BN0q7l029335;
	Mon, 12 Jan 2026 03:15:37 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7gnqs8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Jan 2026 03:15:37 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 60C3FaCk019952;
	Mon, 12 Jan 2026 03:15:36 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4bkd7gnqs3-1;
	Mon, 12 Jan 2026 03:15:36 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: target: Constify struct configfs_item_operations and configfs_group_operations
Date: Sun, 11 Jan 2026 22:15:32 -0500
Message-ID: <176818268040.1966853.753214202766218860.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <a0f25237ae86b8c4dd7a3876c4ed2dc3de200173.1767008082.git.christophe.jaillet@wanadoo.fr>
References: <a0f25237ae86b8c4dd7a3876c4ed2dc3de200173.1767008082.git.christophe.jaillet@wanadoo.fr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-11_09,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601120025
X-Proofpoint-GUID: dPvh8e520BP19bRdb6MOXpc-1N89nGZ0
X-Proofpoint-ORIG-GUID: dPvh8e520BP19bRdb6MOXpc-1N89nGZ0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEyMDAyNSBTYWx0ZWRfX/9DwuOczy8ee
 KMCV/7pUCyamuErNaIIhTw0nvw+HiXIafLOtkUQ0WvGxt5hzvIdZpyXqSp9Kjmyt7vZOEHLxC0y
 4a3DMt0KeOCNN0fCcDxQriuhzdj+1uOsds4cvaL8v6yCzQsPnqGaYGGIqG/WIrLCSNqOimzAhcT
 pijlu21eIDa1MW2lJYVshGt/Y+dN4yEWqvvGfUsqT8wZapWvcY05EP5PG02UQw/U8aEEJeUXf8n
 N6qrWKIREMy+hkRtwqjknL4EkIG+vBXYMr/1RLfETNkeszQ/KwWn3g/rqUHjHr5c/hd0i6TQ2M+
 zZk9Ls36AIHZesh1fEoTEcMVgDqMYJRySpMhKwiSFnLyDybNyTT5A+FEjDNb6Ss4AX6q0j8WKBK
 aqM5vK/Px/2yqUa2RMZ2gOhCGWHJlwMrKoJMRH0FvxfLPDJr/T/PGsl/lDzrTUHQkxZ6P9ixxTu
 Xp/QfS45J5FjqsAslTrLvxT7SNpGfOUPyHgcK1Ls=
X-Authority-Analysis: v=2.4 cv=fIc0HJae c=1 sm=1 tr=0 ts=6964675a b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=vb0bRh6vb49zVdbpWocA:9 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
 cc=ntf awl=host:12109

On Mon, 29 Dec 2025 12:35:01 +0100, Christophe JAILLET wrote:

> 'struct configfs_item_operations' and 'configfs_group_operations' are not
> modified in this driver.
> 
> Constifying these structures moves some data to a read-only section, so
> increases overall security, especially when the structure holds some
> function pointers.
> 
> [...]

Applied to 6.20/scsi-queue, thanks!

[1/1] scsi: target: Constify struct configfs_item_operations and configfs_group_operations
      https://git.kernel.org/mkp/scsi/c/ae62d62b1c74

-- 
Martin K. Petersen
