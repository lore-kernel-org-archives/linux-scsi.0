Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794996737;
	b=0A8K1kkj9OqxxoU6ZpOg4u4rGkVNLJHI1NF81mI+rV/CRgKDH+85V0DWdlN6SBpPjOSH
	 ygEB6RvsdIREYLi0Sq/NlK/4OY0FDKO3drV1Trrlu0P+e8mfxDKdugfBnF+Lk4nllaZhA
	 f11EsRCLo1V1c3kJINc3yBPPQGuIgbpCwsdZ1VjDfUi2RiHtjWAEcazRcn9nXN/Qgt34P
	 X3e+0hc3dTDjzV0kRIwXqL/P+ehC1oG+CU4482j5HFb/AVTWV2ldRsUZq6OZujiE7MfOt
	 dBBKK32nC/iz+hKnbdOrqlnetMaD/zVH+vGfk2a9lY68hW5JHj5IQMLaNHT5wM3Whkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794996737;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=sHBYgL6hZwGDpI863RtsriK53stw9Pe7vR+7C6m4b/g=;
	b=jEWEB7/NRvCAjkRAKP/4j5oEBpL8ZJgMrd5esBtCpOdELPZFxQBqalzXDCNWa8wDiiQz
	 xaT6KeH/khiaa1fBNmfH+Sr+u0JC5hfXcAFQrCHgE5MRpkMaXTZV9VtdOhDyu5QTn/9Zu
	 tQ4PiuX6pLp+PSlO2zAm1PXKsWRK7TCQrKD9JkzVL62QC44G9xiVGreel5mesci1FKbIN
	 /gXfBkaaws5KOic7Fjcq4fK8Kainyy7VrHt1xiY3ZmTm8Kb3nDXAxTaWLwCJg8KXRtrNv
	 kX9xctxMssDMAn5u0uh7QoR0Ba1jUUGKhSa4GDnS7m+s1Io81DLh1kcDocz37+xJS8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=HKoG+VFU;
	arc=none smtp.remote-ip=209.85.216.100
Received: from mail-pj1-f100.google.com (mail-pj1-f100.google.com [209.85.216.100])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B80E606A33B
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:12:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8B80E606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=HKoG+VFU
Received: by mail-pj1-f100.google.com with SMTP id 98e67ed59e1d1-3b3bf3bef9aso737886a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:12:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794996737; x=1795601537;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sHBYgL6hZwGDpI863RtsriK53stw9Pe7vR+7C6m4b/g=;
        b=C0sHdOUNklrBM/MoBFSl7mDGNZ3GoiIEblu1VLf7NuarUF7/9+HS6zDXCCBi+3DbO4
         xdaMJQZl2n7QcfS/+KFbIygIXVPW9CfXoso2+hVQmcURAD5/r4/27HZmvo057vxvr1Bt
         WRMf47gen73Qrqpd2Lv74mHgtiBsgkZqQjCE7HiwRSO9eYz5XJ6S+HLQVs/VN+9HgXfr
         7RyzU6pyZtxwzbUngUEGqt7q2fjSon7eTXp7Gn+bdXnPVqwaIzBn/bq3SgM1VJft20qX
         zn7XIQxP6mjycAzX2ukIB+3dysI5eETSb4usfXEwqu+5NNlkhWc1V7K1m/roF0VOd7hT
         i6LA==
X-Gm-Message-State: APuU4Z+9S58JrEiQ8aGoRl2P2qKR60lrRFBGAeEzN3uDRZ6xlfd+HLms
	rlVZHCwq44g767VztUV7/fN9PCtM0hwbpaTuJbOhTF3jP1/pqOi43TEjOFl+GrioaAiJ1Azik4v
	gog/lPTawT1SqqTT1EQ/ojQr4q+D/0E3qnizB3+RdL+qhE8j8IzOvuHkfXmqsaiYSJePC5C9Sw9
	o4jQKfsBFR9cfe/Gc3DpXBKQPgGRcjrarg6umA6kLK3Hp0KzhqotFFiSMy7eoXI/dndAfa4XYvQ
	wgBE/BYUlaOwFA5OEzwM2DVzNrJg1fqVkQ=
