From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: [PATCH 2/2] scsi_dh_rdac : Consolidate rdac strings together
Date: Tue, 4 Sep 2012 17:05:15 +0000
Message-ID: <77471C95FAFD844C8CA02DD4F4C5FE2B0BCCAF1D@SACEXCMBX02-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:43020 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932415Ab2IDRFf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Sep 2012 13:05:35 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: "device-mapper development (dm-devel@redhat.com)" <dm-devel@redhat.com>

This patch consolidates the strings together. Purpose is to remove minor product strings extensions.
That way the future products with similar strings should not require change  here.

Signed-off-by: Babu Moger <babu.moger@netapp.com>
---
--- linux-3.6-rc1/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2012-09-04 12:01:15.000000000 -0500
+++ linux-3.6-rc1/drivers/scsi/device_handler/scsi_dh_rdac.c	2012-09-04 12:01:28.000000000 -0500
@@ -790,27 +790,16 @@ static const struct scsi_dh_devlist rdac
 	{"IBM", "1815"},
 	{"IBM", "1818"},
 	{"IBM", "3526"},
-	{"SGI", "TP9400"},
-	{"SGI", "TP9500"},
-	{"SGI", "TP9700"},
+	{"SGI", "TP9"},
 	{"SGI", "IS"},
 	{"STK", "OPENstorage D280"},
 	{"STK", "FLEXLINE 380"},
-	{"SUN", "CSM100_R_FC"},
-	{"SUN", "CSM200_R"},
-	{"SUN", "LCSM100_I"},
-	{"SUN", "LCSM100_S"},
-	{"SUN", "LCSM100_E"},
-	{"SUN", "LCSM100_F"},
+	{"SUN", "CSM"},
+	{"SUN", "LCSM100"},
 	{"SUN", "STK6580_6780"},
 	{"SUN", "SUN_6180"},
 	{"SUN", "ArrayStorage"},
-	{"DELL", "MD3000"},
-	{"DELL", "MD3000i"},
-	{"DELL", "MD32xx"},
-	{"DELL", "MD32xxi"},
-	{"DELL", "MD36xxi"},
-	{"DELL", "MD36xxf"},
+	{"DELL", "MD3"},
 	{"NETAPP", "INF-01-00"},
 	{"LSI", "INF-01-00"},
 	{"ENGENIO", "INF-01-00"},


