From: Jeff Garzik <jgarzik@pobox.com>
Subject: 2.6 api host private area?
Date: Thu, 17 Jul 2003 14:44:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F16EE8A.20203@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:14483 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S271585AbTGQS3o
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jul 2003 14:29:44 -0400
Received: from rdu26-227-011.nc.rr.com ([66.26.227.11] helo=pobox.com)
	by www.linux.org.uk with esmtp (Exim 4.14)
	id 19dDk6-0001El-2q
	for linux-scsi@vger.kernel.org; Thu, 17 Jul 2003 19:44:38 +0100
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Where is the pointer for the scsi_host_alloc private area stored?

In the net driver subsystem, alloc_etherdev() stores this in the 
dev->priv pointer.

I see clearly that scsi_host_alloc allocates the correct size (scsi_host 
+ privsize), but it forces each LLD to duplicate nasty pointer 
arithmetic required to obtain the pointer to the private area.

	Jeff



