From: Jeff Garzik <jgarzik@pobox.com>
Subject: SCSI partial completions?
Date: Thu, 08 May 2003 19:57:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EBAEEE8.6070201@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:9682 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262134AbTEHXos
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 May 2003 19:44:48 -0400
Received: from rdu26-227-011.nc.rr.com ([66.26.227.11] helo=pobox.com)
	by www.linux.org.uk with esmtp (Exim 4.14)
	id 19DvGO-0004DR-Q6
	for linux-scsi@vger.kernel.org; Fri, 09 May 2003 00:57:24 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I could have sworn I saw some code in drivers/scsi/scsi*.c that implied 
partial completions were supported.

Let's imagine that I receive a Scsi_Cmnd that wants to write N sectors. 
  Time passes, my error handler kicks in, and I realize that I was only 
able to write N/2 sectors.

How do I tell the SCSI layer that N/2 sectors were written successfully?

Thanks,

	Jeff



