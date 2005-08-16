From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] add missing attribute container function prototype
Date: Tue, 16 Aug 2005 17:26:10 -0500
Message-ID: <1124231170.5093.16.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:9695 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750700AbVHPW0M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Aug 2005 18:26:12 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id j7GMQAA17604
	for <linux-scsi@vger.kernel.org>; Tue, 16 Aug 2005 18:26:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

attribute_container_classdev_to_container is an exported function of the
attribute_container.c file.  However, there's no prototype for it.  Now
I actually want to use it, so add one.

James

diff --git a/include/linux/attribute_container.h b/include/linux/attribute_container.h
--- a/include/linux/attribute_container.h
+++ b/include/linux/attribute_container.h
@@ -64,6 +64,7 @@ int attribute_container_add_class_device
 						 struct class_device *classdev);
 void attribute_container_remove_attrs(struct class_device *classdev);
 void attribute_container_class_device_del(struct class_device *classdev);
+struct attribute_container *attribute_container_classdev_to_container(struct class_device *);
 struct class_device *attribute_container_find_class_device(struct attribute_container *, struct device *);
 struct class_device_attribute **attribute_container_classdev_to_attrs(const struct class_device *classdev);
 


