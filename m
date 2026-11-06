Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.227
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793926694;
	b=gnW/qQc9dWf1S3UIfJU1fvjMfnU4p2pKbOe0MuxkL1JwTPb81ABDydWXoD8V24uAAAFH
	 PMSpeeU55izxf/pNfPG6hFHVFJhlqOW5Xlf/MQfgl70ULO2okO2kmOtQYMoNg2D4/49dL
	 usikTHwKGmvnjeEV3h8yDW3hOFiwYlfRSwUgwABcWfhGdIB15Uv+111iXiOEfkxWdAuHO
	 /nk3EdhShpQuI2VoBQ/CJ6vK9QD2UPeU6+akXHtN1RFFSxyM608GtzT9c3p/kYGycnMkd
	 m5MyopudSikcwa42xSHBaRVnbhU9luemN6JDlJk9lSZlYS1fpAyG8+QcU8aHg9L7FfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793926694;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=VaydLd+Pq2W1/S2edfEzi4kZ5PBc7ow3LucuoxauL+4=;
	b=4cCyZ/fVHhZqy350RhVGkjlkmrf0Bo8BczWRu2ppSFxfh1PoFH8adC42ff9vIEj0k0vy
	 E/luLe/JWrnx8E16JZxIksIDSUP7Dlt8YmOSK8+VCxityO7a24N+42D6J+ROVK4rx9Ic0
	 WQAaY/OlD7/pYDvUIYkg2JpZX9+R6cfT6fQNCQlRQpCRtdusSr4LSbioZLe/n8ISs8q0u
	 SG536WVr7gWvQVmy2ntYVM6rTTCPIZrLkQZ78fP0bAUv88AhfnknFIItRBIE5+/JlFmeI
	 pcvE/POZDF13SyQuPgL3L/J9Lp1WbqERKcWVIagu+kvpDXqvb8SbHZTRp0KAjLM1HWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=Rfi6w+Oi;
	arc=none smtp.remote-ip=209.85.215.227
Received: from mail-pg1-f227.google.com (mail-pg1-f227.google.com [209.85.215.227])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B58A606A31B
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 00:58:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3B58A606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=Rfi6w+Oi
Received: by mail-pg1-f227.google.com with SMTP id 41be03b00d2f7-cdab938dc83so38888a12.3
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:58:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793926693; x=1794531493;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VaydLd+Pq2W1/S2edfEzi4kZ5PBc7ow3LucuoxauL+4=;
        b=O4LKfJGDxcln9Cu4iEGo2RPvKlZC+ChKc+Ivr45IaNfv4/DFqiE8CzuyiHxCb36yqo
         olpJjMONiPvMYz92yBtrV8ViYPtuZLd6ncCxPsaza4PZ8BqgCL4KulaghaB3mQme2eoC
         NPva8v0CiN2iAB+r09ZU7KLO1MnsIkB6Qz1MLRf/zfoWGTlNyp0KLOwC0MsPxgFDuEN6
         Z3zE/FrGJ/1ssVD87zgUQIxvY+LQvBG9QQg4tRB4t7U+m17DfEEdzmiitNm8kntCCLiu
         GzFx6LUrI+OBgRJcypTyRblR7evXUJB+mF8kGed8o6eS01pNKnY8wmqUyab0F/MqnpWG
         JQlw==
X-Gm-Message-State: APuU4Z8jFmE6ZxltsS21PWN/XeMw4Dz5MpASlHvz+1eTo0xzNYGpCi4c
	W7SOSrYMUNUccuoqH26WxyjAbgVIyf0t6CKIqwGsNVAaHF5OOHpEcaDgAM/PtjGysl9k4JMM95r
	ZZSc17OUqeXm+clD61Zap/aAH488oPiBpiWoFQAQHtw8L8xVuG/j/DzoYl8e1cBYcK3a4OJ0MqF
	CU2DuTCteIL4IxrYnbgFqXKJXXjBbYO8+NcTfbMS1mPEaXL9aHasXiZemm9eTGPUa3YvwmksbVQ
	tZKIMK2lux4iiWG0jCh7AHvs1zazCp9he8=
