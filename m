From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH] scsi sysfs (arm scsi 3/3)
Date: Tue, 26 Nov 2002 00:14:47 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021126081447.GC3280@beaverton.ibm.com>
References: <20021126081047.GA3280@beaverton.ibm.com> <20021126081252.GB3280@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from westrelay01.boulder.ibm.com (westrelay01.boulder.ibm.com [9.17.194.22])
	by e32.co.us.ibm.com (8.12.2/8.12.2) with ESMTP id gAQ8DE7l019790
	for <linux-scsi@vger.kernel.org>; Tue, 26 Nov 2002 03:13:14 -0500
Received: from hmsbounty (sig-9-65-8-42.mts.ibm.com [9.65.8.42])
	by westrelay01.boulder.ibm.com (8.12.3/NCO/VER6.4) with ESMTP id gAQ8DDUC066254
	for <linux-scsi@vger.kernel.org>; Tue, 26 Nov 2002 01:13:14 -0700
Content-Disposition: inline
In-Reply-To: <20021126081252.GB3280@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

[arm scsi]
        - Added support for newer scsi_add_host.
	- Needs compile check on arm.
-andmike
--
Michael Anderson
andmike@us.ibm.com

 acornscsi.c |    2 +-
 arxescsi.c  |    2 +-
 cumana_1.c  |    2 +-
 cumana_2.c  |    2 +-
 eesox.c     |    2 +-
 oak.c       |    2 +-
 powertec.c  |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)
------

diff -Nru a/drivers/acorn/scsi/acornscsi.c b/drivers/acorn/scsi/acornscsi.c
--- a/drivers/acorn/scsi/acornscsi.c	Mon Nov 25 14:51:52 2002
+++ b/drivers/acorn/scsi/acornscsi.c	Mon Nov 25 14:51:52 2002
@@ -3051,7 +3051,7 @@
 
 	acornscsi_resetcard(ashost);
 
-	ret = scsi_add_host(host);
+	ret = scsi_add_host(host, &ec->dev);
 	if (ret == 0)
 		goto out;
 
diff -Nru a/drivers/acorn/scsi/arxescsi.c b/drivers/acorn/scsi/arxescsi.c
--- a/drivers/acorn/scsi/arxescsi.c	Mon Nov 25 14:51:52 2002
+++ b/drivers/acorn/scsi/arxescsi.c	Mon Nov 25 14:51:52 2002
@@ -398,7 +398,7 @@
 
 	fas216_init(host);
 
-	ret = scsi_add_host(host);
+	ret = scsi_add_host(host, &ec->dev);
 	if (ret == 0)
 		goto out;
 
diff -Nru a/drivers/acorn/scsi/cumana_1.c b/drivers/acorn/scsi/cumana_1.c
--- a/drivers/acorn/scsi/cumana_1.c	Mon Nov 25 14:51:52 2002
+++ b/drivers/acorn/scsi/cumana_1.c	Mon Nov 25 14:51:52 2002
@@ -299,7 +299,7 @@
 	NCR5380_print_options(host);
 	printk("\n");
 
-	ret = scsi_add_host(host);
+	ret = scsi_add_host(host, &ec->dev);
 	if (ret == 0)
 		goto out;
 
diff -Nru a/drivers/acorn/scsi/cumana_2.c b/drivers/acorn/scsi/cumana_2.c
--- a/drivers/acorn/scsi/cumana_2.c	Mon Nov 25 14:51:53 2002
+++ b/drivers/acorn/scsi/cumana_2.c	Mon Nov 25 14:51:53 2002
@@ -505,7 +505,7 @@
 
 	fas216_init(host);
 
-	ret = scsi_add_host(host);
+	ret = scsi_add_host(host, &ec->dev);
 	if (ret == 0)
 		goto out;
 
diff -Nru a/drivers/acorn/scsi/eesox.c b/drivers/acorn/scsi/eesox.c
--- a/drivers/acorn/scsi/eesox.c	Mon Nov 25 14:51:53 2002
+++ b/drivers/acorn/scsi/eesox.c	Mon Nov 25 14:51:53 2002
@@ -504,7 +504,7 @@
 	}
 
 	fas216_init(host);
-	ret = scsi_add_host(host);
+	ret = scsi_add_host(host, &ec->dev);
 	if (ret == 0)
 		goto out;
 
diff -Nru a/drivers/acorn/scsi/oak.c b/drivers/acorn/scsi/oak.c
--- a/drivers/acorn/scsi/oak.c	Mon Nov 25 14:51:52 2002
+++ b/drivers/acorn/scsi/oak.c	Mon Nov 25 14:51:52 2002
@@ -160,7 +160,7 @@
 	NCR5380_print_options(host);
 	printk("\n");
 
-	ret = scsi_add_host(host);
+	ret = scsi_add_host(host, &ec->dev);
 	if (ret == 0)
 		goto out;
 
diff -Nru a/drivers/acorn/scsi/powertec.c b/drivers/acorn/scsi/powertec.c
--- a/drivers/acorn/scsi/powertec.c	Mon Nov 25 14:51:53 2002
+++ b/drivers/acorn/scsi/powertec.c	Mon Nov 25 14:51:53 2002
@@ -378,7 +378,7 @@
 
 	fas216_init(host);
 
-	ret = scsi_add_host(host);
+	ret = scsi_add_host(host, &ec->dev);
 	if (ret == 0)
 		goto out;
 
