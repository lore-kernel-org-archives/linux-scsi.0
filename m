From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 54/55] scsi: Add prototype declaration to header file
 ufs/ufshcd.h
Date: Sun, 30 Mar 2014 00:20:39 +0530
Message-ID: <851b8b92b988e363d8aec2ef4b0332609c10cfc0.1396114898.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Y <santoshsy@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, josh@joshtriplett.org
List-Id: linux-scsi@vger.kernel.org

Add prototype declaration of functions to header file ufs/ufshcd.h
because they are used by more than one file.

This eliminates the following warning in ufs/ufshcd.h:
drivers/scsi/ufs/ufshcd.c:2769:5: warning: no previous prototype for =E2=
=80=98ufshcd_suspend=E2=80=99 [-Wmissing-prototypes]
drivers/scsi/ufs/ufshcd.c:2790:5: warning: no previous prototype for =E2=
=80=98ufshcd_resume=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/ufs/ufshcd.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 577679a..9a920c3 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -317,4 +317,6 @@ static inline int ufshcd_dme_peer_get(struct ufs_hb=
a *hba,
 	return ufshcd_dme_get_attr(hba, attr_sel, mib_val, DME_PEER);
 }
=20
+int ufshcd_suspend(struct ufs_hba *hba, pm_message_t state);
+int ufshcd_resume(struct ufs_hba *hba);
 #endif /* End of Header */
--=20
1.7.9.5
