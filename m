Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793926752;
	b=JZ5DKOC1js2c0Uk1J8QGXPBsmpNui+RjLzyuGO+p2j7X0EXVAQDRlTEzuRSjW0LmBAZq
	 tKPicysOuBNJ5zxjidJKQPX/DcbBAT8vKmCRH0TN6mfYjVITVaf1/fSWGrMhWgi2yRgB4
	 KqplQxvTohwehQaZuxlIBBYIPxZ4e0G3giWu4EKwNlVHqf5rspt9gU8DB07SbVO5rGok5
	 W6Uyv6OkDvNWOSbOa7MxqmnHr/AN2BxHa7I5zEM1q3Lp5BCf3zbmbcutbDCLFgMjOSu+p
	 9CQFWkKebslETsVEIFpIV/PV/ht/6FYUiz1PtQI57jurdkfNbSOTd30UJPIt2cHtC4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793926752;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:X-DetectorID-Processed;
	bh=nc3xYTUdVskb8cAI+3wJE0wixc20N7ndgApW8fYSpXQ=;
	b=5ANhtkazSRh0BzDZ6Cz82j+s+gKJ54KlBMar15/ERbw3urP7Wpi3+gdcmjfTk3wqLDo6
	 wiP+lSPr7+zTQJ2B2Fj8zqXPOsrmYYr58hHzZ9fuHyiy+4UwA+CPSE/35HFPxGIAAe+OR
	 9cSSFnITBXnW3mAuGdZQ0uR6XXdGrPliHB8kz5BorIrOZ/SsFjZWwEOTnbO06thBAEhj4
	 qv0Hjcd7O5TzLuxTvxqxrzKiPhGB7H4kqhSPwn/XUXPoWgtLOcElpq8OKCumNN/tu8zLg
	 gJu3O/vOw8iiorEbO7Nh1XAHCV32Dc/w7ZiHeoA8UnP8mhrBJD31dkjKf1Z8gd030xA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b="E/bn/FOF";
	arc=none smtp.remote-ip=209.85.222.100
Received: from mail-ua1-f100.google.com (mail-ua1-f100.google.com [209.85.222.100])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B78E606A31B
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 00:59:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9B78E606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=E/bn/FOF
Received: by mail-ua1-f100.google.com with SMTP id a1e0cc1a2514c-998d151f441so14707241.2
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:59:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793926750; x=1794531550;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nc3xYTUdVskb8cAI+3wJE0wixc20N7ndgApW8fYSpXQ=;
        b=BXg3zhOSgMycYbWuMez+w639YVv7OA8XBqxRFOzWv+nfLZSOShQNI90Dq6fcCgoSmb
         0eH3HmzENzOOd7uRQfIt0CbnF8EaEMB8qdDaroCd3lSUQ3JJK5IiLFxttycU9Uc+EIPz
         C3ghNieSEYh87MqWmB04RDTwhZcmCnbtwI/HUHDpUhHc4fhXF5q5YlsXBrfYNQXB2Pzb
         eHAi4YJPP4pEO4cE0xmPHrfRR//fEv7EOp/Ym6/LXCa+54saP+k05MfGNq/JGkkHYYEt
         mcCINitGq4OEOV3ofOE4MlFa7awQQRA5DBheeLCI+SViMM3/N0iUU35V0FV54qhbP8H9
         c0CQ==
X-Gm-Message-State: APuU4Z/u6gBdGHTPE0+h2nX39Y+0cSjo0Lddf9C65KHDEnHSA4xPfGbQ
	mTQFsDna0WAebfAOqVIuepGOosdeGJry30t1FKgGhxMSlsMq154jgwqIWD6gUsWMatRoKxZwYK7
	De92z188sY6u7wf6YozQEAQQ0nMEvnRDEN7jeSYifjLDj013sbWgIvBu5K8pDNKrqqTcxcQwS2b
	JhwtqA5MOqZcGG9l2U5yGWRI41kSKDad60LAorvx/+X4d09NuZl2OAQw6c4Sjbiv2783yWWUgZu
	1jggwx9M+StcfbKkkWb8Kb3h7joSFTNv2w=
