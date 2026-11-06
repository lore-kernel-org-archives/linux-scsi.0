Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.98
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793926699;
	b=0T1jcCX9e7AAChU2AdWz6IgxAMSxaDmWVbYXaa9W5hWtksDJCyUTJbKgQb9ZDs5pTKQW
	 PxVS9yD1OwI4vlu0MNgB0p0sEeRqIUZNpmV8LneIK+BQkhf0g1+TapQFxU0T+tWrLMf5f
	 ATZhHYWTDLA3lDdtfgQWBoM/3bgZdk/rA2veKLrKxIVQ6dyOkvrn8aZwfQP92gmrjkdIK
	 TMxprp7DIZ5TzkWVAnmQUZXfLeYwRrAX48yWpGVXs1yeG9RzgnjxMPi7tOfKW7QJWchm1
	 ydGhcYETf+OEdrQn3JwDjF+LYL2uyfsqa0icpZUJ6fqgMgtzZvW4OMj6fnPD9E3qZ6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793926699;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=gpiDhrok3lMHYae4YW2799PVQYySNztKf2WWBcOzfmg=;
	b=25y+jXRc0L/kz/H0U4aIfsn3S0FNEsLl8VbN85rXugH/Lt1dd2vJCFLhHfVnvzwjeYcV
	 1otkfNXBBoGhIJnrgj11sKS0iJA3Z95jhGiVA9cJraQSdEXwxTSd1asv24CYaSKIaVxf+
	 kJTz4YpNZiUrmzYj5fE5Dn0RzOLNLwPYfnno5/r9mP4rx3egXftDcRMsWV7vZx2wMgyfs
	 zvgUJdYCe2so0kgw8sZdU5gtWYMtB+47kHaEVINa67nlZUAVnnsQWJv0HbIGLf5GYdJVY
	 UNMJL5LEcufDNApBQXcXQy4dWcGwLoyEra1iCbRl6GnPX/4mODj9QWjCTDxMTCK1d+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b="Er/KKtjp";
	arc=none smtp.remote-ip=209.85.216.98
Received: from mail-pj1-f98.google.com (mail-pj1-f98.google.com [209.85.216.98])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6F8606A330
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 00:58:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8C6F8606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=Er/KKtjp
Received: by mail-pj1-f98.google.com with SMTP id 98e67ed59e1d1-3b0bbdeae06so53117a91.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:58:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793926698; x=1794531498;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gpiDhrok3lMHYae4YW2799PVQYySNztKf2WWBcOzfmg=;
        b=zz/G12zKPkFQt7+a67OIu/OG3EUkrOdnombD5zdEGMo7Wy765WXnie17gQcB19B9DH
         MFxx7Dt2fcgUosbXjL5Ev4fTJyws0ArG9AjFFGxsbZs9LNaEb47pHZtc60reDlGfNgr/
         PQ7rM15gy3siQbvik8wQ0eiyfv4wFESK4b5nmXaiCwESsRMqpaBnF+AscJpQANQCdYeu
         U3HqsSAdj25cSw6dDSsP2ZRfdx3pvzVD85+lrWnSe0T7wEIK+22VuwW1WJ+8LySrEOIj
         m3YA6fAl7lU1c94/lmjNJ/7rbLUsDTHyh6K1k1aoUy17MMUxadq18OyiQ559AZ+cvj6f
         IAPQ==
X-Gm-Message-State: APuU4Z+KaatLWpcyoMziSsz7lCMHavelCc+/plfWzuZwKVQqkxn3lt6X
	k6srEsNIzY9IxhRBCxyXESaRtlvZ/v/i2i3bkFiJgfvFiARBm+LCEMaZpnW/tc+Ie+S2WEd/WYf
	x1nw03M0RJqL7/VXZ11NTCfT5NwzZilx4do4gQgZs9Ib7+i5R753cHQ5esGdt3YxKO5auwayb4Q
	xYCncUpA+AtApU4P6U3HGhE7xD6zAdi1FwoEpk4TqYX+vAHyM3XfjrVtLTz3riD+WYW9Jr7ZsfZ
	ctZE2IBcdDjglFClAaT2ypwuP23V00wzfk=
