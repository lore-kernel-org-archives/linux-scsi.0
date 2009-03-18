From: Jan Engelhardt <jengelh@medozas.de>
Subject: hdparm with USB disk
Date: Wed, 18 Mar 2009 12:29:30 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903181226530.27821@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36083 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226AbZCRL3d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Mar 2009 07:29:33 -0400
Received: from localhost (localhost [127.0.0.1])
	by sovereign.computergmbh.de (Postfix) with ESMTP id AFB6544D77C9
	for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2009 12:29:30 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,


so it happens I have to work with one of those shitty "green" devices 
again that think their power management is smarter than me. 
Unfortunately, hdparm just does not fly with USB devices, so what is the 
preferred tool here?

# hdparm -B 254 /dev/sdb

/dev/sdb:
 setting Advanced Power Management level to 0xfe (254)
 HDIO_DRIVE_CMD failed: Input/output error


