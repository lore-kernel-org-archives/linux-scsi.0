From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH] - export spi_dv_pending
Date: Mon, 29 Jan 2007 09:41:12 -0700
Message-ID: <20070129164111.GA1873@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:60413 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbXA2Qkh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Jan 2007 11:40:37 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

export define to be used in 3rd fusion patch

Signed-off-by: Eric Moore <Eric.Moore@lsi.com>

diff -uarpN b/drivers/scsi/scsi_transport_spi.c a/drivers/scsi/scsi_transport_spi.c
--- b/drivers/scsi/scsi_transport_spi.c	2007-01-24 19:19:28.000000000 -0700
+++ a/drivers/scsi/scsi_transport_spi.c	2007-01-28 12:39:38.000000000 -0700
@@ -46,7 +46,6 @@
 				 * two cc/ua clears */
 
 /* Private data accessors (keep these out of the header file) */
-#define spi_dv_pending(x) (((struct spi_transport_attrs *)&(x)->starget_data)->dv_pending)
 #define spi_dv_in_progress(x) (((struct spi_transport_attrs *)&(x)->starget_data)->dv_in_progress)
 #define spi_dv_mutex(x) (((struct spi_transport_attrs *)&(x)->starget_data)->dv_mutex)
 
diff -uarpN b/include/scsi/scsi_transport_spi.h a/include/scsi/scsi_transport_spi.h
--- b/include/scsi/scsi_transport_spi.h	2007-01-24 19:19:28.000000000 -0700
+++ a/include/scsi/scsi_transport_spi.h	2007-01-28 12:39:31.000000000 -0700
@@ -85,6 +85,7 @@ struct spi_host_attrs {
 #define spi_pcomp_en(x)	(((struct spi_transport_attrs *)&(x)->starget_data)->pcomp_en)
 #define spi_hold_mcs(x)	(((struct spi_transport_attrs *)&(x)->starget_data)->hold_mcs)
 #define spi_initial_dv(x)	(((struct spi_transport_attrs *)&(x)->starget_data)->initial_dv)
+#define spi_dv_pending(x) (((struct spi_transport_attrs *)&(x)->starget_data)->dv_pending)
 
 #define spi_support_sync(x)	(((struct spi_transport_attrs *)&(x)->starget_data)->support_sync)
 #define spi_support_wide(x)	(((struct spi_transport_attrs *)&(x)->starget_data)->support_wide)
