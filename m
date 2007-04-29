From: Wakko Warner <wakko@animx.eu.org>
Subject: scsi0: device overrun (status a) on 0:0:0
Date: Sat, 28 Apr 2007 23:06:51 -0400
Message-ID: <20070429030651.GA4897@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from animx.eu.org ([216.98.75.249]:43311 "EHLO animx.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754532AbXD2Dgl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Apr 2007 23:36:41 -0400
Received: from wakko by animx.eu.org with local
	(Exim 4.64 #1 (Debian Bug?  What bug /\oo/\))
	id 1HhzkR-0001Hg-1g
	for linux-scsi@vger.kernel.org; Sat, 28 Apr 2007 23:06:51 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

NOTE: I am not on the list, please always keep me in CC.

Can anyone tell me what this means:
Apr 28 22:50:42 vegeta kernel: [179467.422680] scsi0: device overrun (status a) on 0:0:0
Apr 28 22:50:42 vegeta kernel: [179467.479433] scsi0: device overrun (status a) on 0:0:0
Apr 28 22:50:42 vegeta kernel: [179467.499404] scsi0: device overrun (status a) on 0:0:0
Apr 28 22:50:42 vegeta kernel: [179467.565196] scsi0: device overrun (status a) on 0:0:0
Apr 28 22:50:43 vegeta kernel: [179467.647090] scsi0: device overrun (status a) on 0:0:0

Kernel is 2.6.20.

I see this frequently in my logs/dmesg and have no clue what it really
means.  I have 2 disks that constantly give this, both are SEAGATE
ST318404LW on an onboard AIC79xx controller (MB: SuperMicro X5DA8).

I see no noticable problems or speed issues.  Kernel 2.6.17 did not show me
this error.

A grep of the source shows this line is in drivers/scsi/aic7xxx/aic79xx_osm.c
and nowhere else.

-- 
 Lab tests show that use of micro$oft causes cancer in lab animals
 Got Gas???
