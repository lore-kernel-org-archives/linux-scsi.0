From: nehal@canada.com
Subject: advansys problems
Date: Mon, 30 Jun 2003 17:31:02 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200306301731.02662.nehal@canada.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:2957 "EHLO
	pd2mo3so.prod.shaw.ca") by vger.kernel.org with ESMTP
	id S264731AbTGAAQY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Jun 2003 20:16:24 -0400
Received: from pd6mr3so.prod.shaw.ca
 (pd6mr3so-qfe3.prod.shaw.ca [10.0.141.218]) by l-daemon
 (iPlanet Messaging Server 5.2 HotFix 1.16 (built May 14 2003))
 with ESMTP id <0HHB00M67LF9UV@l-daemon> for linux-scsi@vger.kernel.org; Mon,
 30 Jun 2003 18:30:45 -0600 (MDT)
Received: from pn2ml1so.prod.shaw.ca
 (pn2ml1so-qfe0.prod.shaw.ca [10.0.121.145]) by l-daemon
 (iPlanet Messaging Server 5.2 HotFix 1.16 (built May 14 2003))
 with ESMTP id <0HHB009RCLF9Z9@l-daemon> for linux-scsi@vger.kernel.org; Mon,
 30 Jun 2003 18:30:45 -0600 (MDT)
Received: from 192.168.0.111 (h24-82-78-36.vf.shawcable.net [24.82.78.36])
 by l-daemon (iPlanet Messaging Server 5.2 HotFix 1.16 (built May 14 2003))
 with ESMTP id <0HHB00FBULF88A@l-daemon> for linux-scsi@vger.kernel.org; Mon,
 30 Jun 2003 18:30:45 -0600 (MDT)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

i get this error with 2.4.21-ac4

advansys: advansys_reset: board 0: SCSI bus reset started...
advansys: advansys_reset: board 0: SCSI bus reset successful...
scsi: device set offline - not ready or command retry failed after bus reset: 
host 0 channel 0 id 0 lun 0

then it displays the 2 'advansys_reset' messages again and freezes...
i never used to get any of these problems or messages in 
kernel version 2.4.21, 

is this bug known already?

Nehal

