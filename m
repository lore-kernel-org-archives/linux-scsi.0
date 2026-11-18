Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794996748;
	b=C8VlFgdniSwmYNQKWY9eA7PAO5rXrf8zoPgFz7E5xsG1hEDK+CBvuRyAouTsXSuPFZuX
	 qfQwIE2mBY/Ubucx9E0IlGO35WWCQW2qKP8XVyFgqjikeY5gUkMKggqBY8G55dgO6csSJ
	 KmoECLVPn3fuMB42IrjWoSGQdH7W0U2LVvsgIel7mQHP1vWTkfQfiOAsgwZsS92vYTpCn
	 tVpmdhd/jgHmZUAO2eL1gjnMBgEJZx6FX7nb+2kP1XP8fJFP75a5/WsL4cwHXRikW86ub
	 kTcTVuINrrsRAcXzUqvKgkP/BW+MdThgMh4WQo8wRJ33WfBT3W9BOgqWbljv69a4hVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794996748;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=KJ9nAu5G2j39HhA15ZpjOPHsUaQMW4Mkf+OJpcaT6ic=;
	b=4BQq45kj1y5D6UQko56gGobjlLexRl0hSanayOKrIXLbQnyWVP/eZeYjjs1BJe1IvIi6
	 +YsQUvQTypxc1YAVm+qjqk+ruukPKL60iJkLiNPhY/VEnXoBEqp2GspUu7NWdRhgHuUWM
	 Q8EyRAednAVb4Hi6X7Ggh6d8+yIkKGIDWJ3ku7vywifRtde7xB6SmwZ4YAqf49zp7mT4X
	 MbBIk+5V6lH7XzpEo/bRfWq7/lFbxYi1LBFgEB1Ehc8ALooBryAvY/fjfS69pFsJO/7DJ
	 hq/59S23TQRC5ztS8NJQSeBy+YyEvk5tfAJUUXDz7SuVrjnVUqDv/KiMM9eEFdH6cnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=gFpkKlzT;
	arc=none smtp.remote-ip=209.85.215.225
Received: from mail-pg1-f225.google.com (mail-pg1-f225.google.com [209.85.215.225])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41492606A31C
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:12:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41492606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=gFpkKlzT
Received: by mail-pg1-f225.google.com with SMTP id 41be03b00d2f7-cdb45e96d2bso553076a12.0
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:12:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794996748; x=1795601548;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KJ9nAu5G2j39HhA15ZpjOPHsUaQMW4Mkf+OJpcaT6ic=;
        b=KEjTj9KFtdOvwWb+XAD+O2Ln2n8Lv9pZiTu39qzSYMRXgrA2bFZWmvw+srWcmkPlXW
         7cpFlz8pd7vmAKJN9OUytxtUGE3fsYDKdWYlFOVJr2T9zlux0JtqGjyoH1AcpLgntkRp
         T0QzAEeQvn6JJA/GE0S253PjQ/pqGGURVsj+tx5dVqqA8/rfOGKDtK1pAzCw/paNvoOA
         Og//yd1hFwOiKYWl64pvV9Wg0BBgcU5/dHi8OTnSVWBoKro5+caiVMZkkkATX7YPDs4N
         KRk0xMSJPvzqTbSWTTuliGcJLooADkRkUzv4zQuDA77nO2h4dBzOAlBJkmVEmXkR1N7S
         Kj+w==
X-Gm-Message-State: APuU4Z9fyJURJgumZG4gu+K6mOPrYbGIp4FGmFoP9eO/hWqwOOn7ig4t
	JBGs/ToIGHEooN5GKSyCTClyqY9MNrU6k0CMPcQAcDPmje0qnvDFY5VjZMMpQLqqmD6ciPDYQDk
	r9Y9gCBnnzzTTj7FC0A0+oR+AqxL3F2fmSi7gLm5WGITIFvBgk3kIWqQiAhPptEIfVIps5jOETV
	to3q7ucb3D7xoU+yL7upa1xlkNTQCfg5b9dDWaVMXMC8Zs9QRstOb8wMRXZoKtYUOPUzVzOqyky
	c5w6Z4lirUJmBUhSQFF3zhWhj0MjnQ4dYA=
X-Gm-Gg: AZFdTZcRdCht/lxLbWo2aq6K3k3hfSsphca4wVmeRBtFBZbNnvt3xFW5QIEoTSsAPfz
	ZLB0xj1i6HolnODY4Eo0YgPgNNe/cI7Kmb9gssbVedlLhT5TFooet4a3sokUxZnK1dyl+irtztg
	20HW7BZX9riVnYftLpFjtI6xzKZvidoxCrB6zGVNp/lfGDUm3F3BA4yPXeNGEjHgntNI+lwR8qs
	FRyt6tG8sA1DTi6SVYR5bKkV1rdnYCzMLfWXyubF6WlHcLxff9I9xu3v+8PHlydfoG9jigiy8+B
	shOd2dS9uMHn68aiRwX47pQhBvkbaTMN+rVJ73H4BFY8AgDHEJXnDiNP58dyjDMBdBSXINApBuV
	yHgZL1+rvYVn+29n7+bgWxXVNAhkzi6n6aap3F61pikFtHEpiIrBH4JqzzpKYDZce7dDK9i5wK6
	9TnEuFuQw2aO3RE0yVUkknGNL2/YYkHf9lK7TMw16WRZfHrCGVihsEH7Mi
