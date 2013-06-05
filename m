From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/10] qla2xxx: Reduce the number of Coverity warnings
Date: Wed, 05 Jun 2013 15:01:51 +0200
Message-ID: <51AF36BF.3030602@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:59661 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab3FENBy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jun 2013 09:01:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Chad Dupuis <chad.dupuis@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>

The current implementation of the qla2xxx Fibre Channel initiator driver 
triggers multiple warnings when analyzed with the Coverity static 
analyzer. This patch series addresses a significant number of these 
warnings.

Note: patch 10/10 of this series is a reworked version of a patch that 
had been posted a few weeks ago on the linux-scsi mailing list.
