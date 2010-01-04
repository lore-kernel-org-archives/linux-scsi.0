From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: be2iscsi: Merging multiple patches and new ones V2
Date: Tue, 5 Jan 2010 05:03:27 +0530
Message-ID: <20100104233317.GA16679@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:14215 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753854Ab0ADXdK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2010 18:33:10 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

Hi James

	I have verified compilation after applying each patch

I have redone all the patches,so, pl ignore any patches not yet
applied
 
These patches are made on your latest scsi-misc tree pulled today

The patches are

[0001/12] :	Use start cid and number of cid and icd from FW
[0002/12] :	Move freeing of resources to stop_conn
[0003/12] :	Link Wrb with next Wrb
[0004/12] :	Added opcode for ISCSI_OP_LOGOUT_RSP, ISCSI_OP_SCSI_TMFUNC_RSP
[0005/12] :	be2iscsi moved pci_set_drvdata to inside beiscsi_hba	
[0006/12] :	Use of opcode in beiscsi_alloc_pdu
[0007/12] :	This patch decides whether ack based completion is required or not
[0008/12] :	Removes the endianess change that was wrongly
       				added for data_count	
[0009/12] :	Enables async mode for mcc rings so that
       				multiple requests can be queued
[0010/12] :	Fixed a bug where LinkUP killed sessions
[0011/12] :	Fixes a bug where can_queue was not initiallized. Found by Mike Christie
[0012/12] :	Enables TEXT Request / Response processing


Thank You

Jayamohan Kallickal

Signed-off-by:  Jayamohan Kallickal <jayamohank@serverengines.com>

---

