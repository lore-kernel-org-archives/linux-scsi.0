From: David Jeffery <david_jeffery@adaptec.com>
Subject: [PATCH2.5] ips 4/4: version resync
Date: 15 Aug 2003 08:43:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1060951428.3259.48.camel@blackmagic>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-kdXyh/dsCe0qBQ5tuG1S"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic-mail.adaptec.com ([208.236.45.100]:14023 "EHLO
	magic.adaptec.com") by vger.kernel.org with ESMTP id S275937AbTHOMlS
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Aug 2003 08:41:18 -0400
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id h7FCfHo21143
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2003 05:41:17 -0700
Received: from rtpexc01.adaptec.com (rtpexc01.adaptec.com [10.110.12.22])
	by redfish.adaptec.com (8.8.8p2+Sun/8.8.8) with ESMTP id FAA24475
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2003 05:41:16 -0700 (PDT)
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


--=-kdXyh/dsCe0qBQ5tuG1S
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

This patch has no code changes.  It is just a resync of all the version
numbers with the 6.10 driver and bumping up the driver version number.

David Jeffery 


--=-kdXyh/dsCe0qBQ5tuG1S
Content-Disposition: attachment; filename=test3.patch4
Content-Transfer-Encoding: quoted-printable
Content-Type: text/x-patch; name=test3.patch4; charset=ANSI_X3.4-1968

diff -urN linux-2.6.0-test3_p3/drivers/scsi/ips.c linux-2.6.0-test3_p4/driv=
ers/scsi/ips.c
--- linux-2.6.0-test3_p3/drivers/scsi/ips.c	2003-08-11 13:54:05.000000000 -=
0400
+++ linux-2.6.0-test3_p4/drivers/scsi/ips.c	2003-08-14 08:39:47.000000000 -=
0400
@@ -195,8 +195,8 @@
 /*
  * DRIVER_VER
  */
-#define IPS_VERSION_HIGH        "5.99"
-#define IPS_VERSION_LOW         ".01-BETA"
+#define IPS_VERSION_HIGH        "6.10"
+#define IPS_VERSION_LOW         ".90-BETA"
=20
 #if !defined(__i386__) && !defined(__ia64__) && !defined(__x86_64__)
 #error "This driver has only been tested on the x86/ia64/x86_64 platforms"
diff -urN linux-2.6.0-test3_p3/drivers/scsi/ips.h linux-2.6.0-test3_p4/driv=
ers/scsi/ips.h
--- linux-2.6.0-test3_p3/drivers/scsi/ips.h	2003-08-11 13:54:05.000000000 -=
0400
+++ linux-2.6.0-test3_p4/drivers/scsi/ips.h	2003-08-14 12:40:01.000000000 -=
0400
@@ -1201,25 +1201,29 @@
 *
 *************************************************************************/
=20
-#define IPS_VER_MAJOR 5
-#define IPS_VER_MAJOR_STRING "5"
-#define IPS_VER_MINOR 99
-#define IPS_VER_MINOR_STRING "99"
-#define IPS_VER_BUILD 00
-#define IPS_VER_BUILD_STRING "00"
-#define IPS_VER_STRING "5.99.00"
-#define IPS_BUILD_IDENT 1132
+#define IPS_VER_MAJOR 6
+#define IPS_VER_MAJOR_STRING "6"
+#define IPS_VER_MINOR 10
+#define IPS_VER_MINOR_STRING "10"
+#define IPS_VER_BUILD 90
+#define IPS_VER_BUILD_STRING "90"
+#define IPS_VER_STRING "6.10.90"
+#define IPS_RELEASE_ID 0x00010000
+#define IPS_BUILD_IDENT 364
+#define IPS_LEGALCOPYRIGHT_STRING "(C) Copyright IBM Corp. 1994, 2003. All=
 Rights Reserved."
+#define IPS_ADAPTECCOPYRIGHT_STRING "(c) Copyright Adaptec, Inc. 2002 to p=
resent. All Rights Reserved."
+#define IPS_NT_LEGALCOPYRIGHT_STRING "(C) Copyright IBM Corp. 1994, 2003."
=20
 /* Version numbers for various adapters */
 #define IPS_VER_SERVERAID1 "2.25.01"
 #define IPS_VER_SERVERAID2 "2.88.13"
 #define IPS_VER_NAVAJO "2.88.13"
-#define IPS_VER_SERVERAID3 "5.11.05"
-#define IPS_VER_SERVERAID4H "5.11.05"
-#define IPS_VER_SERVERAID4MLx "5.11.05"
-#define IPS_VER_SARASOTA "5.11.05"
-#define IPS_VER_MARCO "0.00.00"
-#define IPS_VER_SEBRING "0.00.00"
+#define IPS_VER_SERVERAID3 "6.10.24"
+#define IPS_VER_SERVERAID4H "6.10.24"
+#define IPS_VER_SERVERAID4MLx "6.10.24"
+#define IPS_VER_SARASOTA "6.10.24"
+#define IPS_VER_MARCO "6.10.24"
+#define IPS_VER_SEBRING "6.10.24"
=20
 /* Compatability IDs for various adapters */
 #define IPS_COMPAT_UNKNOWN ""
@@ -1228,17 +1232,17 @@
 #define IPS_COMPAT_SERVERAID2 "2.88.13"
 #define IPS_COMPAT_NAVAJO  "2.88.13"
 #define IPS_COMPAT_KIOWA "2.88.13"
-#define IPS_COMPAT_SERVERAID3H  "SA510"
-#define IPS_COMPAT_SERVERAID3L  "SA510"
-#define IPS_COMPAT_SERVERAID4H  "SA510"
-#define IPS_COMPAT_SERVERAID4M  "SA510"
-#define IPS_COMPAT_SERVERAID4L  "SA510"
-#define IPS_COMPAT_SERVERAID4Mx "SA510"
-#define IPS_COMPAT_SERVERAID4Lx "SA510"
-#define IPS_COMPAT_SARASOTA     "SA510"
-#define IPS_COMPAT_MARCO        "SA000"
-#define IPS_COMPAT_SEBRING      "SA000"
-#define IPS_COMPAT_BIOS "SA510"
+#define IPS_COMPAT_SERVERAID3H  "SB610"
+#define IPS_COMPAT_SERVERAID3L  "SB610"
+#define IPS_COMPAT_SERVERAID4H  "SB610"
+#define IPS_COMPAT_SERVERAID4M  "SB610"
+#define IPS_COMPAT_SERVERAID4L  "SB610"
+#define IPS_COMPAT_SERVERAID4Mx "SB610"
+#define IPS_COMPAT_SERVERAID4Lx "SB610"
+#define IPS_COMPAT_SARASOTA     "SB610"
+#define IPS_COMPAT_MARCO        "SB610"
+#define IPS_COMPAT_SEBRING      "SB610"
+#define IPS_COMPAT_BIOS "SB610"
=20
 #define IPS_COMPAT_MAX_ADAPTER_TYPE 16
 #define IPS_COMPAT_ID_LENGTH 8

--=-kdXyh/dsCe0qBQ5tuG1S--

