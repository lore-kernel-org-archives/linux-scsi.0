From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH 18/38] move sgiwd93_remove to .devexit.text
Date: Tue, 24 Nov 2009 22:07:13 +0100
Message-ID: <1259096853-18909-18-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1259096853-18909-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-2-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-3-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-4-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-5-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-6-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-7-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-8-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-9-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-10-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-11-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-12-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-13-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-14-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-15-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-16-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-17-git-send-email-u.kleine-koenig@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44711 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934032AbZKXVIh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2009 16:08:37 -0500
In-Reply-To: <1259096853-18909-17-git-send-email-u.kleine-koenig@pengutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, "James E.J. Bottomley" <James.Bottomley@suse.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, Dmitri Vorobiev <dmitri.vorobiev@www.movial.com>, linux-scsi@vger.kernel.org

The function sgiwd93_remove is used only wrapped by __devexit_p so
define it using __devexit.

Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/scsi/sgiwd93.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sgiwd93.c b/drivers/scsi/sgiwd93.c
index 0807b26..4f33f7a 100644
--- a/drivers/scsi/sgiwd93.c
+++ b/drivers/scsi/sgiwd93.c
@@ -297,7 +297,7 @@ out:
 	return err;
 }
=20
-static int __exit sgiwd93_remove(struct platform_device *pdev)
+static int __devexit sgiwd93_remove(struct platform_device *pdev)
 {
 	struct Scsi_Host *host =3D platform_get_drvdata(pdev);
 	struct ip22_hostdata *hdata =3D (struct ip22_hostdata *) host->hostda=
ta;
--=20
1.6.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
