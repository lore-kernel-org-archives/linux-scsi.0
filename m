Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.97
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793926745;
	b=jbtebF6/RMUJ4btJr7jSfOAmWG1JUotzSVgIdHPL5yvOwfoG/KP6c1B04wof5gSzkmE3
	 uptoT6cj960An7lKlIMP67LH0Vy08/edN4NAsoZwM6cHUW55HyRLcV3Z4E9dpLRj77uIp
	 U+q+vzMmYkV7KIxvt7nhGgGM274BzheweKPY9pcQLT7SdMFFH+UxW7eiECRS9H86lZawr
	 4QZK6OrT/GOHx4hFHb3tW6I/nlGoB/IRhzI+l3yGCN1vt3TFtLTepU91iN34qNuZtP2LO
	 bW8FMFxwyr35eTVkMTBrHbzaKaexu4gCVtqAW+/2SP9pNl8T8BdJkzNJDJYAnfJverw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793926745;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=UqhK1fSKYW4KXqV/Z4DRH/PaK/Vparw14oEL5YsYzKc=;
	b=prXtbbA0DR+vFFIjP6XJYaxV8W/cbJP3BwrFGcDOWOmFzGzurnZuCqBfRQ7dcwZgg4+P
	 xMrXPnXtaeICkH+A7Lkru7Pf/UxOc77JqxzYsVy7px7Z8W64fYtRo+qYkiCNiVWGryqhr
	 Ya4s3vBbknTjTh/9fGsC4Vm5QjgeL9u8KctMUZvIjy1zuM+hInSzAMAmJxHqM26fa+yaj
	 luCJEs1JhWAOblL61/Yv0wtTmEzQ3USdn0tvBlYr40CH3dFUmPQWkrw3D2MUsDTGrkWZb
	 //ScmZTLYu4ZB8wytLEp7nWOmpLTZ1WM4FAywJE5fo/N57YIkimDXDPjzMpeUYUWR6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=exmYJlov;
	arc=none smtp.remote-ip=209.85.216.97
Received: from mail-pj1-f97.google.com (mail-pj1-f97.google.com [209.85.216.97])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B94606A331
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 00:59:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4B94606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=exmYJlov
Received: by mail-pj1-f97.google.com with SMTP id 98e67ed59e1d1-3ae1d0caaedso58890a91.2
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:59:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793926744; x=1794531544;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UqhK1fSKYW4KXqV/Z4DRH/PaK/Vparw14oEL5YsYzKc=;
        b=yNVjZ/AW62shdGLWs0ZKydTegO7SEQMTxHQbHTGgmLbDx5CKkt8hvJGazmkrAXgr4z
         n1t76FHhb2da9TyN1GtG4REU6e5yC/swkpc4vNMyP508qkov/HEmSKPXsA6u7CfrjdFI
         LU/bOX3zEN9woSC/ywcN9ZVuqJSblRAVVIuv/GcwNsEuFX6B4/wDTUdNQkZozXfD9l83
         GW9eyG3HWPf3pq1up2CxE7SH/WzGsWEdUoLI5Em53iuo8PF24MRFQWgmeucV5qJX2lUq
         zHyCKAeCH3in2U40+HhNCiMy5tg7CXIM9hOaVUaXZTvda/g5pLOYlvdcaw0HXsTUdANK
         +6SA==
X-Gm-Message-State: APuU4Z8eM+b2whcRDpx+UVXHYKyTRLDV0oCf46tz9XmLUHicg/urZKy1
	6UWDYAGoWthPhhCC13Pv99eQ0RoOMG6dBIFG9dBwLxkFvFzwZL/mO/DnQ5oJ/m6M8a1dyS8x7R0
	NycwDjTAQmYo1J1yu2lGJkhGLbFMYCR4wb4TrF426cbLs7mMUFepjG/pg7vTcc8w/Z+3N0E0w5X
	VTB/z6zpu10zDkFSLz6ePS9ILALZhAEHZELMtcc09QJ/4w6fOa3pCnn/XZlG8YC77s1njsNpfVY
	NB/nJGbfdd4czVFdiGo1ySbI2ItpBuhrWM=
