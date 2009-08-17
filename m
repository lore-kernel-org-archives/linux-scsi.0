From: <Yanqing_Liu@Dell.com>
Subject: [PATCH] add support for next generation of Dell PV array
Date: Mon, 17 Aug 2009 14:31:42 -0500
Message-ID: <D00AA2C108EC0346B503219C7565A66F9E2969@ausx3mpc138.aus.amer.dell.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:13463 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902AbZHQTbn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Aug 2009 15:31:43 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, dm-devel@redhat.com

Hello,


This patch is to add DM support for next generation of Dell PowerVault
storage array.


Signed-off-by: Yanqing Liu <Yanqing_Liu@Dell.com>

--- linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c.orig
2009-08-05 16:30:51.000000000 -0500
+++ linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c
2009-08-05 16:34:00.000000000 -0500
@@ -631,6 +631,8 @@ static const struct scsi_dh_devlist rdac
 	{"SUN", "LCSM100_F"},
 	{"DELL", "MD3000"},
 	{"DELL", "MD3000i"},
+	{"DELL", "MD32xx"},
+	{"DELL", "MD32xxi"},
 	{"LSI", "INF-01-00"},
 	{"ENGENIO", "INF-01-00"},
 	{NULL, NULL},

Thanks,
Yanqing
