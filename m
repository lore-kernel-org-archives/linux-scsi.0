Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794996795;
	b=s9yBkOdJkbX0Hx4XCeAD99IHrGRgLhlb2nX70iR9/wL3j/RUgJvYSkhwhfCz+cyKcP0z
	 VOU/Gvy/dX0ymYHhHxtsoaEya0m/av+M86p/2PqfsJdpi4ZsAUhLyYpNLsYzfbsLvfk6H
	 DQ4Kbo1fSkz+yJIZnrcwejOA3Z1PG2CBLemGaJwcgsnVPC0+IAnNrZaXpKUHZsGUHddY/
	 TQn5W20nQY/d6RuNcgNWRkEccjGlKKTEofI42frfp2qDQnW2qflONzVFI6mlvxipIQ8n4
	 4b4n49W0SGcIyYAzZSP3gqvWNnNGxs+f6cCtjXvIk8mIHNBOQDaHsvzUFm0+8FI2Qvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794996795;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=5Vj34yDsuon5YovBq3PktOJ0J3tFulYVLt4QDyFXMlU=;
	b=NLr//FEsktYV22o/gmgG7iSWRDflRt7M22g3be81ZUNW31CIbd564RxyMk0IaLH+OKYf
	 RdsNTZcey9+44i35Vc3PgT3OBcGBfw/Jxzj7I59pM+0IaBufi8yLAf3cK1cUVAD3pRq0Q
	 hDqaGtnOqdZBBL7O30mLfjdAEaJEBShBYrP3lEzAl3dDHnkxHggk/yi/60aAFcK86mU+v
	 /3uyNuEaxCXY34QPkMqZ34qEtbWFXzm4qv3PFFLsq81L6ajNZ/zB9d2vLoaOHOnEclSJg
	 pX0DsCliDQImmcRck7ISciQhiq9gpjJdMflNpgft/aPRDQGM5Gan/ZOKfG3i2rWhjgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=VRb2VYTR;
	arc=none smtp.remote-ip=209.85.215.225
Received: from mail-pg1-f225.google.com (mail-pg1-f225.google.com [209.85.215.225])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FAE606A320
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:13:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 04FAE606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=VRb2VYTR
Received: by mail-pg1-f225.google.com with SMTP id 41be03b00d2f7-cd62c570b5dso662504a12.2
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:13:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794996794; x=1795601594;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5Vj34yDsuon5YovBq3PktOJ0J3tFulYVLt4QDyFXMlU=;
        b=qK6Kyu+M3sPmVMpyENB8E4j9QoqAjtvU5uGCOACE3oeRp8boMdnXYhuQmdEB295c+G
         tZjLsgax67pJdLdi/8C0xvHpKWWYQLiuVvFsKU7999CnqPx5/IkAJOOQmZcfogr5V6bn
         jBwthUg9gzw2GfUa0wzhf8cmZ6KpOJkmslUzIceCSrHcpX/LaXxjmGCSSnLXkLHxkb8P
         2dg5e/Aivub1sAa30cOmy8YlUdbixt2k1c1+C88T5vIGbbt1INH5xNmXCvh6cnoCPafH
         SeAtDvsLBE+gOs3VVLh/wCe1fF10N7TGOENzG9H7lyqk5ZwIyQU/nn9HoSFw7XVUu5of
         E+Qg==
X-Gm-Message-State: APuU4Z/jQvZZOLNACtpCR/DjfGlnl6exhJHeXm+deXmCB5eyZtHIjIXn
	4pqmCjj3lfZ1FnluOhsSTgPOLQ5iOYZqCmbBn8wJ8VeInInjzc0UHpC2cEyxCcDRnP8pl8zzq/K
	ktjHgLwBn3TjniKQ6BVe+uvlBFtqOl/zbT2T3/nZi0Hnp9JMjCLDFn6DaMP6T3KBoNHhPavN48q
	/Q9lcFkyR5qWJqJ4hM2TYzG7/bLhtE7pj7F9P1u2Lkc4OqEeEZrHYBUnq2YxzTpVzSl77m4XLH3
	GVblObwjQqywqcxthRoJV71AG6kXCIuhnI=
X-Gm-Gg: AZFdTZcIn55ODkcFmT/du/YORIOZsR6jOGXoPZ2fkqXRwO/k7gjcDVHaUO7lhTkPKjN
	cjyes4CD5R4rElqVGQoG/7S/DisMqbZrxFqylYnFpujrcx+bfFGuAvAPE6sZrRK1iPuqOaBvHNT
	7cX0ZOaZZeXaoabsUTzszvTzqJz8FXlRcasMPDStiLNxSpXUZI7jznwZvOfbYmfTW1/szYtThZt
	WW/ri3MAcxpmLxTZbU5vmgXlYq4Hj05IkatZtO8NNrkQiqvFblLp5Nl1Ishtp/6ZN0s1PJT5884
	dHtwRqHDvNyLnvpE0VyhI2dTo053nFzLUpjNNlNrdHi4lbIy6RPqwGYS/svz/x6OjLzPnf0d3D5
	GiShb+V5rEJnhL6of0si0seQ4+NZpshNaLJBEc8KQHx6a00Trf4i2j2Lw6GZ4+eb8TZQO3LPnAP
	MsAuqchhGpJfn1yu54WMBEtIPAyCCwrw8/NAD19K6Zg/Kt44LMoeITmflF
