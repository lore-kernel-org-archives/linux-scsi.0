From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH v3 4/4] Documentation: add WRITE_CACHE flag in usb storage quirk.
Date: Sat,  9 Jun 2012 13:41:37 -0400
Message-ID: <1339263697-4111-1-git-send-email-linkinjeon@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, gregkh@linuxfoundation.org, mdharm-usb@one-eyed-alien.net, stern@rowland.harvard.edu, sshtylyov@mvista.com, bvanassche@acm.org
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>
List-Id: linux-scsi@vger.kernel.org

Add WRITE_CACHE flag in usb storage quirk.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
---
 Documentation/kernel-parameters.txt |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 86bdca9..2f88c9c 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2939,6 +2939,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 					initial READ(10) command);
 				o = CAPACITY_OK (accept the capacity
 					reported by the device);
+				p = WRITE_CACHE (the device cache is ON
+					by default);
 				r = IGNORE_RESIDUE (the device reports
 					bogus residue values);
 				s = SINGLE_LUN (the device has only one
-- 
1.7.9.5
