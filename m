From: michaelc@cs.wisc.edu
Subject: scsi tcq fixes for 2.6.27
Date: Sun, 29 Jun 2008 01:30:24 -0500
Message-ID: <1214721027-32426-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:48094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbYF2Gac (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Jun 2008 02:30:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, promise_linux@promise.com, david.somayajulu@qlogic.com

The following patches were made over scsi-misc. They are bug fixes, but
I am not sure if they are critical enough send to linus for 2.6.26.
They fix a bug where we can send a device too much IO, because we were
setting the queue depth to the driver's can_queue. I had thought that
we could end up with IO timeouts and queue fulls, but I have not seen
any reports on the lists, so people are probably not running IO work
loads on these drivers.


