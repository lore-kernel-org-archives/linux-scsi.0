From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH] CDC_WR
Date: 13 Nov 2003 15:47:10 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068763630.2851.56.camel@patrh9>
References: <1068479926.2313.7.camel@patrh9>
	 <1068485442.4495.25.camel@patrh9>  <1068589440.5909.33.camel@patrh9>
	 <1068762936.2851.50.camel@patrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:62346 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264455AbTKMWrp
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2003 17:47:45 -0500
Received: from royntex01.iomegacorp.com (unknown [147.178.90.120])
	by email.iomega.com (Postfix) with ESMTP id 4CCCA1A42
	for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2003 15:47:42 -0700 (MST)
In-Reply-To: <1068762936.2851.50.camel@patrh9>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Calling all MMC gurus ...

> > > Slanderous or not, also I hear:

8)

In Japanese we have:

http://pc.watch.impress.co.jp/docs/2003/0401/hitachi.htm

I'm told this says LG-Hitachi makes a drive that supports all three of
the dominant three kinds of discs: DVD-RAM and DVD-RW and DVD+RW.

In 2.6.0-test9 cdrom.ko, that drive will appear writable via mode page
x2A Capabilities by saying DVD-RAM disc could appear, no matter if the
inserted disc is DVD+RW i.e. not very rewritable-in-place.

Ouch.

Pat LaVarre


