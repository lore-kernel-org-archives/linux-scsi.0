From: Matthew Wilcox <willy@debian.org>
Subject: [PATCH] Add SPI-5 constants to scsi.h
Date: Tue, 21 Sep 2004 12:50:59 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040921115059.GU642@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:3483 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S267587AbUIULvA
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 07:51:00 -0400
Received: from willy by www.linux.org.uk with local (Exim 4.33)
	id 1C9jAh-0007Id-CV
	for linux-scsi@vger.kernel.org; Tue, 21 Sep 2004 12:50:59 +0100
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Add the new constant names from SPI-5 to <scsi/scsi.h>

Index: linux-2.6/include/scsi/scsi.h
===================================================================
RCS file: /var/cvs/linux-2.6/include/scsi/scsi.h,v
retrieving revision 1.10
diff -u -p -r1.10 scsi.h
--- linux-2.6/include/scsi/scsi.h	13 Sep 2004 15:24:18 -0000	1.10
+++ linux-2.6/include/scsi/scsi.h	21 Sep 2004 11:48:09 -0000
@@ -246,24 +246,34 @@ struct scsi_lun {
 #define     EXTENDED_SDTR                   0x01
 #define     EXTENDED_EXTENDED_IDENTIFY      0x02    /* SCSI-I only */
 #define     EXTENDED_WDTR                   0x03
+#define     EXTENDED_PPR                    0x04
+#define     EXTENDED_MODIFY_BIDI_DATA_PTR   0x05
 #define SAVE_POINTERS       0x02
 #define RESTORE_POINTERS    0x03
 #define DISCONNECT          0x04
 #define INITIATOR_ERROR     0x05
-#define ABORT               0x06
+#define ABORT_TASK_SET      0x06		/* SPI-5 name */
+#define ABORT               ABORT_TASK_SET	/* Old name */
 #define MESSAGE_REJECT      0x07
 #define NOP                 0x08
 #define MSG_PARITY_ERROR    0x09
 #define LINKED_CMD_COMPLETE 0x0a
 #define LINKED_FLG_CMD_COMPLETE 0x0b
-#define BUS_DEVICE_RESET    0x0c
-
+#define TARGET_RESET        0x0c		/* SPI-5 name */
+#define BUS_DEVICE_RESET    TARGET_RESET	/* Old name */
+#define ABORT_TASK          0x0d
+#define CLEAR_TASK_SET      0x0e
 #define INITIATE_RECOVERY   0x0f            /* SCSI-II only */
 #define RELEASE_RECOVERY    0x10            /* SCSI-II only */
-
+#define CLEAR_ACA           0x16
+#define LOGICAL_UNIT_RESET  0x17
 #define SIMPLE_QUEUE_TAG    0x20
 #define HEAD_OF_QUEUE_TAG   0x21
 #define ORDERED_QUEUE_TAG   0x22
+#define IGNORE_WIDE_RESIDUE 0x23
+#define ACA                 0x24
+#define QAS_REQUEST         0x55
+#define IDENTIFY            0x80
 
 /*
  * Host byte codes

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
