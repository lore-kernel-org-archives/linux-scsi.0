From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 0/6] qla4xxx: 5.04.00-k6: Updates for scsi "misc" branch
Date: Wed, 9 Apr 2014 21:12:23 -0400
Message-ID: <1397092349-25332-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:44776 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933779AbaDJBwP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Apr 2014 21:52:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, giridhar.malavali@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

James,

Please apply the following patches to the scsi tree at your earliest convenience.

Adheer Chandravanshi (2):
      qla4xxx: Fix smatch warning in func qla4xxx_get_ep_param
      qla4xxx: Fix smatch warning in func qla4xxx_conn_get_param

Nilesh Javali (2):
      qla4xxx: Export sysfs DDBs from DPC handler
      qla4xxx: Fix memory leak for ha->saved_acb

Tej Parkash (1):
      qla4xxx: Disable INTx interrupt for ISP82XX

Vikas Chaudhary (1):
      qla4xxx: Update driver version to 5.04.00-k6

Thanks,
Vikas.

