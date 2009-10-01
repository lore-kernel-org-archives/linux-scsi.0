From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH 08/34] move initio_remove_one to .devexit.text
Date: Thu,  1 Oct 2009 10:28:12 +0200
Message-ID: <1254385718-14254-8-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20091001082607.GA2181@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932326AbZJAI34@vger.kernel.org>
In-Reply-To: <20091001082607.GA2181@pengutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Yang Hongyang <yanghy@cn.fujitsu.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Alan Cox <alan@redhat.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The function initio_remove_one is used only wrapped by __devexit_p so
define it using __devexit.

Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
Cc: Yang Hongyang <yanghy@cn.fujitsu.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@redhat.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/scsi/initio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 89a5948..8bbfd99 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -2964,7 +2964,7 @@ out_disable_device:
  *	finished being used.
  */
=20
-static void initio_remove_one(struct pci_dev *pdev)
+static void __devexit initio_remove_one(struct pci_dev *pdev)
 {
 	struct Scsi_Host *host =3D pci_get_drvdata(pdev);
 	struct initio_host *s =3D (struct initio_host *)host->hostdata;
--=20
1.6.4.3
