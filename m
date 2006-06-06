From: Alexis Bruemmer <alexisb@us.ibm.com>
Subject: [PATCH 3/7] aic94xx: sas remove depot's
Date: Tue, 06 Jun 2006 16:46:30 -0700
Message-ID: <1149637590.25278.71.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:63968 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751368AbWFFXqr
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Jun 2006 19:46:47 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e31.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k56Nkkbv019053
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jun 2006 19:46:46 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by westrelay02.boulder.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k56NkhBf063196
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jun 2006 17:46:43 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k56Nkksr006662
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jun 2006 17:46:46 -0600
Received: from alexis.beaverton.ibm.com (alexis.beaverton.ibm.com [9.47.17.62])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k56NkjxB006635
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jun 2006 17:46:45 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Remove the //depot SCM comments

Signed-off-by: Alexis Bruemmer <alexisb@us.ibm.com>

---
Index: linux-2.6.17-rc5/drivers/scsi/sas/sas_discover.c
===================================================================
--- linux-2.6.17-rc5.orig/drivers/scsi/sas/sas_discover.c	2006-06-05 13:05:55.000000000 -0700
+++ linux-2.6.17-rc5/drivers/scsi/sas/sas_discover.c	2006-06-05 13:12:57.000000000 -0700
@@ -20,7 +20,6 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  *
- * $Id: //depot/sas-class/sas_discover.c#140 $
  */
 
 #include <linux/pci.h>
Index: linux-2.6.17-rc5/drivers/scsi/sas/sas_dump.c
===================================================================
--- linux-2.6.17-rc5.orig/drivers/scsi/sas/sas_dump.c	2006-06-05 12:39:31.000000000 -0700
+++ linux-2.6.17-rc5/drivers/scsi/sas/sas_dump.c	2006-06-05 13:12:57.000000000 -0700
@@ -20,7 +20,6 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  *
- * $Id: //depot/sas-class/sas_dump.c#4 $
  */
 
 #include "sas_dump.h"
Index: linux-2.6.17-rc5/drivers/scsi/sas/sas_dump.h
===================================================================
--- linux-2.6.17-rc5.orig/drivers/scsi/sas/sas_dump.h	2006-06-05 12:37:09.000000000 -0700
+++ linux-2.6.17-rc5/drivers/scsi/sas/sas_dump.h	2006-06-05 13:12:57.000000000 -0700
@@ -20,7 +20,6 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  *
- * $Id: //depot/sas-class/sas_dump.h#2 $
  */
 
 #include "sas_internal.h"
Index: linux-2.6.17-rc5/drivers/scsi/sas/sas_event.c
===================================================================
--- linux-2.6.17-rc5.orig/drivers/scsi/sas/sas_event.c	2006-06-05 13:03:12.000000000 -0700
+++ linux-2.6.17-rc5/drivers/scsi/sas/sas_event.c	2006-06-05 13:12:57.000000000 -0700
@@ -20,7 +20,6 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  *
- * $Id: //depot/sas-class/sas_event.c#26 $
  */
 
 /**
Index: linux-2.6.17-rc5/drivers/scsi/sas/sas_expander.c
===================================================================
--- linux-2.6.17-rc5.orig/drivers/scsi/sas/sas_expander.c	2006-06-05 13:03:25.000000000 -0700
+++ linux-2.6.17-rc5/drivers/scsi/sas/sas_expander.c	2006-06-05 13:12:57.000000000 -0700
@@ -20,7 +20,6 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  *
- * $Id: //depot/sas-class/sas_expander.c#60 $
  */
 
 #include <linux/pci.h>
Index: linux-2.6.17-rc5/drivers/scsi/sas/sas_init.c
===================================================================
--- linux-2.6.17-rc5.orig/drivers/scsi/sas/sas_init.c	2006-06-05 13:02:01.000000000 -0700
+++ linux-2.6.17-rc5/drivers/scsi/sas/sas_init.c	2006-06-05 13:12:57.000000000 -0700
@@ -21,7 +21,6 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
  * USA
  *
- * $Id: //depot/sas-class/sas_init.c#45 $
  */
 
 #include <linux/module.h>
Index: linux-2.6.17-rc5/drivers/scsi/sas/sas_internal.h
===================================================================
--- linux-2.6.17-rc5.orig/drivers/scsi/sas/sas_internal.h	2006-06-05 13:02:14.000000000 -0700
+++ linux-2.6.17-rc5/drivers/scsi/sas/sas_internal.h	2006-06-05 13:12:57.000000000 -0700
@@ -21,7 +21,6 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
  * USA
  *
