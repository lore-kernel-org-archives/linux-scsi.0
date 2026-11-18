Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.217.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794996779;
	b=dXpMpGnJTl69T4LAWPZ2AVW65kLM/XVWcgQkLYIitywDaKKcABUrc0fwR/hocFLT7n+S
	 i/9hp7TQfx7PcwsMgo2ODqFbZFEmk51vD7e940gvy1E3/alB4IHmXu/cwskVlg8ZCmCVj
	 TcKPLid2e5+7oYaE+FZ1Sr37I85iH4CbBid5MktSPawWKtpp+2LgqaD1bSg5YUZQDbRuQ
	 tOYEvJs9HHT6VhhJp8koY6GUTPR0NjVeKe5b5tsPmdUG1x9sJ6bpNRV8gZDkBKEHT1sJs
	 SlHBoVBuv6bh5Qy9cOpqKSgY0qO+g1qRM2KWkecJMaM9/snoAaf8aLENpDimQ7veuiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794996779;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=wf5V1pTeVy0KfuuseZCJo2z3RspWtJuZhZJziDBbC6g=;
	b=dL9CPJJgn5TrnpuSHSxF5ztAfwVf5u3pTtMfSebGZI41Gr8Z+Y/sF0D4mlq6ppJ3JaY6
	 fe2pBsUyOXtl4loikxYWydLuh6wvAX1vIHKcyIgJL6HhmVv3FTPEwA2glJNqLgzuph59u
	 YNGpu5hoMvTiP3AiW6PgzwOVDMMatuHyFAxe/utwvCToOWOb63b2MhOdEjFHKPCqT3TV6
	 HCEitv2BUf57wsdh/6Bu1tdayKS8w3djc55tJVC5TM4VhlnBVLwdyvdj7jNf/08GBjq/p
	 eomrTAxumfcSoDhTFKpa3qkcn4h8aYInWqEbsNJSraVpa6wl1MRHJUSaUelAFSfPHKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b="hk/8hxSO";
	arc=none smtp.remote-ip=209.85.217.99
Received: from mail-vs1-f99.google.com (mail-vs1-f99.google.com [209.85.217.99])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFDB606A31C
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:12:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DEFDB606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=hk/8hxSO
Received: by mail-vs1-f99.google.com with SMTP id ada2fe7eead31-7d2b25786d9so435148137.0
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:12:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794996778; x=1795601578;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wf5V1pTeVy0KfuuseZCJo2z3RspWtJuZhZJziDBbC6g=;
        b=VwypaMHvLCBOjQQhP4ER0llkxy2P3UFA1RmlxYYwVa+YhqxvVaxqcDLAihphs1g8T4
         TIDsZIiRJ0AlvfAnkFACVXoB780oQWzNbhdwoAtwuIJgaEaW16ZDIYJoPSwn82GJd7L2
         zBRBs/uHEsV+wYvUCp+7JSyYbjwn1GHKrvriob/s3ZfneUX+KfrYFHx+JQ/f0/s+yKQz
         AqZCaOgGQ6QkyyOA0jSpyO//9taPzJ7O6e1DtSzQMbeAs6zyOMCmK3CRwprED6kS42pI
         ab79ZxMzJ66eG5NHyT0/eVjxT82NqHN5+pp0N1cFc6ngBQz1OEmNE26jcx7bBGIvj6p6
         tNLA==
X-Gm-Message-State: APuU4Z8GkjhMli0f3AFGlZQnSb/cMjoTDlI+Xh/fC5iAldZb46Y+qUWM
	IDSt/6oL/srzO7hGinZUCXNcALwISRzNPDJr1yIpDHbOiWgMU9QA9Q3cmAcS4q6JBrj+lfOMrNU
	Djwumq+4rTYWReDS853OoT8eBzg4TqWYt0el4KSvG46JPk87A5lgN0atiflgntpnhDLYk8u6NHa
	IIuF/BCeEaYWNx74rDYh6dKN3iOhS6Cm9Cfk/MGfzKbqt8nXzANRPnUwnwapwOJz5Ho/snXD6C2
	x7LDvsgp4DubiD7dPoIVVAGsug9dHLTDyE=
