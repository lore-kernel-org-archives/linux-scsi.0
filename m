Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794996849;
	b=l7H785G/1bK6JW4opfh1PG1YgQCoJHf54UC4u3LpaKOiywtyZkMd1TwMO/GtMkeRsROR
	 mp0Y6uOjy7wV34pSPPNRyGgcbjDSqbeu9k9YQXkf4h5WTHSjaifvsAQZqUzww8Nsmn2+G
	 4RzLgSK0G7tRZuLSl+qy3/x7uV4tYNHeDziUIlJNys+qwgkSvqcjbTS1FYDxotjOK4Mpa
	 jq+IN3G94VcWuvirZmDEfdHNnusSVl+Phmw4wEvmfaS5SmJWlk9JABdaKZ80j3shI294T
	 4n0DE7bHxaVwIOYbiLcL0miarZSOrUT5/zb4ppuboGvY1PQQ/8L4KF5kRXCNHXkNq8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794996849;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=5Ii/uDVUIxn5wJgL3J4SouK+PQ5B6GYnbzLGZAyVUrw=;
	b=d+4ioyUfbGrhzl/24fOU9gM1gSITmJFUXugNah1gC4Qo5pO3+EZj+RtARJuzyZOJsGk0
	 GPgJQIHaju7Mb6B25auUITwKvjtktJdzjUxwZ8VWynw8ZV3kjsXRdaMisjkKZt6fVpTvF
	 HmFMz8oejX/YSwRhdFba2FRLU/YnM/Wo056pkT08i0r+hP+T/VE6KzCdjCXfvh9dLLzJf
	 ANxbiN/u/mfhuxCVXZjeeol3bQNqDdEu0uKLri/5ZrxEds8+9wTEK2hr/Lb90NpS8vQn3
	 HrHJYTwwOpM+7coypp4AqrhwIOVwthyIHv7gJ5ldmhYeaMrc4lMMXDIeWG96Fo9INhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=Jtj0soAr;
	arc=none smtp.remote-ip=209.85.215.225
Received: from mail-pg1-f225.google.com (mail-pg1-f225.google.com [209.85.215.225])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBFB2606A325
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:14:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DBFB2606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=Jtj0soAr
Received: by mail-pg1-f225.google.com with SMTP id 41be03b00d2f7-cd6028ff33fso548238a12.0
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:14:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794996848; x=1795601648;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5Ii/uDVUIxn5wJgL3J4SouK+PQ5B6GYnbzLGZAyVUrw=;
        b=j6u/W4p3MbfXc3aMcJPzT6I4VezEPjwbKoBCgOeOVbQiS65Rt2rejvZjeQRQGR75Ht
         ZM+DnqVchcPM07mXNqUfxI7KVa0mLqfst3YF0arVK5Tdv40rhPw6x3+afInX7ZmpDmOO
         38D4ZhmSQ4sjhecaSb+tA8Oq7/SJGiKRN1uu+qtP3vWGrv6zkKBr7Zyylxn4mAaSDsWI
         FWCTxombDNTaziR0tgliT/we4m5hG12EtQTt3vc8JH+DNt+2WoCegmor2/RhZhzCvGLg
         nBD6Ag2nQk9lUrXusi7/Rs0jUNV0b3qdf4Wd21VNYEmgFxNM3I7qtQjEiZ1F45s+Fqgt
         2+Fw==
X-Gm-Message-State: APuU4Z9hZHxaL/d/J/bwwBjQCKpRxy9+9Rh8yYdSSgvP/8WSb4eO3VAO
	VbE2y8x4ZHjIHUpvNWGhagG6MAKXQW1iKYKUYiEM7hnhufG1v7Mu4NPjaaR2Yyfmfsvrbxr6C83
	oo5KwYj3UzUznZRTkwWK9hc6Ff4clXM0qlkg9I5l0aU8R/NdEGgfCQPiVP8KlgkMCyAUai9ZmCc
	9CPptxZ0RGZqk+R3oNPFzotXZPAEWvgre12v8AY58KehJBfADLfn4alqTRDu1I+WCtE2VPcvuR1
	Uh+aJClwr3Ll3h0JPyMmR+2oGTrXXXZGhw=
