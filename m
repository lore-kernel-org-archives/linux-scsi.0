Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794996791;
	b=BmXKXaLRdM/EeLSg8otfe0tlN024deT+fhrgoLGnSo2hEKy1OR9rMKrnOTA+DdrJfoVp
	 dXt8Da6vFHcanUvfyxlUdRVUJSAwaufloNJkc8Q2oEPVgGcNuOPplfNL7wNysg3y6VV6z
	 C0vXRbML6eSwgcGrQ2WwvkQ/ZpENFmQyw+I8L+nvYM4PCr0GzRFxWuhPWeeT5MO6TAx6r
	 j2EHhVNLg2I+0TBfSaOCA8Y779bPrHoLjwxcThOl9lDGA03r7TriVloXZ7xrrnXWkj0Rm
	 ZmzsBx2ULCZJAaD6ZbhhvVvZLwX/8wMNqKFcv1lcpfGevS2wyy+1wsh57cbmMeq/n+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794996791;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=ZepaF5ZjILEGF2RJZ8YfzJS1zsqRfD3aJ64PJj+03uA=;
	b=H/T/j4qFvk0xaCKl/mpc0CtODVJiu0OwWQHz2Ak4cEFqFoBWYo5bVpb3eCXTdAjP+21w
	 qJTitfgcs96icYK/1S+bWkjKZBCI9shWih8NGwz0qYuuaqH6jL9ZUR+H7WHzUPtJSvkq6
	 OKO1HTF/+XiOd2k64dyzs/ACx84DwHJXqhGlz34WjGy4AWzAaDSCGJCuNTJ8THCZuafpe
	 H0Ejq0yLpn/9kJ/+/qf40J0XEWdTqVeuusZ1kRxvNe2Pzn1sVofn2+dXm9YCM52tsgFr5
	 h/9sfyMl8N/KYINGgUpdIU99A6tK9dUKwgEKbwy74/Ckcyo1jzKLUXkpveP9QGMOqvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=Q+k3O0Gb;
	arc=none smtp.remote-ip=209.85.215.225
Received: from mail-pg1-f225.google.com (mail-pg1-f225.google.com [209.85.215.225])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B12606A31C
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:13:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 64B12606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=Q+k3O0Gb
Received: by mail-pg1-f225.google.com with SMTP id 41be03b00d2f7-cdb75699c7cso405735a12.2
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:13:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794996790; x=1795601590;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZepaF5ZjILEGF2RJZ8YfzJS1zsqRfD3aJ64PJj+03uA=;
        b=YGYUsVhA2bxcMDL7pAPhc7p0umtt6cXmK1KNJiTUuUSZRiqD2620NnPM8+rZ2kFhRO
         pFAwZTJsuezUNkF6FuaZaGVTrpDZiA2QN2h1/S0/zZUHYqNS6eV1z0LcVjta67AuMIJV
         RFriDv4MWHzy0lUqmxXzM3nFTzDadGqoEbGI8up+fc0y+6ppopfTcjj10hRl1z/IQuM+
         YwVK2jKXZx4JCFtf5PqdArg/Yf4Uv4IG4nDmWOqQPcmRVNKIPqVKQpktLjsU3AMA+5YY
         LWutTE/f1MCdZmulONmKZFjDSCHh6xNbQkZ0CkCv0Y8mkwnBrUHLzefD1YNpXRJwiUAF
         1rNQ==
X-Gm-Message-State: APuU4Z/FOIlCHZ5lvRkC3pRjx+xGRVTMYz7kLmziOVOGaSKrbfPA3ZmT
	TCUZcnin26kfz4Vc41PGwyCdNIa/pqtcB8osoz4Bwx3NRwqHdUg1h0SGeLxXNmPxpyF/mNosbOT
	LO5HF5cKUv7uJCxwCaWP59nrlLsmTyr2j6tJHKtage1pzS6MDiurE8KwmQIk1WalxVQ9+AuJaz3
	Lf+qGanDh6qBWRmWGawyja7MwWQcjK/MkJxou6ybASk7q6eyqO5uIarVlnYvA0eD39LSVd+5sWD
	nlBXz43ycAac3nuNbz0yzd2w3ggJmA1GPU=
X-Gm-Gg: AZFdTZdZ6VHPcA6Vqlo20RjxTlIRBKpdDpKc/P7QY07y9hKK84J5KwX0Ioi3tb7EocO
	/LzdJMPXLLcOR8KTl4y0rd1jw5M1lglzP6A4R3Ul2I/HwSe/pw7JSnl7L5fLEgap63Cjh4AcbDE
	wz5NxBJAJk8rvifqvNEOz1Q1MOeRe+AM4JkjyDXUyc2ZOsSAJ/97smL+pqT6kCHXrgh/4ZE8hB2
	qkTQmUlmNCGckR76zpCxvhtFivOuRQtoia+bXB/OenGWt39n1xg59nGJLz8ZYCkr981hDUMCdrw
	Sbx6XqDRJDwfEHOFcBRvZQsTWC3YHXgK+hA9OYlpK5Yi6tW8QbjDITwCRaUdvcNoYq5x+3All4g
	LjxYPBVTeUShdWZ+BPUI/7p5poDOfmJdhw1qs20RdbAxU96IfQCoqOuJMzJhwRZK691CfQDU3le
	GY6AAm7u/vLQI3HJagCQvAJ1+dP1F1uOwLPQzr9uiyq5O+IL2LnCiq7zQO
