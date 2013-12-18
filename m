From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 2/4] drivers: target: Mark function as static in
 target_core_iblock.c
Date: Wed, 18 Dec 2013 23:56:44 +0530
Message-ID: <bf4be9c01bc63fc3092132de26196a5a0ed8857d.1387390091.git.rashika.kheria@gmail.com>
References: <1a63603bc5ff05147c419a301d59b135cd0c8406.1387390091.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1a63603bc5ff05147c419a301d59b135cd0c8406.1387390091.git.rashika.kheria@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, josh@joshtriplett.org
List-Id: linux-scsi@vger.kernel.org

Mark function iblock_get_write_cache() as static in target_core_iblock.=
c
because it is not used outside this file.

This eliminates the following warning in target_core_iblock.c:
drivers/target/target_core_iblock.c:766:6: warning: no previous prototy=
pe for =E2=80=98iblock_get_write_cache=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 drivers/target/target_core_iblock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/targe=
t_core_iblock.c
index c87959f..15d9121 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -763,7 +763,7 @@ iblock_parse_cdb(struct se_cmd *cmd)
 	return sbc_parse_cdb(cmd, &iblock_sbc_ops);
 }
=20
-bool iblock_get_write_cache(struct se_device *dev)
+static bool iblock_get_write_cache(struct se_device *dev)
 {
 	struct iblock_dev *ib_dev =3D IBLOCK_DEV(dev);
 	struct block_device *bd =3D ib_dev->ibd_bd;
--=20
1.7.9.5
