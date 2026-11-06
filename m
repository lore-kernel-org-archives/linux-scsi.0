Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.226
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793926705;
	b=g/GyKDrV3vQpzvhyAju1JblWWBzC/AX1h3DrVH6ak53nm/SH78Zqqlh2069q+z6EPr7y
	 aZ8SrahZkDJb/yoi8eGt1w8KWiNAKR9uWYROfH2kgDzGWud4klXQHYIyi3u2VDsJGIAZI
	 rKTJeRtmhKTRHhX/Bee+gM7w+D5vPJsaeBuUyZ2Hqw6Sd9X0RMdcUrEdLupjMix3ak8ih
	 kYvyJNRwRW2ipqvdB2PsgbJgu+rCJdt09EunRajuyXMGlQZVcb5c16uyg33mlYjKCRtxa
	 U9+acKqd+vBKAunJUvoGGL+gNhcYG0y0ACLq3qYjikTyOoiIWt7+6EJlnYtrKYacHaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793926705;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=6Xsr5ZYEsP68P7AxGGkifUnUds8By+BstyfNIEUR7OU=;
	b=eCp+xY3LwxX7hTQW1zmM/L+67F8AkAmOz4d63DcT7ekycAIhuhK3evROK85BEiyLcip0
	 Bxc8s1LelAAIwT2zQPonRg4fCBK/pyVOLNKNa0QysYMyhf7Scrb7NAF2jq8WojsxYUaMj
	 Mo/xGnH/bQc3TAWsd26RP4Fard+KwhKZAGs1hKCFWpQ2XhzTmFrj1hiFHzz/+iCGtqJhR
	 0CleFB9znBhTtnNoQx8c0hrpl3mp/2QiunPF1wrTT3/FYAgIbwUg6PoCOuW8ng5w/MUS+
	 4QJrt0Nob/Wt0ZJepGab0PbJoWYqQyCWZhuwkn2p0QGjzBRu75SMjG0z5A4JEKGDtcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=NhxTaYjo;
	arc=none smtp.remote-ip=209.85.214.226
Received: from mail-pl1-f226.google.com (mail-pl1-f226.google.com [209.85.214.226])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE24606A328
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 00:58:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DDE24606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=NhxTaYjo
Received: by mail-pl1-f226.google.com with SMTP id d9443c01a7336-2eb0f1b592bso285715ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:58:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793926704; x=1794531504;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6Xsr5ZYEsP68P7AxGGkifUnUds8By+BstyfNIEUR7OU=;
        b=Avd+2Hk7N/IeR4gzucqxbTir+26DpixgWNK5zQVNXwzvFC7ow2WuXapLWfJ7Cx85p0
         QOh++gIrzW2Rr8p74JtqKYx1+SMOLngvf9hpNwdf/NSfDUNOmzC9xbSBfXzctv/9J2Wd
         2P/57RXBskutKdIkwFe2y6n0vM6smCS3QVDP/wryRzSMqCad1cjYqnDnR79qcWcnxf7h
         7B1W4OsuZtxagSma7q4tq7crknQASIgM5Zfv1AS+xnhylEyEIYsJy6TdZayotBBFzGPG
         G4mKXKAW8lC+pqmAMHZ+2WU8HzN+4QjR505GbOpBZGbuBsQqfGVfDAPpc4xdDIll5KD7
         PrXA==
X-Gm-Message-State: APuU4Z8ZXQFM4Em47QzFOpqSg5qrxC0mC9uz3y68GUYbJaEosGVtKWp3
	K3Ap7NWVaAghb9tpUGjwW4Cxvo5YGGjNmiwq+5IzXto9wFy+y7NdLLbAWYxk69dd03hX1NEurmT
	mMuFafQgGOZKEahMdhuDf6CuVRL3l4WUrBoWyXG56kqe6N6VGHVsb638he76JkEv77fdG9ADYlQ
	LjW0L1OhBi7efcS4XKn00QIHmnryjUO9mX8RInM8wEJCUgrqbeYikPTflWN9sAdxOUt/RwGTWFA
	7fvPNOf5Iu03pdT4pft/hPsGxwl3uacFNw=
