Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.226
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794996733;
	b=v1uxSvo2bJubbOPm4WDPuHILPACCYnE8LXyc+kGjp7RMLKFcMcbNh3SuSYq9OHMJfqZk
	 Ay1q+rywrV5xwyP8VsxFzmbbAkkPxeFsvzyby+lJBrhLLBokb2Lz0ZI4d0VVkLsLOpfD0
	 4srE8IDcJKqnM+gLaEiD+8y9O9OMK/L5DXfXiNgkUVh3gwBp+7/SmXy6BKYRW0NB65cR+
	 rsnh1ONpVDiJngPAS/Nlt8NJJoDBjpTOE53jRO6oAoC1JoKFtF6d5SAkBuvFkFb0EZhoQ
	 Dsn/adUfIk/PF1LdHbLXqnKn/GOierOvsaXH9g2a3E/yCWX51xHna7SxjMHvp6RPn1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794996733;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=CH2uOXbLqkPaB1MCdkiR9hZJBHzsxjfeu8pwuDZPuYA=;
	b=q19T2HnKtwkLPUQO00Llufz6p5Mny+OxhYnmkg+wgakxPoQoHhlYML7coK7dAaA3EMzq
	 6bGGN5usWPUbjxP4+24BOuYB7iwSK7G8Cq/n79qgFW9ZKI/qNYQSydGmrxgLXQkk31jWM
	 nkwX0pTFWvJOOSiqB2s8lAD5KDNvDuZBKxU6EGeZGtqpYmg72Jv8dBzt2hscAcUGVkMs8
	 Xxi6BZW6z4MjHWioxmw3/X6bS5p5MV9w+rPrNhBZ6wx6ygN0Nfe7q8IIofUKFp3zmyvxF
	 SA7ZJMVnBwGLU4keV+EJ+j80ZUuwGQbbcW+SPATYKRAFNdqdRNohnDbdAKDZZZRCOFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=BDEQf5l6;
	arc=none smtp.remote-ip=209.85.222.226
Received: from mail-qk1-f226.google.com (mail-qk1-f226.google.com [209.85.222.226])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10371606A31C
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:12:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10371606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=BDEQf5l6
Received: by mail-qk1-f226.google.com with SMTP id af79cd13be357-9495e8ae23aso72177785a.2
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:12:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794996732; x=1795601532;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CH2uOXbLqkPaB1MCdkiR9hZJBHzsxjfeu8pwuDZPuYA=;
        b=23zAMtMAEELqGyrcQOTwOjGUcaTBSV+FK4zxoLTShVrXKJqoG2Agne9vkAfNbQwciX
         hJhe6KwJOsymTn3oX+Jc391ex4NrNhUSsdFCLn2FhDQDHEb5lYMLVl1IT76NQCOc8qOu
         T+AThTS4gLePPgp6A7K3fs8jVXO4nJYaEl8zqs4Lt1paeNperfavFqcED+2nwP3gL2UT
         gppJxDBriaaSkj2aYZ9gbvwaIw7oXobmk/N6C502CKI+nKJw1GmvdXSqh02aWOpi+iyT
         85PqleUJbvFY5Uwo4XmBAbjyEFCyjxB3pWh4Z/IK0pWusd3RGwdKQ+ogENWCyiKen2CX
         IHrw==
X-Gm-Message-State: APuU4Z9KwlhzfiFRQWyTAIBj+pZMuwonGvPmd4He1Rn+ftG2D2TQoTuz
	2iLdjy1K5CLi7qnCfyhWbqZHZkh/FRvYZbqh0txBPZGSNFjCitvNcTLyF1gWg5kR4EpaLXl5VoX
	E7u1lWXFfoKgk7guGz8EvLsKfLk7K3fTqY9Vd7LvKCzsj5SVgDeZCQG4bIQQziQnhWA3J0NewuR
	e7QU65NIxXGBL0UxnThei5+yyZeS744jGCF0eN2BPMNBUyBVCxIazC+adKKKcyENlKqPvJXJUzC
	w/gqezp9OGmWfU7ma8vaGXitKY5uTFy/tI=
X-Gm-Gg: AYBFou1NfJRUd2S0MVd4bKNbsW+CoKwaDvxbPSKtAwjRIJ0qTQgY4qj34s+EsY5dqXl
	gJY1dMnFJVsXeQxZ5gpQCNjizS0gz1aUAaEJ+hBpMsRwdbo3pHFEvuR4Bs+zuxpiWtGSPE8C5Ql
	T1ncaPNse5R4UJ0NY7lw0LGLWLRN/VbSbniJHkPg2XDXu+JSzugCOwmHvF3gTeqJsalkwXYRYVG
	9Yj0nzs+3RuJcM3XW0ogB2xEZVBaNDNcY3B04n7EqSRn6RtJPc6evPv3V57IG5gof+2m7sLEWso
	BG03PF63rSNSjsc8sX8mzo+b+avyPwUllCIu3yrArEPuXbhtTuO1QAiRoGlzPbwlVB2kTEz5jGs
	zDkSyNWMNZYENIbYaITGpr3DXRQU1cZ2OMW+MtmYfZMBwIgo/6ieLj2JJuMAyJxIEZpFhZMQtjv
	vKHtMt8+3pDSmxN/9PUQHkarbFJIXCozJn8QBfYr7cjNP9xy6gnceO+Q==
