From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] PATCH 2.5: kconfig missing EXPERIMENTAL 2 (1_7)
Date: Wed, 07 Aug 2002 14:05:20 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020807043058.215804B60@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Marcelo Tosatti <marcelo@conectiva.com.br>
Cc: linux-scsi@vger.kernel.org

From:  Greg Banks <gnb@alphalink.com.au>

(Included in 2.5)
  
  Three symbols CONFIG_SCSI_CUMANA_1, CONFIG_SCSI_ECOSCSI, and CONFIG_SCSI_OAK1
  depend on CONFIG_EXPERIMENTAL but do not say so in their banners.
  

--- trivial-2.4.20-pre1/drivers/acorn/scsi/Config.in.orig	2002-08-07 10:57:30.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/acorn/scsi/Config.in	2002-08-07 10:57:30.000000000 +1000
@@ -14,10 +14,10 @@
 if [ "$CONFIG_EXPERIMENTAL" = "y" ]; then
    comment 'The following drivers are not fully supported'
 
-   dep_tristate 'CumanaSCSI I support' CONFIG_SCSI_CUMANA_1 $CONFIG_SCSI
+   dep_tristate 'CumanaSCSI I support (EXPERIMENTAL)' CONFIG_SCSI_CUMANA_1 $CONFIG_SCSI
    if [ "$CONFIG_ARCH_ARC" = "y" -o "$CONFIG_ARCH_A5K" = "y" ]; then
-      dep_tristate 'EcoScsi support' CONFIG_SCSI_ECOSCSI $CONFIG_SCSI
+      dep_tristate 'EcoScsi support (EXPERIMENTAL)' CONFIG_SCSI_ECOSCSI $CONFIG_SCSI
    fi
-   dep_tristate 'Oak SCSI support' CONFIG_SCSI_OAK1 $CONFIG_SCSI
+   dep_tristate 'Oak SCSI support (EXPERIMENTAL)' CONFIG_SCSI_OAK1 $CONFIG_SCSI
 fi
 
-- 
  Don't blame me: the Monkey is driving
