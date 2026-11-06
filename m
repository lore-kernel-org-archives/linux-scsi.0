Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.137
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793934582;
	b=cvXZro6rRuOzlFkT89NJt/HR22jfjA8W49c4BFBHKLZJ4bHA0Ab2DC/CD1afRwifDhSu
	 M9MsINvSVYhHd2A9rDs9X14yq5ak8UrnHDIFiGn2sPrHTH+x44zZjWREwcggdYCAg1RiN
	 Sz3Q4oj9fECMnXn78KOqapp/a9SLc0A7DPVrYcyvJJVCnf0iPkrkLpYI0Ilc7MYrnBR5y
	 QFQ7cGaIUbL3tK/h+/LH0MAk28EslrQ/EGdiX1Zteyp42trxXyng9xmE+OoDV/Wnl8Bly
	 5VVLUy381EGj1cU0EcQdBiD1J9w7Emjv/kwL/uxUGI0ae0akV1FW8fnKGC+gHd0+m0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793934582;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=KYBPtrlIi9gXAazDdsBPDTstOux0YKUL3iELrqvYDFI=;
	b=EvAGlfrENuHTWvRGGmruh7VFcyJnXeo5JZIfDpbppP6OMZgGqsg8m6yXAfB2+79ryKST
	 F8VNYf6plgeXjZphcG5zYvE3fg9Qhd7NOolKZZIKGPYTcT4BELBscBEotx511tkNT9qre
	 ywOhs2g3VOHxCNlJj4meH5KB9V5SRfKmLjGa7XNrHg0xrKOkAqQm6hh9RjcnOf1jMRYBE
	 07CTL/mHEHwMwLIKGZFnBhmNMn4vbH7r/3uNhSGiwHjIYD7R5UJginNZ9cMjgqs+2YxqH
	 Pwi/qqgKJvnC/ZrCe22y87UiMXlGBPZrElYXsZTh0SBMXC3TOiQPvp4f35oRAeYQcGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b="wX/K9WBl";
	arc=none smtp.remote-ip=111.22.67.137
Received: from cmccmta4.chinamobile.com (cmccmta4.chinamobile.com [111.22.67.137])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7766606A31B;
	Fri,  6 Nov 2026 03:09:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B7766606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=wX/K9WBl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=wX/K9WBl6nrLO6n6xfx2eC02EaWs9eN2Jysxzqrm1Gg2qLrJUeHZG01hyRwwWeR+AAx2l2xGUXE35
	 PwDVX7YrLBjoUt6UwuI9gsEn6nPYkNlJwpV8l3qsjK/n2UZVjlfaVvhlz7DXf4/wSVv1h1UlqDdJXa
	 HHC5Z6707AR0Y00I=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app04-12004 (RichMail) with SMTP id 2ee46aed44f2bc2-4b693;
	Fri, 06 Nov 2026 11:09:38 +0800 (CST)
X-RM-TRANSID:2ee46aed44f2bc2-4b693
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from [25.255.2.225] (unknown[10.55.1.70])
	by rmsmtp-syy-appsvr07-12007 (RichMail) with SMTP id 2ee76aed44f163e-0f789;
	Fri, 06 Nov 2026 11:09:38 +0800 (CST)
X-RM-TRANSID:2ee76aed44f163e-0f789
From: xujiahao <xujiahao@cmss.chinamobile.com>
To: Laurence Oberman <loberman@redhat.com>,
	John Meneghini <jmeneghi@redhat.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	xujiahao <xujiahao@cmss.chinamobile.com>
Subject: [PATCH] scsi: st: Avoid truncating the tape name for large tape numbers
Date: Fri,  6 Nov 2026 10:17:30 +0800
Message-ID: <20261106021730.3409119-1-xujiahao@cmss.chinamobile.com>
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

create_one_cdev() builds the class device name in a 10-byte buffer as
"n" (no-rewind devices) + tape->name + a one-character mode suffix.
tape->name is a DISK_NAME_LEN (32) byte array holding "st%d", and the
tape index comes from an idr with an upper bound of ST_MAX_TAPES - 1
(131071, six digits), so "n" + "st131071" + suffix + terminator needs
11 bytes.  Names of tapes with large index numbers are truncated today
and lose the mode suffix, which leaves the rewind modes of such a tape
with the same name.

Size the buffer after the actual requirement, DISK_NAME_LEN + 2, and
pass sizeof(name) to snprintf() so the two cannot drift apart again.

GCC reports with -Wformat-truncation=2:

  drivers/scsi/st.c:4393:31: warning: '%s' directive output may be truncated writing up to 31 bytes into a region of size between 9 and 10 [-Wformat-truncation=]

Signed-off-by: xujiahao <xujiahao@cmss.chinamobile.com>
---
 drivers/scsi/st.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index e9d41e3cc..311781987 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4366,7 +4366,7 @@ static int create_one_cdev(struct scsi_tape *tape, int mode, int rew)
 	struct cdev *cdev;
 	struct device *dev;
 	struct st_modedef *STm = &(tape->modes[mode]);
-	char name[10];
+	char name[DISK_NAME_LEN + 2];
 	int dev_num = tape->index;
 
 	cdev_devno = MKDEV(SCSI_TAPE_MAJOR, TAPE_MINOR(dev_num, mode, rew));
@@ -4390,7 +4390,7 @@ static int create_one_cdev(struct scsi_tape *tape, int mode, int rew)
 	}
 
 	i = mode << (4 - ST_NBR_MODE_BITS);
-	snprintf(name, 10, "%s%s%s", rew ? "n" : "",
+	snprintf(name, sizeof(name), "%s%s%s", rew ? "n" : "",
 		 tape->name, st_formats[i]);
 
 	dev = device_create(&st_sysfs_class, &tape->device->sdev_gendev,
-- 
2.43.0



