From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: be2iscsi: 4 Patches for the driver
Date: Wed, 18 Nov 2009 06:11:04 +0530
Message-ID: <20091118004049.GA10257@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:16398 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751891AbZKRAlA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2009 19:41:00 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

Hi

 I am sending four patches.

1/4 : This patch enablesi be2iscsi to use the start number and number
 of cids/icd provided by FW rather than hard coded values

2/4 : We need to hold on to ep resources untill invalidate and
  close connection are completed

3/4 : This patch will link the current allocated wrb with the next
 wrb that will be allocated. This is a requirement from the chip.

4/4 : This patch does a couple of very small, mostly
    single line changes which I feel will be an overkill to put in
    individual patches

	1) moved pci_set_drvdata to inside beiscsi_hba_alloc
	2) Enabled handling of  TEXT Response
	3) Added opcode for ISCSI_OP_LOGOUT_RSP, ISCSI_OP_SCSI_TMFUNC_RSP,
	4) Ask for ack based completion for NOOPOUT and TTT != RESERVERD
	

The patch was built on the latest tree at
git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

I request that these patches  be applied to the next release

Thanks
Jay

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
