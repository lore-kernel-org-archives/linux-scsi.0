Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793926771;
	b=o8/7N+otNyPNsKeLPWozWGC1U69ncZcF6hsscEz6UH/98QSwLZGH9Jj8bSfwwfOFOjSh
	 /7RHWVWx+pxx/Zec0RVQhF+6oCLYpchvUZEqAOU4vwVtUsRORR+mk3HavNB8OVXV59RVu
	 o19tASIhfBDbCJcC1riYBu1iVFcwTmpOON7os9kqbMUF9JPziEoQCdVfGjOAvmFwBh++A
	 zkeeF78BA+k0zUShL7npBIV0wBNHzslWVQBJOagyY9bCZiz3tggFfjQ9hHriNFWEVKloc
	 BJJWpnWGp1lE2AVuDf0+xzZ/FBFEJK2wVBop9KW88T8WQnYnw4xiuGJ8GMXL//e5Ing==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793926771;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=zAjZ4tSwdyEJCFsAUE+y2HP627JYNj0DEd16hlEhl6M=;
	b=b6SvLxPlFOh6IAcoqBTesk3xCb16Es7AfXHjH99KhsiETqgC1Hm+i1zSYWNmWjgZso6a
	 aqkLRd9HmVGkEfUVUKIbOn2177IpLLoyKsr7XFWWodkz/RbcD6cYhj0RUj0x/ognVgbKk
	 wUOSFQ9r6/Jr5jyvaMTYdn2knwlzWLOzxcxp3+P4l5eMsNxRzNuOT5fl3aqJF5u1Uw83N
	 eG0HrI5vATZFJacxWvuJ2Lf56t6hblU/Cwd3JMBawbDRT86cL4eBzBGrWLwRJQGVvbm6w
	 oUs8Pp7va9HatEb1v71cBzrZVB3J1uCO1IzvuiL9pU57wJvPVua1EaGyWP7cWBxP9Vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=QRkzlVjc;
	arc=none smtp.remote-ip=209.85.215.225
Received: from mail-pg1-f225.google.com (mail-pg1-f225.google.com [209.85.215.225])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93083606A31B
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 00:59:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 93083606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=QRkzlVjc
Received: by mail-pg1-f225.google.com with SMTP id 41be03b00d2f7-cd60c5da24cso59675a12.0
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:59:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793926770; x=1794531570;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zAjZ4tSwdyEJCFsAUE+y2HP627JYNj0DEd16hlEhl6M=;
        b=sKgQAEufRl5eFJgS+Jg6qzhRVek7Zsj2730YuTOEmTmRU92HpakdtwpgFI38BEt+Ad
         Un0SLq5DW6LQqTyt1qsxijLmOCupKTXSeQMI0rk9Ns8X6+LWTJY/SzwFKtU4a9eHyg6K
         GwkIj9D/XPTAOX6t2IfpISUEy1iBngaFm3Ya2e2ENyMVKki1/w/3GMbn46lYUgn+u39q
         v1PUV4q5ilOdsGR7vBYXZ0w59J/BUBDX9cBZByo95667Ctfzx4ntOu+zZLnEV99D5u7y
         6TzzIW8w+cLJika1DkXAL2GG84FQVRVz3S3z5GyU07A867oHL1blhN/ALM7+yITqQbYO
         BimQ==
X-Gm-Message-State: APuU4Z91ZnOs7FY0eQJYuCq+HXqwq5KXcKk+GjdB+zSq3BZLWKnR2U15
	9naHvpPZCNIIwOaaP6UJQox5hm6fYub+NUg/7NPWW+h6tIiV33/pUAPRt2I+gWR8Bs3scJMYFRf
	OgW33/zM8h3Etpa7nq720QJBNoG1QPN78b6VELG2t8bY0/KpoRrdjZ9w5vpGk2gzA7SuG0iYwLb
	iBxMrwJYrxJ97cKOcPIUwC9iQ0AjV79O7miawBW6hE0GGIQwsZdp/f/wEH+6vLNFwhF5KXpbB1n
	xjbhWzxyY67UTDDyAlMUQoj3omAtC6n3gU=
X-Gm-Gg: AYBFou1PzxaWkn9I7OfhzmYW5Hej3lVbPpKbRvm6MDsS9K+vKQmD9iY8Prz71ReiU3J
	R4KMzqfcAouumeCkmFWyHsBm26e25u7vcBf2Tko6kNwB71yfIMI5KSk0DugcbzVCLlrcWBvgX1o
	O7mY/YOFxeIIt58l5XfHJ48ukvn3av5BnVwTrXHxTp86cbWdVkox/HjYBTzvrghIjnlyQSMOtYd
	vfgbuiNIZs3cO0JEIWnhiB+2X0ONNXsz0eqjDMCz5mCp4kKxDCsTMnZixMkYXiAp7SDr2aMtpOC
	zpJyF9zToUwijLiwX32l9fjfjX76qa9RUN9ELXZ8/jGJb+tqnpEJO77qIHGzSoBPxz3PBtjpvzu
	tvWE1ZJy1oeD1mIU+gISndGdkXZPf7KSJGDPspottG5nt5WCaRd3SBQB5UuBEgfHzME0+O9pz7s
	t3oADy7Zu3fYHY0u+TdSb5IUSe0lOKdsI8HPwGENrlWmt1pQXLRhZSeQ==
X-Received: by 2002:a17:90b:564f:b0:3ad:c4e9:7beb with SMTP id 98e67ed59e1d1-3b0db6e0315mr772675a91.43.1793926769910;
        Thu, 05 Nov 2026 16:59:29 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b0d7e2676asm681937a91.7.2026.11.05.16.59.29
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:59:29 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cd66551e02cso140672a12.2
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:59:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793926768; x=1794531568; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=zAjZ4tSwdyEJCFsAUE+y2HP627JYNj0DEd16hlEhl6M=;
        b=QRkzlVjcwfOCsPv1ajIU0/VSR/qrPFnaE95BepkX6ljBjc8CvkwwmCwhVQfA1eAymi
         hRAY1262ROPnXMWEpe8bcdRhKOLDxVi9R80hA0xCiYd6IL/rrxyiv3ijDbvoSsyT1tIL
         qp3pOAglYE+XIFRPeqqBquXMFoqPmQ9yP/bwU=
X-Received: by 2002:a17:90b:4b8e:b0:3ac:3588:b548 with SMTP id 98e67ed59e1d1-3b0db6a8f31mr836774a91.13.1793926768025;
        Thu, 05 Nov 2026 16:59:28 -0800 (PST)
X-Received: by 2002:a17:90b:4b8e:b0:3ac:3588:b548 with SMTP id 98e67ed59e1d1-3b0db6a8f31mr836747a91.13.1793926767457;
        Thu, 05 Nov 2026 16:59:27 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed47d7b8cfsm450745ad.57.2026.11.05.16.59.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:59:27 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 25/37] scsi: mpt3sas: Fix SGE offset boundary check in _ctl_do_mpt_command
Date: Thu,  5 Nov 2026 16:42:40 -0800
Message-Id: <1793925772-1303-26-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Ensure data_sge_offset leaves room for two SGE entries within the request
frame by checking that data_sge_offset * 4 does not exceed request_sz - 32.
Reorder the overflow guard before the multiplication to prevent wraparound.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 60815302daf7..04555eaa09c4 100644
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