X-Gm-Gg: AYBFou3qMUWIJilMqe+FcV5IHFe1+/zqccEUT+j5s3uJn616umo00Pnn8i7B34LsyPM
	T8uf0dy7ZMXz9W8eivagPzSohD7mDr1/mbwUf3/yWLs3ejGix3UNYvf2CYMSIJevikuAT0hvqJR
	6/x+48j/U7kRFCZRvdD2gLTGwKZ+eESkHW9YzRgCE532xDXySo8ah2eZutIdBXsdgkuMechjKtM
	/3EOX9TKga67gcM7LWkyN+wY8qIVPOKIDDgJ32SU11vcwtO7ouWggvOF4kSThe5Zs6byYOnODrb
	pDERERkxdI7h6GFiSrOOC4ZB/vWu+ocYJbaAqUU1U+sToqUHnbPdvFv3cmCbJaxX7dO6KN8XjUO
	07eIko/VxjaBZDcowOJA8eJ/tkfjz6DSG8xPgOy/P4eIgbTSRac5L+PdmVD9FP29eOIERGO7l4B
	bQMyYWNjk2AgYoTl3XgxkTLFQF+FpKEdJF2redh9rhSFFgrB+oS3vcr3j2
X-Received: by 2002:a05:6102:1499:b0:7d2:c786:5a95 with SMTP id ada2fe7eead31-7d6ba3bf996mr642646137.13.1794996777763;
        Wed, 18 Nov 2026 02:12:57 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-123.dlp.protect.broadcom.com. [144.49.247.123])
        by smtp-relay.gmail.com with ESMTPS id 71dfb90a1353d-5ee64e756d2sm27606e0c.15.2026.11.18.02.12.57
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:12:57 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2e987ec84afso7537815ad.3
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:12:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794996776; x=1795601576; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=wf5V1pTeVy0KfuuseZCJo2z3RspWtJuZhZJziDBbC6g=;
        b=hk/8hxSOZV+TQrfZC2d5aEKIMqF0BhfFB2cWx8qeRYwMNQJkOu/q6iVbaQqqq0f6OD
         aApv+skGRrJPtDcCaE03wLEa1J6HhhdtVF4rpKqzYrjwOoakWCVJh+m+YhIZJavzSBLU
         MhSgZCytzbJKVIcphLCh5VxlGmPXoPsWlcCk4=
X-Received: by 2002:a17:90b:4c4b:b0:3ac:83c1:2bd with SMTP id 98e67ed59e1d1-3b3d0764b26mr2485059a91.28.1794996776436;
        Wed, 18 Nov 2026 02:12:56 -0800 (PST)
X-Received: by 2002:a17:90b:4c4b:b0:3ac:83c1:2bd with SMTP id 98e67ed59e1d1-3b3d0764b26mr2485020a91.28.1794996775860;
        Wed, 18 Nov 2026 02:12:55 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3ac6016c3sm8740707a91.15.2026.11.18.02.12.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:12:55 -0800 (PST)
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
Subject: [PATCH v2 16/37] scsi: mpt3sas: Fix page fault from stale ioc->chip after PCI error recovery
Date: Wed, 18 Nov 2026 01:56:25 -0800
Message-Id: <1794995806-5835-17-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

NULL ioc->chip after unmapping it and guard mask/unmask_interrupts()
against a NULL chip pointer.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c   | 27 +++++++++++++++++++++++++--
 drivers/scsi/mpt3sas/mpt3sas_config.c |  4 ++++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c  |  8 ++++++++
 3 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index bd169e3f18fa..995228da8f77 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1645,6 +1645,8 @@ mpt3sas_base_mask_interrupts(struct MPT3SAS_ADAPTER *ioc)
 	u32 him_register;
 
 	ioc->mask_interrupts = 1;
+	if (!ioc->chip)
+		return;
 	him_register = ioc->base_readl(&ioc->chip->HostInterruptMask);
 	him_register |= MPI2_HIM_DIM + MPI2_HIM_RIM + MPI2_HIM_RESET_IRQ_MASK;
 	writel(him_register, &ioc->chip->HostInterruptMask);
