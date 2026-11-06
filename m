Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.217.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793926701;
	b=L/a7GeAYpJZaABWRNdRbgpP9G+jszmMYn7NTKVP/qnzmYTLcuFGyCp0ehaOpzTICUZSJ
	 tFRAh0EUp0J4KXFTsiTtv94pD0VVdsCCKnbGfihECPx5kwEwxs562yGaU4F10rmHKfybm
	 l4K/S6ONVZ2V656RFZwBGFNwx7wQgY1QcoSVmOwMsrOl9dLmmoYwK37Kp0Q9BCMUSwVtp
	 ydlf+SClC8sbBddgf0rYtItUIx1RI0PVqG9LwTiZOB5waWQwO4tWHJIP1DWzPoaczW12r
	 K7satlJIJim6HyK5750P9PqoqJDsNldlRZ4lqJPvUSy2D8ApOKI9WaR2b/p3VcqzRAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793926701;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=DE9Vsv0lPiwIH02KdMn0cDDibHnMwQrKBhbzvtTkLrM=;
	b=t57lsXlORIRL8BDpsB/ZLquZG4X6yHiWa7cP/uGJkox5Wvb71H2XKe+zKbqaTzFSH3Pc
	 GFL3wMLRnY1rvJ/6fH5j5XhJRVPjQS7+Hn/Q3IxwVLkJZHLYy55E32UJru/QC19wR1YTk
	 7BVcIjt7UarZq3RuSsIntuCWKbKBNj19GBt6khsX1Cr2vDIXOVU+pdascBSdqoCiR69tS
	 JIayXuH81VUusVVQatCoebJUUo+7agiq8Le194Mk2LUfysyMJsy21jU12VM1jTTvpuZuI
	 Z95JfHiwA0KQ0698kWMhclaboZvuYAlXB7zOt1B9Pb1yuZDLLWP8aPCyypPGI1v+jcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=ENYh42vJ;
	arc=none smtp.remote-ip=209.85.217.99
Received: from mail-vs1-f99.google.com (mail-vs1-f99.google.com [209.85.217.99])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D81C606A32E
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 00:58:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D81C606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=ENYh42vJ
Received: by mail-vs1-f99.google.com with SMTP id ada2fe7eead31-7cc603a168fso46727137.3
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:58:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793926700; x=1794531500;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DE9Vsv0lPiwIH02KdMn0cDDibHnMwQrKBhbzvtTkLrM=;
        b=aHMU4/ROi13CVKFqmA/URkeE5wYwYYPCh6Glz1MxpH1v0WG96b753p7yhzePBAohrZ
         1im2WbrkoajR/NT0UDUSneTvEetwfnpEetLNIfwwJ7wbUfYEG3tgyYky//UleQClWMkE
         kRAjVX4ldD9ZrxOfQmUkR8vVPud1WGI/cFpz53JcPH+zWgjXfgYigp5IMI5drjOH73j6
         DTUkFnQFtT4ZYJ6SUPMY1q5tAkEa52xcDSHEE98X+U+ThQe0QC/+lwmA/qU+jZeYXuUo
         6z1skmyJDmONA5mfJYb2hjaJaNps6zZo60jgOR71kwP3k4grE/ZIWI62gMCYrvqeilHd
         VCng==
X-Gm-Message-State: APuU4Z9Jc0e1Xu9KkYEmQONOizw71+qRR+u5/s1clSqbzUaP1tX9ZrwK
	rmpmikooxxHx5u/Qo4ZI1Tu9rqK/WEPs4RsIyiFz7nRwbZtQJY7FOe1AGibjmekUVNYsydo+ycs
	Uk7MD2YlhLcqs9ClKK+DLA2tcrzYd/xzOSIo6lzWdh8v5zAyN2xmyXXIAplm32yLTvzPurFEEmq
	SSMKCe9E98iYdHNd526TWnsSNmlT9A/f6OxTfFmebthpGLwHckh1FgCXA76zgh5JLeRn+nzDOzz
	kTkkksG1tYY9IrPgt7nbO9SQYCr82EDZQ0=
X-Gm-Gg: AYBFou0gHKq7xjUW+PH+Ysbx/kzSyQxLIhvSMsUTUZ2zSdN2FIDuAkjiPYik02K4P/k
	NrtUT5qXP9Jd/l6CVm6ae7lD3Yc6c2fpAHTyOwVTiMjQEARUCiljMGzwOEt63uQaq+IUXNid5A4
	NA0vqx0hHZnw/i66wrjoRlFe8NBIWgXfYy0lxcm/6FA8inE6SNOvpr0R4quvWCKGKhZnrwOJTaY
	BykXR3h155TPhQ54lcPFzj1Mxo/pXembzZLDNCVZh6+xuxlSJ9pA7kJWF3pIxw4b0lBv0vabtSt
	wKPCUYbkHVaHqjC/K/O1D/vwk606v8wkiPyRWQhmAQtiMz9TFOL8lvTFPrmnOr2q3bXJDSEiUkN
	NoXYP/90mxIHgrHxQjBWsXtJ1OOM71Bys/j1jsuthfxKdu064SR72YG55OiU6jxCpiKYhLElIjU
	LUzwVGUXmLo+jeKAeqFJkcyrxk4VqV9PXpDi/xy7ZvDm/rQt8fW8d9OQ==
