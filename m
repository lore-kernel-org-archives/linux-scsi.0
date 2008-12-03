From: Bernd Schubert <bs@q-leap.de>
Subject: [PATCH 2/2] reset flag documentation
Date: Wed, 3 Dec 2008 13:35:30 +0100
Message-ID: <200812031335.30995.bs@q-leap.de>
References: <200812031329.06324.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.q-leap.de ([88.79.172.217]:45769 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbYLCMff (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2008 07:35:35 -0500
In-Reply-To: <200812031329.06324.bs@q-leap.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Sathya Prakash <Sathya.Prakash@lsi.com>, Eric Moore <Eric.Moore@lsi.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>

I was rather suprised when Sathya explained me the MPT_IOC_PRE_RESET has to
be done after the MUR command. Explain what MPT_IOC_PRE_RESET is actually
though to be for.

Signed-off-by: Bernd Schubert <bs@q-leap.de>

Index: linux-2.6/drivers/message/fusion/mptbase.h
===================================================================
--- linux-2.6.orig/drivers/message/fusion/mptbase.h
+++ linux-2.6/drivers/message/fusion/mptbase.h
@@ -735,8 +735,9 @@ typedef struct _MPT_ADAPTER
 typedef int (*MPT_CALLBACK)(MPT_ADAPTER *ioc, MPT_FRAME_HDR *req, MPT_FRAME_HDR *reply);
 typedef int (*MPT_EVHANDLER)(MPT_ADAPTER *ioc, EventNotificationReply_t *evReply);
 typedef int (*MPT_RESETHANDLER)(MPT_ADAPTER *ioc, int reset_phase);
-/* reset_phase defs */
-#define MPT_IOC_PRE_RESET		0
+
+/* reset_phase defs, see e.g. mptscsih_ioc_reset() about flag usage */
+#define MPT_IOC_PRE_RESET		0	/* clear pending requests */
 #define MPT_IOC_POST_RESET		1
 #define MPT_IOC_SETUP_RESET		2



-- 
Bernd Schubert
Q-Leap Networks GmbH
