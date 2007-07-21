From: David Miller <davem@davemloft.net>
Subject: [PATCH] (was Re: ESP SCSI and QLGC,ISP SCSI drivers not finding
 attached devices)
Date: Fri, 20 Jul 2007 17:32:45 -0700 (PDT)
Message-ID: <20070720.173245.74748233.davem@davemloft.net>
References: <Pine.LNX.4.61.0707201822250.8013@mtfhpc.demon.co.uk>
	<Pine.LNX.4.61.0707202101270.8250@mtfhpc.demon.co.uk>
	<20070720.153618.108742928.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <20070720.153618.108742928.davem@davemloft.net>
Sender: sparclinux-owner@vger.kernel.org
To: mark@mtfhpc.demon.co.uk
Cc: James.Bottomley@SteelEye.com, sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


James, can you queue this up to Linus?  Thanks a lot!

[SCSI] ESP: Increase ESP_BUS_TIMEOUT to 275.

This matches the original driver's value and seems to be
necessary for some disks on sun4c systems.

Reported by Mark Fortescue <mark@mtfhpc.demon.co.uk>

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/scsi/esp_scsi.h b/drivers/scsi/esp_scsi.h
index d5576d5..856e38b 100644
--- a/drivers/scsi/esp_scsi.h
+++ b/drivers/scsi/esp_scsi.h
@@ -220,7 +220,7 @@
 #define ESP_BUSID_RESELID     0x10
 #define ESP_BUSID_CTR32BIT    0x40
 
-#define ESP_BUS_TIMEOUT        250     /* In milli-seconds */
+#define ESP_BUS_TIMEOUT        275     /* In milli-seconds */
 #define ESP_TIMEO_CONST       8192
 #define ESP_NEG_DEFP(mhz, cfact) \
         ((ESP_BUS_TIMEOUT * ((mhz) / 1000)) / (8192 * (cfact)))
