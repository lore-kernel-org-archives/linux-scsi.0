From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [Q] scsi_adjust_queue_depth(SDp, 0, SDp->host->cmd_per_lun); needed?
Date: Sun, 25 Jul 2004 22:09:41 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0407252205240.5555@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.de ([213.165.64.20]:8099 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S264377AbUGYUKV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 Jul 2004 16:10:21 -0400
Received: from lyakh (helo=localhost)
	by poirot.grange with local-esmtp (Exim 3.35 #1 (Debian))
	id 1BopJV-0001Sf-00
	for <linux-scsi@vger.kernel.org>; Sun, 25 Jul 2004 22:09:41 +0200
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello

A question: are calls like the one in

53c700.c::
 	NCR_700_slave_configure()
 		scsi_adjust_queue_depth(SDp, 0, SDp->host->cmd_per_lun);

really needed? Isn't the call in

scsi.c::
 	scsi_probe_and_add_lun()
 		scsi_alloc_sdev()
 			scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);

enough?

Thanks
Guennadi
---
Guennadi Liakhovetski