X-Received: by 2002:a17:90b:1649:b0:3a4:b418:94ce with SMTP id 98e67ed59e1d1-3b3d06416b1mr2383597a91.1.1794996793958;
        Wed, 18 Nov 2026 02:13:13 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-123.dlp.protect.broadcom.com. [144.49.247.123])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b3d19ca5b5sm697081a91.0.2026.11.18.02.13.13
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:13:13 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3b3b74351a4so872391a91.2
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:13:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794996792; x=1795601592; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=5Vj34yDsuon5YovBq3PktOJ0J3tFulYVLt4QDyFXMlU=;
        b=VRb2VYTRPKUer03JZKb2rZeKzxCYwFwvUqB5RVbQK0zlUJzLBHbV6GchFSNHD2cwHj
         jiSYEWDRFyniNlfCNikUW55iUg28x4adEIQtBqsoICmgNTwfqh0PLaOplktxDeSmH+W5
         of1KwlX/Y0AO4a+GLSMHDOUeUFQcnqEPK6AoY=
X-Received: by 2002:a17:90b:3e81:b0:3b3:b373:6a6a with SMTP id 98e67ed59e1d1-3b3d0764a68mr2311797a91.28.1794996791854;
        Wed, 18 Nov 2026 02:13:11 -0800 (PST)
X-Received: by 2002:a17:90b:3e81:b0:3b3:b373:6a6a with SMTP id 98e67ed59e1d1-3b3d0764a68mr2311768a91.28.1794996791318;
        Wed, 18 Nov 2026 02:13:11 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3ac6016c3sm8740707a91.15.2026.11.18.02.13.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:13:10 -0800 (PST)
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
Subject: [PATCH v2 20/37] scsi: mpt3sas: Validate CurrentHostPageSize before using it as a shift amount
Date: Wed, 18 Nov 2026 01:56:29 -0800
Message-Id: <1794995806-5835-21-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Reject an out-of-range CurrentHostPageSize instead of using it
directly as a shift amount.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 14 +++++++++++---
 drivers/scsi/mpt3sas/mpt3sas_base.h |  1 +
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 07af8542fbc7..0b4b8aad2162 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -7553,12 +7553,20 @@ _base_get_ioc_facts(struct MPT3SAS_ADAPTER *ioc)
 	facts->CurrentHostPageSize = mpi_reply.CurrentHostPageSize;
 
 	/*
-	 * Get the Page Size from IOC Facts. If it's 0, default to 4k.
+	 * Get the Page Size from IOC Facts. If it's 0, or outside the range
+	 * of page sizes (4k..64k) the driver can safely handle, default to 4k.
 	 */
-	ioc->page_size = 1 << facts->CurrentHostPageSize;
+	if (facts->CurrentHostPageSize != 0 &&
+	    (facts->CurrentHostPageSize < MPT3SAS_HOST_PAGE_SIZE_4K ||
+	     facts->CurrentHostPageSize > MPT3SAS_HOST_PAGE_SIZE_64K)) {
+		ioc_warn(ioc, "CurrentHostPageSize(%d) is invalid: Setting default host page size to 4k\n",
+			 facts->CurrentHostPageSize);
+		facts->CurrentHostPageSize = MPT3SAS_HOST_PAGE_SIZE_4K;
+	}
+	ioc->page_size = 1U << facts->CurrentHostPageSize;
 	if (ioc->page_size == 1) {
 		ioc_info(ioc, "CurrentHostPageSize is 0: Setting default host page size to 4k\n");
-		ioc->page_size = 1 << MPT3SAS_HOST_PAGE_SIZE_4K;
+		ioc->page_size = 1U << MPT3SAS_HOST_PAGE_SIZE_4K;
 	}
 	dinitprintk(ioc,
 		    ioc_info(ioc, "CurrentHostPageSize(%d)\n",
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 43586baf049c..6fb511530637 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -134,6 +134,7 @@
 
 #define MPT3SAS_RAID_MAX_SECTORS	8192
 #define MPT3SAS_HOST_PAGE_SIZE_4K	12
+#define MPT3SAS_HOST_PAGE_SIZE_64K	16
 #define MPT3SAS_NVME_QUEUE_DEPTH	128
 #define MPT_NAME_LENGTH			32	/* generic length of strings */
 #define MPT_STRING_LENGTH		80
-- 
2.53.0

