From: Tom Szybist <tszybist@comcast.net>
Subject: Best aic79xx driver?
Date: Tue, 27 Jan 2004 15:47:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200401271547.05696.tszybist@comcast.net>
Reply-To: tszybist@comcast.net
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sccrmhc12.comcast.net ([204.127.202.56]:49089 "EHLO
	sccrmhc12.comcast.net") by vger.kernel.org with ESMTP
	id S265833AbUA0UnH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jan 2004 15:43:07 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

We are trying to settling in on using the Adaptec 29320 HBAs.

We are constrained to use Red Hat AS 2.1, with 2.4.9-e.24. The
driver included with that is 1.3.4.

This seems to not work that well.  Under I/O with many drives,
the processes go into disk wait, and never return.  No console
messages or anything. (The machine is still up and running though).

I've been testing with 2.0.5 from Justin, and that seems to
work well.  However, I noticed that only 2.0.2 is listed
on Adaptec's web page.

All things being equal, what should we go with? 2.0.5? 2.0.2?
or something else?

Thanks,

Tom

