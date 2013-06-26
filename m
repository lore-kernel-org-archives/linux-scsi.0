From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 0/4] qla4xxx: Updates for scsi "misc" branch
Date: Wed, 26 Jun 2013 08:11:30 -0400
Message-ID: <1372248694-3928-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:30380
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751408Ab3FZMiC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Jun 2013 08:38:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

James,

Following patches are to display additional iSCSI connection and session
parameters in sysfs.

Please apply these patches to the scsi tree "misc" branch at your
earliest convenience.

Adheer Chandravanshi (3):
      scsi_transport_iscsi: Exporting new attrs for iscsi session and connection in sysfs
      libiscsi: Exporting new attrs for iscsi session and connection in sysfs
      qla4xxx: Exporting new attrs for iscsi session and connection in sysfs

Vikas Chaudhary (1):
      qla4xxx: Update driver version to 5.03.00-k10

Thanks,
Vikas.

