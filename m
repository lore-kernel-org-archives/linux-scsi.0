From: <adheer.chandravanshi@qlogic.com>
Subject: [PATCH V2 0/4] qla4xxx: Updates for scsi "misc" branch
Date: Fri, 18 Oct 2013 09:01:39 -0400
Message-ID: <1382101303-3420-1-git-send-email-adheer.chandravanshi@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:19761 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753922Ab3JRNde (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Oct 2013 09:33:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

From: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

James,

Following patches support setting and display of addition network
parameters for iSCSI interface.

Please apply these patches to the iscsi tree "misc" branch at your
earliest convenience.

Mike,

All the changes as per your comments are incorporated in this version
of the patch-set.


Adheer Chandravanshi (1):
  qla4xxx: Update driver version to 5.04.00-k2

Harish Zunjarrao (3):
  iscsi_transport: Remove net param enum values
  iscsi_transport: Additional parameters for network settings
  qla4xxx: Add support for additional network parameters settings

Thanks,
Adheer
