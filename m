From: "Duane Grigsby" <duane.grigsby@qlogic.com>
Subject: RE: [Suspected SPAM:##] Failover problem with HP HSV 110 storage array system
Date: Tue, 20 Apr 2004 16:45:44 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41EBA11203419D4CA8EB4C6140D8B4010102122C@AVEXCH01.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:43356 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S263716AbUDTXrC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Apr 2004 19:47:02 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: philippe.aubry3@free.fr, linux-scsi@vger.kernel.org

> Do you have any idea for this problem ?
> I think a problem during the suspend lun or 
> qla2x00_restart_queues but 
> i'm not sure.
> For this time i continue test and i hope to undrestand this.
> 
> I thank in advance for your help.
> 
> Best regards
> Philippe Aubry
> philippe.aubry3@free.fr
> 
> -
Supporting failover on the HSV110 storage is more involved than just changing the notify type to spinup. It requires logic that is not present in the 60660 driver.


