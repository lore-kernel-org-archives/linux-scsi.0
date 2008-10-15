From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: scsi-debug documentation?
Date: Wed, 15 Oct 2008 10:26:23 +0900
Message-ID: <20081015102627Q.fujita.tomonori@lab.ntt.co.jp>
References: <48F4F049.5090709@redhat.com>
	<48F53417.1090501@interlog.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:33460 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbYJOB0s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Oct 2008 21:26:48 -0400
In-Reply-To: <48F53417.1090501@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: avi@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 14 Oct 2008 20:06:47 -0400
Douglas Gilbert <dgilbert@interlog.com> wrote:

> Avi Kivity wrote:
> > scsi-debug points to http://www.torque.net/sg/sdebug26.html as its
> > documentation.  That site appears to be dead however.  Does anyone have
> > a copy?
> > 
> > If so, I suggest Documentation/scsi/ as a better place for it.
> 
> Avi,
> The torque.net domain has been sold and is no longer
> functional. My pages have moved to
>    http://sg.danny.cz/sg
> This includes documentation on the sg driver and various user
> space packages: sg3_utils, smp_utils, sdparm and lsscsi.
> 
> So the page you were looking for is now:
>    http://sg.danny.cz/sg/sdebug26.html

Why not update Kconfig and scsi_debug.c?

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] update scsi_debug's URL

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/Kconfig      |    4 ++--
 drivers/scsi/scsi_debug.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 403ecad..510396f 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1517,8 +1517,8 @@ config SCSI_DEBUG
 	  each with multiple dummy SCSI devices (disks). It defaults to one
 	  host adapter with one dummy SCSI disk. Each dummy disk uses kernel
 	  RAM as storage (i.e. it is a ramdisk). To save space when multiple
-	  dummy disks are simulated, they share the same kernel RAM for 
-	  their storage. See <http://www.torque.net/sg/sdebug.html> for more
+	  dummy disks are simulated, they share the same kernel RAM for
+	  their storage. See <http://sg.danny.cz/sg/sdebug26.html> for more
 	  information. This driver is primarily of use to those testing the
 	  SCSI and block subsystems. If unsure, say N.
 
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 27c633f..671fed0 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -12,7 +12,7 @@
  *  SAS disks.
  *
  *
- *  For documentation see http://www.torque.net/sg/sdebug26.html
+ *  For documentation see http://sg.danny.cz/sg/sdebug26.html
  *
  *   D. Gilbert (dpg) work for Magneto-Optical device test [20010421]
  *   dpg: work for devfs large number of disks [20010809]
-- 
1.5.6.5

