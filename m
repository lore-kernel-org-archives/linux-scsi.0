Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793926792;
	b=QgffRb9SeiK8g90txNshDDW7nbdQ1sasZVCQucL6CBQtgFUeusjL3kx8dRp0Obu8Fw3T
	 bJppAygHXfqlW0i8noStqOdOZVDyAVWdXN14hlrmvc+WXrPIRVVq1Onba63PnDFhz5Opb
	 lpI1LERF/GNKGZA3goTa2rWQ7LzfGaS9XT1BykbLYlT2zczu0H3xJWxK8t90SbqWJVpdc
	 FnTD6NUaCt9C8TByz1p3XC9Lg5OWmhR80DdDUgklihLFwpmcmryPt/PxMmBhIfBpZI3AL
	 zsmtP7AdlHfhLiVvvY2SV27yIgiLMCLJKpT971rcmj1bEY5Ax5mOFIwU9eWEyDnTHeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793926792;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=kFQAsS+oG7VocM70ea3QRG0BRfeZovsJ/Z/tJ1SpMEo=;
	b=dB21vufLAej8QPZ3x7r5z9VT5un8/eMmGSJC8U1jO11mlF48AbUe4w4NdBdXjLIXIv9v
	 wuHvR3oiU+3iLYGN6uX9zc+odRYIhOQSKXeP1R22erqd0peSxvq1qpVTliryiLs3siYgM
	 Yu7ts/hZcrMJDMrbdvbpJ/5O4IM2XmEXe9urOVg04PlX0Sygp8EppnTj+hNrd8Il7lTkg
	 pZJRZZxv8wFsjXCPu1jGXTertZTt8f6gkTbUUrV9NQp28lJoaQ94EPHWCx+YlOrzbDo9z
	 rfFwLp6zelHrdUH57W8AffSu8n5YL6WlOgj5isCkpUVMppLXZqmMkBAQSLHucjlUsHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=eMIo5SCy;
	arc=none smtp.remote-ip=209.85.216.100
Received: from mail-pj1-f100.google.com (mail-pj1-f100.google.com [209.85.216.100])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31CA606A31B
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 00:59:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A31CA606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=eMIo5SCy
Received: by mail-pj1-f100.google.com with SMTP id 98e67ed59e1d1-3adac5c10e3so78186a91.0
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:59:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793926791; x=1794531591;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kFQAsS+oG7VocM70ea3QRG0BRfeZovsJ/Z/tJ1SpMEo=;
        b=Ehb04YkXXSeUSyZKrsLZBznrzu1UJPf29RtBYfEKyoTI9dg5G4pne8hfV8JfknPu06
         402uYVmkmsutj/+S04iTPIsuRZizxp3vU/nR4Vk7PCn36S/vKhzGpBkcEakb3+a1ezcA
         0TMq1z9T90OM+JMJY7TYuEiIxpvMVPjDimGTINo5DtlB+JiYaa/+EHHes4vjwfZyhG81
         BXms7NyHwUQ/6+z/ualst0tuiGa9oWJskPnoP96Iv07WNo7kEsXZpFReI6BN8uZCtbDB
         +s2BhD5VHeiNZt1QfRW4YQf2Db0HMPm18+cnZBC2Tui3Ez6CXK6t1gemPkg8kTf6vHo3
         7TYw==
X-Gm-Message-State: APuU4Z+XVHwttDY4HP8OrsmklG+pDrhCU5El01JtKtJxx2a7p8ID+vCZ
	pWPI3kFlsZomEuRahmQey6GauWh3/7ggkmgFkualGwA312+fm4toFtyGxMlkhnmxQuX0x5GyMlQ
	jNOU7kdwqhlpPnhEOFGeQsyz0cDRsHww+vFJkaBfWh8pfsvt2Y93TkZVMg+kOr9CtHnxrjFLE8S
	A+PcwEwkpPV5YY2A13gPIpBgjIAYEqfGad3E5uv5DM6ljkAaDg4VzT2PU9iRypnvijXb+EpuHk/
	0hCPz9W0MEEuXZDVKYkrSDIMR6BS6F2DWI=
