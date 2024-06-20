Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26D11CFD69;
	Thu, 20 Jun 2024 17:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718906332; cv=none; b=PCHk+HB3prAbWetC6+M0qEBEXBEBc5wGh3UalDBabLGluz9hZDl7o3Y3zY1xfvp9sAnUd/7syK73sqj04cJlIp+9IC9IvKIG7dtSSNRu2pNwR69N5Qjji0yD0oa9yIal+wsShLzy81kD9m9TEb4GwdRoFwxzjhDNTuGYVDAvvuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718906332; c=relaxed/simple;
	bh=JtxyDAJmwTseDc70rSPwJFLuifJTU6XLGZKMlZ49AeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lNSZGDggHeuk3mnGyLyMYvlsMcszSW7VpxzLqmzF/lzBpNDLZ9XBThcYytq9JTDMZQystC4+iKSTffT25oEcsMdjs+0emYWh26IpcA7F6L8T8KhVTOt9ALM56Kcwxd8bt9Fli04cucQrOSyiId4RR9YtCIkMknJUxxgmb+qqETM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PGH7yXlF; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PGH7yXlF"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-707040e3017so848802a12.3;
        Thu, 20 Jun 2024 10:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718906330; x=1719511130; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A1P/SC3CnW8VwRQdxuFYJOk3VzBL5R50SJhCR1VLaP4=;
        b=PGH7yXlFlJDTnty4owPptnNHe+umUxWtkr+BLCQiHnnQ0RRcUFPhQAvHw8VPrlcgbK
         RvCaW0y+LhjS5W8EDgD8pXrMvWD0vNEVrYHBHFETWMbi1GIwG6r20Kazdaw64g3lS+nE
         RBLfFngZS1bWDgd2GisjdNvUWVHa8dAiZrIhP3hVSlaV6AZGE7VjMaXTnVeF5o6ftkzS
         1ZUQjQCHaoW0hLRoBDBk0oTrel+h+DmPCC2AQh5gJ0XpvDdSt61JeczEeCNjYXRySg+k
         Jzoa0PwStq+z1IGT4apIA7ufuQqNH/JGLMEezJztD9dg/HTcEV6m8hR2CZ5S81mh7NIq
         IxAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718906330; x=1719511130;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A1P/SC3CnW8VwRQdxuFYJOk3VzBL5R50SJhCR1VLaP4=;
        b=tGOgqS3eWoa1Wn4I1wXFvz3sEadJ6TiVxTZG6HS4uzl4WmW+NxoHP/kDlWB+z1pUNs
         sN2qS3Ir3ufG5nqTm0Z+OJZYb021X1FOIkP21l9F9/TK0/8buSeP/xX9WZbC6zqEbB2r
         zMbtK8p9wfoNlidHDYRXf+eH6vvr1xPc6FCbYIgvCSbHspriiFCGox2lyoIwHT0iw0YZ
         zP5e/gOgEQsbNByX8MkmiInBWB4S8BGckWq4dI3A4DFpF0mneIreP9szpy6BmEZaK+N8
         9YNvfy1/kVVW0fHKSqZSobia5qkzH95ctr1mLEPn0Zdk+Y5CX8uZqZl9k6bI0CYUw4i6
         ufcQ==
X-Forwarded-Encrypted: i=1; AJvYcCXxTkkWqaXDdMwA3wQqKWfCqpGWbV9+DrLHLPCJiPINKCP5cH1Kful/mTfbNMkHiowTn1zZKwJsvoyq7wc75R01O4f+YISvEAsj7Q==
X-Gm-Message-State: AOJu0YzGef4T/z08mzX+lG7ESTFhJc+8rspd6sX/FFQAI9kSh31hmCjR
	VfcO96sukxM9Pz+E4YKElfjHmodV2s7gTx4KnrxnkY2XKCNkS9lY/3+ZjvFghH0=
X-Google-Smtp-Source: AGHT+IGWXsSjB74ZkY33xSGV66MpkL8BGYuPS62vzS9X76Uki4Qr6bCcEMzRCDBxT7/iFMdNX6o18w==
X-Received: by 2002:a17:902:dac7:b0:1f7:90e:6d3e with SMTP id d9443c01a7336-1f9aa47878dmr72023545ad.67.1718906330373;
        Thu, 20 Jun 2024 10:58:50 -0700 (PDT)
Received: from localhost ([216.228.127.128])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f9941d957fsm56566125ad.273.2024.06.20.10.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 10:58:49 -0700 (PDT)
From: Yury Norov <yury.norov@gmail.com>
To: linux-kernel@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
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
Subject: [PATCH v4 36/40] scsi: sr: drop locking around SR index bitmap
Date: Thu, 20 Jun 2024 10:56:59 -0700
Message-ID: <20240620175703.605111-37-yury.norov@gmail.com>
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

The driver accesses the sr_index_bits bitmaps to set/clear individual
bits only. Now that we have an atomic bit search helper, we can drop
the sr_index_lock that protects the sr_index_bits, and make all this
routine lockless.

While there, use DECLARE_BITMAP() to declare sr_index_bits.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 drivers/scsi/sr.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 7ab000942b97..3b4e04ed8b4a 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -33,6 +33,7 @@
  *	check resource allocation in sr_init and some cleanups
  */
 
+#include <linux/find_atomic.h>
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/kernel.h>
@@ -103,8 +104,7 @@ static struct scsi_driver sr_template = {
 	.done			= sr_done,
 };
 
-static unsigned long sr_index_bits[SR_DISKS / BITS_PER_LONG];
-static DEFINE_SPINLOCK(sr_index_lock);
+static DECLARE_BITMAP(sr_index_bits, SR_DISKS);
 
 static struct lock_class_key sr_bio_compl_lkclass;
 
@@ -566,10 +566,7 @@ static void sr_free_disk(struct gendisk *disk)
 {
 	struct scsi_cd *cd = disk->private_data;
 
-	spin_lock(&sr_index_lock);
 	clear_bit(MINOR(disk_devt(disk)), sr_index_bits);
-	spin_unlock(&sr_index_lock);
-
 	unregister_cdrom(&cd->cdi);
 	mutex_destroy(&cd->lock);
 	kfree(cd);
@@ -628,15 +625,11 @@ static int sr_probe(struct device *dev)
 		goto fail_free;
 	mutex_init(&cd->lock);
 
-	spin_lock(&sr_index_lock);
-	minor = find_first_zero_bit(sr_index_bits, SR_DISKS);
+	minor = find_and_set_bit(sr_index_bits, SR_DISKS);
 	if (minor == SR_DISKS) {
-		spin_unlock(&sr_index_lock);
 		error = -EBUSY;
 		goto fail_put;
 	}
-	__set_bit(minor, sr_index_bits);
-	spin_unlock(&sr_index_lock);
 
 	disk->major = SCSI_CDROM_MAJOR;
 	disk->first_minor = minor;
@@ -700,9 +693,7 @@ static int sr_probe(struct device *dev)
 unregister_cdrom:
 	unregister_cdrom(&cd->cdi);
 fail_minor:
-	spin_lock(&sr_index_lock);
 	clear_bit(minor, sr_index_bits);
-	spin_unlock(&sr_index_lock);
 fail_put:
 	put_disk(disk);
 	mutex_destroy(&cd->lock);
-- 
2.43.0

