Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.226
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794996760;
	b=CBNi0/b9WxcH9YF8YoTm1yzYFYP+S/6GTHKz79oyzI02AIb6e+6AjFNpwFx9GRAO+aSx
	 59oMqM/GKTLbbBVIjMm3ZaRHrLy1T5XjbCMLN+JUUgyuJHzr6/oNmvBfvVSac6V90FBBc
	 2ioSXtjgFoy07L+FFsJbNoc5H25pwUl2Dacj0/VYMK+El4N3jf3LGK5vYUtdSewx25rMN
	 3Gqy/6CcJ7sxcZ9Edflip5KYdnGvF0HN9JiRKdNarBDVgGxTPTVNDsbqRQNla2FEQ+OFS
	 kU6s/tQJjzZ0yXfUhvqoT3+DWyQDY+Qlp8Rmcm5Gw3qlX22z0XsDcHGIWrL0g7BGPdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794996760;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=qyPNKLsBKUccWJTqLDcFfQpIPaJKZtIHP2jSWOMcD+w=;
	b=bu0SOT9Wb8oN25msHLVNgwZS3ST42qsqR2sKzHpLiDkJFNhX1TbrBbMIcRfNliuMQhRs
	 2UEIkyEwK4zeoppNKoCT0iSf0ugEP9Z9p5pgm5RFOkSwYQhL3asOElThNWXoXmmZfJVjr
	 dQk7UaM1OUS5RbKA41XcpQArbjaopQhLeuE56PPUgGpaMW88tTF0clkY503k+d//Aicdr
	 2eq1llYr6J7gLLNOnJlrYOnnyFumxbZVPtd+SzphdIPU9TV59fhpFh0rah9UCFuETCjgI
	 wWlD0s3G1uciGCbDexXEc1u4FUPrW92V6NZ9yWc/np/w4vvKF0Dk9rnIUmemPoeUMyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=FlmAu8jN;
	arc=none smtp.remote-ip=209.85.215.226
Received: from mail-pg1-f226.google.com (mail-pg1-f226.google.com [209.85.215.226])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C89606A31C
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:12:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E0C89606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=FlmAu8jN
Received: by mail-pg1-f226.google.com with SMTP id 41be03b00d2f7-cdb75699c7cso405547a12.2
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:12:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794996759; x=1795601559;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qyPNKLsBKUccWJTqLDcFfQpIPaJKZtIHP2jSWOMcD+w=;
        b=beSM7y00X2DcR71dfQ9Nb02suYDqfHY5MC3y+37KLE7WmTgD6eOspeep7Iv1Shthgo
         xIqkAiv8qNnvhxPR0Ubbn0NoF9DFEG67aI4nTGqrrppMHeFgDnfTytTJCxqT7VFjKbqY
         pnOD3MfREbTg2BfAZD3NaY/1n+/6BeTQLsWDZTloK4IZQ2IzGc8Lb8oe3d5L4kYN5f9j
         vpJWKxa9ZMjEjzwiszS+x2EF6lUiHY0IWGL8Qx1Sf4AOOy3rI4BazOcveglW/h3MIN04
         Hgktl2MqrJyh5pdl8Hx4gF+yVRqKm+Jq7X64yNqJIo6bJDvLdqULWhanL9t08shCzzsX
         JXRQ==
X-Gm-Message-State: APuU4Z8+IHSHbDgE0aMi3njKO/kfZqpbO2Tni+QLTBpdgf1juWRXGWfZ
	So0gQA6KbLbTYsF6KFOXidO3WerwqhiB6QkcQDsEsW3o2n1VL+jfrg2yJRmtyISQRyaX14B5PeZ
	7AhfgNlW/riqPnAvp+uOap5LymkqaNyoGuyBYa6zdj2xEnKfCLd+grPbK8giSx/OTGzHdyAH7nN
	woOLr/mLNVOhMXGvSk5h3zjILnQK5WWDv2WGAMVvDriROxzNN3v050vsc1U2+aCzCP1hWEp/flz
	MWjQg2+MVeDM1ascYDQsklnZyVHR39FgYw=