X-Gm-Gg: AYBFou1NX+ZLqfkef4YpRbOnjDsTBrSALFZbpSfHS3Bw2NaWlsrOOB5VBVlbPtzOPLO
	lO1nUxW5TUxfQ+R0C8TcuhG3mu9Nsfnpvw3TN7xrNYarCTdna677adZngWmtgRQbSuf3Y6SGhrP
	FK6U8MolCyEhg8a9aS3s0/PieJl8uciQiC63UnzqfauhXnqNQa0GcB9zw97jJZxiVNXbdw9iLuh
	OEGS/KMQdNH/VQv9zgfiVlTDFkvPPQQWrqqvu0S5byc1E1VjyZSjtxZE8G4v9N3a4hR2EVR1Pd8
	EAwpdGDozxeapbSWQpBoaPAkYjy9+IjOz/sC4+8AIUQV7GSVlZYPXNBzMMWE4gf7O3oI7EomZre
	oc6M83f2swp33d5SahiQCBenIyCdfV4oFeydJh7ixM+GXDbvYa7D79n5CMtMwv8VHt6LBkga+Fv
	UZVIpG/HUy6pQveZGVV+oZ5ReaduppasGFCf9UT5g887yx0Jl4l6+QDQ==
X-Received: by 2002:a17:90b:39ab:b0:3ae:a531:4e73 with SMTP id 98e67ed59e1d1-3b0db6210b3mr759943a91.7.1793926791100;
        Thu, 05 Nov 2026 16:59:51 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b0d7ddf641sm693989a91.5.2026.11.05.16.59.50
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:59:51 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2e987ec84afso1244025ad.3
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:59:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793926789; x=1794531589; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=kFQAsS+oG7VocM70ea3QRG0BRfeZovsJ/Z/tJ1SpMEo=;
        b=eMIo5SCypPy79PhlUetmkSsTelcavde85FL5UNPHx0RHOkNHVdVlB/jHfUkSjo37Qg
         6ud5eTPGeXdjcZoAs801rxeeq0c9EtXxmz982RIRhotC0JyJ9keVMcTfNY9udtR0wHVZ
         AWUuEvkADhgoAW6wu0XuPx+gQ5F0sHzws73PU=
X-Received: by 2002:a17:902:ea0a:b0:2ed:2494:df85 with SMTP id d9443c01a7336-2ed40e2b5f4mr14574845ad.52.1793926789422;
        Thu, 05 Nov 2026 16:59:49 -0800 (PST)
X-Received: by 2002:a17:902:ea0a:b0:2ed:2494:df85 with SMTP id d9443c01a7336-2ed40e2b5f4mr14574595ad.52.1793926788900;
        Thu, 05 Nov 2026 16:59:48 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed47d7b8cfsm450745ad.57.2026.11.05.16.59.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:59:48 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 31/37] scsi: mpt3sas: Restrict ioc_dump debugfs and replace raw ioc dump with text
Date: Thu,  5 Nov 2026 16:42:46 -0800
Message-Id: <1793925772-1303-32-git-send-email-shivasharan.srikanteshwara@broadcom.com>
X-Mailer: git-send-email 2.4.3
In-Reply-To: <1793925772-1303-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1793925772-1303-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

The ioc_dump debugfs file previously exposed raw MPT3SAS_ADAPTER bytes,
leaking kernel addresses, and was world-readable.

Create the file with mode 0400 instead of 0444, replace the raw dump
with a small human-readable text summary of key adapter properties, and
fix the memory leak in the release path.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_debugfs.c | 49 +++++++++++++++++++++++---
 1 file changed, 45 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_debugfs.c b/drivers/scsi/mpt3sas/mpt3sas_debugfs.c
index 183391f6b8d1..432e120ac81d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_debugfs.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_debugfs.c
@@ -49,22 +49,62 @@ _debugfs_iocdump_read(struct file *filp, char __user *ubuf, size_t cnt,
 	return simple_read_from_buffer(ubuf, cnt, ppos, debug->buf, debug->len);
 }
 
