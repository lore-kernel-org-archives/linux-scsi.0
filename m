From: Simon Kelley <simon@thekelleys.org.uk>
Subject: Is there a grand plan for FC failover?
Date: Mon, 26 Jan 2004 14:18:15 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <401521A7.5030808@thekelleys.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.sanger.ac.uk ([193.62.203.215]:29244 "EHLO
	smtp.sanger.ac.uk") by vger.kernel.org with ESMTP id S263775AbUAZORt
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jan 2004 09:17:49 -0500
Received: from thekelleys.org.uk (srk@09559vai [172.25.17.183])
	by smtp.sanger.ac.uk (8.12.8/8.12.8) with ESMTP id i0QEHlGG177923
	for <linux-scsi@vger.kernel.org>; Mon, 26 Jan 2004 14:17:48 GMT
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I see that 2.6.x kernels now have the qla2xxx driver in the mainline, 
but without the failover code.

What is the reason for that? Is there a plan provide failover facilities 
  at a higher level which will be usable with all suitable low-level 
drivers and hardware?

I'm very much in favour of using drivers which are developed in the 
kernel mainline but I have an application which needs failover so I 
might be forced back to the qlogic-distributed code.

Cheers,

Simon.