X-Gm-Gg: AYBFou0hKgkjzVqllSVLAda4I+5gG3QmxPy8AJDr8zJfXl0oK0RF43DtrQ4yBty3n5i
	BZMVuTVuXymuGDwx/ZU4N0P4WGzajQ/6eXCxPUYpWEQF6zYqyw+R0tm6xA6W82VDx/FgpM9bmeQ
	wBrzV1dh8HsrkHzPz87Sk1g6YJivpQGl63FQup5BnvBzDm/bgl3PjKjzA+wABa8VfqqB3XlX3wN
	+5b0hP6uo5JDETy+RItTpQPccSgSYX2nE36KXtTqsgjg3cC3Zmk8MeYdGmiZpzjEWpQLN1RNzh3
	jxs8S6QeLd95zOX0Eglx13qijnwngUTqqyyFd5Gpz8zLd58wiqKBzZhpBwFehIFrmg5PGLtu6Dp
	bfw8/qjzGsVLu8y/6K491nABUnf6ny2kOeczB4Hvl+YN4jfPRYj/TlnEJjQj4jWdBvxdHdybOhV
	Dcx40MX8fIzILz/cT4h9vjBFSb3ibB8mX+a75bMX7Ew7jC6kuOdwltnA==
X-Received: by 2002:a05:6102:604e:b0:7d2:840b:b064 with SMTP id ada2fe7eead31-7d2a130dc30mr665357137.3.1793926750372;
        Thu, 05 Nov 2026 16:59:10 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id ada2fe7eead31-7d2a88c065fsm2954137.5.2026.11.05.16.59.10
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:59:10 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2e8e16d22d8so1735515ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 16:59:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793926749; x=1794531549; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=nc3xYTUdVskb8cAI+3wJE0wixc20N7ndgApW8fYSpXQ=;
        b=E/bn/FOF16oWAJKWsuiUnXZ9ZjU5peZeYRfVlyIhtVxRN1rhdteAo2jEwvarDwEISV
         MOCKyih9h8ILF9Uy69/sexFAfJzk8Qz4q3ITFml14OzRhFeR66Y3lS/83KXjEdOYkTIF
         Y8umvCPzWPA21TJitTAqjPKC2wPD/ogJ6zTs0=
X-Received: by 2002:a17:903:1b0b:b0:2e5:a355:56d8 with SMTP id d9443c01a7336-2ed40daea89mr14481415ad.42.1793926749161;
        Thu, 05 Nov 2026 16:59:09 -0800 (PST)
X-Received: by 2002:a17:903:1b0b:b0:2e5:a355:56d8 with SMTP id d9443c01a7336-2ed40daea89mr14481255ad.42.1793926748668;
        Thu, 05 Nov 2026 16:59:08 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed47d7b8cfsm450745ad.57.2026.11.05.16.59.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 16:59:07 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 19/37] scsi: mpt3sas: Reject implausibly small MaxReplyDescriptorPostQueueDepth
Date: Thu,  5 Nov 2026 16:42:34 -0800
Message-Id: <1793925772-1303-20-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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

Avoid an unsigned underflow in the hba_queue_depth calculation when
firmware reports a too-small queue depth.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 7 +++++++
 drivers/scsi/mpt3sas/mpt3sas_base.h | 9 +++++++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 4e2cee2e13fc..12295ab544ad 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -6452,6 +6452,13 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 				(ioc->reply_post_queue_depth % 16);
 	}
 
+	if (facts->MaxReplyDescriptorPostQueueDepth <
+	    MPT3SAS_MIN_REPLY_POST_QUEUE_DEPTH) {
+		ioc_err(ioc, "MaxReplyDescriptorPostQueueDepth is too small (%u)\n",
+			facts->MaxReplyDescriptorPostQueueDepth);
+		return -EINVAL;
+	}
+
 	if (ioc->reply_post_queue_depth >
 	    facts->MaxReplyDescriptorPostQueueDepth) {
 		ioc->reply_post_queue_depth =
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 47255bf9cdda..192b8e8a5b4d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -145,6 +145,15 @@
 #define MPT_MAX_HBA_NUM_PHYS		32
 
 #define INTERNAL_CMDS_COUNT		10	/* reserved cmds */
+
+/*
+ * Minimum reply post queue depth for hba_queue_depth to stay non-negative.
+ * Values 66-79 floor to 64 after 16-alignment, making ((64-64)/2)-1 = -1
+ * which wraps to 65535 as u16. The smallest value whose aligned floor exceeds
+ * 64 is 80 (80 % 16 == 0, giving ((80-64)/2)-1 == 7).
+ */
+#define MPT3SAS_MIN_REPLY_POST_QUEUE_DEPTH	80
+
 /* reserved for issuing internally framed scsi io cmds */
 #define INTERNAL_SCSIIO_CMDS_COUNT	3
 #define INTERNAL_SCSIIO_FOR_DISCOVERY	2
-- 
2.53.0

