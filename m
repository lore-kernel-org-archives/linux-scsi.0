From: Luben Tuikov <ltuikov@yahoo.com>
Subject: [PATCH 0/2] [SCSI] Don't overwhelm with messages when a device is unplugged
Date: Fri, 3 Nov 2006 01:16:40 -0800 (PST)
Message-ID: <665944.84253.qm@web31806.mail.mud.yahoo.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31806.mail.mud.yahoo.com ([68.142.207.69]:22658 "HELO
	web31806.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1752274AbWKCJQl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Nov 2006 04:16:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

What follows are two patches.
The first I've been carrying for a long time.
The second is recent.

We see over 2 million messages of sorts when
a device(s) is unplugged right in the middle of
heavy I/O.

"rejecting I/O to device being removed" and
"rejecting I/O to dead device"...

These are printed so many times that they cause
soft-lockup on all 4 CPUs in succession!...

The following patches remedy this sad situation.

    Luben

