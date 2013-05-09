From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 0/8] qla4xxx: Updates for scsi "misc" branch
Date: Thu, 9 May 2013 06:02:04 -0400
Message-ID: <1368093732-8524-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-db8lp0189.outbound.messaging.microsoft.com ([213.199.154.189]:12889
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753581Ab3EIK0s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 May 2013 06:26:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

James,

Following patches are to display additional iSCSI connection and session
parameters to sysfs as well allow setting and display of additional Network
parameter for iSCSI interface.

Please apply these patches to the scsi tree "misc" branch at your
earliest convenience.

Adheer Chandravanshi (3):
      scsi_transport_iscsi: Exporting new attrs for iscsi session and connection in sysfs
      libiscsi: Exporting new attrs for iscsi session and connection in sysfs
      qla4xxx: Exporting new attrs for iscsi session and connection in sysfs

Harish Zunjarrao (3):
      iscsi_transport: Remove net param enum numbers
      iscsi_transport: Additional parameters for net settings
      qla4xxx: Additional parameters for net settings

Manish Rangankar (1):
      qla4xxx: Add support to allow flashnode multi-session login.

Vikas Chaudhary (1):
      qla4xxx: Update driver version to 5.03.00-k10

Thanks,
Vikas.

