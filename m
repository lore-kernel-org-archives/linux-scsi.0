From: "Scott T. Smith" <scott@gelatinous.com>
Subject: error handling in 2.6.x
Date: Wed, 01 Sep 2004 13:18:09 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1094069889.4883.652.camel@tinny.home.foo>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl093-129-198.sfo4.dsl.speakeasy.net ([66.93.129.198]:33184
	"EHLO localhost.localdomain") by vger.kernel.org with ESMTP
	id S267721AbUIAUSh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Sep 2004 16:18:37 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I'm modifying an error handler for a 2.6.x driver
(eh_device_reset_handler and eh_bus_reset_handler) and am wondering if I
can use semaphores... is it called from a user context, or is it called
from a "bottom half"?  Given that I see scsi_eh_%d processes on my
machine, I assume it's called from a user context, but I just wanted to
be sure first.

	Scott


