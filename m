From: Sander van Beek - Elexis <sander@elexis.nl>
Subject: qlogic qla2312f-v2 (hp oem?)
Date: Fri, 09 Jun 2006 13:20:57 +0200
Message-ID: <7.0.1.0.0.20060609132026.025d7098@elexis.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp18.wxs.nl ([195.121.247.9]:14782 "EHLO smtp18.wxs.nl")
	by vger.kernel.org with ESMTP id S965066AbWFILTC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jun 2006 07:19:02 -0400
Received: from ws-sander.elexis.nl (ip5457f222.direct-adsl.nl [84.87.242.34])
 by smtp18.wxs.nl (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0J0L005XPBFPV9@smtp18.wxs.nl> for linux-scsi@vger.kernel.org;
 Fri, 09 Jun 2006 13:19:01 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all,

I recently got two qla2312f-v2 cards from ebay. These are dual 2gbit 
fibre channel hba's for a pci-x bus. The qlogic site says this type 
is a HP OEM card and it is not sold directly by qlogic.
I tried to get them working on a slackware 10.2 system with the 
latest stable 2.6 kernel. However, the qla2xxx driver does not see 
the card. My dmesg only shows this line:

Jun  9 11:09:27 clust1 kernel: QLogic Fibre Channel HBA Driver

This is how the card shows up in my /proc/pci:

   Bus  2, device   1, function  1:
     Class 0c04: PCI device 1077:8000 (rev 1).
       IRQ 255.
       Prefetchable 32 bit memory at 0x40000000 [0x403fffff].

Can anyone supply me with some hints what could be wrong, or what I 
should do to get them working?

With best regards,
Sander van Beek

---------------------------------------

Ing. S. van Beek
Elexis
Marketing 9
6921 RE Duiven

Tel: 	+31 (0)26 7110329
Mob: 	+31 (0)6 28395109
Fax: 	+31 (0)318 611112
Email: sander@elexis.nl
Web: 	http://www.elexis.nl