- * $Id: //depot/sas-class/sas_internal.h#35 $
  */
 
 #ifndef _SAS_INTERNAL_H_
Index: linux-2.6.17-rc5/drivers/scsi/sas/sas_phy.c
===================================================================
--- linux-2.6.17-rc5.orig/drivers/scsi/sas/sas_phy.c	2006-06-05 12:41:58.000000000 -0700
+++ linux-2.6.17-rc5/drivers/scsi/sas/sas_phy.c	2006-06-05 13:12:57.000000000 -0700
@@ -20,7 +20,6 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  *
- * $Id: //depot/sas-class/sas_phy.c#38 $
  */
 
 #include "sas_internal.h"
Index: linux-2.6.17-rc5/drivers/scsi/sas/sas_port.c
===================================================================
--- linux-2.6.17-rc5.orig/drivers/scsi/sas/sas_port.c	2006-06-05 13:02:28.000000000 -0700
+++ linux-2.6.17-rc5/drivers/scsi/sas/sas_port.c	2006-06-05 13:12:57.000000000 -0700
@@ -20,7 +20,6 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  *
- * $Id: //depot/sas-class/sas_port.c#44 $
  */
 
 #include "sas_internal.h"
Index: linux-2.6.17-rc5/drivers/scsi/sas/sas_scsi_host.c
===================================================================
--- linux-2.6.17-rc5.orig/drivers/scsi/sas/sas_scsi_host.c	2006-06-05 13:02:42.000000000 -0700
+++ linux-2.6.17-rc5/drivers/scsi/sas/sas_scsi_host.c	2006-06-05 13:12:57.000000000 -0700
@@ -21,7 +21,6 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
  * USA
  *
- * $Id: //depot/sas-class/sas_scsi_host.c#60 $
  */
 
 #include "sas_internal.h"
Index: linux-2.6.17-rc5/drivers/scsi/sas/Kconfig
===================================================================
--- linux-2.6.17-rc5.orig/drivers/scsi/sas/Kconfig	2006-06-05 12:37:09.000000000 -0700
+++ linux-2.6.17-rc5/drivers/scsi/sas/Kconfig	2006-06-05 13:12:57.000000000 -0700
@@ -21,8 +21,6 @@
 # Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
 # USA
 #
-# $Id: //depot/sas-class/Kconfig#6 $
-#
 
 config SCSI_SAS_DOMAIN_ATTRS
 	tristate "SAS Domain Transport Attributes"
Index: linux-2.6.17-rc5/drivers/scsi/aic94xx/Kconfig
===================================================================
--- linux-2.6.17-rc5.orig/drivers/scsi/aic94xx/Kconfig	2006-06-05 12:34:52.000000000 -0700
+++ linux-2.6.17-rc5/drivers/scsi/aic94xx/Kconfig	2006-06-05 13:15:49.000000000 -0700
@@ -22,7 +22,6 @@
 # along with Aic94xx Driver; if not, write to the Free Software
 # Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #
-# $Id: //depot/aic94xx/Kconfig#9 $
 #
 
 config SCSI_AIC94XX
Index: linux-2.6.17-rc5/drivers/scsi/aic94xx/aic94xx_dump.c
===================================================================
--- linux-2.6.17-rc5.orig/drivers/scsi/aic94xx/aic94xx_dump.c	2006-06-05 12:34:52.000000000 -0700
+++ linux-2.6.17-rc5/drivers/scsi/aic94xx/aic94xx_dump.c	2006-06-05 13:16:08.000000000 -0700
@@ -27,7 +27,6 @@
  * locations, names, etc.  Make use of macros.  Print more information.
  * Print all cseq and lseq mip and mdp.
  *
- * $Id: //depot/aic94xx/aic94xx_dump.c#29 $
  */
 
 #include "linux/pci.h"
Index: linux-2.6.17-rc5/drivers/scsi/aic94xx/aic94xx_dump.h
===================================================================
--- linux-2.6.17-rc5.orig/drivers/scsi/aic94xx/aic94xx_dump.h	2006-06-05 12:34:52.000000000 -0700
+++ linux-2.6.17-rc5/drivers/scsi/aic94xx/aic94xx_dump.h	2006-06-05 13:16:17.000000000 -0700
@@ -22,7 +22,6 @@
  * along with the aic94xx driver; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  *