X-Gm-Gg: AYBFou25gRt7PeCgB5HNYw9vANC0ToyDFoMa9KidEURS2nqAFWwLtNvmkiEMwH3hqnO
	eKzXlmKLjlG/7kxBxFcH5vU+K77Ij8ua81/7AQ+NqOlgymRelV+An2q3oUY8roFW6pYzEKlPLdP
	W1aDdAmMu14JGzYWFgwNJPUI+JqxUar1B2EUfYKvgpKl1vtNDG0tpqgOUzJk4IAR7SrURqnYHOd
	byDkfgZEJePnlYNVENiliNTrW/zZpoi6CJXuc9PCxcxkOxMcz+508RpUYnbI4q8H6xxfQvO4JwE
	2ayK4BTTnz45nznHOwYL8IF4VI3PfXkDqyctOcXE9Gg+ZFkKCj0+KYdRLtkd0w//a03LIZ1Eco+
	GC0RRU/M7oiIl7T+KeknZVzBqDLxrEg+bFLT+2ZO0NgMgG4YboxYzw0+B6uqF6PKtDO+WfGZowM
	zx9R7q/yj05awtaKYUUvD10a5xAjg6tZFPKbnUp0qO2y0nP2pS/LFRYA==
X-Received: by 2002:a17:90b:5403:b0:3ac:9463:83e6 with SMTP id 98e67ed59e1d1-3b0db6d710fmr779701a91.10.1793926697981;
        Thu, 05 Nov 2026 16:58:17 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b0d7c9e095sm757455a91.2.2026.11.05.16.58.15
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:58:17 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2e942b1cc86so1347305ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:58:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793926694; x=1794531494; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=gpiDhrok3lMHYae4YW2799PVQYySNztKf2WWBcOzfmg=;
        b=Er/KKtjpiq/QU0aJtIwKuUNWunyoJPLKda6I4f6I/Y/LVzwwWBLUpdQTdnvmaICFvT
         nmU9qviRGskVwGJikHV2SQP5HITI57L4xP84By5Ol8+eHs4JZ3ffmK0w9v3PG1ylAGiq
         jGmxgc8Nf70IxmU4Ee3lLBCjCGOIKlJr4zMKk=
X-Received: by 2002:a17:903:1246:b0:2e9:7719:40fe with SMTP id d9443c01a7336-2ed404dd213mr13864435ad.2.1793926694662;
        Thu, 05 Nov 2026 16:58:14 -0800 (PST)
X-Received: by 2002:a17:903:1246:b0:2e9:7719:40fe with SMTP id d9443c01a7336-2ed404dd213mr13864215ad.2.1793926694166;
        Thu, 05 Nov 2026 16:58:14 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed47d7b8cfsm450745ad.57.2026.11.05.16.58.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:58:13 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 03/37] scsi: mpt3sas: Pin Scsi_Host while an ioctl is using its ioc
Date: Thu,  5 Nov 2026 16:42:18 -0800
Message-Id: <1793925772-1303-4-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Take a Scsi_Host reference in _ctl_verify_adapter() and release it
once the ioctl is done, so the adapter can't be torn down while an
ioctl is in flight.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 8bb947004885..f254e9984da8 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -447,6 +447,11 @@ _ctl_verify_adapter(int ioc_number, struct MPT3SAS_ADAPTER **iocpp,
 				continue;
 		}
 out:
+		if (!scsi_host_get(ioc->shost)) {
+			spin_unlock(&gioc_lock);
+			*iocpp = NULL;
+			return -1;
+		}
 		spin_unlock(&gioc_lock);
 		*iocpp = ioc;
 		return ioc_number;
@@ -2847,6 +2852,7 @@ _ctl_ioctl_main(struct file *file, unsigned int cmd, void __user *arg,
 	mutex_unlock(&ioc->ctl_cmds.mutex);
 out_unlock_pciaccess:
 	mutex_unlock(&ioc->pci_access_mutex);
+	scsi_host_put(ioc->shost);
 	return ret;
 }
 
-- 
2.53.0

