From: Jeff Garzik <jeff@garzik.org>
Subject: generating a Linux WWN?
Date: Thu, 27 Sep 2007 06:04:20 -0400
Message-ID: <46FB8024.8040807@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:46089 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbXI0KEY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Sep 2007 06:04:24 -0400
Received: from cpe-069-134-071-233.nc.res.rr.com ([69.134.71.233] helo=core.yyz.us)
	by mail.dvmed.net with esmtpsa (Exim 4.63 #1 (Red Hat Linux))
	id 1IaqEI-0000Y0-WF
	for linux-scsi@vger.kernel.org; Thu, 27 Sep 2007 10:04:23 +0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Is there an accepted way to generate a SAS address, when the adapter 
does not supply one (NVRAM invalid or missing, etc.)?

Unless somebody complains, I was just planning to use 
get_random_bytes().  But maybe Linux has an IEEE id we can use, to make 
the practice a bit more legitimate and avoid stomping on others?  Or an 
IEEE id specifically designed for generated-address purposes?

	Jeff



