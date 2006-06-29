From: Adrian Bunk <bunk@stusta.de>
Subject: [-mm patch] drivers/message/fusion/mptsas.c: make 2 functions static
Date: Thu, 29 Jun 2006 21:20:10 +0200
Message-ID: <20060629192010.GP19712@stusta.de>
References: <20060629013643.4b47e8bd.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [141.84.69.5] ([141.84.69.5]:27408 "HELO mailout.stusta.mhn.de")
	by vger.kernel.org with SMTP id S932275AbWF2TUr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jun 2006 15:20:47 -0400
Content-Disposition: inline
In-Reply-To: <20060629013643.4b47e8bd.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, Eric.Moore@lsil.com
Cc: linux-kernel@vger.kernel.org, mpt_linux_developer@lsil.com, linux-scsi@vger.kernel.org

On Thu, Jun 29, 2006 at 01:36:43AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.17-mm3:
>...
>  git-scsi-misc.patch
>...
>  git trees.
>...

This patch makes two needlessly global functions static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/message/fusion/mptsas.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.17-mm4-full/drivers/message/fusion/mptsas.c.old	2006-06-29 14:54:36.000000000 +0200
+++ linux-2.6.17-mm4-full/drivers/message/fusion/mptsas.c	2006-06-29 14:54:51.000000000 +0200
@@ -337,7 +337,7 @@
 }
 
 /* no mutex */
-void
+static void
 mptsas_port_delete(struct mptsas_portinfo_details * port_details)
 {
 	struct mptsas_portinfo *port_info;
@@ -438,7 +438,7 @@
  * Updates for new and existing narrow/wide port configuration
  * in the sas_topology
  */
-void
+static void
 mptsas_setup_wide_ports(MPT_ADAPTER *ioc, struct mptsas_portinfo *port_info)
 {
 	struct mptsas_portinfo_details * port_details;

