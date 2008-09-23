From: Bernd Schubert <bs@q-leap.de>
Subject: [PATCH 4/4 ] Increase scsi timeouts
Date: Tue, 23 Sep 2008 15:28:58 +0200
Message-ID: <200809231528.59206.bs@q-leap.de>
References: <200809231516.48197.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.q-leap.de ([153.94.51.193]:50606 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947AbYIWN3E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Sep 2008 09:29:04 -0400
In-Reply-To: <200809231516.48197.bs@q-leap.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Eric Moore <Eric.Moore@lsi.com>, Sathya Prakash <Sathya.Prakash@lsi.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, DL-MPTFusionLinux@lsi.com

Increase scsi-timeouts, similariy to the LSI 4.x driver.

Signed-off-by: Bernd Schubert <bs@q-leap.de>

 drivers/message/fusion/mptscsih.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6.26/drivers/message/fusion/mptscsih.c
===================================================================
--- linux-2.6.26.orig/drivers/message/fusion/mptscsih.c
+++ linux-2.6.26/drivers/message/fusion/mptscsih.c
@@ -1760,10 +1760,9 @@ mptscsih_get_tm_timeout(MPT_ADAPTER *ioc
 	case FC:
 		return 40;
 	case SAS:
-		return 10;
 	case SPI:
 	default:
-		return 2;
+		return 10;
 	}
 }
 
