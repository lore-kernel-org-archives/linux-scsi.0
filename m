Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794996834;
	b=PBOc10u1AiVXPu3j4d6qidu4DAXY7ywuf4wYoJ8G0QEGkSRQhlNC96E5Ptf0nqc+fYRt
	 b1av8W9U09zBZZo0rFZ3LJdqTLOJGSas6w/L0VMKFXt/vnpuWWaSegzC/mZ7gkyGhqRHG
	 JqEO6RlwisO1whjGqpLOJ3f21QWyA2c5DREXAbxuEH3WVa6wo9tOsXCgwAaUmhtnrc38O
	 pk/LeWmoveKcHSKu0esFn+Wtjeza2XM4Xg5FSh/a9c9O0YU271JisgDSars787DaYVn8V
	 pnrqGNOveL5wQb5/s/w4h2thL7fZd+tf0v8T4JIxd8vVRv2sn7kIQnVjikgSv+Jd4OA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794996834;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=0v4jvdX3b35Hhj3Tu+t0BxIQJNcDlPQQNAlCn7l6Tl0=;
	b=ZWCMnre+POympE6IAvPyEE4JEqv7ytGeoEXOJXT2upO/3KDMHoC0c3T99PAEEM72rLxe
	 lIvkSxO9ah1BKKsOa9XsB0yykr+vIxcRTpUINRInhvOp5u5F/uSt/bQB9ajrJvJRmAF3m
	 MC9x3XqYkupwk1z47QD5lcRMUf/m8T8ditWrCOhZZVtAsoge5usOVBXPqWIipKXhimaX0
	 LOF+sQaNs/SqQweTu/2zpx8XxICNJlmt62ZnfVq3Wba6ARtHuNGyntzCmVMLtFCBHG/vL
	 rIzjEL5BBwnQUZ8sXMTooSRyQPwriKF/QzutyWI4gi/tWfT/437OY8tWEe5hwVdFMZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=dkOwlwTv;
	arc=none smtp.remote-ip=209.85.216.99
Received: from mail-pj1-f99.google.com (mail-pj1-f99.google.com [209.85.216.99])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186F6606A333
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:13:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 186F6606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=dkOwlwTv
Received: by mail-pj1-f99.google.com with SMTP id 98e67ed59e1d1-3adac5b29ebso442151a91.2
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:13:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794996833; x=1795601633;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0v4jvdX3b35Hhj3Tu+t0BxIQJNcDlPQQNAlCn7l6Tl0=;
        b=cdeUk9IJfI9uXML/6Pmu4b5xvYBW7fw6VPzrgL4lEhEHrLSX5f/othp+Ox5D/GqNOB
         J7QjYCjzmqRUQ1QzIroOcW3YjzpHczRthxj+tuyBh2MpQVwfkm1zto35azY/y/zYukH8
         56vqNNl8cFuNoC+NQG0rTDsgdvX+yWKW6yd8J8TMyULUc66C6JmRfdIIuRyHeERFbOu9
         oGCExrU73C2juiBl8ulUPUSi/HRpG+RJgMp5O8vi/WzhR5dXbd5mXHddKrchUFUCeie+
         qG+Z86f1cUA/tmXc3nk5FQL+RHjJ2/U6qbzQU7uCgBTXjRKgTbY5TPD10RP7nma+WAaL
         Se6w==
X-Gm-Message-State: APuU4Z86zW+9NDMhrORbwiUy3cwRaYep54zBlGd37fTKD/7HKUIDjE23
	MfO6Xd2/lhahi6aeP/NDMfw13qTxVuPCW7hun76Do27aLDTzNKK9f7/qPML6sH45HKeiZbEGXLh
	V3ZQABoaOebHXufm0QmQkm2bU9RQ62q6nWUA7zwubiz9FcUEbD6hvjquQbZ5vkcECDY10aV2eiV
	wVHc3zCgdeXtOQJICbvAqPlM6dT+FZ+qCMmbrQwEwwtjFlUXbFegBJ2VIwJaRk+v/hCMYfzsKqL
	6+1DRyxEf38wy9QkZLpmzwbs6CZtxaKoK0=
X-Gm-Gg: AZFdTZfa5Tbdb1Ttr/UffkskUZNyX1lgvuf0eNuTXPdNEDcgild4uevwfHtZQ/sFofT
	hzvZXGgEGvA8jamFi3uCF2afMso11FhLxfL4HftWk5QE1RKLiEp4YpNagNZHfKdf4SH62Ot3sOC
	vvpM4DBwsR0sfihzXxYRB8CGPK0plibjLQvB/OImNvRvpveutenfBMpwD2mqPVe1qaefO/2mHiT
	0TBlZvKYstJRQVu0ZXWJgcvih6PZ6cS9mcq+sbNkpnA8G6VBa031SaZ0wBnnEi3d26pwq2N29sO
	E3rnGfljf/Mbl7ZP4B043/sEbTSBK1iK+vJ099jpFjKIoz2Dywpd7qROa0HqlDFK1BfS0v3tzaG
	Z4pL0SFinjiJurl96ua40XsF/UXiJy0EtCz2WOUXkE3H4FzbLB8AKeH/uo+d6dAnjt5lRYSVWN/
	HaM3Q7RAr0R+jgcdobfppcV5CCteAoFzUiNL5tdjZU6Pr8JmUz79UHZQ==
