Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.97
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794996815;
	b=DxQI6Nzq1StAgeqf5LmDLsWIAg9mU2SMy3+wNpJLBKhNLNytlA62oGyLc8vhlFq/UlSx
	 NOCtGaaEoCbLiAjFtHidH9dUMwuTt51+DxDyEcvVMmqqVdOT51sQ4WN6zFklo6FyVS01i
	 j8cVWGjOeDf/Ln1nFwCiVq2u2r7vB1gEmdXz4N0OVXWWW1YA+IIXrXUfbBCuIxIedgn7J
	 vzuYSfOAga5Rk1mn6McZKqYy5uoEaSP4tbcg8i+OBckr1Yl7O/IkLRpiYTHyzd/8e1WwO
	 1C/SxDu+n6jdzNgew2jwp1+BLJF70tra6GLQ9LHmPKWRcfT7XgUj6/zmlBUR2SAKPFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794996815;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=11LETA3QGVBYRSLq8m+qYXk1rZ5cvm61WxYcI0Gr97U=;
	b=q7sp8c/XpPZUumJ9LQHhW9mCPMMLvYOCsQqFwfiGe4HvHveiygsDU4l1SQZqSO22435W
	 mChzocH3gw9p0EeM7qoXL2F5ZhrCan+w7huKSQHF8rNVOJGEKPH1JJ9+u1/3nULkdPHCO
	 sJ5W8YL/S7HEnP2VbdeEag9D6Tb+cGFWPjWRZYH8X5GgZmwvtLpGpJQ2FJA2zkuJEDLnH
	 btiJkKM2Iob+AqT+S2tTQdWG6HjW1KnjHuIYXrjdgCyPf/2yESksJ0mnzDids0572IxCJ
	 gyyDX2vMXjejwNcnBbt6kKdc9rXkcbg2HBW20Fpd0R4J3+QUKEbRED17jbjO1ypbk9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b="U/5aoGyS";
	arc=none smtp.remote-ip=209.85.160.97
Received: from mail-oa1-f97.google.com (mail-oa1-f97.google.com [209.85.160.97])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD80B606A31C
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:13:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD80B606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=U/5aoGyS
Received: by mail-oa1-f97.google.com with SMTP id 586e51a60fabf-48e9476e26aso312995fac.3
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:13:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794996813; x=1795601613;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=11LETA3QGVBYRSLq8m+qYXk1rZ5cvm61WxYcI0Gr97U=;
        b=RPZHIHXqnbQ90qLuk7xVas8iLjF0XFR/PhzKJbYLME53l+OrEwuKtSVDfC7JDYPiPQ
         qIIjKfhAOi7gywb1PkmXbMpQRHirjfqrsRLPgSLHUULmqBD1pAec+k31Ccd95v/M6A4m
         NYcUH7JZ9o/odsM2Woug5qCf9JuYBBCFu2orpGQcfMrRZctzlrFBmzDorj8RQ+Z6uvUX
         TMbpIvjL01czpZrYSeweEABc57+yjfwOPUxVjmEVs5gFpZycxDAB08mrWXut9GT0+qoq
         Ju4Ila/FgHNqH2tot4oPfQWmo+Kn9KlJwKXSYBPioVTaG5vhqwt0y6VXzjHHQW02lgI+
         S0wg==
X-Gm-Message-State: APuU4Z+8QzKVDBgS3p8uLlpDGZCXQEERDCR637UsB0R5z4ULXXQmtPTt
	81j/DfC/liKO1HFCO5/ddWciF0e0e6vrljE7Z3JlMdcPEYbZvLSHEnax39z858z5nFHJIHCleYW
	nNgvoFit/34eu4DvFNL2i21B2P3K+Nqb/zrltWCaaMPaH8EOeaArI+NPVafUcBMo3woP38Jl2KX
	SeAg59CyAGMuVfR3+nZoCaeHiELR96xmf7vWwkMytfQTuIOU8RizqKImwsJ6ZHlkZ4woIYMl2AE
	GGKHo9mAkZZ8138lfmVdMffuxhlkYC3LqA=
X-Gm-Gg: AYBFou1N7LlMJxaF2GLnP/LJtDMxOt1Bmk4oB9nrIp7N3yIEzi55AkOuP2f1sjPkJIZ
	XLyX2F09zSU/PZtiUWcf+lLSmXfR/sCkUjE1mhPzqWaafcNj5dzju0rOo5uRAYSnV3Lu88cp8Eq
	lWg2MIeY3Uvw/0ycul/rUVfoizUw1qYalPtF64K/sBFba1d89hM/MWe01EwETfG/7qid35BaLzR
	gwO7CGW9iXnQ0FhDko2R7KQxgRAcOb8tj1LpCmmPbeXuTZE46IiYfpmrWYTpRdJzBfRXnN9gf6i
	b7Qf59uowOjCyRl8wA1wqA5HZRS7lCCFy+O2QGptDlunhGhdkm1q0t+pCxLjR0h2SQgME97LXrG
	f7heokLBbWIB0mVqpXgyOYsiNglryLrbqBEfvtK91J4xIGtpR26WoeKYCYfxNlReG9Dn202c/bW
	DtHnVqgskT4R2ukrddGzOs8LGfxaAPZpeYDI7f+zG3Yw0YlyKbAFzuccoo
