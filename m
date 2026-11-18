Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794996847;
	b=l5/68YYNNJtPC3oLXfz/aHg+kRZdq2vFC5sZPSOZAGzlatU60AEr+uTHDIJS7JhxMH9O
	 nAUFgHbRkKOTqaDmLQBC3gBUh51tcea/OD6me6bxZ5yMBhlDzXgoGf23o4uEEoafS5Rk0
	 e7SrkejMAbe5OaeDMAlxZ5nsPLlRm8U8yl5lQEEY+fJj4hKYd8GCIrR4SZfFZaRAJuywg
	 C+innyuwdm7OXr2YzBQGRRzYJxrRJGZsDg57ur17ls3GDoO5knui+CscmLQ9ddK2yyiLl
	 fw7dHe7GNH1bD4B2Yht2WwNAscKY77Sigr05KKU48kQXYoJI5ZdSz4zSh+JRzoxyxZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794996847;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=BW0ZgeDgcOiV0Ehvz/rBcGltgwDLVw9HM18BH5WCVAM=;
	b=WmzISlvURO+WBlwjoNCicOaRSKnN2h1IzXsyWiVH/0bjSxamQuMWCAmI9w0pFiLSV4TR
	 ynjxrYloBj90NHGKQx+Z/OKGh8Vob4hZegBsQqWUxkF4Urue+lLQUQCnSuXp5nuN1Sa3p
	 f+JYwk34p/qAI9thD+nPpDhW0tZKWfOqIUAHIjJSXu6Ru1C1mLz0u6gxw+O3C2ejHk8fh
	 MeL0nXctzmmIWbgCet75noV2g4nPcXjbygrO+BkGNAnfYoBBdXQd+8aWMv8ZYJxDcf+SL
	 H7/scwyrM5VOkKAFwB+we7uJshhPP+kbK92G3cFCrY5wsHQ5D5yyVPJ2HFAeM1Xwsyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b="Ernkv/Nz";
	arc=none smtp.remote-ip=209.85.216.99
Received: from mail-pj1-f99.google.com (mail-pj1-f99.google.com [209.85.216.99])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC61606A334
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:14:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DCC61606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=Ernkv/Nz
Received: by mail-pj1-f99.google.com with SMTP id 98e67ed59e1d1-3b3b3c072eeso435687a91.3
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:14:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794996846; x=1795601646;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BW0ZgeDgcOiV0Ehvz/rBcGltgwDLVw9HM18BH5WCVAM=;
        b=FSrcfP5wW82csivOSrKytA8XdMGFJdy5M4gid3wUBPB/bLBjWN7EYPDGF5Tr4ZtqCk
         KWAhm1T63n+Iw9HyzS3CKqYf4pTu0YIYsmQg8k9ZYhPB+2SiymBJomUIEFyEVT5TRCCm
         IdcpEA3B5EylZyrT+RqwnCr41Z5C+2WcBYrC89CBODPdWnjBT+FSD/LnDsFiXJ4nR5KI
         bCBJtfZ0+ts23anzPJnFBFd0rtMEBkIXcJ7ro3qGpZmI1BAHEDQiL8QbURi+zg7UIAF2
         tyF7nQ31vV0OIOoGt8YyNqpSFv1qDOifngUnwwm2F/GvevrSQY3T+PMqlkD0MyWEg1ID
         JwjQ==
X-Gm-Message-State: APuU4Z/KGL2QtKbd5K1EmtxhAzBpTN7hPoHu95YZY6bgqXLGzDBaIa2R
	2I6i5hpJHPMkrsk5TkyOxgga1TLF9wcudvrAVCH9FgJejbDSM5P44rS4XLv3BbjnDIdQA9E7aqT
	YdlG6F2XB4K9/Emr66zl4aqmmCMHKFIsntnS75NQqz50U3bq+o6JpL8uRikQNgbJwZ74cSLr57O
	3P4Y5hxXhJipcOZQFGyGnAJn4kD4fbAThLCWcyPEY6TH+dIzifFs/NDq1RXUztnsm0HBTSYla2S
	fbVioYB+3O5F2T2owSNyfXFtMknJIJjm+M=
