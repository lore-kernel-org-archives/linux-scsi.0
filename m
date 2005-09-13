From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 6/9] iscsi: add newline to sysfs output
Date: Mon, 12 Sep 2005 21:01:46 -0500
Message-ID: <1126576906.29245.26.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:19897 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932404AbVIMCCW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Sep 2005 22:02:22 -0400
Received: from max (c-24-118-218-223.hsd1.mn.comcast.net [24.118.218.223])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id j8D22Dmt010030
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 12 Sep 2005 21:02:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

from tomof@acm.org

trivial cleanup of show_transport_handle()

Signed-off-by: Alex Aizman <itn780@yahoo.com>
Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -97,7 +97,7 @@ static ssize_t
 show_transport_handle(struct class_device *cdev, char *buf)
 {
 	struct iscsi_internal *priv = cdev_to_iscsi_internal(cdev);
-	return sprintf(buf, "%llu", (unsigned long long)iscsi_handle(priv->iscsi_transport));
+	return sprintf(buf, "%llu\n", (unsigned long long)iscsi_handle(priv->iscsi_transport));
 }
 static CLASS_DEVICE_ATTR(handle, S_IRUGO, show_transport_handle, NULL);
 


