From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH 07/38] move lasi700_driver_remove to .devexit.text
Date: Tue, 24 Nov 2009 22:07:02 +0100
Message-ID: <1259096853-18909-7-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1259096853-18909-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-2-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-3-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-4-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-5-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259096853-18909-6-git-send-email-u.kleine-koenig@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S934143AbZKXVJ4@vger.kernel.org>
In-Reply-To: <1259096853-18909-6-git-send-email-u.kleine-koenig@pengutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, "James E.J. Bottomley" <James.Bottomley@suse.de>, Yang Hongyang <yanghy@cn.fujitsu.com>, Kyle McMartin <kyle@mcmartin.ca>, Kay Sievers <kay.sievers@vrfy.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Helge Deller <deller@gmx.de>
List-Id: linux-scsi@vger.kernel.org

The function lasi700_driver_remove is used only wrapped by __devexit_p
so define it using __devexit.

Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
Cc: Yang Hongyang <yanghy@cn.fujitsu.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Helge Deller <deller@gmx.de>
---
 drivers/scsi/lasi700.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/lasi700.c b/drivers/scsi/lasi700.c
index b3d3131..a192914 100644
--- a/drivers/scsi/lasi700.c
+++ b/drivers/scsi/lasi700.c
@@ -147,7 +147,7 @@ lasi700_probe(struct parisc_device *dev)
 	return -ENODEV;
 }
=20
-static int __exit
+static int __devexit
 lasi700_driver_remove(struct parisc_device *dev)
 {
 	struct Scsi_Host *host =3D dev_get_drvdata(&dev->dev);
--=20
1.6.5.2
