Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794996726;
	b=UFiH0ZrZzw+0o1hoJu3jE723JQv4DiP5glMuKwakRcPTrggTVgDU3rXY40Wz0M35KJcb
	 WW44zUNS7OxcN7EXdhqdt0f9QZUJoGGHT7cMvEgFfpKHX1yAtoqDlItWzLv02LhfrdXqt
	 /h0OiYwLXDrbXvBm4ALcezpXZskvLKB7gXjf1b2n1kdKwZpWw9Moc/oksFPjsm9vIIXW2
	 mrx3Wmc6g7fDiccTnTjvaxVvNrKVhL+HZZIHncPez8rfRA1zE3b8eud8Q0xVGHil9gyUc
	 UZA1g+B3gWQdfVf+5NhPMZL1tUGcj0QfEcpPLSchFjVCY+QinEggvzrR91CSRXt7gBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794996726;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=HY3fK7lDJOBS2MN05k9QL9HX1jpgKbUrNENd4SCpvNY=;
	b=sAQf/iF5oVknm93lgHduAYhWgoA2Fs/7jCJ7B8ROZF7IBBrU1ubmHBknMDkhptBTgYbM
	 a2Qqnnj+W4m7wwq0Ne/F3yPtE3WPSEbRBp5cn054zsHTWGgOATMFN5XxLonz2tw64sYX0
	 MY/tDkeKp5aakghw3hd2Dr5+zpsgZtkb0Qqqb9j0uWZqGPYLM422CS+Fgtfk+FGQ4jiRA
	 nlPp4O9yvBOlCzPdsdiDuYMwdB7A5AsRz87oM8RRSI2PE7iWjtDX1luvwaXARuVbsWvmf
	 IVZRxlMFyrsenG7a1ZQWiV0EvOJUiLYlPGIERp6XRySq8GUcOYdMn4nX6mRfCguwAsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=PMovxgnt;
	arc=none smtp.remote-ip=209.85.222.225
Received: from mail-qk1-f225.google.com (mail-qk1-f225.google.com [209.85.222.225])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEBBB606A31C
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:12:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BEBBB606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=PMovxgnt
Received: by mail-qk1-f225.google.com with SMTP id af79cd13be357-94965745d92so87148885a.2
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:12:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794996725; x=1795601525;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HY3fK7lDJOBS2MN05k9QL9HX1jpgKbUrNENd4SCpvNY=;
        b=Z6rIiZosvJb1g8GQYSSBZYbTLjMR2RobuIZQoQty/+Z/WWugh3cbUCKTHHSmOIAKyI
         2aTv04D4G1HEBFO0lTZbU78S6NWCBEXs+NgczfqOiw+JYsypWjMHR390M2+q4s8EDA0I
         YVouQ+cvNaK9VYscY6PSNbZY0ShMlRi1KIBwsoT0rDhpUhuyFM57E0zJvooYmv4/ucto
         JhGItWuKN/b4htFghn3+LQxFJcUWnl0vs/iQA6wm+eZbcH246qTGMmJQSgMIAxptIMAe
         tH+leIF3QEBnhlguTuTWs1sjBreE0TV6cJ+LO2i7T/Cziy9LPUygZZ7wfgvGJIFJk6j+
         m5qg==
X-Gm-Message-State: APuU4Z9hkfEWOh6UFo26tAJKgKn1wPpcanz3/v1TgFAF6L237wtSiAVP
	Ltk+eZSOTvtRIRdaIu49lNFti2ANiQ96o3cbfzsplqYhr8UB4yUhgpEUOLh2oJYvDpHbs6q163W
	VqAJAw1q8mrIRn8o/53QLJFVHLHi093aymcDCggAlNgZvG8AQp38kq+dT9G+tPHiRCaJNd3XZKo
	JahcMHddr+NxJoQTyO8RJ1QOabx52TEL63zJIcAi097NHKjBNgtdXWlq2FBlk1gP85/2ABMYVKr
	C5UYuSDjPpwt6pgOyFZn6Qv9z8qpaLcq0M=
