From: Oliver Neukum <oliver@neukum.org>
Subject: Cleanup error handling for power management of sd
Date: Thu,  2 Aug 2012 12:27:03 +0200
Message-ID: <1343903227-17285-1-git-send-email-oliver@neukum.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out003.kontent.com ([81.88.40.217]:36381 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab2HBK2L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Aug 2012 06:28:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org, hare@suse.de

Errors happening while sd devices are going to sleep need
to interpreted for the generic layer. In particular errors
for unplugged devices and removed media must be ignored.
This hits mostly users of eSATA devices who unplug external
drives right before the system is supposed to go to sleep.
