From: Jeff Garzik <jgarzik@pobox.com>
Subject: RFC: move hosts.h, scsi.h
Date: Thu, 22 May 2003 16:34:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3ECD346D.2070302@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:23440 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S263206AbTEVUWL
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 May 2003 16:22:11 -0400
Received: from rdu26-227-011.nc.rr.com ([66.26.227.11] helo=pobox.com)
	by www.linux.org.uk with esmtp (Exim 4.14)
	id 19IwmQ-0005VW-SL
	for linux-scsi@vger.kernel.org; Thu, 22 May 2003 21:35:15 +0100
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

I request permission to do the following:

1) bk mv drivers/scsi/scsi.h include/linux
2) bk mv drivers/scsi/hosts.h include/linux/scsi_hosts.h
3) bk mv drivers/scsi/scsi_obsolete.h include/linux
4) create shell drivers/scsi/{...}.h that includes just-moved files, so 
to preserve full driver source compatibility.
5) edit include/linux/scsi.h to include <linux/scsi_obsolete.h> not 
"scsi_obsolete.h"

Objections/comments?

