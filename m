From: Oliver Neukum <oliver@neukum.org>
Subject: Handle errors during transitions to sleep states in sd
Date: Fri,  3 Aug 2012 14:27:36 +0200
Message-ID: <1343996861-20857-1-git-send-email-oliver@neukum.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out002.kontent.com ([81.88.40.216]:53909 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab2HCM2r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Aug 2012 08:28:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org, hare@suse.de

During transition to sleep sd can encounter errors. They must be translated
to a form the generic layer understands, so that it knows whether an error
can be ignored (eg. medium removal) should be retried (eg. BUSY)
or the transition must be aborted.

