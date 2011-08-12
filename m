From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 0/4] qla4xxx feature updates
Date: Fri, 12 Aug 2011 02:51:25 -0700
Message-ID: <1313142689-13388-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:46309
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752537Ab1HLKBR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Aug 2011 06:01:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com> 

James,

Following patches are made over scsi-misc and our ealier patchset
posted here: http://marc.info/?l=linux-scsi&m=131219494805315&w=2

Harish Zunjarrao (2):
	qla4xxx: Added restore factory defaults support using BSG
	qla4xxx: Added Get ACB support using BSG

Vikas Chaudhary (2):
	scsi: Added support for adapter and firmware reset
	qla4xxx: Added support for adapter and firmware reset

Thanks,
Vikas.

