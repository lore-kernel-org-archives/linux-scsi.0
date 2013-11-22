From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 0/8] qla4xxx: 5.04.00-k3: Updates for scsi "misc" branch
Date: Fri, 22 Nov 2013 05:28:16 -0500
Message-ID: <1385116104-19784-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:10242 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755388Ab3KVLBP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Nov 2013 06:01:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

James,

Please apply the following patches to the scsi tree at your earliest convenience.

These patches are on top of other qla4xxx patch posted on list here:
http://marc.info/?l=linux-scsi&m=138210321629250&w=2

Adheer Chandravanshi (4):
      scsi_transport_iscsi: Export ISCSI_PARAM_LOCAL_IPADDR attr for iscsi_connection
      libiscsi: Add local_ipaddr parameter in iscsi_conn struct
      qla4xxx: Add support for ISCSI_PARAM_LOCAL_IPADDR sysfs attr
      qla4xxx: Recreate chap data list during get chap operation

Lalit Chandivade (2):
      scsi_transport_iscsi: Add host statistics support
      qla4xxx: Add host statistics support

Vikas Chaudhary (2):
      qla4xxx: Added support for Diagnostics MBOX command
      qla4xxx: Update driver version to 5.04.00-k3

Thanks,
Vikas.
