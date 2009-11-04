From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: [PATCH] scsi_dh_rdac: Add two new IBM devices to rdac_dev_list
Date: Wed, 4 Nov 2009 12:36:16 -0700
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF48744CE36@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:39919 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757594AbZKDTgT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Nov 2009 14:36:19 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "sekharan@us.ibm.com" <sekharan@us.ibm.com>, "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>

This patch adds two new IBM storage devices which can use rdac device handlers.
Signed-off-by: Babu Moger <babu.moger@lsi.com>
---
--- linux-2.6.32-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2009-11-03 16:06:58.677451876 -0600
+++ linux-2.6.32-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c	2009-11-03 16:08:29.725570987 -0600
@@ -666,6 +666,8 @@ static const struct scsi_dh_devlist rdac
 	{"IBM", "1724"},
 	{"IBM", "1726"},
 	{"IBM", "1742"},
+	{"IBM", "1745"},
+	{"IBM", "1746"},
 	{"IBM", "1814"},
 	{"IBM", "1815"},
 	{"IBM", "1818"},


