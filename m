From: Nathan Bryant <nbryant@optonline.net>
Subject: aic7xxx question
Date: Thu, 22 Jul 2004 00:03:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40FF3C86.8000604@optonline.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta6.srv.hcvlny.cv.net ([167.206.5.72]:8120 "EHLO
	mta6.srv.hcvlny.cv.net") by vger.kernel.org with ESMTP
	id S266293AbUGVEDT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jul 2004 00:03:19 -0400
Received: from optonline.net (ool-43564880.dyn.optonline.net [67.86.72.128])
 by mta6.srv.hcvlny.cv.net
 (iPlanet Messaging Server 5.2 HotFix 1.25 (built Mar  3 2004))
 with ESMTP id <0I18004JAJ9UJV@mta6.srv.hcvlny.cv.net> for
 linux-scsi@vger.kernel.org; Thu, 22 Jul 2004 00:03:31 -0400 (EDT)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Luben Tuikov <luben_tuikov@adaptec.com>


I have a quick aic7xxx question.. where is the routine that initializes 
the SCB's? I see where they are being allocated in kernel memory, but I 
need to know where/how we tell the controller what their DMA address and 
any other status bits are... that's not obvious

(Suspend/resume progress: I've fixed the storm of bus reset interrupts, 
but now I am getting a storm of NO_MATCH sequencer interrupts.)

