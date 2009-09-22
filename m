From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: libiscsi and be2iscsi driver v2
Date: Tue, 22 Sep 2009 07:25:21 +0530
Message-ID: <20090922015508.GA16179@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:50737 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751190AbZIVBzE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Sep 2009 21:55:04 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

Hi

  This is a resubmission  and contains changes asked for by Mike Christie.

  These two patches contain the  modifications required to support 
  moving to pci_pools for the be2iscsi driver.

   I request you to pl consider  this for inclusion
   in the Linux Kernel.

 
  The two  patches are described below:

  [PATCH 1/2]: The changes to libiscsi and all drivers that call
		iscsi_session_setup to enable support of private
		space for use by LLD's.

  [PATCH 2/2]: The changes required by be2iscsi to support 
		pci_pools for iscsi_hdr. This version 
		i)removes cleanup loop in beiscsi_session_destroy.
		ii) Fixup for allocation failure handling in beiscsi_alloc_pdu


Thank You

Jayamohan Kallickal

Signed-off-by:  Jayamohan Kallickal <jayamohank@serverengines.com>

---

