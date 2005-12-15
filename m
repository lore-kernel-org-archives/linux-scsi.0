From: Matthew Wilcox <matthew@wil.cx>
Subject: From: Matthew Wilcox <matthew@wil.cx>
Date: Thu, 15 Dec 2005 16:07:32 -0500
Message-ID: <11346808522583-git-send-email-matthew@wil.cx>
References: <11346808523659-git-send-email-matthew@wil.cx>
Reply-To: Matthew Wilcox <matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.magmacom.com ([206.191.0.217]:56216 "EHLO mx1.magmacom.com")
	by vger.kernel.org with ESMTP id S1750946AbVLOVHv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Dec 2005 16:07:51 -0500
In-Reply-To: <11346808523659-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Subject:[PATCH 3/5]"@wil.cx, "[SCSI]"@wil.cx, Fix@wil.cx, printing@wil.cx, of@wil.cx, two-byte@wil.cx, messages@wil.cx, Matthew Wilcox <matthew@wil.cx>

A missing comma meant that "Ordered Queue Tag" and "Ignore Wide Residue"
were being concatenated together.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

---

 drivers/scsi/scsi_transport_spi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

bf55571883d8fc9e9b1e2fd238d9760dacb4f914
diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 59fb69b..8cc5dff 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -1060,7 +1060,7 @@ static const char * const one_byte_msgs[
 #define NO_ONE_BYTE_MSGS (sizeof(one_byte_msgs)  / sizeof (const char *))
 
 static const char * const two_byte_msgs[] = {
-/* 0x20 */ "Simple Queue Tag", "Head of Queue Tag", "Ordered Queue Tag"
+/* 0x20 */ "Simple Queue Tag", "Head of Queue Tag", "Ordered Queue Tag",
 /* 0x23 */ "Ignore Wide Residue"
 };
 #define NO_TWO_BYTE_MSGS (sizeof(two_byte_msgs)  / sizeof (const char *))
-- 
0.99.9.GIT

