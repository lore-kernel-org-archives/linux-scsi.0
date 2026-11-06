Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793926708;
	b=KGAG8JFiCMLRUo/R5weVzf+TIHuCdrpESirZh7E2NgfQu9wOIyoN0u0vIBwzMuOM2oVZ
	 WsXAZrzMgP/ftCNZG9Rquew84rRbvGPZqRIfb5RQis8Vi8ArAO22sDkcgFNuc0Aqu4Vfc
	 feBPvFjz9SXwA1auHS8tV6WtSvc/pvQikCOJ9Cxd+AsEnEgXSxVku2ktKGscOt2lTTHTP
	 J/G0b3ZQYI1Pob/a3dSIM/igjlzOlyxjlulKE9bbk0QTiJXF3Av1cD+lVw9LZmlxOLBsj
	 oWTo1xkkecNrQjZQXSS7Q1MhgbQmfiIqzdS3TBk/2jXsqipcYXxSl8vzv5TtJRDKAgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793926708;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=Q3x5VOgbP1fOQpHzV0rjrBPOffUpWylb0b+X3NUC47g=;
	b=BYiuom4bC3xh8E++4hheqzIj6KZn9TVFqoYeIUfShENhAN+GQe0Y1rxU1FZDjaJt5gys
	 nYfoE18K5AdKOBOgbINe+sqgT9vC7ncKxCUA802veoVjKNaGdpqhTVI4gRkKJ7GXnJJ6G
	 kH/y887Qh8RfDaBlXnDThaxPpLGd3opb/QQWVJI3h8gB4jyj49yJ1k0MRcPbF8GqjyH+7
	 oJe3mDcYSiLQhMU+fsevuX0uQEdgX6rnD/BH+cYv/mXWcwQ0IEpyT0IYIOMu7cOo1sBF9
	 S805h7+iYY32Vj2GX66OugTjbH9XmGaiObhlqzJV3EjqGcR8DsPYQi/gM1Q1gojK+cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=fOYa7dtt;
	arc=none smtp.remote-ip=209.85.215.225
Received: from mail-pg1-f225.google.com (mail-pg1-f225.google.com [209.85.215.225])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B004606A32C
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 00:58:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9B004606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=fOYa7dtt
Received: by mail-pg1-f225.google.com with SMTP id 41be03b00d2f7-cc4aa0246b7so34299a12.3
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:58:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793926707; x=1794531507;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q3x5VOgbP1fOQpHzV0rjrBPOffUpWylb0b+X3NUC47g=;
        b=x3axBt47modeAgD8/s/TG2o7neq6NmNLrvcWmie4io1sV0K9UQVs3B+478KDCftVbK
         3AkD7wItCC1KdxJCx9Oz7MpTa6EfzSGcmRrVca0W/El7rSqLpQ3QScz3jfH3EJ9KFa+V
         WBholsXGevZzlHjx3urT0wTcLbwjubtPQSDaM+v6Cb8AefQ/uWM5lhVXcXAU81wfPxSc
         7PcE4pjlCseaBJOCtuPS9TXXax4qG+p/r4oPSv2CKrsLUUijQKQ4eBnaGNBPuOfufd3t
         qG/FiYiwHaJfk1P33u6ACo8R3HajkCa9g1RYWG+jRmy8iO4bwditRPdYr9lpk77KWH4E
         qXMA==
X-Gm-Message-State: APuU4Z/lKaK4GL3iuxbozwD7vjq/EukqhEzpoB/9sD4sla7a3BqBObue
	Sbt4zArDm8R6jMPlBMNx3kPYqxluSSJifDgLpQG52yFrcnMzOSnLXwdtMDKJeix/0GtR2lYJTkg
	IMw7z+KLLeVIKH0TV0zYx3FsUG7sasS8dEPGtLFetbxn1Vkc4N7hyOHfPxPNCvY8WqiElUQ061M
	OvKeQt9vlrIhmdMR5Se0O1wE0R7OjWBfQdX6673Ap/8/g+fSqnYRuebR03LIUr9VC0bjpZrK8Q8
	bM8SDJd8YyvXXN+RvQWoN+pHvZxthlqzB4=
