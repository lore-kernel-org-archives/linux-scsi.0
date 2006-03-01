From: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>
Subject: [PATCH 0/9] lpfc 8.1.3: driver update (repost)
Date: Tue, 28 Feb 2006 22:33:02 -0500
Message-ID: <20060301033302.GA21417@shrimp.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shrimp.ma.emulex.com ([138.239.78.42]:20432 "EHLO
	shrimp.ma.emulex.com") by vger.kernel.org with ESMTP
	id S1750774AbWCADdE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2006 22:33:04 -0500
Received: from shrimp.ma.emulex.com (localhost.localdomain [127.0.0.1])
	by shrimp.ma.emulex.com (8.13.4/8.13.4) with ESMTP id k213X2bK021425
	for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2006 22:33:02 -0500
Received: (from jamesw@localhost)
	by shrimp.ma.emulex.com (8.13.4/8.13.4/Submit) id k213X2AE021423
	for linux-scsi@vger.kernel.org; Tue, 28 Feb 2006 22:33:02 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

James Smart is away this week so I'm covering this for him.

We're reposting the lpfc 8.1.3 patches because the earlier set had
some patch format issues that preventing them from applying.  These
are exactly the same changes as the previously posted 8.1.3, but
without the formatting issue.

This patch set updates the lpfc driver to revision 8.1.3, which includes
the following changes:

  - Derive supported speeds from LMT field in the READ_CONFIG
  - PCI hrd_type should be obtained with pci_read_config_byte() macro
  - Remove unused MBhostaddr from lpfc_sli structure
  - Fix performance when using multiple SLI rings
  - Fix deadlock in lpfc_fdmi_tmo_handler
  - Protect NPL lists with host lock
  - Fix polling mode panic
  - Adding hbaapi event support
  - Change version number to 8.1.3

- Jamie Wellnitz
