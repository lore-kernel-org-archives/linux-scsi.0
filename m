Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795072794;
	b=dz8kbviddj7GOBoAMx2/gAtGCq9rZkU1WO2N5NHOnXJo5Sj6Eqmw0gXefjitWSSUNwN0
	 tOVWlyeyF2DHFJrhlK9U7RMWx6gxTVz7vHOUMV2nbDDs6sAeFmAEucfSWx2NcIvzEsI08
	 fG5EHt51V3+E7QeqTX74/qJXLFO6w6pOFsiYNgOkXj1SujV5J/fNPaeT2Nh4vwwKoYQOp
	 tdlDEKIshXRrGtqlareOaGrJmNGSwW9+YQffGvQ9gpuUeYdWDjKR/YHrW0WzjiaMer4ez
	 7WmVGhjfcEzgYbvWgfshNrNzUOBB6vrlSgkPnGfjQcr3fzIFVnTx06Yrd8/cnu6msCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795072794;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=cX3RJ3lczZMpwzQnXoneBQZZ6SSE5cGoZd2UZFTipl4=;
	b=0DEhsA5zNcbZtyAv1Wst1j6s3i9xD0iJcTXLjhBYx/6h4olonjDG2Nh8tbhlE9OOTFwk
	 8LMjJLB7cVBhtAq6FTs+Pj5KFB/8mrOpBc0kNLHfLlFsyK+avWSSeX25HsTGmJMQsi++Z
	 hfYGQf9hhCAm993UFGunev6ur0N1aLoUxTCqT6XjOWflD+IKo+7QYoPGdLmswwnspZNt4
	 9wt+m3IX3uF3pZtisECHguYb4X/FTABaWHGIWl+jOkxGKj0SaM9/GDdmF8vwKra28+vxa
	 0FLpfoexBLhnRnvm44DwAGIDFX41Hl3CUZmK6J3mPvBB48y0BTagCIDfTUzU+pu2aMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=YZNyUmtt;
	arc=none smtp.remote-ip=209.85.215.225
Received: from mail-pg1-f225.google.com (mail-pg1-f225.google.com [209.85.215.225])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F97606A32C
	for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 07:19:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A8F97606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=YZNyUmtt
Received: by mail-pg1-f225.google.com with SMTP id 41be03b00d2f7-cddee4abc57so625047a12.0
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 23:19:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795072793; x=1795677593;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cX3RJ3lczZMpwzQnXoneBQZZ6SSE5cGoZd2UZFTipl4=;
        b=zOP0C+vzNmOdKk62GnzAn1VAktXBCjSvHlO6Gfd6EdhSl5dmoJpCvNcS8/OZkG73/+
         P8NUAa1zQbGDWXKqZxfwkhCaqIL7ysPAnNRi2buR59wQVYDmoWJujHP+7FqLLrGDa2eC
         F7Blvzb4FMSUZM4H9jlMauD6l/pxX3Bx90ixFj/id7H6VpjlroRJayurZpaJHiRDAiEn
         R7vYae9HnV/3S4oIUADmziRCMGHQyY0VNqgIhhJGfi94VY5KM7Lct7xH2rF41JzLbn9f
         EVphE5YmevSOef/dmU73k43LnY2keKPQLyASlTBZC5Fs4RC62eEQemHg3K4J4JqNHzfH
         2Mfg==
X-Gm-Message-State: APuU4Z/ZtC40ZLFl3F5vP/qbq1XJPKKsT3lWYYz28GaSI0jTZwM79T9+
	GgxLVQObnNXCIiP/3xwqPq4N/kyULHe6G7cRNZkfzSt6s4K61SG35wmBWQMXVmRYqF04faDmi3s
	H3QuUcS7NyS8PYnHqdrU0OWxIJCeMx+Vy/f58ZPPuwrICE/pF0LMV6y1Iv3V8zZD4msnIOjKkF9
	2ehUJRs1Zs2UB7MomGwhXnQenbMZLcksTTcGYvhSsxTDT2EjCQpsiv1j4ITI37vrFcOOWCJVcRY
	GbA0N5xTLc2alYm
X-Gm-Gg: AZFdTZfUykp24NIZXuY+WIcDqgk9s8KvCBVvRwD10Xiwd988HQysOHulYbAk+J+6zQH
	ATCeDjzuxAuX01msVfsAXXJMO5vat5iF5BUHdFzxtj1Y1FPZDR3/y5iTkqff+CzjXJLc+jdULxg
	v+hG8Gk7e9f9ULN552KNjdja+4h2ZsbdQLD9/QgF6twrK7q4Hip2AFu4qood/Wb6ZyqJsB7Xj13
	wNJeYn5d73721Nq3k/qMK8X9qAjlITtTZ6uFLyjGHzm5P4A4aC4ren8KUmMU4U43aE1mk2S5xR0
	iSjC28rxdRUOVo68CNLafXpZHu3DAD3q26xGuyLLK12aWY0n1ieSP9Xn7dQQdnKSapjUI4KrBTk
	Evx++17V7Elpe7zu7N32iQz84AQ6SdHOZMDpmRzwL5XbDc4bbyHksL8Bp2UV1Yf/gS1IWOVymTF
	p6YKdJkVOitH6cwVX2mX4YyFeMjfzQsoD05Bc=
