Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.228
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793926785;
	b=17IL2lJJBt1TI0LY9kyFCf5j17z3J2tun7SZ7l/h5/n6L7lUsELhRKHV28dqxmyAXHiM
	 Es1QIzowIlvJiq90HmMON894eFwwj0WFPwc4d+O5VcB4+rZydomqp2n6uE/ee90r3WqJ9
	 5nRtritx/SgRG0FcOx+x9FN2zFelABZCGaXxz8FrSSMvIEskr3jrdwUhj3mLCBXQXxNCd
	 mrVHN2lODmbh4pFstTTuBuA02ItAk+Yd+57G739Wqr4cmDMyHhNY5aUnLrqJl4gM8sV1y
	 DSlGMPCoN/rfCU1Dy3gZKdm9h0se4+VueMzrXC2Jz5MvclhMXPtyCovGRAGzZjBfFcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793926785;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=zZshDIQLaMdW1+p6ncQNJ4IucalFt1t1XZZFQHcr8G0=;
	b=F94IurugLpo1091gOAgq+Kr5upgkeMGbEMjGBHqucnuAdyVGoStRH//MjDl3uUyE3uVO
	 UB7ungEfvccLv7HQ5PlNV53VgvAdkDAK5XaHmrMmiNz5RgRhHh/MT2cc0a8zruguNx+es
	 KDSyvxtFTkXWuiRQgUCFJbI7+ekvdEMuk5fnI+3lpvI6Vg01DRi/m//sBwMRM7vY/CLat
	 C6SaKjZ3u6koIZE/nerRUjry5SfhKa4MTY4yECiFu6lyEApjD6FBgghSL9t7I18t57cb1
	 JumCysyDbrAvCzOR1s03kc/ar/zlAEoImhT3FfaXvyOv3ywWD2jOuwgFtcsPN+Nxb+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=WYiRv+2n;
	arc=none smtp.remote-ip=209.85.215.228
Received: from mail-pg1-f228.google.com (mail-pg1-f228.google.com [209.85.215.228])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7317B606A31B
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 00:59:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7317B606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=WYiRv+2n
Received: by mail-pg1-f228.google.com with SMTP id 41be03b00d2f7-cdb2e0062bbso37028a12.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:59:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793926785; x=1794531585;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zZshDIQLaMdW1+p6ncQNJ4IucalFt1t1XZZFQHcr8G0=;
        b=tpd6fPKESRFyiRIZOvPJUKyNC5AH//+T16HRbgdAtpCyLqicrn3b3/B0p8ToLU0rjN
         sjTmOaRKhRq/Dybsjq2LgbFufVkz8BQMOOsKrK6mMcavNDjPj35bji4AESKRhd9JhfXv
         +3l/QKjYd56tYbQLol72hIERCzp47NkHT/XQZ8oUp5NudN+nwQBI4/HZYFML3U2NNud3
         55b1EAoMe18MY9tT70Zsj7vIfKUWHMGS2dAO50QHxjm7RmvraN7L6Ls5FBEOgITP7ckP
         +tjnX0B4Es6XNwx1a5wIu07JdQ9JKrU75G1LKrYYpQ9/yJfRyCt/rw8UK9BL2HeV0hkJ
         hGWw==
X-Gm-Message-State: APuU4Z8PGY4oP4USnE25tZnYbiLU0+opHqrdJBSnUKep4S+ruyV14tv9
	T51KVziWI8fqL3GxTqxqJjvYcBIXkdu4YExlp6RO6EyIJtvzu2u4lhklRDYLtHcUzkQ1KbUWjHH
	aMIXHqdKEFhhr3E46CsXi1tfSxemxRJIvXFpAUjjb8U9kex72rz1uER+eNLm6GH6O0otxWIyhzX
	kjg5j1eCxtcPAD4xsjTLuPzjmAVu3UfO9utH+WHStwwuaEVep9XaTn0/zqeMXNJSIGZDtIiZ1ZI
	d6TRqrHVyRLBGVcKMhzRbsGa5iikUKi3yM=
