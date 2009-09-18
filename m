From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: libiscsi and be2iscsi driver
Date: Fri, 18 Sep 2009 21:43:43 +0530
Message-ID: <20090918161324.GA7898@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:37544 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751243AbZIRQNc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Sep 2009 12:13:32 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

Hi

  These two patches contains the modifications required to support 
  moving to pci_pools for the be2iscsi driver.

   I request you to pl consider  this for inclusion
   in the Linux Kernel.

 
  The two  patches are described below:

  [PATCH 1/2]: The changes to libiscsi and all drivers that call
		iscsi_session_setup to enable support of private
		space for use by LLD's.

  [PATCH 2/2]: The changes required by be2iscsi to support 
		pci_pools for iscsi_hdr.


Thank You

Jayamohan Kallickal

Signed-off-by:  Jayamohan Kallickal <jayamohank@serverengines.com>

---

