Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81EB141989;
	Wed, 14 Feb 2024 22:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707948874; cv=none; b=k4i1TOQcuYRgP/6CyYJBzETMn6L0evNbFzPOQKuMHCwSAQZ3tPp1Xe0YQ4uAE9wzkGHuTrfOcm3GfHm3prvE0Qbj7+/qAz/fF8+IZGevbowotxjr7yRGI2aQDzqLpx80dTHvkNvDTaxE7n6rnLxdUmkKgqH80QtdTi8akvvkVVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707948874; c=relaxed/simple;
	bh=MBNyoTNrMFm88MBdz2XN+cxJ+NbJO9blJRPLgTBPtDk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Nnl/sKKrdV6Uhhf8/nxmQlgiM569BME7/00CCsGcdiiCrxV3GEdBDnwfWidaFY7bj+4z5syEZbqRFInwv7LZQAWYlIJVI5pI0jKH8jmsLSQOfpGqdGfFrUNe7/Cs27Tz7u9Aw3Mo6Xrs5tennlxVsyc+oDr+KM7Lh+xCL8icPIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TG40N4FN; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TG40N4FN"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41ELiWJ4022704;
	Wed, 14 Feb 2024 22:14:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2023-11-20; bh=6xQXk51zyAc/FJVeHYLZ/+JdxhV5quNYw+01DQcVd5M=;
 b=TG40N4FNlDOT7ZFvxte3ufnEvTokR5mCkLEyLnTqAY8EQse0cc8H0xA5nXIloiu8CBTy
 o+21h0lKx1SHDkqoW8bUVZk3li8XCX+n3gTSeT58mRduvPC88zwNzSDoCRjIHb7vM0WS
 U0ZZo0XFze0w+6kMaLonaacLycbU0fTjMoUPqv9UG8iFPib61kI0EJdcuYXXOlYXxjaE
 otXKjS16K6ME4hGl1HTOf/MY+KGdahnPNumJ5Y7qHy2tnGZkAjb7vaxjJ+vnvvmMWMNe
 PZEEi2Dhgu4dRXO8bbwyLe9L0YVFxZuxWtOzzw/0hiI6nkenw4AYfMtG2hjUK+O6cxih TQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w92ppgghp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Feb 2024 22:14:21 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41EM7PWJ000598;
	Wed, 14 Feb 2024 22:14:19 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3w5yk9mmsk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Feb 2024 22:14:19 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 41EMEJIU031042;
	Wed, 14 Feb 2024 22:14:19 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3w5yk9mms8-1;
	Wed, 14 Feb 2024 22:14:19 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
Cc: belegdol@gmail.com, "Martin K. Petersen" <martin.petersen@oracle.com>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2] scsi: core: Consult supported VPD page list prior to fetching page
Date: Wed, 14 Feb 2024 17:14:11 -0500
Message-ID: <20240214221411.2888112-1-martin.petersen@oracle.com>
X-Mailer: git-send-email 2.42.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-14_14,2024-02-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0 mlxscore=0
 bulkscore=0 spamscore=0 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402140167
X-Proofpoint-ORIG-GUID: zQ8k94iFH4zMb3RUJmygo0uic13atvkN
X-Proofpoint-GUID: zQ8k94iFH4zMb3RUJmygo0uic13atvkN

Commit c92a6b5d6335 ("scsi: core: Query VPD size before getting full
page") removed the logic which checks whether a VPD page is present on
the supported pages list before asking for the page itself. That was
done because SPC helpfully states "The Supported VPD Pages VPD page
list may or may not include all the VPD pages that are able to be
returned by the device server". Testing had revealed a few devices
that supported some of the 0xBn pages but didn't actually list them in
page 0.

Julian Sikorski bisected a problem with his drive resetting during
discovery to the commit above. As it turns out, this particular drive
firmware will crash if we attempt to fetch page 0xB9.

Various approaches were attempted to work around this. In the end,
reinstating the logic that consults VPD page 0 before fetching any
other page was the path of least resistance. A firmware update for the
devices which originally compelled us to remove the check has since
been released.

Cc: stable@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>
Fixes: c92a6b5d6335 ("scsi: core: Query VPD size before getting full page")
Reported-by: Julian Sikorski <belegdol@gmail.com>
Tested-by: Julian Sikorski <belegdol@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

v2: Address Bart's comments.
---
 drivers/scsi/scsi.c        | 22 ++++++++++++++++++++--
 include/scsi/scsi_device.h |  4 ----
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 76d369343c7a..8cad9792a562 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -328,21 +328,39 @@ static int scsi_vpd_inquiry(struct scsi_device *sdev, unsigned char *buffer,
 	return result + 4;
 }
 
+enum scsi_vpd_parameters {
+	SCSI_VPD_HEADER_SIZE = 4,
+	SCSI_VPD_LIST_SIZE = 36,
+};
+
 static int scsi_get_vpd_size(struct scsi_device *sdev, u8 page)
 {
-	unsigned char vpd_header[SCSI_VPD_HEADER_SIZE] __aligned(4);
+	unsigned char vpd[SCSI_VPD_LIST_SIZE] __aligned(4);
 	int result;
 
 	if (sdev->no_vpd_size)
 		return SCSI_DEFAULT_VPD_LEN;
 
+	/*
+	 * Fetch the supported pages VPD and validate that the requested page
+	 * number is present.
+	 */
+	if (page != 0) {
+		result = scsi_vpd_inquiry(sdev, vpd, 0, sizeof(vpd));
+		if (result < SCSI_VPD_HEADER_SIZE)
+			return 0;
+
+		result -= SCSI_VPD_HEADER_SIZE;
+		if (!memchr(&vpd[SCSI_VPD_HEADER_SIZE], page, result))
+			return 0;
+	}
 	/*
 	 * Fetch the VPD page header to find out how big the page
 	 * is. This is done to prevent problems on legacy devices
 	 * which can not handle allocation lengths as large as
 	 * potentially requested by the caller.
 	 */
-	result = scsi_vpd_inquiry(sdev, vpd_header, page, sizeof(vpd_header));
+	result = scsi_vpd_inquiry(sdev, vpd, page, SCSI_VPD_HEADER_SIZE);
 	if (result < 0)
 		return 0;
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index cb019c80763b..72a6b3923fc7 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -100,10 +100,6 @@ struct scsi_vpd {
 	unsigned char	data[];
 };
 
-enum scsi_vpd_parameters {
-	SCSI_VPD_HEADER_SIZE = 4,
-};
-
 struct scsi_device {
 	struct Scsi_Host *host;
 	struct request_queue *request_queue;
-- 
2.42.1

