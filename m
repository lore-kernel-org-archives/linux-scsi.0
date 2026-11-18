Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794996768;
	b=QwojRRVmiuohnRbZ5Gmzr/bFKNdaDaFP5FwT7rFAFMz5mkXfA2Dhr3Zx1PezprHDyqth
	 67Ge0bO2PQlejk+AE9G+WQPLSX0TraD4NCfPGqrB5yyjJXyNgbKPKnLxUzG8gGiwsamL1
	 lJmvMRV84Dful5r8CmOzIKL7asG3jWpsp1gktwFZholVknbguvIh51bdlMsWj1aRjzLKM
	 PyDeM9xqYQRUh66dZT/dTALjZ5SvDbtSebI1f3sfRvUrgIeUOxwj6YbcRuDD2+VNY1MLb
	 rspYKPqU7FbjJxY4WYECm/Y69qelnAaobTXMcP51ZiY2kGCSikIp6G6vSScLN6Si21A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794996768;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=7Iv+IDUEhLfMJ9yGaiV9XYqTTWC+SorCCPn8g7VvN/M=;
	b=ZH6mSQSqS1VH5PRTsQDQ/Pu6agGBJR4wlJBZqHdGZ7eHdck1pBddwVnhIaFbN0RIVvuw
	 aVc3zeal3bHjQyb2/+qJeWug4ldmBdKiaDvau57XP4if8VgTMJbO7GGru6FCAi+Od7xuS
	 tO9YWO3BFQRO7yabkHWy07eH8wPNvyPhsewk9VOTZYjs6/osgPy7jmLZ2XtW4y5CcuZlW
	 F1rhPTgV8SYKKFwHngB5Kz2ir9AHFjLRuRVT4OaLIQuxnusifpb5EKNdfiIpG40ttJ94L
	 URqGiTxqwtUk42idPMFLw/a4Lgatp7khdDKKqgnwoTwSatDAGXb5rtYUaJVh2T2Prvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=MmZvvdKy;
	arc=none smtp.remote-ip=209.85.215.225
Received: from mail-pg1-f225.google.com (mail-pg1-f225.google.com [209.85.215.225])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4F7606A31C
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:12:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BD4F7606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=MmZvvdKy
Received: by mail-pg1-f225.google.com with SMTP id 41be03b00d2f7-cd69954c755so677003a12.3
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:12:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794996767; x=1795601567;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7Iv+IDUEhLfMJ9yGaiV9XYqTTWC+SorCCPn8g7VvN/M=;
        b=woPKY4kYVRs4vdXoc38hsan7DSxVt4qBqIGqrRnhA3TdrwHDef4KQ8Vbd5+GFHzL34
         WYBiNKd5QycpsyaNuL9UC8erg+G4Tw7RtUxIEci2aNiFDPy/8ebz7olHslWqeZ2Iqe9D
         EqvuKwsxgc60lZf7kespzgh6Syuuof9EPJ0wjai05DIYrrKruYkeOlhQxwhC6rWXTSaE
         sVozPGb+X3ddYb9XfevAxxQhrVszQ1RXq0PXrsLve8axHgXTQp4siGIKOaSxXsAD/5xi
         fIHTuqo6jjo0pfOSjyEmxk3ZBSArD02qjHcOONTpOtgXiNgH/Ql/bkMz8s0QCfi5HrLa
         Bv2Q==
X-Gm-Message-State: APuU4Z9n4QJehxnkI+Zw8kYLZ92veZpsgTNE1E6jLq3dJFqdnQDL6jdP
	/WtfPA5m53/maJlT4rwVPlmZq5A0eN3NlpgHxyeWTQhjd6vYlE0yMh/4eZYB5ubpSXn2pQTInaK
	9l4sTyuZXejHtotLbcNJ+s436jCOIUrkdlDC697lmFJ5MDzmwo2yReoof+LTSkiepsWrvqw9Nny
	ghJf47+q6HWWz5rQggo6C7pk/4T6ty1L2fcS4n1fgsbcZR0z9K94Tln5wE6Gz8HopaKbHRtRiOk
	tHlZ0BCOKfShfgpj2LKC3rLMu3YsA8AO4A=
