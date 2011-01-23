From: Fubo Chen <fubo.chen@gmail.com>
Subject: [PATCH] Make sure sense_valid() makes sense
Date: Sun, 23 Jan 2011 17:59:01 +0100
Message-ID: <AANLkTi=-tBfUHQfpLupid_fs_wXgG7rBQO4PhxQAVkpW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37073 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab1AWQ7D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Jan 2011 11:59:03 -0500
Received: by iyj18 with SMTP id 18so3249706iyj.19
        for <linux-scsi@vger.kernel.org>; Sun, 23 Jan 2011 08:59:02 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Signed-off-by: Fubo Chen <fubo.chen@gmail.com>

diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 648d233..4a37b8a 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -489,7 +489,7 @@ static inline int scsi_is_wlun(unsigned int lun)

 #define sense_class(sense)  (((sense) >> 4) & 0x7)
 #define sense_error(sense)  ((sense) & 0xf)
-#define sense_valid(sense)  ((sense) & 0x80);
+#define sense_valid(sense)  ((sense) & 0x80)

 /*
  * default timeouts
