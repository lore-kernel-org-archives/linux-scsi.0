From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] update additional sense codes and some opcode names
Date: Sun, 02 Jul 2006 13:48:10 -0400
Message-ID: <44A806DA.1020108@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040401060902020306000404"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:19105 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751273AbWGBRsP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Jul 2006 13:48:15 -0400
Received: from hse-london-ppp195987.sympatico.ca ([64.229.19.50] helo=[192.168.1.100])
	by pentafluge.infradead.org with esmtpsa (Exim 4.62 #1 (Red Hat Linux))
	id 1Fx63I-00005P-Pw
	for linux-scsi@vger.kernel.org; Sun, 02 Jul 2006 18:48:13 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------040401060902020306000404
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Following on from my post titled: "additional sense codes
need update" see the attachment against lk 2.6.17 .

ChangeLog:
  - update additional sense codes table to agree with
    SPC-4 revision 5a  (14 June 2006)
  - adjust some of the opcode names


Signed-off-by: Douglas Gilbert <dougg@torque.net>


--------------040401060902020306000404
Content-Type: text/x-patch;
 name="constants_2617a.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="constants_2617a.diff"

--- linux/drivers/scsi/constants.c	2006-04-03 10:28:26.000000000 -0400
+++ linux/drivers/scsi/constants.c2617dpg1	2006-07-02 13:36:12.000000000 -0400
@@ -5,6 +5,7 @@
  * Additions for SCSI 3+ (SPC-3 T10/1416-D Rev 07 3 May 2002)
  *   by D. Gilbert and aeb (20020609)
  * Additions for SPC-3 T10/1416-D Rev 21 22 Sept 2004, D. Gilbert 20041025
+ * Update to SPC-4 T10/1713-D Rev 5a, 14 June 2006, D. Gilbert 20060702
  */
 
 #include <linux/config.h>
@@ -37,55 +38,56 @@
 /* 00-03 */ "Test Unit Ready", "Rezero Unit/Rewind", NULL, "Request Sense",
 /* 04-07 */ "Format Unit/Medium", "Read Block Limits", NULL,
 	    "Reasssign Blocks",
-/* 08-0d */ "Read (6)", NULL, "Write (6)", "Seek (6)", NULL, NULL,
+/* 08-0d */ "Read(6)", NULL, "Write(6)", "Seek(6)", NULL, NULL,
 /* 0e-12 */ NULL, "Read Reverse", "Write Filemarks", "Space", "Inquiry",  
-/* 13-16 */ "Verify (6)", "Recover Buffered Data", "Mode Select (6)",
-	    "Reserve (6)",
-/* 17-1a */ "Release (6)", "Copy", "Erase", "Mode Sense (6)", 
+/* 13-16 */ "Verify(6)", "Recover Buffered Data", "Mode Select(6)",
+	    "Reserve(6)",
+/* 17-1a */ "Release(6)", "Copy", "Erase", "Mode Sense(6)", 
 /* 1b-1d */ "Start/Stop Unit", "Receive Diagnostic", "Send Diagnostic", 
 /* 1e-1f */ "Prevent/Allow Medium Removal", NULL,
 /* 20-22 */  NULL, NULL, NULL,
 /* 23-28 */ "Read Format Capacities", "Set Window",
-	    "Read Capacity (10)", NULL, NULL, "Read (10)", 
-/* 29-2d */ "Read Generation", "Write (10)", "Seek (10)", "Erase (10)", 
+	    "Read Capacity(10)", NULL, NULL, "Read(10)", 
+/* 29-2d */ "Read Generation", "Write(10)", "Seek(10)", "Erase(10)", 
             "Read updated block", 
-/* 2e-31 */ "Write Verify (10)", "Verify (10)", "Search High", "Search Equal", 
+/* 2e-31 */ "Write Verify(10)", "Verify(10)", "Search High", "Search Equal", 
 /* 32-34 */ "Search Low", "Set Limits", "Prefetch/Read Position", 
-/* 35-37 */ "Synchronize Cache (10)", "Lock/Unlock Cache (10)",
+/* 35-37 */ "Synchronize Cache(10)", "Lock/Unlock Cache(10)",
 	    "Read Defect Data(10)", 
 /* 38-3c */ "Medium Scan", "Compare", "Copy Verify", "Write Buffer", 
             "Read Buffer", 
-/* 3d-3f */ "Update Block", "Read Long (10)",  "Write Long (10)",
-/* 40-41 */ "Change Definition", "Write Same (10)",
+/* 3d-3f */ "Update Block", "Read Long(10)",  "Write Long(10)",
+/* 40-41 */ "Change Definition", "Write Same(10)",
 /* 42-48 */ "Read sub-channel", "Read TOC/PMA/ATIP", "Read density support",
-            "Play audio (10)", "Get configuration", "Play audio msf",
+            "Play audio(10)", "Get configuration", "Play audio msf",
             "Play audio track/index",
-/* 49-4f */ "Play track relative (10)", "Get event status notification",
+/* 49-4f */ "Play track relative(10)", "Get event status notification",
             "Pause/resume", "Log Select", "Log Sense", "Stop play/scan",
             NULL,
 /* 50-55 */ "Xdwrite", "Xpwrite, Read disk info", "Xdread, Read track info",
-            "Reserve track", "Send OPC info", "Mode Select (10)",
-/* 56-5b */ "Reserve (10)", "Release (10)", "Repair track", "Read master cue",
-            "Mode Sense (10)", "Close track/session",
+            "Reserve track", "Send OPC info", "Mode Select(10)",
+/* 56-5b */ "Reserve(10)", "Release(10)", "Repair track", "Read master cue",
+            "Mode Sense(10)", "Close track/session",
 /* 5c-5f */ "Read buffer capacity", "Send cue sheet", "Persistent reserve in",
             "Persistent reserve out",
 /* 60-67 */ NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 /* 68-6f */ NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 /* 70-77 */ NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 /* 78-7f */ NULL, NULL, NULL, NULL, NULL, NULL, NULL, "Variable length",
-/* 80-84 */ "Xdwrite (16)", "Rebuild (16)", "Regenerate (16)", "Extended copy",
+/* 80-84 */ "Xdwrite(16)", "Rebuild(16)", "Regenerate(16)", "Extended copy",
             "Receive copy results",
-/* 85-89 */ "Memory Export In (16)", "Access control in", "Access control out",
-            "Read (16)", "Memory Export Out (16)",
-/* 8a-8f */ "Write (16)", NULL, "Read attributes", "Write attributes",
-            "Write and verify (16)", "Verify (16)",
-/* 90-94 */ "Pre-fetch (16)", "Synchronize cache (16)",
-            "Lock/unlock cache (16)", "Write same (16)", NULL,
+/* 85-89 */ "ATA command pass through(16)", "Access control in",
+	    "Access control out", "Read(16)", "Memory Export Out(16)",
+/* 8a-8f */ "Write(16)", NULL, "Read attributes", "Write attributes",
+            "Write and verify(16)", "Verify(16)",
+/* 90-94 */ "Pre-fetch(16)", "Synchronize cache(16)",
+            "Lock/unlock cache(16)", "Write same(16)", NULL,
 /* 95-99 */ NULL, NULL, NULL, NULL, NULL,
-/* 9a-9f */ NULL, NULL, NULL, NULL, "Service action in (16)",
-            "Service action out (16)",
-/* a0-a5 */ "Report luns", "Blank", "Send event", "Maintenance in",
-            "Maintenance out", "Move medium/play audio(12)",
+/* 9a-9f */ NULL, NULL, NULL, NULL, "Service action in(16)",
+            "Service action out(16)",
+/* a0-a5 */ "Report luns", "ATA command pass through(12)/Blank",
+            "Security protocol in", "Maintenance in", "Maintenance out",
+	    "Move medium/play audio(12)",
 /* a6-a9 */ "Exchange medium", "Move medium attached", "Read(12)",
             "Play track relative(12)",
 /* aa-ae */ "Write(12)", NULL, "Erase(12), Get Performance",
@@ -93,12 +95,12 @@
 /* af-b1 */ "Verify(12)", "Search data high(12)", "Search data equal(12)",
 /* b2-b4 */ "Search data low(12)", "Set limits(12)",
             "Read element status attached",
-/* b5-b6 */ "Request volume element address", "Send volume tag, set streaming",
+/* b5-b6 */ "Security protocol out", "Send volume tag, set streaming",
 /* b7-b9 */ "Read defect data(12)", "Read element status", "Read CD msf",
 /* ba-bc */ "Redundancy group (in), Scan",
-            "Redundancy group (out), Set cd-rom speed", "Spare in, Play cd",
-/* bd-bf */ "Spare out, Mechanism status", "Volume set in, Read cd",
-            "Volume set out, Send DVD structure",
+            "Redundancy group (out), Set cd-rom speed", "Spare (in), Play cd",
+/* bd-bf */ "Spare (out), Mechanism status", "Volume set (in), Read cd",
+            "Volume set (out), Send DVD structure",
 };
 
 struct value_name_pair {
@@ -113,6 +115,7 @@
 	{0xc, "Report supported operation codes"},
 	{0xd, "Report supported task management functions"},
 	{0xe, "Report priority"},
+	{0xf, "Report timestamp"},
 };
 #define MAINT_IN_SZ \
         (int)(sizeof(maint_in_arr) / sizeof(maint_in_arr[0]))