- * $Id: //depot/aic94xx/aic94xx_dump.h#10 $
  */
 
 #ifndef _AIC94XX_DUMP_H_
Index: linux-2.6.17-rc5/drivers/scsi/aic94xx/aic94xx_hwi.c
===================================================================
--- linux-2.6.17-rc5.orig/drivers/scsi/aic94xx/aic94xx_hwi.c	2006-06-05 12:59:01.000000000 -0700
+++ linux-2.6.17-rc5/drivers/scsi/aic94xx/aic94xx_hwi.c	2006-06-05 13:16:30.000000000 -0700
@@ -22,7 +22,6 @@
  * along with the aic94xx driver; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  *
- * $Id: //depot/aic94xx/aic94xx_hwi.c#107 $
  */
 
 #include <linux/pci.h>
Index: linux-2.6.17-rc5/drivers/scsi/aic94xx/aic94xx_hwi.h
===================================================================
--- linux-2.6.17-rc5.orig/drivers/scsi/aic94xx/aic94xx_hwi.h	2006-06-05 12:58:51.000000000 -0700
+++ linux-2.6.17-rc5/drivers/scsi/aic94xx/aic94xx_hwi.h	2006-06-05 13:16:39.000000000 -0700
@@ -22,7 +22,6 @@
  * along with the aic94xx driver; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  *
- * $Id: //depot/aic94xx/aic94xx_hwi.h#74 $
  */
 
 #ifndef _AIC94XX_HWI_H_
Index: linux-2.6.17-rc5/drivers/scsi/aic94xx/aic94xx_init.c
===================================================================
--- linux-2.6.17-rc5.orig/drivers/scsi/aic94xx/aic94xx_init.c	2006-06-05 12:34:52.000000000 -0700
+++ linux-2.6.17-rc5/drivers/scsi/aic94xx/aic94xx_init.c	2006-06-05 13:16:49.000000000 -0700
@@ -22,7 +22,6 @@
  * along with the aic94xx driver; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  *
- * $Id: //depot/aic94xx/aic94xx_init.c#99 $
  */
 
 #include <linux/config.h>
Index: linux-2.6.17-rc5/drivers/scsi/aic94xx/aic94xx_reg.c
===================================================================
--- linux-2.6.17-rc5.orig/drivers/scsi/aic94xx/aic94xx_reg.c	2006-06-05 12:34:52.000000000 -0700
+++ linux-2.6.17-rc5/drivers/scsi/aic94xx/aic94xx_reg.c	2006-06-05 13:17:02.000000000 -0700
@@ -22,7 +22,6 @@
  * along with the aic94xx driver; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  *
- * $Id: //depot/aic94xx/aic94xx_reg.c#14 $
  */
 
 #include <linux/pci.h>
Index: linux-2.6.17-rc5/drivers/scsi/aic94xx/aic94xx_reg.h
===================================================================
--- linux-2.6.17-rc5.orig/drivers/scsi/aic94xx/aic94xx_reg.h	2006-06-05 12:34:52.000000000 -0700
+++ linux-2.6.17-rc5/drivers/scsi/aic94xx/aic94xx_reg.h	2006-06-05 13:17:14.000000000 -0700
@@ -22,7 +22,6 @@
  * along with the aic94xx driver; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  *
- * $Id: //depot/aic94xx/aic94xx_reg.h#19 $
  */
 
 #ifndef _AIC94XX_REG_H_
Index: linux-2.6.17-rc5/drivers/scsi/aic94xx/aic94xx_sas.h
===================================================================
--- linux-2.6.17-rc5.orig/drivers/scsi/aic94xx/aic94xx_sas.h	2006-06-05 12:59:21.000000000 -0700
+++ linux-2.6.17-rc5/drivers/scsi/aic94xx/aic94xx_sas.h	2006-06-05 13:17:24.000000000 -0700
@@ -22,7 +22,6 @@
  * along with the aic94xx driver; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  *
- * $Id: //depot/aic94xx/aic94xx_sas.h#62 $
  */
 
 #ifndef _AIC94XX_SAS_H_
Index: linux-2.6.17-rc5/drivers/scsi/aic94xx/aic94xx_scb.c
===================================================================
--- linux-2.6.17-rc5.orig/drivers/scsi/aic94xx/aic94xx_scb.c	2006-06-05 12:34:52.000000000 -0700
+++ linux-2.6.17-rc5/drivers/scsi/aic94xx/aic94xx_scb.c	2006-06-05 13:17:36.000000000 -0700
@@ -22,7 +22,6 @@
  * along with the aic94xx driver; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  *
