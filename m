From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: be2iscsi: Merging multiple patches and new ones
Date: Fri, 4 Dec 2009 08:46:26 +0530
Message-ID: <20091204031614.GA5947@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:6441 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751728AbZLDDQO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Dec 2009 22:16:14 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

Hi James

    There are multiple patches from me that are floating around and Mike
had wanted me to submit individual patches for every issue.

I have gone ahead and redone all the patches and added some more fixes/features.
So, pl ignore all my previous patches that have not been applied yet.
 
These patches are made on your latest scsi-misc tree pulled today

The patches are

[0001/15] :	Usei start cid and number of cid and icd from FW
[0002/15] :	Move freeing of resources to stop_conn
[0003/15] :	Link Wrb with next Wrb
[0004/15] :	Added opcode for ISCSI_OP_LOGOUT_RSP, ISCSI_OP_SCSI_TMFUNC_RSP
[0005/15] :	be2iscsi moved pci_set_drvdata to inside beiscsi_hba	
[0006/15] :	Use of opcode in beiscsi_alloc_pdu
[0007/15] :	This patch decides whether ack based completion is required or not
[0008/15] :	removes the endianess change that was wrongly
				added for data_count	
[0009/15] :	removes index from alloc_wrb_index
[0010/15] :	Enables support for TEXT RESPONSE processing
[0011/15] :	enables async mode for mcc rings so that
				multiple requests can be queued
[0012/15] :	Fixed a bug where LinUP killed sessions
[0013/15] :	Removed BUG_ON from Async Notifications from the chip
[0014/15] :	Fixes a bug where can_queue was not initiallized. Found by Mike Christie
[0015/15] :	Enables TEXT Request / Response processing


Thank You

Jayamohan Kallickal

Signed-off-by:  Jayamohan Kallickal <jayamohank@serverengines.com>

---

