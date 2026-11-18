Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794996842;
	b=EIBdbBCzyKb/ERRQ1V5qX6xfiYkc0UQ3EYG5k3hWLbD6cTn9M3IGL1N2+A+J0p4TDVOd
	 WV+qiVqGLrDqzO96WXUBe8dhrT7TfDXkKtwNanTK40nhM1o828stiZ6o/L6j0yySlwpxa
	 dw+oyWvH+99HOoWyAA7milCr0fdWxCMypTTURu3m3ksl8zUnUL2bXMbsDlBUDx03axJg6
	 F7s4XWRaIObtN7IyiiA34FZUJKqtd+DF4Eo9Jz7qc63xuA/PikzB8aFqP/5O26J6TzDAX
	 chfA2hZX9MPF2cP8WN9yO4a2QHnUvhzKb33tyz+UUJGi/nLRo0mxDNrIHJj2kSQXHDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794996842;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=kFQAsS+oG7VocM70ea3QRG0BRfeZovsJ/Z/tJ1SpMEo=;
	b=SA6BLoa5Y/zDC5kl67N17zIawCGEOmD/U0NvK1abOCmq6ldHPm32UhNdw3I4sd9/l+m7
	 fHy+oJjCmKq1d711sTIsapMPX7Oaer5hUKJKCkRn0yr4w62fD2aW/KLx0hzuRlb8fnVbG
	 6sBMwd8IgTu4l3sDNWSSmoAQH4Fdo0SxpYgEbEZLPo4z0PC7y2VOoVJ0po+LjL5NvqGu8
	 f9A+OmfDA5FoNsDAYZNyCqEJmBhVmK+S3nLGYAdym0MemuxiamsbR8D047BpMqzVTL2JF
	 t2S7J5c8GXta7U+7yb9+9Kr5QU3Z0m4gFSyazFEhpF7GlYO3wD0htcWS/rRy8+pM99w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=AFrguAWZ;
	arc=none smtp.remote-ip=209.85.222.100
Received: from mail-ua1-f100.google.com (mail-ua1-f100.google.com [209.85.222.100])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED16606A32C
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:14:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AED16606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=AFrguAWZ
Received: by mail-ua1-f100.google.com with SMTP id a1e0cc1a2514c-9905d61449cso207483241.0
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:14:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794996840; x=1795601640;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kFQAsS+oG7VocM70ea3QRG0BRfeZovsJ/Z/tJ1SpMEo=;
        b=U/KVWSPICIOXAmuzV4h9As6/Vbecpofi9qzltsEoGROls5qdqGZbrtxl9MtDlzzs0v
         zOf+4rpJL/ZTVSaruFnheIUDv/vONG9aQgWGuU8HcL8BhjUSRPK2cM0DlwGEZsc7u7VR
         g17wFzUxPFNSF+0h2gN5XtTK3wkJdz7CbvsSQp4wiD/E7qr74Kdo0AbzgQTZS1MVru1a
         KEvmb3uZZdvNsczOYukyF7slYH1iUUP9M+MX4z7ZKSKXdzmfOyQ867r15bgO0e2iSVs7
         lwl34wy0SCt/9LaNXWEIZT6ORsFFxGoABOP7jfLoPjFNvPSWU5qfpYe8UVdpzhe8N0wF
         D/aA==
X-Gm-Message-State: APuU4Z/VqpAP4sUb0pYdyPFj9FZOAOOk0DAAe4I+naiQ9tDzWb3DmU62
	ZQibRNTur50gy3IIG2H1ux6UYV04TZb/YsYpN3QAiy1doxLZQx0aoSdV09x+Rx96s3VQ0d9KyB7
	l0nczwn6vn+WaHUzwu0qRVWRIlY1W7koom6lN7fyI9RcrRWtf5da/FSob4XcNAvpO/XiETPlqwb
	VriNVtNvnwLJo0xnQo5QZ6AIOVcBUaioLbtHikooeZ5RmM+LDizE93QjnsznlrX4xmQnr0xZvKc
	pBziotTjtGSXaL4ViRK+qvh34sHC2jKU4E=
X-Gm-Gg: AYBFou07fah5RlglZQPqMpxd1KxwucaDHOLNDafuDWwGv4+AaO1YsvMbLh7++alYMhc
	5dusVyr3iZGWs4+CI+8xRs6kM82BkQPoF1ozH/B9bvXZIbAyYR4Zsn2aTAcQB+cJnnq5py5imVh
	cpiYnFxw/z/DNTbpckMiHSfRjbl1pAQ5ejbSK5lI6WsY2SIlVFG3eW6xti9PNxpHHuggj4RRl+v
	CtF0PtHKObUzrgOcyfFxEgYW5XV4Cqc2bpSWxFGBKb6ZONWnhrzcJ4NxWEPS/bv1SuFyJ53tDY2
	31qzY42HwSFhVrIJQGPLi6RJpngNyWTHdHy28F3+i3mvnqKeVdaKGvxJTfFhfPE/ajfOFQ2t6du
	IZSW/+3+bNhCmd0mLmiV5mGQUuhkKeAjtsca5/JfxMdw+Pvwq/kRvjteuHyiDWp7u6J/kowP7aC
	iTmZ9doo6RMoyMoMlJBMQqMhpgOhBCZp605xGYjAJeBLlfhZLLO0SU+Q==
X-Received: by 2002:a05:6102:f9d:b0:7a6:d11b:16ea with SMTP id ada2fe7eead31-7d6ba3935c1mr630540137.6.1794996840383;
        Wed, 18 Nov 2026 02:14:00 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id a1e0cc1a2514c-99e4a52fedbsm232792241.8.2026.11.18.02.14.00
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:14:00 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3ad30487d55so1109625a91.2
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:14:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794996839; x=1795601639; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=kFQAsS+oG7VocM70ea3QRG0BRfeZovsJ/Z/tJ1SpMEo=;
        b=AFrguAWZISMUYfbnaZL6ntHZ57Ji0LMrccMbkvFI+UmJj+gL26Xz5l4u08ccIv8/7+
         iCtPg1nrXM+edP8lVlsoJ+Ah9gew+9eE7C5b+GUNuIV0I2QLgb/sp+koWIlQn9ZRN6r7
         JCn5rsMtS9jSJbM9E7cARSi2RgNYfyTZvY48s=
X-Received: by 2002:a17:90b:52:b0:3b3:acea:46b6 with SMTP id 98e67ed59e1d1-3b3d07c3f17mr2168937a91.58.1794996835118;
        Wed, 18 Nov 2026 02:13:55 -0800 (PST)
X-Received: by 2002:a17:90b:52:b0:3b3:acea:46b6 with SMTP id 98e67ed59e1d1-3b3d07c3f17mr2168903a91.58.1794996834575;
        Wed, 18 Nov 2026 02:13:54 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3ac6016c3sm8740707a91.15.2026.11.18.02.13.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:13:54 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	thenzl@redhat.com,
	mgandhi@redhat.com,
	loberman@redhat.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v2 31/37] scsi: mpt3sas: Restrict ioc_dump debugfs and replace raw ioc dump with text
Date: Wed, 18 Nov 2026 01:56:40 -0800
Message-Id: <1794995806-5835-32-git-send-email-shivasharan.srikanteshwara@broadcom.com>
X-Mailer: git-send-email 2.4.3
In-Reply-To: <1794995806-5835-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1794995806-5835-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