X-Gm-Gg: AYBFou19jirKPwwpu3IEcGV4IEIVbqCrGCn5nSVRobK67kntO8PyA1vbSi0Xi4eKyvI
	ehx6sZ7Ysi1K0J4gTLxIN0tAqZKdhaUgR3z15Mq2FOjFdtcoQnXnHQStmAzFunXFbOarR4P4VKR
	RHoAt4A+2R5akbW/BStsFHa0vD+4YETwaYIdqAXgQiccuAhMhELWxMBXKIbH4gT3PaJtNKRvrkr
	zN2gpY1hGpg+niY0ZlhnQ9wBJn2/ku6sr044f2UhLuyj1MRSwVtIpTKwxCor7ohyy3NOVPCrB9M
	99XidzA57sGgOE8rdU5ntDertQF1weauCTG4oAEkFWeZE7rpkVOn9yjhFgapbPfBkdiX7NeBNFU
	iw8PFLnMh8DRSgSEiPROgFQF+YKAcPcQLnBd4bnuYKPs/fLnu7iPKlz2tb12tImlm5kbrQspxar
	Vj71nSkZ0ftqJBjO0bYTnp9/t2ZDtpmI/UZOvA4dLOjJQPn91wkIWJGw==
X-Received: by 2002:a05:620a:2718:b0:949:7781:6a31 with SMTP id af79cd13be357-9499962736dmr362300485a.76.1794996724606;
        Wed, 18 Nov 2026 02:12:04 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id af79cd13be357-9499b4bada9sm14234385a.5.2026.11.18.02.12.03
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:12:04 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3b0afbf532eso712916a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:12:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794996722; x=1795601522; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=HY3fK7lDJOBS2MN05k9QL9HX1jpgKbUrNENd4SCpvNY=;
        b=PMovxgntLNH6DS7PG8B3Q64VS6NtN0GLKHBBMQCwrXL/c6uZT22hAAbnf9DVrhLOZ0
         dyeFJrXOJx6QPkKZBueEfsIX3McY3G3+RgCfzj4rIrndzf7SyNyS8yiCyC5dG6XhlMva
         29ELYL0d3yKc8gpc/m7KwYzGhk+aqDX6awuBo=
X-Received: by 2002:a17:90b:49:b0:3ab:b39f:41da with SMTP id 98e67ed59e1d1-3b3d07a2122mr1899274a91.11.1794996722419;
        Wed, 18 Nov 2026 02:12:02 -0800 (PST)
X-Received: by 2002:a17:90b:49:b0:3ab:b39f:41da with SMTP id 98e67ed59e1d1-3b3d07a2122mr1899255a91.11.1794996721840;
        Wed, 18 Nov 2026 02:12:01 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3ac6016c3sm8740707a91.15.2026.11.18.02.11.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:12:01 -0800 (PST)
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
Subject: [PATCH v2 02/37] scsi: mpt3sas: Validate RAID configuration page length
Date: Wed, 18 Nov 2026 01:56:11 -0800
Message-Id: <1794995806-5835-3-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Check the RAID config page length and NumElements against the
allocated buffer before use, to avoid an out-of-bounds read.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_config.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
index b0d5ef893600..eb51ce3610c8 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -2655,6 +2655,7 @@ mpt3sas_config_get_volume_handle(struct MPT3SAS_ADAPTER *ioc, u16 pd_handle,
 	int config_num;
 	u16 element_type;
 	u16 phys_disk_dev_handle;
+	int max_num_elements;
 
 	*volume_handle = 0;
 	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
@@ -2672,7 +2673,15 @@ mpt3sas_config_get_volume_handle(struct MPT3SAS_ADAPTER *ioc, u16 pd_handle,
 
 	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_READ_CURRENT;
 	config_page_sz = (le16_to_cpu(mpi_reply.ExtPageLength) * 4);
-	config_page = kmalloc(config_page_sz, GFP_KERNEL);
+	/* _config_request() takes a u16 size, so larger pages can't be handled */
+	if (config_page_sz < offsetof(Mpi2RaidConfigurationPage0_t,
+				      ConfigElement) || config_page_sz > U16_MAX) {
+		ioc_err(ioc, "%s: RAID configuration page length (%d) is invalid\n",
+			__func__, config_page_sz);
+		r = -EIO;
+		goto out;
+	}
+	config_page = kzalloc(config_page_sz, GFP_KERNEL);
 	if (!config_page) {
 		r = -1;
 		goto out;
@@ -2692,7 +2701,11 @@ mpt3sas_config_get_volume_handle(struct MPT3SAS_ADAPTER *ioc, u16 pd_handle,
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

