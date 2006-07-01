From: Douglas Gilbert <dougg@torque.net>
Subject: additional sense codes need update
Date: Sat, 01 Jul 2006 00:54:54 -0400
Message-ID: <44A6001E.2040803@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070307030409070402070302"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:37762 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S964883AbWGAEzH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 1 Jul 2006 00:55:07 -0400
Received: from hse-london-ppp195890.sympatico.ca ([64.229.18.207] helo=[192.168.1.100])
	by pentafluge.infradead.org with esmtpsa (Exim 4.62 #1 (Red Hat Linux))
	id 1FwXVX-0006bz-PV
	for linux-scsi@vger.kernel.org; Sat, 01 Jul 2006 05:55:04 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------070307030409070402070302
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

At http://www.t10.org/lists/asc-num.txt is a list
of SCSI additional sense codes and their qualifiers
with the corresponding text messages.

Comparing the latest list at that site (2006/06/10)
with what we have in constants.c in the scsi
subsystem my program came up with the following list
of discrepancies. Probably time for an update.

Doug Gilbert


--------------070307030409070402070302
Content-Type: text/plain;
 name="asc_diff.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="asc_diff.txt"

no entry for 0,1d : ATA PASS THROUGH INFORMATION AVAILABLE
4,2 differ; ref: LOGICAL UNIT NOT READY, INITIALIZING COMMAND REQUIRED, kern: LOGICAL UNIT NOT READY, INITIALIZING CMD. REQUIRED
no entry for b,3 : WARNING - BACKGROUND SELF-TEST FAILED
no entry for b,4 : WARNING - BACKGROUND PRE-SCAN DETECTED MEDIUM ERROR
no entry for b,5 : WARNING - BACKGROUND MEDIUM SCAN DETECTED MEDIUM ERROR
no entry for c,f : DEFECTS IN ERROR WINDOW
no entry for e,3 : INVALID FIELD IN COMMAND INFORMATION UNIT
10,1 differ; ref: LOGICAL BLOCK GUARD CHECK FAILED, kern: DATA BLOCK GUARD CHECK FAILED
10,2 differ; ref: LOGICAL BLOCK APPLICATION TAG CHECK FAILED, kern: DATA BLOCK APPLICATION TAG CHECK FAILED
10,3 differ; ref: LOGICAL BLOCK REFERENCE TAG CHECK FAILED, kern: DATA BLOCK REFERENCE TAG CHECK FAILED
no entry for 11,14 : READ ERROR - LBA MARKED BAD BY APPLICATION CLIENT
no entry for 21,3 : INVALID WRITE CROSSING LAYER JUMP
no entry for 24,2 : OBSOLETE
no entry for 24,3 : OBSOLETE
26,f differ; ref: INVALID DATA-OUT BUFFER INTEGRITY CHECK VALUE, kern: INVALID DATA-OUT BUFFER INTEGRITY
no entry for 26,10 : DATA DECRYPTION KEY FAIL LIMIT REACHED
no entry for 26,11 : INCOMPLETE KEY-ASSOCIATED DATA SET
no entry for 26,12 : VENDOR SPECIFIC KEY REFERENCE NOT FOUND
no entry for 28,2 : FORMAT-LAYER MAY HAVE CHANGED
no entry for 2a,10 : TIMESTAMP CHANGED
no entry for 2a,11 : DATA ENCRYPTION PARAMETERS CHANGED BY ANOTHER I_T NEXUS
no entry for 2a,12 : DATA ENCRYPTION PARAMETERS CHANGED BY VENDOR SPECIFIC EVENT
no entry for 2a,13 : DATA ENCRYPTION KEY INSTANCE COUNTER HAS CHANGED
no entry for 2f,1 : COMMANDS CLEARED BY POWER LOSS NOTIFICATION
30,c differ; ref: WORM MEDIUM - OVERWRITE ATTEMPTED, kern: WORM MEDIUM, OVERWRITE ATTEMPTED
no entry for 30,d : WORM MEDIUM - INTEGRITY CHECK
no entry for 3f,12 : ISCSI IP ADDRESS ADDED
no entry for 3f,13 : ISCSI IP ADDRESS REMOVED
no entry for 3f,14 : ISCSI IP ADDRESS CHANGED
no entry for 40,0 : RAM FAILURE (SHOULD USE 40 NN)
no entry for 41,0 : DATA PATH FAILURE (SHOULD USE 40 NN)
no entry for 42,0 : POWER-ON OR SELF-TEST FAILURE (SHOULD USE 40 NN)
no entry for 44,71 : ATA DEVICE FAILED SET FEATURES
47,3 differ; ref: INFORMATION UNIT IUCRC ERROR DETECTED, kern: INFORMATION UNIT CRC ERROR DETECTED
no entry for 47,6 : PHY TEST FUNCTION IN PROGRESS
no entry for 53,3 : MEDIUM REMOVAL PREVENTED BY DATA TRANSFER ELEMENT
no entry for 53,4 : MEDIUM THREAD OR UNTHREAD FAILURE
no entry for 55,8 : MAXIMUM NUMBER OF SUPPLEMENTAL DECRYPTION KEYS EXCEEDED
no entry for 67,b : ATA DEVICE FEATURE NOT ENABLED
no entry for 6f,6 : INSUFFICIENT BLOCK COUNT FOR BINDING NONCE RECORDING
no entry for 6f,7 : CONFLICT IN BINDING NONCE RECORDING
no entry for 72,6 : RMZ EXTENSION IS NOT ALLOWED
no entry for 72,7 : NO MORE TEST ZONE EXTENSIONS ARE ALLOWED
no entry for 73,10 : CURRENT POWER CALIBRATION AREA ALMOST FULL
no entry for 73,11 : CURRENT POWER CALIBRATION AREA IS FULL
no entry for 73,17 : RDZ IS FULL
no entry for 74,0 : SECURITY ERROR
no entry for 74,1 : UNABLE TO DECRYPT DATA
no entry for 74,2 : UNENCRYPTED DATA ENCOUNTERED WHILE DECRYPTING
no entry for 74,3 : INCORRECT DATA ENCRYPTION KEY
no entry for 74,4 : CRYPTOGRAPHIC INTEGRITY VALIDATION FAILED
no entry for 74,5 : ERROR DECRYPTING DATA
no entry for 74,71 : LOGICAL UNIT ACCESS NOT AUTHORIZED


--------------070307030409070402070302--
