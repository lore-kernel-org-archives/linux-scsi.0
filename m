From: Jason Van Patten <jvp@lateapex.net>
Subject: Adaptec DPT_I2O Driver in 2.6
Date: Sat, 20 Dec 2003 10:45:15 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200312201545.hBKFjFQn010471@localhost.localdomain>
Reply-To: jvp@lateapex.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from corvette.lateapex.net ([64.236.104.2]:53952 "EHLO
	localhost.localdomain") by vger.kernel.org with ESMTP
	id S264531AbTLTPpU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Dec 2003 10:45:20 -0500
Received: from localhost.localdomain (corvette [127.0.0.1])
	by localhost.localdomain (8.12.8/8.12.8) with ESMTP id hBKFjF39010473
	for <linux-scsi@vger.kernel.org>; Sat, 20 Dec 2003 10:45:15 -0500
Received: (from jvp@localhost)
	by localhost.localdomain (8.12.8/8.12.8/Submit) id hBKFjFQn010471
	for linux-scsi@vger.kernel.org; Sat, 20 Dec 2003 10:45:15 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hey folks -

I asked this question on the main kernel mailing list and got redirected
here.  In the 2.6 tree, the driver drivers/scsi/dpt_i2o.c has a #error in it
that prevents it from being compiled.  The note in the file is:

#error Please convert me to Documentation/DMA-mapping.txt

Is anyone actively working on converting this driver to 2.6?  I've
tried contacting the author, Deanna Bonds at Adaptec, but her email stopped
working.  I'm not sure if she's no longer with Adaptec, or changed her email
address so as to stop getting kernel questions. :-)

In either case, I have two boxen at home with the Adaptec SCSI RAID
controllers, and I'd like to move them from 2.4 to 2.6.  Can anyone help?

Thanks!

jas
-- 
Jason Van Patten
AOL IM: Jason VP 
