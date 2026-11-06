Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.227
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793926715;
	b=pul2Ye8cUOizpJHMbnecC29W88W0QVdEKqWSobnNyYOD1FsPuMn2IMZDyfoq6yCdKoQA
	 oRrFG1d2/6QZ/ZPPbnGcfsmNbxoNztuaciKvb0oV9dLGFW4wlxHweXydShDswqqJLDbZ6
	 y60y3BkQbQK52WkumQ8lDxcfn2F4Puy1yGSTA2Dh9rqTUARrntROHJg63e28Zt9BC44qx
	 ww02YLct6fLOrkh0cHV9ACdpLHr5SlAVPveZ8nyEECx8ngfFFrDoTtXeKjNE0mag5Phdi
	 AQNlBZVQU7PUhtEQs3LmktVZCIBT2oYjwdFWOKlvOqA3NFM/yl961spPUiKvu53sVfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793926715;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=1f7XHNl5P0nLse+G7I6vckULqLjIbOPQkT6j+6l2lQk=;
	b=wlHTzkjn5zDERkW1WGue8m6mjW3U8OLccXk7cqEF/axFoXZim2//sMiiP4qu2XiKW+eW
	 nz+v2Nlcd43GGkAG/JWAMwAsepvO/RA9cO8XmWnB71f5oSm8YgwiPGNxJ2Gl+ZH8vHaSc
	 iiegI2NpNft75TiAGCagDM/Dg2ScTVtmow2Uo3/X2FbuYK6+uWDggdnw9QKKlRaK/BLEX
	 496APj2SnPXQWvRV751wTAW9eQZoal53w4xBW3gQjYUl4ESFM/HNjgvYLUToNrUDniVcy
	 s0mRTFYmr1/Cm/STuaLmwp1pYDeNQeOfmPSChnOc7+2iEZDSikv74mmbMk2ggOMymlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=W++7c8wN;
	arc=none smtp.remote-ip=209.85.215.227
Received: from mail-pg1-f227.google.com (mail-pg1-f227.google.com [209.85.215.227])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C13C606A31B
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 00:58:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9C13C606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=W++7c8wN
Received: by mail-pg1-f227.google.com with SMTP id 41be03b00d2f7-cd60c5da24cso59419a12.0
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:58:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793926714; x=1794531514;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1f7XHNl5P0nLse+G7I6vckULqLjIbOPQkT6j+6l2lQk=;
        b=NJhw2zrZUetPj+j0cGnc3Ub0f5bJ5TpdJqCxz/vPTbioHyP8TtpGjzNnTnRaTciTkQ
         LZbxAcQTU/PGbyAvPlUUSd/SBgID8chPPYuCRzkjp2FFjCVZoKY2JeU811Mi4KQy3cke
         gNqRcn9u44bQKoPWP5Fy8k9GGwsHDe3Hu3JDK5s8Qu58QfF9kGFcTqJo8kgIbNl6GTBy
         sjsmkIc7N5VUExCkgC/9rLkdLYrJzJ7s7bJn6YpZQ9CtLU8pSGfwI9bl2vxKizcgNFHp
         4wLiwsRfgHZRJX1UAk7NMR9O50hjzjrlWJGAkQqR2+00FCd/753hbVZmE1HAaeFqT0gU
         cEtw==
X-Gm-Message-State: APuU4Z/oBVbK1hP338IQiSbctMtC2lFGME9ejP1i8RqxrO2mrR3W6ARz
	bwbCyCF/7H8SE6etHwEafXzOKkOUjhQgcd8UNQPApEpbiMqZgXZ+/3PGxLcAkfzsdDvkbFobpos
	ziBNKVYGU24s8LPevl0ajLyo6xZiPM6fwXI544YJsyI2LNC3lbq8jFs2WIBuTsJcSfB2HLS2yLy
	1ElxFYAE6Jc+RHvjhIjU7l2rBfIRIhjSc2ck5UYj5YbRmBBMmtLHR7GffL1cf41m+VhRB7P8/Bh
	RXQ/r/WO+bKErkmbpK4otalOGk1O1Clwic=
