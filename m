From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: usb storage traces
Date: 04 Dec 2003 09:13:54 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1070554434.2891.32.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:47289 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S263060AbTLDQVt
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Dec 2003 11:21:49 -0500
Received: from royntex01.iomegacorp.com (unknown [147.178.90.120])
	by email.iomega.com (Postfix) with ESMTP id 55FA81D28
	for <linux-scsi@vger.kernel.org>; Thu,  4 Dec 2003 09:21:48 -0700 (MST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

> Subject: Re: usb storage traces

As before, if still now always we each launch a new thread to reply to
posts of this thread, then this thread will grow to contain only an
index of usb storage traces.

> ...

A usb storage trace kindly posted offline is:

http://marc.theaimsgroup.com/?l=linux-scsi&m=106877150809363

List: linux-scsi
Subject: Re: [usb-storage] Re: [PATCH] fix Sony USB mass storag...
Date: 2003-11-14 0:55:07

In particular we see there the MODE_SENSE (6) commands:

-i x0C -y "1A 00 00 00 0C 00"

-i xC0 -y "1A 00 08 00 C0 00
-i xC0 -y "1A 00 1C 00 C0 00"
-i xC0 -y "1A 00 3F 00 C0 00"

Pat LaVarre


