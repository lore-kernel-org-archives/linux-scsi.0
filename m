Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8141DFE3;
	Tue, 13 Feb 2024 14:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707834800; cv=none; b=OX5hzEYQZqgmI+HLRGv9xsLBALP7oI9w4Rq1kGapYQ1IIBdNzSy895PNSfebZMauJz8x8wADfNeRXTEh+Y1MFVQrMyd6qO6Z/e0TtNxA+KPteWktsVbYyfhctlNRfF5OaW7ofEBC3MTcx6qJpzM+PABlkNQbTh55RvdWYqjEF2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707834800; c=relaxed/simple;
	bh=xBIYg43+Vy06LaQwzpL5eJyJ7exe9LOWLiuZ7iNlXZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=agQYPwvPksitSSrhtfWu/FExC6kiVJx29jnB519GjLWGFWjHBbhXOXu3VKJ0fcXNO5Wt7ZtjhYa4NBC8ubqQOBaLNOkbpDLKsfH+562ERF/D+zkahfmznYDQDt2q2UkpozGe654oONDwfvZmjmE75+Ldgu+TioSE6CN1oSNXWDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OLAbKPnD; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OLAbKPnD"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41DDojE0014163;
	Tue, 13 Feb 2024 14:33:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2023-11-20; bh=RWCCo/GkrKf2x4jMdXGak7qX7g7APn1oHCzI7veQcRE=;
 b=OLAbKPnD37c6mU5JIOR98wSCU6CTu0mlys9yPETz1Z0TgaryeL1H30PBGkGsESrcyDGs
 I5o7jScdyB9W4gJRC2KQmXYqLrsOtkMYL+t4FWFuHVgieEPzsv5FMv+NWaTxkTQgUgKT
 CJ6woNiDiZpyTaYg6qwSDO1xsl6y1DQ67PVmLi0g935itQb8pLLXcKh7i8DlaKUoO7sk
 /o7uucO/xysVjvLP4fnwAhr9whnFU+5nqwhY/KhXNEKnD2nUOlPNgYmuXqV/COYsCBge
 Xj7KfVDIs6a1odgbwfpgnRAx4QPVaLRVuepGQ/8/bwTQu/b/u4/GJfUOjnXfFXuPZRLp 7w== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w87nxggj5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Feb 2024 14:33:13 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41DDjKjD015098;
	Tue, 13 Feb 2024 14:33:12 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w5yk7dwn6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Feb 2024 14:33:12 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 41DEXCgg029359;
	Tue, 13 Feb 2024 14:33:12 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3w5yk7dwm3-1;
	Tue, 13 Feb 2024 14:33:12 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
Cc: belegdol@gmail.com, "Martin K. Petersen" <martin.petersen@oracle.com>,
        stable@vger.kernel.org, Tasos Sahanidis <tasos@tasossah.com>
Subject: [PATCH] scsi: sd: usb_storage: uas: Access media prior to querying device properties
Date: Tue, 13 Feb 2024 09:33:06 -0500
Message-ID: <20240213143306.2194237-1-martin.petersen@oracle.com>
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
 definitions=2024-02-13_08,2024-02-12_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 phishscore=0 adultscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402130115
X-Proofpoint-GUID: ob5vS-P4vZ8CmFwp3t-Bj23xpNkbo7GK
X-Proofpoint-ORIG-GUID: ob5vS-P4vZ8CmFwp3t-Bj23xpNkbo7GK

It has been observed that some USB/UAS devices return generic
properties hardcoded in firmware for mode pages and vital product data
for a period of time after a device has been discovered. The reported
properties are either garbage or they do not accurately reflect the
properties of the physical storage device attached in the case of a
bridge.

