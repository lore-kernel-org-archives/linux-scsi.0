From: Jeff Garzik <jeff@garzik.org>
Subject: ipr using libata old-EH
Date: Thu, 12 Jul 2007 15:57:07 -0400
Message-ID: <46968793.8070803@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:55426 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756314AbXGLT5K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jul 2007 15:57:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

I just noticed that ipr is still using the old reset and error handling 
methods.  Once libata-dev.git (#mv-eh, #new-eh) work is merged, ipr is 
the last driver that uses old error handling methods.  Please look into 
upgrading the driver to ->error_handler(), ->freeze(), ->thaw().

Thanks.

	Jeff