X-Received: by 2002:a05:6102:4456:b0:7cc:776:6c41 with SMTP id ada2fe7eead31-7d2a15ce76dmr622287137.22.1793926700057;
        Thu, 05 Nov 2026 16:58:20 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id a1e0cc1a2514c-99ba631bf76sm62758241.11.2026.11.05.16.58.19
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:58:20 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2ea71803effso1142475ad.3
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:58:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793926699; x=1794531499; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=DE9Vsv0lPiwIH02KdMn0cDDibHnMwQrKBhbzvtTkLrM=;
        b=ENYh42vJ1KqQJu0q8Hxmi1Q5PkgN2u0S4VQZ1h+sWLqWe8Ds8I4A1fAJruD9PGbUWn
         vVgYY7JDObhbyKtkX8ijiKVIOT8FZAbCyuqx3M8Ts5KsHDQ9Y0PGEQESy/GJgHyAPFLX
         2Ytj+0MqKNwvOof4kb6OBiI7hrTdzd5I/X6Rw=
X-Received: by 2002:a17:902:d503:b0:2ed:a66:cc7c with SMTP id d9443c01a7336-2ed40c02f7cmr15155045ad.40.1793926698785;
        Thu, 05 Nov 2026 16:58:18 -0800 (PST)
X-Received: by 2002:a17:902:d503:b0:2ed:a66:cc7c with SMTP id d9443c01a7336-2ed40c02f7cmr15154825ad.40.1793926698252;
        Thu, 05 Nov 2026 16:58:18 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed47d7b8cfsm450745ad.57.2026.11.05.16.58.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:58:16 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 04/37] scsi: mpt3sas: Fix locking and bounds checks on host_trace_buffer sysfs files