X-Gm-Gg: AYBFou1Xm2fQGnQfjzkVKnDhPWrC/Tt8iy/MjDzoJ134z3hEiWlXAd3Xm+KMMVkBP1f
	LQsvuEuF+AHlFdHanXOwPJAKHzXTV7LOlzgfI18Z3+p0M5bzQAfRg9z6aX8nTUYxi95/TfCcoYx
	qUme7Mw6HjgKqSBctWj0oo8WKZ6LdXvV+qKUh54SS1nVnPfV1atnOsc15U1E3EgSOFh3C/pVaBG
	+rgXEYAXMFkMOj4NgO9M53eLcPbbPhvzTfDNIS+A933FdfkS+ZgIebeNg9qtOiNJvZJdERfokKF
	p5LdBwUUZ3CmDnvw8EnOu0moYDzVuByFtA+akg79aLn/RUWLsyVkoLxFEkremdOgci//6dByvMr
	kMPZHf8rIGhETzL2IBiCQOFBx1RSynwrTIWoHHyr9wHvVqoIlRYi2BNTrjPmxTYFIU06//cxLXR
	+2jYHPUvVHo9PK8FmkXGKgsd5fah5gN3++URHu6RujUjsWf3KkvyArmA==
X-Received: by 2002:a17:90a:e187:b0:3a7:e11c:4e6e with SMTP id 98e67ed59e1d1-3b0db71df67mr747805a91.59.1793926704055;
        Thu, 05 Nov 2026 16:58:24 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b0b32a5585sm2871820a91.8.2026.11.05.16.58.23
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:58:24 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ed02a00b24so1134835ad.2
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:58:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793926702; x=1794531502; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=6Xsr5ZYEsP68P7AxGGkifUnUds8By+BstyfNIEUR7OU=;
        b=NhxTaYjoZK5wb3FvqOu5ju5oIHIp5y95xJ6k7DQHP28WVHLi1clC/+LQ6PivLdFEYT
         AQdhTem97XF+Armc16fTT/MbgK6fF/JLI5yPw6ufVV02tH12Mc5PgLn2QVPBvtM6WCK2
         VO1+vJRUC9/IRD1imHPRyeDu4YiO+V9sU7Bm8=
X-Received: by 2002:a17:903:378b:b0:2e5:38bf:cb43 with SMTP id d9443c01a7336-2ed4062eaa9mr13782255ad.2.1793926702438;
        Thu, 05 Nov 2026 16:58:22 -0800 (PST)
X-Received: by 2002:a17:903:378b:b0:2e5:38bf:cb43 with SMTP id d9443c01a7336-2ed4062eaa9mr13781975ad.2.1793926701549;
        Thu, 05 Nov 2026 16:58:21 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed47d7b8cfsm450745ad.57.2026.11.05.16.58.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:58:20 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 05/37] scsi: mpt3sas: Fix unlocked use of raid_device in enable_sdev_max_qd_store
Date: Thu,  5 Nov 2026 16:42:20 -0800
Message-Id: <1793925772-1303-6-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Take ioc->raid_device_lock around the raid_device lookup and check
for NULL before dereferencing it.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index d696cb12047c..39e063d5a55c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -4250,13 +4250,28 @@ enable_sdev_max_qd_store(struct device *cdev,
 
 			if (sas_target_priv_data->flags &
 			    MPT_TARGET_FLAGS_VOLUME) {
+				unsigned long flags;
+				u8 volume_type;
+				u32 device_info;
+
+				spin_lock_irqsave(&ioc->raid_device_lock,
+						  flags);
 				raid_device =
 				    mpt3sas_raid_device_find_by_handle(ioc,
 				    sas_target_priv_data->handle);
+				if (!raid_device) {
+					spin_unlock_irqrestore(
+					    &ioc->raid_device_lock, flags);
+					continue;
+				}
+				volume_type = raid_device->volume_type;
+				device_info = raid_device->device_info;
+				spin_unlock_irqrestore(&ioc->raid_device_lock,
+						       flags);
 
-				switch (raid_device->volume_type) {
+				switch (volume_type) {
 				case MPI2_RAID_VOL_TYPE_RAID0:
-					if (raid_device->device_info &
+					if (device_info &
 					    MPI2_SAS_DEVICE_INFO_SSP_TARGET)
 						qdepth =
 						    MPT3SAS_SAS_QUEUE_DEPTH;
-- 
2.53.0

