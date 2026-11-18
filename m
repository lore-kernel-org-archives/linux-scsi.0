Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.226
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794996798;
	b=t6zujqbjxV2zeybr8Zv621a6i8lcP8+vn1488ogz4/1UmwYYbbAQEIt60/wmahDNNuAT
	 /XAFRDYYdP9fz4Dvgb5J3OIOXJ3YAi7DlJMIEX2ophxls4/p5Pxn9mT8t/KbbXTtNILkv
	 54azuijTQKp0Mx9YbK8QatwAreeM5n/8pfBGnhNQ+0yADE5gCkV2j5DgTrgqofkOGwdeF
	 4RBSrRMaeeEmCiu85owtQrJqzt2LhcPNlW4RW2M/LqHLJbdgDRBth75Fn+XMWVYPEtjKq
	 fm2kRevki6CyqLvM773FhXrBBz2NF8xrCU3E1wNMdX8yUlufuySuR1XmGh0g9l8YFWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794996798;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=7IByfpGREyABq5y7e87yorRQVCS2+bmqiFKi3xMiyiU=;
	b=fZg3Nep8WSl8RbxgVmwE9rr2TjkFDYZkAgZlLbFMvLPxa9S/nKFEh2up0tpa0WT/yK1l
	 A9aiXpK7OtzcJhDjXNjGJ399uGw+gTWYmoxwj17Uj3JbHdhsOR+3Dfs+OQSUST0s1BSvS
	 YO6RYqxfOkqr2cU7DMnisnJ5KwQdw1+zzAjfHj1u67EalBc4hXYTKvy4NlEwEIRbBmYU+
	 eTh/8F/JOsqed1/bqaLxteY3bS+Wvx2rUnnZ9a2PEYGg7xb7oP82a3T/NkrGtbrIjlToc
	 VZjngwP92fKQgH2QqmJ7/csF7edHyCZhY9GJW4+Z3fyhmiL4JfsvOqoQmL3jN6TsIwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=Dd9fUhsj;
	arc=none smtp.remote-ip=209.85.215.226
Received: from mail-pg1-f226.google.com (mail-pg1-f226.google.com [209.85.215.226])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103B3606A31C
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:13:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 103B3606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=Dd9fUhsj
Received: by mail-pg1-f226.google.com with SMTP id 41be03b00d2f7-cddc597d062so497439a12.3
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:13:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794996797; x=1795601597;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7IByfpGREyABq5y7e87yorRQVCS2+bmqiFKi3xMiyiU=;
        b=eoV2MomXsz/D9PQIlHoLWu8cZKsB/oRvCTxvYqgA/PgdO83jYn/ygS3JZerntySPeB
         abhyAWqvqhyGtV4Wc2UYCwYiYgCoAPk0Cp4uJkThauBdA7KZl/v2vJZGW/CceactPrIt
         /1KR9Z+L0qcfEboFFDw1+l6y/8TL0UlVdtpiKbyx1QupU1AoCSTJ4o6Gzt9GaMJhXnSF
         oW4IpKTtxIoqeRk+czr6mDxzS+wYhz+s4YXcCJEUO1uCVuHUusTWeh/fTbkOHf69S/70
         XctvAWvbI/pTLWHCKkYBcIWN+r+AA31dccpY8f46rsA+ChyhVi2KVCBMTzcONbYjPR2p
         k6XA==
X-Gm-Message-State: APuU4Z9E0rjkYQ6oBquCFhuC2tf+yJZ/o8Kp1fLIIozNchBi8TNLtfrB
	AFkZnvaZzXf/1mJbG+Gfgugtcrk4FrDSa2cX37Jhs9938a9ZK0xJDIOpE8OjzNKuIdVvL7KU8vI
	q9o9KKcf+udrqezcAJHysiVXo68qqwWrOOUsMiVrWhjZ0pvV0FimQfDejQuYNxggleS9kDK5GuS
	nU2Gi4Ipz84l3CWJaJSDO/gQxIcmCY9F9sj7c4mdwZ90/H8Vl/8p31Z6eDnCuNXx6Bm6n27AIIv
	lvDwM7Ds9fJSxhtGXZy9j3iX3at0Z0kfMY=
