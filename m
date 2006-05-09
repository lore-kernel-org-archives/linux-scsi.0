From: Alexis Bruemmer <alexisb@us.ibm.com>
Subject: [PATCH 3/8] aic94xx: remove the //depot SCM comments
Date: Tue, 09 May 2006 14:27:54 -0700
Message-ID: <1147210074.11847.47.camel@localhost.localdomain>
References: <1147209211.11847.33.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:46977 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751040AbWEIV2C
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 May 2006 17:28:02 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k49LS1UV014122
	for <linux-scsi@vger.kernel.org>; Tue, 9 May 2006 17:28:01 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k49LS17r170936
	for <linux-scsi@vger.kernel.org>; Tue, 9 May 2006 15:28:01 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id k49LS1t5015703
	for <linux-scsi@vger.kernel.org>; Tue, 9 May 2006 15:28:01 -0600
Received: from alexis.beaverton.ibm.com (alexis.beaverton.ibm.com [9.47.17.121])
	by d03av01.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id k49LRtWQ015289
	for <linux-scsi@vger.kernel.org>; Tue, 9 May 2006 15:28:00 -0600
In-Reply-To: <1147209211.11847.33.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Remove the //depot SCM comments

Signed-off-by: Alexis Bruemmer <alexisb@us.ibm.com>
Signed-off-by: Mike Anderson <andmike@us.ibm.com>


---
 drivers/scsi/sas/Kconfig         |    2 --
 drivers/scsi/sas/Makefile        |    2 --
 drivers/scsi/sas/sas_discover.c  |    1 -
 drivers/scsi/sas/sas_dump.c      |    1 -
 drivers/scsi/sas/sas_dump.h      |    1 -
 drivers/scsi/sas/sas_event.c     |    1 -
 drivers/scsi/sas/sas_expander.c  |    1 -
 drivers/scsi/sas/sas_init.c      |    1 -
 drivers/scsi/sas/sas_internal.h  |    1 -
 drivers/scsi/sas/sas_phy.c       |    1 -
 drivers/scsi/sas/sas_port.c      |    1 -
 drivers/scsi/sas/sas_scsi_host.c |    1 -
 include/scsi/sas/sas.h           |    1 -
 include/scsi/sas/sas_class.h     |    1 -
 include/scsi/sas/sas_discover.h  |    1 -
 include/scsi/sas/sas_expander.h  |    1 -
 include/scsi/sas/sas_frames.h    |    1 -
 include/scsi/sas/sas_frames_be.h |    1 -
 include/scsi/sas/sas_frames_le.h |    1 -
 include/scsi/sas/sas_task.h      |    1 -
 20 files changed, 22 deletions(-)

Index: aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_discover.c
===================================================================
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/sas/sas_discover.c
+++ aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_discover.c
@@ -20,7 +20,6 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  *
- * $Id: //depot/sas-class/sas_discover.c#140 $
  */
 
 #include <linux/pci.h>
Index: aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_dump.c
===================================================================
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/sas/sas_dump.c
+++ aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_dump.c
@@ -20,7 +20,6 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  *
- * $Id: //depot/sas-class/sas_dump.c#4 $
  */
 
 #include "sas_dump.h"
Index: aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_dump.h
===================================================================
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/sas/sas_dump.h
+++ aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_dump.h
@@ -20,7 +20,6 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  *
- * $Id: //depot/sas-class/sas_dump.h#2 $
  */
 
 #include "sas_internal.h"
Index: aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_event.c
===================================================================
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/sas/sas_event.c
+++ aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_event.c
@@ -20,7 +20,6 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  *
- * $Id: //depot/sas-class/sas_event.c#26 $
  */
 
 /**
Index: aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_expander.c
===================================================================
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/sas/sas_expander.c
+++ aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_expander.c
@@ -20,7 +20,6 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  *
- * $Id: //depot/sas-class/sas_expander.c#60 $
  */
 
 #include <linux/pci.h>
Index: aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_init.c
===================================================================
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/sas/sas_init.c
+++ aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_init.c
@@ -21,7 +21,6 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
  * USA
  *
- * $Id: //depot/sas-class/sas_init.c#45 $
  */
 
 #include <linux/module.h>
Index: aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_internal.h
===================================================================
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/sas/sas_internal.h
+++ aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_internal.h
@@ -21,7 +21,6 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
  * USA
  *
- * $Id: //depot/sas-class/sas_internal.h#35 $
  */
 
 #ifndef _SAS_INTERNAL_H_
Index: aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_phy.c
===================================================================
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/sas/sas_phy.c
+++ aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_phy.c
@@ -20,7 +20,6 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  *
- * $Id: //depot/sas-class/sas_phy.c#38 $
  */
 
 #include "sas_internal.h"
Index: aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_port.c
===================================================================
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/sas/sas_port.c
+++ aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_port.c
@@ -20,7 +20,6 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  *
- * $Id: //depot/sas-class/sas_port.c#44 $
  */
 
 #include "sas_internal.h"
