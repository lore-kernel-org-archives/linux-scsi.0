Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794996787;
	b=LvqNQvcsNbhHCoMzqV3emaAZj6OtCHRXsGyGuA8q8TKZ+v+Tjyg4zE9UKlAJ0T9k0PVi
	 vTI9l2CrywMI8vJaFqhQ4DMKtqCnP1oz8alVcy+raJpcIVKACA/t+TDmFgQwRHxbtOqZ0
	 quJ01KliVXt4uEGrYtwh7PeiX0iSRpRtSTVM8L0vXO7GDZjDUq864eooIbCUcticyagG1
	 x2fBGT149byo6FO9R99/aj0cb6NewiN3aONv2nlE+3FyqvVOQShUp+r087QmsUX/cPIEd
	 rLfS7qsizKKsRIxWzOt8+ABrFzU11N169xU6iLaL9ICPGGNa/vFay/6Lfy4KQeI5YZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794996787;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=/XoNfe30G6z4mLXoi2VJBYhXSNP0t4XcHKlKoMeUePI=;
	b=2bDOjRISc1jr0mTpGsNRBpAPUwN9pGFZs1U6lMxbnrXFZZoWPumdDRmNQvB1RqIiwhHq
	 8K+6CKF/pknG92faLalmuFPuV9vJ1+bU31ZrP+HuJ6oRAG6/y70Pa1xkjeas0x+SLAw1M
	 QswXboL2QHyRuzCqL136AcJ9WzHKEvhCWne/+kIsF+SrcNQU5MiuMYrBUxVwKlIcMPwma
	 8CPJ6rbrTtcpRlsecYbalV5CA/EhDc1wUlDoX+hwSvoUsLvi2S0mWppWfzDxzKWqXAM3P
	 7+AMdp0DzoDDKBp+MbXrHOnkNd93RHQ6zeG29AgDTGOVXcr5C7IsaWht28saRPMj4dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b="gXVqw/Lg";
	arc=none smtp.remote-ip=209.85.216.100
Received: from mail-pj1-f100.google.com (mail-pj1-f100.google.com [209.85.216.100])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80055606A31C
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:13:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 80055606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=gXVqw/Lg
Received: by mail-pj1-f100.google.com with SMTP id 98e67ed59e1d1-3ada4c06b7bso415905a91.2
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:13:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794996786; x=1795601586;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/XoNfe30G6z4mLXoi2VJBYhXSNP0t4XcHKlKoMeUePI=;
        b=lYeVPSiwqfZOHXeDRJ10ditpSJmVx0BWu8CiIMjJNUtavkRDrU3yVvhnDLtFD/DtbC
         Bz8Xu6PVmPoyIB03Mn7k/OdmApF5u9K0HWkK/Wa83mfizLCxa+TR1PoDv0DpY7jqjKZs
         u1vcg2Q5PeXQV8PjaJZ62LMbzLaWl1d4beCbrVo80DtpU9fhHWOjoxV6olEavAXxcvMB
         I+aiWP3PPCiCDmrn7pzKowr56TZEqWukGHHTHTUn2Nk2IlmJmKdFCD9F6i7MZb2usHe7
         P6beLRStUbjkX4zSTP7KR+u4xm2JmbSXc/L7S+VLO2M/XWDzBoxSCMjvzNXFa4fJBu9F
         wgNA==
X-Gm-Message-State: APuU4Z8/s7sf3cd8R67cle95LKr6IrmRcnzP1ZEm3uK94OxKRSTR0Qt2
	nZklzSUhQmaptbQo44/eh1MQ3Ko8Bx7i4Cl98VuTbUjuRbLONiU8/C+WOnDfPPFtCCO9NeruJsL
	G6eKhAzcxF+qzJXuVaFjLVNCwsPFViy8KCupcDIsuv/j00hE9jh/NTio2rIQMLtoPQ/NXT3Ie/u
	z2UbcI5e1AZ/8DAfKokqfP6ZBY2IR3xe7h4DPRnA2K82Kt558vXqCtf5bj9OcitW4KSoTv1TKhq
	ILuWgbHXcaHT0vmSjOeklNhGZqOFlOfGs4=
