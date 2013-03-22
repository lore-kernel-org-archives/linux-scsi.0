From: vikas.chaudhary@qlogic.com
Subject: [PATCH 0/4] qla4xxx: Patches for iSCSI flash node mgmt support
Date: Fri, 22 Mar 2013 07:41:28 -0400
Message-ID: <1363952492-16205-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:50542 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751724Ab3CVMEN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Mar 2013 08:04:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, poornima.vonti@qlogic.com, manish.rangankar@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

James,

Following patches allows iscsiadm to manage iSCSI target information
stored on adapter flash on per host basis and and perform various
operations like add, delete, login, logout, and update the target
information.

Please apply these patches to the scsi tree "misc" branch at your
earliest convenience.

Adheer Chandravanshi (3):
      scsi_transport_iscsi: Add flash node mgmt support
      libiscsi: export function iscsi_switch_str_param
      qla4xxx: Add flash node mgmt support

Vikas Chaudhary (1):
      qla4xxx: Update driver version to 5.03.00-k7

Thanks,
Vikas.
