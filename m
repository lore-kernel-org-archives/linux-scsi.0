From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [scsi 4/7 RESEND] scsi_debug: make dump_sector static
Date: Tue, 28 Jul 2015 16:54:23 +0300
Message-ID: <1438091666-18113-4-git-send-email-tomas.winkler@intel.com>
References: <1438091666-18113-1-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1438091666-18113-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
List-Id: linux-scsi@vger.kernel.org

fixes warning:
warning: no previous prototype for =E2=80=98dump_sector=E2=80=99

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index e2c509e39765..3a70683cf9f9 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2681,7 +2681,7 @@ resp_read_dt0(struct scsi_cmnd *scp, struct sdebu=
g_dev_info *devip)
 	return 0;
 }
=20
-void dump_sector(unsigned char *buf, int len)
+static void dump_sector(unsigned char *buf, int len)
 {
 	int i, j, n;
=20
--=20
2.4.3
