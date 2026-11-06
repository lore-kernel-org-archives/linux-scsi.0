Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.228
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793926800;
	b=Dld47m8+UCQeDaLEVreeB1gHbBsBLV4TwHNCjC5GSDSIeBPZuCMIOGBiWX1elOujAo16
	 VxbGfyCaXIs1AJZW8AukIPwef82ueetbZEvzIUV/hXd5hVzqZ7aUJ+L6frTszRSGJSvOH
	 gp7L0yPzih5UNOsU2HPDkHPq4YK5+s6peb8niAufSNA44x9agUvReEyEgSNEyfGOH0mzR
	 Hvo1LnBebh3nfmbArQdESJkHmPYG+fJigNKbSdVoNupgiqeVi4dYxNtgDIRWMPDEf5vbT
	 gRAeSOZg691lvEtQ6AbcLDXsULosDSPI2bXmaVRF23yMVfK+yb5NDyYJbPI+J9RXovw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793926800;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=hpbj2Z6Hey8c7UXTGlAyb8NrTtG+XksSDakpyKREAZs=;
	b=fwB7oSnBkfcMLGPdarDqaxC69iesbtpnVqjwnOMdk0gUDcxhsj9CXTclyLlzSoybrMWI
	 wch5Ih+mjTgj2AkkaH063btkj353r1DjIQiGDM00RnIS3CAYBQAHXYTfcQybkzC8EhLxA
	 uzdBqgKr0UPDGH7tDVu1O0F9bRi5fUafqpRi8/ns68K7sZWv7cFiWQfDKkbgQ6c/jIXDS
	 imlYlhC6B/9TDAtrl10SwhR60BmYPhYNKi9fJlxKQac2v4ZAjKQmKQzTslNKLo0uzmBL5
	 c2RfkRQGClyEAl5UZxp6b+j5dC88hmQvHRfkaQuIArFUo9Dm/sDAXbCh+vHF1yqtthg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=QnVazPqI;
	arc=none smtp.remote-ip=209.85.215.228
Received: from mail-pg1-f228.google.com (mail-pg1-f228.google.com [209.85.215.228])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075EC606A31B
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 00:59:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 075EC606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=QnVazPqI
Received: by mail-pg1-f228.google.com with SMTP id 41be03b00d2f7-cdb628232d2so64390a12.0
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:59:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793926799; x=1794531599;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hpbj2Z6Hey8c7UXTGlAyb8NrTtG+XksSDakpyKREAZs=;
        b=WKC1SNdgE0xSDTD4ozqKjKpJ298WCy2yGQyk/FXrXWi01j5nK90yVwGVjODXGIBDbv
         ze+Dgto9omVZo2rjJ/2sQ8MUgSouegedeFKRug5up5srsqd9Ebe8InsvgPH5SaPPQiSU
         yZJSTmlT2pr+pIsx4moJhUY/sMXzFx83/RNuGDbVeZUKpbF4yKbhmCbA+Cm0tITz+wRE
         etUNFJB3PshBN1yjakpSo5lwnDZDeRd7HpHG7P9m3iXhCw76sHAUU8C03e3HLEbpwH+w
         oSEnagJcRwiYIxVdHU06luMNfVfgD+ptjJlbc0ti+Sx2c6C2wAwS4nHXrEtsWAo9bP/R
         e4Xw==
X-Gm-Message-State: APuU4Z8pKXIuhxQ0KjhVvOOVsmrYhI+qMSWd7Tdh3M0KLOcq9sLtq8S2
	Vw8bCGKmTQdtzhZrz+rBI8KwVXDBAmQ9A96SEediuQJawFsJPuRZxXZHbAnrYBgwRMmbQ9Vpgri
	KKfao/cOWciLnPBDOb0WD7CRUAns/+Xr0ASAyLuv29A5ESYnoeP3JbViFeub2o+0lkpjyMXgKBK
	M7HyuKAZqgweEvfsFx0zyhM0dFR9BYuBDUD63NEjOA5I4Ok0bYNlmxAbMBhLFnzfNfInmVPx9TD
	4TQS8eX/uROnF4jqhb4mns3MznpiFpl5Jk=
X-Gm-Gg: AYBFou2tvnDe/gYuQtEJ4EF0e4XE+yJZCxvQAGpN2fyc5k1cwhhO6Yuh+9tizeXoGQe
	pl2rE45QKAUqNUstIPNKTti8UUy0rD+oNYkWP2Z9XjOw5U8wH/OH15E3CHxuSJpeuk0Emzo44Ey
	xEUH/ykA1yqRcXKH8O4pmReFew4dorjPVtNN+PViaKaVDaGDzbf2fEwif0zm+trgY1dt79stT8M
	zAIogUwZYlAN6pEZNuCpmCqm8fDXjj3WLTEzynPXTPOamX0kE9XnuXuVqIBsSSzmSwuxoLyJs08
	loKPY76LYRu6XEfZhepQ8W5yVWsGQaFrarUc/PSbW9q6aSgY6U9wAXUuXk1hyt+9CSpJC2/qXLt
	k+jTPOYU7s2o5MLds4Jv0J3Sjh1akRjkvdd4H9gJz2MzunYltq9oCI1ibVQDLuoqYNmt7ywxGAj
	CXbH6BqopNaIdmYtF+64WEW9gvlFlL0gpP1EWfYq3cmCnQsutXdSPo6g==
X-Received: by 2002:a17:90b:2ccf:b0:3b0:a757:4f85 with SMTP id 98e67ed59e1d1-3b0db6057b7mr814622a91.2.1793926799140;
        Thu, 05 Nov 2026 16:59:59 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b094d2f3b2sm2327138a91.1.2026.11.05.16.59.58
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:59:59 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2ed08be1c84so1731365ad.3
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:59:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793926797; x=1794531597; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=hpbj2Z6Hey8c7UXTGlAyb8NrTtG+XksSDakpyKREAZs=;
        b=QnVazPqIYW8wswWxoVAXxx6OP2ZSUR9fqH/fg7iTemKKprtfYqnT2lBMfppqzv+by7
         Qy6hkBvBYlHjaFlxbA9KVTHRWvidQPEaQgLcCSIi+PR+ocSmcBZxxQJSSMZA6OvnRqkg
         DqupFCmfqszuKr+gZDe+OfvxAYF50gCK0X9+Q=
X-Received: by 2002:a17:903:37c6:b0:2ed:2a1d:e36d with SMTP id d9443c01a7336-2ed40c7b5e1mr13881295ad.36.1793926797278;
        Thu, 05 Nov 2026 16:59:57 -0800 (PST)
X-Received: by 2002:a17:903:37c6:b0:2ed:2a1d:e36d with SMTP id d9443c01a7336-2ed40c7b5e1mr13881095ad.36.1793926796811;
        Thu, 05 Nov 2026 16:59:56 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed47d7b8cfsm450745ad.57.2026.11.05.16.59.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:59:55 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 33/37] scsi: mpt3sas: Bound SMP passthrough buffer reads to actual buffer size
Date: Thu,  5 Nov 2026 16:42:48 -0800
Message-Id: <1793925772-1303-34-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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
index 6870172c5ebb..c80bb2e7c240 100644
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