@@ -1662,6 +1664,8 @@ mpt3sas_base_unmask_interrupts(struct MPT3SAS_ADAPTER *ioc)
 {
 	u32 him_register;
 
+	if (!ioc->chip)
+		return;
 	him_register = ioc->base_readl(&ioc->chip->HostInterruptMask);
 	him_register &= ~MPI2_HIM_RIM;
 	writel(him_register, &ioc->chip->HostInterruptMask);
@@ -3579,6 +3583,7 @@ mpt3sas_base_unmap_resources(struct MPT3SAS_ADAPTER *ioc)
 
 	if (ioc->chip_phys) {
 		iounmap(ioc->chip);
+		ioc->chip = NULL;
 		ioc->chip_phys = 0;
 	}
 
@@ -3682,9 +3687,11 @@ mpt3sas_base_map_resources(struct MPT3SAS_ADAPTER *ioc)
 		} else if (pci_resource_flags(pdev, i) & IORESOURCE_MEM) {
 			if (memap_sz)
 				continue;
+			memap_sz = pci_resource_len(pdev, i);
+			if (!memap_sz)
+				continue;
 			ioc->chip_phys = pci_resource_start(pdev, i);
 			chip_phys = ioc->chip_phys;
-			memap_sz = pci_resource_len(pdev, i);
 			ioc->chip = ioremap(ioc->chip_phys, memap_sz);
 		}
 	}
@@ -6740,6 +6747,15 @@ mpt3sas_base_get_iocstate(struct MPT3SAS_ADAPTER *ioc, int cooked)
 {
 	u32 s, sc;
 
+	/*
+	 * Registers are unmapped (e.g. after PCI error recovery/suspend).
+	 * Return a state value that matches no real IOC state, so callers
+	 * neither treat the IOC as FAULT (and try a register-based diag
+	 * reset) nor as READY/OPERATIONAL.
+	 */
+	if (!ioc->chip)
+		return MPI2_IOC_STATE_MASK;
+
 	s = ioc->base_readl_ext_retry(&ioc->chip->Doorbell);
 	sc = s & MPI2_IOC_STATE_MASK;
 	return cooked ? sc : s;
@@ -8137,7 +8153,7 @@ mpt3sas_base_make_ioc_ready(struct MPT3SAS_ADAPTER *ioc, enum reset_type type)
 
 	dinitprintk(ioc, ioc_info(ioc, "%s\n", __func__));
 
-	if (ioc->pci_error_recovery)
+	if (ioc->pci_error_recovery || !ioc->chip)
 		return 0;
 
 	ioc_state = mpt3sas_base_get_iocstate(ioc, 0);
@@ -8970,6 +8986,13 @@ mpt3sas_base_hard_reset_handler(struct MPT3SAS_ADAPTER *ioc,
 		goto out_unlocked;
 	}
 
+	if (!ioc->chip) {
+		ioc_err(ioc, "%s: controller registers are not mapped\n",
+			__func__);
+		r = -ENODEV;
+		goto out_unlocked;
+	}
+
 	if (mpt3sas_fwfault_debug)
 		mpt3sas_halt_firmware(ioc);
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
index eb51ce3610c8..2609b298af0b 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -304,6 +304,10 @@ _config_request(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 	struct config_request mem;
 	u32 ioc_status = UINT_MAX;
 
+	/* registers are unmapped (e.g. after PCI error recovery/suspend) */
+	if (!ioc->chip)
+		return -ENODEV;
+
 	mutex_lock(&ioc->config_cmds.mutex);
 	if (ioc->config_cmds.status != MPT3_CMD_NOT_USED) {
 		ioc_err(ioc, "%s: config_cmd in use\n", __func__);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 0b219fe87a0b..2355080f5f97 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -12497,6 +12497,10 @@ _scsih_nvme_shutdown(struct MPT3SAS_ADAPTER *ioc)
 	Mpi26IoUnitControlReply_t *mpi_reply;
 	u16 smid;
 
+	/* controller registers unmapped, can't post requests */
+	if (!ioc->chip)
+		return;
+
 	/* are there any NVMe devices ? */
 	if (list_empty(&ioc->pcie_device_list))
 		return;
@@ -12565,6 +12569,10 @@ _scsih_ir_shutdown(struct MPT3SAS_ADAPTER *ioc)
 	Mpi2RaidActionReply_t *mpi_reply;
 	u16 smid;
 
+	/* controller registers unmapped, can't post requests */
+	if (!ioc->chip)
+		return;
+
 	/* is IR firmware build loaded ? */
 	if (!ioc->ir_firmware)
 		return;
-- 
2.53.0