Date: Thu,  5 Nov 2026 16:42:19 -0800
Message-Id: <1793925772-1303-5-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Serialize the host_trace_buffer* sysfs handlers on ctl_cmds.mutex and
clamp the reported/used buffer size to the actual allocation size.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c          | 50 +++++++++++++++++----
 drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c |  2 +
 2 files changed, 43 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index f254e9984da8..d696cb12047c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -1791,6 +1791,10 @@ _ctl_diag_register_2(struct MPT3SAS_ADAPTER *ioc,
 	if (request_data == NULL) {
 		ioc->diag_buffer_sz[buffer_type] = 0;
 		ioc->diag_buffer_dma[buffer_type] = 0;
+		if (buffer_type == MPI2_DIAG_BUF_TYPE_TRACE) {
+			ioc->ring_buffer_sz = 0;
+			ioc->ring_buffer_offset = 0;
+		}
 		request_data = dma_alloc_coherent(&ioc->pdev->dev,
 				request_data_sz, &request_data_dma, GFP_KERNEL);
 		if (request_data == NULL) {
@@ -3628,9 +3632,12 @@ host_trace_buffer_size_show(struct device *cdev,
 	u32 size = 0;
 	struct DIAG_BUFFER_START *request_data;
 
+	mutex_lock(&ioc->ctl_cmds.mutex);
+
 	if (!ioc->diag_buffer[MPI2_DIAG_BUF_TYPE_TRACE]) {
 		ioc_err(ioc, "%s: host_trace_buffer is not registered\n",
 			__func__);
+		mutex_unlock(&ioc->ctl_cmds.mutex);
 		return 0;
 	}
 
@@ -3638,6 +3645,7 @@ host_trace_buffer_size_show(struct device *cdev,
 	    MPT3_DIAG_BUFFER_IS_REGISTERED) == 0) {
 		ioc_err(ioc, "%s: host_trace_buffer is not registered\n",
 			__func__);
+		mutex_unlock(&ioc->ctl_cmds.mutex);
 		return 0;
 	}
 
@@ -3649,7 +3657,11 @@ host_trace_buffer_size_show(struct device *cdev,
 	    le32_to_cpu(request_data->Reserved3) == 0x4742444c)
 		size = le32_to_cpu(request_data->Size);
 
+	/* Never trust firmware size beyond what was actually allocated */
+	size = min_t(u32, size,
+		     ioc->diag_buffer_sz[MPI2_DIAG_BUF_TYPE_TRACE]);
 	ioc->ring_buffer_sz = size;
+	mutex_unlock(&ioc->ctl_cmds.mutex);
 	return snprintf(buf, PAGE_SIZE, "%d\n", size);
 }
 static DEVICE_ATTR_RO(host_trace_buffer_size);
@@ -3674,10 +3686,15 @@ host_trace_buffer_show(struct device *cdev, struct device_attribute *attr,
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
 	void *request_data;
 	u32 size;
+	u32 offset;
+	u32 buffer_sz;
+
+	mutex_lock(&ioc->ctl_cmds.mutex);
 
 	if (!ioc->diag_buffer[MPI2_DIAG_BUF_TYPE_TRACE]) {
 		ioc_err(ioc, "%s: host_trace_buffer is not registered\n",
 			__func__);
+		mutex_unlock(&ioc->ctl_cmds.mutex);
 		return 0;
 	}
 
@@ -3685,16 +3702,24 @@ host_trace_buffer_show(struct device *cdev, struct device_attribute *attr,
 	    MPT3_DIAG_BUFFER_IS_REGISTERED) == 0) {
 		ioc_err(ioc, "%s: host_trace_buffer is not registered\n",
 			__func__);
+		mutex_unlock(&ioc->ctl_cmds.mutex);
 		return 0;
 	}
 
-	if (ioc->ring_buffer_offset > ioc->ring_buffer_sz)
+	offset = ioc->ring_buffer_offset;
+	/* Never read beyond the actual allocated diag buffer */
+	buffer_sz = min_t(u32, ioc->ring_buffer_sz,
+			  ioc->diag_buffer_sz[MPI2_DIAG_BUF_TYPE_TRACE]);
+	if (offset > buffer_sz) {
+		mutex_unlock(&ioc->ctl_cmds.mutex);
 		return 0;
+	}
 
-	size = ioc->ring_buffer_sz - ioc->ring_buffer_offset;
+	size = buffer_sz - offset;
 	size = (size >= PAGE_SIZE) ? (PAGE_SIZE - 1) : size;
-	request_data = ioc->diag_buffer[0] + ioc->ring_buffer_offset;
+	request_data = ioc->diag_buffer[MPI2_DIAG_BUF_TYPE_TRACE] + offset;
 	memcpy(buf, request_data, size);
+	mutex_unlock(&ioc->ctl_cmds.mutex);
 	return size;
 }
 
@@ -3704,12 +3729,14 @@ host_trace_buffer_store(struct device *cdev, struct device_attribute *attr,
 {
 	struct Scsi_Host *shost = class_to_shost(cdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
-	int val = 0;
+	unsigned int val;
 
-	if (sscanf(buf, "%d", &val) != 1)
+	if (kstrtouint(buf, 0, &val))
 		return -EINVAL;
 
+	mutex_lock(&ioc->ctl_cmds.mutex);
 	ioc->ring_buffer_offset = val;
+	mutex_unlock(&ioc->ctl_cmds.mutex);
 	return strlen(buf);
 }
 static DEVICE_ATTR_RW(host_trace_buffer);
@@ -3755,13 +3782,17 @@ host_trace_buffer_enable_store(struct device *cdev,
 	struct mpt3_diag_register diag_register;
 	u8 issue_reset = 0;
 
+	if (sscanf(buf, "%9s", str) != 1)
+		return -EINVAL;
+
+	mutex_lock(&ioc->ctl_cmds.mutex);
+
 	/* don't allow post/release occurr while recovery is active */
 	if (ioc->shost_recovery || ioc->remove_host ||
-	    ioc->pci_error_recovery || ioc->is_driver_loading)
+	    ioc->pci_error_recovery || ioc->is_driver_loading) {
+		mutex_unlock(&ioc->ctl_cmds.mutex);
 		return -EBUSY;
-
-	if (sscanf(buf, "%9s", str) != 1)
-		return -EINVAL;
+	}
 
 	if (!strcmp(str, "post")) {
 		/* exit out if host buffers are already posted */
@@ -3832,6 +3863,7 @@ host_trace_buffer_enable_store(struct device *cdev,
 	}
 
  out:
+	mutex_unlock(&ioc->ctl_cmds.mutex);
 	return strlen(buf);
 }
 static DEVICE_ATTR_RW(host_trace_buffer_enable);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c b/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c
index d9b7d0ee25b0..bda404a3ff3d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c
@@ -118,6 +118,7 @@ mpt3sas_process_trigger_data(struct MPT3SAS_ADAPTER *ioc,
 	dTriggerDiagPrintk(ioc, ioc_info(ioc, "%s: enter\n", __func__));
 
 	/* release the diag buffer trace */
+	mutex_lock(&ioc->ctl_cmds.mutex);
 	if ((ioc->diag_buffer_status[MPI2_DIAG_BUF_TYPE_TRACE] &
 	    MPT3_DIAG_BUFFER_IS_RELEASED) == 0) {
 		/*
@@ -131,6 +132,7 @@ mpt3sas_process_trigger_data(struct MPT3SAS_ADAPTER *ioc,
 		mpt3sas_send_diag_release(ioc, MPI2_DIAG_BUF_TYPE_TRACE,
 		    &issue_reset);
 	}
+	mutex_unlock(&ioc->ctl_cmds.mutex);
 
 	ioc->htb_rel.buffer_rel_condition = MPT3_DIAG_BUFFER_REL_TRIGGER;
 	if (event_data) {
-- 
2.53.0

