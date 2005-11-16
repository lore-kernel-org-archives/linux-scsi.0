From: Jeff Garzik <jgarzik@pobox.com>
Subject: channel busy
Date: Wed, 16 Nov 2005 10:51:19 -0500
Message-ID: <437B5577.1070901@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:53684 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1030375AbVKPPv3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Nov 2005 10:51:29 -0500
Received: from cpe-069-134-188-146.nc.res.rr.com ([69.134.188.146] helo=[10.10.10.88])
	by mail.dvmed.net with esmtpsa (Exim 4.52 #1 (Red Hat Linux))
	id 1EcPZC-0004Nd-Oy
	for linux-scsi@vger.kernel.org; Wed, 16 Nov 2005 15:51:25 +0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

It would be nice if the SCSI core supported the concept of "channel 
busy".  SCSI understands host-busy and device-busy.

Right now libata allocates one scsi host per ATA port largely due to 
SCSI implementation details, and I would like to get away from that.

	Jeff