@@ -122,6 +125,7 @@
 	{0xa, "Set target port groups"},
 	{0xb, "Change aliases"},
 	{0xe, "Set priority"},
+	{0xe, "Set timestamp"},
 };
 #define MAINT_OUT_SZ \
         (int)(sizeof(maint_out_arr) / sizeof(maint_out_arr[0]))
@@ -435,6 +439,7 @@
 	{0x001A, "Rewind operation in progress"},
 	{0x001B, "Set capacity operation in progress"},
 	{0x001C, "Verify operation in progress"},
+	{0x001D, "ATA pass through information available"},
 
 	{0x0100, "No index/sector signal"},
 
@@ -446,7 +451,7 @@
 
 	{0x0400, "Logical unit not ready, cause not reportable"},
 	{0x0401, "Logical unit is in process of becoming ready"},
-	{0x0402, "Logical unit not ready, initializing cmd. required"},
+	{0x0402, "Logical unit not ready, initializing command required"},
 	{0x0403, "Logical unit not ready, manual intervention required"},
 	{0x0404, "Logical unit not ready, format in progress"},
 	{0x0405, "Logical unit not ready, rebuild in progress"},
@@ -486,6 +491,9 @@
 	{0x0B00, "Warning"},
 	{0x0B01, "Warning - specified temperature exceeded"},
 	{0x0B02, "Warning - enclosure degraded"},
