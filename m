Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794996752;
	b=u5W2OqXJFlTr6QQ1cOsvwTLOm5VfpF/wco3MixYFgFlL9pK3sFzwOO9e/Xe9s0VctxmR
	 9AIRTuG05D+ryi2+bwgjYo8vZONZ3eTUpBKyyS+JIXAsbvLx7URFIfNyppc+1TT+mOQGD
	 XQRLLZmm790jQPJQnRCt32Ia+yIiHgQUvbgvzjOf3VPyVL6N4b/QF1I1ooWKcrxD9Z5CL
	 Axq6jUC38DhlXEFUT7UqM/TG7CF/4jd/RW0xpMYn/vAEaA4jr6Wvkso0ABs3klM3CcjpC
	 5rcB2bmfeGFfEyDWmKbiQ4Qb+tEcBaikfS0nxu0hwH64guJM4CwTSkg1FeM6l38itvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794996752;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=9CCL8q3hLyFQuWX2ke9Lfm5bz+ZlQQjSvw9G3QVTWE8=;
	b=zxatrPHhOCQ1SN20mrxDiCi23SD4ZhePVZ6yWgH3RjjmQAAtxYEdwtN730Cj/ulU2Pxy
	 nH6xC3YWpYoDkG86ieb+GMISLBwXImsPABLRRTKk7qAhjouZFZY2bth+Rre6n1XtX9hoK
	 MAC/S+nRUKsyIMj+luQa/iD2+Uh662S6lRSsOnT1HCCBGlCilw63FGin0l2OACBxyT3zN
	 ti+SB6YAkFvd5ow+scoHRjtOmocvH1za39J/If7/KhqFcgEnE7Z0c+awPqgAfPuchV4pF
	 /84/op+/zgufAQCK6YX7crK/zTM2btyzHV3Yjz7gtEEaHb9SlEQjjJoKz/iT2LymXxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=PYvvW5O7;
	arc=none smtp.remote-ip=209.85.215.225
Received: from mail-pg1-f225.google.com (mail-pg1-f225.google.com [209.85.215.225])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE6D606A320
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:12:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EEE6D606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=PYvvW5O7
Received: by mail-pg1-f225.google.com with SMTP id 41be03b00d2f7-cdb2dfcca94so330461a12.1
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:12:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794996751; x=1795601551;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9CCL8q3hLyFQuWX2ke9Lfm5bz+ZlQQjSvw9G3QVTWE8=;
        b=ce9xrlG1Kc73VHFWSafEBqkv1mIzNM+01rZCh6oYtMvjbSB242nmt25F3NsH21M7XN
         znM3gE4jTZGYMutHSAU8G7ZLpjsKSHX7DJieH8Qvt85SU9X9DcqEsFaYwD2LY0wCzFjs
         NeQvujNBZPqoMQp+696OUswhhIA3aEDC8AG5YOJLLL+/qydK0U1g1SOLb6wrcLE2RTa9
         MJvdmPFoL109Pdwiw1FxoEQjBxDLG8dsu9euHoEvDbzUhYbDhsSADorPXROW/x7vVSYd
         ociPSpgI+Zqnten9e9bmRj4jUJKlS1DTGkWXzBhIRGIkRV13O+yNg+v4GJjI3zrtuAF1
         MSGQ==
X-Gm-Message-State: APuU4Z/FqzctK0r3ZuIH38aJxVS0H25VGAmjOOV7/E0LQxd876jMNj40
	Wn8ZxRTAps/aGA6mdH8uCU01fp8ffwmhjhUkIKo/Nqj2jFkTUbKZsLv1S3cxf5Zv2fncDiC4IX/
	0rm1guBhCVuvuNO5JmJT4mmz88Y6CA7PgJfFXOLcACF70bBZPxMsu6Sm2aIL9Jrcn7Zamd1Y6xM
	xAWEf/Pj1uvAMfzdvacjNMRpoaM8l139NIyYR/abQGcttQJytwx9Y4HqsRpM0o6sHQdlQ/iIXLm
	tNc5yHigRb1QyGPfuN3illKVU6xxBGnG7o=
