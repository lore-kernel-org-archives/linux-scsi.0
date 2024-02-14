Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC1F126F3E;
	Wed, 14 Feb 2024 18:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707935148; cv=none; b=VdWGDDDPb5qxm5uFYHC43HBcI+NqZI1r3597IBLvU399F27Qr1j3MNPXQ7ioqDkMEf0WlCo/TqvPvTaVZ2PBz6Go9i2dw5Rbi5O46kzJfrNAL57u9WeLd1GvKP2Rxv0lqXvl5G10HSgJeYR052MAzjLXeGaKS6V8XhM7rqqbZsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707935148; c=relaxed/simple;
	bh=1vQt8jhGZZ4Okrp/m/px5CbpOfzKFMz5cDzvWzQMPc0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ih8F9PfpoAwDi8EZULuFfpDHFpifd995CXVyMUKERKYtDdLG6/jp5dpYOtEn4qSIvdfH1RsIPbprNUdcwKlYMMNGxTgGUQli128gHJPo91EuMhVHXSH3/APJbhtslgr+DMCWmYcxWo/nDElBrFziDfINy6ioyix+mRlN2h6bH9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RCaRZSd/; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RCaRZSd/"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41EI9jRn028981;
	Wed, 14 Feb 2024 18:25:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2023-11-20; bh=xfeg7oOmfZUIsWxEBtMsJD9XI2+1Y5YvmYF+cuMF5dg=;
 b=RCaRZSd/3lvmn5q3VbP6QQ+ArzHveHljOawY5iSTWet7hhiVVfIJU3lN99ToaTV8hMqC
 zsSmWljCZwCjc9Wv8hrdy8JNzQ2FTdgWXz3ZkJMQORb4SJRfxtYdcabhiTaxZqkahBBx
 PUS5bEQ3R4uIqGdQnMYcNS9XYxLYV51LVP99pb8Dg6/v/OoKRRJsHXDJ3HKhCOcaHeh2
 kTqhMxnRkT6A7wjnLVyXRz/s2C479Xs+CHspwr/QFigv24C45DrEk2ZaQ8huTwZMmCGn
 rJBe5CvLObqvU7L2P7Xogtm9XoP5/q+sBud3hq5Q6+AHQo6X8jNGQEwEB/eiu0GXrmGf ww== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w92j0g162-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Feb 2024 18:25:44 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41EHpwYM015057;
	Wed, 14 Feb 2024 18:25:43 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w5yk9b9ed-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Feb 2024 18:25:42 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 41EIPgbD003348;
	Wed, 14 Feb 2024 18:25:42 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3w5yk9b9cp-1;
	Wed, 14 Feb 2024 18:25:42 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
Cc: belegdol@gmail.com, "Martin K. Petersen" <martin.petersen@oracle.com>,
        stable@vger.kernel.org
Subject: [PATCH] scsi: core: Consult supported VPD page list prior to fetching page
Date: Wed, 14 Feb 2024 13:25:35 -0500
Message-ID: <20240214182535.2533977-1-martin.petersen@oracle.com>
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
 definitions=2024-02-14_10,2024-02-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 phishscore=0 adultscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402140144
X-Proofpoint-GUID: Altetu1zu2TCtqABQdJSkQ8QeIgKrb0-
X-Proofpoint-ORIG-GUID: Altetu1zu2TCtqABQdJSkQ8QeIgKrb0-

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

Cc: <stable@vger.kernel.org>
Fixes: c92a6b5d6335 ("scsi: core: Query VPD size before getting full page")
Reported-by: Julian Sikorski <belegdol@gmail.com>
Tested-by: Julian Sikorski <belegdol@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/scsi.c        | 21 +++++++++++++++++++--
 include/scsi/scsi_device.h |  1 +
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 76d369343c7a..5ef5fcf022ed 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -330,19 +330,36 @@ static int scsi_vpd_inquiry(struct scsi_device *sdev, unsigned char *buffer,
 
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
+		for (unsigned int i = SCSI_VPD_HEADER_SIZE ; i < result ; i++) {
+			if (vpd[i] == page)
+				goto found;
+		}
+
+		return 0;
+	}
+found:
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
index cb019c80763b..6673885565e3 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -102,6 +102,7 @@ struct scsi_vpd {
 
 enum scsi_vpd_parameters {
 	SCSI_VPD_HEADER_SIZE = 4,
+	SCSI_VPD_LIST_SIZE = 36,
 };
 
 struct scsi_device {
-- 
2.42.1