X-Gm-Gg: AZFdTZdJ9acg0UJEKr4h4gjco68EYvUCLkrv0NTZHl0xvE+hVVIN7Loz3qLLkT14ifG
	w3Px0qOEpPvsc1gYbVqR8EQdcLGTbWFFahOhX5+GCI2FR/3VJt24529prhz8G65EQdZ0dSn4rKY
	7dFuJ+mHi83l3HK77qi4ryZp7C9tK0vjVaciFEmSpYDzlNOm5hL564Aq/mmmlUkNhJHY1M/wtFl
	Mf9aZoS2ewmlHTRGf2DIqvJp2/drA7RAFmEq3QvpqfjbvqcxZg6UU2Rs6hcDHj4UsTugIEd+zMF
	0OlEqGlZbNufjOM8E5egJAPF5tremRb3S3AkOJnKh+XofTNMpCf6Eh/baqBPcbwvwWgkNf3xxAu
	fTcMFuURAlVI/ezK5eZrgmfOFPvWgy0XCk6HBsM8A6CyJ0N/L3Mge40NDk1/sImzvTbVO+Pc3O6
	uahokGzxRecxoPM259NX+1YBls5p8OmV0uadC+8k5j7K8hoQsukHKTz30m
X-Received: by 2002:a17:90b:4b0d:b0:3b0:c7ab:4644 with SMTP id 98e67ed59e1d1-3b3d0759d9amr2129907a91.14.1794996766996;
        Wed, 18 Nov 2026 02:12:46 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-123.dlp.protect.broadcom.com. [144.49.247.123])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b3d1cb9989sm562123a91.1.2026.11.18.02.12.46
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:12:46 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cdd9fa2a558so888117a12.0
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:12:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794996765; x=1795601565; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=7Iv+IDUEhLfMJ9yGaiV9XYqTTWC+SorCCPn8g7VvN/M=;
        b=MmZvvdKyv+NAwkKEhG7kdgzusikSGLYpKesLCWfwud2sIwWeWsdq+J6bs73UwyPRid
         zAzl+TY4er9H6smNdPDB3/AWjXwzH30qBcU4eW8cclw2lMh9l5EFR8Or1CqJ+gZ85Xwg
         n0/6bTa3jGSOxiBIV2MzzkNMPGV/Gnzv1wwis=
X-Received: by 2002:a17:90b:4fc1:b0:3b0:9a0d:b825 with SMTP id 98e67ed59e1d1-3b3d07ab104mr2153409a91.45.1794996764850;
        Wed, 18 Nov 2026 02:12:44 -0800 (PST)
X-Received: by 2002:a17:90b:4fc1:b0:3b0:9a0d:b825 with SMTP id 98e67ed59e1d1-3b3d07ab104mr2153386a91.45.1794996764341;
        Wed, 18 Nov 2026 02:12:44 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3ac6016c3sm8740707a91.15.2026.11.18.02.12.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:12:43 -0800 (PST)
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
Subject: [PATCH v2 13/37] scsi: mpt3sas: Validate max_data_size in MPT3EVENTREPORT ioctl
Date: Wed, 18 Nov 2026 01:56:22 -0800
Message-Id: <1794995806-5835-14-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Reject a max_data_size smaller than the ioctl header size before
using it in size arithmetic.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index a0d915678c02..5db233d21f01 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -1367,6 +1367,9 @@ _ctl_eventreport(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 	dctlprintk(ioc, ioc_info(ioc, "%s: enter\n",
 				 __func__));
 
+	if (karg.hdr.max_data_size < sizeof(struct mpt3_ioctl_header))
+		return -EINVAL;
+
 	number_bytes = karg.hdr.max_data_size -
 	    sizeof(struct mpt3_ioctl_header);
 	max_events = number_bytes/sizeof(struct MPT3_IOCTL_EVENTS);
-- 
2.53.0

