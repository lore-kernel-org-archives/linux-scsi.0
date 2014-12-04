From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH 0/4] scsi_debug: Unit Attention fixes/enhancements
Date: Thu,  4 Dec 2014 11:49:24 -0500
Message-ID: <1417711768-24167-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932343AbaLDQtc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Dec 2014 11:49:32 -0500
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sB4GnU77003352
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Thu, 4 Dec 2014 11:49:31 -0500
Received: from emilne.csb ([10.18.25.104])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id sB4GnUgC011313
	for <linux-scsi@vger.kernel.org>; Thu, 4 Dec 2014 11:49:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

This patch series fixes a couple of problems in the code to generate UAs
when "virtual_gb" is changed, and adds the generation of a UA when "max_luns"
is changed.  It also adds the generation of a UA when a WRITE BUFFER
command is issued.

Patches were generated against jejb for-next branch, with Doug Gilbert's
earlier patches applied.

Ewan D. Milne (4):
  scsi_debug: Fixed missing "break;" in SDEBUG_UA_CAPACITY_CHANGED case
  scsi_debug: Added taking of sdebug_host_list_lock when changing
    capacity
  scsi_debug: Add REPORTED LUNS DATA HAS CHANGED Unit Attention
  scsi_debug: Implement WRITE BUFFER command

 drivers/scsi/scsi_debug.c | 131 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 128 insertions(+), 3 deletions(-)

-- 
1.7.11.7

