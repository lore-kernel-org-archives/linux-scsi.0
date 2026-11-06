Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.228
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793926810;
	b=J+ntIJUcYsnrkAc+kYq5GbdNpmdra4tg5CA/r47O41d7y5Xx3dnuxwxcSAz5bNot2LIT
	 94HrcxVUH2K0e2Y+9coeaQpvHndbg7jDs9g2BkOZw3nWwqVn2SJjI9nDrTab06vhrxsON
	 /J/YOksrWPpN1VDAz3oApHzDTvecO9hGLOi2EXEHQBn/Gv89mEQmebsStYQeLz4q4E+zF
	 4mjDr8kpA/NGfUtxzoNw8k9dl+P80OLKpXCnGgBxFjb46qk4+c/XTEqCNaIGsTcIKdpK7
	 5sPNVZezC9q4T6dJgNwe7JB0GQH22eUeHuOesKHcwa5xBOF7k76ZelKYzVlmq2vlTGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793926810;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=iF9XMmZuEJqGMH73H20LJnOlU1CR2IP7veqYKnH46VU=;
	b=4qrk1DahRWIOswMhEeFPeQ7rZ0a3WE7C51knDAhayAarWIp74ybYikOyss3op/0LfNyB
	 bVSUUzlI4vfXcFbgGYwqKGXQpx0rUIG9iEBdVcOIAA+3raOIP4wVq/WnhPoXWv9cWAYK9
	 rw6rD/Mn7D4WBPNsx9BI0WB3lkNX6TRPd28xUUoJnaBa9XgkFWMzN94QQAgmSNphFz2kx
	 PaZw/sehvHOgalEzPpo11UcW96HExvGAaItg8pV4Kg8qSHAmg2gte30S3GMk5FtC9smzs
	 UeLevbAc2BoEFRsxStQWtzpKGcNlu6khCzI/Xba80bFxSuy9GUDXcoHha3otj/Ep0YA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=E7SQh18k;
	arc=none smtp.remote-ip=209.85.215.228
Received: from mail-pg1-f228.google.com (mail-pg1-f228.google.com [209.85.215.228])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DDCD606A328
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 01:00:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7DDCD606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=E7SQh18k
Received: by mail-pg1-f228.google.com with SMTP id 41be03b00d2f7-cdb684859cbso67343a12.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 17:00:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793926810; x=1794531610;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iF9XMmZuEJqGMH73H20LJnOlU1CR2IP7veqYKnH46VU=;
        b=J7tSP1ndCp1LL64LyGmBVzJ++1lE39pAU08y81/6rTL1moi37kvnROcAHNB8evUOOK
         5H+W1deAjEH8mV6D4aJ8CsGiCk+5HLb18f3kNYqONrq0k3xSYuV8AcazYtHdHJOIDFRD
         Pq3ZfRcK/0TEMfkrjFNlgKH2xUF58kZKUqwpm+xys3d9rYUFQtxxZXouQlqdS3yk9R55
         hzbnHR2UPVeyoexX6wB9fjSeUGdZA6L+8g24hc4PGxOBbXdvDhtgjeVDYpRdFlh8qK4H
         +gXq35aJxDLeFuiCSgZSKq9VWdvs1v8ZOKxT7vCQ85YWgOVE42bCEBITVPCw6IqnGadu
         vUVA==
X-Gm-Message-State: APuU4Z+l8DMvHIu4Au3Tqww8ukk4fQTaNjl0zD0WI+yY2D9hRh1kDSxN
	DEiwmh7ZTdPnysLviHfbEc7/CPVYfcdkV/bJEtXIWtVh3WvF2M+8Q5XhAD7spFD5cwwWnigNk7h
	3KBfxyYzO24v/lEa4+Jz3Q11KYwlHoWCkMYsg7nIrczS6sm74OqnN+Mh1J4m7CcNCJQg3GSFSeA
	0XISxiN+tfd6L+GzRgT0AvHh/YauMwMtnFhJ0cUAQqnr8Uf+AIpRcXRLfBkXaCJUXfUVMpY3+TB
	FWmoEB+E8YwERw1xMVs0GmHYNO+v3Wo7xs=
