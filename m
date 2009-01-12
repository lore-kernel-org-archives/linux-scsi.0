From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH -next] scsi_debug: needs CRC_T10DIF
Date: Mon, 12 Jan 2009 10:53:04 -0800
Message-ID: <496B9190.5030503@oracle.com>
References: <20090112154539.4857f533.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20090112154539.4857f533.sfr@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, mkp@mkp.net
List-Id: linux-scsi@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix scsi_debug build error:

drivers/built-in.o: In function `resp_read':
scsi_debug.c:(.text+0x21379a): undefined reference to `crc_t10dif'
drivers/built-in.o: In function `resp_write':
scsi_debug.c:(.text+0x213fca): undefined reference to `crc_t10dif'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20090112.orig/drivers/scsi/Kconfig
+++ linux-next-20090112/drivers/scsi/Kconfig
@@ -1535,6 +1535,7 @@ config SCSI_NSP32
 config SCSI_DEBUG
 	tristate "SCSI debugging host simulator"
 	depends on SCSI
+	select CRC_T10DIF
 	help
 	  This is a host adapter simulator that can simulate multiple hosts
 	  each with multiple dummy SCSI devices (disks). It defaults to one