+/* Buffer size for the text dump */
+#define MPT3SAS_IOCDUMP_BUF_SZ 1024
+
 /*
- * _debugfs_iocdump_open :	open the ioc_dump debugfs attribute file
+ * _debugfs_iocdump_open: open the ioc_dump debugfs attribute file.
+ * Populates the debugfs buffer with a summary of key adapter properties.
  */
 static int
 _debugfs_iocdump_open(struct inode *inode, struct file *file)
 {
 	struct MPT3SAS_ADAPTER *ioc = inode->i_private;
 	struct mpt3sas_debugfs_buffer *debug;
+	char *buf;
+	size_t len = 0;
 
 	debug = kzalloc_obj(struct mpt3sas_debugfs_buffer);
 	if (!debug)
 		return -ENOMEM;
 
-	debug->buf = (void *)ioc;
-	debug->len = sizeof(struct MPT3SAS_ADAPTER);
+	buf = kzalloc(MPT3SAS_IOCDUMP_BUF_SZ, GFP_KERNEL);
+	if (!buf) {
+		kfree(debug);
+		return -ENOMEM;
+	}
+
+	len += scnprintf(buf + len, MPT3SAS_IOCDUMP_BUF_SZ - len,
+	    "name:           %s\n", ioc->name);
+	len += scnprintf(buf + len, MPT3SAS_IOCDUMP_BUF_SZ - len,
+	    "fw_version:     %02d.%02d.%02d.%02d\n",
+	    (ioc->facts.FWVersion.Word & 0xFF000000) >> 24,
+	    (ioc->facts.FWVersion.Word & 0x00FF0000) >> 16,
+	    (ioc->facts.FWVersion.Word & 0x0000FF00) >> 8,
+	    ioc->facts.FWVersion.Word & 0x000000FF);
+	len += scnprintf(buf + len, MPT3SAS_IOCDUMP_BUF_SZ - len,
+	    "request_sz:     %d\n", ioc->request_sz);
+	len += scnprintf(buf + len, MPT3SAS_IOCDUMP_BUF_SZ - len,
+	    "reply_sz:       %d\n", ioc->reply_sz);
+	len += scnprintf(buf + len, MPT3SAS_IOCDUMP_BUF_SZ - len,
+	    "chain_segment_sz: %d\n", ioc->chain_segment_sz);
+	len += scnprintf(buf + len, MPT3SAS_IOCDUMP_BUF_SZ - len,
+	    "hba_queue_depth: %d\n", ioc->hba_queue_depth);
+	len += scnprintf(buf + len, MPT3SAS_IOCDUMP_BUF_SZ - len,
+	    "scsiio_depth:   %d\n", ioc->scsiio_depth);
+	len += scnprintf(buf + len, MPT3SAS_IOCDUMP_BUF_SZ - len,
+	    "max_dev_handle: %d\n", ioc->facts.MaxDevHandle);
+	len += scnprintf(buf + len, MPT3SAS_IOCDUMP_BUF_SZ - len,
+	    "shost_recovery: %d\n", ioc->shost_recovery);
+	len += scnprintf(buf + len, MPT3SAS_IOCDUMP_BUF_SZ - len,
+	    "pci_error_recovery: %d\n", ioc->pci_error_recovery);
+	len += scnprintf(buf + len, MPT3SAS_IOCDUMP_BUF_SZ - len,
+	    "remove_host:    %d\n", ioc->remove_host);
+
+	debug->buf = buf;
+	debug->len = len;
 	file->private_data = debug;
+
 	return 0;
 }
 
@@ -82,6 +122,7 @@ _debugfs_iocdump_release(struct inode *inode, struct file *file)
 		return 0;
 
 	file->private_data = NULL;
+	kfree(debug->buf);
 	kfree(debug);
 	return 0;
 }
@@ -132,7 +173,7 @@ mpt3sas_setup_debugfs(struct MPT3SAS_ADAPTER *ioc)
 	}
 
 	snprintf(name, sizeof(name), "ioc_dump");
-	ioc->ioc_dump =	debugfs_create_file(name, 0444,
+	ioc->ioc_dump =	debugfs_create_file(name, 0400,
 	    ioc->debugfs_root, ioc, &mpt3sas_debugfs_iocdump_fops);
 	if (!ioc->ioc_dump) {
 		dev_err(&ioc->pdev->dev,
-- 
2.53.0

