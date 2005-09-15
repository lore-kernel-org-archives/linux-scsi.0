From: Jack Byer <ojbyer@usa.net>
Subject: Hardware RAID problem
Date: Thu, 15 Sep 2005 17:43:52 -0400
Message-ID: <dgcpuo$n6a$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:43245 "EHLO ciao.gmane.org")
	by vger.kernel.org with ESMTP id S965289AbVIOWVB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Sep 2005 18:21:01 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1EG260-0007kC-14
	for linux-scsi@vger.kernel.org; Fri, 16 Sep 2005 00:20:44 +0200
Received: from pcp08552403pcs.groton01.ct.comcast.net ([69.138.132.253])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Fri, 16 Sep 2005 00:20:44 +0200
Received: from ojbyer by pcp08552403pcs.groton01.ct.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Fri, 16 Sep 2005 00:20:44 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Last week, I reported a problem booting my machine with a AMI megaraid
card. This problem appeared on -mm kernels >= 2.6.12-mm1 and on
2.6.14-rc1. I tried applying a patch from Christoph Hellwig, which did
not resolve the problem.

Now I am seeing the exact same bug on a different machine, using a
different raid controller (3ware 9xxx series) when trying to install
2.6.13-mm1.

Is there any chance that this is a kernel configuration problem, or has
something recently changed in the scsi drivers that is affecting both
drivers?