X-Received: by 2002:a05:6870:2e81:b0:4a6:dc31:5301 with SMTP id 586e51a60fabf-4b75c856504mr1714129fac.15.1794996813403;
        Wed, 18 Nov 2026 02:13:33 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-123.dlp.protect.broadcom.com. [144.49.247.123])
        by smtp-relay.gmail.com with ESMTPS id 586e51a60fabf-4b7469f1e9asm20861fac.29.2026.11.18.02.13.32
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:13:33 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cddc4bde4adso564288a12.2
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:13:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794996811; x=1795601611; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=11LETA3QGVBYRSLq8m+qYXk1rZ5cvm61WxYcI0Gr97U=;
        b=U/5aoGyScRmglTLracOW4vH54AcUdWprEwsvvdAOQpqJRd+1dth/gzYRaMOnL9XJiS
         vUYN+UlSWJo+3BomBYJ9N0Qur6ECAkoUj0uJ8PQScpBo0iKqG6MLW0Y8RMEJ5hMw6qYD
         WuhMJcNFJkt/gwTGsbJV2o/v5B7jJ996Bo+XE=
X-Received: by 2002:a17:90b:1c05:b0:3b0:96b4:ceb7 with SMTP id 98e67ed59e1d1-3b3d06a3a5dmr2417138a91.8.1794996810937;
        Wed, 18 Nov 2026 02:13:30 -0800 (PST)
X-Received: by 2002:a17:90b:1c05:b0:3b0:96b4:ceb7 with SMTP id 98e67ed59e1d1-3b3d06a3a5dmr2417116a91.8.1794996810385;
        Wed, 18 Nov 2026 02:13:30 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3ac6016c3sm8740707a91.15.2026.11.18.02.13.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:13:29 -0800 (PST)
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
Subject: [PATCH v2 25/37] scsi: mpt3sas: Fix SGE offset boundary check in _ctl_do_mpt_command
Date: Wed, 18 Nov 2026 01:56:34 -0800
Message-Id: <1794995806-5835-26-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Ensure data_sge_offset leaves room for two SGE entries within the request
frame by checking that data_sge_offset * 4 does not exceed request_sz - 32.
Reorder the overflow guard before the multiplication to prevent wraparound.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index f97967235367..d3166e048991 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -714,6 +714,7 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 	unsigned long timeout;
 	u8 issue_reset;
 	u32 sz, sz_arg;
+	u32 sge_cnt;
 	void *psge;
 	void *data_out = NULL;
 	dma_addr_t data_out_dma = 0;
@@ -746,8 +747,9 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 	}
 
 	/* Check for overflow and wraparound */
-	if (karg.data_sge_offset * 4 > ioc->request_sz ||
-	    karg.data_sge_offset > (UINT_MAX / 4)) {
+	if (karg.data_sge_offset > (UINT_MAX / 4) ||
+	    karg.data_sge_offset * 4 >
+	    ioc->request_sz - max_t(u32, ioc->sge_size, ioc->sge_size_ieee)) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -782,6 +784,23 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 	data_out_sz = karg.data_out_size;
 	data_in_sz = karg.data_in_size;
 
+	/*
+	 * SGEs follow the request header and must stay inside the frame.
+	 * MCTP, mem-move and bidirectional data need two, others need one.
+	 */
+	sge_cnt = (data_out_sz && data_in_sz) ? 2 : 1;
+	if (mpi_request->Function == MPI2_FUNCTION_MCTP_PASSTHROUGH ||
+	    (mpi_request->Function == MPI2_FUNCTION_TOOLBOX &&
+	    ((Mpi2ToolboxCleanRequest_t *)mpi_request)->Tool ==
+	    MPI2_TOOLBOX_MEMORY_MOVE_TOOL))
+		sge_cnt = 2;
+	if (karg.data_sge_offset * 4 + sge_cnt *
+	    max_t(u32, ioc->sge_size, ioc->sge_size_ieee) > ioc->request_sz) {
+		mpt3sas_base_free_smid(ioc, smid);
+		ret = -EINVAL;
+		goto out;
+	}
+
 	if (mpi_request->Function == MPI2_FUNCTION_SCSI_IO_REQUEST ||
 	    mpi_request->Function == MPI2_FUNCTION_RAID_SCSI_IO_PASSTHROUGH ||
 	    mpi_request->Function == MPI2_FUNCTION_SCSI_TASK_MGMT ||
-- 
2.53.0

