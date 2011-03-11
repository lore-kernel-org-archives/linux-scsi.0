From: <Yanqing_Liu@Dell.com>
Subject: [patch] Add MD36xxf into RDAC device list
Date: Fri, 11 Mar 2011 09:47:11 -0600
Message-ID: <DB6E482E89290547898851B8CC9D81100161718E@AUSX7MCPS302.AMER.DELL.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:37067 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab1CKPrN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Mar 2011 10:47:13 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org
Cc: Amer_Hadba@Dell.com, Clayton_Walther@Dell.com, Joel_S@Dell.com, Sudhir.Dachepalli@lsi.com, Babu.Moger@lsi.com, Shyam_Iyer@Dell.com, Narayanan_D@Dell.com

Hi,

This patch is to add Dell MD36xxf array into the RDAC handler device list.

Thanks,
Yanqing


Singed-off-by Yanqing Liu <Yanqing_Liu@Dell.com>
---

--- drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2011-02-05 09:12:39.355376053 -0600
+++ drivers/scsi/device_handler/scsi_dh_rdac.c	2011-02-05 09:12:53.749455577 -0600
@@ -769,6 +769,7 @@
 	{"DELL", "MD32xx"},
 	{"DELL", "MD32xxi"},
 	{"DELL", "MD36xxi"},
+	{"DELL", "MD36xxf"},
 	{"LSI", "INF-01-00"},
 	{"ENGENIO", "INF-01-00"},
 	{"STK", "FLEXLINE 380"},

