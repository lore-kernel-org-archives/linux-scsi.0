From: James.Smart@Emulex.Com
Subject: [PATCH 0/15]  lpfc 8.1.0 driver updates
Date: Fri, 28 Oct 2005 20:28:47 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276A4F@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:58064 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1750846AbVJ2A25 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Oct 2005 20:28:57 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id j9T0SnDp018478
	for <linux-scsi@vger.kernel.org>; Fri, 28 Oct 2005 17:28:50 -0700 (PDT)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following patch set revises our driver to rev 8.1.0.  The patches
are based on the current scsi-misc-2.6 git tree, but the lpfc sources should
be roughly the same in the other reset git trees. This patch *DOES* expect
that the previous fc transport patch has been applied. See:
    http://marc.theaimsgroup.com/?l=linux-scsi&m=112965152011520&w=2

Summary of patches:
- Cleanup code in lpfc_get_stats().
- Update to Emulex hba model names
- Return -EINVAL, -EPERM, and -EIO  instead of 0 from sysfs callbacks
- Add range checking for attributes passed as options at load time.
- Fix comments for nodev_tmo
- Fix for "Unknown IOCB command Data: x0 x3 x0 x0" messages
- Restore HEX safe bahavior of the sysfs xxx_store functions.
- Remove RPI hash from the driver.
- Fix for "command completion for iotax x?? not found" messages
- Replace lpfc_sli_issue_iocb_wait_high_priority with lpfc_sli_issue_iocb_wait.
- Adjust lpfc_scsi_buf allocation to account for lun_queue_depth and
  error handling
- Remove unneeded IOCB_t * cast from lpfc_sli_handle_fast_ring_event
- Return FAILED from eh_ routines if command(s) is(are) not completed
- Add owner field to struct pci_driver
- Change version number to 8.1.0


Thanks

-- james s