- * $Id: //depot/aic94xx/aic94xx_scb.c#71 $
  */
 
 #include <linux/pci.h>
Index: linux-2.6.17-rc5/drivers/scsi/aic94xx/aic94xx_sds.c
===================================================================
--- linux-2.6.17-rc5.orig/drivers/scsi/aic94xx/aic94xx_sds.c	2006-06-05 12:34:52.000000000 -0700
+++ linux-2.6.17-rc5/drivers/scsi/aic94xx/aic94xx_sds.c	2006-06-05 13:17:46.000000000 -0700
@@ -23,7 +23,6 @@
  * along with the aic94xx driver; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  *
- * $Id: //depot/aic94xx/aic94xx_sds.c#35 $
  */
 
 #include <linux/pci.h>
Index: linux-2.6.17-rc5/drivers/scsi/aic94xx/aic94xx_seq.c
===================================================================
--- linux-2.6.17-rc5.orig/drivers/scsi/aic94xx/aic94xx_seq.c	2006-06-05 12:34:52.000000000 -0700
+++ linux-2.6.17-rc5/drivers/scsi/aic94xx/aic94xx_seq.c	2006-06-05 13:17:58.000000000 -0700
@@ -24,7 +24,6 @@
  * along with the aic94xx driver; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  *
- * $Id: //depot/aic94xx/aic94xx_seq.c#42 $
  */
 
 #include <linux/delay.h>
Index: linux-2.6.17-rc5/drivers/scsi/aic94xx/aic94xx_seq.h
===================================================================
--- linux-2.6.17-rc5.orig/drivers/scsi/aic94xx/aic94xx_seq.h	2006-06-05 12:34:52.000000000 -0700
+++ linux-2.6.17-rc5/drivers/scsi/aic94xx/aic94xx_seq.h	2006-06-05 13:18:12.000000000 -0700
@@ -22,7 +22,6 @@
  * along with the aic94xx driver; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  *
- * $Id: //depot/aic94xx/aic94xx_seq.h#7 $
  */
 
 #ifndef _AIC94XX_SEQ_H_
Index: linux-2.6.17-rc5/drivers/scsi/aic94xx/aic94xx_seq_microcode.c
===================================================================
--- linux-2.6.17-rc5.orig/drivers/scsi/aic94xx/aic94xx_seq_microcode.c	2006-06-05 12:34:52.000000000 -0700
+++ linux-2.6.17-rc5/drivers/scsi/aic94xx/aic94xx_seq_microcode.c	2006-06-05 13:18:27.000000000 -0700
@@ -22,8 +22,6 @@
  * along with the aic94xx driver; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  *
- * $Id: //depot/aic94xx/aic94xx_seq_microcode.c#24 $
- *
  * Compile options: RAZOR BYPASS_OOB SATA_II_NCQ TARGET_MODE CONCURR_CONNECTION
  */
 
Index: linux-2.6.17-rc5/drivers/scsi/aic94xx/aic94xx_task.c
===================================================================
--- linux-2.6.17-rc5.orig/drivers/scsi/aic94xx/aic94xx_task.c	2006-06-05 12:59:39.000000000 -0700
+++ linux-2.6.17-rc5/drivers/scsi/aic94xx/aic94xx_task.c	2006-06-05 13:18:38.000000000 -0700
@@ -22,7 +22,6 @@
  * along with the aic94xx driver; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  *
- * $Id: //depot/aic94xx/aic94xx_task.c#51 $
  */
 
 #include <linux/spinlock.h>
Index: linux-2.6.17-rc5/drivers/scsi/aic94xx/aic94xx_tmf.c
===================================================================
--- linux-2.6.17-rc5.orig/drivers/scsi/aic94xx/aic94xx_tmf.c	2006-06-05 12:46:28.000000000 -0700
+++ linux-2.6.17-rc5/drivers/scsi/aic94xx/aic94xx_tmf.c	2006-06-05 13:18:52.000000000 -0700
@@ -22,7 +22,6 @@
  * along with the aic94xx driver; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  *
- * $Id: //depot/aic94xx/aic94xx_tmf.c#35 $
  */
 
 #include <linux/spinlock.h>


