From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: sg MiB writes scheduling while atomic
Date: 14 Oct 2003 17:36:58 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1066174617.3399.0.camel@patehci2>
References: <Pine.LNX.4.44L0.0309101219190.905-100000@ida.rowland.org>
	 <1063217791.3669.43.camel@patehci2> <1063219776.3669.72.camel@patehci2>
	 <1063222216.3669.87.camel@patehci2> <3F66AF1B.5010402@torque.net>
	 <20030916114238.GA21596@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:18106 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261735AbTJNXhN
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Oct 2003 19:37:13 -0400
Received: from royntex01.iomegacorp.com (unknown [147.178.90.120])
	by email.iomega.com (Postfix) with ESMTP id 4164C19ED
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2003 17:37:12 -0600 (MDT)
In-Reply-To: <20030916114238.GA21596@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

linux-2.6.0-test7 I like better.  As this thread detailed back in
mid-September, if I boot to -test4, Ctrl+C does reliably spew dmesg if
pressed during:

sg_dd of=/dev/sg0 if=/dev/zero bs=2k

-test7 with much the same .config accepts Ctrl+C without complaint.

Pat LaVarre



