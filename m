From: Frank Zago <fzago@greshamstorage.com>
Subject: [PATCH] add 2 more broken device to scsi_scan.c
Date: Sun, 28 Apr 2002 02:50:37 -0500 (CDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0204280247160.12909-100000@janus.openmic.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi,

These two flatbed scanners respond to all luns. This patch fixes it.
Tested. Applies to kernel 2.4.18.

Regards,
  Frank.


--- scsi_scan.c.org     Mon Feb 25 13:38:04 2002
+++ scsi_scan.c Sun Apr 28 02:27:39 2002
@@ -115,6 +115,8 @@
        {"YAMAHA", "CRW6416S", "1.0c", BLIST_NOLUN},            /* Locks up if polled for lun != 0 */
        {"MITSUMI", "CD-R CR-2201CS", "6119", BLIST_NOLUN},     /* Locks up if polled for lun != 0 */
        {"RELISYS", "Scorpio", "*", BLIST_NOLUN},               /* responds to all LUN */
+       {"RELISYS", "VM3530+", "*", BLIST_NOLUN},               /* responds to all LUN */
+       {"ACROSS", "", "*", BLIST_NOLUN},                       /* responds to all LUN */
        {"MICROTEK", "ScanMaker II", "5.61", BLIST_NOLUN},      /* responds to all LUN */

 /*



