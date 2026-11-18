Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.98
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794996857;
	b=UJzr8CAFp7lFtSTpfW1zqGNRfrG3mBAVnCTBAFzzZ8YbcJObDlpF5RP44vBc7u98ahqW
	 OM45cMXCnT/b5ke+qiF0yepORrkFidokDaOZnl39SwZ4WxzGyNDBx8DINjdtJzs4b79PF
	 4UsggJwx26UoVYbu74KBH6xRbM//DbvP5lOh8R8MGLVa+qXdcmM/BVIDj6f+2w6ILL3fa
	 c16CycuQaTyyht4A2aSWlztZ+Iy3rmCYw4+e87SgcZi9hF1ssO2o08qdZ5dEQTJq0enYX
	 hEmagKvVS9d3WFNrjWlpztUg4CpcVFZq1tOPJw7l3GX2ThV73NhoWlBRat0Vf+3rWUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794996857;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=887cpRWQ/fGqqrIUhFxQo3KI4bz2hlmlYvY38qklhLw=;
	b=GoGebaU17xRm8j40ezjt4hsdg3QnVXFa/DMYHAFW9oH4Kry+rtCxHk2uSsevIxCMtoBS
	 JJk7mUTg7eeQa+YP5Bs0/9bAdLYeQXS/rmclhUKTjcrzm8Lvs1Pb7XnwSONRKrZTuIWVq
	 V0WHaYBDjQ5aNm3QEBoECPv1g2/tEN/igEqMcfkl4IpivKr2JMXSqaX+tf08ZghM7t1Cy
	 DayohxqiEXYREP4Wz71nhau/jLNCn0akw3tVrYHA4j0iqb/9kkWQrNI2HpQ9DtsIZuXHJ
	 TAkCWipBZtV9LhlntMoTHEET2TEXCK7mZwJ2zpN+h5JRyRGPonAssK6JbloWZY4XIFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=e2I8TmBk;
	arc=none smtp.remote-ip=209.85.219.98
Received: from mail-qv1-f98.google.com (mail-qv1-f98.google.com [209.85.219.98])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B47606A31C
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:14:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 19B47606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=e2I8TmBk
Received: by mail-qv1-f98.google.com with SMTP id 6a1803df08f44-91ccfb88e4dso7908726d6.0
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:14:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794996856; x=1795601656;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=887cpRWQ/fGqqrIUhFxQo3KI4bz2hlmlYvY38qklhLw=;
        b=tzoYrROOZ7uSmVL9u8/OeQRmLNDWrxNr8ZgLLkQr7We+YV8jWLs1Iao8K+k0eO/Lt3
         /pI8PBx7OJtU3a1HE1lhreDkt0Jwl13GwMyaQXM2xvlG6IOROT+IWnoxZ/3aX59eENLK
         6tzh7JDidHHPxNEiIFulT+ukilPvFF5pzoGn89MFrrXZdJ0cyxlfdIJMNfLDErzKJ5ap
         zM8KhzOQ5z/Ikm1+e2VIJJr0f7jJgch0hzTeNNJ+DbMKSZNb02pCkMCHtwGntvf4PQGv
         UX6y5gqyPKn8stdk06zuAUTvajNAtcDmNNGjqeuq2n8xv0XyaiwOgd6439sbNTCT2N0W
         jpgA==
X-Gm-Message-State: APuU4Z/43HE8A7eOnbJU/JN2fJbT8rz+FBgvhoG8J9HZbweZdGxFe33K
	c0rKVseK44aXYibCgs1pRDkMU0SebaK2km9SUC2YxwOiN1khGpOpFRpul4+tzMcOMIvYUjA9nPq
	5umBlPce84pUBZWRoYWuVCmcN9qVEDitfr5nmWxqQpSpinpBA5P+HJYOAWm86fBCGZAVB9DqNgL
	s093B51e84YNFuJlamJDWQmsmQGc3T/auHvriH8DWsgMAtdJtfnQJdqzA709igB9FK8QSrr35+b
	40YMQD48OpYqveCf74svpqi1vUAjLqW+Ww=
X-Gm-Gg: AZFdTZfzeSWRPBD0Rhz0xs2K3AzoxdHY0t45Ya9OkaO230HbbuHk34BLLaZb/gHVxpG
	+5WAZHyPnT7m2EYpDR+IK5HldEQscJ+ZdggFYtXBKeJyHdB0CPrA1eRziZCZkFvNgZ8kcbC6EC9
	TPIOlDUZpXHgy8F4V9+Bw7DdzuESOp8cQs2kEC/tjNzZcSwLSoDfbqL3Qhb1kbQ55cZOeIDFkJ4
	oWffkh81Z82fbN/wDotVyih8ulHTuSSPOFNWmcrQ6ucVtvwVRpkMqavh2DbnHBqGecduauzbxP8
	waIRUmkNqeIk76Ee1A+SPKr0lLTvR5+R06fA1G28fj6vizPRkOqDkQbPAK1lrXeBHn+TuukCRS7
	GLhWDw5TStUUMroKiFyTwERXpt4YUsra8wBNmqFoBI4EUvU+Y6+Ff7/rQiDW9E/AdLiANbTQQpB
	froOImH2BrvmzXcSijXgJFDT7raL2v5SUJfXyeQICIxbCSpYE4tqsP/g==
X-Received: by 2002:a05:6214:5545:b0:921:1242:f2a6 with SMTP id 6a1803df08f44-92114e6805cmr28605196d6.15.1794996855737;
        Wed, 18 Nov 2026 02:14:15 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id 6a1803df08f44-92114e2e3edsm235276d6.29.2026.11.18.02.14.15
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:14:15 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3b0c7ab2427so653648a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 02:14:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794996854; x=1795601654; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=887cpRWQ/fGqqrIUhFxQo3KI4bz2hlmlYvY38qklhLw=;
        b=e2I8TmBk/OzYlIWu+YfB2Wrjr7pDBJUM2oaxYQV0zsU6nJmSJnR+oM6huGJn1+XhbN
         bObGOXusV4BuCPxcOtcOhcd8jgtBxtrO8ybL479noI+M3BOUnv43zmcWO/0c2AeWFMVF
         Z1qYkiXy7EN1zxs67/L8ANF2DaQFIbxUT6e+I=
X-Received: by 2002:a17:90b:4b05:b0:3b0:968f:fdee with SMTP id 98e67ed59e1d1-3b3d07ca11emr2314140a91.55.1794996854366;
        Wed, 18 Nov 2026 02:14:14 -0800 (PST)
X-Received: by 2002:a17:90b:4b05:b0:3b0:968f:fdee with SMTP id 98e67ed59e1d1-3b3d07ca11emr2314117a91.55.1794996853762;
        Wed, 18 Nov 2026 02:14:13 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3ac6016c3sm8740707a91.15.2026.11.18.02.14.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 02:14:13 -0800 (PST)
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
Subject: [PATCH v2 36/37] scsi: mpt3sas: Bound NVMe passthrough transfer size against PRP buffer capacity
Date: Wed, 18 Nov 2026 01:56:45 -0800
Message-Id: <1794995806-5835-37-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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
index c3d337c203ef..b147640a139e 100644
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
+		if (data_out_sz > ((u64)ioc->shost->sg_tablesize * ioc->page_size) ||
+		    data_in_sz > ((u64)ioc->shost->sg_tablesize * ioc->page_size)) {
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

