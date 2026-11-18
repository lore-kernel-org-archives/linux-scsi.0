Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794996740;
	b=Utzi2iaDQGc++yF/GVH0vD8DOcZLIvE0lIij4jTac2UGBY2qkLKCHR6ias0kvxRd3qQ1
	 BiX2nyx+CJEXP4GrYjPObCtKxSmILit0ZJmuKNfb1FUYNYNZTYs2yfGGw3bE/IoRWS1DX
	 /mOaThGDnAtGg1Xi2GxKDmn4QnJqx7VkT4GYjqHLy5nuZQSb3RESL1dNPUukpTsFRXdPO
	 hR3zDcL8m2OwweKSpVl6oJoccomvO5/6MBHXD+QseAJvyptZbQabLKvk23M2Kv6WbhXFs
	 IyRVHFpJu9UgkkOytj5JIBk8p++Hrl8LjjX2x6ks/4V7Hx9cYghhOum4t09RoHZpaJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794996740;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=3XZ75csC6Eenl/OFpVvyiIQ6tmTJ2//2Pf9Iqu1dnRQ=;
	b=jJjxXP1IzffhCHHF7v/gpLZ0XwrrKtYdvTMjTBxqQytlezLZa4fREqrup/CPzjmFjINE
	 vBrY2UUAoG5nHnZciTOjvGwxnYbtxlUFZ+/v2fwthWER9ePPttRACTXGteOzEgxzRklGb
	 GgswE74PT4nzvHpZA2WRzM/UYRS1GVM1NBT8QSTFzH7Xu+TK4mFawsoiy3B+3wXHYfDar
	 diaKFPxE6msSc+vAJ4WuUpRWEq5xV1v2uk6LmgrinP+QIRAy663nlumfQFd+Ue2p+/i8+
	 BnZeqGOi7+mersuf0aX1sgLl/QCo0mYmraC8tEF3pL5c0/SvhIwq2j04szj8kg1mQ4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=YLtqjFFr;
	arc=none smtp.remote-ip=209.85.215.225
Received: from mail-pg1-f225.google.com (mail-pg1-f225.google.com [209.85.215.225])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2697A606A332
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:12:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2697A606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=YLtqjFFr
Received: by mail-pg1-f225.google.com with SMTP id 41be03b00d2f7-cd60c5da24cso606647a12.0
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:12:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794996739; x=1795601539;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3XZ75csC6Eenl/OFpVvyiIQ6tmTJ2//2Pf9Iqu1dnRQ=;
        b=CP7IlKRqUNAklE3fdWhkEXeLaOK9UBAwCxHskQY0PQPCBBKCoUMdRwrJiKOT1M3pkS
         fHmjN+U/WIM6vNkU4IQrleiuQ5gr+ety8w5mJSllbCe+qACUpLQQHWxaIuA9q3d63wRc
         H/oVUHo6kc+baO7IcWPlNMGHFH4AlVjJXTtDpgv34OqbNttNRet7plw19Dx0q5zM0dQ3
         Zz3cPtG9HGTED+Ld5dBB8pIaFieXt92Ztkph0Zwq72Wl3dtrdemr8KQ/UBvZCv99AyN1
         ktFQSwxy2egK8IHvPIXFPISz6zvqRmx07wkfdrZwRfEISmRDLR8t9OLThgNQMYcrv6JW
         1SXA==
X-Gm-Message-State: APuU4Z/JBoYGUxt8d4khPekmxrm84jll/TwdZ4UQQut6DRhVPoSNy+fl
	7TMVRtrzyZnvhWrm0L+ytmL3qO8XIoLAuovtou2WDvXRR2euScfJZemhvIUyWhlHes5IxfgiEY1
	RV/LVG+8lIRtZBrt/lNJvs6XCPRCV8yzJTF0iYMOltXhPhy5YdMasD+q6vzvdC8NN8Of6gLuT8I
	+TXg27/0nymxP1mfqX3wRxPcB28spSHdlgTe9JLUXkqRHtVXTW/D1Rx5w7Y7epd8V/6lE3DDu4L
	41+rxELFklrcW14sDDX/haL1tiYzRT7Jv4=
X-Gm-Gg: AZFdTZcUGnLEjewV9KQE35w3XjhYJqOrTwHNDS7xMYQ/4Dn9cfWNO2Ujo0vF1N33BUF
	pG7FSNKOTeo7Z1wAiqRXaxi/5PEIlH8/3Un+bcdNKZbb0VWiEL9T/4HWPVPF7xRR1CX62/od5rB
	FafRnyP9iKd2MC5HZDsViI9MyaWawqGchGpE7ZeeLHTQOobUtMjWHuJEqjxM2j/yIm5zeKMLLH3
	2MUvHEn1FaAkEQdHx4kBM+N4rqksI4O2VMFPgV86qdOLGxkW7HMhqER5XEsFcmVe5/me/XmprUK
	g3HWOjCQV6HVw9UR9xjTKMn8KCgmuFwn6NoUjqK9LHraQ7lU9N506ZEU+vs4ywQSAqQNwyMzf3d
	q/I13wFQVi0CSxAUXTu5Y25YbItQl8hIXjvZpn6L7wi79xiyc7abRUY+8cUem5vQLW2WM8feN3F
	tp+1p/6ZG9XVvheimo3AM3/QNfwiLuFFsel1ZYVZX+ciqr2XJVyTQrsPMs
X-Received: by 2002:a17:90b:1b07:b0:39e:6c6a:6580 with SMTP id 98e67ed59e1d1-3b3d07d92a8mr2118492a91.67.1794996739429;
        Wed, 18 Nov 2026 02:12:19 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-123.dlp.protect.broadcom.com. [144.49.247.123])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b3d14c0525sm1611986a91.8.2026.11.18.02.12.19
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:12:19 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cdd9fa2a558so887609a12.0
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:12:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794996738; x=1795601538; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=3XZ75csC6Eenl/OFpVvyiIQ6tmTJ2//2Pf9Iqu1dnRQ=;
        b=YLtqjFFrrca2K7EEVdZnUnDKGMPbQ9xEvF5oKxjrrO2w12wkz0tquRYb2dm5hUGjcp
         tskaEtevIuDjlkoF9Ih2OiEl3EgJ/uVW50mxIrE2UcNT0TvcExSkASVjvOk6YFIK6ICN
         1W2FC444T5+mU+qNs0mR3m7vbdw1DM99I/LDA=
X-Received: by 2002:a17:90b:2642:b0:3a4:f75d:d194 with SMTP id 98e67ed59e1d1-3b3d0765fffmr2179808a91.36.1794996737770;
        Wed, 18 Nov 2026 02:12:17 -0800 (PST)
X-Received: by 2002:a17:90b:2642:b0:3a4:f75d:d194 with SMTP id 98e67ed59e1d1-3b3d0765fffmr2179778a91.36.1794996737252;
        Wed, 18 Nov 2026 02:12:17 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3ac6016c3sm8740707a91.15.2026.11.18.02.12.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:12:16 -0800 (PST)
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
Subject: [PATCH v2 06/37] scsi: mpt3sas: Fix invalid kfree() of fw_event_work event_data
Date: Wed, 18 Nov 2026 01:56:15 -0800
Message-Id: <1794995806-5835-7-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Drop an errant kfree() of fw_event->event_data, a flexible array
member of fw_event_work rather than its own allocation.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index f78fc0faad61..4bc2f7ce4aa2 100644
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

