Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.139
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793936887;
	b=qQADSnzEZlJ2tWiClzJMKInlpjNXgAPpYkFPJ4LhHTZpVZUCr9NJFTG6ks/YTnjfgaK/
	 z3dUwaLNBBKgdfRwMzwobzI19ZcmJ7VB095cusWdVSEtI8v0PkOtTNOHDs0jBpkStUK0z
	 DI/J1LNiSQaJHKmVObJJp3bNXixXKvOHrsC3fQo2lCrKzdPhemLDVOyceHeE7p7SK/tgA
	 FQchA6I4KUXEOzxxjbWqRVFHglDLKh2fSAbMfgXINJbkJPQOkmmdOKfbNaxiQy3PuV0Hw
	 5hUu3facO/rgGlMJQ4gC9uJ32uyV2DlgkfpxHk/C3ZBuPzUszlu3K7oyClTXmRimu8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793936887;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=mp9vc2fmA8WolxnJVR0p5IkNg2jUdofuz1rHIL/6RxM=;
	b=4wjNlr3SR7BRwPpjun11eu1o4j4feEkBjXAIHVNUZXX0oxt7e7DNe9pDDAavvev7+U+j
	 IN8cmuEQCzlB/HB1jeQ8c/JXa8N2H/tFo98WotKjYw/0Xc6X2qByENmYODquSNGhQdnqq
	 tpkqMZJjxXKS/Bd7SdvbDgBFPhFlRfPjrB/tmulL8FYgqs7YS0HQnz7VeOGqQNGMTd3H8
	 M/SF3IbjE7R4nwW1PjDE83H85/SYQWiGMeuHhQCSfUG+OfdYfMVmdXsiB9dIlpxK4iAOV
	 gOB+4S/lHbELMY1NODMwq6Twtsd7VEdS086AiCpLEbv3l6vVlx9ItzuLAtM8C4vMoGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=LifHQXQw;
	arc=none smtp.remote-ip=111.22.67.139
Received: from cmccmta6.chinamobile.com (cmccmta6.chinamobile.com [111.22.67.139])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B840D606A326;
	Fri,  6 Nov 2026 03:48:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B840D606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=LifHQXQw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=LifHQXQweKN+ISzLsUpQPSXjn5ddMHnC6idVzyCIcMyR3RvTsTrE7oCgyvQXKrLpdsuIFI7mAVELb
	 2OS4sfDzpuUOr9N4TlZ/2XDio/Jgcz7G0U1KI1ZSMRRMDmHJrsh0p8L2AS9Wq0lgChVroQBbt682I7
	 vrR2WvV95dwqbbnw=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app05-12005 (RichMail) with SMTP id 2ee56aed4df0a0a-a9cf8;
	Fri, 06 Nov 2026 11:48:00 +0800 (CST)
X-RM-TRANSID:2ee56aed4df0a0a-a9cf8
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from [25.255.2.225] (unknown[10.55.1.70])
	by rmsmtp-syy-appsvr10-12010 (RichMail) with SMTP id 2eea6aed4def955-10b04;
	Fri, 06 Nov 2026 11:48:00 +0800 (CST)
X-RM-TRANSID:2eea6aed4def955-10b04
From: xujiahao <xujiahao@cmss.chinamobile.com>
To: Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	xujiahao <xujiahao@cmss.chinamobile.com>
Subject: [PATCH] scsi: megaraid: Fix firmware version truncation
Date: Fri,  6 Nov 2026 11:44:44 +0800
Message-ID: <20261106034444.3443214-1-xujiahao@cmss.chinamobile.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The HP firmware encoding writes "%c%d%d.%d%d" into adapter->fw_version
and adapter->bios_version, which are 7-byte buffers.  The format can
produce 8 characters plus the terminator, so revisions with larger
field values would be truncated, and gcc reports it in a W=1 build:

  drivers/scsi/megaraid.c:317:36: warning: '%d' directive output may be truncated writing between 1 and 2 bytes into a region of size between 1 and 2 [-Wformat-truncation=]
  drivers/scsi/megaraid.c:324:36: warning: '%d' directive output may be truncated writing between 1 and 2 bytes into a region of size between 1 and 2 [-Wformat-truncation=]

Size both buffers to 16 bytes, the same size struct mega_adapinfo uses
for the same strings, and pass the size of the buffer being written
when formatting bios_version.

The non-HP path copies 4 bytes into the buffers and terminates them at
[4], and all consumers print them with %s or compare them with
strcmp(), so the larger buffers change nothing else.

Signed-off-by: xujiahao <xujiahao@cmss.chinamobile.com>
---
 drivers/scsi/megaraid.c | 2 +-
 drivers/scsi/megaraid.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index a4079866f..a4995078f 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -320,7 +320,7 @@ mega_query_adapter(adapter_t *adapter)
 			 adapter->product_info.fw_version[1] & 0x0f,
 			 0,
 			 adapter->product_info.fw_version[0] & 0x0f);
-		snprintf(adapter->bios_version, sizeof(adapter->fw_version),
+		snprintf(adapter->bios_version, sizeof(adapter->bios_version),
 			 "%c%d%d.%d%d",
 			 adapter->product_info.bios_version[2],
 			 0,
diff --git a/drivers/scsi/megaraid.h b/drivers/scsi/megaraid.h
index ecbaa0a0a..e95d99e83 100644
--- a/drivers/scsi/megaraid.h
+++ b/drivers/scsi/megaraid.h
@@ -830,8 +830,8 @@ typedef struct {
 
 	/* Host adapter parameters */
 	u8	numldrv;
-	u8	fw_version[7];
-	u8	bios_version[7];
+	u8	fw_version[16];
+	u8	bios_version[16];
 
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry	*controller_proc_dir_entry;
-- 
2.43.0



