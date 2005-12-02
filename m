From: lance dillon <ldillon@sk-tech.com>
Subject: cpqfc
Date: Fri, 02 Dec 2005 09:09:11 -0600
Message-ID: <1133536151.16763.6.camel@think.jsc.nasa.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from joy.jsc.nasa.gov ([139.169.137.12]:16603 "EHLO joy.jsc.nasa.gov")
	by vger.kernel.org with ESMTP id S1750781AbVLBPJU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Dec 2005 10:09:20 -0500
Received: from think.jsc.nasa.gov (think.jsc.nasa.gov [139.169.132.64])
	by joy.jsc.nasa.gov (8.11.7/8.11.3) with ESMTP id jB2FAcr09787
	for <linux-scsi@vger.kernel.org>; Fri, 2 Dec 2005 09:10:38 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

So, I got the code to successfully compile and load, but when I
rebooted, the modprobe.conf shows:

alias eth1 cpqfc


I'm just wondering why it should look like an ethernet card, unless I'm
missing something...  I thought it would look like scsi drives..

Does anybody have any ideas?

Thanks...

l

