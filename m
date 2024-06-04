Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CAD313D501;
	Tue,  4 Jun 2024 15:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717515445; cv=none; b=EG1S3Xnk1wwfehh89iQj/LN/Es0aT7r5IfkIF/oiobHXMF9465S+mPWEPz/+pfrwAzXX6Hapyj0nvNnemWM27szym/yEjiO8Pr+SMZ9SpGfZNl1CnuHL9tg1i2x0wk/Ovvhnibx0azTa2sWJ5MxyzdJmkDNbQhOIA/UWJt6FfUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717515445; c=relaxed/simple;
	bh=N2LPjcYKuHsMXsaqcKihQRsMuiZG397H2kNsmn+DhBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RnssLgYM0kP7JgROBlbuG21s1ixCDD32c3Doxz/yQGnb1fqQqF3riDd9ltAgDzmu5njHQIxXUGYihISS9ParxGyBtKGTI+m4K1r7Ie+NYUyS/viVdbF2bzPJ9xTIyOkTa6FgzjklPVF0jqJKl5Qeh5R7UQugDxHbubsppVMyu8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 454BmnD8004599;
	Tue, 4 Jun 2024 14:45:37 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Doracle.com;_h?=
 =?UTF-8?Q?=3Dcc:content-transfer-encoding:date:from:in-reply-to:message-i?=
 =?UTF-8?Q?d:mime-version:references:subject:to;_s=3Dcorp-2023-11-20;_bh?=
 =?UTF-8?Q?=3DkEG3l2bq46yfLz9iShx+a4M5AbefH0DBWx6NBWCS/TA=3D;_b=3DUlAJkmLQ?=
 =?UTF-8?Q?B3tDrZRviAU7ulZFsr3/mQ79E4iz9wCEmNK2J2mynIBrAiQGDkAhknT7ayST_AJ?=
 =?UTF-8?Q?DMSEruI0C41ISGxq/dPOLHGrRc+C6KXhNDpAEW8tmIvym+YBlxSQpQKHFEjR98Z?=
 =?UTF-8?Q?ZqO_2wdLJbfP/5WGfi2veA1uDnLRoNSM0TCP2cCEiL1lJmUy+nkTKGvQpgRb1pC?=
 =?UTF-8?Q?PRhdKySW+_dnX08JnlMxZ/1G6Fsx1kpzA2YQQFPgsDPEF6TEv3M+Pxu2vkL76OS?=
 =?UTF-8?Q?oIOp6GneOhjVADp_pn+9m2BVqDirtIOSbpqR6jR1HokrkfwQWmSuqeQtZwHj3J9?=
 =?UTF-8?Q?wIIlbVpOEEK8TPz0XKAtv_HA=3D=3D_?=
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yfv05d6y0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Jun 2024 14:45:36 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 454EY65g016121;
	Tue, 4 Jun 2024 14:45:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ygrsa7brq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Jun 2024 14:45:36 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 454EjZMc015190;
	Tue, 4 Jun 2024 14:45:35 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3ygrsa7br5-1;
	Tue, 04 Jun 2024 14:45:35 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, stable@vger.kernel.org,
        Pierre Tomon <pierretom+12@ik.me>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] scsi: sd: Use READ(16) when reading block zero on large capacity disks
Date: Tue,  4 Jun 2024 10:45:01 -0400
Message-ID: <20240604144501.3862738-1-martin.petersen@oracle.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <4VrGl13122ztVS@smtp-3-0001.mail.infomaniak.ch>
References: <4VrGl13122ztVS@smtp-3-0001.mail.infomaniak.ch>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-04_09,2024-06-04_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 malwarescore=0 suspectscore=0 phishscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406040118
X-Proofpoint-GUID: EUKi5VmEIlBmXF2scn4Vwh9XajWBdDty
X-Proofpoint-ORIG-GUID: EUKi5VmEIlBmXF2scn4Vwh9XajWBdDty

Commit 321da3dc1f3c ("scsi: sd: usb_storage: uas: Access media prior
to querying device properties") triggered a read to LBA 0 before
attempting to inquire about device characteristics. This was done
because some protocol bridge devices will return generic values until
an attached storage device's media has been accessed.

Pierre Tomon reported that this change caused problems on a large
capacity external drive connected via a bridge device. The bridge in
question does not appear to implement the READ(10) command.

Issue a READ(16) instead of READ(10) when a device has been identified
as preferring 16-byte commands (use_16_for_rw heuristic).

Cc: stable@vger.kernel.org
Fixes: 321da3dc1f3c ("scsi: sd: usb_storage: uas: Access media prior to querying device properties")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=218890
Reported-by: Pierre Tomon <pierretom+12@ik.me>
Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Pierre Tomon <pierretom+12@ik.me>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/sd.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 65cdc8b77e35..6759bd5af58a 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3572,16 +3572,23 @@ static bool sd_validate_opt_xfer_size(struct scsi_disk *sdkp,
 
 static void sd_read_block_zero(struct scsi_disk *sdkp)
 {
-	unsigned int buf_len = sdkp->device->sector_size;
-	char *buffer, cmd[10] = { };
+	struct scsi_device *sdev = sdkp->device;
+	unsigned int buf_len = sdev->sector_size;
+	char *buffer, cmd[16] = { };
 
 	buffer = kmalloc(buf_len, GFP_KERNEL);
 	if (!buffer)
 		return;
 
-	cmd[0] = READ_10;
-	put_unaligned_be32(0, &cmd[2]); /* Logical block address 0 */
-	put_unaligned_be16(1, &cmd[7]);	/* Transfer 1 logical block */
+	if (sdev->use_16_for_rw) {
+		cmd[0] = READ_16;
+		put_unaligned_be64(0, &cmd[2]); /* Logical block address 0 */
+		put_unaligned_be32(1, &cmd[10]);/* Transfer 1 logical block */
+	} else {
+		cmd[0] = READ_10;
+		put_unaligned_be32(0, &cmd[2]); /* Logical block address 0 */
+		put_unaligned_be16(1, &cmd[7]);	/* Transfer 1 logical block */
+	}
 
 	scsi_execute_cmd(sdkp->device, cmd, REQ_OP_DRV_IN, buffer, buf_len,
 			 SD_TIMEOUT, sdkp->max_retries, NULL);
-- 
2.45.1

