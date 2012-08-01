From: Oliver Neukum <oliver@neukum.org>
Subject: cleanup error handling during suspend/resume of sd
Date: Wed,  1 Aug 2012 16:44:07 +0200
Message-ID: <1343832250-24228-1-git-send-email-oliver@neukum.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out002.kontent.com ([81.88.40.216]:50489 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412Ab2HAPAD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Aug 2012 11:00:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org, hare@suse.de
Cc: Oliver Neukum <oneukum@suse.de>

This series fixes an issue mostly seen with eSATA devices and
card readers. The errors don't arise on the SCSI level must
be processed and sorted for the generic code, so that issue
like recently disconnected devices don't impede system sleep.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