X-Gm-Gg: AZFdTZcrHLTOfo9Js+lR41ShqlRdX4iHm/DBO0i/08GQ+LtYY4IWkmjH+jw/uJ8UkOn
	95je76BYR41E7y9W3gFUSzR3HpnZdir7eOnfQhTo4r3x/Nz0TAMDoxUhX34nU0DTjMpUVLxi4aQ
	xum97YwHRycRNKm+3UhE/2M/JnPXxDMOTke0wNh6fAhg0+DD+x+vBNvamzGhneS/wTJSVRDy2H4
	3CuIBlKtj3GOVKB1xe5B0m9uXR8LG62OR5VCGuzPXZYPdamIPb1X0rbwt0v3OxjCHFGFlEiNnpZ
	wwiAQdQlNMeLzU+WpC2GeZmVozWpwwyFGGdFwrLRLwcHB/lXnCR9JqFyTJKcEbT7Ri7Pp+NJ8pu
	cTyDyToRsYKbCHToXbQ4BsJ02JEt35ERemEfluDdxB2pcdeMcV4A4lh9/NrPxmx61wXnop9xRg4
	2uAFTIqOhUi/twjOf44awV772q46+yJ4gTq/XlXpCvM4te/s2lfDuc4A==
X-Received: by 2002:a17:90b:3c81:b0:3ab:36c4:b4ff with SMTP id 98e67ed59e1d1-3b3d07b80c7mr2184321a91.24.1794996751161;
        Wed, 18 Nov 2026 02:12:31 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b3abf029a5sm3964259a91.5.2026.11.18.02.12.30
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:12:31 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3b167bc8e16so741175a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:12:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794996749; x=1795601549; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=9CCL8q3hLyFQuWX2ke9Lfm5bz+ZlQQjSvw9G3QVTWE8=;
        b=PYvvW5O7QnQ3X8xu+fbYMGUSfeOk4Xzq4HZC/B9OFxQynWXLZQLci5SaOtL7T3a/bo
         kc7VsBuyZSw0441gFw0RGyOAxjeGVf/sHagbHfDz5j5GZ8yMnidM+7ypeJ3OByyMOyyu
         fg/hzvBKpfonl0XrNX0MWGL88o14OvRAX13NQ=
X-Received: by 2002:a17:90b:3b48:b0:3b3:b71e:b2f3 with SMTP id 98e67ed59e1d1-3b3d07d45e5mr2221377a91.45.1794996749376;
        Wed, 18 Nov 2026 02:12:29 -0800 (PST)