X-Received: by 2002:a17:90b:448f:b0:3b3:c04e:4b61 with SMTP id 98e67ed59e1d1-3b3d07abdb6mr2315008a91.47.1794996833268;
        Wed, 18 Nov 2026 02:13:53 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b3d14463c6sm1504513a91.6.2026.11.18.02.13.52
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:13:53 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3b3b74351a4so873001a91.2
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:13:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794996831; x=1795601631; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=0v4jvdX3b35Hhj3Tu+t0BxIQJNcDlPQQNAlCn7l6Tl0=;
        b=dkOwlwTveN+i/pBWuO6SqPna3b1f6AKRBTS1Ampw5VBwfyoyUAqD4R4IKjYwNq76p6
         Rl0hut9GxsPpOLObZExBlaIH4NZna194Djm5hL2ESHVMWGFVg2hHI+M32L4ziyV2JpQA
         RqyI09KySZMPYFDJ/4LAvD3zQVsawJFbhpA+A=
X-Received: by 2002:a17:90a:d446:b0:3ad:ce34:f63c with SMTP id 98e67ed59e1d1-3b3d0765d34mr2511021a91.30.1794996831278;
        Wed, 18 Nov 2026 02:13:51 -0800 (PST)
X-Received: by 2002:a17:90a:d446:b0:3ad:ce34:f63c with SMTP id 98e67ed59e1d1-3b3d0765d34mr2510991a91.30.1794996830738;
        Wed, 18 Nov 2026 02:13:50 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3ac6016c3sm8740707a91.15.2026.11.18.02.13.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:13:50 -0800 (PST)
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
Subject: [PATCH v2 30/37] scsi: mpt3sas: Add _ctl_diag_buffer_reset() helper to clear diag buffer state
Date: Wed, 18 Nov 2026 01:56:39 -0800
Message-Id: <1794995806-5835-31-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Consolidate open-coded diag buffer teardown sequences across
_ctl_diag_register_2(), _ctl_diag_unregister(), and
_ctl_host_trace_buffer_enable_store() into a single helper that clears
the pointer, size, DMA address, status, and unique ID together.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 32 +++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index d15ef29ed077..e1c3ac432501 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -1651,6 +1651,28 @@ _ctl_diag_get_bufftype(struct MPT3SAS_ADAPTER *ioc, u32 unique_id)
 	return MPT3_DIAG_UID_NOT_FOUND;
 }
 
+/**
+ * _ctl_diag_buffer_reset - clear every field describing a diag buffer
+ * @ioc: per adapter object
+ * @buffer_type: diag buffer type
+ *
+ * Call this wherever a diag buffer's DMA memory is freed, so its size and
+ * DMA address never outlive the pointer that describes them.
+ */
+static void
+_ctl_diag_buffer_reset(struct MPT3SAS_ADAPTER *ioc, u8 buffer_type)
+{
+	ioc->diag_buffer[buffer_type] = NULL;
+	ioc->diag_buffer_sz[buffer_type] = 0;
+	ioc->diag_buffer_dma[buffer_type] = 0;
+	ioc->diag_buffer_status[buffer_type] = 0;
+	ioc->unique_id[buffer_type] = 0;
+	if (buffer_type == MPI2_DIAG_BUF_TYPE_TRACE) {
+		ioc->ring_buffer_sz = 0;
+		ioc->ring_buffer_offset = 0;
+	}
+}
+
 /**
  * _ctl_diag_register_2 - wrapper for registering diag buffer support
  * @ioc: per adapter object
@@ -1909,9 +1931,7 @@ _ctl_diag_register_2(struct MPT3SAS_ADAPTER *ioc,
 	if (rc && request_data) {
 		dma_free_coherent(&ioc->pdev->dev, request_data_sz,
 		    request_data, request_data_dma);
-		ioc->diag_buffer[buffer_type] = NULL;
-		ioc->diag_buffer_status[buffer_type] &=
-		    ~MPT3_DIAG_BUFFER_IS_DRIVER_ALLOCATED;
+		_ctl_diag_buffer_reset(ioc, buffer_type);
 	}
 
 	ioc->ctl_cmds.status = MPT3_CMD_NOT_USED;
@@ -2132,8 +2152,7 @@ _ctl_diag_unregister(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 		request_data_dma = ioc->diag_buffer_dma[buffer_type];
 		dma_free_coherent(&ioc->pdev->dev, request_data_sz,
 				request_data, request_data_dma);
-		ioc->diag_buffer[buffer_type] = NULL;
-		ioc->diag_buffer_status[buffer_type] = 0;
+		_ctl_diag_buffer_reset(ioc, buffer_type);
 	}
 	return 0;
 }
@@ -3875,8 +3894,7 @@ host_trace_buffer_enable_store(struct device *cdev,
 						  ioc->diag_buffer_sz[MPI2_DIAG_BUF_TYPE_TRACE],
 						  ioc->diag_buffer[MPI2_DIAG_BUF_TYPE_TRACE],
 						  ioc->diag_buffer_dma[MPI2_DIAG_BUF_TYPE_TRACE]);
-				ioc->diag_buffer[MPI2_DIAG_BUF_TYPE_TRACE] =
-				    NULL;
+				_ctl_diag_buffer_reset(ioc, MPI2_DIAG_BUF_TYPE_TRACE);
 			}
 
 			diag_register.requested_buffer_size = (1024 * 1024);
-- 
2.53.0