X-Received: by 2002:a05:620a:46a5:b0:949:3c50:135 with SMTP id af79cd13be357-949995abaabmr418770185a.38.1794996731925;
        Wed, 18 Nov 2026 02:12:11 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id af79cd13be357-9499b4db4ecsm13991685a.8.2026.11.18.02.12.11
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:12:11 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3ada6ccd402so534313a91.2
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:12:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794996730; x=1795601530; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=CH2uOXbLqkPaB1MCdkiR9hZJBHzsxjfeu8pwuDZPuYA=;
        b=BDEQf5l6gtXkbXtkOXVGldy/wdrfRhb+DNelvqX/VtyhTGonJ+vOXEEzTjTk7tyQNJ
         ldZT+nBkQj/vA7n53L5iqtdR59iUqrzrHvOhr2+eM3SC9mTCaDqQB+PXlqxvho8AbhrW
         XfREiA8cCO2rXtuQ3Up1yIMBoeOX+UaOHh42c=
X-Received: by 2002:a17:90b:3f88:b0:3b1:3e7a:6d8e with SMTP id 98e67ed59e1d1-3b3d0763251mr1957308a91.10.1794996730488;
        Wed, 18 Nov 2026 02:12:10 -0800 (PST)
X-Received: by 2002:a17:90b:3f88:b0:3b1:3e7a:6d8e with SMTP id 98e67ed59e1d1-3b3d0763251mr1957268a91.10.1794996729540;
        Wed, 18 Nov 2026 02:12:09 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3ac6016c3sm8740707a91.15.2026.11.18.02.12.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:12:09 -0800 (PST)
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
Subject: [PATCH v2 04/37] scsi: mpt3sas: Fix locking and bounds checks on host_trace_buffer sysfs files
Date: Wed, 18 Nov 2026 01:56:13 -0800
Message-Id: <1794995806-5835-5-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Serialize the host_trace_buffer* sysfs handlers on ctl_cmds.mutex and
clamp the reported/used buffer size to the actual allocation size.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 69 ++++++++++++++++++++++++------
 1 file changed, 57 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index f4eeef572f6e..ef28da96dc26 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -1772,6 +1772,11 @@ _ctl_diag_register_2(struct MPT3SAS_ADAPTER *ioc,
 	/* Reset ioc variables used for additional query commands */
 	ioc->reset_from_user = 0;
 	memset(&ioc->htb_rel, 0, sizeof(struct htb_rel_query));
+	/* a (re)posted trace buffer starts a fresh capture */
+	if (buffer_type == MPI2_DIAG_BUF_TYPE_TRACE) {
+		ioc->ring_buffer_sz = 0;
+		ioc->ring_buffer_offset = 0;
+	}
 	ioc->diag_buffer_status[buffer_type] &=
 	    MPT3_DIAG_BUFFER_IS_DRIVER_ALLOCATED;
 	memcpy(ioc->product_specific[buffer_type],
@@ -1791,6 +1796,10 @@ _ctl_diag_register_2(struct MPT3SAS_ADAPTER *ioc,
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
@@ -3628,9 +3637,12 @@ host_trace_buffer_size_show(struct device *cdev,
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
 
@@ -3638,6 +3650,7 @@ host_trace_buffer_size_show(struct device *cdev,
 	    MPT3_DIAG_BUFFER_IS_REGISTERED) == 0) {
 		ioc_err(ioc, "%s: host_trace_buffer is not registered\n",
 			__func__);
+		mutex_unlock(&ioc->ctl_cmds.mutex);
 		return 0;
 	}
 
@@ -3649,7 +3662,11 @@ host_trace_buffer_size_show(struct device *cdev,
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
@@ -3674,10 +3691,15 @@ host_trace_buffer_show(struct device *cdev, struct device_attribute *attr,
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
 
@@ -3685,16 +3707,24 @@ host_trace_buffer_show(struct device *cdev, struct device_attribute *attr,
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
 
@@ -3704,12 +3734,14 @@ host_trace_buffer_store(struct device *cdev, struct device_attribute *attr,
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
@@ -3733,16 +3765,24 @@ host_trace_buffer_enable_show(struct device *cdev,
 {
 	struct Scsi_Host *shost = class_to_shost(cdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
+	const char *state;
+
+	/* serialize with post/release so a transient state is not reported */
+	if (mutex_lock_interruptible(&ioc->ctl_cmds.mutex))
+		return -ERESTARTSYS;
 
 	if ((!ioc->diag_buffer[MPI2_DIAG_BUF_TYPE_TRACE]) ||
 	   ((ioc->diag_buffer_status[MPI2_DIAG_BUF_TYPE_TRACE] &
 	    MPT3_DIAG_BUFFER_IS_REGISTERED) == 0))
-		return snprintf(buf, PAGE_SIZE, "off\n");
+		state = "off";
 	else if ((ioc->diag_buffer_status[MPI2_DIAG_BUF_TYPE_TRACE] &
 	    MPT3_DIAG_BUFFER_IS_RELEASED))
-		return snprintf(buf, PAGE_SIZE, "release\n");
+		state = "release";
 	else
-		return snprintf(buf, PAGE_SIZE, "post\n");
+		state = "post";
+
+	mutex_unlock(&ioc->ctl_cmds.mutex);
+	return snprintf(buf, PAGE_SIZE, "%s\n", state);
 }
 
 static ssize_t
@@ -3755,13 +3795,17 @@ host_trace_buffer_enable_store(struct device *cdev,
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
@@ -3832,6 +3876,7 @@ host_trace_buffer_enable_store(struct device *cdev,
 	}
 
  out:
+	mutex_unlock(&ioc->ctl_cmds.mutex);
 	return strlen(buf);
 }
 static DEVICE_ATTR_RW(host_trace_buffer_enable);
-- 
2.53.0

