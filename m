From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 0/4] qla4xxx: Added support for new ISP8042
Date: Fri, 16 Aug 2013 07:03:01 -0400
Message-ID: <1376650985-11416-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:41459 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752019Ab3HPMAL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Aug 2013 08:00:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

James,

Please apply the following patches to the scsi tree, misc branch at your
earliest convenience.

Nilesh Javali (1):
      qla4xxx: Implementation of ACB configuration during Loopback for ISP8042

Vikas Chaudhary (3):
      qla4xxx: Added support for ISP8042
      qla4xxx: Update Copyright header
      qla4xxx: Update driver version to 5.04.00-k0

Also please pull our earlier patches posted here:-
http://marc.info/?l=linux-scsi&m=137361890905745&w=2
http://marc.info/?l=linux-scsi&m=137424938121265&w=2
http://marc.info/?l=linux-scsi&m=137352460808208&w=2
http://marc.info/?l=linux-scsi&m=137455225131210&w=2


Thanks,
Vikas.
