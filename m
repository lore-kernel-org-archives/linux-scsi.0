From: Adrian Bunk <bunk@stusta.de>
Subject: [-mm patch] make scsi_host_link_pm_policy() static
Date: Sun, 29 Jul 2007 16:58:55 +0200
Message-ID: <20070729145855.GB16817@stusta.de>
References: <20070725040304.111550f4.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070725040304.111550f4.akpm@linux-foundation.org>
Sender: linux-ide-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Kristen Carlson Accardi <kristen.c.accardi@intel.com>, James Bottomley <James.Bottomley@steeleye.com>, Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 25, 2007 at 04:03:04AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.22-rc6-mm1:
>...
> +ata-ahci-alpm-expose-power-management-policy-option-to-users.patch
>...
>  ata things
>...

scsi_host_link_pm_policy() can become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.23-rc1-mm1/drivers/scsi/scsi_sysfs.c.old	2007-07-26 21:31:24.000000000 +0200
+++ linux-2.6.23-rc1-mm1/drivers/scsi/scsi_sysfs.c	2007-07-26 21:31:57.000000000 +0200
@@ -200,7 +200,7 @@
 	{ SHOST_MEDIUM_POWER, "medium_power" },
 };
 
-const char *scsi_host_link_pm_policy(enum scsi_host_link_pm policy)
+static const char *scsi_host_link_pm_policy(enum scsi_host_link_pm policy)
 {
 	int i;
 	char *name = NULL;