X-Gm-Gg: AYBFou2r25nfrLM2YPNVG0zw3TAN6AG8wgHAqZkJmNc6i/59sxoMN4cwKJSAJKrNooV
	0Ks4EhDCsb+qSEcCeQtUApHhP/5AKNQ7ubdPtxXKonTogJPdC8BeV1d2SSuz2HJ0uHfLKjCh7eO
	ngppFeCGCG+VmezJu+SVhwsqaYeP4uesMJBDqw6fxFLlMnd9oMUsI3+USuYWXo+CTpXKS+ESblX
	A4ZoAoWLtR20qL9ksnP1gqc0yQYJ5N9V/xTrI1VICW4JgWWfen2dfzBr9C4V9njmFcjT1UcAUvl
	GGsq/U6vgSO4qf3OwimK4lQK+ZXZ8VmcDXYOVvjRQgQPF/ouFYEsG/a+Jm3rJs6UzuWZWH2XQJp
	ngrmNz9atp9zwnjlthdlK5l2qp8BRMsJiYo79NhD3bB6nys5hwSFvWOs+VkoTqc3HXkVweoXMEm
	NR9b+snMuoGRtUqSNONjrkNs8JJpFYi9rTfSfbHCx9Y7t8pPtHts+XDg==
X-Received: by 2002:a17:90a:e7d1:b0:3a4:967c:6947 with SMTP id 98e67ed59e1d1-3b0db6eef8dmr689694a91.21.1793926784662;
        Thu, 05 Nov 2026 16:59:44 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b0b315a3f7sm3013620a91.1.2026.11.05.16.59.44
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:59:44 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2ea71803effso1159625ad.3
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:59:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793926783; x=1794531583; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=zZshDIQLaMdW1+p6ncQNJ4IucalFt1t1XZZFQHcr8G0=;
        b=WYiRv+2nQPN3/6ojRp96E/HvTIQd9F95vEQEQB4vZ5A2en+1n9QhJ9UReeOk0Vvph6
         MHUgY1qnjmZNf5nDj2GzaBq1fVUnmMKBcjhlc0wYN0DB/whOcJprDKLFzTinhzcZjnN0
         YB3xOsXYj3cNpZqFTh+EEhKNDs/f+uUjNUFLI=
X-Received: by 2002:a17:903:1b08:b0:2e9:6972:54d7 with SMTP id d9443c01a7336-2ed40c7f867mr14780655ad.52.1793926782758;
        Thu, 05 Nov 2026 16:59:42 -0800 (PST)
X-Received: by 2002:a17:903:1b08:b0:2e9:6972:54d7 with SMTP id d9443c01a7336-2ed40c7f867mr14780385ad.52.1793926781896;
        Thu, 05 Nov 2026 16:59:41 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed47d7b8cfsm450745ad.57.2026.11.05.16.59.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:59:41 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 29/37] scsi: mpt3sas: Bound event-log copy size against reply frame size
Date: Thu,  5 Nov 2026 16:42:44 -0800
Message-Id: <1793925772-1303-30-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Cap the event data copy in mpt3sas_ctl_add_to_event_log() against the
space available in the reply frame, not just MPT3_EVENT_DATA_SIZE. Treat
frames too small to hold the Mpi2EventNotificationReply_t header as having
nothing to copy to avoid underflow in the size calculation.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 04555eaa09c4..a8e92a786265 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -366,8 +366,19 @@ mpt3sas_ctl_add_to_event_log(struct MPT3SAS_ADAPTER *ioc,
 		event_log[i].event = event;
 		event_log[i].context = ioc->event_context++;
 
+		/*
+		 * Bound the copy by the reply frame ctl owns, not just the
+		 * log entry size, in case the scsih-side clamp was skipped.
+		 * Skip the copy when the frame is too small to hold the
+		 * header, since computing a size from it would wrap.
+		 */
 		event_data_sz = le16_to_cpu(mpi_reply->EventDataLength)*4;
-		sz = min_t(u32, event_data_sz, MPT3_EVENT_DATA_SIZE);
+		if (ioc->reply_sz > offsetof(Mpi2EventNotificationReply_t, EventData))
+			sz = min_t(u32, event_data_sz,
+				   min_t(u32, (u32)MPT3_EVENT_DATA_SIZE,
+				   ioc->reply_sz - offsetof(Mpi2EventNotificationReply_t, EventData)));
+		else
+			sz = 0;
 		memset(event_log[i].data, 0, MPT3_EVENT_DATA_SIZE);
 		memcpy(event_log[i].data, mpi_reply->EventData, sz);
 		send_aen = 1;
-- 
2.53.0