X-Received: by 2002:a17:90b:3b8a:b0:3a7:b260:9ced with SMTP id 98e67ed59e1d1-3b3d07cafb6mr2318231a91.58.1794996790142;
        Wed, 18 Nov 2026 02:13:10 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-123.dlp.protect.broadcom.com. [144.49.247.123])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b3d8b8ce6esm379457a91.4.2026.11.18.02.13.09
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:13:10 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ed02a00b24so8111525ad.2
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:13:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794996788; x=1795601588; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=ZepaF5ZjILEGF2RJZ8YfzJS1zsqRfD3aJ64PJj+03uA=;
        b=Q+k3O0Gbzqj8byirXqGi5i1lpCtjNysdzcY2n7HxADEUsa4Y8muqhsJfPf+Mvu/tqV
         lrp1kEntzBy1CVtDC0Z6Rlfu38ioXyZKYyruJNOq5tg4TXgYg/XhWFmyZqNxTMzFq938
         FzANFTINmOlvHa/is9Sj9Z00FaVO9knOteZWw=
X-Received: by 2002:a17:90b:448f:b0:3ac:9c37:942e with SMTP id 98e67ed59e1d1-3b3d07aba04mr2289190a91.49.1794996788041;
        Wed, 18 Nov 2026 02:13:08 -0800 (PST)
X-Received: by 2002:a17:90b:448f:b0:3ac:9c37:942e with SMTP id 98e67ed59e1d1-3b3d07aba04mr2289154a91.49.1794996787380;
        Wed, 18 Nov 2026 02:13:07 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3ac6016c3sm8740707a91.15.2026.11.18.02.13.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:13:06 -0800 (PST)
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
Subject: [PATCH v2 19/37] scsi: mpt3sas: Reject implausibly small MaxReplyDescriptorPostQueueDepth
Date: Wed, 18 Nov 2026 01:56:28 -0800
Message-Id: <1794995806-5835-20-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Avoid an unsigned underflow in the hba_queue_depth calculation when
firmware reports a too-small queue depth.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 18 ++++++++++++++++++
 drivers/scsi/mpt3sas/mpt3sas_base.h |  9 +++++++++
 2 files changed, 27 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index dca07b97dfb4..07af8542fbc7 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -6453,6 +6453,13 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 				(ioc->reply_post_queue_depth % 16);
 	}
 
+	if (facts->MaxReplyDescriptorPostQueueDepth <
+	    MPT3SAS_MIN_REPLY_POST_QUEUE_DEPTH) {
+		ioc_err(ioc, "MaxReplyDescriptorPostQueueDepth is too small (%u)\n",
+			facts->MaxReplyDescriptorPostQueueDepth);
+		return -EINVAL;
+	}
+
 	if (ioc->reply_post_queue_depth >
 	    facts->MaxReplyDescriptorPostQueueDepth) {
 		ioc->reply_post_queue_depth =
@@ -6463,6 +6470,17 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 		ioc->reply_free_queue_depth = ioc->hba_queue_depth + 64;
 	}
 
+	/*
+	 * Ensure that scsiio_depth and can_queue cannot underflow
+	 * after the clamp above.
+	 */
+	if (ioc->hba_queue_depth <= ioc->hi_priority_depth +
+	    ioc->internal_depth + INTERNAL_SCSIIO_CMDS_COUNT) {
+		ioc_err(ioc, "hba_queue_depth(%u) is too small for the reserved command depths\n",
+			ioc->hba_queue_depth);
+		return -EINVAL;
+	}
+
 	ioc_info(ioc,
 	    "scatter gather: sge_in_main_msg(%d), sge_per_chain(%d), "
 	    "sge_per_io(%d), chains_per_io(%d)\n",
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 3c5d6803e56e..43586baf049c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -145,6 +145,15 @@
 #define MPT_MAX_HBA_NUM_PHYS		32
 
 #define INTERNAL_CMDS_COUNT		10	/* reserved cmds */
+
+/*
+ * Minimum reply post queue depth for hba_queue_depth to stay non-negative.
+ * Values 66-79 floor to 64 after 16-alignment, making ((64-64)/2)-1 = -1
+ * which wraps to 65535 as u16. The smallest value whose aligned floor exceeds
+ * 64 is 80 (80 % 16 == 0, giving ((80-64)/2)-1 == 7).
+ */
+#define MPT3SAS_MIN_REPLY_POST_QUEUE_DEPTH	80
+
 /* reserved for issuing internally framed scsi io cmds */
 #define INTERNAL_SCSIIO_CMDS_COUNT	3
 #define INTERNAL_SCSIIO_FOR_DISCOVERY	2
-- 
2.53.0

