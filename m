Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5438FE
	for <linux-scsi@vger.kernel.org>; Sun,  3 Dec 2023 08:06:19 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1r9oz0-0005gf-Fr; Sun, 03 Dec 2023 17:06:14 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1r9oyz-00DK9Y-4E; Sun, 03 Dec 2023 17:06:13 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1r9oyy-00DPoV-R9; Sun, 03 Dec 2023 17:06:12 +0100
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: "James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Finn Thain <fthain@linux-m68k.org>,
	Michael Schmitz <schmitzmic@gmail.com>,
	kernel@pengutronix.de
Subject: [PATCH 00/14] scsci: Convert to platform remove callback returning void
Date: Sun,  3 Dec 2023 17:05:45 +0100
Message-ID: <cover.1701619134.git.u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2063; i=u.kleine-koenig@pengutronix.de; h=from:subject:message-id; bh=iubrYeMiuZQvnPp7zpziUnn3i98Bk0McvVTNOciwiDw=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlbKdYbRdywXdVYvlAEUzj4+r66wHoxwsz9keeH nT087Ws8faJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZWynWAAKCRCPgPtYfRL+ TkoXCACgoounhc9N3LsZxym5HA9IuV4cdHixHmrH04hKUMRy01ZWiUT/hf4VLFGVDtjT1HPEkVg aHxG21+GJdBjzLvdYuHTYwEwhd1Ec6RPhS6Zs2GbL8SUbvWywzKAaH/PbIHwdqzgR3fDEKcaCgA eRBthZBuPsVzAEyafpNZ+8l1BddLBb0P+Hif/RTeL9Y+FLM7QCJWBwHtGG/WuAX7pTZ2ANLtaqz wO3mhKuWte2NUb9IPgtbsJPxJ+M/+cX5poD0N9T0Ypo4rVRvfagS+PepNNtmNdLdiCTMlUwuV4x eEviGVjQ6Vsih4CD+D1l/rqCG4cBmVqlU/lQ2EkU5q3VjAGj
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-scsi@vger.kernel.org

Hello,

this series converts all drivers below drivers/scsi to struct
platform_driver::remove_new(). See commit 5c5a7680e67b ("platform:
Provide a remove callback that returns no value") for an extended
explanation and the eventual goal.

All conversations are trivial, because all .remove() callbacks returned
zero unconditionally.

Best regards
Uwe

Uwe Kleine-König (14):
  scsi: a3000: Convert to platform remove callback returning void
  scsi: a4000t: Convert to platform remove callback returning void
  scsi: atari: Convert to platform remove callback returning void
  scsi: bvme6000: Convert to platform remove callback returning void
  scsi: jazz_esp: Convert to platform remove callback returning void
  scsi: mac_esp: Convert to platform remove callback returning void
  scsi: mac: Convert to platform remove callback returning void
  scsi: mvme16x: Convert to platform remove callback returning void
  scsi: qlogicpti: Convert to platform remove callback returning void
  scsi: sgiwd93: Convert to platform remove callback returning void
  scsi: sni_53c710: Convert to platform remove callback returning void
  scsi: sun3: Convert to platform remove callback returning void
  scsi: sun3x_esp: Convert to platform remove callback returning void
  scsi: sun_esp: Convert to platform remove callback returning void

 drivers/scsi/a3000.c         | 5 ++---
 drivers/scsi/a4000t.c        | 5 ++---
 drivers/scsi/atari_scsi.c    | 5 ++---
 drivers/scsi/bvme6000_scsi.c | 6 ++----
 drivers/scsi/jazz_esp.c      | 6 ++----
 drivers/scsi/mac_esp.c       | 6 ++----
 drivers/scsi/mac_scsi.c      | 5 ++---
 drivers/scsi/mvme16x_scsi.c  | 6 ++----
 drivers/scsi/qlogicpti.c     | 6 ++----
 drivers/scsi/sgiwd93.c       | 5 ++---
 drivers/scsi/sni_53c710.c    | 6 ++----
 drivers/scsi/sun3_scsi.c     | 5 ++---
 drivers/scsi/sun3x_esp.c     | 6 ++----
 drivers/scsi/sun_esp.c       | 6 ++----
 14 files changed, 28 insertions(+), 50 deletions(-)


base-commit: 5eda217cee887e595ba2265435862d585d399769
-- 
2.42.0