X-Gm-Gg: AZFdTZfJAjx03ELLZwq+SzCyR9bP4veO+VaUgKjcwn0zeKKLw5O4lg7NKbvhlCmhS5a
	pLNDQNRoYFLlLHGBAehIS3p9A05APZC06DAomoE1qAAeeqF+DYk05GeXH1wcpvf/W/324TyDoxA
	FRDtJ2R+x49d9Q0w+wbPaORxSQleBnvToO8TpC/RZB0R4067zfLgojcQI9t96z35x76eX+7tdAy
	XydegcOLcgLTCYdwQTOJrU4f8vsN7eaK8uheyRzX+ZZa2VPQIPfCAfsuh5Ys8KEyTk7oYW5WKVu
	g03Uhe0yIzfS1CjR2BMhLF310csXwzr5B8ZPqvgbz9A++PwfkXSiDoFvZhiEFSWLb1xD7z+kZab
	SBbxfp0fGYB+emb39DXg/B+NdsOYiFAMC8iBxrQGWYdjCLlhV7P0qIBUh8eHRjX5xu4aoVXWY1c
	RUGYvuDuUwWIe9zDZGKudzqsoIjcpz+GGFLKjZYx5Eo9IBbS8uzUbHTA==
X-Received: by 2002:a17:90b:2e0b:b0:3ac:8446:c1a5 with SMTP id 98e67ed59e1d1-3b3d07d81eamr1852110a91.48.1794996846175;
        Wed, 18 Nov 2026 02:14:06 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b3d4087b73sm581521a91.2.2026.11.18.02.14.04
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:14:06 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3ad704d4760so838470a91.3
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:14:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794996843; x=1795601643; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=BW0ZgeDgcOiV0Ehvz/rBcGltgwDLVw9HM18BH5WCVAM=;
        b=Ernkv/Nz6ukkI7oKDqYjzHJQjlB1kiZdTE5ZPwLYhGHzO8moGjV75YQRdQL8Lytzon
         4vmkSX3qQkMxVEPgbXSXT2cofBlw9Co7YxEbVRG2ulmYLy6WVu1AZbRZuY2xrJkCcKE4
         b5dHtnVlzZylohJH07arY/++kbebxyV+zhm5k=
X-Received: by 2002:a17:90b:1649:b0:3ab:c370:3684 with SMTP id 98e67ed59e1d1-3b3d07c3f7cmr2037843a91.30.1794996842908;
        Wed, 18 Nov 2026 02:14:02 -0800 (PST)
X-Received: by 2002:a17:90b:1649:b0:3ab:c370:3684 with SMTP id 98e67ed59e1d1-3b3d07c3f7cmr2037819a91.30.1794996842194;
        Wed, 18 Nov 2026 02:14:02 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3ac6016c3sm8740707a91.15.2026.11.18.02.13.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:14:01 -0800 (PST)
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
Subject: [PATCH v2 33/37] scsi: mpt3sas: Bound SMP passthrough buffer reads to actual buffer size
Date: Wed, 18 Nov 2026 01:56:42 -0800
Message-Id: <1794995806-5835-34-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

The SMP passthrough handler reads bytes at offsets 1 and 10 of the data
buffer to detect link-reset commands without checking the buffer length.
Guard each read against the actual buffer size to prevent out-of-bounds
access on undersized non-inline buffers.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index e1c3ac432501..e8c5dee499fd 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -996,13 +996,15 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 		Mpi2SmpPassthroughRequest_t *smp_request =
 		    (Mpi2SmpPassthroughRequest_t *)mpi_request;
 		u8 *data;
+		bool inline_data;
 
 		if (!ioc->multipath_on_hba) {
 			/* ioc determines which port to use */
 			smp_request->PhysicalPort = 0xFF;
 		}
-		if (smp_request->PassthroughFlags &
-		    MPI2_SMP_PT_REQ_PT_FLAGS_IMMEDIATE)
+		inline_data = smp_request->PassthroughFlags &
+		    MPI2_SMP_PT_REQ_PT_FLAGS_IMMEDIATE;
+		if (inline_data)
 			data = (u8 *)&smp_request->SGL;
 		else {
 			if (unlikely(data_out == NULL)) {
@@ -1015,7 +1017,10 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 			data = data_out;
 		}
 
-		if (data[1] == 0x91 && (data[10] == 1 || data[10] == 2)) {
+		/* Bound the read below to the caller-supplied buffer size. */
+		if ((inline_data || data_out_sz > 1) && data[1] == 0x91 &&
+		    (inline_data || data_out_sz > 10) &&
+		    (data[10] == 1 || data[10] == 2)) {
 			ioc->ioc_link_reset_in_progress = 1;
 			ioc->ignore_loginfos = 1;
 		}
-- 
2.53.0

