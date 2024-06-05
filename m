Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97B6DF60;
	Wed,  5 Jun 2024 02:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717554360; cv=none; b=XJE2cUs5pNG45TlJVhMTJPekzB6i12Gl1oYrnA9YuQwSeGwPN6WDG8SlI7Hazl0agcU6TXi+6Ar/jW1MBRNbJg/Do0mLXxAdcuKU1Dq8jIJwgRGHDIiq/k3OFHo1vs+mYZKFoDDgoU8PD871sMKOzNf9yFamGU2BmfpKbxf26aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717554360; c=relaxed/simple;
	bh=t4/UuPcm2KF//0fZsqUvhp8NGB6Z5SyAUZtj00LZHJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k4dylL9eZXawEgiWip3RiKa+DgokoJMFDd335/S4ENh8d9GfHTMj6L03+eF6vWlyTVz8Pt+L5qKCkvzWw2UpZLukBFYMTHlSvGA0/uXKtnlpqKqqSv9YVx+Xtp18P40E0KnH0BLAfHonUS2Mn/sCD5RJqvPQbWzjxQU8qcGY9Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TX9HJgvW; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TX9HJgvW"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4551DwsM028876;
	Wed, 5 Jun 2024 02:25:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc :
 content-transfer-encoding : date : from : in-reply-to : message-id :
 mime-version : references : subject : to; s=corp-2023-11-20;
 bh=+YiiJ/dVbBnker1B+5dQTq9Zxcr9yNQJEMHs9jZf/Xg=;
 b=TX9HJgvWhvBjfQUbzmG/NaTPaEuIUc/z99sN05hYsk+qnTrYgJ0P8zdOwobZeVtlDLcl
 Dxvmw9M+nQB89zNeOjOUgdhImmBS5Mt2YuAl1ne0QsyF7olEa/aSTcuRASs7xJG9ejSr
 xQ5PnT8lUgk67FlFEdlG+msH614sZ/EYWGh+Ovr4n15ohoE8dgZpL3FBkoivCIvlk1cD
 23VBSo/O4aKj79MsCKUSf7G70+zfSUDNoIk/xeH6lB2rf65thKWxUlbJZs4HPp4Cw2/c
 t6GSeVl8FUZDFhOH5KdOlYy9pOhcw+a6NyAsCCTd9zBSeAuGz9h12ebwnw4iKnJ6jDb8 Gg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yjbusr5x2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Jun 2024 02:25:53 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4550UGbg005565;
	Wed, 5 Jun 2024 02:25:52 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ygrmec8m5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Jun 2024 02:25:52 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4552Pqvo022056;
	Wed, 5 Jun 2024 02:25:52 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3ygrmec8kr-1;
	Wed, 05 Jun 2024 02:25:52 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, stable@vger.kernel.org,
        Pierre Tomon <pierretom+12@ik.me>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH v2] scsi: sd: Use READ(16) when reading block zero on large capacity disks
Date: Tue,  4 Jun 2024 22:25:21 -0400
Message-ID: <20240605022521.3960956-1-martin.petersen@oracle.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <50211dcb-dc40-4bb5-8168-8f102f6bfb5c@acm.org>
References: <50211dcb-dc40-4bb5-8168-8f102f6bfb5c@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-04_11,2024-06-04_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 malwarescore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406050017
X-Proofpoint-ORIG-GUID: _NgYNPMaQUXZajdxusIy0HnA9J0IxKCm
X-Proofpoint-GUID: _NgYNPMaQUXZajdxusIy0HnA9J0IxKCm

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
Link: https://lore.kernel.org/r/70dd7ae0-b6b1-48e1-bb59-53b7c7f18274@rowland.harvard.edu
Reported-by: Pierre Tomon <pierretom+12@ik.me>
Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Pierre Tomon <pierretom+12@ik.me>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/sd.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 65cdc8b77e35..22f8841eb5eb 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3572,16 +3572,23 @@ static bool sd_validate_opt_xfer_size(struct scsi_disk *sdkp,
 
 static void sd_read_block_zero(struct scsi_disk *sdkp)
 {
-	unsigned int buf_len = sdkp->device->sector_size;
-	char *buffer, cmd[10] = { };
+	struct scsi_device *sdev = sdkp->device;
+	unsigned int buf_len = sdev->sector_size;
+	u8 *buffer, cmd[16] = { };
 
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

