From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: RFC: Proposal for BSG Interface
Date: Wed, 17 Mar 2010 23:35:14 +0530
Message-ID: <20100317180457.GA25818@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:58949 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755286Ab0CQSFO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Mar 2010 14:05:14 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu, open-iscsi@googlegroups.com

	 This submission contains an implementation of bsg interface
that is modelled on the FC BSG interface.
 
Also, contains the modified be2iscsi driver to support this interface.

These patches are made over the latest scsi-misc tree.

Signed-off-by:  Jayamohan Kallickal <jayamohank@serverengines.com>

---