X-Gm-Gg: AZFdTZdtZ+KlRlR0H0YdCzEJKbu2S8seb7h+04XJQI8WHP/4geYIO4L1Erokdf1l+t/
	poqwZ9jdJRRg16x1CfUv3wNpnAoc7cJjvah0tPqglgi2EJjY28ZMGYVbZtJr7POxV1cNzaKyFj3
	npCgRreIrflj4TEY0eF81v3hFQJr6QPSEUIMEbmzGW2dQwgN92v/TXLSu+/WfWt8LdFFnteJTh5
	qwhLc3aXAGlus45gTcKKx52MpWybtLlAvVzmiQTX1ZmuO3aOpf4UfvE1lM0f9YMQQWO8VOmaV9o
	H4EndQfByQDvVVL1D1fu0s7fsIbE0IvKLVK5M80n6knWwJKnCrtDFmWot64MzpDK9elSkGvLKZC
	5e0xbC0NgNEfkQoL0SCoUPXGud6yrclwHkqxrqAqJw5Z1QmpFWtqo/h5W4FO7rZe5uifvva3nEp
	30dX2VjX7x6ZKR084pxnF2CwN3Az65sToopAvXFOVn1kuyDBqs/GiZyg==
X-Received: by 2002:a17:90b:39a3:b0:3b0:d0c5:c10e with SMTP id 98e67ed59e1d1-3b3d07a2448mr2172204a91.17.1794996736723;
        Wed, 18 Nov 2026 02:12:16 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b3abece214sm3962294a91.3.2026.11.18.02.12.15
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:12:16 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3ae72da2f57so1051341a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:12:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794996734; x=1795601534; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=sHBYgL6hZwGDpI863RtsriK53stw9Pe7vR+7C6m4b/g=;
        b=HKoG+VFUESjJ3UguULQoOG5VvYgDjV1R8sOnVFZf+yxyfOkNYRCkeycFq2x9h1nECZ
         uvC5nfUtdyRZHwzDiBloez/gIlq93Ctt8ZrsMBQT2JJz6G3RlB3I707SGSJsOgjPfYbt
         iP0Wt4dWP0Ie9eN7OQDKebAbfCS1ajlEK4ogo=
X-Received: by 2002:a17:90b:1b0f:b0:3ad:a462:f07f with SMTP id 98e67ed59e1d1-3b3d07d463dmr2303756a91.45.1794996734019;
        Wed, 18 Nov 2026 02:12:14 -0800 (PST)
X-Received: by 2002:a17:90b:1b0f:b0:3ad:a462:f07f with SMTP id 98e67ed59e1d1-3b3d07d463dmr2303722a91.45.1794996733470;
        Wed, 18 Nov 2026 02:12:13 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3ac6016c3sm8740707a91.15.2026.11.18.02.12.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:12:12 -0800 (PST)
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
Subject: [PATCH v2 05/37] scsi: mpt3sas: Fix unlocked use of raid_device in enable_sdev_max_qd_store
Date: Wed, 18 Nov 2026 01:56:14 -0800
Message-Id: <1794995806-5835-6-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Take ioc->raid_device_lock around the raid_device lookup and check
for NULL before dereferencing it.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index ef28da96dc26..d8b1e60af940 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -4263,13 +4263,28 @@ enable_sdev_max_qd_store(struct device *cdev,
 
 			if (sas_target_priv_data->flags &
 			    MPT_TARGET_FLAGS_VOLUME) {
+				unsigned long flags;
+				u8 volume_type;
+				u32 device_info;
+
+				spin_lock_irqsave(&ioc->raid_device_lock,
+						  flags);
 				raid_device =
 				    mpt3sas_raid_device_find_by_handle(ioc,
 				    sas_target_priv_data->handle);
+				if (!raid_device) {
+					spin_unlock_irqrestore(
+					    &ioc->raid_device_lock, flags);
+					continue;
+				}
+				volume_type = raid_device->volume_type;
+				device_info = raid_device->device_info;
+				spin_unlock_irqrestore(&ioc->raid_device_lock,
+						       flags);
 
-				switch (raid_device->volume_type) {
+				switch (volume_type) {
 				case MPI2_RAID_VOL_TYPE_RAID0:
-					if (raid_device->device_info &
+					if (device_info &
 					    MPI2_SAS_DEVICE_INFO_SSP_TARGET)
 						qdepth =
 						    MPT3SAS_SAS_QUEUE_DEPTH;
-- 
2.53.0