+	{0x0B03, "Warning - background self-test failed"},
+	{0x0B04, "Warning - background pre-scan detected medium error"},
+	{0x0B05, "Warning - background medium scan detected medium error"},
 
 	{0x0C00, "Write error"},
 	{0x0C01, "Write error - recovered with auto reallocation"},
@@ -501,6 +509,7 @@
 	{0x0C0B, "Auxiliary memory write error"},
 	{0x0C0C, "Write error - unexpected unsolicited data"},
 	{0x0C0D, "Write error - not enough unsolicited data"},
+	{0x0C0F, "Defects in error window"},
 
 	{0x0D00, "Error detected by third party temporary initiator"},
 	{0x0D01, "Third party device failure"},
@@ -512,11 +521,12 @@
 	{0x0E00, "Invalid information unit"},
 	{0x0E01, "Information unit too short"},
 	{0x0E02, "Information unit too long"},
+	{0x0E03, "Invalid field in command information unit"},
 
 	{0x1000, "Id CRC or ECC error"},
-	{0x1001, "Data block guard check failed"},
-	{0x1002, "Data block application tag check failed"},
-	{0x1003, "Data block reference tag check failed"},
+	{0x1001, "Logical block guard check failed"},
+	{0x1002, "Logical block application tag check failed"},
+	{0x1003, "Logical block reference tag check failed"},
 
 	{0x1100, "Unrecovered read error"},
 	{0x1101, "Read retries exhausted"},