X-Gm-Gg: AYBFou2mzdh8D/fyaOcJphY3MOCOxaOLuBZoQwbgpfAByeEVI0vbxyv6n40q8hhTNuj
	oHfYidOjIFzWtafqE7vqKd1ZWO6Y79HZew9dPp//yBsWNKt08BOO99xwZLfOkAh6Qv1j90nHxdw
	QNzdoA7tpMMkKdLP+H3Lk6CGCJEc2VKQjLd4YA8gtTXcAaFw4A6GTTN0ZIk5UoweEfaTD1r+LkV
	GWAFAVLyhyoho1Z+B/agtLMmZMkE4jZwoM4zPRWckHuFsp5QP8tUQZG0XUHaPuoUdmhzY/CRw4O
	8/qHidR/iw40JupM/tfs3aHKAGZOxxuHdu1uWNJAZxMDxCa5v7Ko+F5ZqS07uPzUGXKMeub2R1f
	puCtg7eigKlbnjSdg3WbhZEjwmUxtsWDAE921rtCmZJJvAfg+apXApLs/5MPdvMUiHCZh3h5vDE
	V81nOBAFjZXYoO6K8emtm3TD/kRjwB+hsWuNN9nkjeFB8/LZgg36vRCg==
X-Received: by 2002:a17:90a:d88e:b0:3ad:c482:ae9a with SMTP id 98e67ed59e1d1-3b0db5ed5f3mr802504a91.1.1793926693452;
        Thu, 05 Nov 2026 16:58:13 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b0d7e280e0sm709875a91.8.2026.11.05.16.58.12
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:58:13 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2ea63087d79so1165795ad.3
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:58:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793926691; x=1794531491; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=VaydLd+Pq2W1/S2edfEzi4kZ5PBc7ow3LucuoxauL+4=;
        b=Rfi6w+Oi48L5OF1cOGQVlaReGEoAKsOu0yd8kWSpcDRIpWiHivqa4Mj13MWeEE2jgr
         vZi3OPs9Gy8iN4EmEnt+rnbJMTr5DR3l5HNO6aBXnLs/RS/S9xzrCNKJ4PBXv9quL+7H
         8b/PbOvYG1bZ19wClZg+yMXFFxf26TQBhK3iA=
X-Received: by 2002:a17:903:3708:b0:2ed:1df2:8b35 with SMTP id d9443c01a7336-2ed40c9d179mr15737615ad.37.1793926691530;
        Thu, 05 Nov 2026 16:58:11 -0800 (PST)
X-Received: by 2002:a17:903:3708:b0:2ed:1df2:8b35 with SMTP id d9443c01a7336-2ed40c9d179mr15737405ad.37.1793926690896;
        Thu, 05 Nov 2026 16:58:10 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed47d7b8cfsm450745ad.57.2026.11.05.16.58.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:58:10 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 02/37] scsi: mpt3sas: Validate RAID configuration page length
Date: Thu,  5 Nov 2026 16:42:17 -0800
Message-Id: <1793925772-1303-3-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Check the RAID config page length and NumElements against the
allocated buffer before use, to avoid an out-of-bounds read.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_config.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
index b0d5ef893600..75312d43e386 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -2655,6 +2655,7 @@ mpt3sas_config_get_volume_handle(struct MPT3SAS_ADAPTER *ioc, u16 pd_handle,
 	int config_num;
 	u16 element_type;
 	u16 phys_disk_dev_handle;
+	int max_num_elements;
 
 	*volume_handle = 0;
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
@@ -2672,6 +2673,13 @@ mpt3sas_config_get_volume_handle(struct MPT3SAS_ADAPTER *ioc, u16 pd_handle,
 
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_READ_CURRENT;
 	config_page_sz = (le16_to_cpu(mpi_reply.ExtPageLength) * 4);
+	if (config_page_sz < offsetof(Mpi2RaidConfigurationPage0_t,
+				      ConfigElement)) {
+		ioc_err(ioc, "%s: RAID configuration page length (%d) is too small\n",
+			__func__, config_page_sz);
+		r = -EIO;
+		goto out;
+	}
 	config_page = kmalloc(config_page_sz, GFP_KERNEL);
 	if (!config_page) {
 		r = -1;
@@ -2692,7 +2700,11 @@ mpt3sas_config_get_volume_handle(struct MPT3SAS_ADAPTER *ioc, u16 pd_handle,
 		    MPI2_IOCSTATUS_MASK;
 		if (ioc_status != MPI2_IOCSTATUS_SUCCESS)
 			goto out;
-		for (i = 0; i < config_page->NumElements; i++) {
+		max_num_elements = (config_page_sz -
+		    offsetof(Mpi2RaidConfigurationPage0_t, ConfigElement)) /
+		    sizeof(config_page->ConfigElement[0]);
+		for (i = 0; i < config_page->NumElements &&
+		     i < max_num_elements; i++) {
 			element_type = le16_to_cpu(config_page->
 			    ConfigElement[i].ElementFlags) &
 			    MPI2_RAIDCONFIG0_EFLAGS_MASK_ELEMENT_TYPE;
-- 
2.53.0

