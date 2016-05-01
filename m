From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH v2.5 0/6] scsi_debug: rebase second half of series
Date: Sat, 30 Apr 2016 22:44:41 -0400
Message-ID: <1462070687-12689-1-git-send-email-dgilbert@interlog.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:53629 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651AbcEACo4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 30 Apr 2016 22:44:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, tomas.winkler@intel.com, emilne@redhat.com, bart.vanassche@sandisk.com

Changes since original version:
  - reduce resp_report_luns to reporting 256 LUNs (0 to 255)
    using address_method=0 which is single level peripheral
    device addressing method. Reviewer would like further
    address_methods support which will be presented as a
    separate patch

Primary reason for this patch series is to add multi queue support
modelled on the null_blk driver. Incorporate REPORT LUNS patch from
Tomas Winkler sent in Febrary 2015; trim to a maximum of 256 LUNs
(0 to 255) per target. Add parameter that permits LU names to use
UUIDs (spc5r08.pdf).


The first half of this series (1 through 7) have already been applied
to the maintainers' trees. That differed slightly from my v2 series
(after 7/12 was applied). So 1/6 of this series is a resync and the
next 5 patches in this series correspond to v2 8/12 through 12/12
(give or take a little fuzz).

Douglas Gilbert (6):
  scsi_debug: use pdt constants
  scsi_debug: rework resp_report_luns
  scsi_debug: add multiple queue support
  scsi_debug: vpd and mode page work
  scsi_debug: uuid for lu name
  scsi_debug: use locally assigned naa

 drivers/scsi/scsi_debug.c | 1134 ++++++++++++++++++++++++++++-----------------
 1 file changed, 710 insertions(+), 424 deletions(-)

-- 
2.7.4

