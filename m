From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 16/55] scsi: Mark function as static in cxgbi/libcxgbi.c
Date: Sat, 29 Mar 2014 23:30:59 +0530
Message-ID: <362da499bafb18e192a6d31a689f1b5aeddfbf5d.1396114898.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Rashika Kheria <rashika.kheria@gmail.com>, linux-scsi@vger.kernel.org, josh@joshtriplett.org
List-Id: linux-scsi@vger.kernel.org

Mark function as static in cxgbi/libcxgbi.c because it is not used
outside this file.

This eliminates the following warning in cxgbi/libcxgbi.c:
drivers/scsi/cxgbi/libcxgbi.c:1307:5: warning: no previous prototype fo=
r =E2=80=98cxgbi_ddp_reserve=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/cxgbi/libcxgbi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgb=
i.c
index b44c1cf..db6bf76 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -1304,7 +1304,7 @@ unmark_entries:
 	return err;
 }
=20
-int cxgbi_ddp_reserve(struct cxgbi_sock *csk, unsigned int *tagp,
+static int cxgbi_ddp_reserve(struct cxgbi_sock *csk, unsigned int *tag=
p,
 			unsigned int sw_tag, unsigned int xferlen,
 			struct scatterlist *sgl, unsigned int sgcnt, gfp_t gfp)
 {
--=20
1.7.9.5
