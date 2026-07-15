Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D103D16F0;
	Wed, 15 Jul 2026 08:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784105216; cv=none; b=jONBZ61wUv3ju4bQ5r/bs83sfnOjPdGdHSAggHMpHr1fH5p8357csyketZ0l1SQX7wsBCpFFmO58aB6hRntgkPWZir1Nex4Ns8q1CPBuD1Q0NPk+YKdZKQg3hlFDUpfE9w7xQu0d+Wrct4afTNZ9P9J9kxLkMeY2m+CGW+49iBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784105216; c=relaxed/simple;
	bh=uNk6L6GKzEOaVOBLX7Nwz5vsh20+Zo+t/TviSdKLsL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UeWpuB+05HbBoYZruo8lRIWhnaASNLVKvKHovj7EyLUvwkUzPQbT4lRukaNiFd9o0QhoZFwx99T5J6etWtDZuuOLQplcrHU60Hlck9j/dE2PFvSimGd16iuKcl/hqDfAHtNcZX99Gh5gkYXYcUR4bj6xbGQtAWjhyVWYsvto6Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.245.140])
	by APP-05 (Coremail) with SMTP id zQCowACXB+v8SFdqE4JHGA--.7917S4;
	Wed, 15 Jul 2026 16:46:52 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: martin.petersen@oracle.com
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	James.Bottomley@HansenPartnership.com,
	aradford@gmail.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] scsi: 3w-sas: bound firmware error strings
Date: Wed, 15 Jul 2026 16:46:52 +0800
Message-ID: <20260715084652.47248-3-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260715084652.47248-1-pengpeng@iscas.ac.cn>
References: <20260715084652.47248-1-pengpeng@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowACXB+v8SFdqE4JHGA--.7917S4
X-Coremail-Antispam: 1UD129KBjvJXoWxZw13tr1fWFWxArW5WryfZwb_yoWrGF13pw
	4rKas8JrW8JF15Jr9xCw1UZr45C3Z2yayFg34UX342vFWUGr90qFySkr109ryjkryxAw4j
	qF4Fv39xuF18ArJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPj14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1l
	e2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI
	8IcVAFwI0_Jw0_WrylYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwAC
	jcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_JF0_Jw
	1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWU
	JVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7V
	AKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Xr0_Ar1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMI
	IF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjTRRLvuDUUU
	U
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

The controller response header stores the description and optional firmware
error string in its fixed 98-byte err_specific_desc field.
twl_aen_queue_event() and twl_fill_sense() use strlen().  They derive an
optional second string without first proving a terminator lies in the
firmware-owned field.

Without a terminator, strlen() can scan past the field.
A first string reaching the last field byte also makes adding one form a
pointer past the array.

Terminate the field before parsing it and use a shared helper that treats a
full first string as having no optional second string.  This keeps both AEN
and sense reporting paths within the response field.

Fixes: f619106bdd9d ("[SCSI] 3w-sas: Add new driver for LSI 3ware 9750")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 drivers/scsi/3w-sas.c | 31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index 52dc1aa639f7..5fc46a90e026 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -92,6 +92,24 @@ MODULE_PARM_DESC(use_msi, "Use Message Signaled Interrupts. Default: 0");
 /* Function prototypes */
 static int twl_reset_device_extension(TW_Device_Extension *tw_dev, int ioctl_reset);
 
+/*
+ * The firmware field contains two NUL-terminated strings in one fixed-size
+ * array.  Make the last byte a terminator before finding the optional second
+ * string, and never form a pointer one byte past the array.
+ */
+static const char *twl_error_string(TW_Command_Apache_Header *header)
+{
+	size_t description_len;
+
+	header->err_specific_desc[sizeof(header->err_specific_desc) - 1] = '\0';
+	description_len = strnlen(header->err_specific_desc,
+				  sizeof(header->err_specific_desc));
+	if (description_len == sizeof(header->err_specific_desc) - 1)
+		return "";
+
+	return &header->err_specific_desc[description_len + 1];
+}
+
 /* Functions */
 
 /* This function returns AENs through sysfs */
@@ -226,7 +244,7 @@ static void twl_aen_queue_event(TW_Device_Extension *tw_dev, TW_Command_Apache_H
 	TW_Event *event;
 	unsigned short aen;
 	char host[16];
-	char *error_str;
+	const char *error_str;
 
 	tw_dev->aen_count++;
 
@@ -250,10 +268,9 @@ static void twl_aen_queue_event(TW_Device_Extension *tw_dev, TW_Command_Apache_H
 	tw_dev->error_sequence_id++;
 
 	/* Check for embedded error string */
-	error_str = &(header->err_specific_desc[strlen(header->err_specific_desc)+1]);
-
-	header->err_specific_desc[sizeof(header->err_specific_desc) - 1] = '\0';
-	event->parameter_len = strlen(header->err_specific_desc);
+	error_str = twl_error_string(header);
+	event->parameter_len = strnlen(header->err_specific_desc,
+				       sizeof(header->err_specific_desc));
 	memcpy(event->parameter_data, header->err_specific_desc, event->parameter_len + 1 + strlen(error_str));
 	if (event->severity != TW_AEN_SEVERITY_DEBUG)
 		printk(KERN_WARNING "3w-sas:%s AEN: %s (0x%02X:0x%04X): %s:%s.\n",
@@ -861,13 +878,13 @@ static int twl_fill_sense(TW_Device_Extension *tw_dev, int i, int request_id, in
 	TW_Command_Apache_Header *header;
 	TW_Command_Full *full_command_packet;
 	unsigned short error;
-	char *error_str;
+	const char *error_str;
 
 	header = tw_dev->sense_buffer_virt[i];
 	full_command_packet = tw_dev->command_packet_virt[request_id];
 
 	/* Get embedded firmware error string */
-	error_str = &(header->err_specific_desc[strlen(header->err_specific_desc) + 1]);
+	error_str = twl_error_string(header);
 
 	/* Don't print error for Logical unit not supported during rollcall */
 	error = le16_to_cpu(header->status_block.error);
-- 
2.43.0

