From: Krzysztof Wilczynski <krzysztof.wilczynski@linux.com>
Subject: [PATCH] scsi: Remove unused variable "*dev" from function mvs_task_exec.
Date: Tue, 24 Apr 2012 02:32:10 +0100
Message-ID: <1335231130-14747-1-git-send-email-krzysztof.wilczynski@linux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:52174 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792Ab2DXBcO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Apr 2012 21:32:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E . J . Bottomley" <JBottomley@parallels.com>
Cc: Jiri Kosina <trivial@kernel.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This is to address the following warning during compilation time:

  drivers/scsi/mvsas/mv_sas.c: In function =E2=80=98mvs_task_exec=E2=80=
=99:
  drivers/scsi/mvsas/mv_sas.c:888: warning: unused variable =E2=80=98de=
v=E2=80=99

This variable is indeed no longer in use (change can be traced back
to commit: 424a6f6ef990b7e9f56f6627bfc6c46b493faeb4).

Signed-off-by: Krzysztof Wilczynski <krzysztof.wilczynski@linux.com>
---
 drivers/scsi/mvsas/mv_sas.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index fd3b283..3006ec9 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -885,7 +885,6 @@ static int mvs_task_exec(struct sas_task *task, con=
st int num, gfp_t gfp_flags,
 				struct completion *completion, int is_tmf,
 				struct mvs_tmf_task *tmf)
 {
-	struct domain_device *dev =3D task->dev;
 	struct mvs_info *mvi =3D NULL;
 	u32 rc =3D 0;
 	u32 pass =3D 0;
--=20
1.7.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