@@ -538,6 +548,7 @@
 	{0x1111, "Read error - loss of streaming"},
 	{0x1112, "Auxiliary memory read error"},
 	{0x1113, "Read error - failed retransmission request"},
+	{0x1114, "Read error - lba marked bad by application client"},
 
 	{0x1200, "Address mark not found for id field"},
 
@@ -618,11 +629,14 @@
 	{0x2100, "Logical block address out of range"},
 	{0x2101, "Invalid element address"},
 	{0x2102, "Invalid address for write"},
+	{0x2103, "Invalid write crossing layer jump"},
 
 	{0x2200, "Illegal function (use 20 00, 24 00, or 26 00)"},
 
 	{0x2400, "Invalid field in cdb"},
 	{0x2401, "CDB decryption error"},
+	{0x2402, "Obsolete"},
+	{0x2403, "Obsolete"},
 	{0x2404, "Security audit value frozen"},
 	{0x2405, "Security working key frozen"},
 	{0x2406, "Nonce not unique"},
@@ -645,7 +659,10 @@
 	{0x260C, "Invalid operation for copy source or destination"},
 	{0x260D, "Copy segment granularity violation"},
 	{0x260E, "Invalid parameter while port is enabled"},
-	{0x260F, "Invalid data-out buffer integrity"},
+	{0x260F, "Invalid data-out buffer integrity check value"},
+	{0x2610, "Data decryption key fail limit reached"},
+	{0x2611, "Incomplete key-associated data set"},
+	{0x2612, "Vendor specific key reference not found"},
 
 	{0x2700, "Write protected"},
 	{0x2701, "Hardware write protected"},
@@ -657,6 +674,7 @@
 
 	{0x2800, "Not ready to ready change, medium may have changed"},
 	{0x2801, "Import or export element accessed"},
+	{0x2802, "Format-layer may have changed"},
 
 	{0x2900, "Power on, reset, or bus device reset occurred"},
 	{0x2901, "Power on occurred"},
@@ -677,6 +695,11 @@
 	{0x2A07, "Implicit asymmetric access state transition failed"},
 	{0x2A08, "Priority changed"},
 	{0x2A09, "Capacity data has changed"},
+	{0x2A10, "Timestamp changed"},
+	{0x2A11, "Data encryption parameters changed by another i_t nexus"},
+	{0x2A12, "Data encryption parameters changed by vendor specific "
+		 "event"},
+	{0x2A13, "Data encryption key instance counter has changed"},
 
 	{0x2B00, "Copy cannot execute since host cannot disconnect"},
 
@@ -698,6 +721,7 @@
 	{0x2E00, "Insufficient time for operation"},
 
 	{0x2F00, "Commands cleared by another initiator"},
+	{0x2F01, "Commands cleared by power loss notification"},
 
 	{0x3000, "Incompatible medium installed"},
 	{0x3001, "Cannot read medium - unknown format"},
@@ -710,7 +734,8 @@
 	{0x3008, "Cannot write - application code mismatch"},
 	{0x3009, "Current session not fixated for append"},
 	{0x300A, "Cleaning request rejected"},
-	{0x300C, "WORM medium, overwrite attempted"},
+	{0x300C, "WORM medium - overwrite attempted"},
+	{0x300D, "WORM medium - integrity check"},
 	{0x3010, "Medium not formatted"},
 
 	{0x3100, "Medium format corrupted"},
@@ -798,6 +823,9 @@
 	{0x3F0F, "Echo buffer overwritten"},
 	{0x3F10, "Medium loadable"},
 	{0x3F11, "Medium auxiliary memory accessible"},
