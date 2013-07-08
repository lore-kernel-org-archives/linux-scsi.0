From: <adheer.chandravanshi@qlogic.com>
Subject: [PATCH 0/7] qla4xxx: Updates for scsi "misc" branch
Date: Mon, 8 Jul 2013 08:33:04 -0400
Message-ID: <1373286791-29659-1-git-send-email-adheer.chandravanshi@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:1387 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752374Ab3GHNBL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jul 2013 09:01:11 -0400
Received: from mail122-co9 (localhost [127.0.0.1])	by
 mail122-co9-R.bigfish.com (Postfix) with ESMTP id 6377ADA04C6	for
 <linux-scsi@vger.kernel.org>; Mon,  8 Jul 2013 13:01:10 +0000 (UTC)
Received: from CO9EHSMHS005.bigfish.com (unknown [10.236.132.239])	by
 mail122-co9.bigfish.com (Postfix) with ESMTP id 6A3AFB60089	for
 <linux-scsi@vger.kernel.org>; Mon,  8 Jul 2013 13:00:45 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

From: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

James,

Please apply the following patches to the scsi tree at your earliest
convenience.

Adheer Chandravanshi (7):
	qla4xxx: Allow removal of failed session using logout.
	qla4xxx: Use discovery_parent_idx instead of discovery_parent_type
	qla4xxx: Set IPv6 traffic class if device type is IPv6.
	qla4xxx: discovery_parent_idx can be shown without any check.
	qla4xxx: Only BIOS boot target entries should be at index 0 and 1.
	qla4xxx: Export more firmware info in sysfs
	qla4xxx: Update driver version to 5.03.00-k11

Thanks,
Adheer