X-Gm-Gg: AZFdTZf0GMvxjHgiPoFynOA5eHH0C3slxAQhtr0GorH30LIxxr5InsCUX80IxTg7sH7
	yq+dddRso+cwMjsF/cyrJ2XW4ZyjzbimqR5YDTwerM/N6COyviR7+HoogjKKGJnTikfhZhWEwkv
	U3gyqfuyOdqP7y/46EK9YL4o4Z1nysw7fVfp92sSjGV/+L+EJbl2WywiMId5fiZSrIiukHhKFdb
	Fl7aMf+MDc48JpN3dkZcy48YPT9VTqBZMdwLBP5a5m37JfyN9gf2wIZ5YKgM+byyY9uKW5ZnP/T
	Few7cqMwYmgZVWSOECrhge83BbxbcxehXmUiOi2E5ecDSrTNwrYSCYlpeQtRXrGVt3B50Pu+ZHk
	JLYhqv0tvpNseYbYTA+QuN9S36L/O3SwSXAEDDrdSEeRMrSuKYFI5oA9k6zdICLOw1Yci/erpFZ
	bJTvmcyAmHErCi7JZKDhyz8AVgFlj4bXojLNw2KZMdDMBgTt/KJ7lQ7w==
X-Received: by 2002:a17:90a:da8b:b0:3b0:a831:5acc with SMTP id 98e67ed59e1d1-3b3d07d4347mr1722593a91.42.1794996848220;
        Wed, 18 Nov 2026 02:14:08 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b3ac020c2fsm3977984a91.6.2026.11.18.02.14.07
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:14:08 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2e94f72fb9fso7732545ad.1
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:14:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794996846; x=1795601646; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=5Ii/uDVUIxn5wJgL3J4SouK+PQ5B6GYnbzLGZAyVUrw=;
        b=Jtj0soArOvy7QJdee6uG7aILlUellO5PoFTpncF5n8FJmuiq4EdCW0F/USKz1Sh7aa
         yTm4u68uurRAIU5OhlB3+SEe5LXIwo8NBu7etlEM2P6AJzsrl89KReglX86jDo64VPhc
         v6hU8mnfTgMYsW7UJ27OZ4mpIz43XSIz1kk4Y=
X-Received: by 2002:a17:90b:4b:b0:3ac:452b:4a63 with SMTP id 98e67ed59e1d1-3b3d07e0abdmr2208245a91.55.1794996846551;
        Wed, 18 Nov 2026 02:14:06 -0800 (PST)
X-Received: by 2002:a17:90b:4b:b0:3ac:452b:4a63 with SMTP id 98e67ed59e1d1-3b3d07e0abdmr2208218a91.55.1794996845995;
        Wed, 18 Nov 2026 02:14:05 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3ac6016c3sm8740707a91.15.2026.11.18.02.14.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:14:05 -0800 (PST)
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
Subject: [PATCH v2 34/37] scsi: mpt3sas: Release sas_device reference on error in mpt3sas_transport_port_add
Date: Wed, 18 Nov 2026 01:56:43 -0800
Message-Id: <1794995806-5835-35-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

The reference taken by mpt3sas_get_sdev_by_addr() is never released on
error paths that branch to out_fail. Add sas_device_put() there to
prevent a reference count leak.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index 5f087d0b4d7a..facdec0240db 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -866,6 +866,8 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 	sas_port_delete(port);
 
 out_fail:
+	if (sas_device)
+		sas_device_put(sas_device);
 	list_for_each_entry_safe(mpt3sas_phy, next, &mpt3sas_port->phy_list,
 	    port_siblings)
 		list_del(&mpt3sas_phy->port_siblings);
-- 
2.53.0

