From: Arvind Kumar <arvindkumar@vmware.com>
Subject: Re: [PATCH] VMW_PVSCSI: Change to update maintainer details (name,
 email)
Date: Fri, 17 Jun 2016 01:19:59 +0000
Message-ID: <1466126464746.49767@vmware.com>
References: <57634CBD.8000402@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <57634CBD.8000402@vmware.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jim Gill <jgill@vmware.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "pv-drivers@vmware.com" <pv-drivers@vmware.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Looks fine to me.

Acked-by: Arvind Kumar (arvindkumar@vmware.com)

Thanks!
Arvind
________________________________________
From: Jim Gill <jgill@vmware.com>
Sent: Thursday, June 16, 2016 6:05 PM
To: jejb@linux.vnet.ibm.com; martin.petersen@oracle.com
Cc: Arvind Kumar; pv-drivers@vmware.com; linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: [PATCH] VMW_PVSCSI: Change to update maintainer details (name, email)

 From 6a076cc00ec12c6f9cba58ee7e4c3dec49e1e7e5 Mon Sep 17 00:00:00 2001
From: Jim Gill <jgill@vmware.com>
Date: Thu, 16 Jun 2016 14:10:43 -0700
Subject: [PATCH] VMW_PVSCSI: Change to update maintainer details (name, email)

Signed-off-by: Jim Gill <jgill@vmware.com>
---
  drivers/scsi/vmw_pvscsi.c | 2 +-
  drivers/scsi/vmw_pvscsi.h | 2 +-
  2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 6164634..4a0d3cd 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -17,7 +17,7 @@
   * along with this program; if not, write to the Free Software
   * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
   *
- * Maintained by: Arvind Kumar <arvindkumar@vmware.com>
+ * Maintained by: Jim Gill <jgill@vmware.com>
   *
   */

diff --git a/drivers/scsi/vmw_pvscsi.h b/drivers/scsi/vmw_pvscsi.h
index 12712c9..c097d2c 100644
--- a/drivers/scsi/vmw_pvscsi.h
+++ b/drivers/scsi/vmw_pvscsi.h
@@ -17,7 +17,7 @@
   * along with this program; if not, write to the Free Software
   * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
   *
- * Maintained by: Arvind Kumar <arvindkumar@vmware.com>
+ * Maintained by: Jim Gill <jgill@vmware.com>
   *
   */

--
2.5.0
