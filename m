Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793926719;
	b=dmDN9+uRXS4mjNeOd2Jldj8mmyNPKb1s1rrmLPScX4wEIYSud5IMmJRWBk3IDWZA4jfu
	 OTRHRYhOnOkc9FpsBlfyVP5L9tWygEeJrX+DGLvvldV15FC+Qlz5lVKCAVhCO/i9niVLH
	 0a/ldpIoke7/vXQMQOTnHXQl0/L5C625pKdKrFv7Jn12oqj0HL4OGsKJkWmAiwaM9RUip
	 3OvUdcCkwfVDDq20s9c+kK3JG2iZzeeYfJjFJ00IZgGqdF8iWY+UmraJU/TCTxatXnTnJ
	 K5cVM02+EFrxn5PsWeX1Kza5nS4dtyFoYxbW6FQUNPRU4J+hAopIpEDycHI37vn/nxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793926719;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=4LULYwV2o4UhZi047H7Od7ERxR+6CtHJJrbkdyK+pms=;
	b=T/6EI4BKvTHDPCO66vl3q733zA+B36aX5M6TRCggw/bBpbSVj+46BEkuEWbmJRutDAJk
	 f5PQgOqZ67xCnGt3bbLlj9RoYS+HsNN5QK/UKMrwV/Y6mGGJBJomP57hZVckrYfeyYWpj
	 4EZFpQE9fhehaoFRtYDl+lYATt4QyF9YUI+YzSq0r2miWi+LFlLu3T9wRWC4s6GV9WKmM
	 sluCsogrsaWwa0zkDBQqL1XWbJyJ+bHTgV3BUfcjmEl7PpQZPKI3MZKLF3tDCkQY4kdh5
	 ZvlRW7m9fMzCEbe2uPg1kXctKTTVc2v/r8e064vX/qKSGabvHDl/L7yJtzXAqrOUduw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=XBGIO+Mg;
	arc=none smtp.remote-ip=209.85.215.225
Received: from mail-pg1-f225.google.com (mail-pg1-f225.google.com [209.85.215.225])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F198C606A326
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 00:58:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F198C606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=XBGIO+Mg
Received: by mail-pg1-f225.google.com with SMTP id 41be03b00d2f7-cdb684859cbso66652a12.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:58:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793926718; x=1794531518;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4LULYwV2o4UhZi047H7Od7ERxR+6CtHJJrbkdyK+pms=;
        b=apMsHeq+1JLWMKN8iA8LoMIeEG+Dxif/uNzbVHTZynmajobZ+hrOnsRuWYiufX9iMK
         CmN/tQ02ROhEwdfxC0pcgx1D61dlbAld8sGi39OwZwt42c9OFpUh/7lDNZLmEfQt/0wU
         GzoAl+1aPyOFt2CkLg2VXmBdqeEYiQdeLj+1WFlbe8laj1/mxi4QVbn64fTq1VDshtaz
         towNFVS8IdZ6SdYldsDWdq43Rh+3cGZ4lhug+HJG1gATXjqW/nHETtTaC76hSEeAV3s0
         CdE9jFTMZyg9elFWJnNZGCU/JFcc0AO3bZSkn0YdXsfCRqhCB1hRUzZqHEnIU66GHRC6
         dNcg==
X-Gm-Message-State: APuU4Z+0O6n6PqGfkOdjuUU/xLZw9CKg+w5rVSzP7GW1W2mGqJZBNzx2
	+PFwE/L+4LPjbVzyD5rr1MlqTNPue7qtRyvVC3hOoqSS3jM7fC7hVsk2jF/v4kC2OX+U3LIjCcV
	NMbEdVakyW6wk7KQLdriARFU0+egJvpzxuYyHsAHExCDagydp/Y3h1Up8XL1CyhZsoS1repR734
	yLWHK4wlKTxH2ZEBhpmwo28O3GnbDHBM3w0IlWRhkS2BaOLc0T6BR/llUPOfBx3mfTsBjyiXcVu
	GudnOguB3yXPfmj5RiIMPHDaL12+nHYpMI=
X-Gm-Gg: AYBFou28lhtc2YEPldu3fTNwILjQKyPIMLIv8/LudF5yiREZwq/ZeKggUusBOkj2j6d
	mENlgeHqUObWf0H6w4UtRC8hvOBHhFDEpZfwwdYe/6ZoCU0s+QYRM39iefoupaQiih0GT6CwTbv
	CP3Xcb6eRL5zNkBcAV1/a8tNslZl1PuuWThfKaCsV1TYcdRYvhJDCaciVAaKzJsG9trQ8B8P2yu
	/RXWeoPkxqGF+E45DeSlFzQNyTT9AodxMom58VE+LFSrPLYLKWbH3ZGzw/DEsnAG0mEkOF056Vv
	zqwTFZY+yb4xHfZUKEglblUvJtEDKglsrfHF6zSZmvEJgGUFkbdddL9Zu3afessXI8ldas9CpkS
	ZSZGTU3p7ogjQ1Sg6PsXykGumvs8EMytUHwcDANteeVRemNw9SwdhH1lEYVPJkktqrrvNd2W8u3
	seSyygp+sQTE3PeVO75X8KjCNIq/mTHSk3QVtGG9jSMF2G0wXmFNf0Kg==
