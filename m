From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH 27/34] move stex_remove to .devexit.text
Date: Thu,  1 Oct 2009 10:28:31 +0200
Message-ID: <1254385718-14254-27-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20091001082607.GA2181@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932265AbZJAI3e@vger.kernel.org>
In-Reply-To: <20091001082607.GA2181@pengutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>, Willem Riede <osst@riede.org>, "James E.J. Bottomley" <James.Bottomley@suse.de>, =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>, James Bottomley <James.Bottomley@HansenPartnership.com>, Ed Lin <ed.lin@promise.com>, Yang Hongyang <yanghy@cn.fujitsu.com>, linux-scsi@vger.kernel.org, osst-users@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

The function stex_remove is used only wrapped by __devexit_p so define
it using __devexit.

Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Willem Riede <osst@riede.org>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
Cc: "Kai M=C3=A4kisara" <Kai.Makisara@kolumbus.fi>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ed Lin <ed.lin@promise.com>
Cc: Yang Hongyang <yanghy@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org
Cc: osst-users@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
---
 drivers/scsi/stex.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 09fa886..09ee386 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -1679,7 +1679,7 @@ static void stex_hba_free(struct st_hba *hba)
 			  hba->dma_mem, hba->dma_handle);
 }
=20
-static void stex_remove(struct pci_dev *pdev)
+static void __devexit stex_remove(struct pci_dev *pdev)
 {
 	struct st_hba *hba =3D pci_get_drvdata(pdev);
=20
--=20
1.6.4.3