X-Gm-Gg: AYBFou3Q8xWz7TlrNz80EjPAcXxV6AF/7pm/f751KpUc9SYLfBwVDtsBzBFa0EnfpXw
	9Dq+YdUdoHrOrWN6y0Ve/T79cF09BlGEaJMoDzAr+hEFc7NlFEwEVJiHiJIeSxpUnHxmS7sj7aV
	FvgorHCCRR9BDKFjhXnXEjwXvlsVMjsX5+0MEJs4cJhUr3bORAV4t1NIZfLbGwtOXq16HN1gtZL
	XFZslTGBFVdRxGmWDmIIuI7s/0tpTv2Zkupn+M/lWIF45AI2QvLTuMc2p1zDf5P9NhFq3Z46JfY
	6y8Q3HOorGJKr5VGYU59dbfFh7DJTZlN+JHMOU5GoXi6XyXIuuhiE2HRxOVnNIIGU5NJwkXhMfj
	GcM/Crk5HhbOqtdLJn1e1RtzXYpAzGfb5a8xNDcN5t+rL/MgVqDJg6Wn/4gFh9jm3fn9gconPfA
	6fxVF8aKXXdqXExSYmYGBtymfAhBNNqL5+bqqHGg7y8dT24mmvStCdAg==
X-Received: by 2002:a17:90b:224a:b0:3ac:9c37:9418 with SMTP id 98e67ed59e1d1-3b0db6a7db5mr769102a91.19.1793926713719;
        Thu, 05 Nov 2026 16:58:33 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b0d7c9e095sm757946a91.2.2026.11.05.16.58.33
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:58:33 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2ed276af91dso1799195ad.3
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:58:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793926712; x=1794531512; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=1f7XHNl5P0nLse+G7I6vckULqLjIbOPQkT6j+6l2lQk=;
        b=W++7c8wN6y2Ft+Ni+k96bmw1ASaRuBNSYw6SB6769Xj6Dlzk8piaoc84xYvbeJx8xs
         k23XndeCIEkJC+FiwcCTYHUzaCQUFz6ElFtt8Vc2mG6U+dwNjeQCxRF513UAofIUO6LE
         zD8rWgMYYcYh4LIbvSOuSqDXg7jXzbGi6+k1g=
X-Received: by 2002:a17:903:2f91:b0:2e9:5829:9b41 with SMTP id d9443c01a7336-2ed41bfa794mr12801245ad.37.1793926712040;
        Thu, 05 Nov 2026 16:58:32 -0800 (PST)
X-Received: by 2002:a17:903:2f91:b0:2e9:5829:9b41 with SMTP id d9443c01a7336-2ed41bfa794mr12801005ad.37.1793926711398;
        Thu, 05 Nov 2026 16:58:31 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed47d7b8cfsm450745ad.57.2026.11.05.16.58.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:58:30 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 08/37] scsi: mpt3sas: Validate firmware/user supplied device handles against MaxDevHandle
Date: Thu,  5 Nov 2026 16:42:23 -0800
Message-Id: <1793925772-1303-9-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Firmware-supplied (and ioctl-supplied) device handles are used to index
driver bitmaps and look up devices without being checked against
ioc->facts.MaxDevHandle. Add the check in the event, discovery, post-reset
scan (including the physical disk handle) and TM/control completion paths.

