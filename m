From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] scsi: st.c: fix kernel-doc mismatch
Date: Mon, 20 Nov 2017 18:25:08 -0800
Message-ID: <fa663a7f-8248-9562-dda7-8c54e13b5824@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:35500 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751305AbdKUCZM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Nov 2017 21:25:12 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

From: Randy Dunlap <rdunlap@infradead.org>

Fix kernel-doc function name and comments in st.c::read_ns_show():
change us to ns to match the function name.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 drivers/scsi/st.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-414.orig/drivers/scsi/st.c
+++ lnx-414/drivers/scsi/st.c
@@ -4712,7 +4712,7 @@ static ssize_t read_byte_cnt_show(struct
 static DEVICE_ATTR_RO(read_byte_cnt);
 
 /**
- * read_us_show - return read us - overall time spent waiting on reads in ns.
+ * read_ns_show - return read ns - overall time spent waiting on reads in ns.
  * @dev: struct device
  * @attr: attribute structure
  * @buf: buffer to return formatted data in
