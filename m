From: Jeff Garzik <jgarzik@pobox.com>
Subject: General comment on USB...
Date: Thu, 08 May 2003 16:24:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EBABCE4.4010702@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:39101 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262069AbTEHUL0
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 May 2003 16:11:26 -0400
Received: from rdu26-227-011.nc.rr.com ([66.26.227.11] helo=pobox.com)
	by www.linux.org.uk with esmtp (Exim 4.14)
	id 19Drvv-0000AA-6m
	for linux-scsi@vger.kernel.org; Thu, 08 May 2003 21:24:03 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Just some food for thought.

Many host controllers deal with special cases by filtering, or 
validating, or massaging SCSI cdb's passed to them, before queueing them 
for execution by the target.

Instead of changing the core kernel's scanning logic (or other logic) 
because of buggy USB storage devices, punt that duty to the USB storage 
core.  USB, not core SCSI, needs to know about buggy devices it will 
deal with, and work around them.

	Jeff



