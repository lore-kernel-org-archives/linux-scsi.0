From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [0/5]  qla2xxx: fixes for 2.6.8...
Date: Mon, 12 Jul 2004 07:04:28 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040712140428.GA6938@praka.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-01-qfe0.socal.rr.com ([66.75.162.133]:1195 "EHLO
	ms-smtp-01-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S263159AbUGLVQA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jul 2004 17:16:00 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

James,

Here's a set of patches which fix a handful of outstanding issues with
the qla2xxx driver, including the recent TCQ issues.  Please apply for
the 2.6.8 release.

All patches can be found at the following URL:

        ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.00.00b15k/

Regards,
Andrew Vasquez
QLogic Corporation


ChangeSet@1.1865, 2004-07-12 09:28:00-07:00, andrew.vasquez@apc.qlogic.com
  Fix issue where host-reset would incorrectly return a
  FAILED status.

ChangeSet@1.1866, 2004-07-12 09:30:06-07:00, andrew.vasquez@apc.qlogic.com
  Fix issue where firmware options were not properly being
  set before firmware initialization.

ChangeSet@1.1867, 2004-07-12 09:38:28-07:00, andrew.vasquez@apc.qlogic.com
  Correct usage of tag-command-queueing methods:
  
  o Properly call scsi_activate_tcq() rather than
    scsi_adjust_queue_depth().
  o Properly retrieve tag message from command via
    scsi_populate_tag_msg().

ChangeSet@1.1868, 2004-07-12 09:42:23-07:00, andrew.vasquez@apc.qlogic.com
  Fix issue where a single command could inadvertently get 
  'stuck' in the pending queue during resource availability
  failures.

ChangeSet@1.1869, 2004-07-12 09:53:48-07:00, andrew.vasquez@apc.qlogic.com
  Update version number to 8.00.00b15-k.
