From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH RESEND 0/2] target: target bug fix and enchancement.
Date: Thu, 25 Sep 2014 06:22:27 -0400
Message-ID: <1411640549-8013-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:41127 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752389AbaIYK4a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 06:56:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com

Hi Nicholas/Christoph,

Please apply the following patches at your earliest convenience.

Thanks,
~Saurav

Quinn Tran (1):
  Target/transport: SCSI Status Respond being sent to Initiator twice.

Saurav Kashyap (1):
  target: Implement report lun data change unit attention.

 drivers/target/target_core_fabric_configfs.c |   28 ++++++++++++++++++++++++++
 drivers/target/target_core_transport.c       |    3 +-
 2 files changed, 29 insertions(+), 2 deletions(-)

-- 
1.7.7