+	{0x3F12, "iSCSI IP address added"},
+	{0x3F13, "iSCSI IP address removed"},
+	{0x3F14, "iSCSI IP address changed"},
 /*
  *	{0x40NN, "Ram failure"},
  *	{0x40NN, "Diagnostic failure on component nn"},
@@ -807,6 +835,7 @@
 	{0x4300, "Message error"},
 
 	{0x4400, "Internal target failure"},
+	{0x4471, "ATA device failed set features"},
 
 	{0x4500, "Select or reselect failure"},
 
@@ -815,9 +844,10 @@
 	{0x4700, "Scsi parity error"},
 	{0x4701, "Data phase CRC error detected"},
 	{0x4702, "Scsi parity error detected during st data phase"},
-	{0x4703, "Information unit CRC error detected"},
+	{0x4703, "Information unit iuCRC error detected"},
 	{0x4704, "Asynchronous information protection error detected"},
 	{0x4705, "Protocol service CRC error"},
+	{0x4706, "Phy test function in progress"},
 	{0x477f, "Some commands cleared by iSCSI Protocol event"},
 
 	{0x4800, "Initiator detected error message received"},
@@ -852,6 +882,8 @@
 	{0x5300, "Media load or eject failed"},
 	{0x5301, "Unload tape failure"},
 	{0x5302, "Medium removal prevented"},
+	{0x5303, "Medium removal prevented by data transfer element"},
+	{0x5304, "Medium thread or unthread failure"},
 
 	{0x5400, "Scsi to host system interface failure"},
 
@@ -863,6 +895,7 @@
 	{0x5505, "Insufficient access control resources"},
 	{0x5506, "Auxiliary memory out of space"},
 	{0x5507, "Quota error"},
+	{0x5508, "Maximum number of supplemental decryption keys exceeded"},
 
 	{0x5700, "Unable to recover table-of-contents"},
 
@@ -1012,6 +1045,7 @@
 	{0x6708, "Assign failure occurred"},
 	{0x6709, "Multiply assigned logical unit"},
 	{0x670A, "Set target port groups command failed"},
+	{0x670B, "ATA device feature not enabled"},
 
 	{0x6800, "Logical unit not configured"},
 
@@ -1038,6 +1072,8 @@
 	{0x6F03, "Read of scrambled sector without authentication"},
 	{0x6F04, "Media region code is mismatched to logical unit region"},
 	{0x6F05, "Drive region must be permanent/region reset count error"},
+	{0x6F06, "Insufficient block count for binding nonce recording"},
+	{0x6F07, "Conflict in binding nonce recording"},
 /*
  *	{0x70NN, "Decompression exception short algorithm id of nn"},
  */
@@ -1049,6 +1085,8 @@
 	{0x7203, "Session fixation error - incomplete track in session"},
 	{0x7204, "Empty or partially written reserved track"},
 	{0x7205, "No more track reservations allowed"},
+	{0x7206, "RMZ extension is not allowed"},
+	{0x7207, "No more test zone extensions are allowed"},
 
 	{0x7300, "Cd control error"},
 	{0x7301, "Power calibration area almost full"},
@@ -1057,6 +1095,18 @@
 	{0x7304, "Program memory area update failure"},
 	{0x7305, "Program memory area is full"},
 	{0x7306, "RMA/PMA is almost full"},
+	{0x7310, "Current power calibration area almost full"},
+	{0x7311, "Current power calibration area is full"},
+	{0x7317, "RDZ is full"},
+
+	{0x7400, "Security error"},
+	{0x7401, "Unable to decrypt data"},
+	{0x7402, "Unencrypted data encountered while decrypting"},
+	{0x7403, "Incorrect data encryption key"},
+	{0x7404, "Cryptographic integrity validation failed"},
+	{0x7405, "Error decrypting data"},
+	{0x7471, "Logical unit access not authorized"},
+
 	{0, NULL}
 };
 

--------------040401060902020306000404--