X-Received: by 2002:a17:90a:da83:b0:3b4:a90:7f30 with SMTP id 98e67ed59e1d1-3b40a9082f4mr198886a91.55.1795072792919;
        Wed, 18 Nov 2026 23:19:52 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b405cec357sm529830a91.5.2026.11.18.23.19.52
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 23:19:52 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3b0a9de9c2aso1192290a91.2
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 23:19:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1795072791; x=1795677591; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cX3RJ3lczZMpwzQnXoneBQZZ6SSE5cGoZd2UZFTipl4=;
        b=YZNyUmtt3G2VXNfUkCr5Vo03xCPWFboa0R5UNkDwlX1SxNLwaYwhwxMuDmplGyLga7
         xTLxw7SaFjyPvOeBabQCukWWUMLNAJYsDe+XkRux/0b3HKfLM/4+uKnW1wDrZ6ohoSyn
         TfqHet6MKU1T/EM34USF0WmSvcgS4NQ6Sii/E=
X-Received: by 2002:a17:90b:4488:b0:3b0:e388:d9da with SMTP id 98e67ed59e1d1-3b3d0761702mr5398087a91.29.1795072791223;
        Wed, 18 Nov 2026 23:19:51 -0800 (PST)
X-Received: by 2002:a17:90b:4488:b0:3b0:e388:d9da with SMTP id 98e67ed59e1d1-3b3d0761702mr5398062a91.29.1795072790636;
        Wed, 18 Nov 2026 23:19:50 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b402981814sm748560a91.2.2026.11.18.23.19.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 23:19:50 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v2 13/20] scsi: mpi3mr: Fix the lowest phy number for phys 32 and above
Date: Thu, 19 Nov 2026 12:41:25 +0530
Message-ID: <20261119071133.127282-14-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261119071133.127282-1-ranjan.kumar@broadcom.com>
References: <20261119071133.127282-1-ranjan.kumar@broadcom.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

The phy mask is 64 bits wide but the lowest phy of a port is found with a
call that takes a 32 bit value, so only the low 32 bits of the mask are
looked at. For a port with only phys 32 and above the lowest phy comes out
as -1.

Find the lowest phy in the whole mask.

Fixes: cb5b60894602 ("scsi: mpi3mr: Increase maximum number of PHYs to 64 from 32")
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index ecf312f007dc..87f2e1841ce3 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -587,6 +587,17 @@ static enum sas_linkrate mpi3mr_convert_phy_link_rate(u8 link_rate)
 	return rc;
 }
 
+/**
+ * mpi3mr_lowest_phy - Get the lowest phy number in a phy mask
+ * @phy_mask: Phy mask of the port
+ *
+ * Return: The lowest phy number, or -1 if the mask is empty.
+ */
+static int mpi3mr_lowest_phy(u64 phy_mask)
+{
+	return phy_mask ? __ffs64(phy_mask) : -1;
+}
+
 /**
  * mpi3mr_delete_sas_phy - Remove a single phy from port
  * @mrioc: Adapter instance reference
@@ -613,7 +624,7 @@ static void mpi3mr_delete_sas_phy(struct mpi3mr_ioc *mrioc,
 		mr_sas_port->phy_mask &= ~BIT_ULL(mr_sas_phy->phy_id);
 
 		if (mr_sas_port->lowest_phy == mr_sas_phy->phy_id)
-			mr_sas_port->lowest_phy = ffs(mr_sas_port->phy_mask) - 1;
+			mr_sas_port->lowest_phy = mpi3mr_lowest_phy(mr_sas_port->phy_mask);
 	}
 	sas_port_delete_phy(mr_sas_port->port, mr_sas_phy->phy);
 	mr_sas_phy->phy_belongs_to_port = 0;
@@ -644,7 +655,7 @@ static void mpi3mr_add_sas_phy(struct mpi3mr_ioc *mrioc,
 		mr_sas_port->phy_mask |= BIT_ULL(mr_sas_phy->phy_id);
 
 		if (mr_sas_phy->phy_id < mr_sas_port->lowest_phy)
-			mr_sas_port->lowest_phy = ffs(mr_sas_port->phy_mask) - 1;
+			mr_sas_port->lowest_phy = mpi3mr_lowest_phy(mr_sas_port->phy_mask);
 	}
 	sas_port_add_phy(mr_sas_port->port, mr_sas_phy->phy);
 	mr_sas_phy->phy_belongs_to_port = 1;
@@ -1427,7 +1438,7 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 	}
 
 	if (mr_sas_node->host_node)
-		mr_sas_port->lowest_phy = ffs(mr_sas_port->phy_mask) - 1;
+		mr_sas_port->lowest_phy = mpi3mr_lowest_phy(mr_sas_port->phy_mask);
 
 	if (mr_sas_port->remote_identify.device_type == SAS_END_DEVICE) {
 		tgtdev = mpi3mr_get_tgtdev_by_addr(mrioc,
-- 
2.47.3

