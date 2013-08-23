From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 0/4] qla4xxx: Misc Fixes in minidump
Date: Fri, 23 Aug 2013 03:40:17 -0400
Message-ID: <1377243621-32107-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:45308 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754978Ab3HWIJa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Aug 2013 04:09:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

James,

Please apply the following patches to the scsi tree, misc branch at your
earliest convenience.

These patches are on top of our earlier patchset:-
http://marc.info/?l=linux-scsi&m=137665441602732&w=2

Santosh Vernekar (2):
      qla4xxx: Add pex-dma support for capturing minidump
      qla4xxx: Fix the minidump data collection check in for loop

Vikas Chaudhary (2):
      qla4xxx: Return error if minidump data collection fails
      qla4xxx: Update driver version to 5.04.00-k1

Thanks,
Vikas.