X-Gm-Gg: AZFdTZdkndEyMO4pqH0UOm4BZ5DxmU++mx0sFbBNRaW7wZJvj8PfGpOW7DgT1Ys+LdQ
	iSxZaTjmEsfHcVi+S+LOlNX6UQaQa3niSkZDODqXyXSBgld8li+pvu46kMSXy5/O3asg2WXfAbk
	9Kzg+kBphWkP+KPXPcIw9jT039p++naz+RLPSGDyMWSjuT+QXuZKNBYCnQ5cdFm3EPUkGfpPJEb
	WT3U0tBXWoOR1QNbHE6x9L6ObZX83dIw9MqjahZr8MyP9gjopl3heg8quxIva+9v18NTqg5eIKd
	aq3fECDZc13Dw3nsTmLufXVqf8p53+oOkDMSGZouqRVLRA16aSPQ84KL5ftaFl/9foMokTS9crz
	ZofZD0rWxo8qNprOU9MKji5ex3nWhF4oBIns2lv5DCdej7B5grLx7mKDvzekx0B3CiXwKb+UGAt
	QbEz3PcBZ1t6+dtf1+paYYn4vGT+Q+TZbNDPodgKwq5lX3xsv1iYFF/FoM
X-Received: by 2002:a17:90b:2dd0:b0:3ac:450b:164c with SMTP id 98e67ed59e1d1-3b3d07d4d64mr2411188a91.47.1794996797579;
        Wed, 18 Nov 2026 02:13:17 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-123.dlp.protect.broadcom.com. [144.49.247.123])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b3c050721csm2629519a91.4.2026.11.18.02.13.17
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:13:17 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3ae72da2f57so1052255a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:13:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794996795; x=1795601595; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=7IByfpGREyABq5y7e87yorRQVCS2+bmqiFKi3xMiyiU=;
        b=Dd9fUhsjccOSwME/OQ8AEpohsUSp9oax5pbSDTuvSpTWj/SlfG4K2k8rGKr3enZ8oG
         o+K7gbIVtKIfos/45kyxnumCSmyB37Xwjj69N+ETuFz4sTDDnfdUPKbitYEeilwIrCo8
         zUzSsWx4QgwnSZDi73W3MT+mKKUxHfHrz10L8=
X-Received: by 2002:a17:90b:3c05:b0:3b3:c930:35c7 with SMTP id 98e67ed59e1d1-3b3d07b90fbmr2326332a91.27.1794996795626;
        Wed, 18 Nov 2026 02:13:15 -0800 (PST)
X-Received: by 2002:a17:90b:3c05:b0:3b3:c930:35c7 with SMTP id 98e67ed59e1d1-3b3d07b90fbmr2326297a91.27.1794996795120;
        Wed, 18 Nov 2026 02:13:15 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3ac6016c3sm8740707a91.15.2026.11.18.02.13.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:13:14 -0800 (PST)
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
Subject: [PATCH v2 21/37] scsi: mpt3sas: Clamp sense_length before copying into transfer_packet->sense
Date: Wed, 18 Nov 2026 01:56:30 -0800
Message-Id: <1794995806-5835-22-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Clamp the firmware-reported SenseCount to sizeof(sense) before the
copy.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index a25e2aed266b..8bafb8ea70a8 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -7579,7 +7579,8 @@ _scsi_send_scsi_io(struct MPT3SAS_ADAPTER *ioc, struct _scsi_io_transfer
 		transfer_packet->valid_reply = 1;
 		mpi_reply = ioc->scsih_cmds.reply;
 		transfer_packet->sense_length =
-		   le32_to_cpu(mpi_reply->SenseCount);
+		   min_t(u32, le32_to_cpu(mpi_reply->SenseCount),
+			 sizeof(transfer_packet->sense));
 		if (transfer_packet->sense_length)
 			memcpy(transfer_packet->sense, priv_sense,
 			    transfer_packet->sense_length);
-- 
2.53.0

