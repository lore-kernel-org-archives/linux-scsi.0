From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 0/11] iscsi bugfixes
Date: Mon, 24 Jul 2006 15:47:07 -0500
Message-ID: <1153774027.1040.31.camel@madmax>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:13248 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751432AbWGXUqs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jul 2006 16:46:48 -0400
Received: from [192.168.0.7] (c-24-118-221-159.hsd1.mn.comcast.net [24.118.221.159])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id k6OKkRxd012522
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2006 15:46:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following patches fixes some regressions and bugs we have had since
the driver was created. The bugs include:

1. Sending the wrong error values to userspace.
2. r2t list problems. We should not hit the BUG_ONs anymore.
3. Many abort fixes including handling the case where the session drops
in the middle of an abort or if a command finishes and then we get the
status.
4. Fix iser oops during session recovery.
5. More memory reduction patches. We should not be able to negotiate for
larger maxrecvdatalength values and not be limited by how much memory we
can allocate.
6. Fix id leaks
7. Fix allocation from soft irq context bug.