X-Received: by 2002:a17:90b:4b88:b0:3b1:ba59:56a1 with SMTP id 98e67ed59e1d1-3b3d07ca529mr2182002a91.39.1794996747398;
        Wed, 18 Nov 2026 02:12:27 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-123.dlp.protect.broadcom.com. [144.49.247.123])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b3d0eaa8eesm1582275a91.2.2026.11.18.02.12.26
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:12:27 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3ac8f449d1bso627379a91.3
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:12:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794996746; x=1795601546; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=KJ9nAu5G2j39HhA15ZpjOPHsUaQMW4Mkf+OJpcaT6ic=;
        b=gFpkKlzTuFBcMYAWUkr2FAJRdxpLddLgIXptToMOr573/Ot7MaAz0btux87d9TNTPg
         +1NyABoxuf63tSK+DaztY5yH+k6BBCaiaC/rdYpvN+8tnwtZdLbSXL6NJ/muB/53JRbc
         ZZRPelN2Aapd+6HpUapwHHZ5deqYmyPcLQt/0=
X-Received: by 2002:a17:90a:d886:b0:3b0:9bfa:72b1 with SMTP id 98e67ed59e1d1-3b3d07caebemr2485360a91.49.1794996745540;
        Wed, 18 Nov 2026 02:12:25 -0800 (PST)
X-Received: by 2002:a17:90a:d886:b0:3b0:9bfa:72b1 with SMTP id 98e67ed59e1d1-3b3d07caebemr2485328a91.49.1794996744984;
        Wed, 18 Nov 2026 02:12:24 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3ac6016c3sm8740707a91.15.2026.11.18.02.12.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:12:24 -0800 (PST)
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
Subject: [PATCH v2 08/37] scsi: mpt3sas: Validate firmware/user supplied device handles against MaxDevHandle
Date: Wed, 18 Nov 2026 01:56:17 -0800
Message-Id: <1794995806-5835-9-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 75 ++++++++++++++++++++++++++--
 2 files changed, 73 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index d8b1e60af940..a0d915678c02 100644
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
index 4bc2f7ce4aa2..184ed88fab55 100644
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
@@ -8397,6 +8416,13 @@ _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 retry_count,
 	u8 connector_name[5];
 	u8 port_id;
 
+	if (handle >= ioc->facts.MaxDevHandle) {
+		/* not retryable: drop the device instead of looping forever */
+		ioc_err(ioc, "handle(0x%04x) out of bounds in %s\n",
+			handle, __func__);
+		return 0;
+	}
+
 	if ((mpt3sas_config_get_sas_device_pg0(ioc, &mpi_reply, &sas_device_pg0,
 	    MPI2_SAS_DEVICE_PGAD_FORM_HANDLE, handle))) {
 		ioc_err(ioc, "failure at %s:%d/%s()!\n",
@@ -9184,6 +9210,12 @@ _scsih_pcie_check_device(struct MPT3SAS_ADAPTER *ioc, u16 handle)
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
@@ -10450,6 +10482,12 @@ _scsih_sas_pd_add(struct MPT3SAS_ADAPTER *ioc,
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
@@ -10741,6 +10779,11 @@ _scsih_sas_ir_physical_disk_event(struct MPT3SAS_ADAPTER *ioc,
 		return;
 
 	handle = le16_to_cpu(event_data->PhysDiskDevHandle);
+	if (handle >= ioc->facts.MaxDevHandle) {
+		ioc_err(ioc, "handle(0x%04x) out of bounds in %s\n",
+			handle, __func__);
+		return;
+	}
 	state = le32_to_cpu(event_data->NewValue);
 
 	if (!ioc->hide_ir_msg)
@@ -11104,6 +11147,11 @@ _scsih_search_responding_sas_devices(struct MPT3SAS_ADAPTER *ioc)
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
@@ -11224,6 +11272,11 @@ _scsih_search_responding_pcie_devices(struct MPT3SAS_ADAPTER *ioc)
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
@@ -11324,6 +11377,11 @@ _scsih_search_responding_raid_devices(struct MPT3SAS_ADAPTER *ioc)
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
@@ -11350,6 +11408,11 @@ _scsih_search_responding_raid_devices(struct MPT3SAS_ADAPTER *ioc)
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
@@ -11685,6 +11748,12 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
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

