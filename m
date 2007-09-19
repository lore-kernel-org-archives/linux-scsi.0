From: Sean Bruno <sean.bruno@dsl-only.net>
Subject: qla2xxx behavior with changing volumes
Date: Tue, 18 Sep 2007 21:12:06 -0700
Message-ID: <1190175126.4408.5.camel@home-desk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iron2.pdx.net ([69.64.224.71]:57317 "EHLO iron2.pdx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835AbXISESt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Sep 2007 00:18:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

What is the expected behavior when volumes on a SAN change size and LUN
ID order?

I've noticed that if a volume changes size, leaves the SAN or changes
target ID it isn't auto-magically picked up by a 2.6.18 based
system(running CentOS 5).

If a new target appears on the SAN however, it is noticed and assigned a
new drive letter.

Sean