X-Gm-Gg: AZFdTZet/ynh+L1yVPda55XNcpuKi2kjXr5ScVMxbCsT6KB7/KJPglcsRJdWOD9Gyah
	vDrg8aTp2ruI55HHq70cvVGDfZ3+fFQkVl8d6xqA/I9uOP5loaZaspcCSkPcIoGNvpbXu/Q9yFM
	qUkbSMgnfjQnTpEU0VHoF3WgtJVRNH+xp69gGQ/Fz3yQXE7M/mIphGll4vHrnH5vNH/OzAyH4RS
	CcVM/hhEBNcnnfCJLvIDglyVUxyFTfUDvmzMAfVu4mdud0eJfRr41Pu0jJUD/igyWGp25uJH7rN
	vWMGF/huY7thblylW/bBedi8IZuVYYK0goYTbabsjdIJV9125Z4s7mPZckGd9IfTmG6M/fEQRK+
	gYP0i/MUcWYYaohBqORANO0/plfT+kbkRGasxpTWuBQTAR0MRA07d7vt2Q32v2LNek6xyjs8SuB
	A67HN6PhNXf3mlRPDBNstrMvHrqSypSCi2E+3XIlouOhdZsPggoQpG6g==
X-Received: by 2002:a17:90b:4c4b:b0:3b3:b858:cc96 with SMTP id 98e67ed59e1d1-3b3d07c9ea7mr2458256a91.46.1794996785822;
        Wed, 18 Nov 2026 02:13:05 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b3abb84fe8sm3893056a91.2.2026.11.18.02.13.05
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:13:05 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3ac8f449d1bso627940a91.3
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:13:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794996784; x=1795601584; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=/XoNfe30G6z4mLXoi2VJBYhXSNP0t4XcHKlKoMeUePI=;
        b=gXVqw/LgS7Jl1IHVTz2cYaGs7HVLW9QOTBlX7YFyfY6CPx2ji40IOTDnJfrL3RzeGh
         6q5PQMikQJXH5JwGlb6BXN3NWR94tR8BAwG0MTdtE4AoiB5ub1+JCcF37c/PBlLP6gre
         tCsw/bINsXA5w2ENp16CLX3yXxUNS9VeuXcx8=
X-Received: by 2002:a17:90b:4a12:b0:3a0:7261:d58e with SMTP id 98e67ed59e1d1-3b3d0764a4cmr2326374a91.22.1794996784112;
        Wed, 18 Nov 2026 02:13:04 -0800 (PST)
X-Received: by 2002:a17:90b:4a12:b0:3a0:7261:d58e with SMTP id 98e67ed59e1d1-3b3d0764a4cmr2326345a91.22.1794996783507;
        Wed, 18 Nov 2026 02:13:03 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3ac6016c3sm8740707a91.15.2026.11.18.02.13.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:13:03 -0800 (PST)
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
Subject: [PATCH v2 18/37] scsi: mpt3sas: Clamp firmware reply copies to the allocated reply buffer
Date: Wed, 18 Nov 2026 01:56:27 -0800
Message-Id: <1794995806-5835-19-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Clamp MsgLength-based memcpy()s of firmware replies to ioc->reply_sz
across the driver's completion handlers.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c      | 6 ++++--
 drivers/scsi/mpt3sas/mpt3sas_config.c    | 2 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c       | 3 ++-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 5 +++--
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 2 +-
 5 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 995228da8f77..dca07b97dfb4 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1459,7 +1459,8 @@ mpt3sas_base_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 	ioc->base_cmds.status |= MPT3_CMD_COMPLETE;
 	if (mpi_reply) {
 		ioc->base_cmds.status |= MPT3_CMD_REPLY_VALID;
-		memcpy(ioc->base_cmds.reply, mpi_reply, mpi_reply->MsgLength*4);
+		memcpy(ioc->base_cmds.reply, mpi_reply,
+		       min_t(u32, mpi_reply->MsgLength * 4, ioc->reply_sz));
 	}
 	ioc->base_cmds.status &= ~MPT3_CMD_PENDING;
 