X-Gm-Gg: AYBFou1PPd1+5m/HztQ5L/5pRDkIaba4K6sQuEVTM2HD0vV22vT8Yx0j8KGz0ITMmU5
	fCOqum2dRaPDnAletUHwuhuPY4G7A/LERMgNxulDkFxwUkqUUlipJNv9YsPqWk+8mLpfSpHuib3
	PZDkyuO3b4rYADyHax7asBx4gkbh1uA3hb3/zXYmXR+BOp08I8SXwZcUSr5Zb1Zc+JOpZddqii4
	f+t5GUIwa/hU5iYliaPw7D5s3qYWjUodFu7ON11WpetiZAQlIVW/G7p6SMvJm9s+iNem0Ra4Omh
	JuFxJAZVWhqSkQUft743lF4ATV0ECFhMCiLfQudDldfchCg4NviJWJGoWPYDe6YcYOt8U+h6Hi7
	36jI3RMLngznPFMR9ug0MbQxb9Rsoqab+oZ4zwmq0tMpbOakpVJSsvZzVExjS0F8Ous/OaMgJFV
	zQnq15Sztn+YgebUg4MKd0jRqGhRzlvzJMRfSRy9zxM9wfU9cvSSnexw==
X-Received: by 2002:a17:90b:4988:b0:3b0:ad59:7199 with SMTP id 98e67ed59e1d1-3b0db703cedmr790366a91.32.1793926743909;
        Thu, 05 Nov 2026 16:59:03 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b094cf3bdesm1841549a91.0.2026.11.05.16.59.03
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:59:03 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2eced5a4cb9so926295ad.2
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:59:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793926742; x=1794531542; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=UqhK1fSKYW4KXqV/Z4DRH/PaK/Vparw14oEL5YsYzKc=;
        b=exmYJlovY9Lb3Irg/00AmaMS8r2tZOUaJXEvJ6lJThiFdv4K1xb95Iu9NxZQj06V6s
         rAeUFGSbPOWTYd5M2gWEoirCiT3WjqHhbNlkr0CoPyNYwBk4cId+OkAaMXfepJvCaT9u
         dgPu6Lh8VDpyU/Cq81aHbILkqvrCmLbahiFmw=
X-Received: by 2002:a17:902:e545:b0:2dd:ad73:5b68 with SMTP id d9443c01a7336-2ed4098828fmr12564875ad.24.1793926741921;
        Thu, 05 Nov 2026 16:59:01 -0800 (PST)
X-Received: by 2002:a17:902:e545:b0:2dd:ad73:5b68 with SMTP id d9443c01a7336-2ed4098828fmr12564665ad.24.1793926741407;
        Thu, 05 Nov 2026 16:59:01 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed47d7b8cfsm450745ad.57.2026.11.05.16.58.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:59:00 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 17/37] scsi: mpt3sas: Clamp ValidEntries in driver trigger page update helpers
Date: Thu,  5 Nov 2026 16:42:32 -0800
Message-Id: <1793925772-1303-18-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Clamp ValidEntries to NUM_VALID_ENTRIES in the pg2/pg3/pg4 trigger
update helpers before it's used as a copy count.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_config.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
index 75312d43e386..ddbccbac69b3 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -2278,6 +2278,8 @@ mpt3sas_config_update_driver_trigger_pg2(struct MPT3SAS_ADAPTER *ioc,
 
 	if (set) {
 		count = event_tg->ValidEntries;
+		if (count > NUM_VALID_ENTRIES)
+			count = NUM_VALID_ENTRIES;
 		tg_pg2.NumMPIEventTrigger = cpu_to_le16(count);
 		for (i = 0; i < count; i++) {
 			tg_pg2.MPIEventTriggers[i].MPIEventCode =
@@ -2437,6 +2439,8 @@ mpt3sas_config_update_driver_trigger_pg3(struct MPT3SAS_ADAPTER *ioc,
 
 	if (set) {
 		count = scsi_tg->ValidEntries;
+		if (count > NUM_VALID_ENTRIES)
+			count = NUM_VALID_ENTRIES;
 		tg_pg3.NumSCSISenseTrigger = cpu_to_le16(count);
 		for (i = 0; i < count; i++) {
 			tg_pg3.SCSISenseTriggers[i].ASCQ =
@@ -2595,6 +2599,8 @@ mpt3sas_config_update_driver_trigger_pg4(struct MPT3SAS_ADAPTER *ioc,
 
 	if (set) {
 		count = mpi_tg->ValidEntries;
+		if (count > NUM_VALID_ENTRIES)
+			count = NUM_VALID_ENTRIES;
 		tg_pg4.NumIOCStatusLogInfoTrigger = cpu_to_le16(count);
 		for (i = 0; i < count; i++) {
 			tg_pg4.IOCStatusLoginfoTriggers[i].IOCStatus =
-- 
2.53.0

