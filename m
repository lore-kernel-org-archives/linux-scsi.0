From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH] scsi_dh: add two SUN devices to the list of devices
	supported by default
Date: Wed, 12 Aug 2009 12:43:20 -0700
Message-ID: <1250106200.20492.4.camel@chandra-ubuntu>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:37462 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbZHLTjY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Aug 2009 15:39:24 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e38.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n7CJZjFw008307
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2009 13:35:45 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n7CJdCLd229612
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2009 13:39:15 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n7CJdCKH002442
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2009 13:39:12 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing list <linux-scsi@vger.kernel.org>, "rick.brown" <rick.brown@oit.gatech.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Moger, Babu" <Babu.Moger@lsi.com>

Hello all,

Yesterday, Rick has requested to add two of the sun devices to the list
of devices supported by scsi_dh_rdac by default.

This patch adds the support.

chandra
----------------------

Add two SUN devices to the devlist as requested in the mailing list.

Reported-by: Rice Brown <rick.brown@oit.gatech.edu>
Signed-Off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: Moger Babu <Babu.Moger@lsi.com>
---
 drivers/scsi/device_handler/scsi_dh_rdac.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.31-rc4/drivers/scsi/device_handler/scsi_dh_rdac.c
===================================================================
--- linux-2.6.31-rc4.orig/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ linux-2.6.31-rc4/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -633,6 +633,8 @@ static const struct scsi_dh_devlist rdac
 	{"DELL", "MD3000i"},
 	{"LSI", "INF-01-00"},
 	{"ENGENIO", "INF-01-00"},
+	{"STK", "FLEXLINE 380"},
+	{"SUN", "CSM100_R_FC"},
 	{NULL, NULL},
 };
 


