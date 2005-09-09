From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [PATCH 2.6.13 17/20] aic94xx: aic94xx_seq.h Sequencer interface header
 file
Date: Fri, 09 Sep 2005 15:36:36 -0400
Message-ID: <4321E444.2010606@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:50885 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1030361AbVIITgm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Sep 2005 15:36:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Signed-off-by: Luben Tuikov <luben_tuikov@adaptec.com>

diff -X linux-2.6.13/Documentation/dontdiff -Naur linux-2.6.13-orig/drivers/scsi/aic94xx/aic94xx_seq.h linux-2.6.13/drivers/scsi/aic94xx/aic94xx_seq.h
--- linux-2.6.13-orig/drivers/scsi/aic94xx/aic94xx_seq.h	1969-12-31 19:00:00.000000000 -0500
+++ linux-2.6.13/drivers/scsi/aic94xx/aic94xx_seq.h	2005-09-09 11:21:23.000000000 -0400
@@ -0,0 +1,42 @@
+/*
+ * Aic94xx SAS/SATA driver sequencer interface header file.
+ *
+ * Copyright (C) 2005 Adaptec, Inc.  All rights reserved.
+ * Copyright (C) 2005 Luben Tuikov <luben_tuikov@adaptec.com>
+ *
+ * This file is licensed under GPLv2.
+ * 
+ * This file is part of the aic94xx driver.
+ *
+ * The aic94xx driver is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; version 2 of the
+ * License.
+ *
+ * The aic94xx driver is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with the aic94xx driver; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * $Id: //depot/aic94xx/aic94xx_seq.h#6 $
+ */
+
+#ifndef _AIC94XX_SEQ_H_
+#define _AIC94XX_SEQ_H_
+
+int asd_pause_cseq(struct asd_ha_struct *asd_ha);
+int asd_unpause_cseq(struct asd_ha_struct *asd_ha);
+int asd_pause_lseq(struct asd_ha_struct *asd_ha, u8 lseq_mask);
+int asd_unpause_lseq(struct asd_ha_struct *asd_ha, u8 lseq_mask);
+int asd_init_seqs(struct asd_ha_struct *asd_ha);
+int asd_start_seqs(struct asd_ha_struct *asd_ha);
+
+void asd_update_port_links(struct sas_phy *phy);
+
+#endif