X-Gm-Gg: AYBFou1WkQkWj862mBtPgbTpL/96L7bHjuTSdizin+rcHisBbJWCSFCR1eJ2ohO9C2S
	Xrw3NgahF7YxhyhbNDmzg4edBr7G206SxadogTWlVnQANg3Zj5gVTmlFa08XnQyknSEtinGo0Gt
	BQoAliwFceUZCk+HIbfsWVYPBEtbfeIi/XkP/5qgszIyot8nJ+zGP8h3+bLQ46UG9vvYpUGuRsA
	nQ5uP/J+45VaRR7tkxw/K2LhWrZX5EmixrLu0ENc+A7zftRkovxjipORJ+Lel06qx/DGCF9Q3yt
	o1GU30Wd62CNffHRYbLIYO3b5pXThc5YXYEhHUfe1NpoJXglwfBrjVpa3HwEtE2EROg2B7EpoeT
	c+vGzR2Scvvp+LLkls1VRQBBqWGUHrHe4WfjD4EAZC/1dg0+ZI5Ok9KdBRI3fHhnYQF6SqS2j2i
	XxJkkhGPx254FHlWeKq0GBZe/Amq3LteBPHXmuXcAjaV4lbgXzdkTJkQ==
X-Received: by 2002:a17:90b:5545:b0:3b0:9691:a240 with SMTP id 98e67ed59e1d1-3b0db6eb3a2mr792283a91.47.1793926809702;
        Thu, 05 Nov 2026 17:00:09 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b096bf4048sm1923884a91.3.2026.11.05.17.00.08
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 17:00:09 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2e8dd9b9743so1329615ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 17:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793926807; x=1794531607; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=iF9XMmZuEJqGMH73H20LJnOlU1CR2IP7veqYKnH46VU=;
        b=E7SQh18kyXFdjFxWcivEFOyk47UEweszaHj4ehVmkfq2sqKtgGD2k3DUb53Q6Fc4kv
         uQQ9cjlWrIX51VrpWt3iOPCY8TPEN4SVu3rmDnTzJG8nH8jlcAQRPg17twgEfwyBSOEG
         x4UV0hRiQs8MhQ/BB3QMZkI4pLgYB84VCiH8o=
X-Received: by 2002:a17:903:32c4:b0:2e9:4175:306e with SMTP id d9443c01a7336-2ed41bfad40mr12054195ad.42.1793926806692;
        Thu, 05 Nov 2026 17:00:06 -0800 (PST)
X-Received: by 2002:a17:903:32c4:b0:2e9:4175:306e with SMTP id d9443c01a7336-2ed41bfad40mr12053845ad.42.1793926806131;
        Thu, 05 Nov 2026 17:00:06 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed47d7b8cfsm450745ad.57.2026.11.05.17.00.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 17:00:05 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 36/37] scsi: mpt3sas: Bound NVMe passthrough transfer size against PRP buffer capacity
Date: Thu,  5 Nov 2026 16:42:51 -0800
Message-Id: <1793925772-1303-37-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

The NVMe ioctl passthrough path builds a PRP list into a fixed per-command
buffer sized as sg_tablesize * page_size. Reject requests where either
data_in_size or data_out_size exceeds that limit to prevent overrunning
the buffer and corrupting adjacent DMA allocations.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index df9674fa2af1..1087802368c5 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -899,6 +899,21 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 			ret = -EINVAL;
 			goto out;
 		}
+		/*
+		 * Reject an oversized transfer, since building the PRP list
+		 * would overrun this command's fixed buffer, corrupting
+		 * others sharing it.
+		 */
+		if (data_out_sz > (ioc->shost->sg_tablesize * ioc->page_size) ||
+		    data_in_sz > (ioc->shost->sg_tablesize * ioc->page_size)) {
+			dtmprintk(ioc, ioc_info(ioc,
+				  "%s: data_in_size/data_out_size exceeds NVMe PRP buffer capacity\n",
+				  __func__));
+			mpt3sas_base_free_smid(ioc, smid);
+			ret = -EINVAL;
+			goto out;
+		}
+
 		/*
 		 * Get the Physical Address of the sense buffer.
 		 * Use Error Response buffer address field to hold the sense
-- 
2.53.0

