From: Sean Proctor <sproctor@ccs.neu.edu>
Subject: aic7880 failure on boot
Date: Fri, 8 Nov 2002 05:47:18 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.44.0211080535180.3754-100000@denali.ccs.neu.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from denali.ccs.neu.edu (denali.ccs.neu.edu [129.10.116.200])
	by amber.ccs.neu.edu (Postfix) with ESMTP id 400A31AB12
	for <linux-scsi@vger.kernel.org>; Fri,  8 Nov 2002 05:47:18 -0500 (EST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I'm running a netfinity 7000 w/ quad pentium pros, 4 HDDs on one aic7880
controller and none on the other, and debian 3.0.  it boots fine with
debian's 2.2.20 kernel, but not their 2.4.18 kernel, nor a custom 2.4.19,
nor a custom 2.5.46 kernel (that last 3 were smp, but not the first one).
I'm going to try building a custom 2.2 kernel with smp tomorrow.  I
haven't done any kernel hacking in the past, but I would be interested in
it if someone could point me to some useful reading.

regards,
Sean

