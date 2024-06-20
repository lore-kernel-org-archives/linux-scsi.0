Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61481C0044;
	Thu, 20 Jun 2024 17:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718906274; cv=none; b=EiUydBIjhUzUSGIdVbrYDMBwtjnq3PZ+2p2i98HjYOo/jpY1SnEuxp5DkQEp+IpbTH1TXjjt1t3NtkGTIJBhY/O9O54ytzHFyiNvNP/ZTXtUvHrokDVFfv2HjC1PNiS8wl2n9KebrZm7wv6rPdyMN5j+xAX1YGHo12J5wF1wxMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718906274; c=relaxed/simple;
	bh=pqtOnbnky5xRYHpCY2gs4oz50L4qhYf4MNiIl6TOKwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P20jkhwBQMFZx0q1PriSOX8N72XyTB2hxi77rwbfK0Uoly1iLGD0ws9dPzV9p/killjtWYKSq1v0wTXpkWd8n49IlYqNvIcGTlad86VILnilWa6vYUtmJjYlak3fIXq3RuJGiDuNsJtg9Q1X4eRKDl0cPW+fSk/J7F0wPtiXPbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O1jMxBXj; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O1jMxBXj"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-705b9a89e08so1073741b3a.1;
        Thu, 20 Jun 2024 10:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718906272; x=1719511072; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ns854O7sPQQdjBV1LbOoY/vyRfsFM848PqiWwxxwo8Q=;
        b=O1jMxBXjVu0N5+tWWL30ewrTny4DzaseEqvxCLu2Nc50n2Bwh6+gy3eoxN8ivLaNSX
         EvwN/XaOeYwQx8QpNBrsWp4C/WN7GBdwYQ/Vn78UQY/hzYnfmcTkvPymiuWma1zCAAUQ
         R9l77JzK8pSQEBaeU913tIG2Tr5QI3PC+fuDWdNqC8MnCPUoXHxZ5vJAbof2qq9zRXUQ
         ryppYDBUNfhNipgNzy9Xw6gqEE9bFAFn86/dmpU0Bg5ilJ71MNlpzAEGQCKv1tpGLQm2
         WnknKA/+/9ujGyHxmNlX1msLvoHwJoLxY5Dpew1/01VUhPxLmVmR6AG+a3nYXXXqlB04
         +OVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718906272; x=1719511072;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ns854O7sPQQdjBV1LbOoY/vyRfsFM848PqiWwxxwo8Q=;
        b=J3xwNirKAgk4ZMY2/WzU4GKvFpgG/wa38CxBYGzO1am7y1Om7Ds/mAXXj5vL6NjxJE
         LExG4FVYxs55+CrYJHjpVltsVVEsKCgeleVoEc9F4sN5Q33cN1azHTiIo4lbCpJXcBC/
         MQHlVO8rOqTujkf0CQnqltaHd3IlZj6X0nVqnRpohd/D0n8KUivg2O68m6oG4XbmeEnn
         PzXgsS/uv8m/CrgFMTuHqKJUdpRo/xT5oyVhEAzWNuYdLgIVzYrcH1zHPD6J4eZkPcnA
         KATkpF7HTQbLqDiGx38x/BzCh4uAPZx40bPEg4jN2p8rK2UY+zdtqWuyIHn6jepH+OuH
         qFBg==
X-Forwarded-Encrypted: i=1; AJvYcCWYojj9pMILWknuQpXZivtGWh0FDEM9jqjT2OA4oy590qZnyRG/PLxfoy1dZr3uuruK9+wWjHa3Eeqoc/m5vF4YQKjgMZ3wA0n3Bw==
X-Gm-Message-State: AOJu0Yw+rNepwRzrue/+//2UGT1wvYZLdrgFRVP8XT2iMGyIe9p7ZQjn
	crOf2IeNLeCnQbfxDUsFBs7pcF+B0XuSnPLgk6JPNAEMTzi2fvvrFVL5WbXkW60=
X-Google-Smtp-Source: AGHT+IFQDBD85AA/e7ZhBS6C/4LWgeRZuwweRJrrA1tTXXTcy4Qlg68OlOPMF2Nl1kWKC++a1RbKnw==
X-Received: by 2002:a05:6a20:3b93:b0:1b7:d5d5:415b with SMTP id adf61e73a8af0-1bcbb6982femr5756881637.57.1718906272053;
        Thu, 20 Jun 2024 10:57:52 -0700 (PDT)
Received: from localhost ([216.228.127.128])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-705ccb6b4fasm12608970b3a.150.2024.06.20.10.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 10:57:51 -0700 (PDT)
From: Yury Norov <yury.norov@gmail.com>
To: linux-kernel@vger.kernel.org,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-scsi@vger.kernel.org
Cc: Yury Norov <yury.norov@gmail.com>,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: [PATCH v4 15/40] scsi: core: optimize scsi_evt_emit() by using an atomic iterator
Date: Thu, 20 Jun 2024 10:56:38 -0700
Message-ID: <20240620175703.605111-16-yury.norov@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240620175703.605111-1-yury.norov@gmail.com>
References: <20240620175703.605111-1-yury.norov@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A plain loop in scsi_evt_thread() opencodes optimized atomic bit traversing
macro. Simplify it by using the dedicated iterator.

CC: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 drivers/scsi/scsi_lib.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ec39acc986d6..72bebe5247e7 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -13,6 +13,7 @@
 #include <linux/bitops.h>
 #include <linux/blkdev.h>
 #include <linux/completion.h>
+#include <linux/find_atomic.h>
 #include <linux/kernel.h>
 #include <linux/export.h>
 #include <linux/init.h>
@@ -2588,14 +2589,13 @@ static void scsi_evt_emit(struct scsi_device *sdev, struct scsi_event *evt)
 void scsi_evt_thread(struct work_struct *work)
 {
 	struct scsi_device *sdev;
-	enum scsi_device_event evt_type;
+	enum scsi_device_event evt_type = SDEV_EVT_FIRST;
 	LIST_HEAD(event_list);
 
 	sdev = container_of(work, struct scsi_device, event_work);
 
-	for (evt_type = SDEV_EVT_FIRST; evt_type <= SDEV_EVT_LAST; evt_type++)
-		if (test_and_clear_bit(evt_type, sdev->pending_events))
-			sdev_evt_send_simple(sdev, evt_type, GFP_KERNEL);
+	for_each_test_and_clear_bit_from(evt_type, sdev->pending_events, SDEV_EVT_LAST + 1)
+		sdev_evt_send_simple(sdev, evt_type, GFP_KERNEL);
 
 	while (1) {
 		struct scsi_event *evt;
-- 
2.43.0

