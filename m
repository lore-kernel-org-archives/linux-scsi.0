From: Meelis Roos <mroos@linux.ee>
Subject: lpfc warnings on sparc64
Date: Thu, 25 Sep 2008 11:14:47 +0300 (EEST)
Message-ID: <Pine.SOC.4.64.0809251006540.6342@math.ut.ee>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:41667 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364AbYIYIOt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2008 04:14:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com
Cc: linux-scsi@vger.kernel.org

Noticed this wgile compiling 2.6.27-rc7+git on sparc64 - maybe it is of 
interest.

  CC [M]  drivers/scsi/lpfc/lpfc_sli.o
drivers/scsi/lpfc/lpfc_sli.c: In function 'lpfc_sli_poll_fcp_ring':
drivers/scsi/lpfc/lpfc_sli.c:1365: warning: array subscript is above array bounds
drivers/scsi/lpfc/lpfc_sli.c:1365: warning: array subscript is above array bounds
drivers/scsi/lpfc/lpfc_sli.c: In function 'lpfc_sli_handle_fast_ring_event':
drivers/scsi/lpfc/lpfc_sli.c:1541: warning: array subscript is above array bounds
drivers/scsi/lpfc/lpfc_sli.c:1541: warning: array subscript is above array bounds

-- 
Meelis Roos (mroos@linux.ee)