Prior to commit 1e029397d12f ("scsi: sd: Reorganize DIF/DIX code to
avoid calling revalidate twice") we would call revalidate several
times during device discovery. As a result, incorrect values would
eventually get replaced with ones accurately describing the attached
storage. When we did away with the redundant revalidate pass, several
cases were reported where devices reported nonsensical values or would
end up in write-protected state.

An initial attempt at addressing this issue involved introducing a
delayed second revalidate invocation. However, this approach still
left some devices reporting incorrect characteristics.

Tasos Sahanidis debugged the problem further and identified that
introducing a READ operation prior to MODE SENSE fixed the problem and
that it wasn't a timing issue. Issuing a READ appears to cause the
devices to update their SCSI pages to reflect the actual properties of
the storage media. Device properties like vendor, model, and storage
capacity appear to be correctly reported from the get-go. It is
unclear why these device defer populating the remaining
characteristics.

Match the behavior of a well known commercial operating system and
trigger a READ operation prior to querying device characteristics to
force the device to populate mode pages and VPDs.

The additional READ is triggered by a flag set in the USB storage and
UAS drivers. We avoid issuing the READ for other transport classes
since some storage devices identify Linux through our particular
discovery command sequence.

Cc: <stable@vger.kernel.org>
Fixes: 1e029397d12f ("scsi: sd: Reorganize DIF/DIX code to avoid calling revalidate twice")
Reported-by: Tasos Sahanidis <tasos@tasossah.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/sd.c              | 27 ++++++++++++++++++++++++++-
 drivers/usb/storage/scsiglue.c |  7 +++++++
 drivers/usb/storage/uas.c      |  7 +++++++
 include/scsi/scsi_device.h     |  1 +
 4 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 530918cbfce2..c284628f702c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3405,6 +3405,24 @@ static bool sd_validate_opt_xfer_size(struct scsi_disk *sdkp,
 	return true;
 }
 
+static void sd_read_block_zero(struct scsi_disk *sdkp)
+{
+	unsigned int buf_len = sdkp->device->sector_size;
+	char *buffer, cmd[10] = { };
+
+	buffer = kmalloc(buf_len, GFP_KERNEL);
+	if (!buffer)
+		return;
+
+	cmd[0] = READ_10;
+	put_unaligned_be32(0, &cmd[2]); /* Logical block address 0 */
+	put_unaligned_be16(1, &cmd[7]);	/* Transfer 1 logical block */
+
+	scsi_execute_cmd(sdkp->device, cmd, REQ_OP_DRV_IN, buffer, buf_len,
+			 SD_TIMEOUT, sdkp->max_retries, NULL);
+	kfree(buffer);
+}
+
 /**
  *	sd_revalidate_disk - called the first time a new disk is seen,
  *	performs disk spin up, read_capacity, etc.
@@ -3444,7 +3462,14 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	 */
 	if (sdkp->media_present) {
 		sd_read_capacity(sdkp, buffer);
-
+		/*
+		 * Some USB/UAS devices return generic values for mode pages
+		 * and VPDs until the media has been accessed. Trigger a READ
+		 * operation to force the device to populate mode pages and
+		 * VPDs.
+		 */
+		if (sdp->read_before_ms)
+			sd_read_block_zero(sdkp);
 		/*
 		 * set the default to rotational.  All non-rotational devices
 		 * support the block characteristics VPD page, which will
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index c54e9805da53..12cf9940e5b6 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -179,6 +179,13 @@ static int slave_configure(struct scsi_device *sdev)
 		 */
 		sdev->use_192_bytes_for_3f = 1;
 
+		/*
+		 * Some devices report generic values until the media has been
+		 * accessed. Force a READ(10) prior to querying device
+		 * characteristics.
+		 */
+		sdev->read_before_ms = 1;
+
 		/*
 		 * Some devices don't like MODE SENSE with page=0x3f,
 		 * which is the command used for checking if a device
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 696bb0b23599..299a6767b7b3 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -878,6 +878,13 @@ static int uas_slave_configure(struct scsi_device *sdev)
 	if (devinfo->flags & US_FL_CAPACITY_HEURISTICS)
 		sdev->guess_capacity = 1;
 
+	/*
+	 * Some devices report generic values until the media has been
+	 * accessed. Force a READ(10) prior to querying device
+	 * characteristics.
+	 */
+	sdev->read_before_ms = 1;
+
 	/*
 	 * Some devices don't like MODE SENSE with page=0x3f,
 	 * which is the command used for checking if a device
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 10480eb582b2..cb019c80763b 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -202,6 +202,7 @@ struct scsi_device {
 	unsigned use_10_for_rw:1; /* first try 10-byte read / write */
 	unsigned use_10_for_ms:1; /* first try 10-byte mode sense/select */
 	unsigned set_dbd_for_ms:1; /* Set "DBD" field in mode sense */
+	unsigned read_before_ms:1;   	/* perform a READ before MODE SENSE */
 	unsigned no_report_opcodes:1;	/* no REPORT SUPPORTED OPERATION CODES */
 	unsigned no_write_same:1;	/* no WRITE SAME command */
 	unsigned use_16_for_rw:1; /* Use read/write(16) over read/write(10) */
-- 
2.42.1