Index: aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_scsi_host.c
===================================================================
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/sas/sas_scsi_host.c
+++ aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_scsi_host.c
@@ -21,7 +21,6 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
  * USA
  *
- * $Id: //depot/sas-class/sas_scsi_host.c#60 $
  */
 
 #include "sas_internal.h"
Index: aic94xx-sas-2.6-patched/drivers/scsi/sas/Kconfig
===================================================================
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/sas/Kconfig
+++ aic94xx-sas-2.6-patched/drivers/scsi/sas/Kconfig
@@ -21,8 +21,6 @@
 # Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
 # USA
 #
-# $Id: //depot/sas-class/Kconfig#6 $
-#
 
 config SCSI_SAS_DOMAIN_ATTRS
 	tristate "SAS Domain Transport Attributes"
Index: aic94xx-sas-2.6-patched/drivers/scsi/sas/Makefile
===================================================================
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/sas/Makefile
+++ aic94xx-sas-2.6-patched/drivers/scsi/sas/Makefile
@@ -21,8 +21,6 @@
 # Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
 # USA
 #
-# $Id: //depot/sas-class/Makefile#20 $
-#
 
 ifeq ($(CONFIG_SCSI_SAS_DOMAIN_DEBUG),y)
 	EXTRA_CFLAGS += -DSAS_DEBUG -g
Index: aic94xx-sas-2.6-patched/include/scsi/sas/sas.h
===================================================================
--- aic94xx-sas-2.6-patched.orig/include/scsi/sas/sas.h
+++ aic94xx-sas-2.6-patched/include/scsi/sas/sas.h
@@ -21,7 +21,6 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
  * USA
  *
- * $Id: //depot/sas-class/sas.h#25 $
  */
 
 #ifndef _SAS_H_
Index: aic94xx-sas-2.6-patched/include/scsi/sas/sas_class.h
===================================================================
--- aic94xx-sas-2.6-patched.orig/include/scsi/sas/sas_class.h
+++ aic94xx-sas-2.6-patched/include/scsi/sas/sas_class.h
@@ -21,7 +21,6 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
  * USA
  *
- * $Id: //depot/sas-class/sas_class.h#66 $
  */
 
 #ifndef _SAS_CLASS_H_
Index: aic94xx-sas-2.6-patched/include/scsi/sas/sas_discover.h
===================================================================
--- aic94xx-sas-2.6-patched.orig/include/scsi/sas/sas_discover.h
+++ aic94xx-sas-2.6-patched/include/scsi/sas/sas_discover.h
@@ -20,7 +20,6 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  *
- * $Id: //depot/sas-class/sas_discover.h#41 $
  */
 
 #ifndef _SAS_DISCOVER_H_
Index: aic94xx-sas-2.6-patched/include/scsi/sas/sas_expander.h
===================================================================
--- aic94xx-sas-2.6-patched.orig/include/scsi/sas/sas_expander.h
+++ aic94xx-sas-2.6-patched/include/scsi/sas/sas_expander.h
@@ -20,7 +20,6 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  *
- * $Id: //depot/sas-class/sas_expander.h#19 $
  */
 
 #ifndef _SAS_EXPANDER_H_
Index: aic94xx-sas-2.6-patched/include/scsi/sas/sas_frames.h
===================================================================
--- aic94xx-sas-2.6-patched.orig/include/scsi/sas/sas_frames.h
+++ aic94xx-sas-2.6-patched/include/scsi/sas/sas_frames.h
@@ -21,7 +21,6 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
  * USA
  *
- * $Id: //depot/sas-class/sas_frames.h#5 $
  */
 
 #ifndef _SAS_FRAMES_
Index: aic94xx-sas-2.6-patched/include/scsi/sas/sas_frames_be.h
===================================================================
--- aic94xx-sas-2.6-patched.orig/include/scsi/sas/sas_frames_be.h
+++ aic94xx-sas-2.6-patched/include/scsi/sas/sas_frames_be.h
@@ -21,7 +21,6 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
  * USA
  *
- * $Id: //depot/sas-class/sas_frames_be.h#11 $
  */
 
 #ifndef _SAS_FRAMES_BE_H_
Index: aic94xx-sas-2.6-patched/include/scsi/sas/sas_frames_le.h
===================================================================
--- aic94xx-sas-2.6-patched.orig/include/scsi/sas/sas_frames_le.h
+++ aic94xx-sas-2.6-patched/include/scsi/sas/sas_frames_le.h
@@ -21,7 +21,6 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
  * USA
  *
- * $Id: //depot/sas-class/sas_frames_le.h#10 $
  */
 
 #ifndef _SAS_FRAMES_LE_H_
Index: aic94xx-sas-2.6-patched/include/scsi/sas/sas_task.h
===================================================================
--- aic94xx-sas-2.6-patched.orig/include/scsi/sas/sas_task.h
+++ aic94xx-sas-2.6-patched/include/scsi/sas/sas_task.h
@@ -20,7 +20,6 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  *
- * $Id: //depot/sas-class/sas_task.h#27 $
  */
 
 #ifndef _SAS_TASK_H_