X-Gm-Gg: AYBFou2OAC5JaaVrKw57TtPIXc2XS4RU+P43WTYzNlgJhA4HZtdZATrhGl0etO5O2Mm
	na8XJ47vjfyaIA69fn5zPYHvkvHOY3euCFSf2Ba6CQwa6UIssCDR14jXicLPQ/VD3E1PHJL3HFy
	OBjIQxN4+Y0z+WjZGlzxfDjLfXzVmNjWl8r11A80Mm+Mt5Zfyq/r1ausIQtQqMib5cFsfvDFbet
	jsucawmKZBejk48bzkf+JkKJfTjocxktV1tKaJipzoizohCblqHm74DcsJSOHOOtdA+AwlWJNoi
	/Ru5crVb7k7NdexXjws0uRqOg0rbY9pm5uBPfFOplaaKITgsuhJmavHrfKiSu/E4w6kscfCeuJ7
	y8riOMvTyQuonI4zZQnVQ+3jyJ9eQwFx4Y+Aa7Bv9+4DeYMh+Mo4uQBfJRVxHW3uKKuaFSz1n71
	h30gEneLL8+V84o003OgNYEQ5WCYeGeHzbEtLjhKBf0uE36mlZnBkMUg==
X-Received: by 2002:a17:90b:5784:b0:39d:f08e:e6e7 with SMTP id 98e67ed59e1d1-3b0db6119a1mr708664a91.9.1793926706884;
        Thu, 05 Nov 2026 16:58:26 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b0b2e09962sm2906396a91.0.2026.11.05.16.58.26
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:58:26 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2eaf8ea208bso1133635ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:58:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793926705; x=1794531505; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Q3x5VOgbP1fOQpHzV0rjrBPOffUpWylb0b+X3NUC47g=;
        b=fOYa7dttB7Tp9J3+d90eGw9dUIpzu4K1oAHgVoILDTcFuVvVL5NYOcMc/Od9LiCMNB
         sBR/1v/hZSkgpxuzt7CAxgDWrIqDxn+SFRrV7zfHywa9Ky2SShKsXlkMUMNGP+5IkYoy
         b3zILTKCRrOeliKyUcIsuMAycm3V8fhcZrhgc=
X-Received: by 2002:a17:902:ecd0:b0:2ed:146c:cbb7 with SMTP id d9443c01a7336-2ed409895admr12592425ad.16.1793926705105;
        Thu, 05 Nov 2026 16:58:25 -0800 (PST)
X-Received: by 2002:a17:902:ecd0:b0:2ed:146c:cbb7 with SMTP id d9443c01a7336-2ed409895admr12592265ad.16.1793926704554;
        Thu, 05 Nov 2026 16:58:24 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed47d7b8cfsm450745ad.57.2026.11.05.16.58.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:58:24 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 06/37] scsi: mpt3sas: Fix invalid kfree() of fw_event_work event_data
Date: Thu,  5 Nov 2026 16:42:21 -0800
Message-Id: <1793925772-1303-7-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Drop an errant kfree() of fw_event->event_data, a flexible array
member of fw_event_work rather than its own allocation.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 085d4672db85..f2a1cedcdae4 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -12270,7 +12270,6 @@ mpt3sas_scsih_event_callback(struct MPT3SAS_ADAPTER *ioc, u8 msix_index,
 		if (!fw_event->retries) {
 
 			ioc_err(ioc, "failure at %s:%d/%s()!\n",  __FILE__, __LINE__, __func__);
-			kfree(fw_event->event_data);
 			fw_event_work_put(fw_event);
 			return 1;
 		}
-- 
2.53.0