X-Received: by 2002:a17:90b:1c0d:b0:3a4:f8da:2478 with SMTP id 98e67ed59e1d1-3b0db6c33fdmr792996a91.29.1793926718235;
        Thu, 05 Nov 2026 16:58:38 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b0b315a756sm2907253a91.2.2026.11.05.16.58.36
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:58:38 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cd67d4bbdffso92598a12.3
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:58:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793926715; x=1794531515; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=4LULYwV2o4UhZi047H7Od7ERxR+6CtHJJrbkdyK+pms=;
        b=XBGIO+MgaAeON7kis/XhW8DReIpD0LdWmBQwq9BhNqgb3Za2eBDKfrlkMahHP8AJxy
         BxZXHfQj4r3VZQj5o3v6NXIjjeNoRNjG+Ad7kT0cnwWmlr20I0zqJnK2FR+Z1j5R1TWC
         PID17+I9G0CcpLUqx8cOPf9SJULeknThzp1FY=
X-Received: by 2002:a17:902:ce0c:b0:2ed:2d16:ceac with SMTP id d9443c01a7336-2ed41bfad84mr12817725ad.36.1793926714955;
        Thu, 05 Nov 2026 16:58:34 -0800 (PST)
X-Received: by 2002:a17:902:ce0c:b0:2ed:2d16:ceac with SMTP id d9443c01a7336-2ed41bfad84mr12817515ad.36.1793926714467;
        Thu, 05 Nov 2026 16:58:34 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed47d7b8cfsm450745ad.57.2026.11.05.16.58.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:58:33 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 09/37] scsi: mpt3sas: Clamp topology/IR event entry counts to EventDataLength
Date: Thu,  5 Nov 2026 16:42:24 -0800
Message-Id: <1793925772-1303-10-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Clamp NumEntries/NumElements in SAS/PCIe topology and IR config
change events to what EventDataLength actually covers.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 51 ++++++++++++++++++++++++----
 1 file changed, 45 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index aaab6c4673c1..1d483a560d75 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -12210,9 +12210,21 @@ mpt3sas_scsih_event_callback(struct MPT3SAS_ADAPTER *ioc, u8 msix_index,
 	}
 
 	case MPI2_EVENT_SAS_TOPOLOGY_CHANGE_LIST:
-		_scsih_check_topo_delete_events(ioc,
+	{
+		Mpi2EventDataSasTopologyChangeList_t *topo_data =
 		    (Mpi2EventDataSasTopologyChangeList_t *)
-		    mpi_reply->EventData);
+		    mpi_reply->EventData;
+		u32 data_len = le16_to_cpu(mpi_reply->EventDataLength) * 4;
+		size_t hdr_size =
+		    offsetof(Mpi2EventDataSasTopologyChangeList_t, PHY);
+		u16 max_entries = 0;
+
+		if (data_len > hdr_size)
+			max_entries = (data_len - hdr_size) /
+			    sizeof(Mpi2EventSasTopoPhyEntry_t);
+		if (topo_data->NumEntries > max_entries)
+			topo_data->NumEntries = max_entries;
+		_scsih_check_topo_delete_events(ioc, topo_data);
 		/*
 		 * No need to add the topology change list
 		 * event to fw event work queue when
@@ -12224,18 +12236,45 @@ mpt3sas_scsih_event_callback(struct MPT3SAS_ADAPTER *ioc, u8 msix_index,
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
+		u32 data_len = le16_to_cpu(mpi_reply->EventDataLength) * 4;
+		size_t hdr_size =
+		    offsetof(Mpi26EventDataPCIeTopologyChangeList_t, PortEntry);
+		u16 max_entries = 0;
+
+		if (data_len > hdr_size)
+			max_entries = (data_len - hdr_size) /
+			    sizeof(MPI26_EVENT_PCIE_TOPO_PORT_ENTRY);
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
+		u32 data_len = le16_to_cpu(mpi_reply->EventDataLength) * 4;
+		size_t hdr_size =
+		    offsetof(Mpi2EventDataIrConfigChangeList_t, ConfigElement);
+		u16 max_elements = 0;
+
+		if (data_len > hdr_size)
+			max_elements = (data_len - hdr_size) /
+			    sizeof(MPI2_EVENT_IR_CONFIG_ELEMENT);
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

