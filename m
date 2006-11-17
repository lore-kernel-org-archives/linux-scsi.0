From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 06/15] sas_ata: Require CONFIG_ATA in Kconfig
Date: Fri, 17 Nov 2006 13:07:59 -0800
Message-ID: <20061117210759.17052.27132.stgit@localhost.localdomain>
References: <20061117210737.17052.67041.stgit@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933633AbWKQVEJ@vger.kernel.org>
In-Reply-To: <20061117210737.17052.67041.stgit@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: alexisb@us.ibm.com
List-Id: linux-scsi@vger.kernel.org




Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/libsas/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libsas/Kconfig b/drivers/scsi/libsas/Kconfig
index aafdc92..b64e391 100644
--- a/drivers/scsi/libsas/Kconfig
+++ b/drivers/scsi/libsas/Kconfig
@@ -24,7 +24,7 @@ #
 
 config SCSI_SAS_LIBSAS
 	tristate "SAS Domain Transport Attributes"
-	depends on SCSI
+	depends on SCSI && ATA
 	select SCSI_SAS_ATTRS
 	help
 	  This provides transport specific helpers for SAS drivers which
