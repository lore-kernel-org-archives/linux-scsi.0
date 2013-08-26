From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH 3/5] scsi: Add missing newline to scsi_sysfs.c
Date: Mon, 26 Aug 2013 11:03:38 -0400
Message-ID: <1377529420-31775-4-git-send-email-emilne@redhat.com>
References: <1377529420-31775-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839Ab3HZPDm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Aug 2013 11:03:42 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r7QF3gYN002242
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 11:03:42 -0400
Received: from emilne.csb ([10.18.25.104])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r7QF3eJZ014378
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 11:03:42 -0400
In-Reply-To: <1377529420-31775-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

show_iostat_counterbits() is obviously missing a newline in
the function declaration.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_sysfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 04c2a27..7394a77 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -647,7 +647,8 @@ show_queue_type_field(struct device *dev, struct device_attribute *attr,
 static DEVICE_ATTR(queue_type, S_IRUGO, show_queue_type_field, NULL);
 
 static ssize_t
-show_iostat_counterbits(struct device *dev, struct device_attribute *attr, 				char *buf)
+show_iostat_counterbits(struct device *dev, struct device_attribute *attr,
+			char *buf)
 {
 	return snprintf(buf, 20, "%d\n", (int)sizeof(atomic_t) * 8);
 }
-- 
1.7.11.7