MaxDevHandle is an exclusive upper bound, so also change the passthrough
handle check in _ctl_do_mpt_command() from > to >= so handles at the
boundary are rejected.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c   |  2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 74 ++++++++++++++++++++++++++--
 2 files changed, 72 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 39e063d5a55c..a3d725e5f640 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -787,7 +787,7 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 	    mpi_request->Function == MPI2_FUNCTION_NVME_ENCAPSULATED) {
 
 		device_handle = le16_to_cpu(mpi_request->FunctionDependent1);
-		if (!device_handle || (device_handle >
+		if (!device_handle || (device_handle >=
 		    ioc->facts.MaxDevHandle)) {
 			ret = -EINVAL;
 			mpt3sas_base_free_smid(ioc, smid);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index f2a1cedcdae4..aaab6c4673c1 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -4399,6 +4399,12 @@ _scsih_tm_tr_send(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	u8 tr_method = 0;
 	struct hba_port *port = NULL;
 
+	if (handle >= ioc->facts.MaxDevHandle) {
+		ioc_err(ioc, "handle(0x%04x) out of bounds in %s\n",
+			handle, __func__);
+		return;
+	}
+
 	if (ioc->pci_error_recovery) {
 		dewtprintk(ioc,
 			   ioc_info(ioc, "%s: host in pci error recovery: handle(0x%04x)\n",
@@ -4659,17 +4665,25 @@ _scsih_sas_control_complete(struct MPT3SAS_ADAPTER *ioc, u16 smid,
 {
 	Mpi2SasIoUnitControlReply_t *mpi_reply =
 	    mpt3sas_base_get_reply_virt_addr(ioc, reply);
+	u16 dev_handle;
 
 	if (likely(mpi_reply)) {
+		dev_handle = le16_to_cpu(mpi_reply->DevHandle);
 		dewtprintk(ioc,
 			   ioc_info(ioc, "sc_complete:handle(0x%04x), (open) smid(%d), ioc_status(0x%04x), loginfo(0x%08x)\n",
-				    le16_to_cpu(mpi_reply->DevHandle), smid,
+				    dev_handle, smid,
 				    le16_to_cpu(mpi_reply->IOCStatus),
 				    le32_to_cpu(mpi_reply->IOCLogInfo)));
 		if (le16_to_cpu(mpi_reply->IOCStatus) ==
 		     MPI2_IOCSTATUS_SUCCESS) {
-			clear_bit(le16_to_cpu(mpi_reply->DevHandle),
-			    ioc->device_remove_in_progress);
+			if (dev_handle >= ioc->facts.MaxDevHandle) {
+				ioc_err(ioc,
+					"handle(0x%04x) out of bounds in %s\n",
+					dev_handle, __func__);
+			} else {
+				clear_bit(dev_handle,
+					  ioc->device_remove_in_progress);
+			}
 		}
 	} else {
 		ioc_err(ioc, "mpi_reply not valid at %s:%d/%s()!\n",
@@ -5220,6 +5234,11 @@ _scsih_check_ir_config_unhide_events(struct MPT3SAS_ADAPTER *ioc,
 		if (element->ReasonCode != MPI2_EVENT_IR_CHANGE_RC_UNHIDE)
 			continue;
 		handle = le16_to_cpu(element->PhysDiskDevHandle);
+		if (handle >= ioc->facts.MaxDevHandle) {
+			ioc_err(ioc, "handle(0x%04x) out of bounds in %s\n",
+				handle, __func__);
+			continue;
+		}
 		volume_handle = le16_to_cpu(element->VolDevHandle);
 		clear_bit(handle, ioc->pd_handles);
 		if (!volume_handle)
@@ -8397,6 +8416,12 @@ _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 retry_count,
 	u8 connector_name[5];
 	u8 port_id;
 
+	if (handle >= ioc->facts.MaxDevHandle) {
+		ioc_err(ioc, "handle(0x%04x) out of bounds in %s\n",
+			handle, __func__);
+		return -1;
+	}
+
 	if ((mpt3sas_config_get_sas_device_pg0(ioc, &mpi_reply, &sas_device_pg0,
 	    MPI2_SAS_DEVICE_PGAD_FORM_HANDLE, handle))) {
 		ioc_err(ioc, "failure at %s:%d/%s()!\n",
@@ -9184,6 +9209,12 @@ _scsih_pcie_check_device(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	struct MPT3SAS_TARGET *sas_target_priv_data;
 	u32 device_info;
 
+	if (handle >= ioc->facts.MaxDevHandle) {
+		ioc_err(ioc, "handle(0x%04x) out of bounds in %s\n",
+			handle, __func__);
+		return;
+	}
+
 	if ((mpt3sas_config_get_pcie_device_pg0(ioc, &mpi_reply,
 		&pcie_device_pg0, MPI26_PCIE_DEVICE_PGAD_FORM_HANDLE, handle)))
 		return;
@@ -10450,6 +10481,12 @@ _scsih_sas_pd_add(struct MPT3SAS_ADAPTER *ioc,
 	u64 sas_address;
 	u16 parent_handle;
 
+	if (handle >= ioc->facts.MaxDevHandle) {
+		ioc_err(ioc, "handle(0x%04x) out of bounds in %s\n",
+			handle, __func__);
+		return;
+	}
+
 	set_bit(handle, ioc->pd_handles);
 
 	sas_device = mpt3sas_get_sdev_by_handle(ioc, handle);
@@ -10741,6 +10778,11 @@ _scsih_sas_ir_physical_disk_event(struct MPT3SAS_ADAPTER *ioc,
 		return;
 
 	handle = le16_to_cpu(event_data->PhysDiskDevHandle);
+	if (handle >= ioc->facts.MaxDevHandle) {
+		ioc_err(ioc, "handle(0x%04x) out of bounds in %s\n",
+			handle, __func__);
+		return;
+	}
 	state = le32_to_cpu(event_data->NewValue);
 
 	if (!ioc->hide_ir_msg)
@@ -11104,6 +11146,11 @@ _scsih_search_responding_sas_devices(struct MPT3SAS_ADAPTER *ioc)
 		if (ioc_status != MPI2_IOCSTATUS_SUCCESS)
 			break;
 		handle = le16_to_cpu(sas_device_pg0.DevHandle);
+		if (handle >= ioc->facts.MaxDevHandle) {
+			ioc_err(ioc, "handle(0x%04x) out of bounds in %s\n",
+				handle, __func__);
+			continue;
+		}
 		device_info = le32_to_cpu(sas_device_pg0.DeviceInfo);
 		if (!(_scsih_is_end_device(device_info)))
 			continue;
@@ -11224,6 +11271,11 @@ _scsih_search_responding_pcie_devices(struct MPT3SAS_ADAPTER *ioc)
 			break;
 		}
 		handle = le16_to_cpu(pcie_device_pg0.DevHandle);
+		if (handle >= ioc->facts.MaxDevHandle) {
+			ioc_err(ioc, "handle(0x%04x) out of bounds in %s\n",
+				handle, __func__);
+			continue;
+		}
 		device_info = le32_to_cpu(pcie_device_pg0.DeviceInfo);
 		if (!(_scsih_is_nvme_pciescsi_device(device_info)))
 			continue;
@@ -11324,6 +11376,11 @@ _scsih_search_responding_raid_devices(struct MPT3SAS_ADAPTER *ioc)
 		if (ioc_status != MPI2_IOCSTATUS_SUCCESS)
 			break;
 		handle = le16_to_cpu(volume_pg1.DevHandle);
+		if (handle >= ioc->facts.MaxDevHandle) {
+			ioc_err(ioc, "handle(0x%04x) out of bounds in %s\n",
+				handle, __func__);
+			continue;
+		}
 
 		if (mpt3sas_config_get_raid_volume_pg0(ioc, &mpi_reply,
 		    &volume_pg0, MPI2_RAID_VOLUME_PGAD_FORM_HANDLE, handle,
@@ -11350,6 +11407,11 @@ _scsih_search_responding_raid_devices(struct MPT3SAS_ADAPTER *ioc)
 				break;
 			phys_disk_num = pd_pg0.PhysDiskNum;
 			handle = le16_to_cpu(pd_pg0.DevHandle);
+			if (handle >= ioc->facts.MaxDevHandle) {
+				ioc_err(ioc, "handle(0x%04x) out of bounds in %s\n",
+					handle, __func__);
+				continue;
+			}
 			set_bit(handle, ioc->pd_handles);
 		}
 	}
@@ -11685,6 +11747,12 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
 		}
 		phys_disk_num = pd_pg0.PhysDiskNum;
 		handle = le16_to_cpu(pd_pg0.DevHandle);
+		if (handle >= ioc->facts.MaxDevHandle) {
+			ioc_err(ioc,
+				"handle(0x%04x) out of bounds at %s:%d/%s()!\n",
+				handle, __FILE__, __LINE__, __func__);
+			continue;
+		}
 		sas_device = mpt3sas_get_sdev_by_handle(ioc, handle);
 		if (sas_device) {
 			sas_device_put(sas_device);
-- 
2.53.0

