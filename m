From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH 02/38] move atp870u_remove to .devexit.text
Date: Tue, 24 Nov 2009 22:06:57 +0100
Message-ID: <1259096853-18909-2-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1259096853-18909-1-git-send-email-u.kleine-koenig@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44652 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933998AbZKXVIb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2009 16:08:31 -0500
In-Reply-To: <1259096853-18909-1-git-send-email-u.kleine-koenig@pengutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, "James E.J. Bottomley" <James.Bottomley@suse.de>, Yang Hongyang <yanghy@cn.fujitsu.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Alan Cox <alan@linux.intel.com>, linux-scsi@vger.kernel.org, Alan Cox <alan@redhat.com>

The function atp870u_remove is used only wrapped by __devexit_p so defi=
ne
it using __devexit.

Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
Cc: Yang Hongyang <yanghy@cn.fujitsu.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@linux.intel.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@redhat.com>
---
 drivers/scsi/atp870u.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index b137e56..1059167 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -3143,7 +3143,7 @@ static int atp870u_biosparam(struct scsi_device *=
disk, struct block_device *dev,
 	return 0;
 }
=20
-static void atp870u_remove (struct pci_dev *pdev)
+static void __devexit atp870u_remove (struct pci_dev *pdev)
 {=09
 	struct atp_unit *devext =3D pci_get_drvdata(pdev);
 	struct Scsi_Host *pshost =3D devext->host;
--=20
1.6.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
