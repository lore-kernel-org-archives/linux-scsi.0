From: "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Subject: RE: [PATCH 4/4 ] Increase scsi timeouts
Date: Mon, 6 Oct 2008 17:07:25 +0800
Message-ID: <6A4D764DC1BDE14495DA8DC60A3D69531E967A0643@hkgmail01.lsi.com>
References: <200809231528.59206.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:47901 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025AbYJFJHd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Oct 2008 05:07:33 -0400
In-Reply-To: <200809231528.59206.bs@q-leap.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bernd Schubert <bs@q-leap.de>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>

ACK

-----Original Message-----
From: Bernd Schubert [mailto:bs@q-leap.de]
Sent: Tuesday, September 23, 2008 6:59 PM
To: Linux SCSI Mailing List
Cc: Moore, Eric; Prakash, Sathya; James Bottomley; DL-MPT Fusion Linux
Subject: [PATCH 4/4 ] Increase scsi timeouts

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
-               return 10;
        case SPI:
        default:
-               return 2;
+               return 10;
        }
 }

