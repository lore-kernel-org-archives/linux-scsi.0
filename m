From: Douglas Gilbert <dougg@torque.net>
Subject: [ANNOUNCE] sdparm 0.93
Date: Fri, 03 Jun 2005 23:14:53 +1000
Message-ID: <42A057CD.7050103@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:22210 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261254AbVFCNOi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jun 2005 09:14:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

sdparm is a command line utility designed to get and set
SCSI device parameters (cf hdparm for ATA disks). Apart
from SCSI devices (e.g. disks, tapes and enclosures) sdparm
can be used on any device that uses a SCSI command set
(e.g. CD/DVD drives). sdparm also can list VPD pages including
the device identification page.

The major addition in version 0.93 is transport protocol
specific modes pages for FCP, SPI and SAS.

For more information and downloads see:
http://www.torque.net/sg/sdparm.html

ChangeLog:
http://www.torque.net/sg/p/sdparm.ChangeLog

Doug Gilbert