X-Gm-Gg: AZFdTZeNBoN8tHV7NOlvYrAFc2Y3O5h2sfPHfK2v9gJLHGOdGPcCMk5Szf8NfkMp04m
	yskY64Cz+L+yecbR17BRYvqmCg+azAffqYiGMJtqLWpxrzMmIUw7PrstccmZIIESRWv1Y9MsjXc
	dqtlJz8A2SUQi8aiHPkklQpVFG3G+BrjQBjvwqp53dX3MYAFhRa0seH7j8aODQQSF/qUmtThstp
	hkoXsRM44XmgRipqJVqANtaAKyl6ZHugOTGc5uMrmfr0qJjKWyNYg1RPyWE3Ny8DTL8vnFmzlHj
	AFmpocoLc+gzZ4edjWoTA7iNgtyvG/8QOTK7k8EJKEXbFar5jL8TrLvpaKWECqgkpzdmMRGqfiJ
	PA9wEhKVKUzRttww91HEJEEW1kmUByizsltRZiVKjg+X0IYkspwUjXdsQMizBgbX68KUILP7KwN
	UL9Vh27ZyY6OK3wGN6t1XFdXx0Hte1vKYB1Fn+JIhc8j/9l4mz+lCFNQ==
X-Received: by 2002:a17:90a:d44e:b0:3ac:af8d:c839 with SMTP id 98e67ed59e1d1-3b3d0764a35mr2192426a91.35.1794996759254;
        Wed, 18 Nov 2026 02:12:39 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b3d1d8dc62sm695896a91.1.2026.11.18.02.12.38
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:12:39 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3b08aee6b3eso748993a91.3
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:12:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794996757; x=1795601557; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=qyPNKLsBKUccWJTqLDcFfQpIPaJKZtIHP2jSWOMcD+w=;
        b=FlmAu8jNYkM9VzVjwQ8nUgFgtOUUVCbraHtsl3WAHmw4VUht7QPfOhw1ojhduUx8UB
         LLZERHGKY5OqFQArOtzEnDas5Ie+aPoLquOwB/jUR8+zCKu8qTFhaQQ0W9fs1dQWtBVU
         xVCNk9rnCapxeUrn5UBJ3EQxv/3jIJK2OxOdg=
X-Received: by 2002:a17:90b:4d04:b0:3ac:8af9:4a77 with SMTP id 98e67ed59e1d1-3b3d07597a9mr1786983a91.10.1794996757252;
        Wed, 18 Nov 2026 02:12:37 -0800 (PST)
X-Received: by 2002:a17:90b:4d04:b0:3ac:8af9:4a77 with SMTP id 98e67ed59e1d1-3b3d07597a9mr1786949a91.10.1794996756658;
        Wed, 18 Nov 2026 02:12:36 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3ac6016c3sm8740707a91.15.2026.11.18.02.12.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:12:36 -0800 (PST)
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
Subject: [PATCH v2 11/37] scsi: mpt3sas: Fix port_table memory leak in _scsih_sas_port_refresh
Date: Wed, 18 Nov 2026 01:56:20 -0800
Message-Id: <1794995806-5835-12-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Free port_table on every exit path, including the early return when
no ports are found.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index b6ab2c755e56..746b3f2f241c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -6783,7 +6783,7 @@ _scsih_sas_port_refresh(struct MPT3SAS_ADAPTER *ioc)
 
 	port_count = _scsih_get_port_table_after_reset(ioc, port_table);
 	if (!port_count)
-		return;
+		goto out;
 
 	drsprintk(ioc, ioc_info(ioc, "New Port table\n"));
 	for (j = 0; j < port_count; j++)
@@ -6846,6 +6846,8 @@ _scsih_sas_port_refresh(struct MPT3SAS_ADAPTER *ioc)
 	}
 
 	port_table_entry = NULL;
+out:
+	kfree(port_table);
 }
 
 /**
-- 
2.53.0

