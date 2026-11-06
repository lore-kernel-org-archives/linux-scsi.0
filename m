Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.98
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793926754;
	b=sKJCZQW1LL89Z3adHXYSc06bbbC/MFb/7jVuxkyPStIvYhi+Z9x38LArlO/JmsVIRqtd
	 IKeSQVQOP8v+fHMRE+reCVUwb04hpQpOv6mzQMi4UhroAFr15ppLjVEivEstBKmFPdVuW
	 TapqQdKTBHakkAfX92LZP2xdFrfHla8s0FZUsv1Hs34SIMGKmoCQ8wpubzU3g2WVRfAZm
	 mHBg2a0MKhqDUAAQd3kSqk/BCyGKdtFrrGjNbzq5CK31zqxl0PIMzZ2g+v21H/fq1kqlj
	 NWdpxd4M9/81OU+o+qoQ82p4cjLxlXz8JdbunBh7OZJX+5MKGFGio+97QOht63QROLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793926754;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=BQGD81FEu8+ELksa5krilST/Uboj7Vtc3c5GBy5W+KU=;
	b=agacMTAXAuiqfeAMEYX9LmHTGwOMCufCFrAgqf+JC5iyAJ6GJxpJ8Pxxm5b4xLVPJ0ih
	 sMHsHU88krA91AlwRWMDGhbEcVGMN5MZ3fvGWKR5vk8flex/aYGqC68lInHpmw8Gi2lKR
	 H/toNFDL8CxuLm6MRWOY5SWSr7puvrza9MoDcSe5+zp0eEhmzJmV1/5PlVH6v6hW2ouEe
	 EqlsFLvVO53z1fNGMpRUD/mT+yl9v4k+i9wsXq7RD67NvLmGYbAegcb6VfXOO0BmJ/E/4
	 OusB4blchRh4B0/0Yz9h9PGcMGVKrIjMISjRD5+VZQjmL2Z6M8hfm8ACi3csR/8CZCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=A8OINi6z;
	arc=none smtp.remote-ip=209.85.216.98
Received: from mail-pj1-f98.google.com (mail-pj1-f98.google.com [209.85.216.98])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935FA606A326
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 00:59:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 935FA606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=A8OINi6z
Received: by mail-pj1-f98.google.com with SMTP id 98e67ed59e1d1-3b09a65c76dso95062a91.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:59:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793926748; x=1794531548;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BQGD81FEu8+ELksa5krilST/Uboj7Vtc3c5GBy5W+KU=;
        b=yVnCBcKuqKMpGDWZjh62ap0H417/UvSW4zByJcdW28fE+swjusbWslXNwKgoeTH6bA
         IhUwpUsYb//yK3/QmKDaxPggkGTugThm/8vaFLYc1L94TyPBzDuU60cqtSgChIJcuoA/
         jROWlLpv/IJuz2Lx0BPhbC6YS/ecQfZKRFS2Zd3+P2zuJS3+Lrkjr/c+k7/caZrcixwZ
         fn5cRHWa7yL1bufsJec8yrGm2yczZKtL3vDgpr8t7hUedBqyzO9ZRHSykpWD0G6/Vx8Z
         HVGbtLyRpuM9UV6LW54FVUUu5UD6eyUqfNnX7KtEPDhVEDA/YvYBdmt7G1MQxxNJG9VW
         gbxQ==
X-Gm-Message-State: APuU4Z8lig969OJfbcQqklN9UHZUgiUgGQwHvqUwOaSAgw7Sz6kwYJks
	qDn1tmv4xw1Fjp04uAS7tfRi3aG6zlHfKI8ud394CtpAO6p+qFusrmNm1M0Q6YzK4unQNNxqvQw
	dInSIKWvrgT8eBmYcxrpM3+A0YnJqVu5ufGWEmTURYYMAFxuYSLg/4fdES7aOx+kNkmDT21wUx1
	XdRn0FqoCigXkdj8FGqTT/IELyjyEWGdov0lIdsDgyhkZHQ60KEy4hlG17uIz1jH0jDYVWFcehS
	648WBpJ6HP/PsEWrlHwIhZHjdXI/RByoVU=
X-Gm-Gg: AYBFou18YT/HhaIHhymPy7jvPWOb9FbQLuK6OA10TR1UhjrzYGV/xCGncBsnHo0zJc6
	oBaxU2QKVLQaaZKTQUbSe8bsKNUWj67/b9nb7z1R0/o8tarYC/a0trDS5cKOnjD9JXkppQMVrJv
	Vc4k9Xfx7TlXP3jPVIR0OKkL8HpYYHAOZl6hEFdqElThvulvdO7Xn8md1xwhI6rchNsdftlEOZ5
	df+hhwHihG64yiFei1JN89+QHloCwFKjDGEXMfg8SLQOFx+HbA3mEMN7/zJOhTwqUGn3cETPDEo
	eZkdB6A3wT3IblTFOyyUgJxwfH119/A2/rVVkuN2DakZXj/cKUP2UuHgnS3yiMqtnr/TPJdNRem
	4mjUUMiCtqNUxfYi7KjV9h6AFF97VvmReVNt1d723jWkKcuQl67hScULdnf003uLIjOdtCLxNjS
	aJNuSfy0DuEomMRUY/1irbqrKMt0vSxBbPdmCiDiYVJ9g7zQtKCAfC3g==
X-Received: by 2002:a17:90b:5410:b0:3ab:5832:727d with SMTP id 98e67ed59e1d1-3b0db6e7fa8mr788798a91.35.1793926747792;
        Thu, 05 Nov 2026 16:59:07 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b0d7e280e0sm711208a91.8.2026.11.05.16.59.07
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:59:07 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ed08904845so1607395ad.3
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:59:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793926746; x=1794531546; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=BQGD81FEu8+ELksa5krilST/Uboj7Vtc3c5GBy5W+KU=;
        b=A8OINi6z+dnCj5V1O9EKEpijCXFsrXPXakT1PZ/VAQ/eB+4UHVUHy1nS2j7cNe5m59
         /lDxlfzHP17f7VqZxRfcfeOmFkjLk3AiQjU4oYsemBMy3H5zA4ZO/sYTVZRLMw0H3Gl4
         a4Qu9HjQoX/wv7l+6QH/Gr+VMe2gh4xkXr52s=
X-Received: by 2002:a17:902:f60c:b0:2ed:3eeb:b0d0 with SMTP id d9443c01a7336-2ed416abce0mr14673125ad.13.1793926745936;
        Thu, 05 Nov 2026 16:59:05 -0800 (PST)
X-Received: by 2002:a17:902:f60c:b0:2ed:3eeb:b0d0 with SMTP id d9443c01a7336-2ed416abce0mr14672895ad.13.1793926745435;
        Thu, 05 Nov 2026 16:59:05 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed47d7b8cfsm450745ad.57.2026.11.05.16.59.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:59:05 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 18/37] scsi: mpt3sas: Clamp firmware reply copies to the allocated reply buffer
Date: Thu,  5 Nov 2026 16:42:33 -0800
Message-Id: <1793925772-1303-19-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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
index f0ed1bea64bb..4e2cee2e13fc 100644
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
 
@@ -7679,7 +7680,8 @@ mpt3sas_port_enable_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
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
index ddbccbac69b3..2b5e42255d3b 100644
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
index 4866b3c7d1c1..6df51aa7bcaa 100644
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
index 066378a00fa4..59ec75e0736e 100644
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
index abb46a5e1c1a..32db07ed808a 100644
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

