From: Douglas Gilbert <dougg@torque.net>
Subject: SG_IO ioctl in the 2.6 series
Date: Thu, 06 Oct 2005 20:55:43 +1000
Message-ID: <434502AF.1020609@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:16281 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1750802AbVJFKyr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Oct 2005 06:54:47 -0400
Received: from localhost (localhost [127.0.0.1])
	by borg.st.net.au (Postfix) with ESMTP id 2DF89394A5E
	for <linux-scsi@vger.kernel.org>; Thu,  6 Oct 2005 20:55:24 +1000 (EST)
Received: from [192.168.48.80] (dsl-83.25.240.220.dsl.comindico.com.au [220.240.25.83])
	by borg.st.net.au (Postfix) with ESMTP id 7F3E1394A58
	for <linux-scsi@vger.kernel.org>; Thu,  6 Oct 2005 20:55:23 +1000 (EST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I'm working on a page documenting the SG_IO ioctl in
the lk 2.6 series. this includes looking at its
different implementation (i.e. in the block layer
and in the sg driver).

It is work in progress:
http://www.torque.net/sg/sg_io.html

Feedback welcome.

Doug Gilbert
