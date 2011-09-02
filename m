From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: [RESEND][PATCH] scsi_dh_rdac: Adding couple more vendor product ids
Date: Fri, 2 Sep 2011 11:21:17 -0400
Message-ID: <47D23AD8469A2B448F33C24BD7A39BD90F6A83C4@RTPMVEXC1-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:5467 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509Ab1IBPVg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Sep 2011 11:21:36 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing list <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, device-mapper development <dm-devel@redhat.com>

This patch was not picked up yet. Resubmitting again on top of latest file.
Original patch is here http://marc.info/?l=dm-devel&m=130203604024614&w=2

This patch adds couple more Vendor/Product IDs for RDAC.. There are no functional changes.

Signed-off-by: Babu Moger <babu.moger@netapp.com>
---
--- linux-3.1-rc4/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2011-09-02 09:48:16.000000000 -0500
+++ linux-3.1-rc4/drivers/scsi/device_handler/scsi_dh_rdac.c	2011-09-02 09:49:24.000000000 -0500
@@ -796,6 +796,7 @@ static const struct scsi_dh_devlist rdac
 	{"IBM", "3526"},
 	{"SGI", "TP9400"},
 	{"SGI", "TP9500"},
+	{"SGI", "TP9700"},
 	{"SGI", "IS"},
 	{"STK", "OPENstorage D280"},
 	{"SUN", "CSM200_R"},
@@ -815,6 +816,7 @@ static const struct scsi_dh_devlist rdac
 	{"SUN", "CSM100_R_FC"},
 	{"SUN", "STK6580_6780"},
 	{"SUN", "SUN_6180"},
+	{"SUN", "ArrayStorage"},
 	{NULL, NULL},
 };
 


