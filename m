From: Adrian Bunk <bunk@fs.tum.de>
Subject: [2.6 patch] remove obsolete comment from fusion Kconfig
Date: Wed, 21 Jan 2004 01:43:45 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040121004345.GK6441@fs.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hermes.fachschaften.tu-muenchen.de ([129.187.202.12]:8158 "HELO
	hermes.fachschaften.tu-muenchen.de") by vger.kernel.org with SMTP
	id S265892AbUAUAnu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jan 2004 19:43:50 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: mpt_linux_developer@lsil.com, Andrew Morton <akpm@osdl.org>, James.Bottomley@SteelEye.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

The patch below removes obsolete comments from the fusion Kconfig file 
that were left after the conversion to the new config system.

Please apply
Adrian

--- linux-2.6.1-mm5/drivers/message/fusion/Kconfig.old	2004-01-21 01:40:34.000000000 +0100
+++ linux-2.6.1-mm5/drivers/message/fusion/Kconfig	2004-01-21 01:40:44.000000000 +0100
@@ -138,11 +138,5 @@
 	  Support for building this feature into the linux kernel is not
 	  yet available.
 
-#  if [ "$CONFIG_FUSION_LAN" != "n" ]; then
-#    define_bool CONFIG_NET_FC y
-#  fi
-# These <should> be define_tristate, but we leave them define_bool
-# for backward compatibility with pre-linux-2.2.15 kernels.
-# (Bugzilla:fibrebugs, #384)
 endmenu
 
