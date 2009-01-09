From: "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Subject: RE: [PATCH 2/2 (resend) ] reset flag documentation
Date: Fri, 9 Jan 2009 13:38:12 +0530
Message-ID: <B73941C4DE6A3D4EA1AE128E9565E24423925BE6CF@inbmail01.lsi.com>
References: <200901071905.32280.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og108.obsmtp.com ([64.18.2.169]:57211 "EHLO
	exprod7og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbZAIIIc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jan 2009 03:08:32 -0500
In-Reply-To: <200901071905.32280.bs@q-leap.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bernd Schubert <bs@q-leap.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>

ACK

-----Original Message-----
From: Bernd Schubert [mailto:bs@q-leap.de]
Sent: Wednesday, January 07, 2009 11:36 PM
To: linux-scsi@vger.kernel.org
Cc: Prakash, Sathya; Moore, Eric; James Bottomley; DL-MPT Fusion Linux
Subject: [PATCH 2/2 (resend) ] reset flag documentation

Add documentation of a fusion MPT reset flag.

Signed-off-by: Bernd Schubert <bs@q-leap.de>

Index: linux-2.6/drivers/message/fusion/mptbase.h
===================================================================
--- linux-2.6.orig/drivers/message/fusion/mptbase.h
+++ linux-2.6/drivers/message/fusion/mptbase.h
@@ -735,8 +735,9 @@ typedef struct _MPT_ADAPTER  typedef int (*MPT_CALLBACK)(MPT_ADAPTER *ioc, MPT_FRAME_HDR *req, MPT_FRAME_HDR *reply);  typedef int (*MPT_EVHANDLER)(MPT_ADAPTER *ioc, EventNotificationReply_t *evReply);  typedef int (*MPT_RESETHANDLER)(MPT_ADAPTER *ioc, int reset_phase);
-/* reset_phase defs */
-#define MPT_IOC_PRE_RESET              0
+
+/* reset_phase defs, see e.g. mptscsih_ioc_reset() about flag usage */
+#define MPT_IOC_PRE_RESET              0       /* clear pending requests */
 #define MPT_IOC_POST_RESET             1
 #define MPT_IOC_SETUP_RESET            2




--
Bernd Schubert
Q-Leap Networks GmbH