X-Received: by 2002:a17:90b:3b48:b0:3b3:b71e:b2f3 with SMTP id 98e67ed59e1d1-3b3d07d45e5mr2221349a91.45.1794996748866;
        Wed, 18 Nov 2026 02:12:28 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3ac6016c3sm8740707a91.15.2026.11.18.02.12.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:12:28 -0800 (PST)
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
Subject: [PATCH v2 09/37] scsi: mpt3sas: Clamp topology/IR event entry counts to EventDataLength
Date: Wed, 18 Nov 2026 01:56:18 -0800
Message-Id: <1794995806-5835-10-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Clamp NumEntries/NumElements in SAS/PCIe topology and IR config
change events to what EventDataLength actually covers.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 72 +++++++++++++++++++++++++---
 1 file changed, 65 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 184ed88fab55..b6ab2c755e56 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -12170,7 +12170,7 @@ mpt3sas_scsih_event_callback(struct MPT3SAS_ADAPTER *ioc, u8 msix_index,
 	struct fw_event_work *fw_event;
 	Mpi2EventNotificationReply_t *mpi_reply;
 	u16 event;
-	u16 sz;
+	u32 sz, max_dwords;
 	Mpi26EventDataActiveCableExcept_t *ActiveCableEventData;
 
 	/* events turned off due to host reset */
@@ -12190,6 +12190,28 @@ mpt3sas_scsih_event_callback(struct MPT3SAS_ADAPTER *ioc, u8 msix_index,
 	if (event != MPI2_EVENT_LOG_ENTRY_ADDED)
 		mpt3sas_trigger_event(ioc, event, 0);
 
+	/*
+	 * Ensure EventDataLength does not exceed the maximum allocated reply size
+	 */
+	max_dwords = 0;
+	if (ioc->reply_sz > offsetof(Mpi2EventNotificationReply_t, EventData))
+		max_dwords = (ioc->reply_sz -
+		    offsetof(Mpi2EventNotificationReply_t, EventData)) / 4;
+	if (le16_to_cpu(mpi_reply->EventDataLength) > max_dwords)
+		mpi_reply->EventDataLength = cpu_to_le16(max_dwords);
+	sz = le16_to_cpu(mpi_reply->EventDataLength) * 4;
+
+	/*
+	 * reject events too short to contain the header.
+	 */
+	if ((event == MPI2_EVENT_SAS_TOPOLOGY_CHANGE_LIST &&
+	     sz < offsetof(Mpi2EventDataSasTopologyChangeList_t, PHY)) ||
+	    (event == MPI2_EVENT_PCIE_TOPOLOGY_CHANGE_LIST &&
+	     sz < offsetof(Mpi26EventDataPCIeTopologyChangeList_t, PortEntry)) ||
+	    (event == MPI2_EVENT_IR_CONFIGURATION_CHANGE_LIST &&
+	     sz < offsetof(Mpi2EventDataIrConfigChangeList_t, ConfigElement)))
+		return 1;
+
 	switch (event) {
 	/* handle these */
 	case MPI2_EVENT_SAS_BROADCAST_PRIMITIVE:
@@ -12211,9 +12233,20 @@ mpt3sas_scsih_event_callback(struct MPT3SAS_ADAPTER *ioc, u8 msix_index,
 	}
 
 	case MPI2_EVENT_SAS_TOPOLOGY_CHANGE_LIST:
-		_scsih_check_topo_delete_events(ioc,
+	{
+		Mpi2EventDataSasTopologyChangeList_t *topo_data =
 		    (Mpi2EventDataSasTopologyChangeList_t *)
-		    mpi_reply->EventData);
+		    mpi_reply->EventData;
+		u32 data_len = sz;
+		size_t hdr_size =
+		    offsetof(Mpi2EventDataSasTopologyChangeList_t, PHY);
+		u16 max_entries;
+
+		max_entries = (data_len - hdr_size) /
+		    sizeof(Mpi2EventSasTopoPhyEntry_t);
+		if (topo_data->NumEntries > max_entries)
+			topo_data->NumEntries = max_entries;
+		_scsih_check_topo_delete_events(ioc, topo_data);
 		/*
 		 * No need to add the topology change list
 		 * event to fw event work queue when
@@ -12225,18 +12258,43 @@ mpt3sas_scsih_event_callback(struct MPT3SAS_ADAPTER *ioc, u8 msix_index,
 		if (ioc->shost_recovery)
 			return 1;
 		break;
+	}
 	case MPI2_EVENT_PCIE_TOPOLOGY_CHANGE_LIST:
-	_scsih_check_pcie_topo_remove_events(ioc,
+	{
+		Mpi26EventDataPCIeTopologyChangeList_t *pcie_topo_data =
 		    (Mpi26EventDataPCIeTopologyChangeList_t *)
-		    mpi_reply->EventData);
+		    mpi_reply->EventData;
+		u32 data_len = sz;
+		size_t hdr_size =
+		    offsetof(Mpi26EventDataPCIeTopologyChangeList_t, PortEntry);
+		u16 max_entries;
+
+		max_entries = (data_len - hdr_size) /
+		    sizeof(MPI26_EVENT_PCIE_TOPO_PORT_ENTRY);
+		if (pcie_topo_data->NumEntries > max_entries)
+			pcie_topo_data->NumEntries = max_entries;
+		_scsih_check_pcie_topo_remove_events(ioc, pcie_topo_data);
 		if (ioc->shost_recovery)
 			return 1;
 		break;
+	}
 	case MPI2_EVENT_IR_CONFIGURATION_CHANGE_LIST:
-		_scsih_check_ir_config_unhide_events(ioc,
+	{
+		Mpi2EventDataIrConfigChangeList_t *ir_config_data =
 		    (Mpi2EventDataIrConfigChangeList_t *)
-		    mpi_reply->EventData);
+		    mpi_reply->EventData;
+		u32 data_len = sz;
+		size_t hdr_size =
+		    offsetof(Mpi2EventDataIrConfigChangeList_t, ConfigElement);
+		u16 max_elements;
+
+		max_elements = (data_len - hdr_size) /
+		    sizeof(MPI2_EVENT_IR_CONFIG_ELEMENT);
+		if (ir_config_data->NumElements > max_elements)
+			ir_config_data->NumElements = max_elements;
+		_scsih_check_ir_config_unhide_events(ioc, ir_config_data);
 		break;
+	}
 	case MPI2_EVENT_IR_VOLUME:
 		_scsih_check_volume_delete_events(ioc,
 		    (Mpi2EventDataIrVolume_t *)
-- 
2.53.0

