From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: [PATCH v2] scsi_dh_rdac : Adding MODULE VERSION for rdac device
 handler
Date: Fri, 11 Feb 2011 16:12:44 -0700
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF4FF60C22E@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:41037 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758380Ab1BKXLo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Feb 2011 18:11:44 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>

Resubmitting again.
Adding MODULE_VERSION for scsi_dh_rdac. This will be helpful sometimes to get the code level without looking at the code. 
Original patch is here.. http://marc.info/?l=linux-scsi&m=128035804231431&w=2

Signed-off-by: Babu Moger <babu.moger@lsi.com>
---
--- linux-2.6.38-rc4-new/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2011-02-11 12:41:27.000000000 -0600
+++ linux-2.6.38-rc4-new/drivers/scsi/device_handler/scsi_dh_rdac.c	2011-02-11 16:48:11.000000000 -0600
@@ -906,4 +906,5 @@ module_exit(rdac_exit);
 
 MODULE_DESCRIPTION("Multipath LSI/Engenio RDAC driver");
 MODULE_AUTHOR("Mike Christie, Chandra Seetharaman");
+MODULE_VERSION("01.00.0000.0000");
 MODULE_LICENSE("GPL");