@@ -7689,7 +7690,8 @@ mpt3sas_port_enable_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 	ioc->port_enable_cmds.status &= ~MPT3_CMD_PENDING;
 	ioc->port_enable_cmds.status |= MPT3_CMD_COMPLETE;
 	ioc->port_enable_cmds.status |= MPT3_CMD_REPLY_VALID;
-	memcpy(ioc->port_enable_cmds.reply, mpi_reply, mpi_reply->MsgLength*4);
+	memcpy(ioc->port_enable_cmds.reply, mpi_reply,
+	       min_t(u32, mpi_reply->MsgLength * 4, ioc->reply_sz));
 	ioc_status = le16_to_cpu(mpi_reply->IOCStatus) & MPI2_IOCSTATUS_MASK;
 	if (ioc_status != MPI2_IOCSTATUS_SUCCESS)
 		ioc->port_enable_failed = 1;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
index ff58a5329074..88dba4598d70 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -263,7 +263,7 @@ mpt3sas_config_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 	if (mpi_reply) {
 		ioc->config_cmds.status |= MPT3_CMD_REPLY_VALID;
 		memcpy(ioc->config_cmds.reply, mpi_reply,
-		    mpi_reply->MsgLength*4);
+		       min_t(u32, mpi_reply->MsgLength * 4, ioc->reply_sz));
 	}
 	ioc->config_cmds.status &= ~MPT3_CMD_PENDING;
 	if (ioc->logging_level & MPT_DEBUG_CONFIG)
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 5db233d21f01..7c5db14645ca 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -274,7 +274,8 @@ mpt3sas_ctl_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 	ioc->ctl_cmds.status |= MPT3_CMD_COMPLETE;
 	mpi_reply = mpt3sas_base_get_reply_virt_addr(ioc, reply);
 	if (mpi_reply) {
-		memcpy(ioc->ctl_cmds.reply, mpi_reply, mpi_reply->MsgLength*4);
+		memcpy(ioc->ctl_cmds.reply, mpi_reply,
+		       min_t(u32, mpi_reply->MsgLength * 4, ioc->reply_sz));
 		ioc->ctl_cmds.status |= MPT3_CMD_REPLY_VALID;
 		/* get sense data */
 		if (mpi_reply->Function == MPI2_FUNCTION_SCSI_IO_REQUEST ||
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 2355080f5f97..a25e2aed266b 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2941,7 +2941,8 @@ _scsih_tm_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	ioc->tm_cmds.status |= MPT3_CMD_COMPLETE;
 	mpi_reply =  mpt3sas_base_get_reply_virt_addr(ioc, reply);
 	if (mpi_reply) {
-		memcpy(ioc->tm_cmds.reply, mpi_reply, mpi_reply->MsgLength*4);
+		memcpy(ioc->tm_cmds.reply, mpi_reply,
+		       min_t(u32, mpi_reply->MsgLength * 4, ioc->reply_sz));
 		ioc->tm_cmds.status |= MPT3_CMD_REPLY_VALID;
 	}
 	ioc->tm_cmds.status &= ~MPT3_CMD_PENDING;
@@ -7433,7 +7434,7 @@ _scsih_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	ioc->scsih_cmds.status |= MPT3_CMD_COMPLETE;
 	if (mpi_reply) {
 		memcpy(ioc->scsih_cmds.reply, mpi_reply,
-		    mpi_reply->MsgLength*4);
+		       min_t(u32, mpi_reply->MsgLength * 4, ioc->reply_sz));
 		ioc->scsih_cmds.status |= MPT3_CMD_REPLY_VALID;
 	}
 	ioc->scsih_cmds.status &= ~MPT3_CMD_PENDING;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index b03422fe86fb..e88205b69067 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -305,7 +305,7 @@ mpt3sas_transport_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 	ioc->transport_cmds.status |= MPT3_CMD_COMPLETE;
 	if (mpi_reply) {
 		memcpy(ioc->transport_cmds.reply, mpi_reply,
-		    mpi_reply->MsgLength*4);
+		       min_t(u32, mpi_reply->MsgLength * 4, ioc->reply_sz));
 		ioc->transport_cmds.status |= MPT3_CMD_REPLY_VALID;
 	}
 	ioc->transport_cmds.status &= ~MPT3_CMD_PENDING;
-- 
2.53.0

